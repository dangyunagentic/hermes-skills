---
name: har-capture-suite
description: Offensive security tools for ---...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

---
name: har-capture-suite
description: Full-spectrum Chrome network traffic capture suite - captures XHR/Fetch/WebSocket/Document requests via CDP, includes OOPIF/worker support, sticky flow capture, CAPTCHA detection, sensitive-data redaction, SQLite session persistence, and HAR/ZIP export. Integrated with both chrome-har-capturer library and waguria desktop-app for automated recon during pentest/security operations.
version: "1.0.0"
author: merged from cyrus-and/chrome-har-capturer + waguriagentic/HAR
source: 
  - https://github.com/cyrus-and/chrome-har-capturer
  - https://github.com/waguriagentic/HAR
---

# HAR Capture Suite Skill

## Purpose
Capture complete network traffic from Chrome browser including requests that standard DevTools Network view misses: cross-origin iframes (OOPIFs), service workers, WebSocket connections, and form-POST navigations. Used for security research, penetration testing, API reconnaissance, authentication flow analysis, and reverse engineering client-side encryption.

**Key advantage over standard DevTools:** Captures everything via `chrome.debugger` flat CDP sessions with `Target.setAutoAttach`, so traffic from embedded captchas, payment iframes (Stripe 3DS), and multi-step signups is recorded completely.

---

## Trigger Keywords
- "har", "har capture", "network capture", "web traffic", "fetch logs"
- "chrome debug", "cdp", "browser automation", "request replay"
- "captcha detection", "oauth flow", "authentication trace"
- "export har", "harp", "websockets", "websocket frames"
- "redact sensitive data", "mask auth headers", "capture oauth tokens"

---

## Installation Setup

### Prerequisites
```bash
# Node.js 20+ LTS
nvm install 20
nvm use 20

# Git clone merged suite
mkdir -p /root/har-suite
cd /root/har-suite

# Clone both repos and merge
git clone https://github.com/cyrus-and/chrome-har-capturer /tmp/chrome-har-capturer
git clone https://github.com/waguriagentic/HAR /tmp/har-waguria

# Create merged structure
cp -r /tmp/har-waguria/* .
mkdir -p lib/legacy
cp -r /tmp/chrome-har-capturer/lib/* lib/legacy/ 2>/dev/null || true

# Install dependencies
npm install
```

### Chrome Setup for Debugging
```bash
# Start Chrome with remote debugging port
google-chrome --remote-debugging-port=9222 --headless \
  --disable-gpu --no-sandbox --user-data-dir=/tmp/chrome-debug

# OR for GUI (recommended for manual capture)
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

### Build Extension
```bash
npm run build:extension
# Output: extension/dist/
# Load in Chrome: chrome://extensions → Enable Developer mode → Load unpacked → Select extension/dist/
```

### Run Desktop App
```bash
# Development mode with HMR
npm run dev

# Production build
npm run build:desktop
npm start

