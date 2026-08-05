---
name: ghidrassistmcp-symgraph
description: Offensive security tools for ---...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

---
name: ghidrassistmcp-symgraph
description: Production-grade Ghidra MCP extension with 49 action-based tools, result caching, async task lifecycle, 7 prompt templates, and headless mode support. Requires Java 25+ for building. Provides advanced features like multi-program awareness, dynamic security controls, real-time logging, and CI/CD automation capabilities. Alternative to LaurieWired for production deployment.
version: "1.0.0"
author: symgraph (jtang613) - adapted for Dangyun/Hermes
source: https://github.com/symgraph/GhidrAssistMCP
dependencies:
  - Java 25+ (required for build)
  - Gradle wrapper (auto-downloads correct version)
  - Ghidra 11.4+ compatible
  - Jetty 11.0.20 (embedded server)
  - Jackson 2.17.0 (JSON processing)
features:
  - 49 built-in MCP tools (action-based API pattern)
  - Result caching for performance optimization
  - Async task lifecycle management (get_status, cancel, list)
  - 7 pre-built analysis prompts
  - Multi-program awareness with active context tracking
  - Real-time request/response logging
  - Dynamic security controls (per-tool enable/disable)
  - Headless mode for CI/CD pipelines
  - Rich Configuration UI for tool management
  - SSE + Streamable HTTP transports
---

# GhidrAssistMCP - Symgraph Implementation

## Purpose
Production-grade Model Context Protocol (MCP) server for Ghidra reverse engineering platform. Bridges AI assistants with Ghidra's comprehensive analysis capabilities through standardized API with **49 sophisticated tools**, intelligent caching, async operations, and enterprise-ready security controls.

**Why this matters:** Unlike simple implementations, symgraph provides production-grade features including action-based APIs (reduces endpoint count by 50-70%), full async task lifecycle, intelligent result caching, and headless mode support - making it ideal for enterprise deployments, CI/CD pipelines, and complex multi-program workflows.

---

## Trigger Keywords
- "ghidrassist mcp", "symgraph mcp"
- "production ghidra mcp", "async ghidra"
- "action based api mcp", "cached ghidra"
- "headless ghidra mcp", "ci/cd mcp"

---

## Key Features Comparison

| Feature | LaurieWired | **symgraph/GhidrAssistMCP** | bethington |
|---------|-------------|---------------------------|------------|
| **Tool Count** | ~50 basic | **49 action-based** | 267+ granular |
| **API Pattern** | Separate endpoints | **Discriminator-based** | Granular |
| **Result Caching** | ❌ No | ✅ **Intelligent cache** | ❌ No |
| **Async Tasks** | ❌ Blocking | ✅ **Full lifecycle** | ⚠️ Partial |
| **Prompt Templates** | ❌ None | ✅ **7 pre-built** | ⚠️ Limited |
| **Config UI** | ❌ CLI only | ✅ **Rich panel** | ⚠️ Basic |
| **Security Controls** | ⚠️ Manual | ✅ **Per-tool enable/disable** | ✅ Token-based |
| **Headless Mode** | ❌ Not available | ✅ **Pre/post-script** | ✅ With server |
| **Real-time Logging** | ❌ Minimal | ✅ **Request/response log** | ✅ Extensive |
| **Multi-Program** | ⚠️ Basic | ✅ **Active context aware** | ✅ Full |

**Installation Requirement:** Java 25+ (currently have JDK 21 - upgrade needed)

---

## Architecture Overview

### Core Components
```
┌─────────────────────────────────────────────────────────┐
│                   Plugin Layer                          │
│  - GhidrAssistMCPPlugin.java (lifecycle management)    │
│  - ProgramManager Service (multi-window tracking)      │
│  - Configuration Panel UI (tool management)            │
│  - Activity Logger (real-time request/response)        │
└───────────┬─────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────┐
│                    Server Layer                         │
│  - Jetty 11.0.20 Embedded Server                       │
│  - Port: 8080 (default)                                │
│  - Endpoints: /mcp/sse (SSE), /mcp/message             │
│  - McpServer (io.modelcontextprotocol.sdk:mcp:0.9.0)   │
└───────────┬─────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────┐
│                    Backend Layer                        │
│  - McpBackend                                          │
│  - Tool execution engine                               │
│  - Program resolution (exact/case-insensitive/partial) │
│  - Result caching layer                                │
│  - Async task manager                                  │
└───────────┬─────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────┐
│                      Tool Layer                         │
│  - 49 Individual Tools (McpTool interface)             │
│  - Action-based API pattern                            │
│  - Dynamic enable/disable registry                     │
│  - Category organization (Binary/Analysis/Functions/etc)│
└─────────────────────────────────────────────────────────┘
```

