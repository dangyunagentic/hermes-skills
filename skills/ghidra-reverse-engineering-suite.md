---
name: ghidra-reverse-engineering-suite
description: Complete Ghidra reverse engineering suite - NSA's flagship SRE framework for binary analysis, disassembly, decompilation, and program graphing. Supports 50+ architectures (x86/x64/ARM/MIPS/RISC-V/PowerPC/Sparc/etc), multiple executable formats (PE/ELF/Mach-O/APK/ELF), automated scripting with Python/Java, team collaboration features, and custom extension development. Used for malware analysis, vulnerability research, CTF challenges, and firmware reverse engineering.
version: "1.0.0"
author: Dangyun (Ghidra integration from NSA)
source: 
  - https://github.com/NationalSecurityAgency/ghidra
---

# Ghidra Reverse Engineering Suite

## Purpose
Complete reverse engineering toolkit from NSA (National Security Agency) for advanced binary analysis. Ghidra provides disassembly, decompilation, program graphing, assembly, and scripting capabilities across 50+ processor architectures and multiple executable formats. Supports both interactive GUI mode and fully automated CLI operation for large-scale RE operations.

**Why this matters:** Ghidra is the industry-standard tool for serious reverse engineering work. Combined with angr/pwndbg/pwntools from earlier integration, this creates complete RE arsenal from simple binary analysis to enterprise-grade malware research.

---

## Trigger Keywords
- "ghidra", "disassemble", "decompile", "reverse engineer binary"
- "malware analysis", "firmware dump", "extract strings"
- "program graph", "control flow", "decipher binary"
- "automated RE", "batch processing", "script Ghidra"

---

## Core Features Merged

### 1. **Multi-Architecture Support** (50+ Processors)
Ghidra supports every major architecture used in modern computing:
- **x86/x64**: Intel, AMD processors (primary use case)
- **ARM/ARM64**: Mobile devices, IoT, Raspberry Pi, iOS
- **MIPS**: Embedded systems, routers, game consoles
- **RISC-V**: Emerging embedded platforms
- **PowerPC**: Game consoles, legacy servers
- **SPARC**: Enterprise servers, Unix workstations
- **MIPS32/64**: Gaming (PlayStation, Nintendo Wii)
- **SH**: Legacy systems, automotive
- **TMS320**: Digital signal processors
- **Java bytecode**: JVM applications, Android APKs
- **And 30+ more exotic architectures**

Each architecture has:
- Complete instruction set decoding
- Architecture-specific calling conventions
- Platform-aware decompiler output
- Custom scripting hooks

### 2. **Disassembly & Decompilation Engine**
- **Interactive Disassembler**: Full-featured hex view with real-time assembly
- **Decompiler**: Converts assembly back to readable C-like pseudocode
- **Program Graphs**: Control flow graphs, call graphs, data dependency graphs
- **Symbolic Execution**: Cross-reference tracking between functions/data
- **Pattern Matching**: Find common code patterns across binaries
- **Function Analysis**: Automatic function identification, prologue/epilogue detection

**Decompiler Features:**
- Pseudocode generation for 50+ architectures
- Variable renaming suggestions
- Type inference from decompiled code
- Function signature reconstruction
- Memory aliasing detection

### 3. **Automated Scripting & Extension Development**
Two primary scripting languages:

#### Python Scripting (PyGhidra)
```python
from ghidra.app.script import GhidraScript

class MyAnalysis(GhidraScript):
    def run(self):
        # Get current program
        program = currentProgram
        
        # Analyze all functions
        for func in currentProgram.getFunctionManager().getFunctions(True):
            name = func.getName()
            start = func.getOffset()
            
            # Export function to file
            self.println(f"Analyzing: {name} at {hex(start)}")
            
            # Run custom analysis
            if "encrypt" in name.lower():
                self.println("[+] Potential encryption routine found!")
        
        # Save results
        self.println("Analysis complete")
```

#### Java Extension Development
- Full IDE support (Eclipse or VS Code)
- Extend core Ghidra functionality
- Create custom analysis tools
- Build plugin frameworks
- Develop user interface components

### 4. **Collaboration & Team Features**
- **Project Sharing**: Multi-user collaborative analysis
- **Version Control**: Track changes across team members
- **Comment System**: Add notes to functions, addresses, bytes
- **Task Assignment**: Delegate specific analysis tasks
- **Synchronized Database**: Real-time sync across team instances
- **Export Reports**: Generate professional RE reports

