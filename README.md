# 🛡️ Hermes Skills — Offensive Security Toolkit

**Unified collection of operational skills for red team, reverse engineering, web exploitation, and automated security testing.**

## 📦 Overview

This repository contains:
- **Existing Tools**: Ghidra, Captcha Solver, Browser Fingerprint Generator, Bug Bounty Suite
- **New Additions (2024)**: GuardX Hybrid, RECore Reverse Engineering

---

## 🚀 Quick Start

```bash
# Clone this repo
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills

# Install all dependencies
./INSTALL_ALL.sh

# Activate a skill
export HERMES_SKILLS_HOME=$(pwd)
source skills/<skill-name>/activate.sh
```

---

## 🔥 New Skills (Just Added)

### 1. GuardX Hybrid (Web Vuln + Exploit + RE)
- **CVE Scanning**: 29+ checks (SQLi, XSS, RCE, Spring Actuator)
- **Auto-Exploit**: 123+ vulnerabilities with WAF bypass
- **Secret Detection**: GitHub repos, .env leaks, API keys
- **RE Bridge**: Integrated binary analysis (radare2, gdb, strings)
- **WordPress Mass Dorking**: Async scanning from CSV

**Usage:**
```python
from skills.guardx import guardx
result = guardx.scan('target.com', scan_cve=True)
guardx.exploit(target='site.com', vuln='wp2shell')
re_analysis = guardx.re.extract_strings('/tmp/binary')
```

### 2. RECore (Reverse Engineering)
- **Static Analysis**: radare2 disassembly, crypto detection, string extraction
- **Dynamic Analysis**: Frida hooking, strace/ltrace, memory inspection
- **Mobile RE**: JADX APK decompiler, apktool smali extraction
- **Binary Frameworks**: Angr, Unicorn, Capstone integration

**Usage:**
```python
from skills.recore import recore
info = recore.get_binary_info('/path/to/binary')
strings = recore.extract_strings('/path/file', min_length=8)
result = recore.decompile_apk('/app.apk')
```

---

## 🧪 Existing Skills

| Skill | Description | Status |
|-------|-------------|--------|
| **Ghidra MCP** | Reverse engineering automation via MCP protocol | ✅ Ready |
| **Captcha Solver** | Turnstile, hCaptcha, reCAPTCHA solving infrastructure | ✅ Ready |
| **Browser Fingerprint** | JA3/JA4 spoofing, fingerprint randomization | ✅ Ready |
| **Bug Bounty Suite** | Scraping pipelines, anti-bot evasion, data aggregation | ✅ Ready |
| **Advanced RE** | Ghidra-based static/dynamic analysis workflow | ✅ Ready |

---

## 📋 Installation

### System Dependencies (apt)
```bash
apt install radare2 gdb binutils binwalk strace ltrace file \
             openjdk-17-jdk-headless python3-pip curl wget
```

### Python Dependencies (pip)
```bash
pip install requests cloudscraper aiohttp PyYAML frida \
            angr unicorn capstone jadx
```

### Optional Tools
- **APK Tools**: JADX v1.5.6, Apktool v2.9.3 (manual install)
- **Docker**: For containerized skill deployments

See `INSTALLATION_GUIDE.md` for detailed steps per skill.

---

## 🎯 Usage Examples

### Web Exploitation (GuardX)
```python
from skills.guardx import guardx

# Subdomain enumeration
subs = guardx.subdiscover('example.com')
print(f"Found {subs['count']} subdomains")

# Auto-exploit WordPress SQLi
guardx.exploit(target='vuln-site.com', vuln='wp2shell', interactive=True)

# Secret scan on GitHub
secrets = guardx.secret_scan('github.com/user/repo', include_git=True)
```

### Reverse Engineering (RECore)
```python
from skills.recore import recore

# Binary metadata & hashes
info = recore.get_binary_info('/bin/ls')
print(f"MD5: {info['md5']}, SHA256: {info['sha256']}")

# Extract strings from ELF
strings = recore.extract_strings('/path/to/binary', min_length=6)
print(f"Found {strings['count']} strings")

# Crypto primitive detection
crypto = recore.detect_crypto_primitives('/path/to/binary')
```

### Hybrid Workflow
```python
from skills.guardx import guardx

# Find exposed backup → extract → analyze for secrets
scan_result = guardx.scan('vulnerable-site.com', scan_cve=True)
if scan_result['data']['backup_files']:
    guardx.exploit('site.com', vuln='backup')
    
    # Analyze extracted binary
    secrets = guardx.re.extract_strings('/tmp/extracted/bin', min_length=10)
    print(f"Found API key in: {secrets['strings'][0]}")
```

---

## 🔒 Security Notes

- All tools designed for **authorized testing only**
- Use on targets you own or have explicit permission to test
- Credentials and sensitive data should never be logged
- Follow responsible disclosure policies when finding bugs

---

## 📄 License

Educational / Authorized Testing Only  
All content provided "as-is" for offensive security research

---

*Built for Autumn / Dangyun Operations*  
*Hermes Agent Integration Ready*  
*Last Updated: 2024-08-04*
