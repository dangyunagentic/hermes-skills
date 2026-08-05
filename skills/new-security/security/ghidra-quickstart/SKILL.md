---
name: ghidra-quickstart
description: Offensive security tools for Ghidra Reverse Engineering Suite - Quick Start Guide...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

# Ghidra Reverse Engineering Suite - Quick Start Guide

## For He (User)

### When You Need It
Just say normally:
- "reverse engineer this binary with ghidra"
- "decompile this program"
- "find strings in malware"
- "analyze firmware dump"
- "extract cryptographic functions"
- "help me understand what this exe does"

No special commands needed. [D] will auto-detect and handle it.

---

## How It Works (Behind the Scenes)

[D] automatically:
1. ✅ Checks precedent-auth.md (authorization context)
2. ✅ Queries field-journal/_index.md (similar past analyses?)
3. ✅ Identifies binary type/architecture
4. ✅ Selects appropriate analysis method (GUI/headless/script)
5. ✅ Runs Ghidra analysis (automated or interactive mode)
6. ✅ Extracts key findings (functions, strings, patterns)
7. ✅ Validates results through multiple methods
8. ✅ Writes summary to field-journal
9. ✅ Provides completion options for next steps

**You don't need technical details.** Just ask and [D] handles everything.

---

## Quick Commands (Manual Override if Needed)

```bash
# Automated setup (one-time)
bash ~/.hermes/profiles/default/skills/ghidra-setup.sh

# Launch GUI
ghidra_gui

# Headless analysis (no GUI)
ghidra_headless /tmp/project target_binary

# Run Python script
ghidra_python -script my_analysis.py target_binary

# Extract all strings
ghidra_headless /tmp/project binary --scriptPath scripts/ --script StringsExtractor --scriptOutput output.txt
```

---

## What Gets Analyzed

✅ Linux ELF binaries (x86/x64/ARM/MIPS/RISC-V/etc)  
✅ Windows PE executables (.exe, .dll, .sys)  
✅ macOS Mach-O files  
✅ Android APK native libraries  
✅ Firmware dumps (router, IoT, embedded)  
✅ Game ROMs and console binaries  
✅ EFI bootloaders and UEFI modules  
✅ Custom/binary formats (with proper loader)  

**Cannot analyze:**
- Highly encrypted binaries (needs decryption first)
- JIT-compiled code (requires native binary extraction)
- Protected/driver-signed kernels without proper signatures

---

## Analysis Methods Available

### Interactive GUI Mode (Most Powerful)
Full graphical interface with visual disassembly, decompiler view, graphs, comments, collaboration features.
- Best for: Deep manual reverse engineering, complex binaries, learning RE
- Launch: `ghidra_gui`

### Headless/CLI Mode (Automated)
Run analysis without GUI, perfect for batch processing or server environments.
- Best for: Automated RE pipelines, large-scale analysis, scripting
- Launch: `ghidra_headless <project> <binary>`

### Python Scripting API (Flexible)
Write custom analysis scripts in Python to extend Ghidra functionality.
- Best for: Custom heuristics, automated pattern detection, report generation
- Launch: `ghidra_python -script your_script.py binary`

---

## Key Features

### 50+ Architecture Support
Works with x86, x64, ARM, ARM64, MIPS, RISC-V, PowerPC, SPARC, Java bytecode, and 40+ more.
- Automatic architecture detection
- Architecture-specific decompilation
- Cross-platform binary analysis

### Advanced Decompiler
Converts assembly back to readable C-like pseudocode.
- Pseudocode generation for all supported architectures
- Variable renaming suggestions
- Function signature reconstruction
- Control flow graph visualization

### String Extraction
Find all hardcoded text, URLs, IP addresses, API names, flags.
- Unicode string support
- Filter by length/type
- Export to CSV/text files
- Pattern matching for specific data

### Program Graphing
Visual control flow graphs, call graphs, data dependency graphs.
- Interactive graph exploration
- Auto-layout optimization
- Export as PNG/PDF/SVG
- Cross-reference highlighting

### Team Collaboration
Multi-user analysis with synchronized database.
- Project sharing across team members
- Real-time comment sync
- Version control integration
- Role-based access control

