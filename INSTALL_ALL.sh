#!/bin/bash
# Hermes Skills - Complete Installation Script
# Install all skills, memories, and configure environment
# Run from repository root directory

set -e

echo "=========================================="
echo "🛡️  Hermes Skills Security Suite"
echo "   Professional Security Testing Tools"
echo "=========================================="
echo ""

# Check prerequisites
echo "🔍 Checking system requirements..."
go version > /dev/null 2>&1 || { echo "❌ Go not installed. Installing..."; export PATH=/usr/local/go/bin:$PATH; }
python3 --version > /dev/null 2>&1 || { echo "❌ Python 3 required"; exit 1; }

echo "✅ Go: $(go version)"
echo "✅ Python: $(python3 --version)"
echo ""

# Step 1: Copy skills to Hermes profile
echo "📦 Deploying skills to Hermes profile..."
if [ ! -d "~/.hermes/profiles/default/skills" ]; then
    mkdir -p ~/.hermes/profiles/default/skills
fi

cp -r skills ~/.hermes/profiles/default/
cp -r memories ~/.hermes/profiles/default/ 2>/dev/null || true

chmod +x ~/.hermes/profiles/default/skills/*.sh 2>/dev/null || true
echo "✅ Skills deployed successfully!"
echo ""

# Step 2: Create quick-start script
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
        echo ""
        echo "Available tools: nuclei, subfinder, amass, gobuster, wfuzz, zap"
        ;;
    
    *)
        echo "Usage: $0 [recon|scan|help] [domain]"
        echo ""
        echo "Available commands:"
        echo "  recon [domain]     - Reconnaissance (subfinder + amass)"
        echo "  scan [domain]      - Vulnerability scan (nuclei)"
        echo "  help               - Show this help"
        ;;
esac
EOF
chmod +x ~/.hermes/profiles/default/skills/bb-quickstart.sh
echo "✅ Quick-start scripts created!"
echo ""

# Step 3: Build FPGen Golang server
echo "🔨 Building FPGen Golang server..."
export PATH=$PATH:/usr/local/go/bin

if [ -d "source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator" ]; then
    cd source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator
    
    # Clone if missing
    if [ ! -f "go.mod" ]; then
        cd ../../../..
        git clone --depth 1 https://github.com/dhikadrian/fp-gen source-repos/FPGen-dhikadrian/fp-gen
        cd FPGen-dhikadrian/fingerprint-data/fingerprint-generator
    fi
    
    # Build
    go build -o ~/bin/fp-server ./cmd/server/ 2>/dev/null && \
        echo "✅ FPGen server built successfully!" || \
        echo "⚠️  FPGen build failed or already exists"
    
    cd ../../../../../../
else
    echo "⚠️  FPGen source repo not found. Clone it first."
    echo "   Run: git clone https://github.com/dhikadrian/fp-gen source-repos/FPGen-dhikadrian/"
fi
echo ""

# Step 4: Install Python packages (optional)
echo "🐍 Installing Python packages..."
read -p "Install browserforge and fpgen? (y/n): " install_python
if [[ $install_python =~ ^[Yy]$ ]]; then
    pip3 install --break-system-packages browserforge[all] fpgen 2>/dev/null && \
        echo "✅ Python packages installed!" || \
        echo "⚠️  Python package installation had issues (can be done manually later)"
fi
echo ""

# Step 5: Setup environment file
echo "🔧 Setting up environment configuration..."
cat > ~/.hermes.env << 'EOF'
# Hermes Skills Environment Configuration
export PATH=$PATH:/usr/local/go/bin:~/go/bin
export HERMES_SKILLS_DIR=~/.hermes/profiles/default/skills
export HERMES_MEMORIES_DIR=~/.hermes/profiles/default/memories
export SOURCE_REPOS_DIR=~/tools/source-repos
export FPGEN_SERVER_URL=http://127.0.0.1:8800
export WORDLISTS_DIR=/usr/share/wordlists
EOF

echo 'source ~/.hermes.env' >> ~/.bashrc
source ~/.hermes.env
echo "✅ Environment configured!"
echo ""

# Step 6: Summary
echo "=========================================="
echo "✨ INSTALLATION COMPLETE!"
echo "=========================================="
echo ""
echo "Installed Components:"
echo "✅ Skills: $(ls ~/.hermes/profiles/default/skills/*.md 2>/dev/null | wc -l) documentation files"
echo "✅ Memories: $(ls ~/.hermes/profiles/default/memories/*.md 2>/dev/null | wc -l) installation logs"
echo "✅ Quick-start scripts: Ready at ~/.hermes/profiles/default/skills/"
[ -f ~/bin/fp-server ] && echo "✅ FPGen Server: Built and ready at ~/bin/fp-server"
echo "✅ Environment: Configured at ~/.hermes.env"
echo ""
echo "Next Steps:"
echo "1. Source your shell: source ~/.bashrc"
echo "2. Start FPGen server: ~/bin/fp-server --port 8800 &"
echo "3. Test bug bounty tools: bb-quickstart.sh help"
echo "4. Read documentation: cat ~/.hermes/profiles/default/skills/README.md"
echo ""
echo "⚠️  LEGAL DISCLAIMER:"
echo "   Use these tools ONLY on authorized systems with written consent."
echo "   Unauthorized scanning is illegal and can result in criminal charges."
echo ""
echo "For full documentation, see README.md in this repository."
echo "=========================================="
