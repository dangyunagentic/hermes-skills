# GuardX Toolkit Install Recipe

Source: https://github.com/dhikadrian/guardx — repo contains a single `guardx.zip` (not loose files).

## Install
```bash
git clone --depth 1 https://github.com/dhikadrian/guardx.git /root/tools/guardx
cd /root/tools/guardx && unzip -oq guardx.zip
cd guardx && pip3 install --break-system-packages -r requirements.txt aiodns
```

## Verify
```bash
cd /root/tools/guardx/guardx
python3 guardv2.py --help     # vuln scanner + secret scanner
python3 guardx.py --list      # exploit catalog
```

## Layout (post-unzip)
```
guardx/
├── guardv2.py          # CLI: vuln scan (--scan-cve) + secret scan (local/GitHub)
├── guardvuln.py        # detection engine, 29+ checks
├── guardx.py           # auto-exploit engine
├── guardwaf.py         # WAF recon/bypass
├── guarddiscover.py    # subdomain discovery
├── guardtemplate.py    # nuclei-style YAML template engine
├── wp-dork.py / wp-async-scan.py / wp-verify.py / wp-helix3-scan.py  # mass dorking
├── templates/          # 8 YAML templates
└── third_party/
    ├── wp2shell/       # WP SQLi PoC: check|read|shell (CVE-2026-63030/60137)
    └── cve-2026-49049/ # Helix3 Joomla scanner (read-only)
```

## Environment
Add to ~/.hermes.env:
```bash
export GUARDX_DIR=/root/tools/guardx/guardx
export PATH=$PATH:$GUARDX_DIR
```

## Notes
- Repo returned 404 once mid-session, came back later — HEAD-check before concluding gone.
- wp2shell markers: `parse_path_failed`/`block_cannot_read` = VULNERABLE; `rest_batch_not_allowed` = PATCHED.
- WAF cookie handoff: warm up with cloudscraper, then export `WAF_COOKIE_JSON` + `WAF_UA`.
- Tranco mass scanning: download top-1m.csv.zip from tranco-list.eu first.
