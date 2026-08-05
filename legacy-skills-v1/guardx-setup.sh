#!/bin/bash
# GuardX Setup Script — Web Vuln + Exploit + RE Hybrid
# Installs all GuardX dependencies and configures environment
# Run: bash skills/guardx-setup.sh

set -e

echo "=========================================="
echo "🛡️  GuardX Setup — Web Vuln + Exploit Suite"
echo "=========================================="
echo ""

# Check Python
python3 --version > /dev/null 2>&1 || { echo "❌ Python 3 required"; exit 1; }
echo "✅ Python: $(python3 --version)"

# Step 1: Install system packages
echo ""
echo "📦 Installing system packages..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq wget curl git file 2>/dev/null
    echo "✅ System packages installed"
else
    echo "⚠️  apt not found, install manually: wget curl git file"
fi

# Step 2: Install Python packages
echo ""
echo "🐍 Installing Python dependencies..."

# GuardX core deps
pip3 install --break-system-packages \
    requests>=2.28.0 \
    urllib3>=1.26.0 \
    cloudscraper>=1.2.71 \
    aiohttp>=3.9.0 \
    aiodns>=3.2.0 \
    PyYAML>=6.0 2>/dev/null && \
    echo "✅ GuardX Python dependencies installed" || \
    echo "⚠️  Some packages may need manual install"

# Step 3: Clone GuardX repo if not present
echo ""
echo "📥 Cloning GuardX toolkit..."
GUARDX_DIR="${HOME}/.hermes/profiles/default/guardx-toolkit"

if [ ! -d "$GUARDX_DIR" ]; then
    git clone --depth 1 https://github.com/dhikadrian/guardx.git "$GUARDX_DIR" 2>/dev/null && \
        echo "✅ GuardX toolkit cloned to $GUARDX_DIR" || \
        echo "⚠️  Clone failed - manually clone: git clone https://github.com/dhikadrian/guardx.git $GUARDX_DIR"
else
    echo "✅ GuardX toolkit already exists at $GUARDX_DIR"
fi

# Step 4: Create Python venv for GuardX
echo ""
echo "🔧 Setting up Python venv..."
if [ -d "$GUARDX_DIR" ] && [ ! -d "$GUARDX_DIR/guardx_env" ]; then
    python3 -m venv "$GUARDX_DIR/guardx_env"
    source "$GUARDX_DIR/guardx_env/bin/activate"
    pip install -r "$GUARDX_DIR/requirements.txt" 2>/dev/null
    deactivate
    echo "✅ Python venv created at $GUARDX_DIR/guardx_env"
else
    echo "✅ Python venv already exists"
fi

# Step 5: Install into Hermes skills directory
echo ""
echo "📦 Installing GuardX skill to Hermes profile..."
HERMES_SKILLS_DIR="${HOME}/.hermes/profiles/default/skills"
mkdir -p "$HERMES_SKILLS_DIR/guardx"

# Copy skill files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp -r "$SCRIPT_DIR/guardx/"* "$HERMES_SKILLS_DIR/guardx/" 2>/dev/null || true

echo "✅ GuardX skill installed to $HERMES_SKILLS_DIR/guardx/"

# Step 6: Update environment
echo ""
echo "🔧 Updating environment..."
cat >> ~/.hermes.env << 'EOF'

# GuardX Configuration
export GUARDX_ENABLED=true
export GUARDX_DIR="${HOME}/.hermes/profiles/default/guardx-toolkit"
export GUARDX_ENV="${GUARDX_DIR}/guardx_env/bin/python"
EOF

echo "✅ Environment updated!"

# Step 7: Verify installation
echo ""
echo "🧪 Verification..."
echo "  Python packages:"
pip3 list 2>/dev/null | grep -E "(requests|cloudscraper|aiohttp|PyYAML)" | head -5
echo ""
echo "  Skill files:"
ls -la "$HERMES_SKILLS_DIR/guardx/" 2>/dev/null

echo ""
echo "=========================================="
echo "✨ GuardX Setup Complete!"
echo "=========================================="
echo ""
echo "Quick test:"
echo "  guardx-quickstart.sh list           # List exploits"
echo "  guardx-quickstart.sh scan example.com # Scan target"
echo "  guardx-quickstart.sh validate        # Validate install"
echo ""