### 5. **File Format Support**
- **Windows PE**: Executables, DLLs, drivers
- **Linux ELF**: Binaries, shared libraries, kernels
- **macOS Mach-O**: Darwin executables, frameworks
- **Android APK**: DEX bytecode, native libraries
- **EFI Firmware**: UEFI boot loaders, runtime services
- **Game ROMs**: Various console formats
- **Custom Binary Formats**: Any format with proper loader plugins

### 6. **Advanced Analysis Tools**
- **String Extraction**: Find all hardcoded strings, Unicode/text data
- **Import/Export Analysis**: Identify linked libraries, entry points
- **API Hook Detection**: Find system calls, Windows APIs
- **Heap Structure Analysis**: Parse complex memory structures
- **Cryptographic Detection**: Identify crypto routines, key handling
- **Anti-Debug Detection**: Spot obfuscation techniques
- **Packed Binary Detection**: Detect UPX, ASPack, other packers

---

## Installation Status

### Pre-installed ✅
- Java 21 (`java -version` confirmed working)
- Gradle wrapper available in GHIDRA repository

### Needs Manual Setup ⚠️
- Download official release ZIP (requires network access)
- OR build from source (requires JDK 25 - newer than what we have)

### Quick Install (Download Mode - Recommended)
```bash
# Download latest stable release
cd /opt
wget "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.0_PUBLIC/ghidra_12.0_PUBLIC.zip"
unzip ghidra_12.0_PUBLIC.zip
chmod +x ghidra_12.0_PUBLIC/support/ghidraRun
./ghidra_12.0_PUBLIC/support/ghidraRun
```

### Build from Source (Alternative)
```bash
# Clone repository (already done at /root/tools/ghidra_repo)
cd /root/tools/ghidra_repo

# Install JDK 25 (upgrade from current JDK 21)
# Then run:
gradle buildGhidra

# Results go to: build/dist/ghidra_<version>.zip
```

### Workaround: Use Older Release Version
Since JDK 21 < JDK 25 required for source build:
- Use Ghidra 11.2.x series (built with JDK 17/21 compatible)
- Download `ghidra_11.2.5_PUBLIC.zip` instead of latest
- Full functionality retained for most use cases

---

## Usage Examples

### Example 1: Interactive GUI Analysis
```bash
# Launch Ghidra GUI
cd /opt/ghidra_11.2.5_PUBLIC
./support/ghidraRun

# In GUI:
# 1. Create new project: File → New Project → Non-shared project
# 2. Import binary: File → Import File → Select your_binary
# 3. Auto-analyze: Right-click binary → Analyze
# 4. View disassembly: Double-click imported file
# 5. View decompiler: Click "Decompile" tab on right side
# 6. Extract strings: List → Strings (shows all hardcoded text)
```

### Example 2: Automated CLI Analysis
```bash
# Run headless analysis (no GUI)
cd /opt/ghidra_11.2.5_PUBLIC/support
./analyzeHeadless /tmp/projects MyProject \
  --open /path/to/binary \
  --deleteFirst \
  --scriptPath /root/.hermes/profiles/default/scripts/ghidra/ \
  -script StringsExtractor.java \
  -scriptOutput /tmp/output.txt

# Or run Python script via PyGhidra:
./support/pyghidraRun -headless \
  -project_path /tmp/projects \
  -script my_analysis.py \
  /path/to/binary
```

### Example 3: Custom Python Script
Create script at `/root/.hermes/profiles/default/scripts/ghidra/crypto_detector.py`:
```python
from ghidra.app.script import GhidraScript
from ghidra.program.model.listing import Instruction
import re

class CryptoDetector(GhidraScript):
    """Detect cryptographic functions using heuristics"""
    
    def run(self):
        program = currentProgram
        fm = currentProgram.getFunctionManager()
        
        crypto_patterns = [
            'encrypt', 'decrypt', 'cipher', 'hash', 'md5', 'sha',
            'aes', 'rsa', 'des', 'cbc', 'ecb', 'gcm'
        ]
        
        matches = []
        
        for func in fm.getFunctions(True):
            name = func.getName().lower()
            
            # Pattern matching
            for pattern in crypto_patterns:
                if pattern in name:
                    matches.append({
                        'name': func.getName(),
                        'address': hex(func.getEntryPoint()),
                        'size': func.getBody().numAddresses()
                    })
                    
                    # Also check body content
                    listing = program.getListing()
                    for instr in listing.getInstructionsInRange(func.getBody()):
                        mnem = instr.getMnemonicString().lower()
                        if any(p in mnem for p in ['enc', 'dec', 'hash']):
                            self.println(f"[CRYPTO] Found in {func.getName()}: {instr}")
        
        # Save findings
        self.println(f"\n[*] Found {len(matches)} potential crypto functions:")
        for m in matches:
            self.println(f"  - {m['name']} at {m['address']} ({m['size']} bytes)")

# Usage:
# ./support/pyghidraRun -script crypto_detector.py target_binary
```