### Multi-Window Awareness
The plugin tracks all open CodeBrowser windows and maintains:
- Active window focus detection (automatic context switching)
- `program_name` parameter for explicit targeting
- Project Path values for unambiguous disambiguation
- Intelligent routing based on user's current focus

---

## Tool Inventory (49 Built-in Tools)

### Category 1: Binary & Program Management (11 Tools)
| Tool | Purpose | Security |
|------|---------|----------|
| `get_binary_info` | Get program metadata (name, arch, compiler) | Read-only |
| `list_binaries` | List all open programs with Project Path | Read-only |
| `open_program` | Load project programs in CodeBrowser | Configurable |
| `close_program` | Close open programs (save/ignore options) | Write |
| `import_file` | Import host file into project | 🔒 **Disabled by default** |
| `project_files` | List/delete project entries (confirm required) | Write 🔒 |
| `scripts` | List/read/create/delete/run scripts | 🔒 **Disabled by default** |
| `assemble_code` | Assemble instruction text and patch memory | Write |
| `patch_bytes` | Patch raw bytes at address | Write |
| `export_program` | Export current program to disk | 🔒 **Disabled by default** |

### Category 2: Auto Analysis (3 Tools)
| Tool | Purpose | Use Case |
|------|---------|----------|
| `analysis_options` | Configure/reset preset options | Quick analysis setup |
| `analyze_program` | Run full/partial re-analysis | Initial reverse engineering |
| `analysis_control` | Query/cancel queued tasks | Long-running analysis control |

### Category 3: Function Discovery (9 Tools)
| Tool | Purpose | Key Features |
|------|---------|--------------|
| `get_functions` | List functions with pattern filtering | Pagination support |
| `search_functions_by_name` | Find by name pattern | Case-insensitive search |
| `get_function_statistics` | Comprehensive function metrics | Coverage analysis |
| `analyze_function` | Detailed function info | Signature/variables |
| `get_current_function` | Cursor position function | Context-aware |
| `get_function_stack_layout` | Stack frame variables | Local var offsets |
| `get_basic_blocks` | CFG basic blocks | Control flow analysis |
| `create_function` | Define new function | Manual signature |
| `disassemble_at` | Disassemble at address | Clear existing first |

### Category 4: Binary Information (8 Tools)
| Tool | Purpose | Output Format |
|------|---------|--------------|
| `get_imports` | Imported symbols list | Structured table |
| `get_exports` | Exported symbols list | Structured table |
| `get_strings` | String references with filters | Regex/searchable |
| `search_strings` | Pattern-based string search | Highlighted results |
| `get_segments` | Memory segments | Segment map |
| `get_namespaces` | Namespace listings | Scoped symbols |
| `get_relocations` | Relocation entries | Address→symbol mapping |
| `get_entry_points` | All binary entry points | Multiple entry support |

### Category 5: Data Analysis (4 Tools)
| Tool | Purpose | Use Case |
|------|---------|----------|
| `get_data_vars` | List data definitions | Global/local vars |
| `get_data_at` | Hexdump at address | Inline inspection |
| `create_data_var` | Define data types | Type assignment |
| `get_current_address` | Cursor address retrieval | Context-aware |

### Category 6: Consolidated Action-Based Tools (10 Tools)

#### `get_code` - Unified Code Retrieval
```json
{
  "name": "get_code",
  "arguments": {
    "function": "main",
    "format": "decompiler"  // decompiler, disassembly, pcode
    "raw": false           // Only affects pcode format
  }
}
```

#### `classes` - Class Operations
```json
{
  "name": "classes",
  "arguments": {
    "action": "list|get_info",
    "class_name": "MyClass",
    "pattern": "Socket"     // For list action
  }
}
```

