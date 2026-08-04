# 🔧 Complete Installation Guide — Hermes Skills Security Suite

**Updated 2024-08-04**: Added GuardX Hybrid + RECore tools  
Total: 15+ offensive security tools ready to deploy

---

## ⚡ Quick Start (5 Minutes)

### One-Command Install
```bash
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh
source ~/.bashrc
```

Done! All tools ready at `~/.hermes/profiles/default/skills/`

---

## 📋 Detailed Installation Steps

### Step 1: System Dependencies (Automated)

The `INSTALL_ALL.sh` script will install these automatically:

#### Core Tools (apt)
```bash
# Reverse engineering
radare2 gdb binutils binutils binwalk strace ltrace file

# Development tools
wget curl git build-essential

# JDK for JADX/Apktool
openjdk-17-jdk-headless
```

#### Python Packages (pip)
```bash
# GuardX core
requests cloudscraper aiohttp PyYAML cryptography fpdf

# Frida dynamic instrumentation
frida frida-tools

# Optional advanced RE frameworks (prompt-based)
angr unicorn capstone
```

#### APK Tools (Manual - instructions below)
- **JADX v1.5.6** — APK to Java decompiler
- **Apktool v2.9.3** — Smali bytecode extractor

---

### Step 2: Manual APK Tool Setup

**JADX Installation:**
```bash
cd ~/tools && mkdir -p jadx
cd jadx

# Download JADX zip
wget https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip
unzip jadx-1.5.6.zip

# Create symlink
sudo ln -s $(pwd)/jadx-1.5.6/bin/jadx /usr/local/bin/jadx
sudo ln -s $(pwd)/jadx-1.5.6/bin/jadxi /usr/local/bin/jadxi

# Verify
jadx --version
apktool --version  # Next step
```

**Apktool Installation:**
```bash
cd ~/tools

# Download apktool jar
wget https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar
mkdir -p /opt && mv apktool_2.9.3.jar /opt/apktool.jar

# Create launcher script
echo '#!/bin/bash' > /usr/local/bin/apktool
echo 'exec java -jar "/opt/apktool.jar" "$@"' >> /usr/local/bin/apktool
chmod +x /usr/local/bin/apktool

# Verify
apktool --version
```

---

### Step 3: Deploy Skills (Automated)

`INSTALL_ALL.sh` does this automatically:
```bash
# Copy skills to profile
cp -r skills ~/.hermes/profiles/default/
cp -r memories ~/.hermes/profiles/default/ 2>/dev/null || true

# Make scripts executable
chmod +x ~/.hermes/profiles/default/skills/*.sh
```

**Verify:**
```bash
ls ~/.hermes/profiles/default/skills/
# Should show: guardx/, recore/, *.md, *.sh
ls ~/.hermes/profiles/default/memories/
# Should show: *install-*.md, *improvements.md
```

---

### Step 4: Environment Setup (Automated)

`INSTALL_ALL.sh` creates `~/.hermes.env`:
```bash
export PATH=$PATH:/usr/local/go/bin:~/go/bin
export HERMES_SKILLS_DIR=~/.hermes/profiles/default/skills
export GUARDX_ENABLED=true
export RECORE_ENABLED=true
```

Add to `.bashrc`:
```bash
source ~/.hermes.env
```

---

### Step 5: Source Repositories (Git Clone)

Clone manually or let `INSTALL_ALL.sh` handle it:

```bash
# Core GHIDRA repos
git clone --depth 1 https://github.com/NationalSecurityAgency/ghidra ghidra-official
git clone --depth 1 https://github.com/bethington/ghidra-mcp ghidra-mcp-beth
git clone --depth 1 https://github.com/LaurieWired/GhidraMCP GhidraMCP-Laurie

# FPGen for browser fingerprinting
git clone --depth 1 https://github.com/dhikadrian/fp-gen source-repos/FPGen-dhikadrian/

# Other tools as needed...
```

---

### Step 6: Build FPGen Server (Optional but Recommended)

```bash
cd source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator

# Ensure Go is in PATH
export PATH=$PATH:/usr/local/go/bin

# Build server
go build -o ~/bin/fp-server ./cmd/server/

# Start server
~/bin/fp-server --port 8800 &

# Verify
curl http://localhost:8800/version
```

---

### Step 7: Test Everything

```bash
# Test GuardX validation
guardx-quickstart.sh validate

# Test RECore basic function
python3 -c "from skills.recore import recore; print(recore.get_binary_info('/bin/ls'))"

# Test existing tools
bb-quickstart.sh help
captcha-quickstart.sh help
ghidra-mcp-launch.sh help
```

---

## 🎯 Common Post-Install Tasks

### Enable GuardX Features
```bash
# In ~/.bashrc or current session
export GUARDX_ENABLED=true
export RECORE_ENABLED=true
```

### Start Services
```bash
# FPGen server
~/bin/fp-server --port 8800 &

# Frida server (for mobile RE)
# Upload frida-server to device and run:
adb shell "su -c ./frida-server" &
```

### Quick Test Commands
```bash
# Web vuln scan
guardx-quickstart.sh scan example.com

# Binary analysis
recore-extract-strings /bin/ls --min-len 6

# APK decompile
recore-decompile-apk test.apk --output /tmp/test

# Validate full installation
guardx-quickstart.sh validate
```

---

## 🚨 Troubleshooting

### Python Package Issues
```bash
# Re-install specific package
pip3 install --break-system-packages --force-reinstall <package_name>

# Check installed packages
pip3 list | grep -E "(requests|cloudscraper|frida)"
```

### Tool Not Found
```bash
# Verify binaries exist
which r2 gdb jadx apktool frida

# Re-add to PATH if missing
export PATH=$PATH:/usr/local/bin:/opt/jadx/bin
```

### Permission Errors
```bash
# Make scripts executable
chmod +x ~/.hermes/profiles/default/skills/*.sh
chmod +x ~/.hermes.profile.sh

# Run setup with sudo if needed
sudo apt-get update && sudo apt-get install -y <missing-package>
```

### JDK Version Mismatch
```bash
# Check current version
java -version

# If too old, install JDK 17+
sudo apt install openjdk-17-jdk-headless
sudo update-alternatives --config java
```

---

## 📚 Documentation Links

- **README.md** — Full overview
- **QUICK_START.md** — Fast commands reference
- **skills/guardx/** — GuardX documentation
- **skills/recore/** — RECore documentation
- **memories/** — Installation logs & improvement trackers

---

## ✅ Verification Checklist

After installation, verify all these work:

- [ ] `jadx --version` shows v1.5.6
- [ ] `apktool --version` shows 2.9.3
- [ ] `r2 --version` works
- [ ] `frida --version` works (v17.16.4+)
- [ ] `guardx-quickstart.sh validate` passes
- [ ] `bb-quickstart.sh help` shows bug bounty options
- [ ] `cat ~/.hermes.env` contains GUARDX_ENABLED=true

If all checked, you're ready to go! 🎉

---

*Last Updated: 2024-08-04 | Maintained by Dangyun Operations*
*For issues, check `memories/` for installation logs*
