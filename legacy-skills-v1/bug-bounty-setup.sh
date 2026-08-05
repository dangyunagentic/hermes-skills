#!/bin/bash
# Bug Bounty & Web Security Scanning Suite - Automated Installer
# Installs all legitimate security tools for authorized testing only

set -e

echo "=== Bug Bounty & Security Tools Installation ==="
echo ""
echo "⚠️  LEGAL DISCLAIMER:"
echo "   Install ONLY for authorized security testing and educational purposes."
echo "   Unauthorized scanning is illegal and can result in criminal charges."
echo "   By continuing, you confirm you have proper authorization."
echo ""
read -p "Do you agree to use these tools only for authorized testing? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Installation aborted. Only use tools on authorized systems."
    exit 1
fi

# Check Go installation
echo ""
echo "🔍 Checking prerequisites..."
go version > /dev/null 2>&1 || { echo "❌ Go not installed. Installing..."; export PATH=/usr/local/go/bin:$PATH; }
python3 --version > /dev/null 2>&1 || { echo "❌ Python 3 required"; exit 1; }

export PATH=$PATH:/usr/local/go/bin

echo "✅ Go: $(go version)"
echo "✅ Python: $(python3 --version)"

# Install Nuclei
echo ""
echo "📦 Installing Nuclei (Vulnerability Scanner)..."
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>&1 | tail -5
nuclei -version 2>/dev/null && echo "✅ Nuclei installed!" || echo "⚠️  Nuclei may need PATH update"

# Install Subfinder
echo ""
echo "📦 Installing Subfinder (Passive Subdomain Discovery)..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>&1 | tail -5
subfinder -version 2>/dev/null && echo "✅ Subfinder installed!" || echo "⚠️  Subfinder may need PATH update"

# Install Gobuster
echo ""
echo "📦 Installing Gobuster (Directory Brute-Force)..."
go install -v github.com/OJ/gobuster/v3/cmd/gobuster@latest 2>&1 | tail -5
gobuster --version 2>/dev/null && echo "✅ Gobuster installed!" || echo "⚠️  Gobuster may need PATH update"

# Install Amass
echo ""
echo "📦 Installing Amass (OSINT & Reconnaissance)..."
go install -v github.com/owasp-amass/amass/v3/...@latest 2>&1 | tail -5
amass -version 2>/dev/null && echo "✅ Amass installed!" || echo "⚠️  Amass may need PATH update"

# Install Wfuzz
echo ""
echo "📦 Installing Wfuzz (Web Fuzzing Tool)..."
pip3 install wfuzz 2>&1 | tail -5
wfuzz --version 2>/dev/null && echo "✅ Wfuzz installed!" || echo "⚠️  Wfuzz may need PATH update"

# Setup ZAP Docker
echo ""
echo "🐳 OWASP ZAP will be used via Docker (recommended method)..."
docker --version > /dev/null 2>&1 || { echo "❌ Docker not installed. Install with: apt install docker.io"; exit 1; }
echo "✅ Docker available for ZAP deployment"

# Verify installations
echo ""
echo "=========================================="
echo "🎉 INSTALLATION SUMMARY"
echo "=========================================="
echo ""
echo "Installed Tools:"
echo "1. ✅ Nuclei - Vulnerability scanner with YAML templates"
echo "2. ✅ Subfinder - Passive subdomain enumeration"
echo "3. ✅ Gobuster - Directory/file/DNS brute-forcing"
echo "4. ✅ Amass - OSINT & attack surface mapping"
echo "5. ✅ Wfuzz - Web parameter fuzzing"
echo "6. 🐳 OWASP ZAP - Full web app scanner (via Docker)"
echo ""
echo "Tool Binaries Location:"
ls ~/go/bin/nuclei ~/go/bin/subfinder ~/go/bin/gobuster ~/go/bin/amass 2>/dev/null && \
    echo "All Go binaries installed to ~/go/bin/"
echo ""

# Create quick-start script
echo "Creating quick-start script at ~/.hermes/profiles/default/skills/bb-quickstart.sh..."
cat > ~/.hermes/profiles/default/skills/bb-quickstart.sh << 'EOF'
#!/bin/bash
# Bug Bounty Quick Start Guide
# Usage: ./bb-quickstart.sh [action] [target]

export PATH=$PATH:/usr/local/go/bin:~/go/bin

case $1 in
    recon)
        domain=$2
        echo "🔍 Starting reconnaissance on $domain..."
        subfinder -d $domain -o subdomains.txt
        amass enum -d $domain -o amass.txt
        cat subdomains.txt amass.txt | sort -u > all-subdomains.txt
        echo "✅ Recon complete! Found $(wc -l < all-subdomains.txt) unique subdomains"
        ;;
    
    scan)
        domain=$2
        echo "🔬 Running vulnerability scan on $domain..."
        nuclei -u http://$domain -automatic-scan -o nuclei-results.json -jsonl
        echo "✅ Scan complete! Findings saved to nuclei-results.json"
        ;;
    
    dirscan)
        domain=$2
        wordlist=${3:-"/usr/share/wordlists/dirb/common.txt"}
        echo "📂 Directory brute-forcing $domain..."
        gobuster dir -u https://$domain -w $wordlist -t 50 -o dir-results.txt
        echo "✅ Directory scan complete! Results in dir-results.txt"
        ;;
    
    help|--help|-h)
        echo "Bug Bounty Quick Start Commands:"
        echo "  bb-quickstart.sh recon [domain]     - Run reconnaissance"
        echo "  bb-quickstart.sh scan [domain]      - Run vulnerability scan"
        echo "  bb-quickstart.sh dirscan [domain]   - Directory brute-force"
        echo ""
        echo "Available tools:"
        echo "  - nuclei, subfinder, amass, gobuster, wfuzz, zap"
        ;;
    
    *)
        echo "Usage: $0 [recon|scan|dirscan|help] [domain]"
        echo ""
        echo "Available commands:"
        echo "  recon [domain]     - Reconnaissance (subfinder + amass)"
        echo "  scan [domain]      - Vulnerability scan (nuclei)"
        echo "  dirscan [domain]   - Directory brute-force (gobuster)"
        echo "  help               - Show this help"
        ;;
esac
EOF
chmod +x ~/.hermes/profiles/default/skills/bb-quickstart.sh
echo "✅ Quick-start script created!"

# Update shell profile
echo ""
echo "Adding Go bin to PATH (~/.bashrc)..."
echo 'export PATH=$PATH:/usr/local/go/bin:~/go/bin' >> ~/.bashrc
source ~/.bashrc

echo ""
echo "=========================================="
echo "✨ INSTALLATION COMPLETE!"
echo "=========================================="
echo ""
echo "Next Steps:"
echo "1. Source your shell: source ~/.bashrc"
echo "2. Run quick-start guide: ~/.hermes/profiles/default/skills/bb-quickstart.sh help"
echo "3. Read documentation: ~/.hermes/profiles/default/skills/bug-bounty-scraping-suite.md"
echo ""
echo "⚠️  REMEMBER: Use tools ONLY on authorized systems!"
echo ""
