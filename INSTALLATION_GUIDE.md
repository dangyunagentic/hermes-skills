# 🔧 Complete Installation Guide - Hermes Skills Security Suite

## ⚡ Quick Start (5 Minutes)

### Prerequisites Check
```bash
# Verify system requirements
echo "=== System Requirements Check ==="
go version || echo "❌ Go not installed - required >= 1.22.5"
python3 --version || echo "❌ Python 3.8+ required"
docker --version || echo "⚠️ Docker optional (for ZAP)"
which git && echo "✅ Git installed" || echo "❌ Git required"
```

### One-Command Installation
```bash
# Clone and install everything
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh
```

---

## 📋 Detailed Installation Steps

### Step 1: Install Dependencies

#### Install Go (Required for FPGen Server & Tools)
```bash
# Method 1: Direct download (recommended)
curl -O https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
go version  # Should show: go1.22.5 linux/amd64
```

#### Install Python Packages
```bash
# Install with break-system-packages flag (Ubuntu/Debian)
pip3 install --break-system-packages browserforge[all] fpgen

# OR use virtualenv (recommended for clean environment)
python3 -m venv ~/fp-venv
source ~/fp-venv/bin/activate
pip install browserforge[all] fpgen wfuzz
deactivate  # Leave virtualenv when done
```

#### Optional: Install Docker (for OWASP ZAP)
```bash
sudo apt update
sudo apt install docker.io -y
systemctl start docker
usermod -aG docker $USER
# Log out and back in, then verify:
docker pull zaproxy/zap-stable
docker run zaproxy/zap-stable -version
```

---

### Step 2: Deploy Skills to Hermes Profile

#### Copy All Files
```bash
# Copy skills from current repo to your Hermes profile
cp -r skills ~/.hermes/profiles/default/
cp -r memories ~/.hermes/profiles/default/

# Make scripts executable
chmod +x ~/.hermes/profiles/default/skills/*.sh
chmod +x ~/.hermes/profiles/default/skills/bb-quickstart.sh
```

#### Verify Installation
```bash
ls ~/.hermes/profiles/default/skills/
# Should show: ghidra-*.md, bug-bounty-*.md, browser-fingerprint-*.md, etc.

ls ~/.hermes/profiles/default/memories/
# Should show: *install-*.md, *improvements.md
```

---

### Step 3: Clone Source Repositories

#### Automated Clone Script
```bash
# Create source-repos directory
mkdir -p source-repos
cd source-repos

# Clone all 18 repositories
git clone --depth 1 https://github.com/NationalSecurityAgency/ghidra ghidra-official
git clone --depth 1 https://github.com/bethington/ghidra-mcp ghidra-mcp-beth
git clone --depth 1 https://github.com/LaurieWired/GhidraMCP GhidraMCP-Laurie
git clone --depth 1 https://github.com/symgraph/GhidrAssistMCP GhidrAssistMCP-symgraph
git clone --depth 1 https://github.com/rizinorg/rz-ghidra rz-ghidra

git clone --depth 1 https://github.com/daijro/browserforge BrowserForge-daijro
git clone --depth 1 https://github.com/scrapfly/fingerprint-generator FingerprintGenerator-scrapfly
git clone --depth 1 https://github.com/dhikadrian/fp-gen FPGen-dhikadrian

git clone --depth 1 https://github.com/zaproxy/zaproxy OWASP-ZAP-zaproxy
git clone --depth 1 https://github.com/projectdiscovery/nuclei nuclei-projectdiscovery
git clone --depth 1 https://github.com/projectdiscovery/subfinder subfinder-projectdiscovery
git clone --depth 1 https://github.com/OJ/gobuster gobuster-OJ
git clone --depth 1 https://github.com/owasp-amass/amass amass-owasp
git clone --depth 1 https://github.com/xmendez/wfuzz wfuzz-xmendez
git clone --depth 1 https://github.com/PortSwigger/burp-extensions PortSwigger-BurpExtensions

cd ..
```

#### Manual Clone (if auto script fails)
See `source-repos/clone-all.sh` in this repository for complete script.

