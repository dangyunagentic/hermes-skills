#!/bin/bash
# RECore Setup Script — Reverse Engineering Toolkit
# Installs all RE tools: radare2, Frida, JADX, Apktool, angr, etc.
# Run: bash skills/recore-setup.sh

set -e

echo "=========================================="
echo "🔧 RECore Setup — Reverse Engineering Suite"
echo "=========================================="
echo ""

# Step 1: Install system packages
echo "📦 Installing system packages (radare2, gdb, binwalk...)"
if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq
    
    # Core RE tools
    sudo apt-get install -y -qq \
        radare2 gdb binutils binutils binwalk strace ltrace file wget curl 2>/dev/null && \
        echo "✅ Core RE tools installed" || \
        echo "⚠️  Some packages may need manual installation"
else
    echo "⚠️  apt not found"
fi

# Step 2: Install JDK for JADX/Apktool
echo ""
echo "📥 Installing JDK 17 for JADX/Apktool..."
if ! java -version &> /dev/null; then
    sudo apt-get install -y -qq openjdk-17-jdk-headless 2>/dev/null && \
        echo "✅ JDK 17 installed" || \
        echo "⚠️  JDK installation failed"
else
    echo "✅ JDK already available: $(java -version 2>&1 | head -1)"
fi

# Step 3: Download and setup JADX
echo ""
echo "🔍 Setting up JADX APK decompiler v1.5.6..."

JADX_DIR="${HOME}/tools/jadx"
JADX_BIN="$JADX_DIR/bin"

if [ ! -d "$JADX_DIR" ]; then
    mkdir -p "$JADX_DIR"
    cd "$JADX_DIR"
    
    echo "Downloading jadx-1.5.6.zip..."
    wget -q https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip
    
    unzip -q jadx-1.5.6.zip
    
    # Create symlinks
    sudo ln -s "$JADX_BIN/jadx" /usr/local/bin/jadx
    sudo ln -s "$JADX_BIN/jadxi" /usr/local/bin/jadxi
    
    echo "✅ JADX v1.5.6 installed at $JADX_DIR"
else
    echo "✅ JADX already exists at $JADX_DIR"
fi

# Step 4: Download and setup Apktool
echo ""
echo "🔍 Setting up Apktool v2.9.3..."

APKTOOL_JAR="/opt/apktool.jar"
APKTOOL_BIN="/usr/local/bin/apktool"

if [ ! -f "$APKTOOL_JAR" ]; then
    wget -q -O "$APKTOOL_JAR" https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar
    
    cat > "$APKTOOL_BIN" << 'EOF'
#!/bin/bash
exec java -jar "/opt/apktool.jar" "$@"
EOF
    chmod +x "$APKTOOL_BIN"
    
    echo "✅ Apktool v2.9.3 installed"
else
    echo "✅ Apktool already installed"
fi

# Step 5: Install Python packages
echo ""
echo "🐍 Installing Python dependencies..."

# Core RE frameworks (prompt-based)
read -p "Install advanced RE frameworks (angr, unicorn, capstone)? (y/n): " install_advanced
if [[ $install_advanced =~ ^[Yy]$ ]]; then
    pip3 install --break-system-packages angr unicorn capstone frida frida-tools 2>/dev/null && \
        echo "✅ Advanced RE frameworks installed" || \
        echo "⚠️  Framework installation had issues"
else
    echo "⏭️  Skipped advanced frameworks (can install manually later)"
fi

# Frida CLI only (always install)
pip3 install --break-system-packages frida frida-tools 2>/dev/null && \
    echo "✅ Frida CLI installed" || \
    echo "⚠️  Frida install skipped"

# Step 6: Update environment
echo ""
echo "🔧 Updating environment configuration..."
cat >> ~/.hermes.env << 'EOF'

# RECore Configuration
export RECORE_ENABLED=true
export JADX_HOME="${HOME}/tools/jadx"
export APKTOOL_JAR="/opt/apktool.jar"
export PATH=$PATH:/usr/local/bin:$JADX_HOME/bin
EOF

echo "✅ Environment updated!"

# Step 7: Verification
echo ""
echo "🧪 Verifying installation..."
echo ""
echo "System tools:"
which r2 gdb strings readelf binwalk strace ltrace file | xargs -I {} basename {}

echo ""
echo "APK tools:"
jadx --version 2>&1 | head -1 || echo "⚠️ jadx not found"
apktool --version 2>&1 | head -1 || echo "⚠️ apktool not found"

echo ""
echo "Python modules:"
python3 -c "import frida; print(f'frida: {frida.__version__}')" 2>/dev/null || echo "⚠️ frida not found"
python3 -c "import angr; print(f'angr: {angr.__version__}')" 2>/dev/null || echo "⚠️ angr not found (optional)"
python3 -c "import unicorn; print(f'unicorn: {unicorn.__version__}')" 2>/dev/null || echo "⚠️ unicorn not found (optional)"
python3 -c "import capstone; print(f'capstone: {capstone.__version__}')" 2>/dev/null || echo "⚠️ capstone not found (optional)"

echo ""
echo "=========================================="
echo "✨ RECore Setup Complete!"
echo "=========================================="
echo ""
echo "Quick test commands:"
echo "  recore-getinfo /path/to/binary          # Get binary info"
echo "  recore-extract-strings /path/file       # Extract strings"
echo "  recore-decompile-apk /app.apk           # Decompile APK"
echo "  guardx-quickstart.sh validate           # Full validation"
echo ""