#### `xrefs` - Cross-Reference Discovery
```json
{
  "name": "xrefs",
  "arguments": {
    "address": "0x401234",      // or "function": "main"
    "include_calls": true       // Includes callers/callees
  }
}
```

#### `struct` - Structure Operations (8 Actions)
- `create` - New structure from C definition
- `modify` - Update existing structure
- `merge` - Overlay fields without deleting
- `set_field` - Single field insertion
- `name_gap` - Named undefined bytes as `byte[]`
- `auto_create` - Infer from variable usage
- `rename_field` - Rename struct field
- `field_xrefs` - Field cross-reference lookup

#### `rename_symbol`, `batch_rename` - Symbol Management
- Rename single or multiple symbols
- Support for function/data/variable target types
- Pattern-based matching available

#### `comments`, `variables`, `types`, `bookmarks` - Resource Management
Each uses action-based pattern for get/set/list/remove operations

### Category 7: Search & Task Management (3 Tools)
| Tool | Purpose | Status Tracking |
|------|---------|----------------|
| `search_bytes` | Memory byte pattern search | Immediate |
| `get_task_status` | Check async task progress | Progress % complete |
| `cancel_task` | Stop running async task | Graceful shutdown |

---

## MCP Resources (Static Data Sources)

GhidrAssistMCP exposes 6 static resources:

| Resource URI | Description |
|--------------|-------------|
| `ghidra://program/{name}/info` | Basic program information |
| `ghidra://program/{name}/functions` | List of all functions |
| `ghidra://program/{name}/strings` | String references |
| `ghidra://program/{name}/imports` | Imported symbols |
| `ghidra://program/{name}/exports` | Exported symbols |
| `ghidra://program/{name}/segments` | Memory segments |

---

## MCP Prompts (7 Pre-Built Templates)

Ready-to-use prompts for common analysis tasks:

| Prompt | Description | Use Case |
|--------|-------------|----------|
| `analyze_function` | Comprehensive function breakdown | Deep understanding |
| `identify_vulnerability` | Security weakness detection | Bug hunting |
| `document_function` | Auto documentation generation | Knowledge base |
| `trace_data_flow` | Data propagation analysis | Algorithm reverse |
| `trace_network_data` | Network send/receive stacks | Protocol analysis |
| `compare_functions` | Function similarity diffing | Code reuse detection |
| `reverse_engineer_struct` | Infer structure definitions | Data recovery |

---

## Installation Instructions

### Prerequisites
1. **Java 25+** (required for build - currently have JDK 21, need upgrade)
2. **Gradle wrapper** (included in repo)
3. **Ghidra 11.4+** (tested with 12.1 Public)
4. **System dependencies**: None beyond Java

### Build Process
```bash
cd /root/tools/GhidrAssistMCP-symgraph

# Set Ghidra installation path
export GHIDRA_INSTALL_DIR=/opt/ghidra_11.4.3_PUBLIC

# Build extension (downloads Gradle automatically)
./gradlew installExtension

# This copies the built ZIP to:
# $GHIDRA_INSTALL_DIR/Extensions/Ghidra/GhidrAssistMCP
```

### Ghidra Installation Steps
1. **Restart Ghidra** after build completes
2. **Enable plugin**: File → Configure Plugins → Search "GhidrAssistMCP" → Check box
3. **Open Configuration Panel**: Window → GhidrAssistMCP (or toolbar icon)
4. **Configure settings**: Host (localhost), Port (8080), Enable/Disable toggle
5. **Manage tools**: Configuration tab allows per-tool enable/disable
6. **Monitor activity**: Real-time request/response logging in panel

### Headless Mode Setup (CI/CD)
```bash
# Pre-script: Start server before import completes
"$GHIDRA_INSTALL_DIR/support/analyzeHeadless" /tmp/projects MyProject \
  -import /path/to/binary \
  -scriptPath "$GHIDRASSISTMCP_EXT/ghidra_scripts" \
  -preScript GAMCPStartServer.java "host=127.0.0.1" "port=8080"

# Post-script: Keep server running after analysis
- postScript GAMCPStartServer.java "host=127.0.0.1" "port=8080" "wait=true"

# Control exit with completion file
completion_file=/workspace/control/session.complete
```

**Note:** Requires Java 25+ for compilation and runtime

---

## Usage Examples

