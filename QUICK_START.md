# 🚀 Hermes Skills Quick Start Guide

## ⚡ 60-Second Setup

### Option 1: One-Command Install (Recommended)
```bash
git clone https://github.com/YOUR_USERNAME/hermes-skills.git
cd hermes-skills
chmod +x INSTALL_ALL.sh
./INSTALL_ALL.sh
```

### Option 2: Manual Install
```bash
# Copy skills and memories
cp -r skills ~/.hermes/profiles/default/
cp -r memories ~/.hermes/profiles/default/

# Build FPGen server
export PATH=$PATH:/usr/local/go/bin
go build -o ~/bin/fp-server source-repos/FPGen-dhikadrian/fingerprint-data/fingerprint-generator/cmd/server/

# Start server
~/bin/fp-server --port 8800 &
```

---

## 🎯 Common Commands

### Bug Bounty Tools
```bash
# View help
bb-quickstart.sh help

# Run reconnaissance on test domain
bb-quickstart.sh recon example.com

# Vulnerability scan
bb-quickstart.sh scan example.com
```

### Fingerprint Generation
```python
# Python usage
from browserforge.fingerprints import FingerprintGenerator
fp = FingerprintGenerator().generate()
print(fp.navigator.userAgent)

# HTTP API
curl "http://127.0.0.1:8800/fingerprint?count=5&pretty=true"
```

### Ghidra MCP
```bash
# Start Ghidra MCP server
~/.hermes/profiles/default/skills/ghidra-mcp-launch.sh

# Test connection
nuclei -version  # Should show tool available
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Complete overview and features |
| `INSTALLATION_GUIDE.md` | Detailed installation steps |
| `skills/*.md` | Tool-specific documentation |
| `memories/*install*.md` | Installation records with dates |
| `memories/*improvements.md` | Lesson learned tracking |

---

## ✅ Verification Checklist

After installation, verify everything works:

```bash
# Check tools
go version && python3 --version && docker --version

# Test fingerprints
curl http://127.0.0.1:8800/health

# Verify installation
ls ~/.hermes/profiles/default/skills/*.md | wc -l
ls ~/.hermes/profiles/default/memories/*.md | wc -l
```

Should show:
- ✅ Go installed
- ✅ Python 3.8+ available
- ✅ Health check returns `{status:"ok"}`
- ✅ ~48 skill/memory files present

---

## 🔐 Legal Reminder

**USE THESE TOOLS ONLY ON AUTHORIZED SYSTEMS!**

- ✅ Use on systems you own
- ✅ Use with explicit written authorization
- ❌ Never scan unauthorized targets
- ❌ Never use for illegal activities

By using this software, you agree to follow ethical guidelines and local laws.

---

## 🆘 Need Help?

- Read `INSTALLATION_GUIDE.md` for detailed troubleshooting
- Check `memories/*improvements.md` for known issues and solutions
- Open GitHub issue if problems persist

---

<div align="center">

**Happy Security Testing! 🛡️**

**Hermes Skills - Professional Security Suite**

</div>
