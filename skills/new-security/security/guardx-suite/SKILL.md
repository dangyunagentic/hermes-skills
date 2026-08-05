---
name: guardx-suite
description: Offensive security tools for 🛡️ GuardX Skill — Web Vulnerability Scanner & Exploit Aut...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

# 🛡️ GuardX Skill — Web Vulnerability Scanner & Exploit Automation

**Version**: 1.0.0 | **Updated**: 2024-08-04  
**Type**: Hybrid (Web Vuln + Exploit + RE Bridge)  
**Source**: [dhikadrian/guardx](https://github.com/dhikadrian/guardx)

---

## Overview

GuardX adalah full-spectrum offensive security toolkit untuk vulnerability scanning, exploit automation, dan secret detection. Dilengkapi WAF bypass built-in (Cloudflare, Imunify360) dan integrasi RECore untuk binary analysis.

## Core Modules

| Module | Function |
|--------|----------|
| `guardv2.py` | Vulnerability scanner (29+ checks), secret detector |
| `guardx.py` | Auto-exploit engine (123+ exploits), WAF solver |
| `guarddiscover.py` | Subdomain discovery via CT logs + DNS |
| `wp-dork.py` | WordPress reconnaissance via dorking |
| `wp-async-scan.py` | Async mass scanner (15x faster) |
| `wp-helix3-scan.py` | Joomla Helix3 CVE-2026-49049 scanner |
| `wp-verify.py` | Batch verifier (wp2shell integration) |

## Detection Coverage

### Critical
- PHPInfo exposure
- Django DEBUG=True
- Spring Actuator heapdump
- Git exposure (.git/config)
- .env file leaks
- WP SQLi (CVE-2026-63030, CVE-2026-60137)
- Langflow RCE (CVE-2025-3248)
- Wazuh RCE (CVE-2025-24016)
- Ivanti overflow (CVE-2025-22457)
- NextJS auth bypass (CVE-2025-29927)
- PHPUnit RCE (CVE-2017-9841)

### High
- Laravel Debug Bar
- Symfony Profiler
- CGI scripts
- WordPress user enum
- CORS reflection
- Database admin (phpMyAdmin/Adminer)

### Medium
- Open redirect
- CORS wildcard
- robots.txt sensitive paths
- XML-RPC DoS risk

## Python API

```python
from skills.guardx import guardx

# Vulnerability scan
result = guardx.scan('target.com', scan_cve=True)

# Subdomain enumeration
subs = guardx.subdiscover('example.com')

# Auto-exploit
guardx.exploit(target='site.com', vuln='wp2shell', interactive=True)

# Secret detection
secrets = guardx.secret_scan('github.com/user/repo', include_git=True)

# WordPress mass dorking
guardx.wp_dork('wordpress-site.com')
guardx.wp_async_scan('targets.csv')

# RE bridge (hybrid)
guardx.re.disassemble('/path/to/binary')
guardx.re.extract_strings('/path/to/file', min_length=8)
guardx.re.detect_crypto_primitives('/path/to/binary')
```

## CLI Usage

```bash
# Vulnerability scan
python3 guardv2.py target.com --scan-cve

# Auto-exploit
python3 guardx.py target.com
python3 guardx.py target.com --vuln wp2shell --interactive
python3 guardx.py target.com --vuln langflow --cmd "whoami"

# Secret scan
python3 guardv2.py github.com/username/repo --include-git
python3 guardv2.py /local/path

# List exploits
python3 guardx.py --list
```

## Hybrid Workflow

```
guardx.scan() → finds backup leak
  → guardx.exploit(vuln='backup') → downloads binary
    → guardx.re.extract_strings() → finds API keys
      → guardx.re.detect_crypto() → finds AES key
        → guardx.re.disassemble() → analyze crypto routine
```

## WAF Bypass

All exploits in guardx.py automatically:
1. Use cloudscraper → bypass Cloudflare challenge
2. Detect Imunify360 blocks
3. Rotate user-agents
4. Handle cookie handoffs

## Dependencies

- Python 3.10+
- requests, cloudscraper, aiohttp, PyYAML
- System: wget, curl, git, file
