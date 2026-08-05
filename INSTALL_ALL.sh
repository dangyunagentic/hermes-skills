#!/bin/bash
# ============================================================
# Hermes Skills — All-In-One Installer v2 (2026-08-05)
# Backup: github.com/dangyunagentic/hermes-skills
#
# Fixes from v1:
#  - GuardX vendored locally (vendors/guardx.zip) — no external repo dep
#  - Go tools installed one-by-one (amass multi-module fix)
#  - Skills deploy to ~/.hermes/skills (auto-mirrors profile dir too)
#
# Usage: bash ./INSTALL_ALL.sh [--yes] [--skip-heavy]
#   --yes        non-interactive, install everything
#   --skip-heavy skip Ghidra + RE frameworks (angr/frida/etc)
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

echo "=========================================="
echo " Hermes Skills Security Suite v2"
echo " All-in-one installer"
echo " Updated: 2026-08-05 (Autumn)"
echo "=========================================="

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------- Step 1: Python check ----------
python3 --version > /dev/null 2>&1 || { echo "Python 3 required"; exit 1; }
echo "Python: $(python3 --version)"

# ---------- Step 2: Deploy skills ----------
echo ""
echo "Deploying skills..."
SKILLS_TARGETS=("$HOME/.hermes/skills")
if [ -d "$HOME/.hermes/profiles/default" ]; then
    SKILLS_TARGETS+=("$HOME/.hermes/profiles/default/skills")
fi

SKILL_COUNT=$(find "$REPO_DIR/skills" -name "SKILL.md" | wc -l)
for target in "${SKILLS_TARGETS[@]}"; do
    mkdir -p "$target"
    cp -r "$REPO_DIR/skills/"* "$target/" 2>/dev/null || true
    echo "   Deployed $SKILL_COUNT skills -> $target"
done

# ---------- Step 3: System packages ----------
echo ""
echo "Installing system packages (radare2, gdb, binwalk...)..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq radare2 gdb binutils binwalk strace ltrace file wget curl unzip 2>/dev/null \
        && echo "Core RE tools installed" || echo "Some packages failed (continue anyway)"
else
    echo "apt not found - install manually: radare2 gdb binwalk strace ltrace"
fi

# ---------- Step 4: JDK (JADX/Apktool/Ghidra need it) ----------
echo ""
if ! java -version &> /dev/null; then
    echo "Installing JDK 21..."
    sudo apt-get install -y -qq openjdk-21-jdk-headless 2>/dev/null && echo "JDK 21 installed" || echo "JDK failed"
else
    echo "JDK available: $(java -version 2>&1 | head -1)"
fi

# ---------- Step 5: GuardX (VENDORED — no external repo!) ----------
echo ""
echo "Installing GuardX toolkit (vendored)..."
GUARDX_DIR="$HOME/tools/guardx"
mkdir -p "$GUARDX_DIR"
if [ -f "$REPO_DIR/vendors/guardx.zip" ]; then
    unzip -oq "$REPO_DIR/vendors/guardx.zip" -d "$GUARDX_DIR"
    pip3 install --break-system-packages -r "$GUARDX_DIR/guardx/requirements.txt" aiodns 2>/dev/null \
        && echo "GuardX deployed -> $GUARDX_DIR/guardx" || echo "GuardX deps partial"
else
    echo "vendors/guardx.zip not found in repo"
fi

# ---------- Step 6: Python RE frameworks ----------
if ! $SKIP_HEAVY; then
    echo ""
    echo "Installing Python RE frameworks (angr, frida, capstone...)..."
    pip3 install --break-system-packages angr unicorn capstone frida frida-tools pwntools \
        browserforge fpgen 2>/dev/null \
        && echo "RE frameworks installed" || echo "Some frameworks failed"
    fpgen fetch 2>/dev/null && echo "fpgen model downloaded" || true
fi

