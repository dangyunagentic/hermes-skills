# Quick Start Guide — Hermes Skills Security Suite

**Updated 2026-08-05 (v2.0)**: 121 skills, vendored GuardX, all-in-one installer

---

## One-Command Install

```bash
git clone https://github.com/dangyunagentic/hermes-skills.git
cd hermes-skills
bash ./INSTALL_ALL.sh --yes
source ~/.bashrc
```

Done. 121 skills deployed, all tools installed.

Options:
- `--yes` — non-interactive, install everything including Ghidra
- `--skip-heavy` — skip Ghidra (547MB) + RE frameworks (faster, ~5 min)

---

## What You Get

### Skills (121 SKILL.md)
Deployed to `~/.hermes/skills/` (+ profile dir if exists).

Top picks by focus:

| Focus | Skills |
|-------|--------|
| Bug bounty web | bountyforge, src-hunter |
| Smart contract audit | web3-start-here → web3-bug-classes → web3-poc-foundry |
| Solana audit | solana-auditor (auditor-skill) |
| Onchain intel | onchain-narrative-research |
| RE binary/APK | reverse-skill (router) → recore-suite / ghidra skills |
| OSINT | osint-methodology, offensive-osint |
| Dynamic instrumentation | raptor-skills/frida |
| Exploit validation | raptor-skills/exploitability-validation |

### Tools
| Stack | Tools |
|-------|-------|
| Go (bug bounty) | nuclei, subfinder, httpx, katana, amass |
| RE system | radare2, gdb, binwalk, strace, ltrace |
| Java (mobile/RE) | JDK 21, JADX 1.5.6, Apktool 2.9.3, Ghidra 12.1.2 |
| Python (RE frameworks) | angr, unicorn, capstone, frida, pwntools |
| Fingerprint | browserforge, fpgen |
| Web exploit | GuardX (vendored, offline-ready) |

---

## Verify Install

```bash
# Skills
find ~/.hermes/skills -name "SKILL.md" | wc -l   # expect 121

# Go tools
nuclei -version && subfinder -version && amass version

# RE stack
r2 -v && jadx --version && apktool --version

# GuardX
cd ~/tools/guardx/guardx && python3 guardv2.py --help | head -5

# Python frameworks
python3 -c "import angr, frida, capstone; print('RE frameworks OK')"
```

---

## Update Skills Later

```bash
cd hermes-skills
rsync -a --exclude='.*' ~/.hermes/skills/ skills/
cp ~/.hermes/memories/MEMORY.md memories/hermes-core/
cp ~/.hermes/memories/USER.md memories/hermes-core/
git add -A && git commit -m "sync: $(date +%Y-%m-%d)" && git push
```

---

## Notes

- GuardX vendored: install works even if github.com/dhikadrian/guardx goes down again
- Amass installed one-by-one (Go multi-module fix)
- Ghidra download is 547MB — use `--skip-heavy` on slow connections
- All tools for authorized security testing only
