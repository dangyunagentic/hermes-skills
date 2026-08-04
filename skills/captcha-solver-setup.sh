#!/bin/bash
# CAPTCHA Solver Suite Installation Script
# Installs all merged solvers: captcha-solvers-toolkit + nopecha + buster + others

set -e

CAPTCHA_SUITE_DIR="${CAPTCHA_SUITE_DIR:-/root/captcha-suite}"
echo "🔓 Setting up CAPTCHA Solver Suite..."
echo "   Target directory: $CAPTCHA_SUITE_DIR"

# Check prerequisites
echo ""
echo "✓ Checking prerequisites..."
command -v python3 >/dev/null 2>&1 || { echo "❌ Python3 not found."; exit 1; }
PYTHON_VERSION=$(python3 --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$PYTHON_VERSION" -lt 3 ]; then
    echo "⚠️  Python ${PYTHON_VERSION}. Need 3.6+";
fi

command -v node >/dev/null 2>&1 || { echo "⚠️  Node.js not found. Some features limited."; }

mkdir -p "$CAPTCHA_SUITE_DIR"

# Clone repositories
if [ ! -d "$CAPTCHA_SUITE_DIR/captcha-solvers-toolkit/.git" ]; then
    echo ""
    echo "📦 Cloning solver repositories..."
    
    cd "$CAPTCHA_SUITE_DIR"
    
    # Main toolkit
    git clone https://github.com/sanhaji182/captcha-solvers-toolkit captcha-solvers-toolkit
    
    # NopeCHA extension (source code archived, use releases)
    if [ ! -d "nopecha-extension" ]; then
        mkdir nopecha-extension
        echo "# NopeCHA Extension - Download from Chrome Web Store or GitHub releases" > nopecha-extension/README.md
        echo "URL: https://chrome.google.com/webstore/detail/nopecha/dknlfmjaanfblgfdfebhijalfmhmjjjo" >> nopecha-extension/README.md
    fi
    
    # Buster
    if [ ! -d "buster" ]; then
        git clone https://github.com/dessant/buster buster
    fi
    
    # UcelX solver
    if [ ! -d "ucelx-captcha-solver" ]; then
        git clone https://github.com/UcelX/captcha-solver ucelx-captcha-solver 2>/dev/null || \
            echo "⚠️  UcelX repo unavailable"
    fi
    
    echo "✅ Repositories cloned"
fi

# Install Python dependencies
echo ""
echo "📦 Installing Python dependencies..."
cd "$CAPTCHA_SUITE_DIR/captcha-solvers-toolkit"

pip3 install -r requirements.txt 2>/dev/null || pip3 install quart uvicorn flask requests aiohttp

# Install solver-specific packages
for dir in turnstile-solver capsolver aliyun-slider qoder-refresh; do
    if [ -d "$dir" ] && [ -f "$dir/requirements.txt" ]; then
        echo "Installing $dir dependencies..."
        pip3 install -r "$dir/requirements.txt" 2>/dev/null || echo "⚠️  $dir deps skipped"
    fi
done

# Install Node.js dependencies
echo ""
echo "📦 Installing Node.js dependencies..."
cd "$CAPTCHA_SUITE_DIR"

npm init -y 2>/dev/null || true
if [ -f "package.json" ]; then
    npm install 2>/dev/null || echo "⚠️  npm install failed (check network)"
fi

# Install Playwright
echo ""
echo "🔧 Installing Playwright browser..."
if command -v npx >/dev/null 2>&1; then
    npx playwright install chromium 2>&1 | tail -5 || echo "⚠️  Playwright install may have warnings"
else
    echo "⚠️  npx not available, skipping Playwright"
fi

# Create unified solver API wrapper
echo ""
echo "📝 Creating unified solver client..."
cat > unified_solver.py << 'EOF'
#!/usr/bin/env python3
"""Unified CAPTCHA Solver Client"""
import requests
import base64
import time
from pathlib import Path
from typing import Optional, Dict, Any

class CaptchaSolverClient:
    """Unified client for all solver services"""
    
    def __init__(self, default_provider: str = 'api', api_key: Optional[str] = None):
        self.default_provider = default_provider
        self.api_key = api_key or ''
        
    def solve(
        self,
        url: str,
        sitekey: str,
        captcha_type: str = 'recaptcha_v2',
        proxy: Optional[str] = None,
        timeout: int = 60
    ) -> Dict[str, Any]:
        """Solve any CAPTCHA type via best available provider"""
        
        # Try AI API providers first
        if self.default_provider == 'capsolver':
            return self._solve_capsolver(url, sitekey, captcha_type, proxy, timeout)
        elif self.default_provider == 'nopecha':
            return self._solve_nopecha(url, sitekey, captcha_type, proxy, timeout)
        elif self.default_provider == 'turnstile':
            return self._solve_turnstile_api(url, sitekey, proxy, timeout)
        else:
            raise ValueError(f"Unknown provider: {self.default_provider}")
    
    def _solve_capsolver(self, url: str, sitekey: str, captcha_type: str, proxy: str, timeout: int) -> Dict:
        """Capsolver API client"""
        endpoint = "http://localhost:8000/api/v1/solve"
        
        payload = {
            "main_b64": "",  # Will extract image from page
            "captcha_type": captcha_type.upper(),
            "website_url": url,
            "website_key": sitekey
        }
        
        try:
            response = requests.post(endpoint, json=payload, timeout=timeout)
            result = response.json()
            return {'success': True, 'result': result}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def _solve_turnstile_api(self, url: str, sitekey: str, proxy: str, timeout: int) -> Dict:
        """Turnstile solver API client"""
        endpoint = "http://localhost:5072/turnstile"
        params = {'url': url, 'sitekey': sitekey}
        
        try:
            task_resp = requests.get(endpoint, params=params, timeout=10)
            task_id = task_resp.json().get('taskId')
            
            # Poll for result
            for _ in range(timeout):
                time.sleep(2)
                result_resp = requests.get(f"http://localhost:5072/result?id={task_id}", timeout=5)
                result = result_resp.json()
                
                if result.get('status') == 'ready':
                    return {'success': True, 'token': result['solution']['token']}
                elif result.get('status') == 'fail':
                    return {'success': False, 'error': 'Captcha unsolvable'}
                    
            return {'success': False, 'error': 'Timeout'}
        except Exception as e:
            return {'success': False, 'error': str(e)}


if __name__ == '__main__':
    # Test usage
    solver = CaptchaSolverClient(default_provider='turnstile')
    print("CAPTCHA Solver Suite Unified Client Ready")
    print("Usage:")
    print("  solver = CaptchaSolverClient(default_provider='turnstile')")
    print("  result = solver.solve(url='https://example.com', sitekey='...', captcha_type='turnstile')")
EOF
chmod +x unified_solver.py

echo "✅ Unified solver client created"

# Create quick-start scripts
cat > start-turnstile-server.sh << 'SCRIPT'
#!/bin/bash
cd /root/captcha-suite/captcha-solvers-toolkit/turnstile-solver
python3 api.py --host 127.0.0.1 --port 5072 --browser-type chrome --thread 4
SCRIPT
chmod +x start-turnstile-server.sh

cat > start-capsolver-server.sh << 'SCRIPT'
#!/bin/bash
cd /root/captcha-suite/captcha-solvers-toolkit/capsolver
uvicorn capsolver.main:app --port 8000
SCRIPT
chmod +x start-capsolver-server.sh

echo ""
echo "✅ CAPTCHA Solver Suite setup complete!"
echo ""
echo "Quick start options:"
echo "1. Turnstile API: ./start-turnstile-server.sh"
echo "2. Capsolver API: ./start-capsolver-server.sh"
echo "3. Unified client: python3 unified_solver.py"
echo "4. Browser extension: Install NopeCHA from Chrome Web Store"
echo ""
echo "Full documentation: skills/captcha-solver-suite.md"
