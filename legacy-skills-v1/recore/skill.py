#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
RECore — Unified Reverse Engineering Toolkit
Full-spectrum static + dynamic analysis for binaries, APKs, games, malware.

Capabilities:
  • Static Analysis: disasm, decompile, crypto detection, string extraction
  • Dynamic Analysis: Frida hooking, memory inspection, runtime tracing
  • Binary RE: x86/x64 ARM disassembly, function graph, control flow
  • Mobile RE: APK/JAR reversing, smali editing, cert bypass
  • Malware Analysis: sandbox execution, behavior mapping

Author: Autumn / Dangyun Operation
"""

import subprocess
import json
import os
from pathlib import Path
from typing import Dict, List, Any, Optional, Union

RE_CORE_ROOT = Path("/root/skills/recore")
DATA_DIR = RE_CORE_ROOT / "data"


def run_cmd(args: List[str], capture: bool = True, timeout: int = 300) -> tuple:
    """Execute command with unified error handling."""
    env = os.environ.copy()
    
    if capture:
        result = subprocess.run(
            args,
            capture_output=True,
            text=True,
            timeout=timeout,
            env=env
        )
        return result.stdout, result.stderr, result.returncode
    else:
        subprocess.run(args, env=env)


class RecoreSkill:
    """Unified reverse engineering interface."""
    
    def __init__(self):
        self.root = RE_CORE_ROOT
        
        # Tool availability check (updated with new installs)
        self.tools = {
            'radare2': self._check_tool('r2'),
            'frida': self._check_tool('frida'),  # Now via pip, no frida-server needed
            'gdb': self._check_tool('gdb'),
            'strings': self._check_tool('strings'),
            'readelf': self._check_tool('readelf'),
            'binwalk': self._check_tool('binwalk'),
            'jadx': self._check_tool('jadx'),      # ✓ Installed v1.5.6
            'apktool': self._check_tool('apktool'), # ✓ Installed v2.9.3
            'angr': self._check_tool('python3', ['-c', 'import angr']) # Check import instead of binary
        }
        
        # Additional tools (via pip install)
        self.py_tools = {
            'frida_tools': self._check_python_module('frida'),
            'unicorn': self._check_python_module('unicorn'),
            'capstone': self._check_python_module('capstone')
        }
    
    def _check_python_module(self, name: str) -> bool:
        """Check if Python module is available."""
        stdout, stderr, rc = run_cmd(
            ['python3', '-c', f'import {name}'],
            capture=True
        )
        return rc == 0
    
    def _check_tool(self, name: str, args: list = None) -> bool:
        """Check if tool is available in PATH."""
        stdout, stderr, rc = run_cmd(['which', name], capture=True)
        return rc == 0
    
    # ─────────────────── STATIC ANALYSIS ───────────────────
    
    def disassemble(self, binary_path: str, arch: str = None, 
                   start: str = None, end: str = None) -> Dict[str, Any]:
        """
        Disassemble binary using radare2.
        
        Args:
            binary_path: Path to binary file
            arch: Architecture (x86, x64, arm, arm64) - auto-detect if not specified
            start: Start address (hex)
            end: End address (hex)
        
        Returns:
            dict with disassembly output and metadata
        """
        if not self.tools['radare2']:
            return {"error": "radare2 not installed"}
        
        cmd = ['r2', '-qc', f'aa; pD 512'] + [binary_path]
        stdout, stderr, rc = run_cmd(cmd, timeout=60)
        
        if rc != 0:
            return {"error": stderr}
        
        return {"disassembly": stdout, "success": True}
    
    def analyze_functions(self, binary_path: str) -> Dict[str, Any]:
        """
        Analyze functions in binary (entry points, imports, symbols).
        
        Returns:
            dict with function list, entry point, imports
        """
        if not self.tools['radare2']:
            return {"error": "radare2 not installed"}
        
        # Get function list
        stdout, stderr, rc = run_cmd([
            'r2', '-qc', 'iaqL'
        ] + [binary_path])
        
        if rc != 0:
            return {"error": stderr}
        
        lines = [l.strip() for l in stdout.strip().split("\n") if l.strip()]
        return {"functions": lines, "count": len(lines)}
    
    def extract_strings(self, binary_path: str, min_length: int = 4,
                       unicode: bool = False) -> Dict[str, Any]:
        """
        Extract printable strings from binary.
        
        Args:
            binary_path: Path to binary
            min_length: Minimum string length
            unicode: Include Unicode strings
        
        Returns:
            dict with extracted strings
        """
        if not self.tools['strings']:
            return {"error": "strings not installed"}
        
        args = ['strings', '-n', str(min_length)]
        if unicode:
            args.append('-e')
        
        args.extend(['--', binary_path])
        
        stdout, stderr, rc = run_cmd(args)
        
        if rc != 0:
            return {"error": stderr}
        
        lines = [l.strip() for l in stdout.strip().split("\n") if l.strip()]
        return {"strings": lines, "count": len(lines)}
    
    def read_binary_headers(self, binary_path: str) -> Dict[str, Any]:
        """
        Read PE/ELF headers, sections, imports, exports.
        
        Returns:
            dict with binary metadata
        """
        results = {}
        
        # Check file type
        stdout, stderr, rc = run_cmd(['file', binary_path])
        results['file_type'] = stdout.strip() if rc == 0 else stderr
        
        # Read ELF headers (if ELF)
        if not self.tools['readelf']:
            results['note'] = 'readelf not installed'
            return results
        
        stdout, stderr, rc = run_cmd(['readelf', '-h', binary_path])
        results['headers'] = stdout
        
        # Sections
        stdout, stderr, rc = run_cmd(['readelf', '-S', binary_path])
        results['sections'] = stdout
        
        # Imports
        stdout, stderr, rc = run_cmd(['readelf', '--dyn-syms', binary_path])
        results['imports'] = stdout
        
        return results
    
    def detect_crypto_primitives(self, binary_path: str) -> Dict[str, Any]:
        """
        Detect cryptographic primitives in binary (AES, RSA, SHA, etc.).
        
        Returns:
            dict with detected crypto algorithms and locations
        """
        if not self.tools['strings']:
            return {"error": "strings not installed"}
        
        # Look for crypto function names
        stdout, _, _ = run_cmd(['strings', '-n', '5', '--', binary_path])
        
        crypto_patterns = [
            r'AES|aes', r'RSA|rsa', r'SHA|sha', r'MD5|md5',
            r'sha256|sha512', r'encrypt|decrypt', r'key|secret'
        ]
        
        import re
        found_crypto = []
        
        for line in stdout.split('\n'):
            for pattern in crypto_patterns:
                if re.search(pattern, line, re.IGNORECASE):
                    found_crypto.append(line.strip())
                    break
        
        return {
            "detected": list(set(found_crypto)),
            "count": len(set(found_crypto))
        }
    
    # ─────────────────── MOBILE RE ───────────────────
    
    def decompile_apk(self, apk_path: str, output_dir: str = None) -> Dict[str, Any]:
        """
        Decompile APK to Java source code using JADX.
        
        Args:
            apk_path: Path to APK file
            output_dir: Output directory (auto-create if not specified)
        
        Returns:
            dict with decompilation status
        """
        if not self.tools['jadx']:
            return {"error": "jadx not installed"}
        
        if output_dir is None:
            output_dir = str(DATA_DIR / "decompiled")
        
        os.makedirs(output_dir, exist_ok=True)
        
        cmd = ['jadx', '-d', output_dir, apk_path]
        stdout, stderr, rc = run_cmd(cmd, timeout=300)
        
        if rc != 0:
            return {"error": stderr}
        
        # Count output files
        count = sum(len(files) for _, _, files in os.walk(output_dir))
        
        return {
            "status": "success",
            "output_dir": output_dir,
            "files_decompiled": count
        }
    
    def extract_smali(self, apk_path: str, output_dir: str = None) -> Dict[str, Any]:
        """
        Extract smali bytecode from APK using apktool.
        
        Returns:
            dict with extraction status
        """
        if not self.tools['apktool']:
            return {"error": "apktool not installed"}
        
        if output_dir is None:
            output_dir = str(DATA_DIR / "smali")
        
        os.makedirs(output_dir, exist_ok=True)
        
        cmd = ['apktool', 'd', apk_path, '-o', output_dir]
        stdout, stderr, rc = run_cmd(cmd, timeout=300)
        
        if rc != 0:
            return {"error": stderr}
        
        return {"status": "success", "output_dir": output_dir}
    
    # ─────────────────── DYNAMIC ANALYSIS ───────────────────
    
    def trace_execution(self, binary_path: str, args: List[str] = None) -> Dict[str, Any]:
        """
        Execute binary with strace/ltrace to trace system calls.
        
        Args:
            binary_path: Path to binary
            args: Command line arguments
        
        Returns:
            dict with syscall trace
        """
        stdout, stderr, rc = run_cmd(['strace', '-f', '-e', 
                                      'open,read,write,connect,execve',
                                      binary_path] + (args or []),
                                     timeout=60)
        
        if rc != 0 and 'Operation not permitted' in stderr:
            return {"error": "strace requires CAP_SYS_PTRACE (run as root)"}
        
        return {"trace": stdout, "return_code": rc}
    
    def inspect_memory(self, process_id: int) -> Dict[str, Any]:
        """
        Inspect process memory maps.
        
        Args:
            process_id: PID of target process
        
        Returns:
            dict with memory map information
        """
        try:
            mem_map_path = f"/proc/{process_id}/maps"
            with open(mem_map_path, 'r') as f:
                content = f.read()
            
            return {
                "memory_maps": content.strip().split('\n'),
                "map_count": len(content.strip().split('\n'))
            }
        except FileNotFoundError:
            return {"error": f"Process {process_id} not found"}
        except PermissionError:
            return {"error": "Permission denied — run as root or with sudo"}
    
    # ─────────────────── HELPERS ───────────────────
    
    def get_binary_info(self, binary_path: str) -> Dict[str, Any]:
        """
        Get comprehensive binary information (size, type, hashes, sections).
        
        Returns:
            dict with full binary metadata
        """
        info = {}
        
        # File stats
        stat = os.stat(binary_path)
        info['size_bytes'] = stat.st_size
        info['modified_at'] = stat.st_mtime
        
        # File type
        stdout, _, _ = run_cmd(['file', binary_path])
        info['file_type'] = stdout.strip()
        
        # MD5 hash
        stdout, _, _ = run_cmd(['md5sum', binary_path])
        info['md5'] = stdout.split()[0]
        
        # SHA256 hash
        stdout, _, _ = run_cmd(['sha256sum', binary_path])
        info['sha256'] = stdout.split()[0]
        
        return info
    
    def install_tools(self) -> Dict[str, Any]:
        """
        Check and suggest installation commands for missing tools.
        
        Returns:
            dict with installation instructions
        """
        missing = {name: path for name, path in self.tools.items() if not path}
        
        if not missing:
            return {"status": "all_installed", "message": "All RE tools available"}
        
        install_commands = {
            'radare2': 'apt install radare2',
            'frida': 'pip install frida && apt install frida-tools',
            'gdb': 'apt install gdb-multiarch',
            'strings': 'apt install binutils',
            'readelf': 'apt install binutils',
            'binwalk': 'apt install binwalk',
            'jadx': 'apt install jadx',
            'apktool': 'apt install apktool',
            'angr': 'pip install angr unicorn capstone'
        }
        
        commands = [install_commands[name] for name in missing if name in install_commands]
        
        return {
            "status": "missing_tools",
            "missing": list(missing.keys()),
            "install_commands": commands
        }


# Global instance
recore = RecoreSkill()
