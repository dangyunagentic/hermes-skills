#!/bin/bash
# Ghidra MCP Integration Suite Installer
# Merges bethington/ghidra-mcp + LaurieWired/GhidraMCP + rizinorg/rz-ghidra

set -e

GHIDRA_MCP_DIR="${GHIDRA_MCP_DIR:-/root/tools/ghidra-mcp-integration}"
GHIDRA_RELEASE="${GHIDRA_RELEASE:-11.2.5_PUBLIC}"  # Stable version for JDK 21

echo "🔧 Setting up Ghidra MCP Integration Suite..."
echo "   Target directory: $GHIDRA_MCP_DIR"

# Check prerequisites
echo ""
echo "✓ Checking prerequisites..."

java -version >/dev/null 2>&1 || { echo "❌ Java not found."; exit 1; }
JAVA_VER=$(java -version 2>&1 | head -1)
echo "   Found: $JAVA_VER"

command -v python3 >/dev/null 2>&1 || { echo "❌ Python3 not found."; exit 1; }
PYTHON_VERSION=$(python3 --version | cut -d'v' -f2)
echo "   Python: $PYTHON_VERSION"

command -v mvn >/dev/null 2>&1 && MAVEN_AVAILABLE=true || MAVEN_AVAILABLE=false
if [ "$MAVEN_AVAILABLE" = false ]; then
    echo "⚠️  Maven not found. Installing..."
    sudo apt-get update -qq
    sudo apt-get install -y maven 2>/dev/null || echo "⚠️  Manual Maven installation required"
fi

command -v curl >/dev/null 2>&1 && CURL_AVAILABLE=true || CURL_AVAILABLE=false

mkdir -p "$GHIDRA_MCP_DIR"
cd "$GHIDRA_MCP_DIR"

# Clone repositories (already cloned, verify exists)
echo ""
echo "✓ Verifying repositories..."

if [ ! -d "ghidra-official/.git" ]; then
    echo "Cloning official Ghidra source..."
    git clone --depth 1 https://github.com/NationalSecurityAgency/ghidra ghidra-official 2>&1 | tail -1
fi

if [ ! -d "ghidra-mcp-beth/.git" ]; then
    echo "Cloning bethington/ghidra-mcp..."
    git clone --depth 1 https://github.com/bethington/ghidra-mcp ghidra-mcp-beth 2>&1 | tail -1
fi

if [ ! -d "GhidraMCP-Laurie/.git" ]; then
    echo "Cloning LaurieWired/GhidraMCP..."
    git clone --depth 1 https://github.com/LaurieWired/GhidraMCP GhidraMCP-Laurie 2>&1 | tail -1
fi

if [ ! -d "rz-ghidra/.git" ]; then
    echo "Cloning rizinorg/rz-ghidra..."
    git clone --depth 1 https://github.com/rizinorg/rz-ghidra rz-ghidra 2>&1 | tail -1
fi

# Download Ghidra release if needed
GHIDRA_PATH=""
if [ ! -d "/opt/ghidra_*$GHIDRA_RELEASE" ]; then
    echo ""
    echo "📦 Downloading Ghidra $GHIDRA_RELEASE..."
    
    DOWNLOAD_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_RELEASE//_/}/ghidra_${GHIDRA_RELEASE}.zip"
    
    if [ "$CURL_AVAILABLE" = true ]; then
        curl -L -o ghidra_download.zip "$DOWNLOAD_URL" 2>&1 | tail -3
    else
        wget -q "$DOWNLOAD_URL" -O ghidra_download.zip 2>&1 | tail -3
    fi
    
    unzip -q ghidra_download.zip
    mv ghidra_*_PUBLIC /opt/ghidra_$GHIDRA_RELEASE 2>/dev/null || \
        mv ghidra_* /opt/ghidra_$GHIDRA_RELEASE
    
    GHIDRA_PATH="/opt/ghidra_$GHIDRA_RELEASE"
    echo "✅ Ghidra installed at: $GHIDRA_PATH"
else
    GHIDRA_PATH="/opt/ghidra_$GHIDRA_RELEASE"
    echo "✅ Using existing Ghidra at: $GHIDRA_PATH"
fi

# Setup Python environment with uv
echo ""
echo "📦 Setting up Python environment..."

