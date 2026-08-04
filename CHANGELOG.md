# 📋 Changelog — Hermes Skills Security Suite

**All significant changes to the repository are documented here.**

---

## [2024-08-04] - Major Update: GuardX + RECore Integration

### 🆕 New Skills Added

#### GuardX Hybrid (Web Vuln + Exploit + RE Bridge)
- **Full CVE scanning**: 29+ checks including SQLi, XSS, RCE, Spring Actuator
- **Auto-exploit engine**: 123+ vulnerabilities with WAF bypass built-in
- **Secret detection**: GitHub repos, .env leaks, API keys, config files
- **Mass dorking**: WordPress + Joomla scanning with async support
- **RE bridge**: Integrated binary analysis via RECore skill

**Files added:**
- `skills/guardx/` — Complete GuardX skill module
- `skills/guardx-suite.md` — Full documentation
- `skills/guardx-setup.sh` — Automated setup script
- `skills/final_validation.py` — Validation test suite

**Capabilities:**
```bash
guardx-quickstart.sh scan example.com          # CVE scan
guardx-quickstart.sh exploit site wp2shell     # Auto-exploit
guardx-quickstart.sh re /binary                # Binary analysis
```

#### RECore (Reverse Engineering Toolkit)
- **Static analysis**: radare2 disassembly, string extraction, crypto detection
- **Dynamic analysis**: Frida hooking, strace/ltrace, memory inspection
- **Mobile RE**: JADX v1.5.6, Apktool v2.9.3 integration
- **Binary frameworks**: Angr, Unicorn, Capstone support

**Files added:**
- `skills/recore/` — Complete RECore skill module
- `skills/recore-suite.md` — Full documentation
- `skills/recore-setup.sh` — Automated setup script

**Capabilities:**
```bash
recore-getinfo /path/to/binary        # Binary metadata
recore-extract-strings malware.exe    # String extraction
recore-decompile-apk app.apk          # APK → Java source
```

### 📦 Updated Files

#### INSTALL_ALL.sh
- Added system dependencies: radare2, gdb, binwalk, strace, ltrace
- Added Python packages: requests, cloudscraper, aiohttp, PyYAML, frida
- Added optional install: angr, unicorn, capstone (prompt-based)
- Added APK tool instructions: JADX v1.5.6, Apktool v2.9.3
- Added guardx-quickstart.sh wrapper script
- Added environment flags: GUARDX_ENABLED, RECORE_ENABLED

#### Documentation Updates
- **README.md** — Complete overview with new skills
- **QUICK_START.md** — Quick command reference for all tools
- **INSTALLATION_GUIDE.md** — Detailed setup including APK tools

#### Scripts Added
- `skills/guardx-setup.sh` — GuardX automated installation
- `skills/recore-setup.sh` — RECore automated installation
- `skills/guardx-quickstart.sh` — Quick start commands wrapper

### 🔧 Dependencies Installed

**System Packages (apt):**
- ✅ radare2, gdb, binutils, binwalk, strace, ltrace, file, wget, curl

**Python Packages (pip):**
- ✅ requests, cloudscraper, aiohttp, PyYAML, cryptography, fpdf
- ✅ frida, frida-tools (dynamic instrumentation)
- ⚠️  angr, unicorn, capstone (optional, prompt-based)

**APK Tools:**
- ✅ JADX v1.5.6
- ✅ Apktool v2.9.3

### 🎯 Use Cases Enabled

1. **Web App Pentest (Full Chain)**
   - Recon → CVE scan → Auto-exploit → Binary analysis
   
2. **Malware Analysis Pipeline**
   - Get binary info → Extract strings → Crypto detection → Trace execution
   
3. **APK Reverse Engineering**
   - Decompile APK → Search credentials → Analyze with Ghidra MCP

---

## [Previous Versions]

See git history for earlier commits and updates.

---

## 🔄 Migration Guide (For Existing Users)

If you have existing hermes-skills repo, simply pull latest:

```bash
cd ~/hermes-skills
git pull origin main
bash ./INSTALL_ALL.sh
source ~/.bashrc
```

New tools will be automatically installed alongside existing ones. No breaking changes.

---

*Last updated: 2024-08-04*