### Basic Program Information
```json
{
  "method": "tools/call",
  "params": {
    "name": "get_binary_info",
    "arguments": {}
  }
}
```

### List Functions with Pattern Filtering
```json
{
  "method": "tools/call",
  "params": {
    "name": "get_functions",
    "arguments": {
      "pattern": "init",
      "case_sensitive": false,
      "limit": 50
    }
  }
}
```

### Decompile Function (`get_code`)
```json
{
  "method": "tools/call",
  "params": {
    "name": "get_code",
    "arguments": {
      "function": "main",
      "format": "decompiler"
    }
  }
}
```

### Get Class Information (Action-Based)
```json
{
  "method": "tools/call",
  "params": {
    "name": "classes",
    "arguments": {
      "action": "get_info",
      "class_name": "MyClass"
    }
  }
}
```

### Search Classes (Action-Based)
```json
{
  "method": "tools/call",
  "params": {
    "name": "classes",
    "arguments": {
      "action": "list",
      "pattern": "Socket",
      "case_sensitive": false
    }
  }
}
```

### Async Task Management
```json
// Trigger long operation
{
  "method": "tools/call",
  "params": {
    "name": "get_code",
    "arguments": {
      "function": "large_function"
    }
  }
}

// Check status (returns task_id)
{
  "method": "tools/call",
  "params": {
    "name": "get_task_status",
    "arguments": {
      "task_id": "abc123"
    }
  }
}

// Cancel if needed
{
  "method": "tools/call",
  "params": {
    "name": "cancel_task",
    "arguments": {
      "task_id": "abc123"
    }
  }
}
```

---

## AI Client Integration

### Claude Desktop Config
```json
{
  "mcpServers": {
    "ghidrassist": {
      "command": "bash",
      "args": [
        "-c",
        "cd /opt/ghidra_11.4.3_PUBLIC/Extensions/Ghidra/GhidrAssistMCP && \
         java -jar ghidrassist-mcp-server.jar --host 127.0.0.1 --port 8080"
      ]
    }
  }
}
```

### Cursor MCP Config
Add to your Cursor MCP config:
```json
{
  "mcpServers": {
    "ghidrassist": {
      "url": "http://127.0.0.1:8080/mcp"
    }
  }
}
```

### Autohand Code CLI
```bash
autohand mcp add ghidrassist java -jar /opt/ghidra_11.4.3_PUBLIC/Extensions/Ghidra/GhidrAssistMCP/ghidrassist-mcp-server.jar --host 127.0.0.1 --port 8080
```

### cline Remote Server
1. Start manually:
   ```bash
   cd /opt/ghidra_11.4.3_PUBLIC/Extensions/Ghidra/GhidrAssistMCP && \
   java -jar ghidrassist-mcp-server.jar --transport sse --port 8081
   ```
2. In Cline UI: Add Remote Server → Name: "GhidrAssistMCP", URL: `http://127.0.0.1:8081/sse`

---

## Security Configuration

### Default Deny Policy
Three sensitive tools are **disabled by default** for security:
- `import_file` - Host filesystem interaction
- `scripts` - Arbitrary code execution
- `export_program` - Data exfiltration risk

### Enabling Securely
Use Configuration Panel to enable selectively:
1. Open Window → GhidrAssistMCP
2. Go to Configuration tab
3. Find specific tool in list
4. Check enable box
5. Save configuration

### Confirmation Required
- `project_files` delete operations require `confirm=true` parameter
- Destructive actions logged in real-time panel
- Audit trail maintained for compliance

### Sandbox Mode
For agent lab environments:
```bash
./gradlew installExtension -Ptool_profile=agent_lab
```
Enables restricted mode with:
- Disabled arbitrary imports
- Disabled script execution
- Enabled program export (local artifacts only)

---

## Performance Benchmarks

### Response Times
| Operation Type | Avg Time | Notes |
|---------------|----------|-------|
| Metadata queries | <10ms | Cached responses |
| String extraction | 50-200ms | First time slowest |
| Function listing | 100-500ms | Depends on binary size |
| Decompilation | 500ms-5s | Complex functions slower |
| Cross-references | <100ms | Indexed lookup |
| Async tasks | Varies | 1s-30s+ depending on complexity |