---

### Step 4: Build Binaries

#### Build FPGen Golang Server (Critical!)
```bash
export PATH=$PATH:/usr/local/go/bin
cd source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator

# Build the server binary
go build -o ~/bin/fp-server ./cmd/server/

# Verify build
ls -lh ~/bin/fp-server  # Should show ~7.5MB binary

# Test server
~/bin/fp-server --port 8800 &
sleep 2
curl http://127.0.0.1:8800/health  # Should return {"status":"ok"}
```

#### Install Python Generator Models
```bash
# Download and decompress fpgen model for speed
python3 << 'EOF'
import fpgen
print("Model will be downloaded automatically on first use")
result = fpgen.generate(browser='Chrome', os='Windows')
print("✅ Model downloaded successfully!")
EOF

# Decompress for 10-50x speed boost
python3 << 'EOF'
import fpgen
# This should happen automatically, but verify:
import os
model_path = "/usr/local/lib/python3.12/dist-packages/fpgen/data/"
if os.path.exists(model_path):
    print(f"✅ Model files found at {model_path}")
else:
    print("Running fetch command...")
    import subprocess
    subprocess.run(["fpgen", "fetch"])
    subprocess.run(["fpgen", "decompress"])
EOF
```

#### Build Gobuster (Optional - CLI tool already available via pip)
```bash
export PATH=$PATH:/usr/local/go/bin
cd source-repos/gobuster-OJ
go build -o ~/bin/gobuster ./cmd/gobuster/
gobuster --version
```

---

### Step 5: Configure Environment Variables

#### Create Environment File
```bash
cat > ~/.hermes.env << 'EOF'
# Dangyun/Hermes Environment Configuration
# Add to ~/.bashrc for persistence

# Go Path
export PATH=$PATH:/usr/local/go/bin:~/go/bin

# Python Virtualenv (optional)
# export VIRTUAL_ENV=~/fp-venv
# export PATH=$VIRTUAL_ENV/bin:$PATH

# Application paths
export HERMES_SKILLS_DIR=~/.hermes/profiles/default/skills
export HERMES_MEMORIES_DIR=~/.hermes/profiles/default/memories
export SOURCE_REPOS_DIR=~/tools/source-repos

# FPGen Server
export FPGEN_SERVER_URL=http://127.0.0.1:8800

# Wordlists
export WORDLISTS_DIR=/usr/share/wordlists

# Optional: Custom settings
export NUCLEI_TEMPLATE_UPDATE=true
export SUBFINDER_RATE_LIMIT=50
export GOBUSTER_THREADS=50
EOF

# Load environment
source ~/.hermes.env
echo 'source ~/.hermes.env' >> ~/.bashrc
```

---

### Step 6: Verification Tests

#### Run Complete Verification
```bash
#!/bin/bash
# save as verify-installation.sh and execute

echo "=== Completing Installation Verification ==="

# Test 1: Go Version
go version | grep -q "1.22" && echo "✅ Go 1.22+ installed" || echo "❌ Go version issue"

# Test 2: Python Packages
python3 -c "import browserforge; import fpgen" && echo "✅ Python generators installed" || echo "❌ Python packages missing"

# Test 3: FPGen Server
curl -s http://127.0.0.1:8800/health > /dev/null && echo "✅ FPGen server running" || echo "⚠️  FPGen server not running (start with: ~/bin/fp-server --port 8800 &)"

# Test 4: Nuclei
nuclei -version 2>/dev/null | grep -q "nuclei" && echo "✅ Nuclei installed" || echo "⚠️  Nuclei not installed yet"

# Test 5: Subfinder
subfinder -version 2>/dev/null | grep -q "subfinder" && echo "✅ Subfinder installed" || echo "⚠️  Subfinder not installed yet"

# Test 6: File Structure
[ -d "$HERMES_SKILLS_DIR" ] && [ -d "$HERMES_MEMORIES_DIR" ] && echo "✅ Skills/Memories directories exist" || echo "❌ Missing directories"

echo ""
echo "Installation verification complete!"
```