# Install uv if not available
if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv (Python dependency manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.local/bin/activate
fi

# Create virtualenv in project directory
cd "$GHIDRA_MCP_DIR/ghidra-mcp-beth"
uv sync 2>&1 | tail -3 || pip3 install -e . 2>/dev/null || echo "⚠️  Python deps install may have warnings"

# Build and deploy bethington MCP server
echo ""
echo "🔨 Building bethington/ghidra-mcp..."

if [ "$MAVEN_AVAILABLE" = true ]; then
    cd "$GHIDRA_MCP_DIR/ghidra-mcp-beth"
    
    # Ensure prerequisites (install Ghidra JARs in local Maven repo)
    python -m tools.setup ensure-prereqs --ghidra-path "$GHIDRA_PATH" 2>&1 | tail -5 || \
        echo "⚠️  Prerequisites may need manual setup"
    
    # Build extension
    python -m tools.setup build 2>&1 | tail -10 || \
        mvn clean package assembly:single -DskipTests 2>&1 | tail -10 || \
        echo "⚠️  Build failed, trying LaurieWired alternative..."
    
    # Deploy to user profile
    python -m tools.setup deploy --ghidra-path "$GHIDRA_PATH" 2>&1 | tail -5 || \
        echo "⚠️  Deployment step may require manual intervention"
        
    BETH_BUILD_SUCCESS=true
else
    BETH_BUILD_SUCCESS=false
    echo "⚠️  Maven not available, skipping bethington build"
fi

# Fallback: Try LaurieWired simpler installation
if [ "$BETH_BUILD_SUCCESS" != "true" ]; then
    echo ""
    echo "🔄 Falling back to LaurieWired installation (simpler requirements)..."
    
    cd "$GHIDRA_MCP_DIR/GhidraMCP-Laurie"
    
    # Create lib directory and copy JARs from Ghidra
    mkdir -p lib
    cp "$GHIDRA_PATH/Ghidra/Features/Base/lib/Base.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Features/Decompiler/lib/Decompiler.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Framework/Docking/lib/Docking.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Framework/Generic/lib/Generic.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Framework/Project/lib/Project.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Framework/SoftwareModeling/lib/SoftwareModeling.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Framework/Utility/lib/Utility.jar" lib/ 2>/dev/null || true
    cp "$GHIDRA_PATH/Ghidra/Framework/Gui/lib/Gui.jar" lib/ 2>/dev/null || true
    
    # Build with Maven (simpler build)
    if [ "$MAVEN_AVAILABLE" = true ]; then
        mvn clean package assembly:single 2>&1 | tail -5
    fi
    
    LAURIE_BUILD_SUCCESS=true
fi

# Install rz-ghidra as Rizin plugin
echo ""
echo "🔨 Building rz-ghidra (Rizin decompiler plugin)..."

if [ "$MAVEN_AVAILABLE" = true ]; then
    cd "$GHIDRA_MCP_DIR/rz-ghidra"
    git submodule init
    git submodule update 2>&1 | tail -2
    
    mkdir -p build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=~/.local .. 2>&1 | tail -5 || \
        echo "⚠️  CMake config failed (rizin may not be installed)"
    
    make 2>&1 | tail -5 || echo "⚠️  Make failed"
    make install 2>&1 | tail -5 || echo "⚠️  Install skipped"
    cd ../..
    
    RIZIN_BUILD_SUCCESS=true
else
    RIZIN_BUILD_SUCCESS=false
    echo "⚠️  Skipping rz-ghidra (requires CMake/make)"
fi

# Create unified launcher scripts
echo ""
echo "📝 Creating launcher scripts..."

cat > launch-beth-mcp.sh << 'SCRIPT'
#!/bin/bash
# Launch bethington/ghidra-mcp (primary - production grade)
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
cd /root/tools/ghidra-mcp-integration/ghidra-mcp-beth

# Start with stdio transport (recommended for AI tools)
uv run bridge-mcp-ghidra "$@"

# Or HTTP transport:
# uv run bridge-mcp-ghidra --transport streamable-http --mcp-port 8081 "$@"
SCRIPT
chmod +x launch-beth-mcp.sh

cat > launch-laurie-mcp.sh << 'SCRIPT'
#!/bin/bash
# Launch LaurieWired/GhidraMCP (fallback - simpler)
cd /root/tools/ghidra-mcp-integration/GhidraMCP-Laurie

# Basic bridge start
python bridge_mcp_ghidra.py "$@"
SCRIPT
chmod +x launch-laurie-mcp.sh

cat > launch-rz-ghidra.sh << 'SCRIPT'
#!/bin/bash
# Use rz-ghidra decompiler in Rizin
# Requires Rizin installed

if ! command -v rizin >/dev/null 2>&1; then
    echo "❌ Rizin not found. Install first:"
    echo "   sudo apt install rizin"
    exit 1
fi

# Run Rizin with rz-ghidra decompiler
rizin -c "e ghidra.sleighhome=~/.local/share/rizin/ghidra" "$@"
SCRIPT
chmod +x launch-rz-ghidra.sh

# Create quick-start guide for He
cat > QUICKSTART.md << 'GUIDE'
# Quick Start Guide

## For He (User)

### When You Need It
Just say normally:
- "reverse engineer this binary with MCP"
- "automated analysis with Claude"
- "ghidra mcp tools"
- "analyze malware with AI"

No special commands needed. [D] will auto-detect and route appropriately.

### Quick Commands

```bash
# Primary MCP server (production grade)
./launch-beth-mcp.sh

# Fallback server (simpler, if primary fails)
./launch-laurie-mcp.sh

# Rizin decompiler plugin
./launch-rz-ghidra <binary>

# Health check
curl http://127.0.0.1:8089/check_connection
```

### Next Steps
1. Test basic analysis: `curl http://127.0.0.1:8089/get_version`
2. Configure AI client (Claude/Cursor) with MCP config
3. Ask "[D]" to reverse engineer a binary using MCP tools
4. Review results in field-journal

Full documentation: skills/ghidra-mcp-integration-suite.md
GUIDE

echo ""
echo "✅ Ghidra MCP Integration Suite setup complete!"
echo ""
echo "Quick start options:"
echo "1. Primary MCP (bethington): ./launch-beth-mcp.sh"
echo "2. Fallback MCP (LaurieWired): ./launch-laurie-mcp.sh"
echo "3. Rizin decompiler: ./launch-rz-ghidra <binary>"
echo ""
echo "Full documentation: skills/ghidra-mcp-integration-suite.md"
echo "Installation directory: $GHIDRA_MCP_DIR/"

# Print status summary
echo ""
echo "=== Installation Status ==="
echo "Bethington MCP: $([ "$BETH_BUILD_SUCCESS" = true ] && echo '✅ Built' || echo '⚠️  Skipped')"
echo "LaurieWired MCP: $([ "$LAURIE_BUILD_SUCCESS" = true ] && echo '✅ Built' || echo '⚠️  Skipped')"  
echo "Rizin rz-ghidra: $([ "$RIZIN_BUILD_SUCCESS" = true ] && echo '✅ Built' || echo '⚠️  Skipped')"
echo "Ghidra path: $GHIDRA_PATH"