### Resource Usage
| Metric | Value | Conditions |
|--------|-------|------------|
| **RAM** | ~2-3GB | Per JVM instance |
| **CPU** | 1-2 cores idle, spikes during analysis | Linear scaling |
| **Disk I/O** | Minimal | Mostly read-heavy |
| **Network** | Negligible | Localhost only |

### Caching Benefits
- **2x faster** response for repeated queries
- **Transparent invalidation** on program changes
- **Reduced load** during multi-step workflows
- **Cache warmup** on first access (minor delay)

---

## Troubleshooting Guide

| Problem | Likely Cause | Fix |
|---------|--------------|-----|
| Cannot download Gradle | Network blocked | Download manually from gradle.org |
| Java 21 not sufficient | Version requirement | Upgrade to Java 25+ |
| Port 8080 already in use | Another service | Change port in config |
| Plugin not found | Ghidra not restarted | Restart Ghidra application |
| Tool not available | Disabled by default | Enable via Configuration UI |
| Async task hanging | Resource exhaustion | Cancel and retry |
| Cache not working | Program changed | Wait for auto-invalidaton |
| Headless mode fails | Script path wrong | Verify `scriptPath` parameter |

---

## Integration Points

### With LaurieWired/GhidraMCP
**Hybrid Strategy:**
- Use LaurieWired for quick/simple tasks (no Java 25 required)
- Deploy symgraph for production/complex scenarios (Java 25 available)
- AI agent routes between servers based on task complexity

### With Advanced RE Suite (angr/pwndbg/pwntools)
Unified pipeline:
1. **angr** → Quick flag extraction, symbolic execution
2. **symgraph/GhidrAssistMCP** → Deep static analysis with async support
3. **pwndbg** → Dynamic validation, runtime tracing
4. **pwntools** → Exploit construction based on findings

```python
# Combined example
from symgraph_mcp_client import GhidrAssistClient
import angr

# Step 1: Scan with angr
flag = angr.extract_flag("target_binary")

# Step 2: Deep analyze with symgraph MCP
client = GhidrAssistClient()
client.load_program("target_binary")

# Find crypto functions with async task
task_id = client.async_analyze_function("0x401000")

# Track progress while doing other work
while True:
    status = client.get_task_status(task_id)
    if status["complete"]:
        break
    time.sleep(0.5)

# Process results
result = client.get_task_result(task_id)
```

### With CAPTCHA Solver Suite
Complementary use cases:
1. Reverse engineer binary that uses CAPTCHA for bot detection
2. Extract credentials/handling logic
3. Apply bypass techniques
4. Integrate with automated solver

### With HAR Capture Suite
End-to-end automation:
1. Capture traffic through target service
2. Analyze protocol with symgraph MCP
3. Construct custom payloads using async tasks
4. Replay authentication tokens

---

## Known Limitations

### Current Constraints
- Requires Java 25+ (current environment has JDK 21)
- Build process requires Gradle wrapper execution (~10-15 min)
- Larger memory footprint than LaurieWired (~2-3GB vs 1-2GB)
- Some exotic architectures may have limited decoder support
- Live debugger integration not included (requires bethington)

### Workarounds
1. **Java 21**: Keep LaurieWired operational, plan upgrade path
2. **Build delays**: Run builds offline when network unavailable
3. **Memory pressure**: Use headless mode with reduced heap
4. **Architecture limits**: Manual intervention for unsupported ISAs
5. **Debugger needs**: Combine with bethington for full coverage

---

## Next Steps

1. **Immediate:** Continue using LaurieWired for immediate needs
2. **Short-Term:** Plan Java 25 upgrade (check availability)
3. **Medium-Term:** Deploy symgraph when Java 25 available
4. **Long-Term:** Evaluate bethington for maximum feature requirements

### Upgrade Path Checklist
- [ ] Install Java 25+ (check OS compatibility)
- [ ] Backup current environment
- [ ] Test symgraph build in isolated env
- [ ] Validate all 49 tools functionality
- [ ] Configure AI client integrations
- [ ] Document lessons learned
- [ ] Update improvement tracker

---

*Integrated into Dangyun protocol: Ready for deployment upon Java 25 upgrade.*  
*Source: symgraph/GhidrAssistMCP v1.0.0*  
*Next improvement cycle: After successful deployment and real-world testing.*  
*Note: Requires Java 25+ for build; keep LaurieWired operational until then.*