# ---------- Step 7: Go + bug bounty tools (ONE BY ONE — multi-module fix) ----------
echo ""
if ! command -v go &> /dev/null && [ ! -x /usr/local/go/bin/go ]; then
    echo "Installing Go..."
    GOVER=$(curl -s https://go.dev/VERSION?m=text | head -1)
    wget -q "https://go.dev/dl/${GOVER}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz && rm /tmp/go.tar.gz
fi
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
echo "Go: $(go version 2>/dev/null || echo 'check PATH')"

echo "Installing bug bounty tools (one by one)..."
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
echo "Go tools installed -> ~/go/bin"
grep -q 'go/bin' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"

# ---------- Step 8: JADX + Apktool ----------
echo ""
echo "Installing JADX v1.5.6..."
if ! command -v jadx &> /dev/null; then
    sudo mkdir -p /opt/jadx && cd /opt/jadx
    sudo wget -q https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip -O /tmp/jadx.zip
    sudo unzip -oq /tmp/jadx.zip && sudo chmod +x /opt/jadx/bin/jadx /opt/jadx/bin/jadx-gui
    sudo ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
    sudo ln -sf /opt/jadx/bin/jadx-gui /usr/local/bin/jadx-gui
    rm /tmp/jadx.zip && cd "$REPO_DIR"
    echo "JADX: $(jadx --version)"
else
    echo "JADX already installed"
fi

echo "Installing Apktool v2.9.3..."
if ! command -v apktool &> /dev/null; then
    sudo mkdir -p /opt/apktool
    sudo wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar -O /opt/apktool/apktool.jar
    sudo tee /usr/local/bin/apktool > /dev/null << 'APKEOF'
#!/bin/bash
exec java -jar /opt/apktool/apktool.jar "$@"
APKEOF
    sudo chmod +x /usr/local/bin/apktool
    echo "Apktool: $(apktool --version)"
else
    echo "Apktool already installed"
fi

# ---------- Step 9: Ghidra (heavy, optional) ----------
if ! $SKIP_HEAVY; then
    echo ""
    if ! command -v ghidra &> /dev/null && [ ! -d /opt/ghidra_12.1.2_PUBLIC ]; then
        if confirm "Install Ghidra 12.1.2 (547MB download)?"; then
            echo "Downloading Ghidra 12.1.2..."
            curl -L -s "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.2_build/ghidra_12.1.2_PUBLIC_20260605.zip" -o /tmp/ghidra.zip
            cd /opt && sudo unzip -oq /tmp/ghidra.zip
            sudo ln -sf /opt/ghidra_12.1.2_PUBLIC/support/analyzeHeadless /usr/local/bin/ghidra-headless
            sudo ln -sf /opt/ghidra_12.1.2_PUBLIC/ghidraRun /usr/local/bin/ghidra
            rm /tmp/ghidra.zip && cd "$REPO_DIR"
            echo "Ghidra 12.1.2 installed"
        else
            echo "Skipping Ghidra"
        fi
    else
        echo "Ghidra already installed"
    fi
fi

# ---------- Step 10: Environment ----------
echo ""
echo "Configuring environment..."
ENV_FILE="$HOME/.hermes.env"
if [ ! -f "$ENV_FILE" ]; then
cat > "$ENV_FILE" << 'ENVEOF'
# Hermes Skills Environment Configuration
# Offensive Security Toolkit
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
    echo "Environment configured -> $ENV_FILE"
else
    echo "$ENV_FILE already exists"
fi

# ---------- Summary ----------
echo ""
echo "=========================================="
echo " INSTALLATION COMPLETE!"
echo "=========================================="
echo " Skills deployed:      $SKILL_COUNT"
echo " GuardX:               $HOME/tools/guardx/guardx (vendored)"
echo " Go tools:             ~/go/bin (nuclei, subfinder, httpx, katana, amass)"
echo " JADX/Apktool:         /usr/local/bin"
echo " Environment:          ~/.hermes.env"
echo ""
echo "Next: source ~/.bashrc"
echo "=========================================="
