# Hermes Skills — Full Backup & Offensive Security Toolkit

**All-in-one backup untuk Hermes Agent skills + offensive security toolchain.**

- **Skills**: 121 SKILL.md files
- **Tools**: GuardX (vendored), RE frameworks, bug bounty stack
- **License**: Educational / Authorized Testing Only
- **Updated**: 2026-08-05

---

## Install (One Command)

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

## What's Inside

### Skills (121 SKILL.md)

| Category | Count | Highlights |
|----------|-------|------------|
| **Bug Bounty / Pentest** | 7 | bountyforge, src-hunter (305 payloads), osint-methodology, offensive-osint |
| **Web3 / Smart Contract Audit** | 11 | web3-start-here → bug-classes → poc-foundry, solidity-audit-mcp (Slither+Aderyn), triage-report (Immunefi format) |
| **Solana Audit** | 1 | auditor-skill (1346 checklist items, 131 attack vectors) |
| **Onchain Research** | 1 | onchain-narrative-research (wallet forensics, narrative tracing) |
| **Raptor Framework** | 13 | frida, rr-debugger, exploitability-validation, oss-forensics suite |
| **Security Suite (backup v1)** | 17 | guardx-suite, recore-suite, reverse-skill router, ghidra x4, captcha-solver |
| **Built-in Hermes** | 67 | autonomous-ai-agents, creative, github, productivity, research, mlops |

### Tools (installed by INSTALL_ALL.sh)

| Tool | What |
|------|------|
| **GuardX** (vendored) | Web vuln scanner 29+ CVE, auto-exploit, wp2shell — `vendors/guardx.zip`, no external repo needed |
| **Go stack** | nuclei, subfinder, httpx, katana, amass (installed one-by-one, multi-module fix) |
| **RE stack** | radare2, gdb, binwalk, strace, ltrace |
| **Java stack** | JADX 1.5.6, Apktool 2.9.3, Ghidra 12.1.2 (JDK 21) |
| **Python frameworks** | angr, unicorn, capstone, frida, pwntools, browserforge, fpgen |

---

## Repo Structure

```
hermes-skills/
├── skills/              # 121 SKILL.md (mirror of ~/.hermes/skills)
├── legacy-skills-v1/    # Backup v1 flat .md skills
├── vendors/
│   └── guardx.zip       # Vendored GuardX (no external dep)
├── INSTALL_ALL.sh       # v2 all-in-one installer
├── INSTALLATION_GUIDE.md
├── QUICK_START.md
├── CHANGELOG.md
└── README.md
```

---

## Usage Guide (by focus)

| Focus | Start with |
|-------|-----------|
| Bug bounty web | `bountyforge`, `src-hunter` |
| Smart contract | `web3-start-here` → `web3-bug-classes` → `web3-poc-foundry` |
| Solana audit | `auditor-skill` |
| Onchain intel | `onchain-narrative-research` |
| RE binary/APK | `reverse-skill` (router) → `recore-suite` / ghidra skills |
| OSINT | `osint-methodology`, `offensive-osint` |

---

## Legal

ALL tools designed for **authorized security testing only**.
- Use on systems you own or have written permission to test
- Never scan networks/websites without authorization
- Follow responsible disclosure

---

## Update Flow

```bash
# Setelah install/edit skills baru di mesin:
cd hermes-skills
rsync -a --exclude='.*' ~/.hermes/skills/ skills/
git add -A && git commit -m "update: skills backup $(date +%Y-%m-%d)"
git push
```

Backup dikelola oleh Dangyun untuk Autumn.