### Example 4: String Extraction Batch
```bash
#!/bin/bash
# Extract strings from multiple binaries
BINARY_DIR="$1"
OUTPUT_DIR="$2"

mkdir -p "$OUTPUT_DIR"

for binary in "$BINARY_DIR"/*; do
    echo "Processing: $binary"
    
    ./support/analyzeHeadless /tmp/strings_project ExtractStrings \
      --open "$binary" --deleteFirst \
      -script StringsAnalyzer.py
    
    # Parse results
    grep -i "string:" /tmp/Extract*.txt > "$OUTPUT_DIR/$(basename $binary).strings" 2>/dev/null
done

echo "Strings extracted to $OUTPUT_DIR/"
```

---

## Integration with Other RE Tools

### With angr (Symbolic Execution)
Hybrid approach:
1. Use Ghidra for initial static analysis → identify suspicious functions
2. Export function addresses to angr
3. Symbolically execute targeted functions
4. Combine insights for full understanding

```python
# Workflow example
from ghidra_extractor import extract_function_addrs
import angr

# Step 1: Analyze with Ghidra
ghidra_funcs = extract_function_addrs('malware_binary')

# Step 2: Focus symbolic execution on interesting functions
interesting = [f for f in ghidra_funcs if 'crypto' in f['name'].lower()]

project = angr.Project('malware_binary')
for addr in interesting:
    state = project.factory.call_state(addr)
    simgr = project.factory.simulation_manager(state)
    simgr.explore(...)
```

### With pwndbg (Dynamic Debugging)
Complementary workflow:
1. Ghidra identifies vulnerable functions statically
2. Load binary into pwndbg debugger
3. Verify assumptions dynamically
4. Patch instructions based on Ghidra findings

```bash
# Ghidra identifies: buffer_overflow at 0x401234
# pwndbg validates:
gdb ./target_binary
(gdb) break *0x401234
(gdb) run
(gdb) x/20gx $rsp  # Verify stack layout
```

### With pwntools (Exploit Automation)
End-to-end pipeline:
1. Ghidra finds vulnerability location
2. pwntools constructs exploit payload
3. Validate against running service

```python
from pwn import *
# Ghidra tells us: overflow at offset 40
payload = flat([
    b'A'*40,
    p64(0x401234),  # Address from Ghidra analysis
])
p.sendline(payload)
```

---

## Key Commands & Operations

### GUI Operations
| Action | Menu Path | Shortcut |
|--------|-----------|----------|
| Create new project | File → New Project | Ctrl+N |
| Import binary | File → Import File | Ctrl+I |
| Auto-analyze binary | Right-click → Analyze | F5 |
| View disassembly | Double-click binary | - |
| View decompiler | Click "Decompile" tab | - |
| Extract strings | List → Strings | Ctrl+Shift+S |
| Search code | Edit → Search | Ctrl+F |
| Rename symbol | F2 | - |
| Add comment | Ctrl+C | - |
| View function graph | Right-click → Call Graph | - |

### Headless/CLI Operations
```bash
# Analyze binary without GUI
./analyzeHeadless /projects/project_name binary_to_analyze

# Run Python script
./support/pyghidraRun -script analyze_crypto.py target_binary

# Export decompiled code
./exportCode /path/to/output directory target_program

# Extract strings only
./extractStrings /input/file target_binary > /output/strings.txt
```

### Python Scripting API
```python
# Get program reference
program = currentProgram

# Access listing/disassembly
listing = program.getListing()
for instr in listing.getInstructions(address, True):
    print(f"{instr.getAddress()}: {instr}")

# Get function information
fm = program.getFunctionManager()
for func in fm.getFunctions(True):
    print(f"{func.getName()}: {func.getEntryPoint()}")

# Search strings
search_result = program.getStringTable().getStrings()
for s in search_result:
    if 'FLAG{' in s:
        print(f"Found flag: {s}")

# Create custom analysis
from ghidra.util.task import ConsoleTaskListener
# Implement long-running analyses with progress reporting
```

---

## Performance Benchmarks

### Analysis Speed by Binary Size

| Binary Size | Initial Analysis | Full Decode | String Extraction |
|-------------|------------------|-------------|-------------------|
| < 1MB | 2-5s | 5-10s | <1s |
| 1-10MB | 10-30s | 30-60s | 2-5s |
| 10-50MB | 1-3min | 3-5min | 5-10s |
| 50-100MB | 3-8min | 8-15min | 10-20s |
| 100MB+ | 10min+ | 20min+ | 30s+ |

