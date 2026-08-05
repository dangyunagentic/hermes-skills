---
name: security-hunting
description: Use when hunting bugs on authorized targets.
version: "1.0.0"
author: Autumn / Community
category: red-teaming
tags: [bug-bounty, security, pentest, smart-contract, web-security, osint]
related_skills: [guardx-suite, reverse-skill, bountyforge]
---

# 🔍 Security Hunting — Master Skill

A unified interface for bug bounty hunting, smart contract auditing, and OSINT reconnaissance on **authorized targets only**. Integrates detection patterns, exploit validation, report generation, and forensics workflows.

---

## 🎯 Trigger Matrix

Load this skill when you encounter:
- Bug bounty platforms (HackerOne, Bugcrowd, Immunefi, Intigriti)
- Smart contract audits (EVM/Solidity, Solana/Move, ZKsync Era)
- OSINT/reconnaissance requests (attack surface mapping)
- Vulnerability hunting (IDOR, SSRF, XSS, RCE, reentrancy, oracle manipulation)
- Report writing/validation for submissions

---

## 📚 Knowledge Base Structure

This umbrella skill integrates multiple specialized domains. Load the named source skill for full detail:

### Domain 1: Web/App Bug Bounty
- 29+ CVE detection checks (Django DEBUG, Spring Actuator, PHPInfo, Git exposure, .env leaks)
- WAF bypass patterns (15 techniques)
- IDOR/BOLA, CSRF, SQLi, SSTI, XXE, GraphQL attacks
- ATO chains and credential stuffing playbooks
- Source: `bountyforge`, `src-hunter`, `bug-bounty-scraping-suite`

### Domain 2: Smart Contract Auditing
- **10 DeFi vulnerability classes**: accounting desync, access control, incomplete path, off-by-one, oracle manipulation, ERC4626 vaults, reentrancy, flash loans, signature replay, proxy bugs (full detail in `web3-bug-classes`)
- Protocol architecture analysis (yield aggregators, bridges, DEXs, lending)
- Static analysis via Slither + Aderyn + SWC detectors
- Source: `web3-start-here`, `web3-bug-classes`, `web3-solidity-audit-mcp`, `auditor-skill`

### Domain 3: OSINT Reconnaissance
- 5-stage pipeline: intake → recon → enum → hunt → report
- Asset-graph discipline and severity rubric
- Identity-fabric mapping + breach correlation
- Detectability tagging for evasion-aware probing
- Source: `osint-methodology`, `offensive-osint`, `github-archive`

### Domain 4: Exploit Validation & PoC
- Multi-stage validation pipeline to prevent hallucinated findings (`exploitability-validation`)
- Foundry PoC writing + DeFiHackLabs reproduction patterns (`web3-poc-foundry`)
- Dynamic instrumentation for sink confirmation (`frida`)

### Domain 5: Report Generation
- Immunefi/HackerOne triage format, 7-Question Gate before submit (`web3-triage-report`)
- CVSS scoring + impact validation
- Proof-of-concept documentation standards

---

## 🔧 Tool Integration

| Category | Tools | Location |
|----------|-------|----------|
| Web scanners | guardv2.py, nuclei, httpx, amass, subfinder | `/root/tools/guardx/guardx`, `~/go/bin/` |
| Auto-exploits | guardx.py, wp2shell | `/root/tools/guardx/guardx` |
| Smart contract | Slither, Aderyn, Echidna, Foundry | install per-audit |
| Dynamic analysis | Frida, rr, ghidra, radare2 | system-wide |
| Forensics | github-archive, wayback recovery | `raptor-skills/oss-forensics/*` |

**GuardX verification** (the original repo vanished once mid-session — always verify before relying on it):
```bash
cd /root/tools/guardx/guardx && python3 guardv2.py --help && python3 guardx.py --list
```
If missing, re-clone from https://github.com/dhikadrian/guardx (it is a zip inside the repo: `unzip guardx.zip`).

---

## ⚠️ Critical Safety Rules

1. **AUTHORIZATION ONLY** — scanning/exploitation requires explicit written permission.
2. **READ-ONLY SCANNING** — `--scan-cve` sends HTTP probes only (safe). Never run `--vuln` exploits on unapproved targets.
3. **WAF COOKIE HANDOFF** — for wp2shell, inject cookies via `WAF_COOKIE_JSON` env var after cloudscraper challenge completion.
4. **RATE LIMITS** — GitHub API: 60 req/hr without token. Use a token for bulk operations.
5. **PRE-SUBMIT GATE** — validate every finding with the 7-Question Gate before reporting (see `web3-triage-report`).

---

## 🚀 Quick Start Commands

```bash
# Web vulnerability scan (read-only)
python3 /root/tools/guardx/guardx/guardv2.py target.com --scan-cve

# WordPress SQLi check (non-destructive)
cd /root/tools/guardx/guardx/third_party/wp2shell && python3 -m wp2shell check https://target.com

# Full recon pipeline
amass enum -d target.com -o amass.txt
subfinder -d target.com -o subfinder.txt
cat amass.txt subfinder.txt | sort -u | httpx -o live.txt
katana -list live.txt -o urls.txt
nuclei -l live.txt -automatic-scan
```

---

## 📋 Known Pitfalls

- **Version-header false positives** — WordPress/Joomla version meta is not synced with patches. Verify with the `rest_batch_not_allowed` (patched) vs `parse_path_failed`/`block_cannot_read` (vulnerable) signatures.
- **GitHub username scan default** — guardv2 username mode defaults to 20 repos; raise `--max-repos` for full coverage.
- **WAF cookie injection failure** — Cloudflare/Imunify360 needs a warm-up probe first, then cookie handoff via `WAF_UA` + `WAF_COOKIE_JSON`.
- **Go multi-module install fails** — `go install a b c@latest` errors when packages come from different modules; install each tool in a separate `go install` call.
- **GitHub release 404s** — asset filenames drift between releases; resolve the real asset name via the releases API (`/releases/latest` → `assets[].name`) before downloading large binaries like Ghidra.
- **JADX zip layout** — the release zip extracts `bin/`+`lib/` at top level (no `jadx/` wrapper dir); symlink `/opt/jadx/bin/jadx` into `/usr/local/bin`.
- **GuardX repo disappeared once (404)** — came back later. Verify with a HEAD request before concluding it's gone.

---

## 🔄 Related Skills

- `raptor-skills/audit` — hypothesis-driven coverage gap reviews
- `code-understanding` — adversarial comprehension for vulnerability variants
- `exploitability-validation` — stop chasing hallucinated findings
- `guardx-suite` (docs) — companion doc for the installed GuardX toolkit
- `hermes-guardrail-bypass` — disable context scanning for trusted files (SOUL.md, AGENTS.md)

---

## 📌 Version History

- v1.0.0 (2026-08-05): Initial umbrella integrating bountyforge, web3-bug-bounty (11 skills), src-hunter, auditor-skill, osint-methodology clusters; captured GuardX zip-in-repo install layout and Go multi-module install pitfall.