# Or run CLI directly
node cli.mjs <urls...> --output capture.har
```

---

## Core Capabilities

### 1. **Auto-Capture Across Frames & Workers**
Via `chrome.debugger` CDP flat sessions (`Target.setAutoAttach`):
- Root tab + all child targets (OOPIFs, workers, shared_workers)
- Recursive auto-attach for nested iframes-in-iframe
- Captcha endpoints and same-tab third-party flows visible
- No gaps in request timeline

### 2. **Configurable Capture Scope**
- **Data + navigations (default):** XHR, Fetch, WebSocket, Document loads, Ping/beacon, EventSource
- **Everything:** Includes images, CSS, fonts, scripts
- Toggle in desktop toolbar or extension popup

### 3. **Sticky Tab Flow Capture**
Once a tab starts capturing (allowlist match OR popup button):
- Keeps capturing across **every navigation in that tab**
- Even to non-allowlisted domains
- Example: `chatgpt.com → stripe.com` during checkout captured automatically
- Stops when tab closes, capture off, or explicit stop clicked

### 4. **CAPTCHA Detection & Extraction**
Three parallel detection paths:
```javascript
// Network URL parsing
- reCAPTCHA v2/v3/Enterprise: google.com/recaptcha/api2/* (sitekey=k=...)
- hCaptcha: *.hcaptcha.com/getcaptcha/<sitekey>
- Cloudflare Turnstile: challenges.cloudflare.com/?sitekey=...
- Arkose Labs/FunCaptcha: *.arkoselabs.com/v2/<PUBLIC_KEY>/...
- GeeTest v3/v4: gt=...&challenge=... OR captcha_id=...
- DataDome, AWS WAF Captcha detected

// DOM scan (content script)
- [data-sitekey], .g-recaptcha[data-sitekey], .h-captcha[data-sitekey]
- .cf-turnstile[data-sitekey], arkose script tags
- Re-scans on DOM mutations

// Page-world hook
- Wraps grecaptcha.execute/render
- Wraps hcaptcha.execute/render
- Wraps turnstile.render/execute
- Captures sitekey + action (v3) at call time
```

Output: Provider name + sitekey copied to clipboard with one click.

### 5. **Sensitive-Data Redaction at Export**
Mask before writing files (original data preserved in memory):
```json
{
  "header_patterns": ["authorization", "cookie", "set-cookie", "x-api-key", "proxy-authorization"],
  "body_json_keys": ["password", "secret", "access_token", "refresh_token", "id_token"]
}
```

Result in exported HAR/ZIP: `<redacted>` instead of actual values.

### 6. **SQLite Session Persistence**
- Each desktop-app launch creates new session
- Sessions persisted to WAL-mode SQLite (better-sqlite3)
- Location: `<userData>/har-suite/capture.db`
- Sidebar lists all past sessions
- Double-click to rename inline, right-click to delete
- New session button opens dialog without losing previous captures

### 7. **Virtualized Network Panel**
- Handles 10k+ requests smoothly (`@tanstack/react-virtual`)
- Inline waterfall per row (offset/duration relative to session start)
- Full-text search (URL/method/status, optional body search)
- Request detail pane: headers, payload, JSON pretty-print, WebSocket frames

### 8. **Export Formats**
#### HAR 1.2 Export
```bash
# Desktop app: Export HAR button
# CLI: node cli.mjs --output capture.har
```
Standard format openable in Chrome DevTools or any HAR viewer.

#### ZIP Bundle Export
```
capture.zip
├── capture.har          # full HAR
├── summary.json         # flat list {url, method, status, durationMs}
├── metadata.json        # timestamp, version, redaction flag
└── requests/            # one JSON file per request
    ├── req_0001.json
    └── ...
```

Each request JSON includes raw captured data + WebSocket frames.

### 9. **Copy-as-Helpers**
Right-click any row in UI:
- Copy URL
- Copy as cURL (with redaction applied)
- Copy as fetch() code
- Export this only

### 10. **Token-Authenticated Bridge**
Desktop app runs WebSocket server on `127.0.0.1:9876`:
- Token handshake required before accepting stream
- Only paired extensions can connect
- Prevents unauthorized capture injection

---

## Integration with Dangyun Protocol

### When He Needs HAR Capture
Just say normally:
- "capture traffic to this website"
- "trace the oauth login flow"
- "show me all requests to api endpoint"
- "I need to see what captcha is being sent"

[D] will:
1. Check precedents in field-journal for similar captures
2. Verify Chrome is running with debug port
3. Start desktop app or CLI capture
4. Configure allowlist based on target
5. Wait for traffic, monitor progress
6. Export HAR with redaction applied
7. Write findings to field-journal

### Pentest Use Cases

#### Authentication Flow Analysis
```javascript
// Target: OAuth 2.0 login with redirect chain
const TARGETS = [
  "https://auth.example.com/login",
  "https://accounts.google.com/o/oauth2",
  "https://api.example.com/callback"
];

// Capture setup
await capture.run(TARGETS, {
  host: 'localhost',
  port: 9222,
  content: true,      // include POST bodies
  cache: false,       // no caching for fresh tokens
  graceful: 2000      // wait after load
});
```
Result: Complete token exchange chain + refresh token acquisition.

#### Multi-Step Signup Flow
```javascript
// Form POST with hidden fields + AJAX callbacks
await capture.attach(tabId);
// Navigate through steps → all POST data captured automatically
// Including hidden CSRF tokens, session IDs, fingerprinting data
```

#### Payment Gateway Testing
```javascript
// Stripe 3DS flow across iframe boundaries
await capture.attach(tabId);
// Extension auto-attaches into payment iframe
// Captures POST body with card fingerprint, tokenization endpoint
// Detects CAPTCHA challenge during 3DS verification
```

#### Bot Detection Research
```javascript
// Track fingerprinting scripts execution
// Detect reCAPTCHA/hCaptcha/Cloudflare Turnstile triggers
// Extract all sitekeys + providers used
// Analyze challenge payloads and responses
```

---

## API Usage (Library Mode)

### Basic CLI
```bash
# Single URL
node cli.mjs https://example.com --output example.har

# Multiple URLs in parallel
node cli.mjs https://a.com https://b.com https://c.com \
  --parallel 3 --timeout 30000 --output batch.har

# With advanced options
node cli.mjs https://target.com \
  --host localhost --port 9222 \
  --content --cache --grace 2000 \
  --block "*.css" "*.png" "*.jpg" \
  --header "X-Auth: token" \
  --retry 3 --retry-delay 1000 \
  --output full-trace.har
```

### Programmatic Usage (Node.js ESM)
```javascript
import { run } from 'chrome-har-capturer';

const har = await run(
  ['https://example.com/page'],
  {
    host: 'localhost',
    port: 9222,
    content: true,
    cache: false,
    timeout: 30000,
    retry: 2,
    preHook: async ({ url, client }) => {
      // Custom setup before each page load
      await client.Page.enable();
      await client.Network.enable();
    },
    postHook: async ({ url, client, index }) => {
      // Custom extraction after load
      const cookies = await client.Network.getCookies();
      return { cookies };  // included in HAR as ._user.cookies
    }
  }
);

console.log(JSON.stringify(har, null, 2));
```

### Desktop App + Extension Workflow
```bash
# 1. Start desktop app (starts WebSocket server)
npm run dev

# 2. Load extension in Chrome
# chrome://extensions → Load unpacked → extension/dist/

# 3. Pair extension with desktop app
# Click pairing token in desktop app → copy → paste in extension popup → Pair

# 4. Add allowlist domains
# Extension popup → Allowlist → add "example.com"

# 5. Visit target in Chrome
# Extension auto-attaches debugger (yellow bar appears)
# Desktop app fills with live requests

# 6. Monitor, filter, search in real-time
# Right-click for actions: copy cURL, copy fetch, export only this

# 7. Export when done
# Desktop app: Export HAR / Export ZIP / Save session
```

---

## Tools Status

| Tool | Available | Path | Notes |
|------|-----------|------|-------|
| node | yes | `/root/.nvm/versions/node/v24.19.0/bin/node` | v24.19.0 |
| npm | yes | `/root/.nvm/versions/node/v24.19.0/bin/npm` | v11.17.0 |
| npx | yes | `/root/.nvm/versions/node/v24.19.0/bin/npx` | v11.17.0 |
| google-chrome | check | `which google-chrome` | needs path |
| HAR desktop app | no | — | build required |
| HAR extension | no | — | build required |
| chrome-har-capturer lib | no | — | library mode available |

Bootstrap missing tools:
```bash
bash /root/reverse-skill-clone/skills/scripts/bootstrap-reverse.sh node --start-services
```

---

## Operations Checklist

### Before Capture
- [ ] Chrome running with `--remote-debugging-port=9222`?
- [ ] Desktop app started + token shown?
- [ ] Extension loaded + paired successfully?
- [ ] Allowlist configured for target domain?
- [ ] CAPTCHA redaction settings defined (if needed)?
- [ ] Field journal precedent checked for similar work?

### During Capture
- [ ] Yellow debugger bar visible in Chrome? (don't close it)
- [ ] Desktop app receiving live requests?
- [ ] CAPTCHAs detected and extracted if present?
- [ ] Any failed requests logged for review?
- [ ] Progress reported to He periodically?

### After Capture
- [ ] HAR exported to file?
- [ ] ZIP bundle created with metadata?
- [ ] Sensitive data redaction applied?
- [ ] Summary written to field-journal?
- [ ] Key requests identified for further analysis?
- [ ] Next-step menu provided to He?

---

## Completion Menu (Provide to He)

After capture completes, offer these options:

1. Analyze HAR in desktop browser (open HAR file + show timing chart)
2. Replay specific requests as cURL commands
3. Extract all cookies/tokens from captured data
4. Generate API documentation from request/response pairs
5. Search for specific patterns in request bodies
6. Export only WebSocket frame sequences
7. Compare with previous capture session
8. Write detailed writeup to field-journal
9. Stop here and confirm next objective

---

## Security Considerations

### Authorization Boundary
- All captures within user's authorized scope ONLY
- Confirm target ownership or authorization before attaching debugger
- Never expand attack surface beyond specified domains
- Mask PII in exports unless explicitly requested

### Data Handling
- Do NOT retain un-anonymized sensitive info longer than needed
- Delete temporary Chrome profiles after session
- Securely wipe SQLite database when task complete
- Never log actual tokens/passwords in field journal

### Compliance
- Respect robots.txt and terms of service
- Don't capture data from protected systems without explicit permission
- Document all captures in field-journal with authorization reference

---

## References

- HAR 1.2 Spec: http://www.softwareishard.com/blog/har-12-spec/
- Chrome DevTools Protocol: https://chromedevtools.github.io/devtools-protocol/
- Original chrome-har-capturer: https://github.com/cyrus-and/chrome-har-capturer
- Waguria HAR Suite: https://github.com/waguriagentic/HAR
- Field Journal Precedents: `/root/reverse-skill-clone/skills/field-journal/_index.md`

---

*Integrated into Dangyun protocol: always active for HAR/network capture tasks.*
*Next improvement cycle: triggered after each capture completion.*