### Memory Usage

| Operation | RAM Usage | Notes |
|-----------|-----------|-------|
| Load small binary (<5MB) | ~500MB | Typical desktop usage |
| Large binary (50MB+) | ~2-4GB | Requires adequate system RAM |
| Batch processing | ~1GB per instance | Multithreaded possible |
| Team collaboration | Network dependent | Shared DB overhead minimal |

### Multi-Core Utilization
- Primary analysis runs single-threaded
- Decompilation can parallelize across functions
- String extraction fully parallelized
- Max RAM usage scales linearly with binary complexity

---

## Use Cases Covered

### Malware Analysis
- Reverse engineer Trojan/Ransomware behavior
- Extract C2 infrastructure details
- Deobfuscate packed payloads
- Identify encryption keys/handling

### Vulnerability Research
- Find buffer overflows, integer overflows
- Locate privilege escalation paths
- Analyze kernel module behavior
- Study protection bypasses

### Firmware Reverse Engineering
- Router/firmware analysis
- IoT device security research
- Hardware interface discovery
- Bootloader vulnerability hunting

### CTF Challenges
- Crackme reverse engineering
- Binary exploitation practice
- Flag extraction automation
- Protocol implementation analysis

### Contract Verification
- Solidity compilation analysis
- Blockchain smart contract auditing
- Ethereum bytecode disassembly
- EVM opcode tracing

### Legal/Compliance
- License compliance checking
- Patent infringement analysis
- Security audit preparation
- Incident response forensics

---

## Security & Compliance

### Authorization Boundaries
- ✅ All analysis within user's authorized scope ONLY
- ✅ Confirm binary ownership or authorization before analyzing
- ✅ Never expand attack surface beyond specified targets
- ✅ Document all reverse engineering work in field-journal

### Ethical Considerations
- ⚠️ Reverse engineering may violate software licenses
- ⚠️ Only deploy for legitimate security research purposes
- ⚠️ Respect export controls on cryptographic analysis
- ⚠️ Do NOT crack protected commercial software

### Data Handling
- ❌ Do NOT retain extracted credentials longer than needed
- ❌ Mask sensitive values in logs (keys, tokens)
- ✅ Securely delete temporary analysis files after session
- ✅ Anonymize any extracted user data in reports

---

## Troubleshooting Quick Reference

| Problem | Likely Cause | Fix |
|---------|--------------|-----|
| Cannot launch GUI | Java version mismatch | Ensure JDK 21+ installed |
| Build fails (JDK 25 error) | Current JDK too old | Use older Ghidra release (11.2.x) |
| No strings extracted | Binary encrypted | Decrypt first, then analyze |
| Decompile fails | Complex control flow | Try different decompiler settings |
| Slow performance | Large binary size | Increase Java heap size (-Xmx) |
| Memory errors | Insufficient RAM | Close other apps, increase Xmx |

### Common Issues Solutions

**Issue:** Java Heap Space Error  
**Fix:** Increase max heap size when launching:
```bash
export JAVA_OPTS="-Xmx4g"
./support/ghidraRun
```

**Issue:** Missing Architecture Decoder  
**Fix:** Ghidra 11.2.x supports 50+ archs natively. If missing:
```bash
# Check supported archs
./support/ListSupportedArchitectures.sh

# Install additional decoder if needed
# Most come pre-packaged in release zip
```

**Issue:** Decompiler produces unreadable output  
**Fix:** Adjust decompiler options:
1. Window → Decompiler Settings
2. Enable: "Remove dead code", "Inline small methods"
3. Set: "Function inlining threshold" higher
4. Manually rename variables for clarity

---

## References

- **Official Docs:** https://ghidra-sre.org/
- **User Guide:** https://ghidra-sre.org/RELEASE_NOTES.html
- **API Documentation:** https://ghidra.re/
- **Python Scripting:** https://ghidra-sre.org/RELEASE_NOTES.html#pyghidra
- **Field Journal Precedents:** `/root/reverse-skill-clone/skills/field-journal/_index.md`
- **RE Patterns Reference:** `/root/reverse-skill-clone/skills/reverse-engineering/patterns.md`

---

*Integrated into Dangyun protocol: always active for Ghidra-based RE tasks.*  
*Next improvement cycle: triggered after each Ghidra analysis session.*  
*Note: Requires manual setup (download/release) due to JDK version constraint.*
