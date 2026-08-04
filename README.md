# 🛡️ Hermes Skills — Offensive Security Toolkit

**Professional-grade security testing tools for penetration testers, red teamers, and security researchers.**

📦 **Status**: Production Ready  
🔒 **License**: Educational / Authorized Testing Only  
🤝 **Contributions**: Welcome! See [CONTRIBUTING.md](https://github.com/dangyunagentic/hermes-skills/blob/main/.github/CONTRIBUTING.md) (coming soon)

---

## ⚠️ Important Legal Notice

**ALL tools in this repository are designed for authorized security testing ONLY.**

- ✅ Use on systems you own or have explicit written permission to test
- ❌ NEVER scan networks, websites, or systems without authorization
- ❌ Unauthorized access is illegal (violates Computer Fraud and Abuse Act, GDPR, etc.)
- ✅ Follow responsible disclosure when finding vulnerabilities
- ✅ Use only for legitimate security research and education

**By using these tools, you agree to the above terms. The authors are not responsible for misuse of these tools.**

---

## 🚀 Quick Start (30 Seconds)

### Option 1: One-Command Install
```bash
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh
source ~/.bashrc
```

✅ Done! All tools ready at `~/.hermes/profiles/default/skills/`

### Option 2: Manual Install
See [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) for detailed step-by-step instructions.

---

## 📦 What's Included?

This repository contains **15+ professional security tools** across multiple categories:

### 🔥 New Features (2024-08-04)

#### 1. 🛡️ GuardX Hybrid (Web Vulnerability Scanner & Exploit Automation)
Full-spectrum web security testing with built-in WAF bypass and binary analysis integration.

**Capabilities:**
- ✓ 29+ CVE checks (SQLi, XSS, RCE, Spring Actuator, Django, Laravel)
- ✓ Auto-exploit engine (123+ exploits)
- ✓ Secret detection (.env, API keys, GitHub repos, config files)
- ✓ WordPress + Joomla mass dorking
- ✓ Built-in WAF bypass (Cloudflare, Imunify360, Akamai)
- ✓ Binary analysis bridge to RECore

**Quick commands:**
```bash
guardx-quickstart.sh scan example.com          # Vulnerability scan
guardx-quickstart.sh exploit site wp2shell     # Auto-exploit WordPress SQLi
guardx-quickstart.sh list                      # List all available exploits
guardx-quickstart.sh validate                  # Test installation
```

**Python API:**
```python
from skills.guardx import guardx

# Scan for CVEs
result = guardx.scan('target.com', scan_cve=True)

# Subdomain enumeration
subs = guardx.subdiscover('example.com')

# Auto-exploit specific vulnerability
guardx.exploit(target='site.com', vuln='wp2shell', interactive=True)

# Detect leaked secrets
secrets = guardx.secret_scan('github.com/user/repo', include_git=True)

# Hybrid workflow: find backup → extract → analyze for credentials
scan_result = guardx.scan('vulnerable-site.com', scan_cve=True)
if scan_result['data']['backup_files']:
    guardx.exploit('site.com', vuln='backup')
    secrets = guardx.re.extract_strings('/tmp/binary', min_length=10)
```

**Documentation:** [skills/guardx-suite.md](skills/guardx-suite.md) | **Setup:** [skills/guardx-setup.sh](skills/guardx-setup.sh)

---

#### 2. 🔧 RECore (Reverse Engineering Toolkit)
Comprehensive reverse engineering suite integrating static and dynamic analysis tools.

**Capabilities:**
- ✓ Static analysis: radare2 disassembly, string extraction, crypto detection
- ✓ Dynamic analysis: Frida hooking, strace/ltrace syscall tracing
- ✓ Mobile RE: JADX v1.5.6 APK decompiler, Apktool v2.9.3 smali extractor
- ✓ Binary frameworks: Angr, Unicorn, Capstone integration

**Quick commands:**
```bash
recore-getinfo /path/to/binary        # Get binary metadata (size, hash, type)
recore-extract-strings malware.exe --min-len 6  # Extract suspicious strings
recore-decompile-apk app.apk          # Decompile APK to Java source
recore-detect-crypto binary.bin       # Find encryption algorithms (AES, RSA, SHA)
```

**Python API:**
```python
from skills.recore import recore

# Binary metadata
info = recore.get_binary_info('/path/to/binary')
print(f"Size: {info['size_bytes']}, MD5: {info['md5']}")

# String extraction
strings = recore.extract_strings('/file.bin', min_length=8)
print(f"Found {strings['count']} strings")

# Crypto primitive detection
crypto = recore.detect_crypto_primitives('/malware.exe')
print(f"Algorithms: {crypto['detected'][:5]}")

# APK decompilation
result = recore.decompile_apk('/app.apk', output_dir='/tmp/apk')
print(f"Decompiled {result['files_decompiled']} files")
```

**Documentation:** [skills/recore-suite.md](skills/recore-suite.md) | **Setup:** [skills/recore-setup.sh](skills/recore-setup.sh)

---

### Existing Tools (All Working)

| Tool | Description | Command | Docs |
|------|-------------|---------|------|
| **Bug Bounty Suite** | Recon, scanning, scraping, brute force | `bb-quickstart.sh help` | [bug-bounty-*](skills/bug-bounty*) |
| **Captcha Solver** | Turnstile, hCaptcha, reCAPTCHA bypass | `captcha-quickstart.sh help` | [captcha-solver-*](skills/captcha-solver*) |
| **Browser Fingerprint** | JA3/JA4 spoofing, anti-detection | `fp-gen-server &` | [browser-fingerprint-*](skills/browser-fingerprint*) |
| **Ghidra MCP** | Automated reverse engineering via MCP | `ghidra-mcp-launch.sh start` | [ghidra-mcp-*](skills/ghidra-mcp*) |
| **HAR Capture** | Chrome HAR generation & data redaction | `har-capture-setup.sh test` | [har-capture-*](skills/har-capture*) |
| **Advanced RE** | Ghidra-based static analysis workflows | See docs | [advanced-re-*](skills/advanced-re*) |

---

## 🎯 Complete Workflows

### Web Application Pentest (Full Chain)

```bash
# Phase 1: Reconnaissance
subfinder -d target.com > subs.txt
cat subs.txt | httpx -silent > alive.txt

# Phase 2: Vulnerability Scanning
guardx-quickstart.sh scan target.com

# Phase 3: Exploitation
guardx-quickstart.sh exploit target.com actuator

# Phase 4: Post-Exploitation Analysis
guardx-quickstart.sh re /tmp/actuator_dump.jar
recore-detect-crypto /tmp/actuator_dump.jar
```

### Malware Analysis Pipeline

```bash
# Step 1: Initial Assessment
recore-getinfo malware.exe
recore-extract-strings malware.exe --min-len 10

# Step 2: Behavior Analysis
recore-trace malware.exe --args hidden

# Step 3: Cryptography Detection
recore-detect-crypto malware.exe

# Step 4: Deep Reverse Engineering
ghidra-mcp-analyze malware.exe
```

### APK Security Audit

```bash
# Step 1: Decompilation
recore-decompile-apk app.apk --output /tmp/apk

# Step 2: Credential Search
grep -r "password\|secret\|api_key\|token" /tmp/apk/smali/

# Step 3: Network Analysis
android-nethunter-scan app.apk

# Step 4: Deep Analysis with Ghidra
ghidra-mcp-analyze /tmp/apk/classes.dex
```

---

## 📚 Documentation Structure

| File | Purpose | Audience |
|------|---------|----------|
| **[README.md](README.md)** | Overview, quick start, legal notice | Everyone |
| **[QUICK_START.md](QUICK_START.md)** | Quick command reference | Users |
| **[INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)** | Detailed step-by-step setup | First-time users |
| **[CHANGELOG.md](CHANGELOG.md)** | Version history and updates | Contributors |
| **[skills/*.md](skills/)** | Individual tool documentation | Power users |
| **[memories/*.md](memories/)** | Installation logs and improvements | Contributors |

---

## 🔧 Installation Requirements

### System Dependencies (Automated)
The `INSTALL_ALL.sh` script will install these automatically on Linux:

```bash
# Core tools
radare2 gdb binutils binutils binwalk strace ltrace file wget curl

# Development
openjdk-17-jdk-headless git build-essential python3-pip

# Optional
docker.io  # For containerized tools like ZAP
```

### Python Dependencies (Automated)
```bash
# Core packages
requests cloudscraper aiohttp PyYAML cryptography fpdf

# Dynamic instrumentation
frida frida-tools

# Optional advanced RE (prompt-based during install)
angr unicorn capstone
```

### APK Tools (Manual Setup Required)
After running `INSTALL_ALL.sh`, manually install:

**JADX v1.5.6:**
```bash
cd ~/tools && mkdir -p jadx
cd jadx
wget https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip
unzip jadx-1.5.6.zip
sudo ln -s $(pwd)/jadx-1.5.6/bin/jadx /usr/local/bin/jadx
jadx --version  # Should show v1.5.6
```

**Apktool v2.9.3:**
```bash
cd ~/tools
wget https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar
mkdir -p /opt && mv apktool_2.9.3.jar /opt/apktool.jar
echo '#!/bin/bash' > /usr/local/bin/apktool
echo 'exec java -jar "/opt/apktool.jar" "$@"' >> /usr/local/bin/apktool
chmod +x /usr/local/bin/apktool
apktool --version  # Should show 2.9.3
```

---

## 🚀 Usage Examples

### Basic Bug Bounty Workflow
```bash
# Reconnaissance
bb-quickstart.sh recon example.com

# Vulnerability scanning
bb-quickstart.sh scan example.com

# If GuardX finds something interesting
guardx-quickstart.sh exploit vulnerable.example.com wp2shell

# Analyze any downloaded binary
recore-getinfo /tmp/downloaded/malware.exe
```

### Advanced Reverse Engineering
```bash
# Get binary info
recore-getinfo /path/to/binary

# Extract suspicious strings
recore-extract-strings malware.exe --min-len 10

# Trace execution behavior
recore-trace malware.exe arg1 arg2

# Decompile APK for mobile analysis
recore-decompile-apk suspicious.apk --output /tmp/apk

# Search for hardcoded credentials
grep -r "API_KEY\|SECRET\|PASSWORD" /tmp/apk/smali/
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### How to Contribute

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/hermes-skills.git
   cd hermes-skills
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Add new skills to `skills/`
   - Update documentation
   - Add tests if applicable
   - Follow existing code style

4. **Test your changes**
   ```bash
   bash ./INSTALL_ALL.sh  # Verify installation works
   guardx-quickstart.sh validate  # Run validation
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Describe what you changed and why
   - Reference any related issues
   - Include tests if applicable

### Contribution Guidelines

- ✅ Write clear, descriptive commit messages
- ✅ Document all new features
- ✅ Follow existing code style and naming conventions
- ✅ Keep changes focused and atomic
- ✅ Test thoroughly before submitting
- ❌ Don't break existing functionality
- ❌ Don't introduce security vulnerabilities
- ❌ Don't add copyrighted material without permission

### Reporting Issues

Found a bug? Have a feature request? Please open an issue with:

- Clear title describing the problem
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Environment details (OS, Python version, etc.)
- Screenshots/logs if applicable

---

## 🔍 Repository Structure

```
hermes-skills/
├── .gitignore                    # Git ignore rules
├── CHANGELOG.md                  # Version history
├── INSTALL_ALL.sh               # Main installation script
├── INSTALLATION_GUIDE.md         # Detailed setup guide
├── LICENSE                       # License information
├── QUICK_START.md                # Quick command reference
├── README.md                     # This file
│
├── memories/                     # Installation logs & improvements
│   ├── *install-*.md            # Installation records
│   └── *improvements.md         # Improvement trackers
│
└── skills/                       # All security tools
    ├── guardx/                   # GuardX skill module (Python)
    │   ├── __init__.py
    │   └── skill.py
    ├── recore/                   # RECore skill module (Python)
    │   ├── __init__.py
    │   └── skill.py
    ├── *.md                      # Skill documentation
    ├── *-setup.sh               # Automated setup scripts
    └── *-quickstart.md          # Quick start guides
```

---

## ⚙️ Environment Configuration

After installation, environment variables are set in `~/.hermes.env`:

```bash
export PATH=$PATH:/usr/local/go/bin:~/go/bin
export HERMES_SKILLS_DIR=~/.hermes/profiles/default/skills
export GUARDX_ENABLED=true
export RECORE_ENABLED=true
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

To activate, run:
```bash
source ~/.hermes.env
```

Or add to your `~/.bashrc` for persistence:
```bash
source ~/.hermes.env
```

---

## 🧪 Verification Checklist

After installation, verify all these work:

- [ ] `jadx --version` shows `v1.5.6`
- [ ] `apktool --version` shows `2.9.3`
- [ ] `r2 --version` works
- [ ] `frida --version` works (`v17.16.4+`)
- [ ] `guardx-quickstart.sh validate` passes
- [ ] `bb-quickstart.sh help` shows options
- [ ] `cat ~/.hermes.env` contains `GUARDX_ENABLED=true`
- [ ] `which r2 gdb jadx apktool` all return paths

If all checked ✅, you're ready to go!

---

## 🆘 Troubleshooting

### Common Issues

**Python package installation fails:**
```bash
# Force reinstall specific package
pip3 install --break-system-packages --force-reinstall <package_name>

# Check installed packages
pip3 list | grep -E "(requests|cloudscraper|frida)"
```

**Tool not found:**
```bash
# Verify binaries exist
which r2 gdb jadx apktool frida

# Re-add to PATH if missing
export PATH=$PATH:/usr/local/bin:/opt/jadx/bin
```

**Permission errors:**
```bash
# Make scripts executable
chmod +x ~/.hermes/profiles/default/skills/*.sh

# Run with sudo if needed
sudo apt-get install -y <missing-package>
```

**Java version mismatch:**
```bash
# Check current version
java -version

# If too old, install JDK 17+
sudo apt install openjdk-17-jdk-headless
sudo update-alternatives --config java
```

For more help, check [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) or open an issue.

---

## 📄 License

**Educational / Authorized Testing Only**

All content provided "as-is" for offensive security research and education.

- ✅ **Permitted**: Authorized penetration testing, security research, education
- ❌ **Prohibited**: Unauthorized scanning, exploitation, illegal activities

By using these tools, you agree to use them responsibly and legally.

---

## 👥 Credits & Acknowledgments

Built with love by **Dangyun Operations** for the **Autumn** community.

Special thanks to:
- Original project contributors
- Open-source tool developers (radare2, Frida, JADX, etc.)
- Security researchers who share knowledge publicly
- Community members who provide feedback and improvements

---

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/dangyunagentic/hermes-skills/issues)
- **Discussions**: [GitHub Discussions](https://github.com/dangyunagentic/hermes-skills/discussions)
- **Documentation**: [Wiki](https://github.com/dangyunagentic/hermes-skills/wiki) (coming soon)

---

*Last Updated: 2024-08-04*  
*Maintained by Dangyun Operations*  
*Part of the Hermes Agent Ecosystem*  

🔐 **Remember: With great power comes great responsibility. Use these tools ethically and legally.**
