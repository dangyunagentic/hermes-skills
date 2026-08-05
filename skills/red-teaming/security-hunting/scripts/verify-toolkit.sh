#!/bin/bash
# Verify the full offensive toolkit installation. Run after installs/updates.
# Usage: bash verify-toolkit.sh

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
PASS=0; FAIL=0

check() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "✅ $1"; PASS=$((PASS+1))
    else
        echo "❌ $1"; FAIL=$((FAIL+1))
    fi
}

echo "=== RE tools ==="
check r2; check gdb; check binwalk; check strace; check ltrace

echo "=== Java tools ==="
check java; check jadx; check apktool
[ -x /opt/ghidra_12.1.2_PUBLIC/ghidraRun ] && { echo "✅ ghidra"; PASS=$((PASS+1)); } || { echo "❌ ghidra"; FAIL=$((FAIL+1)); }

echo "=== Go bug bounty ==="
check nuclei; check subfinder; check httpx; check katana; check amass

echo "=== Python frameworks ==="
for mod in angr unicorn capstone frida pwn browserforge fpgen; do
    python3 -c "import $mod" 2>/dev/null && { echo "✅ py:$mod"; PASS=$((PASS+1)); } || { echo "❌ py:$mod"; FAIL=$((FAIL+1)); }
done

echo "=== GuardX ==="
[ -f /root/tools/guardx/guardx/guardx.py ] && python3 /root/tools/guardx/guardx/guardx.py --list >/dev/null 2>&1 && { echo "✅ guardx"; PASS=$((PASS+1)); } || { echo "❌ guardx (re-clone: git clone https://github.com/dhikadrian/guardx /root/tools/guardx && cd /root/tools/guardx && unzip -oq guardx.zip)"; FAIL=$((FAIL+1)); }

echo ""
echo "Result: $PASS passed, $FAIL failed"
exit $FAIL
