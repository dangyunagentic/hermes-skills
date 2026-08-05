# 🔧 RECore Skill — Reverse Engineering Toolkit

**Version**: 1.0.0 | **Updated**: 2024-08-04  
**Type**: Static + Dynamic Analysis  
**Tools**: radare2, Frida, JADX, Apktool, Angr, Unicorn, Capstone

---

## Overview

RECore adalah unified reverse engineering toolkit yang mengintegrasikan static analysis (radare2, gdb), dynamic instrumentation (Frida), mobile RE (JADX, apktool), dan binary frameworks (angr, unicorn, capstone) dalam satu interface Python skill.

## Core Modules

| Module | Function | Status |
|--------|----------|--------|
| `get_binary_info()` | Size, hash, file type | ✅ |
| `extract_strings()` | String extraction from binaries | ✅ |
| `detect_crypto_primitives()` | Find AES/SHA/RSA patterns | ✅ |
| `read_binary_headers()` | ELF/PE section analysis | ✅ |
| `disassemble()` | radare2 disassembly | ✅ |
| `analyze_functions()` | Function graph, imports | ✅ |
| `decompile_apk()` | JADX APK → Java source | ✅ |
| `extract_smali()` | Apktool smali extraction | ✅ |
| `trace_execution()` | strace/ltrace syscall tracing | ✅ |
| `inspect_memory()` | /proc/PID/maps inspection | ✅ |

## Static Analysis

### Binary Information
```python
from skills.recore import recore

info = recore.get_binary_info('/bin/ls')
print(f"Size: {info['size_bytes']} bytes")
print(f"MD5:  {info['md5']}")
print(f"SHA256: {info['sha256']}")
print(f"Type: {info['file_type'][:80]}...")
```

### String Extraction
```python
# Extract printable strings
strings = recore.extract_strings('/path/to/binary', min_length=6)
print(f"Found {strings['count']} strings")
print(f"Sample: {strings['strings'][:10]}")
```

### Crypto Detection
```python
crypto = recore.detect_crypto_primitives('/malware.bin')
print(f"Detected: {crypto['count']} crypto patterns")
print(f"Algorithms: {crypto['detected'][:5]}")
# Examples: sha256sum, aes_encrypt, RSA_key, SHA_CTX
```

### Header Analysis
```python
headers = recore.read_binary_headers('/path/to/elf')
print(headers['sections'])  # .text, .data, .rodata, etc.
print(headers['imports'])   # libc.so functions
```

## Dynamic Analysis

### Syscall Tracing
```python
trace = recore.trace_execution('/binary/path', ['--flag', 'arg1'])
print(trace['trace'][:500])  # First 500 lines of strace output
```

### Memory Inspection
```python
mem = recore.inspect_memory(pid=1234)
print(mem['memory_maps'][:10])  # First 10 memory regions
```

## Mobile RE

### APK Decompilation
```python
result = recore.decompile_apk('/app.apk', output_dir='/tmp/decompiled')
print(f"Decompiled {result['files_decompiled']} files to {result['output_dir']}")
```

### Smali Extraction
```python
smali = recore.extract_smali('/app.apk')
print(f"Smali output: {smali['output_dir']}")
```

## CLI Quick Commands

```bash
# Get binary info
recore-getinfo /path/to/binary

# Extract strings
recore-extract-strings /path/file --min-len 6

# Decompile APK
recore-decompile-apk app.apk --output /tmp/apk

# Detect crypto
recore-detect-crypto malware.exe

# Trace execution
recore-trace binary arg1 arg2
```

## Tool Status

### Installed & Ready
- ✅ radare2 (disassembly)
- ✅ gdb (debugging)
- ✅ binutils (strings/readelf)
- ✅ binwalk (firmware carving)
- ✅ strace/ltrace (syscall tracing)
- ✅ JADX v1.5.6 (APK decompiler)
- ✅ Apktool v2.9.3 (smali)
- ✅ Frida v17.16.4 (dynamic hooking)

### Optional (prompt-based install)
- ⚠️ angr (binary analysis framework)
- ⚠️ unicorn (emulator)
- ⚠️ capstone (disassembly engine)

### Not Available (pip blocked)
- ❌ Unicorn/capstone modules (install manually if needed)
- ❌ Full angr suite (install via pip)

## Hybrid Workflow

```
scan web → find binary download
  → guardx.exploit(vuln='backup')
    → save binary to /tmp/malware
      → recore.get_binary_info('/tmp/malware')
        → recore.extract_strings(min_len=10)
          → Found API key in string
            → recore.detect_crypto()
              → Found AES encryption routine
                → recore.disassemble() → analyze crypto
```

## Use Cases

### Malware Analysis Pipeline
1. `get_binary_info()` → Check size/type/hash
2. `extract_strings()` → Find suspicious URLs/commands
3. `detect_crypto()` → Identify encryption algorithms
4. `trace_execution()` → Monitor system calls

### Firmware Reverse Engineering
1. `binwalk` extract filesystem
2. `extract_strings()` → Find hardcoded creds
3. `disassemble()` → Analyze boot logic
4. `trace_execution()` → Simulate boot sequence

### APK Security Audit
1. `decompile_apk()` → Java source code
2. `extract_smali()` → Find obfuscated methods
3. `detect_crypto()` → Check weak crypto
4. `grep` for secrets → Hardcoded API keys

## Verification

```bash
# Test basic function
python3 -c "from skills.recore import recore; print(recore.get_binary_info('/bin/ls'))"

# Validate tools
which r2 gdb jadx apktool frida

# Full validation
guardx-quickstart.sh validate
```
