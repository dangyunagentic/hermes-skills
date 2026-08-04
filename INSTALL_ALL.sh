#!/bin/bash
# Hermes Skills - Complete Installation Script (Updated 2024-08-04)
# Install all skills, GuardX Hybrid, RECore, and configure environment
# Run from repository root directory

set -e

echo "=========================================="
echo "🛡️  Hermes Skills Security Suite"
echo "   Professional Offensive Security Tools"
echo "   Updated: 2024-08-04 (GuardX + RECore)"
echo "=========================================="
echo ""

# Check prerequisites
echo "🔍 Checking system requirements..."
python3 --version > /dev/null 2>&1 || { echo "❌ Python 3 required"; exit 1; }

echo "✅ Python: $(python3 --version)"
echo ""

# Step 1: Install system dependencies (apt)
echo "📦 Installing system dependencies..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq
    
    # Core RE tools
    sudo apt-get install -y -qq \
        radare2 gdb binutils binutils binwalk strace ltrace file wget curl 2>/dev/null && \
        echo "✅ System tools installed: r2, gdb, binwalk, strings, readelf, strace, ltrace"
    
    # Java for JADX/Apktool
    if ! java -version &> /dev/null; then
        sudo apt-get install -y -qq openjdk-17-jdk-headless 2>/dev/null && \
            echo "✅ JDK installed for JADX/Apktool"
    else
        echo "✅ JDK already available"
    fi
else
    echo "⚠️  APT not found, skipping system dependencies"
fi
echo ""

# Step 2: Deploy skills to Hermes profile
echo "📦 Deploying skills to Hermes profile..."
if [ ! -d "~/.hermes/profiles/default/skills" ]; then
    mkdir -p ~/.hermes/profiles/default/skills
fi

# Copy all skills including new ones
cp -r skills ~/.hermes/profiles/default/
cp -r memories ~/.hermes/profiles/default/ 2>/dev/null || true

