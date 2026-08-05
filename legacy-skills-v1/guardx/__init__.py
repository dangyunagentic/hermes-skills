#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GuardX Skill Specification — Hybrid Edition (Web Vuln + RE)

Description:
  Unified offensive security toolkit combining web vulnerability scanning & exploit 
  automation with reverse engineering capabilities.

Core Modules — Web (GuardX):
  - guardv2.py      : Vulnerability scanner (29+ checks), secret detector
  - guardx.py       : Auto-exploit engine (29 exploits), WAF solver built-in
  - guarddiscover.py: Subdomain discovery via CT logs + DNS enumeration
  - wp-dork.py      : WordPress reconnaissance via search-engine dorking
  - wp-async-scan.py: Async mass scanner (15x faster than synchronous)
  - wp-helix3-scan.py: Joomla Helix3 CVE-2026-49049 scanner
  - wp-verify.py    : Batch verifier (wp2shell integration)

Core Modules — RE (RECore):
  - radare2         : Static disassembly, function analysis, binary inspection
  - binwalk         : Firmware extraction, embedded file carving
  - strings/readelf : String extraction, ELF header analysis
  - gdb              : Debugging, breakpoint analysis
  - strace/ltrace   : Syscall tracing, library call monitoring

Capabilities — Web:
  • CVE Scanning: Spring Actuator, WP SQLi, Django debug, PHPInfo, JWT attacks
  • Secret Detection: GitHub repos, local folders, .env, config files, API keys
  • Auto-Exploit: sqlmap-style RCE, wp2shell webshell deployment, interactive shells
  • WAF Bypass: Cloudflare Turnstile/UAM, Imunify360, Akamai bot protection
  • Mass Dorking: Parallel scanning from CSV, async HTTP/3 support

Capabilities — RE:
  • Static Analysis: x86/x64/ARM disassembly, function graph, control flow
  • Dynamic Analysis: Memory inspection, runtime tracing, syscall monitoring
  • Mobile RE: APK decompilation, smali editing, cert pinning bypass
  • Binary Inspection: crypto primitive detection, string extraction, header analysis

Hybrid Workflow:
  1. GuardX web scan finds exposed binary/firmware download (e.g. backup exploit)
  2. RECore analyzes extracted binary → find hardcoded creds, crypto keys
  3. GuardX auto-exploit uses found creds → gain shell
  4. RECore hooks live process on compromised host → extract runtime secrets

Usage Examples:
  # Web operations
  guardx.scan('target.com', scan_cve=True)
  guardx.exploit(target='site.com', vuln='wp2shell', interactive=True)
  guardx.subdiscover('example.com')
  
  # RE operations (via hybrid bridge)
  guardx.re.disassemble('/path/to/binary')
  guardx.re.extract_strings('/path/to/file.bin')
  guardx.re.decompile_apk('/app.apk')
  guardx.re.trace_execution('/binary/path')
  guardx.re.detect_crypto('/binary')
  guardx.re.get_binary_info('/binary')
"""

from .skill import guardx_skill as guardx

__all__ = ["guardx"]
