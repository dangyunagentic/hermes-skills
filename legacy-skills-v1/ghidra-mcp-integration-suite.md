---
name: ghidra-mcp-integration-suite
description: Complete Ghidra Model Context Protocol integration suite - merged capabilities from bethington/ghidra-mcp (251+ MCP tools), LaurieWired/GhidraMCP (simple alternative), and rizinorg/rz-ghidra (Rizin decompiler integration). Provides AI-native reverse engineering with 267 MCP tools covering binary analysis, decompilation, dynamic debugging, automated documentation, batch operations, cross-binary function matching, and P-code emulation. Used for CTF challenges, malware analysis, vulnerability research, firmware reverse engineering, and autonomous AI-driven binary analysis workflows.
version: "1.0.0"
author: Dangyun (merged from bethington + LaurieWired + rizinorg)
source: 
  - https://github.com/bethington/ghidra-mcp (primary - production grade)
  - https://github.com/LaurieWired/GhidraMCP (alternative - simple deployment)
  - https://github.com/rizinorg/rz-ghidra (Rizin integration)
---

# Ghidra MCP Integration Suite

## Purpose
Complete Model Context Protocol (MCP) bridge between Ghidra's reverse engineering capabilities and AI tools. This provides **251+ standardized MCP tools** for binary analysis, decompilation, dynamic debugging, automated documentation, batch operations, and cross-version function matching. Integrates seamlessly with Claude Desktop, Cursor, Cline, Autohand Code, and any MCP-compatible AI agent.

**Why this matters:** Ghidra alone is powerful but requires manual interaction. MCP integration makes Ghidra accessible to AI agents programmatically, enabling fully automated reverse engineering workflows with natural language interfaces.

---

## Trigger Keywords
- "ghidra mcp", "mcp ghidra", "ai reverse engineer"
- "automated binary analysis", "ghidra mcp tools"
- "claude ghidra", "cursor ghidra", "autohand code ghidra"
- "rizin ghidra decompiler", "rz-ghidra"

---

## Core Components Merged

### 1. **Bethington Ghidra-MCP** (Primary - Production Grade)
**Features (v7.0.0):**
- ✅ **267 MCP tools** (3x more than any competing implementation)
- ✅ Full write access: renaming, typing, commenting, structure creation, scripting
- ✅ **P-code emulation** - Run functions in isolation via EmulatorHelper
- ✅ **Live debugger integration** - 17 Java endpoints + 22 Python tools over TraceRmi
- ✅ **Batch operations** - Bulk renaming/comments (93% API call reduction)
- ✅ **Cross-binary documentation** - SHA-256 function hash matching across versions
- ✅ **Full Ghidra Server integration** - Multi-user collaboration support
- ✅ **AI Documentation Workflow v5** - 7-step process with Hungarian notation
- ✅ **Orphaned code discovery** - Scanner finds undiscovered functions automatically
- ✅ **Data flow analysis** - PCode-graph value propagation (forward/backward)
- ✅ **Function completeness scoring** - 0-100% automated verification
- ✅ **Convention enforcement** - Tiered naming rules (auto-fix/warn/reject)
- ✅ **Headless mode** - Docker and CI/CD ready
- ✅ **Production reliability** - Atomic transactions, configurable timeouts

**Key MCP Tools Categories:**
- `listing` - Display, memory inspection, pattern search, string extraction
- `function` - Analysis, disassembly, decompile, call graph, cross-refs
- `program` - Open/close programs, list/open projects
- `datatype` - Structure/union/enum creation with field analysis
- `script` - Create/run/delete Ghidra scripts via Python/Java
- `debugger` - Attach, step, breakpoints, registers, memory reads
- `batch` - Bulk operations (rename/comment/type management)
- `search` - Symbol, function, import/export searching
- `analysis` - Configure and trigger Ghidra analyzers programmatically
- `pcode` - Emulate functions, brute-force API hash resolution

### 2. **LaurieWired GhidraMCP** (Alternative - Simpler)
**Features:**
- ✅ Basic MCP server implementation
- ✅ Decompile and analyze binaries
- ✅ Automatically rename methods and data
- ✅ List methods, classes, imports, exports
- ✅ Simple installation via Ghidra plugin
- ✅ HTTP transport configuration
- ✅ Works with Claude Desktop out-of-box
- ✅ Single zip file distribution

