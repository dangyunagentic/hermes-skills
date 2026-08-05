# Complete Installation Guide — Hermes Skills Security Suite

**Updated 2026-08-05 (v2.0)**: 121 skills, vendored GuardX, all-in-one installer

---

## Requirements

- Linux (Debian/Ubuntu tested), root or sudo access
- ~3 GB disk (with Ghidra), ~1 GB without (`--skip-heavy`)
- Internet for first install (Go tools, JDK, Ghidra download)
- After install: fully offline-capable (GuardX vendored)

---

## Quick Start (One Command)

```bash
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh --yes
source ~/.bashrc
```

Options:
- `--yes` — non-interactive, install everything
- `--skip-heavy` — skip Ghidra + RE frameworks (faster)

---

## What the Installer Does (10 Steps)

1. **Python check** — python3 required
2. **Deploy skills** — copies 121 SKILL.md to `~/.hermes/skills/` (+ `~/.hermes/profiles/default/skills/` if exists)
3. **System packages** — radare2, gdb, binutils, binwalk, strace, ltrace, wget, curl, unzip (apt)
4. **JDK 21** — required by JADX, Apktool, Ghidra
5. **GuardX (vendored)** — extracts `vendors/guardx.zip` to `~/tools/guardx/`, installs Python deps (requests, aiohttp, aiofiles, colorama, etc + aiodns). No external repo dependency
6. **Python RE frameworks** — angr, unicorn, capstone, frida, frida-tools, pwntools, browserforge, fpgen + `fpgen fetch`
7. **Go + bug bounty tools** — installs Go if missing, then ONE BY ONE (multi-module fix):
   - nuclei (vuln scanner)
   - subfinder (subdomain enum)
   - httpx (host probing)
   - katana (crawler)
   - amass (OWASP, network mapping)
8. **JADX 1.5.6 + Apktool 2.9.3** — APK decompile + smali
9. **Ghidra 12.1.2** (optional, 547MB) — headless + GUI symlinks
10. **Environment** — writes `~/.hermes.env`, sources from `~/.bashrc`

---

## Manual Install (Step by Step)

If you prefer manual control:

### 1. Skills only
```bash
cp -r skills/* ~/.hermes/skills/
```

### 2. GuardX only
```bash
mkdir -p ~/tools/guardx
unzip -oq vendors/guardx.zip -d ~/tools/guardx
pip3 install --break-system-packages -r ~/tools/guardx/guardx/requirements.txt aiodns
```

### 3. Go tools only
```bash
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/owasp-amass/amass/v4/...@latest
```
Note: install one-by-one. Batch `go install a b c` fails with "All packages must be provided by the same module".

### 4. RE frameworks only
```bash
pip3 install --break-system-packages angr unicorn capstone frida frida-tools pwntools
```

---

## Verification

```bash
# Skills count
find ~/.hermes/skills -name "SKILL.md" | wc -l   # expect 121

# Go tools
nuclei -version && subfinder -version && httpx -version && katana -version && amass version

# RE stack
r2 -v && jadx --version && apktool --version && java -version

# GuardX
cd ~/tools/guardx/guardx && python3 guardv2.py --help | head -5

# Python frameworks
python3 -c "import angr, frida, capstone, unicorn; print('RE frameworks OK')"

# Environment
cat ~/.hermes.env
```

---

## Known Issues & Fixes

| Issue | Fix |
|-------|-----|
| `go install` multiple tools fails | Install one-by-one (installer v2 does this) |
| GuardX repo 404 | Irrelevant now — vendored in `vendors/guardx.zip` |
| Ghidra download slow | Use `--skip-heavy`, install later manually |
| `pip` refuses system install | Installer uses `--break-system-packages` |
| Skills not visible in Hermes | Restart gateway: `hermes gateway restart` |
| amass version old | Re-run `go install github.com/owasp-amass/amass/v4/...@latest` |

---

## Updating This Backup

```bash
cd hermes-skills
git pull
rsync -a --exclude='.*' ~/.hermes/skills/ skills/
cp ~/.hermes/memories/MEMORY.md memories/hermes-core/
cp ~/.hermes/memories/USER.md memories/hermes-core/
git add -A && git commit -m "sync: $(date +%Y-%m-%d)" && git push
```

---

## Legal

All tools for **authorized security testing only**. Use on systems you own or have written permission to test.
