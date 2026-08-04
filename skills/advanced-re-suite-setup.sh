#!/bin/bash
# Advanced Reverse Engineering Suite Installer
# Installs angr + pwndbg + pwntools for complete RE toolchain

set -e

RE_SUITE_DIR="${RE_SUITE_DIR:-/root/re-suites}"
echo "🔧 Setting up Advanced Reverse Engineering Suite..."
echo "   Target directory: $RE_SUITE_DIR"

# Check prerequisites
echo ""
echo "✓ Checking prerequisites..."
command -v python3 >/dev/null 2>&1 || { echo "❌ Python3 not found."; exit 1; }
PYTHON_VERSION=$(python3 --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$PYTHON_VERSION" -lt 3 ]; then
    echo "⚠️  Python ${PYTHON_VERSION}. Need 3.6+"
fi

command -v pip3 >/dev/null 2>&1 || { echo "⚠️  pip3 not found. Install first."; }

mkdir -p "$RE_SUITE_DIR"

# Clone repositories
if [ ! -d "$RE_SUITE_DIR/angr/.git" ]; then
    echo ""
    echo "📦 Cloning RE repositories..."
    
    cd "$RE_SUITE_DIR"
    
    # angr - Symbolic execution framework
    if [ ! -d "angr" ]; then
        git clone --depth 1 https://github.com/angr/angr.git 2>&1 | tail -1
        echo "✅ angr cloned"
    fi
    
    # pwndbg - Enhanced GDB/LLDB
    if [ ! -d "pwndbg" ]; then
        git clone --depth 1 https://github.com/pwndbg/pwndbg.git 2>&1 | tail -1
        echo "✅ pwndbg cloned"
    fi
    
    # pwntools - Exploit development framework
    if [ ! -d "pwntools" ]; then
        git clone --depth 1 https://github.com/Gallopsled/pwntools.git 2>&1 | tail -1
        echo "✅ pwntools cloned"
    fi
fi

# Install system dependencies
echo ""
echo "📦 Installing system dependencies..."
sudo apt-get update -qq 2>/dev/null || true
sudo apt-get install -y -qq python3-dev gdb llvm libssl-dev binutils-dev qemu-user 2>/dev/null || \
    echo "⚠️  Some system packages may need manual installation"

# Install Python dependencies for angr
echo ""
echo "📦 Installing angr dependencies..."
if [ -d "$RE_SUITE_DIR/angr" ]; then
    pip3 install --upgrade pip 2>/dev/null || true
    pip3 install angr pyvyxus unicorn z3-solver claripy archinfo cle keystone-engine capstone 2>&1 | tail -5 || \
        echo "⚠️  angr install may have warnings"
fi

# Install pwndbg
echo ""
echo "🔧 Installing pwndbg..."
if [ -d "$RE_SUITE_DIR/pwndbg" ]; then
    cd "$RE_SUITE_DIR/pwndbg"
    ./setup.sh 2>&1 | tail -10 || echo "⚠️  pwndbg setup completed with warnings"
    cd "$RE_SUITE_DIR"
fi

# Install pwntools
echo ""
echo "📦 Installing pwntools..."
if [ -d "$RE_SUITE_DIR/pwntools" ]; then
    cd "$RE_SUITE_DIR/pwntools"
    pip3 install -e . 2>&1 | tail -5 || echo "⚠️  pwntools install completed with warnings"
    cd "$RE_SUITE_DIR"
fi

# Create unified RE client wrapper
echo ""
echo "📝 Creating unified RE client..."
cat > unified_re_client.py << 'EOF'
#!/usr/bin/env python3
"""Unified Reverse Engineering Client"""
import subprocess
import sys
from pathlib import Path

class ReClient:
    """Unified interface for angr, pwndbg, and pwntools"""
    
    def __init__(self):
        self.binary = None
        self.arch = None
        
    def analyze(self, binary_path):
        """Run static analysis with angr"""
        try:
            import angr
            print(f"[+] Loading binary: {binary_path}")
            project = angr.Project(binary_path, auto_load_libs=False)
            print(f"[+] Loaded {project.filename}")
            return project
        except ImportError:
            print("❌ angr not installed. Run: pip3 install angr")
            return None
        except Exception as e:
            print(f"❌ Error loading binary: {e}")
            return None
    
    def debug(self, binary_path, args=None):
        """Launch pwndbg debugger"""
        cmd = ['gdb', '-q']
        if args:
            cmd.extend(args)
        cmd.append(binary_path)
        
        print(f"🔍 Launching debugger...")
        subprocess.run(cmd)
    
    def connect_remote(self, host, port):
        """Connect to remote service via pwntools"""
        try:
            from pwn import *
            context.log_level = 'error'
            p = remote(host, port)
            print(f"✓ Connected to {host}:{port}")
            return p
        except ImportError:
            print("❌ pwntools not installed. Run: pip3 install pwntools")
            return None
        except Exception as e:
            print(f"❌ Connection failed: {e}")
            return None
    
    def process_local(self, binary_path, args=None):
        """Launch local process via pwntools"""
        try:
            from pwn import *
            context.binary = ELF(binary_path)
            p = process([binary_path] + (args or []))
            print(f"✓ Local process started")
            return p
        except ImportError:
            print("❌ pwntools not installed. Run: pip3 install pwntools")
            return None
        except Exception as e:
            print(f"❌ Process launch failed: {e}")
            return None


if __name__ == '__main__':
    print("Advanced RE Suite Client")
    print("=" * 40)
    print("Usage:")
    print("  client = ReClient()")
    print("  ")
    print("  # Static analysis")
    print("  project = client.analyze('target_binary')")
    print("  ")
    print("  # Debug session")
    print("  client.debug('target_binary')")
    print("  ")
    print("  # Remote connection")
    print("  p = client.connect_remote('host', 1337)")
    print("  ")
    print("  # Local process")
    print("  p = client.process_local('target_binary', ['arg1', 'arg2'])")
    print("=" * 40)
EOF
chmod +x unified_re_client.py

# Create quick-start scripts
cat > analyze-binary.sh << 'SCRIPT'
#!/bin/bash
# Quick binary analysis with angr
if [ -z "$1" ]; then
    echo "Usage: ./analyze-binary.sh <binary>"
    exit 1
fi

cd /root/re-suites/angr
python3 -c "
import angr
project = angr.Project('$1', auto_load_libs=False)
cfg = project.analyses.CFGFast()
print(f'Found {len(cfg.functions)} functions')
print('Key functions:')
for name in sorted(cfg.kb.functions.keys()):
    if 'flag' in name.lower() or 'check' in name.lower():
        print(f'  - {name}: {hex(cfg.kb.functions[name].addr)}')
"
SCRIPT
chmod +x analyze-binary.sh

cat > debug-binary.sh << 'SCRIPT'
#!/bin/bash
# Quick debugging with pwndbg
if [ -z "$1" ]; then
    echo "Usage: ./debug-binary.sh <binary> [args...]"
    exit 1
fi

cd /root/re-suites/pwndbg
gdb -q "$@"
SCRIPT
chmod +x debug-binary.sh

cat > solve-ctf.sh << 'SCRIPT'
#!/bin/bash
# CTF challenge automation with pwntools
if [ -z "$1" ]; then
    echo "Usage: ./solve-ctf.sh <service_host> <service_port>"
    exit 1
fi

HOST="$1"
PORT="$2"

python3 << PYEOF
from pwn import *
context.log_level = 'warning'

# Connect to service
p = remote('$HOST', $PORT)

# Send flag format
p.sendline(b'FLAG{...}')

# Try brute force patterns
import string
prefix = b'FLAG{'
for pattern in range(1000):
    payload = prefix + str(pattern).encode().ljust(20, b'A') + b'}'
    p.sendline(payload)
    response = p.recvline(timeout=2)
    if b'correct' in response.lower() or b'success' in response.lower():
        print(f'[+] Found flag: {payload.decode()}')
        break

p.close()
PYEOF
SCRIPT
chmod +x solve-ctf.sh

echo ""
echo "✅ Advanced RE Suite setup complete!"
echo ""
echo "Quick start options:"
echo "1. Unified client: python3 unified_re_client.py"
echo "2. Binary analysis: ./analyze-binary.sh <binary>"
echo "3. Debug session: ./debug-binary.sh <binary>"
echo "4. CTF solve: ./solve-ctf.sh <host> <port>"
echo ""
echo "Full documentation: skills/advanced-re-engineering-suite.md"