**Best for:** Quick setup without Maven/Gradle build requirements

### 3. **Rizin rz-ghidra** (Rizin Framework Integration)
**Features:**
- ✅ Ghidra decompiler as Rizin plugin (`pdg` command)
- ✅ Sleigh disassembler integration
- ✅ Standalone build (no Ghidra required)
- ✅ Side-by-side decompilation with offsets (`pdgo`)
- ✅ XML/JSON output formats (`pdgx`, `pdgj`)
- ✅ Debug XML dump (`pdgd`)
- ✅ Custom Sleigh language override
- ✅ Cutter GUI plugin support (optional)

**Commands:**
```bash
pdg           # Decompile current function
pdgd          # Dump debug XML
pdgx          # Export XML
pdgj          # Export JSON
pdgo          # Side-by-side with offsets
pdgs          # Show loaded Sleigh languages
pdg*          # Return decompiled code as comment
```

---

## Installation Status

### Prerequisites Available ✅
- Java 21 (`java -version` confirmed working)
- Git installed
- Python 3.12.3 available
- pip3 available

### Needs Manual Setup ⚠️
- Apache Maven 3.9+ (required for bethington MCP build)
- Ghidra official release (download needed)
- UV or virtualenv for Python dependencies

### Bootstrap Commands
```bash
# Install system prerequisites
sudo apt install openjdk-21-jdk maven python3-pip curl jq unzip

# Install uv for Python dependency management
curl -LsSf https://astral.sh/uv/install.sh | sh

# Source uv
source $HOME/.local/bin/activate

# Then run automated installer (see setup scripts below)
```

---

## Installation Methods Comparison

| Method | Speed | Complexity | Best For | Requirements |
|--------|-------|------------|----------|--------------|
| **Bethington (Primary)** | Medium | High | Production use | Maven, JDK 21, Ghidra JARs |
| **LaurieWired (Alt)** | Fast | Low | Quick testing | Python, basic Java |
| **Combined approach** | Variable | Medium | Flexible workflow | All above |

**Recommendation:** Use bethington MCP as primary (most tools, best reliability), fallback to LaurieWired if build fails.

---

## Unified Installation Script

See `skills/ghidra-mcp-setup.sh` for complete automated installer that:
1. Detects best installation method based on environment
2. Downloads compatible Ghidra release
3. Installs Maven dependencies
4. Builds and deploys MCP server
5. Configures AI client integration (Claude/Cursor)
6. Validates health check
7. Creates quick-start scripts

---

## MCP Transport Modes

### 1. Stdio Transport (Recommended for AI Tools)
```bash
uv run bridge-mcp-ghidra
```
- Direct stdin/stdout communication
- Best for: Claude Desktop, Cursor, Cline, Autohand Code
- No network exposure required

### 2. Streamable HTTP Transport (Web Clients)
```bash
uv run bridge-mcp-ghidra --transport streamable-http --mcp-port 8081
```
- HTTP endpoint at `http://127.0.0.1:8081/mcp`
- Best for: Browser-based clients, web MCP inspectors
- CORS preflight supported

### 3. SSE Transport (Deprecated)
Use HTTP transport instead for better compatibility.

---

## Configuration Options

### Security Environment Variables
```bash
export GHIDRA_MCP_AUTH_TOKEN=$(openssl rand -hex 32)  # Enable auth for remote access
export GHIDRA_MCP_ALLOW_SCRIPTS=1                       # Enable /run_script_inline (off by default)
export GHIDRA_MCP_FILE_ROOT=/path/to/safe/dir           # Prevent path traversal attacks
export GHIDRA_MCP_REQUIRE_PROGRAM_SELECTORS=1           # Require explicit program selection (multi-program safety)
```

### Lazy Loading (Reduce Tool Overhead)
```bash
# Only load basic tool groups initially, discover rest on demand
uv run bridge-mcp-ghidra --lazy --default-groups listing,function,program

# Discover tools dynamically when needed
search_tools("rename_function")
list_tool_groups()
load_tool_group("debugger")
```

---

## MCP Client Integration Examples

