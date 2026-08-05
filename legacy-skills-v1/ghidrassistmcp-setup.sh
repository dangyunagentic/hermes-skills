#!/bin/bash
# GhidrAssistMCP - Symgraph Installation Script
# Requires Java 25+ (upgrade from current JDK 21)
# This script prepares the environment and builds the extension

set -e

echo "=== GhidrAssistMCP - Symgraph Installation ==="
echo ""
echo "⚠️  WARNING: This requires Java 25+ to build."
echo "   Current system has JDK 21.0.11"
echo ""

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | head -1 | grep -oP '\d+\.\d+')
echo "Detected Java version: $JAVA_VERSION"

if [[ "$JAVA_VERSION" < "25" ]]; then
    echo ""
    echo "❌ Java version too low!"
    echo ""
    echo "Options:"
    echo "1. Upgrade to Java 25+:"
    echo "   sudo add-apt-repository ppa:openjdk-r/ppa && sudo apt update"
    echo "   sudo apt install openjdk-25-jdk"
    echo ""
    echo "2. Or keep using LaurieWired (JDK 21 compatible):"
    echo "   cd /root/tools/GhidraMCP-Laurie && source .venv/bin/activate && python bridge_mcp_ghidra.py"
    echo ""
    exit 1
fi

echo "✅ Java 25+ detected, proceeding with installation..."
echo ""

GHIDRA_INSTALL_DIR="${GHIDRA_INSTALL_DIR:-/opt/ghidra_11.4.3_PUBLIC}"
SYMGRAPH_REPO="/root/tools/GhidrAssistMCP-symgraph"

# Verify Ghidra installation
if [ ! -d "$GHIDRA_INSTALL_DIR" ]; then
    echo "❌ Ghidra not found at $GHIDRA_INSTALL_DIR"
    echo "Please install Ghidra 11.4+ first"
    exit 1
fi

echo "✅ Ghidra found at: $GHIDRA_INSTALL_DIR"

# Clone repository if not exists
if [ ! -d "$SYMGRAPH_REPO/.git" ]; then
    echo "Cloning symgraph/GhidrAssistMCP..."
    git clone https://github.com/symgraph/GhidrAssistMCP "$SYMGRAPH_REPO"
else
    echo "Repository already exists, updating..."
    cd "$SYMGRAPH_REPO"
    git pull
fi

cd "$SYMGRAPH_REPO"

# Set Gradle properties
export GHIDRA_INSTALL_DIR
export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64  # Adjust path as needed

echo ""
echo "Building GhidrAssistMCP extension..."
echo "This may take 10-15 minutes on first build..."
echo ""

# Build with Gradle wrapper
./gradlew clean installExtension

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "Installation location: $GHIDRA_INSTALL_DIR/Extensions/Ghidra/GhidrAssistMCP"
    echo ""
    echo "Next steps:"
    echo "1. Restart Ghidra"
    echo "2. Enable plugin: File → Configure Plugins → Search 'GhidrAssistMCP'"
    echo "3. Open configuration: Window → GhidrAssistMCP"
    echo "4. Configure server settings (host: localhost, port: 8080)"
    echo "5. Enable required tools via Configuration tab"
    echo ""
    echo "MCP Server URLs:"
    echo "  SSE endpoint:   http://127.0.0.1:8080/sse"
    echo "  HTTP endpoint:  http://127.0.0.1:8080/mcp"
    echo "  Message path:   http://127.0.0.1:8080/message"
    echo ""
    echo "Test connection:"
    echo "  curl http://127.0.0.1:8080/sse  # Should connect"
    echo "  curl http://127.0.0.1:8080/mcp  # Should return MCP JSON"
    echo ""
else
    echo "❌ Build failed! Check error messages above."
    exit 1
fi
