# Vetted GitHub Skill Sources (2026-08-05)

Repos verified to contain proper SKILL.md format (directly installable to `~/.hermes/skills/<name>/SKILL.md`) and safe content. Clone → copy SKILL.md dirs → verify frontmatter starts with `---`.

## Bug Bounty / Web Security
| Repo | Stars | Content | Install pattern |
|------|-------|---------|-----------------|
| Gabson0x/bountyforge | ~240 | All-round bounty skill: EVM/Solana/TRON audits, web/API, CI/CD, LLM security, report gen | Single root SKILL.md |
| MyuriKanao/src-hunter-skill | ~600 | Chinese SRC playbooks: 19 attack classes, 305 payloads, 263 WAF bypasses, 2887 H1 cases | Single root SKILL.md |
| elementalsouls/Claude-OSINT | ~2200 | 2 skills under `skills/`: osint-methodology, offensive-osint | Copy each subdir |
| shuvonsec/web3-bug-bounty-hunting-ai-skills | ~120 | 11 web3-* skills built from 2749 Immunefi reports | Copy each subdir, all have frontmatter |
| transilienceai/communitytools | ~450 | Offensive pentest skills + slash commands | Check structure first |
| 0xGhostCAT/claude-ai-cyber-security-skills | ~30 | 30 skills for HackerOne/Bugcrowd | Check structure first |

## Reverse Engineering / Exploit Dev
| Repo | Stars | Content | Install pattern |
|------|-------|---------|-----------------|
| gadievron/raptor | ~3500 | 13 skills: frida, rr-debugger, code-understanding, exploitability-validation, audit, oss-forensics/* | Copy `.claude/skills/*` as-is (proper frontmatter) |
| SnailSploit/Claude-Red | ~2800 | Curated offensive skill library | Verify URL spelling; 404'd once |
| Masriyan/Claude-Code-CyberSecurity-Skill | ~260 | 15 cybersecurity skills | Check structure first |

## Onchain / Crypto
| Repo | Stars | Content | Install pattern |
|------|-------|---------|-----------------|
| hahahakang/onchain-narrative-research-skill | small | Wallet/narrative forensics, signal design, source library | Root dir has SKILL.md + references/ |
| solanabr/auditor-skill | ~50 | Solana program audit skill (1346 checklist items) | Single root SKILL.md |
| LoreResearch/Lore | ~25 | DeFi protocol research agent (Solana) | Check structure |

## Directories / Meta
- 0xNyk/awesome-hermes-agent (~5200) — independent directory of Hermes skills/plugins
- heilcheng/awesome-agent-skills (~6000) — cross-platform skill directory
- shuvonsec/public-skills-builder (~210) — GENERATES bug bounty skills from public HackerOne reports (use for expanding the library)

## Search recipes (GitHub API, unauth = 10 req/min)
```
q=bug bounty skill claude SKILL&sort=stars
q=SKILL.md smart contract OR solidity OR web3&sort=stars
q=claude skill security offensive&sort=stars
q=hermes-agent skill security&sort=stars
```

## Anti-patterns seen
- Flat `*.md` files are NOT picked up by the skill loader — must be `category/name/SKILL.md`.
- Repos with only a README + zip (like dhikadrian/guardx) need unzip before install.
- Some repos 404 intermittently (rate limiting or private toggle); verify with HEAD request, retry later.