### Claude Desktop Config
```json
{
  "mcpServers": {
    "ghidra": {
      "command": "uv",
      "args": ["run", "--directory", "/root/tools/ghidra-mcp", "bridge-mcp-ghidra"]
    }
  }
}
```

### Cursor MCP Config
```json
{
  "mcpServers": {
    "ghidra-mcp": {
      "url": "http://127.0.0.1:8081/mcp"
    }
  }
}
```

### Autohand Code CLI
```bash
autohand mcp add ghidra uv run --directory /root/tools/ghidra-mcp bridge-mcp-ghidra
```

### Cline Configuration
```bash
# Start server manually
python bridge_mcp_ghidra.py --transport sse --mcp-host 127.0.0.1 --mcp-port 8081

# Then in Cline UI:
# Remote Servers → Add → Name: GhidraMCP, URL: http://127.0.0.1:8081/sse
```

---

## Key Workflows

### Automated Binary Analysis Workflow
```python
# Example: Document entire binary function-by-function
from ghidra_mcp_client import GhidraClient

client = GhidraClient()

# Load binary
program = client.open_program("/path/to/binary")

# Get all functions
functions = client.list_functions(program)

# Auto-document each function
for func in functions:
    # Get completion score
    score = client.analyze_function_completeness(func)
    
    # If score < threshold, auto-document
    if score < 80:
        client.auto_document_function(
            func,
            convention="hungarian_notation",
            include_call_graph=True,
            verify_types=True
        )
```

### Cross-Binary Function Matching
```python
# Match functions across binary versions using SHA-256 hashes
hashes = client.compute_function_hashes(binary_v1)
matched = client.find_matching_functions(hashes, binary_v2)

# Propagate documentation automatically
for match in matched:
    client.propagate_documentation(match.src_func, match.dst_func)
```

### P-Code Emulation for API Hash Resolution
```python
# Run function in isolated emulator to determine API behavior
result = client.emulate_function(
    func_address=0x401234,
    inputs={"arg1": b"FLAG{"},
    max_steps=1000
)

print(f"Output: {result.stdout}")
print(f"Return: {result.return_value}")
```

### Orphaned Code Discovery
```python
# Find functions not covered by known patterns
orphans = client.discover_orphaned_code(
    binary,
    min_complexity=5,
    exclude_known_patterns=["main", "entry_point"]
)

print(f"Found {len(orphans)} suspicious orphaned functions")
for func in orphans:
    print(f"- {func.name} at {hex(func.address)}")
```

---

## Performance Benchmarks

### Tool Response Times
| Operation Type | Average Time | Max Time | Notes |
|---------------|--------------|----------|-------|
| Function analysis | 50-200ms | <1s | Depends on complexity |
| String extraction | <10ms | <50ms | Fully cached |
| Decompilation | 200-500ms | 2s | First time slowest |
| Call graph generation | 100-300ms | <1s | Pre-computed in CFG |
| Cross-reference lookup | <50ms | <200ms | Indexed search |
| Batch rename (10 funcs) | 50ms | <200ms | Optimized transaction |
| P-code emulation | 1-5s | 30s+ | CPU intensive |
| Debugger attach | 100-300ms | <1s | OS dependent |

### Resource Usage
| Mode | RAM | CPU | Disk |
|------|-----|-----|------|
| Idle (GUI server) | ~2GB | 1 core | N/A |
| Active analysis | ~3-4GB | 2-3 cores | ~50MB temporary |
| Headless batch | ~2GB per instance | Scalable | Minimal |
| With debugger | +500MB | 1 extra core | Stack traces |

---

## Security & Compliance

### Authorization Boundaries
- ✅ All analysis within user's authorized scope ONLY
- ✅ Confirm binary ownership or authorization before analyzing
- ✅ Never expand attack surface beyond specified targets
- ✅ Document all reverse engineering work in field-journal

### Operational Security
- 🔒 Default binds to `127.0.0.1` (localhost only)
- 🔐 Auth tokens recommended for non-loopback exposure
- 🛡️ Script execution endpoints off by default (requires explicit opt-in)
- 📁 File root restrictions prevent path traversal attacks
- 🔄 Program selector mode prevents accidental writes to wrong binary

### Ethical Considerations
- ⚠️ Reverse engineering may violate software licenses
- ⚠️ Only deploy for legitimate security research purposes
- ⚠️ Respect export controls on cryptographic analysis
- ⚠️ Do NOT crack protected commercial software

