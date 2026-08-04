# 🚀 Quick Start Guide — Hermes Skills Security Suite

**Updated 2024-08-04**: Added GuardX Hybrid + RECore tools  
Total: 15+ offensive security tools ready to deploy

---

## ⚡ One-Command Install

```bash
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh
source ~/.bashrc
```

Done! All tools ready at `~/.hermes/profiles/default/skills/`

---

## 🔥 New Tools (Just Added!)

### 🛡️ GuardX (Web Vuln + Exploit + RE Hybrid)

**What it does:**
- Scan for 29+ CVEs (SQLi, XSS, RCE, Spring Actuator)
- Auto-exploit with WAF bypass (Cloudflare, Imunify360)
- Detect leaked secrets (.env, API keys, GitHub repos)
- WordPress mass dorking & Joomla scanning
- Integrated binary analysis via RECore bridge

**Quick commands:**
```bash
# Vulnerability scan
guardx-quickstart.sh scan example.com

# Auto-exploit specific vuln
guardx-quickstart.sh exploit vulnerable-site.com wp2shell

# List all available exploits
guardx-quickstart.sh list

# Reverse engineer extracted binary
guardx-quickstart.sh re /tmp/extracted/malware.exe

# Validate installation
guardx-quickstart.sh validate
```

**Python API:**
```python
from skills.guardx import guardx

# Full CVE scan
result = guardx.scan('target.com', scan_cve=True)

# Subdomain enumeration
subs = guardx.subdiscover('example.com')
print(f"Found {subs['count']} subdomains")

# Exploit WordPress SQLi
guardx.exploit(target='site.com', vuln='wp2shell', interactive=True)

# Secret detection on GitHub
secrets = guardx.secret_scan('github.com/user/repo', include_git=True)

# Hybrid: find backup → extract → analyze for creds
scan_result = guardx.scan('vuln-site.com', scan_cve=True)
if scan_result['data']['backup_files']:
    guardx.exploit('site.com', vuln='backup')
    secrets = guardx.re.extract_strings('/tmp/binary', min_length=10)
```

### 🔧 RECore (Reverse Engineering)

**What it does:**
- Static analysis: radare2 disassembly, crypto detection, string extraction
- Dynamic analysis: Frida hooking, strace/ltrace memory inspection
- Mobile RE: JADX APK decompiler, apktool smali extraction
- Binary frameworks: Angr, Unicorn, Capstone integration

**Quick commands:**
```bash
# Get binary metadata
recore-getinfo /bin/ls

# Extract strings from ELF
recore-extract-strings /path/to/file --min-len 6

# Decompile APK to Java
recore-decompile-apk /app.apk --output /tmp/decompiled

# Find crypto primitives
recore-detect-crypto /malware.exe

# Trace execution with strace
recore-trace /binary arg1 arg2
```

**Python API:**
```python
from skills.recore import recore

# Binary metadata
info = recore.get_binary_info('/path/to/binary')
print(f"MD5: {info['md5']}, SHA256: {info['sha256']}")

# String extraction
strings = recore.extract_strings('/path/to/binary', min_length=8)
print(f"Found {strings['count']} strings")

# Crypto detection
crypto = recore.detect_crypto_primitives('/malware.bin')
print(f"Algorithms: {crypto['detected'][:5]}")

# APK decompilation
result = recore.decompile_apk('/app.apk')
print(f"Decompiled {result['files_decompiled']} files")
```

---

## 📦 Existing Skills (Still Working)

| Skill | Description | Quick Command |
|-------|-------------|---------------|
| **Bug Bounty Suite** | recon, scan, scrape, brute force | `bb-quickstart.sh help` |
| **Captcha Solver** | Turnstile/hCaptcha/reCAPTCHA bypass | `captcha-quickstart.sh help` |
| **Browser Fingerprint** | JA3/JA4 spoofing, anti-detection | `fp-gen-server &` |
| **Ghidra MCP** | Automated reverse engineering | `ghidra-mcp-launch.sh start` |
| **HAR Capture** | Chrome HAR generation & redaction | `har-capture-setup.sh test` |

See individual `.md` docs in `skills/` folder for details.

---

## 🎯 Common Workflows

### 1. Web App Pentest (Full Chain)
```bash
# Phase 1: Recon
subfinder -d target.com > subs.txt
cat subs.txt | httpx -silent > alive.txt

# Phase 2: CVE Scan
guardx-quickstart.sh scan target.com

# Phase 3: Exploit
guardx-quickstart.sh exploit target.com actuator

# Phase 4: Analyze downloaded binary
guardx-quickstart.sh re /tmp/actuator_dump.jar
recore-detect-crypto /tmp/actuator_dump.jar
```

### 2. Malware Analysis Pipeline
```bash
# Step 1: Get binary info
recore-getinfo malware.exe

# Step 2: Extract suspicious strings
recore-extract-strings malware.exe --min-len 10

# Step 3: Check for crypto patterns
recore-detect-crypto malware.exe

# Step 4: Trace execution
recore-trace malware.exe --args hidden
```

### 3. APK Reverse Engineering
```bash
# Step 1: Decompile APK
recore-decompile-apk app.apk --output /tmp/apk

# Step 2: Search for hardcoded credentials
grep -r "password\|secret\|api_key" /tmp/apk/smali/

# Step 3: Analyze with Ghidra MCP
ghidra-mcp-analyze /tmp/apk/classes.dex
```

---

## ⚠️ Legal Notice

**ALL tools are for authorized testing ONLY.**

- Use only on systems you own or have written permission to test
- Unauthorized scanning/exploration is illegal and can result in criminal charges
- Follow responsible disclosure policies when finding vulnerabilities
- Keep credentials and sensitive data encrypted, never log plaintext

---

## 📚 Documentation

- **README.md** — Full overview of all tools
- **INSTALLATION_GUIDE.md** — Detailed step-by-step setup
- **skills/*.md** — Individual tool documentation
- **memories/** — Installation logs and improvement trackers

---

## 🆘 Troubleshooting

```bash
# Check Python packages
pip3 list | grep -E "(requests|cloudscraper|frida)"

# Verify system tools
which r2 gdb jadx apktool frida

# Test GuardX validation
guardx-quickstart.sh validate

# Recreate environment
rm -rf ~/.hermes.env && source ~/.bashrc
```

---

*Last Updated: 2024-08-04 | Maintained by Dangyun Operations*
