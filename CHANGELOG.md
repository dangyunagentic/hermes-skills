# Changelog — Hermes Skills Security Suite

**All significant changes to the repository are documented here.**

---

## [2026-08-05] - v2.0: All-in-One Backup + GitHub Scrape

### Major Restructure
- **121 SKILL.md** mirrored from live `~/.hermes/skills/` to `skills/` (proper directory structure)
- Flat v1 `.md` skills preserved in `legacy-skills-v1/` (36 files)
- **GuardX vendored** at `vendors/guardx.zip` — no external repo dependency anymore
  (github.com/dhikadrian/guardx sempat 404, sekarang hidup lagi; di-vendor biar aman)

### New Skills from GitHub Scrape
- **bountyforge** (237 stars) — all-round bug bounty orchestrator (EVM/Solana/Move/TRON + web/API + CI/CD + report H1/Bugcrowd/Immunefi)
- **src-hunter** — Chinese SRC/bug bounty, 19 attack class playbooks, 305 payloads, 88k+ WooYun cases
- **raptor-skills** (13 skills) — from gadievron/raptor: frida, rr-debugger, exploitability-validation, oss-forensics suite
- **web3-bug-bounty** (11 skills) — from cyfrin/web3-bug-bounty: bug-classes, poc-foundry, solidity-audit-mcp, triage-report, zksync defense study
- **onchain-narrative-research** — wallet forensics, narrative tracing, signal generation
- **solana-auditor** — 1346-item checklist, 131 attack vectors
- **osint-methodology + offensive-osint** — external red-team recon pipeline

### Installer v2 (INSTALL_ALL.sh)
- Fix Go multi-module issue: tools installed one-by-one (nuclei, subfinder, httpx, katana, amass)
- GuardX deployed from vendored zip (offline-ready)
- Ghidra 12.1.2 optional with prompt (--yes skips prompt)
- Skills deploy to `~/.hermes/skills` + auto-mirror profile dir
- Options: `--yes` (non-interactive), `--skip-heavy` (no Ghidra/RE frameworks)

### Memories Backup
- `memories/hermes-core/` — live mirror of `~/.hermes/memories/` (MEMORY.md + USER.md)
- MEMORY.md updated: GuardX status corrected (ALIVE, was dead 404), amass v4.2.0, 121 skills, token path

### Tools Installed (verified on this host)
| Tool | Version | Location |
|------|---------|----------|
| Go | 1.26.5 | /usr/local/go |
| nuclei | 3.11.0 | ~/go/bin |
| subfinder | 2.6.4 | ~/go/bin |
| httpx | 1.9.0 | ~/go/bin |
| katana | 1.6.1 | ~/go/bin |
| amass | 4.2.0 | ~/go/bin |
| radare2 | 5.5.0 | apt |
| JADX | 1.5.6 | /opt/jadx |
| Apktool | 2.9.3 | /opt/apktool |
| Ghidra | 12.1.2 | /opt/ghidra_12.1.2_PUBLIC |
| angr | 9.3.2 | pip |
| frida | 17.17.0 | pip |
| capstone | 5.0.9 | pip |
| pwntools | 4.15.0 | pip |
| GuardX | latest | ~/tools/guardx/guardx |

---

## [2026-08-04] - v1.x: GuardX + RECore Integration

### New Skills Added

#### GuardX Hybrid (Web Vuln + Exploit + RE Bridge)
- Full CVE scanning: 29+ checks including SQLi, XSS, RCE, Spring Actuator
- Auto-exploit engine: 123+ vulnerabilities with WAF bypass built-in
- Secret detection: GitHub repos, .env leaks, API keys, config files
- Mass dorking: WordPress + Joomla scanning with async support
- RE bridge: Integrated binary analysis via RECore skill

#### RECore Suite
- angr/unicorn/capstone integration
- Ghidra MCP bridge (3 repos analyzed)
- Browser fingerprint generator (browserforge + fpgen Go build)

#### Support Tools
- HAR capture suite + quickstart
- Captcha solver suite
- Reverse-skill auto-router

---

## [2026-08-03] - v1.0: Initial Release

- 17 offensive security skills (flat .md format)
- Basic installer scripts per-toolkit
- RE stack: radare2, gdb, binwalk, strace, ltrace
- Java stack: JADX, Apktool setup scripts
- Python RE frameworks install script
