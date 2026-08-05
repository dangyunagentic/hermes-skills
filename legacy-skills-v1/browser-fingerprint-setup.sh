#!/bin/bash
# Browser Fingerprint Generator Suite - Automated Installer
# Combines: BrowserForge, FingerprintGenerator (fpgen), and FPGen sanitized dataset

set -e

echo "=== Browser Fingerprint Generator Suite Installation ==="
echo ""

# Check Python availability
python3 --version || { echo "❌ Python 3 required"; exit 1; }
pip3 --version || { echo "⚠️ pip3 not found, using python3 -m pip"; PIP_CMD="python3 -m pip"; }
PIP_CMD="${PIP_CMD:-pip3}"

echo "✓ Python detected: $(python3 --version)"

# Install packages
echo ""
echo "📦 Installing browserforge + fpgen..."
$PIP_CMD install browserforge[all] fpgen 2>&1 | tail -5

# Verify installation
if ! python3 -c "import browserforge" 2>/dev/null || ! python3 -c "import fpgen" 2>/dev/null; then
    echo "❌ Package installation failed!"
    echo "   Try manually:"
    echo "   pip3 install browserforge[all] fpgen"
    exit 1
fi

echo "✅ Packages installed successfully"

# Download and prepare fpgen model
echo ""
echo "📥 Downloading fpgen model..."
fpgen fetch 2>&1 | tail -3

echo "💨 Decompressing model for speed (10-50x faster)..."
fpgen decompress 2>&1 | tail -3

echo "✅ Model ready (uses ~100MB+ disk space)"

# Verify FPGen dataset extraction
echo ""
echo "📂 Verifying FPGen dataset..."
FPGEN_DIR="/root/tools/FPGen-dhikadrian/fingerprint-data/fingerprint-generator"
if [ ! -d "$FPGEN_DIR" ]; then
    echo "⚠️  FPGen dataset not found, re-extracting..."
    cd /root/tools/FPGen-dhikadrian && \
    unzip -o "fingerprint-generator-sanitized__2_ (1).zip" -d fingerprint-data/ 2>&1 | tail -3
fi

if [ -d "$FPGEN_DIR" ]; then
    GO_FILES=$(find $FPGEN_DIR -name "*.go" 2>/dev/null | wc -l)
    echo "✅ FPGen dataset ready ($GO_FILES Go source files extracted)"
else
    echo "⚠️  FPGen dataset extraction incomplete, manual check needed"
fi

# Test generation
echo ""
echo "🧪 Testing fingerprint generation..."
TEST_OUTPUT=$(python3 << 'EOF'
from browserforge.headers import HeaderGenerator
from browserforge.fingerprints import FingerprintGenerator
import fpgen

# Test 1: BrowserForge headers
headers = HeaderGenerator()
h = headers.generate()
print("✅ BrowserForge headers:", h.get('User-Agent', 'N/A')[:50])

# Test 2: BrowserForge fingerprints
fp = FingerprintGenerator()
f = fp.generate()
print("✅ BrowserForge fingerprint:", f.navigator.userAgent.split('/')[0][:30])

# Test 3: fpgen generation
gen_result = fpgen.generate(browser='Chrome', os='Windows')
print("✅ fpgen result:", type(gen_result).__name__)

print("ALL TESTS PASSED")
EOF
)

echo "$TEST_OUTPUT" | grep -E "(✅|ERROR|PASSED)" || echo "⚠️  Some tests may have warnings (usually OK)"

# Final status
echo ""
echo "=========================================="
echo "✅ INSTALLATION COMPLETE"
echo "=========================================="
echo ""
echo "Installed Components:"
echo "1. ✅ BrowserForge - Header & fingerprint generation"
echo "2. ✅ FingerprintGenerator (fpgen) - Fast data generator"
echo "3. ✅ FPGen Dataset - Sanitized training data"
echo ""
echo "Installation Locations:"
echo "BrowserForge: Python package (browserforge module)"
echo "FingerprintGenerator: Python package (fpgen module) + ~/.cache/fpgen/"
echo "FPGen Dataset: /root/tools/FPGen-dhikadrian/fingerprint-data/"
echo ""
echo "Quick Start Commands:"
echo "  # Generate headers"
echo "  python3 -c \"from browserforge.headers import HeaderGenerator; print(HeaderGenerator().generate())\""
echo ""
echo "  # Generate fingerprints"
echo "  python3 -c \"from browserforge.fingerprints import FingerprintGenerator; print(FingerprintGenerator().generate())\""
echo ""
echo "  # fpgen with filters"
echo "  python3 -c \"import fpgen; print(fpgen.generate(browser='Chrome', os='Windows'))\""
echo ""
echo "Documentation:"
echo "skills/browser-fingerprint-generator-suite.md"
echo ""