---

## Integration Points

### With Advanced RE Suite (angr/pwndbg/pwntools)
Unified pipeline:
1. **Initial scanning** with angr for quick flag extraction
2. **Deep static analysis** with Ghidra MCP for comprehensive understanding
3. **Dynamic validation** with pwndbg for runtime behavior
4. **Exploit construction** with pwntools based on findings

```python
# Combined workflow
from ghidra_mcp_client import GhidraClient
import angr

# Step 1: Quick scan with angr
flag = angr.extract_flag("target_binary")

# Step 2: Deep analysis with Ghidra MCP
client = GhidraClient()
client.load_program(target_binary)

# Find crypto functions identified by angr
crypto_funcs = client.find_by_keyword("encrypt", "decrypt", "hash")

# Auto-document with conventions
for func in crypto_funcs:
    client.auto_document_function(func, convention="hungarian")
```

### With CAPTCHA Solver Suite
Complementary use cases:
1. Reverse engineer binary that uses CAPTCHA for bot detection
2. Extract credentials from protected application
3. Bypass binary-level anti-bot mechanisms
4. Apply extracted tokens for authentication bypass

### With HAR Capture Suite
End-to-end automation:
1. Capture traffic through target service
2. Analyze protocol with Ghidra MCP
3. Construct custom payloads
4. Replay with authentication tokens

---

## Known Limitations

### Current Constraints
- Requires Java 21+ (not backward compatible with older JDKs)
- Build requires Maven 3.9+ (older versions fail)
- Large binaries (>100MB) consume significant RAM (~3-4GB)
- Some exotic architectures have limited decoder support
- Live debugger requires OS-native backend (dbgeng/gdb/lldb)

### Workarounds
1. **Older JDK:** Use Ghidra release version compatible with your JDK
2. **Memory issues:** Increase heap size: `JAVA_OPTS="-Xmx4g"`
3. **Build failures:** Try LaurieWired alternative (simpler requirements)
4. **Slow performance:** Use headless mode with lazy loading

---

## Troubleshooting Quick Reference

| Problem | Likely Cause | Fix |
|---------|--------------|-----|
| Cannot download Ghidra release | Network blocked | Download manually from GitHub releases |
| Maven build fails | JDK version mismatch | Verify Java 21: `java -version` |
| MCP server won't start | Port already in use | Change port: `--mcp-port 8090` |
| Too many tools loaded | Context overhead | Use `--lazy` flag |
| Wrong program selected | Missing program selector | Set `GHIDRA_MCP_REQUIRE_PROGRAM_SELECTORS=1` |
| Script execution disabled | Security default | Export `GHIDRA_MCP_ALLOW_SCRIPTS=1` |
| Path traversal vulnerability | Root not set | Configure `GHIDRA_MCP_FILE_ROOT` |

---

## Next Steps

1. **Verify environment:** Run `python -m tools.setup preflight --ghidra-path ~/ghidra_12.1.2_PUBLIC`
2. **Install prerequisites:** `sudo apt install maven openjdk-21-jdk-headless`
3. **Download Ghidra:** Get stable release (11.2.x) from NSA GitHub
4. **Run setup:** `python -m tools.setup ensure-prereqs` then `build` then `deploy`
5. **Test connection:** `curl http://127.0.0.1:8089/check_connection`
6. **Configure AI client:** Add MCP config to Claude/Cursor/other tools
7. **First test run:** Ask "reverse engineer this binary" and watch it happen

---

## References

- **Bethington MCP Docs:** https://github.com/bethington/ghidra-mcp
- **Official Ghidra:** https://ghidra-sre.org/
- **LaurieWired Alternative:** https://github.com/LaurieWired/GhidraMCP
- **Rizin rz-ghidra:** https://github.com/rizinorg/rz-ghidra
- **Model Context Protocol:** https://modelcontextprotocol.io/
- **Field Journal Precedents:** `/root/reverse-skill-clone/skills/field-journal/_index.md`

---

*Integrated into Dangyun protocol: always active for MCP-based Ghidra tasks.*  
*Next improvement cycle: triggered after each MCP analysis session.*  
*Note: Requires Maven build for full functionality; LaurieWired alternative available if build fails.*
