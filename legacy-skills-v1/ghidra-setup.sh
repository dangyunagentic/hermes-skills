#!/bin/bash
# Ghidra Reverse Engineering Suite Installer
# Downloads and installs latest stable Ghidra release from NSA GitHub

set -e

GHIDRA_DIR="${GHIDRA_DIR:-/opt/ghidra}"
VERSION="${GHIDRA_VERSION:-11.2.5_PUBLIC}"  # Stable version compatible with JDK 21

echo "🔧 Setting up Ghidra Reverse Engineering Suite..."
echo "   Target directory: $GHIDRA_DIR"
echo "   Version: $VERSION"

# Verify Java installation
echo ""
echo "✓ Checking Java requirements..."
java -version >/dev/null 2>&1 || { echo "❌ Java not found. Install JDK 21+ first."; exit 1; }
JAVA_VER=$(java -version 2>&1 | head -1)
echo "   Found: $JAVA_VER"

# Check disk space
echo ""
echo "✓ Checking disk space..."
FREE_SPACE=$(df -BG /opt | awk 'NR==2 {print $4}' | tr -d 'G')
if [ "${FREE_SPACE%G}" -lt 5 ]; then
    echo "⚠️  WARNING: Less than 5GB free in /opt. Ghidra needs ~2GB."
fi

# Create installation directory
mkdir -p "$GHIDRA_DIR"
cd "$GHIDRA_DIR"

# Download Ghidra release
RELEASE_URL=""
case "$VERSION" in
    *"11.2"*|*"11_2"*)
        RELEASE_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${VERSION//_/}/ghidra_${VERSION}.zip"
        ;;
    *"12.0"*|*"12_0"*)
        RELEASE_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.0_PUBLIC/ghidra_12.0_PUBLIC.zip"
        ;;
    *)
        # Try generic pattern
        VERSION_NUM=${VERSION//_PUBLIC/}
        VERSION_NUM=${VERSION_NUM//./_}
        RELEASE_URL="https://github.com/NationalSecurityAgency/ghidra/releases/latest/download/ghidra_${VERSION}.zip"
        ;;
esac

echo ""
echo "📦 Downloading Ghidra $VERSION..."
echo "   URL: $RELEASE_URL"

if command -v wget >/dev/null 2>&1; then
    wget -q --show-progress "$RELEASE_URL" -O ghidra_download.zip || \
        wget "$RELEASE_URL" -O ghidra_download.zip 2>/dev/null
elif command -v curl >/dev/null 2>&1; then
    curl -L -o ghidra_download.zip "$RELEASE_URL" 2>/dev/null
else
    echo "❌ Neither wget nor curl available. Install one and try again."
    exit 1
fi

# Verify download
if [ ! -f ghidra_download.zip ] || [ ! -s ghidra_download.zip ]; then
    echo "❌ Download failed or corrupted file."
    echo "   Try manually from: https://github.com/NationalSecurityAgency/ghidra/releases"
    exit 1
fi

echo "✅ Download complete ($(du -h ghidra_download.zip | cut -f1))"

# Extract archive
echo ""
echo "📂 Extracting archive..."
unzip -q ghidra_download.zip
EXTRACTED_DIR=$(ls -d ghidra_*_PUBLIC 2>/dev/null | head -1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "❌ Extraction failed. Check download format."
    exit 1
fi

echo "✅ Extracted: $EXTRACTED_DIR"

# Setup launcher scripts
echo ""
echo "📝 Creating launcher scripts..."

cat > ghidra_gui << 'SCRIPT'
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
exec /root/tools/ghidra_setup/$EXTRACTED_DIR/support/ghidraRun "$@"
SCRIPT
chmod +x ghidra_gui

cat > ghidra_headless << 'SCRIPT'
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
exec /root/tools/ghidra_setup/$EXTRACTED_DIR/support/analyzeHeadless "$@"
SCRIPT
chmod +x ghidra_headless

cat > ghidra_python << 'SCRIPT'
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
exec /root/tools/ghidra_setup/$EXTRACTED_DIR/support/pyghidraRun "$@"
SCRIPT
chmod +x ghidra_python

# Create symbolic links in PATH
sudo ln -sf "$GHIDRA_DIR/ghidra_gui" /usr/local/bin/ghidra_gui 2>/dev/null || true
sudo ln -sf "$GHIDRA_DIR/ghidra_headless" /usr/local/bin/ghidra_headless 2>/dev/null || true
sudo ln -sf "$GHIDRA_DIR/ghidra_python" /usr/local/bin/ghidra_python 2>/dev/null || true

# Cleanup
rm -f ghidra_download.zip

echo ""
echo "✅ Ghidra installation complete!"
echo ""
echo "Quick start options:"
echo "1. GUI mode:      ghidra_gui"
echo "2. Headless mode: ghidra_headless <project> <binary>"
echo "3. Python API:    ghidra_python -script your_script.py binary"
echo ""
echo "Full documentation: skills/ghidra-reverse-engineering-suite.md"
echo "Installation directory: $GHIDRA_DIR/$EXTRACTED_DIR/"