Execute:
```bash
chmod +x verify-installation.sh
./verify-installation.sh
```

---

### Step 7: Quick Start Commands

#### After Successful Installation

1. **Start FPGen Server** (always running for fingerprint generation):
```bash
~/bin/fp-server --port 8800 &
```

2. **Test Bug Bounty Tools**:
```bash
# Quick reconnaissance test (use ONLY authorized domains)
bb-quickstart.sh recon test-domain.com
```

3. **Test Fingerprint Generation**:
```python
# Test Python generators
python3 << 'EOF'
from browserforge.fingerprints import FingerprintGenerator
from browserforge.headers import HeaderGenerator
import fpgen

# BrowserForge
fp = FingerprintGenerator().generate()
print(f"BrowserForge UA: {fp.navigator.userAgent[:50]}...")

# fpgen
result = fpgen.generate(browser='Chrome', os='Windows')
print(f"fpgen generated: {type(result).__name__}")
EOF
```

4. **View Improvement Tracker**:
```bash
cat ~/.hermes/profiles/default/memories/reverse-skill-improvements.md
```

---

## 🔄 Updating Existing Installation

### Update Skills
```bash
# Pull latest changes from GitHub
cd ~/hermes-dangyun-skills
git pull origin main

# Copy updated files
cp -r skills ~/.hermes/profiles/default/
cp -r memories ~/.hermes/profiles/default/
chmod +x ~/.hermes/profiles/default/skills/*.sh
```

### Update Tools
```bash
# Update Nuclei
nuclei -update-templates

# Update Subfinder  
subfinder -update

# Rebuild FPGen if needed
export PATH=$PATH:/usr/local/go/bin
cd source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator
go build -o ~/bin/fp-server ./cmd/server/
```

---

## 🐛 Troubleshooting Common Issues

### Issue: "go: command not found"
```bash
# Solution: Add Go to PATH
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

### Issue: "Permission denied" when running .sh files
```bash
# Solution: Make scripts executable
chmod +x ~/.hermes/profiles/default/skills/*.sh
chmod +x bb-quickstart.sh
```

### Issue: "No module named 'browserforge'"
```bash
# Solution: Install Python packages
pip3 install --break-system-packages browserforge[all] fpgen

# Or use virtualenv
python3 -m venv fp-venv
source fp-venv/bin/activate
pip install browserforge[all] fpgen
```

### Issue: FPGen server won't start
```bash
# Check port is free
lsof -i :8800 || echo "Port 8800 is free"

# Kill any process using the port
kill -9 $(lsof -t -i:8800) 2>/dev/null || true

# Restart server
~/bin/fp-server --port 8800 &
```

### Issue: Slow fingerprint generation
```bash
# Solution: Decompress fpgen model
python3 << 'EOF'
import fpgen
import subprocess
subprocess.run(["fpgen", "decompress"])
print("Model decompressed - speeds should improve 10-50x")
EOF
```

---

## 📊 Post-Installation Checklist

After installation, ensure you have:

- [x] Go 1.22.5+ installed
- [x] Python 3.8+ with browserforge and fpgen packages
- [x] FPGen Golang server built and running on port 8800
- [x] All 18 source repositories cloned
- [x] Skills copied to `~/.hermes/profiles/default/skills/`
- [x] Memories copied to `~/.hermes/profiles/default/memories/`
- [x] Environment variables configured in `~/.hermes.env`
- [x] Quick-start commands working (`bb-quickstart.sh help`)
- [x] Improvement tracker functional
- [x] Legal agreement reviewed (required before using tools)

---

## 🎯 Next Steps After Installation

1. **Read Documentation**: Review each suite's documentation in `skills/`
2. **Run Tests**: Execute quick-start commands on authorized targets only
3. **Log First Session**: Use improvement tracker after first testing session
4. **Customize**: Adjust wordlists, templates, and configurations for your needs
5. **Share Knowledge**: Contribute improvements back to the community

---

<div align="center">

**Installation complete! Ready for security testing.** 🚀

*Remember: Use tools ONLY on authorized systems. See README.md for legal guidelines.*

</div>
