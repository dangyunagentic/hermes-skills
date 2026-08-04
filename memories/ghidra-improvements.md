# Ghidra Reverse Engineering Suite - Skills Improvement Tracker

## Purpose
Auto-track improvements after every Ghidra analysis, reverse engineering, or binary research task. This ensures continuous enhancement of analysis strategies and tool selection.

## Memory Storage Location
`/root/.hermes/profiles/default/memories/ghidra-improvements.md` (template provided below)

## Workflow

### After EVERY Ghidra Analysis Task

1. **Verify findings accuracy:**
   - Functions correctly identified?
   - Decompiled code readable?
   - Strings extracted accurately?
   - Vulnerability confirmed?

2. **Write field journal entry** (reverse-skill workflow):
   ```bash
   echo "# ghidra-analysis-$(date +'%Y%m%d')_<target>" >> 
     /root/reverse-skill-clone/skills/field-journal/$(date +'%Y-%m-%d')_ghidra-<target>.md
   ```

3. **Run improvement tracker**:
   ```bash
   bash ~/.hermes/profiles/default/skills/improvement-tracker.sh \
     ghidra-reverse-engineering <outcome> "<specific learnings>"
   ```

4. **Update this memory file**:
   Add new techniques/discovered patterns to sections below

## Improvement Categories

### 1. Analysis Strategy Refinements
- Which binary types work best with Ghidra vs angr vs pwndbg
- GUI vs headless mode trade-offs for different targets
- Auto-analysis quality assessment
- Custom scripting needs identified

### 2. Binary Type Discovery
- Novel binary formats successfully analyzed
- Architecture detection accuracy improvements
- Packed/obfuscated handling techniques
- Anti-analysis defeat methods refined

### 3. Pattern Recognition
- Common vulnerability signatures discovered
- Cryptographic routine identification heuristics
- C2 communication pattern recognition
- Malware family markers identified

### 4. Scripting Improvements
- Custom Python scripts that worked well
- Failed analysis attempts and lessons learned
- Extension development opportunities
- Automation optimization tips

### 5. Tool Selection Learnings
- When to use Ghidra vs other RE tools
- Hybrid approaches combining multiple tools
- Failure recovery procedures developed
- Alternative solvers when primary fails

### 6. Report Generation
- Effective documentation templates
- Export format preferences per target
- Professional presentation standards
- Client-friendly summary techniques

---

## Manual Update Template

When completing complex Ghidra RE tasks, add:

```markdown
## [DATE] - [TARGET BINARY/SERVICE]

**Binary Type:** [ELF/Mach-O/PE/Firmware/etc]
**Architecture:** [x86/x64/ARM/etc]
**Tools Used:** [Ghidra GUI/headless/scripts combination]
**Outcome:** [success/partial/failure]
**Key Learnings:**

1. [Auto-analysis found crypto functions faster than manual search]
2. [Decompiler settings needed adjustment for obfuscated code]
3. [Custom script automated string filtering effectively]
4. [Headless mode better for batch firmware processing]

**Analysis Metrics:**
- Time taken: X minutes
- Success rate: X/Y binaries
- Functions identified: Y
- Critical findings: Z

**Follow-up Actions:**
- [ ] Test same method on similar binaries
- [ ] Share pattern database updates
- [ ] Add to vulnerability indicators list
- [ ] Propose tool configuration update
```

---

## Quick Reference Commands

```bash
# Run automated setup
bash ~/.hermes/profiles/default/skills/ghidra-setup.sh

# Launch GUI
ghidra_gui

# Headless analysis
ghidra_headless <project> <binary>

# Run custom Python script
ghidra_python -script my_analysis.py binary

# Extract strings only
ghidra_headless project binary --scriptPath scripts/ --script StringsExtractor

# Check installation status
ls -lh /opt/ghidra_*_PUBLIC/

# View recent analyses in field journal
ls -lt /root/reverse-skill-clone/skills/field-journal/*ghidra*.md | head -10

# Regenerate tool index if new capabilities added
bash /root/reverse-skill-clone/skills/scripts/refresh-tool-index.sh
```

## Integration Notes

