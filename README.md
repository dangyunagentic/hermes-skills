# 🛡️ Hermes Skills — Offensive Security Toolkit

**Updated 2024-08-04**: Full suite with GuardX Hybrid + RECore tools  
**Total Tools**: 15+ offensive security capabilities  
**Status**: All validated and operational

---

## Quick Start (30 Seconds)

```bash
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh
source ~/.bashrc
```

✅ Done! All tools ready at `~/.hermes/profiles/default/skills/`

---

## 🆕 New Skills (Just Added!)

### 1. 🛡️ GuardX Hybrid (Web Vuln + Exploit + RE)

**Capabilities:**
- CVE scanning (29+ checks: SQLi, XSS, RCE, Spring Actuator)
- Auto-exploit with WAF bypass (Cloudflare, Imunify360)
- Secret detection (.env, API keys, GitHub repos)
- WordPress/Joomla mass dorking
- Binary analysis via RECore bridge

**Quick commands:**
```bash
guardx-quickstart.sh scan example.com          # CVE scan
guardx-quickstart.sh exploit site wp2shell     # Exploit WordPress
guardx-quickstart.sh list                      # List all exploits
guardx-quickstart.sh re /path/to/binary        # RE analysis
guardx-quickstart.sh validate                  # Test install
```

**Python API:**
```python
from skills.guardx import guardx

result = guardx.scan('target.com', scan_cve=True)
subs = guardx.subdiscover('example.com')
guardx.exploit(target='site.com', vuln='wp2shell', interactive=True)
guardx.re.extract_strings('/tmp/binary', min_length=8)
```

**Documentation:** `skills/guardx-suite.md` | **Setup:** `skills/guardx-setup.sh`

---

### 2. 🔧 RECore (Reverse Engineering)

**Capabilities:**
- Static analysis: radare2 disassembly, string extraction, crypto detection
- Dynamic analysis: Frida hooking, strace/ltrace, memory inspection
- Mobile RE: JADX APK decompiler, Apktool smali extraction
- Frameworks: Angr, Unicorn, Capstone integration

**Quick commands:**
```bash
recore-getinfo /bin/ls                           # Binary metadata
recore-extract-strings malware.exe --min-len 6   # Find strings
recore-decompile-apk app.apk                     # APK → Java source
recore-detect-crypto binary.bin                  # AES/SHA/RSA patterns
```

**Python API:**
```python
from skills.recore import recore

info = recore.get_binary_info('/path/to/binary')
strings = recore.extract_strings('/file.bin', min_length=8)
crypto = recore.detect_crypto_primitives('/malware.exe')
result = recore.decompile_apk('/app.apk')
```

**Documentation:** `skills/recore-suite.md` | **Setup:** `skills/recore-setup.sh`

---

## 📦 Existing Skills (All Working)

| Skill | Description | Command | Docs |
|-------|-------------|---------|------|
| **Bug Bounty Suite** | recon, scan, scrape, brute force | `bb-quickstart.sh help` | `skills/bug-bounty-*` |
| **Captcha Solver** | Turnstile/hCaptcha/reCAPTCHA bypass | `captcha-quickstart.sh help` | `skills/captcha-solver-*` |
| **Browser Fingerprint** | JA3/JA4 spoofing, anti-detection | `fp-gen-server &` | `skills/browser-fingerprint-*` |
| **Ghidra MCP** | Automated reverse engineering | `ghidra-mcp-launch.sh start` | `skills/ghidra-mcp-*` |
| **HAR Capture** | Chrome HAR generation & redaction | `har-capture-setup.sh test` | `skills/har-capture-*` |
| **Advanced RE** | Ghidra-based workflows | See docs | `skills/advanced-re-*` |

---

## 🎯 Complete Workflows

### Web App Pentest (Full Chain)
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

### Malware Analysis Pipeline
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

### APK Reverse Engineering
```bash
# Step 1: Decompile APK
recore-decompile-apk app.apk --output /tmp/apk

# Step 2: Search for hardcoded credentials
grep -r "password\|secret\|api_key" /tmp/apk/smali/

# Step 3: Analyze with Ghidra MCP
ghidra-mcp-analyze /tmp/apk/classes.dex
```

---

## 📚 Documentation

- **README.md** — This overview
- **QUICK_START.md** — Quick commands reference
- **INSTALLATION_GUIDE.md** — Detailed step-by-step setup
- **skills/guardx-suite.md** — GuardX complete documentation
- **skills/recore-suite.md** — RECore complete documentation
- **skills/*.md** — Individual skill documentation
- **memories/** — Installation logs and improvement trackers

---

## ⚠️ Legal Notice

**ALL tools are for authorized testing ONLY.**

- Use only on systems you own or have written permission to test
- Unauthorized scanning/exploration is illegal and can result in criminal charges
- Follow responsible disclosure policies when finding vulnerabilities
- Keep credentials and sensitive data encrypted, never log plaintext

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
*Built for Autumn / Hermes Agent Integration*
