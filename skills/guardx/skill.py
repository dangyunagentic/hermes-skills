#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GuardX Skill — Unified vulnerability scanning & exploit automation (Web + RE Hybrid)
Author: Autumn / Dangyun Operation

Core capabilities:
  • guardv2.py   → CVE scanning, secret detection, environment exposure
  • guardx.py    → Auto-exploit engine with WAF bypass (Cloudflare, Imunify360)
  • guarddiscover.py → Subdomain enumeration
  • wp-*         → WordPress mass dorking & Helix3 Joomla scanner
  • wp2shell     → WordPress SQLi RCE (CVE-2026-63030, CVE-2026-60137)
  
RE Hybrid Integration:
  • re.disassemble()      → Static binary disassembly (radare2)
  • re.extract_strings()  → String extraction from binaries
  • re.decompile_apk()    → APK decompilation (jadx/apktool)
  • re.trace_execution()  → System call tracing (strace)
  • re.detect_crypto()    → Crypto primitive detection
  • re.get_binary_info()  → Full binary metadata
"""

import subprocess
import sys
import json
import os
from pathlib import Path
from typing import Dict, List, Any, Optional, Union


GUARDX_ROOT = Path("/root/guardx")
GUARD_ENV_BIN = GUARDX_ROOT / "guardx_env" / "bin"
PYTHON_EXECUTABLE = GUARD_ENV_BIN / "python"


def run_guardx_cmd(args: List[str], capture: bool = True) -> tuple:
    """Execute GuardX command with venv activated."""
    cmd = [str(PYTHON_EXECUTABLE)] + args
    
    env = os.environ.copy()
    env["PATH"] = f"{GUARD_ENV_BIN}:{env['PATH']}"
    
    if capture:
        result = subprocess.run(
            cmd,
            cwd=str(GUARDX_ROOT),
            env=env,
            capture_output=True,
            text=True
        )
        return result.stdout, result.stderr, result.returncode
    else:
        subprocess.run(cmd, cwd=str(GUARDX_ROOT), env=env)


class GuardXSkill:
    """Unified interface untuk semua operasi GuardX dengan RE integration."""
    
    def __init__(self):
        self.root = GUARDX_ROOT
        
        # Lazy load RECore for hybrid operations
        self._recore = None
    
    @property
    def re(self):
        """Get RECore instance (lazy loaded)."""
        if self._recore is None:
            try:
                sys.path.insert(0, '/root')
                from skills.recore import recore
                self._recore = recore
            except ImportError as e:
                self._recore = {"error": f"RECore not found: {e}"}
        return self._recore
    
    # ─────────────────── SCAN OPERATIONS ───────────────────
    
    def scan(self, target: str, scan_cve: bool = False, force_https: bool = False) -> Dict[str, Any]:
        """Run vulnerability scan on web target."""
        args = [str(self.root / "guardv2.py"), str(target)]
        
        if scan_cve:
            args.append("--scan-cve")
        
        stdout, stderr, rc = run_guardx_cmd(args)
        
        if rc != 0:
            return {"error": stderr, "return_code": rc}
        
        try:
            data = json.loads(stdout)
            return {"success": True, "data": data}
        except json.JSONDecodeError:
            return {"raw_output": stdout, "stderr": stderr}
    
    def subdiscover(self, domain: str) -> Dict[str, Any]:
        """Enumerate subdomains for a base domain."""
        stdout, stderr, rc = run_guardx_cmd([
            str(self.root / "guarddiscover.py"),
            domain
        ])
        
        if rc != 0:
            return {"error": stderr}
        
        lines = [l.strip() for l in stdout.strip().split("\n") if l.strip()]
        return {"subdomains": lines, "count": len(lines)}
    
    def secret_scan(self, path_or_url: str, include_git: bool = False, 
                    include_history: bool = False) -> Dict[str, Any]:
        """Scan for exposed secrets in local folder or GitHub repository."""
        args = [str(self.root / "guardv2.py"), str(path_or_url)]
        
        if include_git:
            args.append("--include-git")
        if include_history:
            args.append("--include-history")
        
        stdout, stderr, rc = run_guardx_cmd(args)
        
        if rc != 0:
            return {"error": stderr}
        
        return {"raw_output": stdout}
    
    # ─────────────────── EXPLOIT OPERATIONS ───────────────────
    
    def exploit_list(self) -> Dict[str, Any]:
        """List all available exploits."""
        stdout, stderr, rc = run_guardx_cmd([
            str(self.root / "guardx.py"),
            "--list"
        ])
        
        if rc != 0:
            return {"error": stderr}
        
        exploits = [l.strip() for l in stdout.strip().split("\n") if l.strip()]
        return {"exploits": exploits}
    
    def exploit(self, target: str, vuln: Optional[str] = None, 
                cmd: Optional[str] = None, interactive: bool = False) -> Dict[str, Any]:
        """Auto-exploit detected vulnerabilities."""
        args = [str(self.root / "guardx.py"), str(target)]
        
        if vuln:
            args.extend(["--vuln", vuln])
        
        if cmd:
            args.extend(["--cmd", cmd])
        
        if interactive:
            args.append("--interactive")
        
        stdout, stderr, rc = run_guardx_cmd(args)
        
        if rc != 0:
            return {"error": stderr, "return_code": rc}
        
        return {"raw_output": stdout, "success": rc == 0}
    
    # ─────────────────── WORDPRESS MASS-DORKING ───────────────────
    
    def wp_dork(self, url: str) -> Dict[str, Any]:
        """Dork WordPress installation via search-engine-style probing."""
        stdout, stderr, rc = run_guardx_cmd([
            str(self.root / "wp-dork.py"),
            url
        ])
        
        if rc != 0:
            return {"error": stderr}
        
        return {"raw_output": stdout}
    
    def wp_async_scan(self, csv_path: str) -> Dict[str, Any]:
        """Mass scan WordPress installations from CSV file."""
        stdout, stderr, rc = run_guardx_cmd([
            str(self.root / "wp-async-scan.py"),
            csv_path
        ])
        
        if rc != 0:
            return {"error": stderr}
        
        return {"raw_output": stdout}
    
    def wp_helix3_scan(self, url: str) -> Dict[str, Any]:
        """Scan Joomla Helix3 template for CVE-2026-49049."""
        stdout, stderr, rc = run_guardx_cmd([
            str(self.root / "wp-helix3-scan.py"),
            url
        ])
        
        if rc != 0:
            return {"error": stderr}
        
        return {"raw_output": stdout}
    
    # ─────────────────── RAW EXECUTION ───────────────────
    
    def run_raw(self, script_name: str, args: List[str]) -> Dict[str, Any]:
        """Run any GuardX script directly."""
        script_path = self.root / script_name
        
        if not script_path.exists():
            return {"error": f"Script {script_name} not found"}
        
        return self._execute(script_path, args)
    
    def _execute(self, script: Path, args: List[str]) -> Dict[str, Any]:
        """Execute Python script with guardx environment."""
        stdout, stderr, rc = run_guardx_cmd([str(script)] + args)
        
        return {
            "output": stdout,
            "stderr": stderr,
            "return_code": rc,
            "success": rc == 0
        }


# Global skill instance
guardx_skill = GuardXSkill()