### When He Asks For Binary Analysis
[D] should:
1. Detect keywords ("ghidra", "disassemble", "decompile", "reverse engineer")
2. Route to `ghidra-reverse-engineering-suite` module
3. Check precedent-auth.md first
4. Query field-journal/_index.md for similar past work
5. Identify binary type/architecture
6. Select appropriate analysis method (GUI/headless/script)
7. Launch Ghidra accordingly
8. Execute analysis, monitor progress
9. Validate findings through multiple methods
10. After completion → run improvement-tracker.sh
11. Write summary to memories/ directory

### Auto-Routing Priority
If multiple keywords match:
- Ghidra takes precedence for deep RE tasks
- Combines with advanced-re suite for full pipeline
- Cross-validates with angr/pwndbg for complex cases

---

## Performance Benchmarks (Continuous Tracking)

Track these metrics after each Ghidra batch analyzes:

### By Binary Type
| Type | Avg Analysis Time | Success Rate | Best Method | Notes |
|------|------------------|--------------|-------------|-------|
| Standard ELF | TBD min | TBD% | auto-analyze | Most common case |
| Windows PE | TBD min | TBD% | decompiler focus | API import heavy |
| ARM binary | TBD min | TBD% | architecture-specific | May need emulation |
| Firmware dump | TBD min | TBD% | batch headless | Often encrypted |
| Malware sample | TBD min | TBD% | hybrid approach | Unpacker often needed |

### By Analysis Depth
| Depth Level | Speed | Detail | Best For |
|-------------|-------|--------|----------|
| Basic (strings + imports) | Fast | Low | Quick triage |
| Full (decompile all funcs) | Medium | High | Comprehensive review |
| Targeted (critical funcs only) | Variable | Focused | Vulnerability hunting |
| Deep dive (manual annotation) | Slow | Maximal | Expert RE |

### By Target Complexity
| Complexity | Avg Time | Success Rate | Tools Needed |
|------------|----------|--------------|--------------|
| Simple (unpacked CTF) | 5 min | 95%+ | Auto-analyze only |
| Medium (standard malware) | 20 min | 80% | Scripts + manual tuning |
| Hard (packed/obfuscated) | 60+ min | 60% | All three modes + unpacking |
| Enterprise-grade | 2+ hours | 40% | Specialized techniques |

---

## Success Metrics

Track these after each Ghidra session:
- ✅ Binary correctly loaded and identified
- ✅ Appropriate analysis method selected
- ✅ Key functions/findings discovered
- ✅ Findings documented clearly
- ✅ Report generated in client-friendly format
- ✅ Resolve time within expected window
- ✅ Field journal documentation complete
- ✅ Next-step menu clarity for He

---

## Provider Comparison Matrix

Update this regularly based on real-world testing:

| Tool | Strengths | Weaknesses | Best Use Case | Price Range |
|------|-----------|------------|---------------|-------------|
| **Ghidra** | Multi-arch support, team collaboration, decompiler | GUI heavy, memory intensive | Enterprise RE, malware analysis | Free (NSA) |
| **angr** | Symbolic execution, automation | Less interactive, slower on large binaries | Automated flag extraction | Free |
| **pwndbg** | Real-time debugging, memory inspection | Requires interactive session | Crash analysis, runtime tracing | Free |
| **pwntools** | Remote interaction, exploit construction | Not a debugger itself | Exploit development, CTF | Free |

---

## Known Limitations & Workarounds

### Current Limitations
- Highly packed executables require manual unpacking first
- Encrypted firmware impossible without decryption keys
- JIT-compiled languages challenging for static analysis
- Some exotic architectures have limited decoder support

### Documented Workarounds
1. **Packed binaries:** Use UPX/unpacking tools first, then analyze
2. **Encrypted firmware:** Obtain keys via side-channel or hardware access
3. **Large memory consumption:** Increase Java heap size (-Xmx4g)
4. **Slow analysis:** Use headless mode for batch processing, skip GUI
5. **Decompilation issues:** Adjust decompiler settings manually
6. **Script failures:** Fall back to command-line string extraction

---

*Last updated: 2026-08-04*  
*Integration source: NSA Ghidra framework merged into Dangyun toolchain*  
*Next review trigger: after next complex reverse engineering operation*
