# Ghidra MCP Integration Suite - Skills Improvement Tracker

## Purpose
Auto-track improvements after every MCP-based reverse engineering, binary analysis, or AI-driven RE task. This ensures continuous enhancement of MCP tool usage, workflow optimization, and integration effectiveness.

## Memory Storage Location
`/root/.hermes/profiles/default/memories/ghidra-mcp-improvements.md` (create if doesn't exist)

## Workflow

### After EVERY MCP Analysis Task

1. **Verify results accuracy:**
   - Functions documented correctly?
   - Decompiled code accurate?
   - Cross-references complete?
   - P-code emulation successful?

2. **Write field journal entry** (reverse-skill workflow):
   ```bash
   echo "# mcp-analysis-$(date +'%Y%m%d')_<target>" >> 
     /root/reverse-skill-clone/skills/field-journal/$(date +'%Y-%m-%d')_mcp-<target>.md
   ```

3. **Run improvement tracker**:
   ```bash
   bash ~/.hermes/profiles/default/skills/improvement-tracker.sh \
     ghidra-mcp-integration <outcome> "<specific learnings>"
   ```

4. **Update this memory file**:
   Add new techniques/discovered patterns to sections below

## Improvement Categories

### 1. MCP Tool Selection Patterns
- Which MCP tools work best for different binary types
- Tool group loading strategies (lazy vs eager)
- Function completeness scoring insights
- Convention enforcement effectiveness

### 2. Workflow Optimization
- Automated documentation workflows that succeeded
- Batch operation efficiency improvements
- Cross-binary matching accuracy findings
- Orphaned code discovery patterns

### 3. AI Agent Integration Lessons
- Claude Desktop prompt engineering for MCP tasks
- Cursor configuration best practices
- Autohand Code workflow refinements
- Cline remote server setup tips

### 4. Performance Tuning
- RAM/CPU usage optimizations
- Response time improvements
- Lazy loading configuration discoveries
- Headless mode performance benchmarks

### 5. Debugging & Recovery
- Connection failure recovery procedures
- Program selector mode troubleshooting
- Script execution error handling
- P-code emulation debugging patterns

### 6. Security Configuration Learnings
- Auth token rotation practices
- File root security lessons
- Script execution safety configurations
- Multi-program safety validations

---

## Manual Update Template

When completing complex MCP RE tasks, add:

```markdown
## [DATE] - [TARGET BINARY/SERVICE]

**Binary Type:** [ELF/Mach-O/PE/Firmware/etc]
**Architecture:** [x86/x64/ARM/etc]
**MCP Server:** [bethington primary / LaurieWired fallback]
**Tools Used:** [listing/function/debugger/pcode/script categories]
**Outcome:** [success/partial/failure]
**Key Learnings:**

1. [Lazy loading reduced context overhead by 60%]
2. [Cross-binary matching found 15 identical functions across versions]
3. [Orphaned code discovery found suspicious crypto routine]
4. [P-code emulation resolved API hash in 2 seconds]

**MCP Metrics:**
- Time taken: X minutes
- Tools invoked: Y
- Functions analyzed: Z
- Documentation completeness: W%

**Follow-up Actions:**
- [ ] Test same MCP pattern on similar binaries
- [ ] Share AI agent prompt templates with team
- [ ] Add new tool groups to default lazy set
- [ ] Propose security config update
```

---

## Quick Reference Commands

```bash
# Run automated setup
bash ~/.hermes/profiles/default/skills/ghidra-mcp-setup.sh

# Launch primary MCP server (stdio)
./launch-beth-mcp.sh

# Launch fallback MCP server (LaurieWired)
./launch-laurie-mcp.sh

# Health check
curl http://127.0.0.1:8089/check_connection

# Get version
curl http://127.0.0.1:8089/get_version

# View recent MCP analyses
ls -lt /root/reverse-skill-clone/skills/field-journal/*mcp*.md | head -10

# List available tool groups
uv run --directory /root/tools/ghidra-mcp-integration/ghidra-mcp-beth bridge-mcp-ghidra --list-tool-groups

# Search for specific tool
uv run --directory /root/tools/ghidra-mcp-integration/ghidra-mcp-beth bridge-mcp-ghidra --search-tools "rename_function"
```

## Integration Notes

### When He Asks For MCP-Based Reverse Engineering
[D] should:
1. Detect keywords ("mcp", "ghidra mcp", "automated analysis")
2. Route to `ghidra-mcp-integration-suite` module
3. Check precedent-auth.md first
4. Query field-journal/_index.md for similar past work
5. Identify binary type/architecture
6. Select appropriate MCP server (beth/Laurie/Rizin)
7. Configure transport mode (stdio/HTTP/lazy)
8. Execute MCP commands based on task complexity
9. Validate results through multiple methods
10. After completion → run improvement-tracker.sh
11. Write summary to memories/ directory

### Auto-Routing Priority
If multiple keywords match:
- Ghidra MCP takes precedence over basic RE
- Combines with angr/pwndbg for full pipeline
- Rizin plugin as lightweight alternative when needed

---

## Performance Benchmarks (Continuous Tracking)

Track these metrics after each MCP batch analyzes:

### By Binary Type
| Type | Avg Analysis Time | Success Rate | Best Tools | Notes |
|------|------------------|--------------|------------|-------|
| Standard ELF | TBD min | TBD% | function/listing | Most common case |
| Windows PE | TBD min | TBD% | debugger + script | API heavy |
| ARM binary | TBD min | TBD% | pcode + analysis | May need emulation |
| Firmware dump | TBD min | TBD% | batch + orphan | Often encrypted |
| Malware sample | TBD min | TBD% | all three modes | Unpacker often needed |

### By MCP Transport Mode
| Mode | Speed | Resource Usage | Best For |
|------|-------|----------------|----------|
| Stdio | Fastest | Minimal | AI tools, direct use |
| HTTP | Medium | Network overhead | Web clients, browser |
| Lazy loading | Fastest startup | Context efficient | Large projects |

### By Task Complexity
| Complexity | Avg Time | Success Rate | Tools Needed |
|------------|----------|--------------|--------------|
| Simple (basic disasm) | 5 min | 95%+ | listing only |
| Medium (auto-doc) | 20 min | 85% | function + convention |
| Hard (full analysis) | 60+ min | 70% | all categories |
| Enterprise-grade | 2+ hours | 50% | custom scripts + debug |

---

## Success Metrics

Track these after each MCP session:
- ✅ Correct binary loaded and identified
- ✅ Appropriate MCP server selected
- ✅ Key functions/findings discovered
- ✅ Findings documented clearly
- ✅ AI agent successfully integrated
- ✅ Resolve time within expected window
- ✅ Field journal documentation complete
- ✅ Next-step menu clarity for He

---

## Provider Comparison Matrix

Update this regularly based on real-world testing:

| Server | Strengths | Weaknesses | Best Use Case | Reliability |
|--------|-----------|------------|---------------|-------------|
| **Bethington** | 267+ tools, production-ready | Requires Maven build | Production deployments | ⭐⭐⭐⭐⭐ |
| **LaurieWired** | Simple install, fast setup | ~50 tools, less reliable | Quick testing | ⭐⭐⭐ |
| **Rizin rz-ghidra** | Standalone, no Ghidra needed | Less features | Lightweight needs | ⭐⭐⭐⭐ |

---

## Known Limitations & Workarounds

### Current Limitations
- Requires Maven 3.9+ for bethington build (older versions fail)
- Large binaries consume significant RAM (~3-4GB)
- Some exotic architectures have limited decoder support
- Live debugger requires OS-native backend

### Documented Workarounds
1. **Old JDK:** Use Ghidra 11.2.x compatible release
2. **Memory issues:** `JAVA_OPTS="-Xmx4g"` before launch
3. **Build failures:** Try LaurieWired fallback
4. **Slow performance:** Use headless mode with lazy loading
5. **Script errors:** Set `GHIDRA_MCP_ALLOW_SCRIPTS=1` explicitly

---

*Last updated: 2026-08-04*  
*Integration source: merged 3 repos into unified MCP suite*  
*Next review trigger: after next complex MCP-based reverse engineering operation*
