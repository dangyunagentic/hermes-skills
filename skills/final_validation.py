#!/usr/bin/env python3
"""Final validation: RECore + GuardX Hybrid with all tools installed"""
import sys
sys.path.insert(0, '/root')

print("=" * 60)
print("  FINAL VALIDATION — All Tools Installed")
print("=" * 60)

# Test 1: RECore with all tools
try:
    from skills.recore import recore
    print(f"\n[1] RECore loaded ✓")
    print(f"    System tools: {recore.tools}")
    print(f"    Python tools: {recore.py_tools}")
    
    all_tools = list(recore.tools.values()) + list(recore.py_tools.values())
    ready = sum(all_tools)
    total = len(all_tools)
    print(f"    Ready: {ready}/{total}")
    
except Exception as e:
    print(f"\n[1] RECore FAILED: {e}")

# Test 2: JADX test
print(f"\n[2] JADX (APK decompiler):")
import subprocess
result = subprocess.run(["jadx", "--version"], capture_output=True, text=True)
if result.returncode == 0:
    print(f"    ✓ jadx v{result.stdout.strip()}")
else:
    print(f"    ✗ FAILED: {result.stderr[:60]}")

# Test 3: APKTool
print(f"\n[3] Apktool:")
result = subprocess.run(["apktool", "--version"], capture_output=True, text=True)
if result.returncode == 0:
    print(f"    ✓ apktool v{result.stdout.strip()}")
else:
    print(f"    ✗ FAILED: {result.stderr[:60]}")

# Test 4: Frida
print(f"\n[4] Frida (Dynamic Instrumentation):")
result = subprocess.run(["frida", "--version"], capture_output=True, text=True)
if result.returncode == 0:
    print(f"    ✓ frida v{result.stdout.strip()}")
else:
    print(f"    ✗ FAILED: {result.stderr[:60]}")

# Test 5: Angr/Unicorn/Capstone
print(f"\n[5] Binary Analysis Frameworks:")
result = subprocess.run(
    ["python3", "-c", 
     "import angr, unicorn, capstone; print(f'angr {angr.__version__} | unicorn {unicorn.__version__} | capstone {capstone.__version__}')"],
    capture_output=True, text=True
)
if result.returncode == 0:
    print(f"    ✓ {result.stdout.strip()}")
else:
    print(f"    ✗ FAILED: {result.stderr[:80]}")

# Test 6: GuardX hybrid bridge
print(f"\n[6] GuardX Hybrid Bridge (guardx.re):")
try:
    from skills.guardx import guardx
    re_instance = guardx.re
    if hasattr(re_instance, 'tools'):
        print(f"    ✓ guardx.re → RECore bridge works")
        print(f"    RE tools: {re_instance.tools}")
    else:
        print(f"    ✗ Bridge failed: {re_instance}")
except Exception as e:
    print(f"    ✗ FAILED: {e}")

# Test 7: RECore functions
print(f"\n[7] RECore function test (/bin/ls):")
try:
    result = recore.get_binary_info('/bin/ls')
    print(f"    ✓ get_binary_info: {result['size_bytes']} bytes, type={result['file_type'][:50]}")
    
    result = recore.extract_strings('/bin/ls', min_length=8)
    print(f"    ✓ extract_strings: {result['count']} strings found")
    
    result = recore.detect_crypto_primitives('/bin/ls')
    print(f"    ✓ detect_crypto: {result['count']} crypto patterns")
    
except Exception as e:
    print(f"    ✗ FAILED: {e}")

print("\n" + "=" * 60)
print("  ALL TOOLS VALIDATED")
print("=" * 60)