### Automation & Scripting
Python/Java APIs for custom extensions.
- Automated analysis pipelines
- Custom plugin development
- Batch processing workflows
- Report generation templates

---

## Success Rates by Target Type

| Target Type | Success Rate | Notes |
|-------------|--------------|-------|
| Standard compiled binaries | 95%+ | Most programs analyzed successfully |
| Malware samples | 85-95% | May require unpacking first |
| Firmware dumps | 80-90% | Often packed/encrypted |
| Android APK | 90%+ | DEX + native libs analysis |
| Windows executables | 90-95% | PE format fully supported |
| Obfuscated binaries | 60-80% | Requires manual deobfuscation |

---

## Output & Results

After analysis completes, you'll get:

1. **Function list**: All identified functions with addresses
2. **String extraction**: Hardcoded text, URLs, IPs, flags
3. **Decompiled code**: C-like pseudocode for key functions
4. **Control flow graphs**: Visual program structure
5. **Import/export table**: Linked libraries, entry points
6. **Annotated findings**: Comments added during analysis
7. **Exportable reports**: Professional RE documentation

Example output format:
```json
{
  "success": true,
  "target_binary": "malware_sample.exe",
  "architecture": "x86",
  "analysis_method": "headless",
  "findings_summary": {
    "total_functions": 142,
    "crypto_routines": 5,
    "suspicious_strings": ["FLAG{...}", "http://c2.example.com"],
    "imported_apis": ["CreateProcessA", "InternetOpenA"]
  }
}
```

---

## Next Steps After Analysis

[D] will provide numbered options like:
1. Export full decompiled code for review
2. Focus on suspicious functions only
3. Compare findings with similar binaries
4. Generate professional RE report
5. Flag novel technique for documentation
6. Test exploit based on vulnerability found
7. Configure automated monitoring
8. Stop here, next objective?

---

## Troubleshooting Common Issues

**Q: Cannot download Ghidra release**  
A: Network issue. Download manually from https://github.com/NationalSecurityAgency/ghidra/releases and extract to `/opt/ghidra`.

**Q: Java Heap Space error**  
A: Increase heap size before launching:
```bash
export JAVA_OPTS="-Xmx4g"
ghidra_gui
```

**Q: Wrong architecture detected**  
A: Manually specify architecture in analysis settings after import.

**Q: Decompiler produces unreadable output**  
A: Adjust decompiler settings: Tools → Decompiler Settings → Enable better optimizations.

**Q: Slow performance on large binary**  
A: Use headless mode for batch processing, or increase system RAM.

**Q: Missing string extraction**  
A: Binary may be encrypted/packed. Try unpacking first or use dynamic tracing.

---

## Cost Estimates

| Method | Cost/Resources | Best For |
|--------|---------------|----------|
| GUI analysis | ~1GB RAM, interactive | Manual reverse engineering |
| Headless batch | ~500MB per binary, parallelizable | Large-scale RE |
| Python scripting | Minimal, reusable | Custom analysis tasks |
| Full pipeline | ~2GB RAM total, flexible | Complete RE workflow |

**Ghidra is free and open-source.** No licensing fees. Maintained by NSA.

---

## Security & Authorization

- ⚠️ Only deploy for authorized security research
- ⚠️ Document authorization explicitly in logs
- ❌ Do NOT reverse engineer proprietary software without permission
- ❌ Mask sensitive credentials in field journal entries
- ✅ Respect export controls on cryptography tools

---

## Example Workflow

**He asks:** "Reverse engineer this malware sample to find C2 servers"

[D] responds:
1. Load binary into Ghidra headless mode
2. Run auto-analysis: `ghidra_headless project malware.exe`
3. Extract strings: Find IP addresses, domains, URLs
4. Search imports: Identify network APIs used (WinINET, Winsock)
5. Identify suspicious functions: Look for encryption, persistence
6. Generate report: Compile findings into readable document
7. Report: "Found C2 at http://evil-server.com:8080/callback.exe"

Complete in 5-10 minutes with minimal manual intervention.

---

*Quick ref updated: 2026-08-04*  
*Full docs: skills/ghidra-reverse-engineering-suite.md*  
*Improvement tracker: memories/ghidra-improvements.md (created later)*
