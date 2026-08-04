# Advanced Reverse Engineering Suite - Skills Improvement Tracker

## Purpose
Auto-track improvements after every binary analysis, exploit development, or malware reverse engineering task. This ensures continuous enhancement of analysis strategies and tool selection.

## Memory Storage Location
`/root/.hermes/profiles/default/memories/advanced-re-improvements.md`

## Workflow

### After EVERY RE/Exploit Task

1. **Verify findings accuracy:**
   - Flag/password correctly extracted?
   - Exploit validated on target?
   - Binary analysis accurate (addresses match)?

2. **Write field journal entry** (reverse-skill workflow):
   ```bash
   echo "# re-analysis-$(date +'%Y%m%d')_<target>" >> 
     /root/reverse-skill-clone/skills/field-journal/$(date +'%Y-%m-%d')_re-<target>.md
   ```

3. **Run improvement tracker**:
   ```bash
   bash ~/.hermes/profiles/default/skills/improvement-tracker.sh \
     reverse-engineering <outcome> "<specific learnings>"
   ```

4. **Update this memory file**:
   Add new techniques/discovered patterns to sections below

## Improvement Categories

### 1. Analysis Strategy Refinements
- Which tools work best for each binary type
- Static vs dynamic analysis trade-offs
- Symbolic execution timeout optimization
- Path exploration strategies that reduced failures

### 2. Binary Type Discovery
- Novel binary formats identified
- Architecture detection accuracy improvements
- Packed executable handling techniques
- Anti-debugging bypass methods refined

### 3. Exploit Development Learnings
- Successful ROP chain constructions
- Heap exploitation patterns discovered
- Stack overflow offset calculations
- ASLR/DEP bypass techniques that worked

### 4. Tool Selection Improvements
- When to use angr vs pwndbg vs pwntools
- Hybrid approaches combining multiple tools
- Failure recovery procedures developed
- Alternative solvers when primary fails

### 5. Vulnerability Pattern Recognition
- Common buffer overflow signatures
- Integer overflow detection heuristics
- Format string vulnerability markers
- Use-after-free timing patterns

### 6. CTF Challenge Solutions
- Automated solve patterns documented
- Manual intervention points identified
- Time optimization techniques developed
- Novel challenge types flagged for training

---

## Manual Update Template

When completing complex RE/exploit tasks, add:

```markdown
## [DATE] - [TARGET BINARY/SERVICE]

**Binary Type:** [ELF/Mach-O/PE/Unknown]
**Architecture:** [x86/x64/ARM/etc]
**Tools Used:** [angr/pwndbg/pwntools combination]
**Outcome:** [success/partial/failure]
**Key Learnings:**

1. [Symbolic execution found password faster than manual analysis]
2. [ROP chain needed custom gadget search pattern]
3. [Anti-debugging check required patching before launch]
4. [Heap exploitation needed specific malloc size]

**Analysis Metrics:**
- Time taken: X minutes
- Success rate: X/Y attempts
- Flags found: Y
- Bugs confirmed: Z

**Follow-up Actions:**
- [ ] Test same method on similar binaries
- [ ] Share architecture patterns with team
- [ ] Add to vulnerability database
- [ ] Propose tool performance update
```

---

## Quick Reference Commands

```bash
# Run automated setup
bash ~/.hermes/profiles/default/skills/advanced-re-suite-setup.sh

# Analyze binary
./analyze-binary.sh <binary_path>

# Debug session
./debug-binary.sh <binary> [args...]

# Unified client test
python3 unified_re_client.py

# Check installation status
ls -lh /root/re-suites/{angr,pwndbg,pwntools}

# View recent analyses in field journal
ls -lt /root/reverse-skill-clone/skills/field-journal/*re*.md | head -10

# Regenerate tool index if new tools added
bash /root/reverse-skill-clone/skills/scripts/refresh-tool-index.sh
```

## Integration Notes

### When He Asks For Binary Analysis
[D] should:
1. Detect keywords ("reverse", "binary", "exploit", "gdb", "pwn")
2. Route to `advanced-re-engineering-suite` module
3. Check precedent-auth.md first
4. Query field-journal/_index.md for similar work
5. Identify binary type/architecture
6. Select best analysis method (static/dynamic/pwn)
7. Launch appropriate tool(s)
8. Execute analysis, monitor progress
9. Validate findings through multiple methods
10. After completion → run improvement-tracker.sh
11. Write summary to memories/ directory

### Auto-Routing Priority
If multiple keywords match:
- advanced-re-engineering overrides basic web automation
- Takes precedence over generic pentest tools
- Combined with HAR capture for full traffic trace

---

## Performance Benchmarks (Continuous Tracking)

Track these metrics after each batch of analyzes:

### By Binary Type
| Type | Avg Analysis Time | Success Rate | Best Tool | Notes |
|------|------------------|--------------|-----------|-------|
| Standard ELF | TBD min | TBD% | angr | Most common case |
| ARM binary | TBD min | TBD% | pwndbg | Requires emulation |
| Windows PE | TBD min | TBD% | pwntools | Limited support |
| Packed binary | TBD min | TBD% | Hybrid | Unpacker needed first |

### By Analysis Method
| Method | Speed | Accuracy | Complexity | Best For |
|--------|-------|----------|------------|----------|
| Symbolic Execution | Slow | High | Medium-High | Flag extraction |
| Dynamic Debugging | Fast | Medium | Low | Runtime tracing |
| Fuzz Testing | Variable | Medium | Low | Vulnerability discovery |
| ROP Chain Build | Medium | High | High | Exploitation |

### By Target Difficulty
| Difficulty | Avg Time | Success Rate | Tools Needed |
|------------|----------|--------------|--------------|
| Easy (standard CTF) | 5 min | 95%+ | angr only |
| Medium (custom vuln) | 20 min | 80% | angr + pwndbg |
| Hard (packed/obfuscated) | 60+ min | 60% | All three + manual |
| Very Hard (enterprise) | 2+ hours | 40% | Specialized tools |

---

## Success Metrics

Track these after each RE session:
- ✅ Binary correctly identified and loaded
- ✅ Appropriate tool selected for task
- ✅ Key addresses/functions discovered
- ✅ Findings documented clearly
- ✅ Exploit/test passed on target
- ✅ Resolve time within expected window
- ✅ Field journal documentation complete
- ✅ Next-step menu clarity for He

---

## Provider Comparison Matrix

Update this regularly based on real-world testing:

| Tool | Strengths | Weaknesses | Best Use Case | Price Range |
|------|-----------|------------|---------------|-------------|
| **angr** | Symbolic execution, automatic analysis | Memory intensive, slow on large binaries | Flag extraction, bug finding | Free |
| **pwndbg** | Real-time debugging, memory viewing | Requires interactive session | Crash analysis, step-by-step | Free |
| **pwntools** | Automation, remote interaction | Not a debugger itself | Exploit development, CTF | Free |

---

## Known Limitations & Workarounds

### Current Limitations
- Highly packed executables require manual unpacking first
- Kernel modules not fully supported
- JIT-compiled languages challenging for symbolic execution
- Some ARM optimizations need custom configuration

### Documented Workarounds
1. **Packed binaries:** Use UPX/unpacking tools first, then analyze
2. **Large memory consumption:** Set `auto_load_libs=False` in angr
3. **Slow path exploration:** Increase fork_limit, reduce constraints
4. **Architecture mismatch:** Force context arch before loading binary

---

*Last updated: 2026-08-04*  
*Integration source: merged 3 repos into unified suite (angr + pwndbg + pwntools)*  
*Next review trigger: after next complex reverse engineering operation*
