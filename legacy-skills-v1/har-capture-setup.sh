#!/bin/bash
# HAR Capture Suite Setup Script
# Installs and configures both chrome-har-capturer and waguria HAR suite

set -e

HAR_SUITE_DIR="${HAR_SUITE_DIR:-/root/har-suite}"
echo "🚀 Setting up HAR Capture Suite..."
echo "   Target directory: $HAR_SUITE_DIR"

# Check prerequisites
echo ""
echo "✓ Checking prerequisites..."
command -v node >/dev/null 2>&1 || { echo "❌ Node.js not found. Install first."; exit 1; }
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "⚠️  Node.js ${NODE_VERSION}. Need 20+. Consider updating via nvm."
fi

command -v google-chrome >/dev/null 2>&1 || \
command -v chromium-browser >/dev/null 2>&1 || \
command -v chromium >/dev/null 2>&1 || { echo "⚠️  Chrome/Chromium not found. Required for CDP."; }

mkdir -p "$HAR_SUITE_DIR"

# Clone repos if not present
if [ ! -d "$HAR_SUITE_DIR/.git" ]; then
    echo ""
    echo "📦 Cloning repositories..."
    cd "$HAR_SUITE_DIR"
    git clone https://github.com/waguriagentic/HAR .
    mkdir -p lib/legacy
    git clone https://github.com/cyrus-and/chrome-har-capturer /tmp/chh-temp 2>/dev/null || true
    cp -r /tmp/chh-temp/lib/* lib/legacy/ 2>/dev/null || true
    rm -rf /tmp/chh-temp
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
cd "$HAR_SUITE_DIR"
npm install

# Build extension
echo ""
echo "🔨 Building Chrome extension..."
npm run build:extension 2>&1 | tail -5

# Create startup script
echo ""
echo "📝 Creating convenience scripts..."
cat > start-capture.sh << 'EOF'
#!/bin/bash
# Quick-start HAR capture setup
echo "Starting HAR Capture Suite..."

# Kill existing Chrome debug sessions
pkill -f "remote-debugging-port=9222" 2>/dev/null || true

# Start Chrome with debugging
echo "Launching Chrome with remote debugging on port 9222..."
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/har-chrome-debug \
  --disable-gpu --no-sandbox &
CHROME_PID=$!

echo "Chrome PID: $CHROME_PID"
echo "Waiting for debugger to be ready..."
sleep 3

# Verify connection
curl -s http://localhost:9222/json/version >/dev/null && echo "✅ Debug server ready!" || echo "⚠️  Wait longer for Chrome"

# Start desktop app in background
echo "Starting desktop app..."
cd /root/har-suite
npm run dev &
DESKTOP_PID=$!

echo ""
echo "=========================================="
echo "HAR Capture Suite Ready!"
echo "=========================================="
echo "Chrome debugging: http://localhost:9222"
echo "Desktop app:      http://localhost:5173 (or check tray)"
echo ""
echo "Next steps:"
echo "1. Open chrome://extensions in regular Chrome"
echo "2. Enable Developer mode, Load unpacked → /root/har-suite/extension/dist/"
echo "3. Copy pairing token from desktop app, paste in extension popup"
echo "4. Add target domains to allowlist"
echo "5. Visit targets and watch live traffic in desktop app"
echo ""
echo "Press Ctrl+C to stop all services"
echo "=========================================="

wait
EOF
chmod +x start-capture.sh

# CLI helper
cat > cli-capture.sh << 'EOF'
#!/bin/bash
# Quick CLI HAR capture
cd /root/har-suite
node cli.mjs "$@"
EOF
chmod +x cli-capture.sh

echo "✅ HAR Capture Suite setup complete!"
echo ""
echo "Quick start options:"
echo "1. Run full stack (Chrome + Desktop): ./start-capture.sh"
echo "2. CLI only: ./cli-capture.sh <urls...>"
echo "3. Desktop only: npm run dev"
echo "4. Extension build: npm run build:extension"
echo ""
echo "Documentation: skills/har-capture-suite.md"
