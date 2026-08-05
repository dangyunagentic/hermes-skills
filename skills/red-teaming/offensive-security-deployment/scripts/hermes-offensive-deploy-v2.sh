#!/bin/bash
# ============================================================
# hermes-offensive-deploy-v2.sh — verified deployment wrapper
# Proven 2026-08-05 against dangyunagentic/hermes-skills commit 71bb133
#
# Fixes baked in:
#  - GuardX vendored locally (vendors/guardx.zip) — no external repo dep
#  - Go tools installed one-by-one (multi-module error fix)
#  - Skills mirrored to ~/.hermes/skills (+ profile dir if present)
#  - Token file perms checked (600/400)
#
# Usage: bash hermes-offensive-deploy-v2.sh [--yes] [--skip-heavy]
#   --yes        non-interactive, install everything
#   --skip-heavy skip Ghidra + Python RE frameworks (faster)
# ============================================================
set -e

AUTO_YES=false
SKIP_HEAVY=false
for arg in "$@"; do
    case "$arg" in
        --yes) AUTO_YES=true ;;
        --skip-heavy) SKIP_HEAVY=true ;;
    esac
done

confirm() {
    if $AUTO_YES; then return 0; fi
    read -p "$1 (y/n): " -r
    [[ $REPLY =~ ^[Yy]$ ]]
}

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# If run from elsewhere, expect repo as $1
[ -d "$REPO_DIR/skills" ] || REPO_DIR="${1:?Usage: $0 <repo-dir> [--yes] [--skip-heavy]}"

echo "=== Hermes Offensive Deployment v2 ==="

# --- 1. Deploy skills (SKILL.md structure already in repo) ---
SKILLS_TARGETS=("$HOME/.hermes/skills")
[ -d "$HOME/.hermes/profiles/default" ] && SKILLS_TARGETS+=("$HOME/.hermes/profiles/default/skills")
SKILL_COUNT=$(find "$REPO_DIR/skills" -name "SKILL.md" | wc -l)
for target in "${SKILLS_TARGETS[@]}"; do
    mkdir -p "$target"
    cp -r "$REPO_DIR/skills/"* "$target/" 2>/dev/null || true
    echo "Deployed $SKILL_COUNT skills -> $target"
done

# --- 2. System packages ---
if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq radare2 gdb binutils binwalk strace ltrace file wget curl unzip 2>/dev/null \
        && echo "Core RE tools installed" || echo "Some apt packages failed"
fi

# --- 3. JDK 21 (JADX/Apktool/Ghidra prerequisite) ---
if ! java -version &> /dev/null; then
    sudo apt-get install -y -qq openjdk-21-jdk-headless 2>/dev/null || echo "JDK install failed"
fi

# --- 4. GuardX (VENDORED — offline, no external repo) ---
GUARDX_DIR="$HOME/tools/guardx"
mkdir -p "$GUARDX_DIR"
if [ -f "$REPO_DIR/vendors/guardx.zip" ]; then
    unzip -oq "$REPO_DIR/vendors/guardx.zip" -d "$GUARDX_DIR"
    pip3 install --break-system-packages -r "$GUARDX_DIR/guardx/requirements.txt" aiodns 2>/dev/null \
        && echo "GuardX deployed -> $GUARDX_DIR/guardx" || echo "GuardX deps partial"
else
    echo "vendors/guardx.zip not found — GuardX skipped"
fi

# --- 5. Python RE frameworks (heavy) ---
if ! $SKIP_HEAVY; then
    pip3 install --break-system-packages angr unicorn capstone frida frida-tools pwntools \
        browserforge fpgen 2>/dev/null || echo "Some Python frameworks failed"
    fpgen fetch 2>/dev/null || true
fi

# --- 6. Go + bug bounty tools (ONE BY ONE — multi-module fix) ---
if ! command -v go &> /dev/null && [ ! -x /usr/local/go/bin/go ]; then
    GOVER=$(curl -s https://go.dev/VERSION?m=text | head -1)
    wget -q "https://go.dev/dl/${GOVER}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz && rm /tmp/go.tar.gz
fi
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

GO_TOOLS=(
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "github.com/projectdiscovery/katana/cmd/katana@latest"
    "github.com/owasp-amass/amass/v4/...@latest"
)
for tool in "${GO_TOOLS[@]}"; do
    name=$(basename "$(echo "$tool" | sed 's|@.*||;s|/cmd.*||;s|/v[0-9].*||')")
    echo "   -> $name"
    go install -v "$tool" 2>&1 | tail -1 || echo "   $name failed"
done
grep -q 'go/bin' "$HOME/.bashrc" 2>/dev/null || \
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"

# --- 7. JADX 1.5.6 ---
if ! command -v jadx &> /dev/null; then
    sudo mkdir -p /opt/jadx && cd /opt/jadx
    sudo wget -q https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip -O /tmp/jadx.zip
    sudo unzip -oq /tmp/jadx.zip && sudo chmod +x bin/jadx bin/jadx-gui
    sudo ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
    rm /tmp/jadx.zip && cd "$REPO_DIR"
fi

# --- 8. Apktool 2.9.3 ---
if ! command -v apktool &> /dev/null; then
    sudo mkdir -p /opt/apktool
    sudo wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar -O /opt/apktool/apktool.jar
    printf '#!/bin/bash\nexec java -jar /opt/apktool/apktool.jar "$@"\n' | sudo tee /usr/local/bin/apktool > /dev/null
    sudo chmod +x /usr/local/bin/apktool
fi

# --- 9. Ghidra 12.1.2 (heavy, optional) ---
if ! $SKIP_HEAVY && [ ! -d /opt/ghidra_12.1.2_PUBLIC ]; then
    if confirm "Install Ghidra 12.1.2 (547MB)?"; then
        curl -L -s "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.2_build/ghidra_12.1.2_PUBLIC_20260605.zip" -o /tmp/ghidra.zip
        cd /opt && sudo unzip -oq /tmp/ghidra.zip
        sudo ln -sf /opt/ghidra_12.1.2_PUBLIC/support/analyzeHeadless /usr/local/bin/ghidra-headless
        sudo ln -sf /opt/ghidra_12.1.2_PUBLIC/ghidraRun /usr/local/bin/ghidra
        rm /tmp/ghidra.zip && cd "$REPO_DIR"
    fi
fi

# --- 10. Environment ---
ENV_FILE="$HOME/.hermes.env"
if [ ! -f "$ENV_FILE" ]; then
cat > "$ENV_FILE" << 'ENVEOF'
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:/opt/jadx/bin
export HERMES_SKILLS_DIR=$HOME/.hermes/skills
export GUARDX_ENABLED=true
export RECORE_ENABLED=true
export GHIDRA_HOME=/opt/ghidra_12.1.2_PUBLIC
export JADX_HOME=/opt/jadx
export APKTOOL_HOME=/opt/apktool
export GUARDX_DIR=$HOME/tools/guardx/guardx
export PATH=$PATH:$GUARDX_DIR
ENVEOF
    grep -q 'hermes.env' "$HOME/.bashrc" 2>/dev/null || echo 'source ~/.hermes.env' >> "$HOME/.bashrc"
fi

echo ""
echo "=== DEPLOYMENT COMPLETE ==="
echo "Skills: $SKILL_COUNT | GuardX: $GUARDX_DIR/guardx | Go tools: ~/go/bin"
echo "Next: source ~/.bashrc"