chmod +x ~/.hermes/profiles/default/skills/*.sh 2>/dev/null || true
echo "✅ Skills deployed successfully!"
echo "   New additions: guardx/, recore/"
echo ""

# Step 3: Install Python packages
echo "🐍 Installing Python packages..."

# GuardX dependencies
pip3 install --break-system-packages \
    requests cloudscraper aiohttp PyYAML fpdf cryptography 2>/dev/null && \
    echo "✅ GuardX dependencies installed" || \
    echo "⚠️  Some Python packages may need manual installation"

# RECore dependencies (optional)
read -p "Install advanced RE frameworks (angr, unicorn, capstone)? (y/n): " install_re_frameworks
if [[ $install_re_frameworks =~ ^[Yy]$ ]]; then
    pip3 install --break-system-packages angr unicorn capstone frida frida-tools 2>/dev/null && \
        echo "✅ Advanced RE frameworks installed" || \
        echo "⚠️  Framework installation had issues (can be done manually later)"
fi
echo ""

# Step 4: Download JADX & Apktool (manual step - provide commands)
echo "📥 APK Tools Setup:"
echo "   JADX v1.5.6 & Apktool v2.9.3 need manual install"
echo ""
echo "   Option 1: Quick install via scripts:"
echo "   cd ~/tools && wget https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip"
echo "   unzip jadx-1.5.6.zip -d jadx && chmod +x jadx/bin/* && sudo cp jadx/bin/* /usr/local/bin/"
echo ""
echo "   Option 2: Install apktool:"
echo "   wget https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar"
echo "   echo '#!/bin/bash' > /usr/local/bin/apktool && echo 'exec java -jar /opt/apktool.jar \"\$@\"' >> /usr/local/bin/apktool"
echo "   chmod +x /usr/local/bin/apktool"
echo ""
echo "   After installing, verify: jadx --version && apktool --version"
echo ""

# Step 5: Create quick-start scripts
echo "🚀 Creating quick-start scripts..."

cat > ~/.hermes/profiles/default/skills/bb-quickstart.sh << 'EOF'
#!/bin/bash
# Bug Bounty Quick Start Guide
export PATH=$PATH:/usr/local/go/bin:~/go/bin

case $1 in
    recon)
        domain=$2
        echo "🔍 Starting reconnaissance on $domain..."
        subfinder -d $domain -o subdomains.txt 2>/dev/null || echo "⚠️  Subfinder not installed"
        amass enum -d $domain -o amass.txt 2>/dev/null || echo "⚠️  Amass not installed"
        cat subdomains.txt amass.txt 2>/dev/null | sort -u > all-subdomains.txt
        echo "✅ Recon complete! Found $(wc -l < all-subdomains.txt 2>/dev/null || echo 0) unique subdomains"
        ;;
    
    scan)
        domain=$2
        echo "🔬 Running vulnerability scan on $domain..."
        nuclei -u http://$domain -automatic-scan -o nuclei-results.json -jsonl 2>/dev/null || echo "⚠️  Nuclei not installed"
        echo "✅ Scan complete! Findings saved to nuclei-results.json"
        ;;
    
    help|--help|-h)
        echo "Bug Bounty Quick Start Commands:"
        echo "  bb-quickstart.sh recon [domain]     - Run reconnaissance"
        echo "  bb-quickstart.sh scan [domain]      - Run vulnerability scan"
        ;;
    
    *)
        echo "Usage: $0 [recon|scan|help] [domain]"
        echo "Available commands: recon, scan, help"
        ;;
esac
EOF

cat > ~/.hermes/profiles/default/skills/guardx-quickstart.sh << 'EOF'
#!/bin/bash
# GuardX Quick Start — Web Vuln + Exploit
export HERMES_SKILLS_DIR=~/.hermes/profiles/default

cd $HERMES_SKILLS_DIR/guardx

case $1 in
    scan)
        target=$2
        if [ -z "$target" ]; then
            echo "Usage: guardx-quickstart.sh scan <target.com>"
            exit 1
        fi
        echo "🛡️  Scanning $target for CVEs..."
        python3 guardv2.py $target --scan-cve
        ;;
    
    exploit)
        target=$2
        vuln=$3
        if [ -z "$target" ]; then
            echo "Usage: guardx-quickstart.sh exploit <target.com> [vuln_name]"
            exit 1
        fi
        echo "💥 Exploiting $target..."
        [ -n "$vuln" ] && ARGS="--vuln $vuln" || ARGS=""
        python3 guardx.py $target $ARGS
        ;;
    
    re)
        binary=$2
        if [ -z "$binary" ]; then
            echo "Usage: guardx-quickstart.sh re <binary_path>"
            exit 1
        fi
        echo "🔧 Analyzing binary with RECore..."
        python3 -c "
import sys
sys.path.insert(0, '$HERMES_SKILLS_DIR')
from skills.recore import recore
info = recore.get_binary_info('$binary')
print(f'Size: {info[\"size_bytes\"]} bytes')
print(f'MD5:  {info[\"md5\"]}')
strings = recore.extract_strings('$binary', min_length=6)
print(f'Strings found: {strings[\"count\"]}')
"
        ;;
    
    list|list-exploits)
        echo "📋 Available exploits:"
        python3 guardx.py --list | head -50
        ;;
    
    validate)
        echo "✅ Validating GuardX + RECore..."
        python3 $HERMES_SKILLS_DIR/final_validation.py
        ;;
    
    help|--help|-h)
        echo "GuardX Quick Start Commands:"
        echo "  guardx-quickstart.sh scan <target>   - Vulnerability scan"
        echo "  guardx-quickstart.sh exploit <target> [vuln] - Auto-exploit"
        echo "  guardx-quickstart.sh re <binary>     - RE analysis"
        echo "  guardx-quickstart.sh list            - List exploits"
        echo "  guardx-quickstart.sh validate        - Test installation"
        echo "  guardx-quickstart.sh help            - This help"
        ;;
    
    *)
        echo "Usage: $0 [scan|exploit|re|list|validate|help] [args...]"
        ;;
esac
EOF

chmod +x ~/.hermes/profiles/default/skills/bb-quickstart.sh
chmod +x ~/.hermes/profiles/default/skills/guardx-quickstart.sh
echo "✅ Quick-start scripts created!"
echo "   - bb-quickstart.sh      : Bug bounty tools"
echo "   - guardx-quickstart.sh  : GuardX + RECore operations"
echo ""

# Step 6: Setup environment file
echo "🔧 Setting up environment configuration..."
cat > ~/.hermes.env << 'EOF'
# Hermes Skills Environment Configuration
export PATH=$PATH:/usr/local/go/bin:~/go/bin
export HERMES_SKILLS_DIR=~/.hermes/profiles/default/skills
export HERMES_MEMORIES_DIR=~/.hermes/profiles/default/memories
export SOURCE_REPOS_DIR=~/tools/source-repos
export FPGEN_SERVER_URL=http://127.0.0.1:8800
export WORDLISTS_DIR=/usr/share/wordlists
export GUARDX_ENABLED=true
export RECORE_ENABLED=true
EOF

echo 'source ~/.hermes.env' >> ~/.bashrc
source ~/.hermes.env
echo "✅ Environment configured!"
echo ""

# Step 7: Build FPGen Golang server (existing feature)
echo "🔨 Building FPGen Golang server..."
export PATH=$PATH:/usr/local/go/bin

if [ -d "source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator" ]; then
    cd source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator
    
    if [ ! -f "go.mod" ]; then
        cd ../../../..
        git clone --depth 1 https://github.com/dhikadrian/fp-gen source-repos/FPGen-dhikadrian/fp-gen 2>/dev/null || true
        cd FPGen-dhikadrian/fingerprint-data/fingerprint-generator
    fi
    
    go build -o ~/bin/fp-server ./cmd/server/ 2>/dev/null && \
        echo "✅ FPGen server built successfully!" || \
        echo "⚠️  FPGen build skipped or already exists"
    
    cd ../../../../../../
else
    echo "⚠️  FPGen source repo not found. Clone first:"
    echo "   git clone https://github.com/dhikadrian/fp-gen source-repos/FPGen-dhikadrian/"
fi
echo ""

# Step 8: Summary
echo "=========================================="
echo "✨ INSTALLATION COMPLETE!"
echo "=========================================="
echo ""
echo "Installed Components:"
echo "✅ Core skills: $(ls ~/.hermes/profiles/default/skills/*.md 2>/dev/null | wc -l) documentation files"
echo "✅ Memories: $(ls ~/.hermes/profiles/default/memories/*.md 2>/dev/null | wc -l) installation logs"
echo "✅ Quick-start scripts: Ready at ~/.hermes/profiles/default/skills/"
echo "✅ GuardX: Web vuln scanning + exploitation + RE bridge"
echo "✅ RECore: Reverse engineering tools (radare2, Frida, JADX ready)"
[ -f ~/bin/fp-server ] && echo "✅ FPGen Server: Built and ready at ~/bin/fp-server"
echo "✅ Environment: Configured at ~/.hermes.env"
echo ""
echo "Next Steps:"
echo "1. Source your shell: source ~/.bashrc"
echo "2. Install JADX/Apktool (see above)"
echo "3. Start FPGen server: ~/bin/fp-server --port 8800 &"
echo "4. Test bug bounty: bb-quickstart.sh help"
echo "5. Test GuardX: guardx-quickstart.sh validate"
echo "6. Read docs: cat ~/.hermes/profiles/default/skills/README.md"
echo ""
echo "Quick Commands:"
echo "  guardx-quickstart.sh scan example.com    # CVE scan"
echo "  guardx-quickstart.sh exploit site.com wp2shell  # Exploit WordPress"
echo "  guardx-quickstart.sh re /path/to/binary  # RE analysis"
echo ""
echo "⚠️  LEGAL DISCLAIMER:"
echo "   Use these tools ONLY on authorized systems with written consent."
echo "   Unauthorized scanning is illegal and can result in criminal charges."
echo ""
echo "For full documentation, see README.md in this repository."
echo "=========================================="
