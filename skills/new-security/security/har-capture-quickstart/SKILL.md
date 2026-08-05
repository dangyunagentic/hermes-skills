---
name: har-capture-quickstart
description: Offensive security tools for HAR Capture Suite - Quick Start...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

# HAR Capture Suite - Quick Start

## For He (User)

### When You Need It
Just say normally:
- "capture traffic to example.com"
- "trace the oauth login flow"
- "show all requests during checkout"
- "I need to see what captcha is sent"
- "extract tokens from this API call"

No special commands needed. [D] auto-routes and handles setup.

---

## Quick Commands (Manual Override)

```bash
# Automated setup (one-time)
bash ~/.hermes/profiles/default/skills/har-capture-setup.sh

# CLI capture test
cd /root/har-suite && node cli.mjs https://httpbin.org/headers --output test.har

# Full stack (Chrome + Desktop)
./start-capture.sh

# Desktop GUI only
cd /root/har-suite && npm run dev

# Extension build
npm run build:extension
# Then load in Chrome: chrome://extensions → Load unpacked → extension/dist/
```

---

## How It Works (Behind the Scenes)

[D] will:
1. ✅ Check precedent-auth.md (authorization context)
2. ✅ Query field-journal/_index.md (similar past work?)
3. ✅ Verify Chrome debug port 9222 running
4. ✅ Start appropriate capture method (CLI or GUI)
5. ✅ Configure allowlist based on your target
6. ✅ Monitor progress, detect CAPTCHAs automatically
7. ✅ Export HAR with redaction applied
8. ✅ Write findings to field-journal
9. ✅ Run improvement-tracker.sh after completion

**You don't need to know any of that.** Just ask and it happens.

---

## What Gets Captured

✅ XHR/Fetch/WebSocket requests  
✅ Form POST navigations (including hidden CSRF tokens)  
✅ Cross-origin iframes (OOPIFs) - payments, captchas, embedded widgets  
✅ Service workers & shared workers  
✅ Request/response bodies (if not too large)  
✅ Cookie/auth header propagation across redirects  
✅ CAPTCHA triggers + sitekey extraction  
✅ All timing data for waterfall analysis  

**Cannot capture:**
- Static assets unless "Everything" scope selected
- Response bodies >~50MB (stream timeout)
- Traffic from already-open DevTools Network panel (conflict)

---

## Key Features

### Sticky Flow Capture
Once started, continues across ALL tab navigations:
```
chatgpt.com → stripe.com → dashboard.example.com
(all captured in single session, no gaps)
```

### CAPTCHA Detection
Automatically detects and extracts:
- reCAPTCHA v2/v3/Enterprise → sitekey extracted
- hCaptcha → provider + sitekey
- Cloudflare Turnstile → sitekey + challenge data
- Arkose Labs, GeeTest, DataDome supported

### Sensitive Data Redaction
Headers masked at export:
- `Authorization`
- `Cookie`, `Set-Cookie`
- `X-API-Key`, `X-Auth-Token`

Body JSON keys masked:
- `password`, `secret`
- `access_token`, `refresh_token`, `id_token`

Result: `<redacted>` in exported files. Original preserved in memory.

---

## Output Formats

### HAR 1.2 (standard)
Open in Chrome DevTools or any viewer. Shows complete request timeline.

### ZIP Bundle
Includes:
- `capture.har` - full HAR
- `summary.json` - flat request list
- `metadata.json` - timestamp, version, redaction flag
- `requests/` - individual JSON files per request

---

## Next Steps After Capture

[D] will provide numbered options like:
1. Analyze HAR timing chart
2. Replay specific requests as cURL
3. Extract all cookies/tokens
4. Generate API docs from pairs
5. Search for patterns in bodies
6. Export WebSocket frames only
7. Compare with previous session
8. Write detailed writeup
9. Stop here, next objective?

---

## Troubleshooting

**Q: Chrome won't connect to debug port**
A: Make sure Chrome launched with `--remote-debugging-port=9222`

**Q: Yellow "being debugged" bar disappears**
A: Closing the debugger banner detaches extension. Keep it open!

**Q: Some requests missing from capture**
A: Check if DevTools Network panel was already open on that tab (can't attach twice). Close DevTools first.

**Q: CAPTCHA not detected**
A: May need DOM scan timeout longer, or hook timing adjustment. Tell [D] specifically which captcha type.

**Q: Large response body empty**
A: Browser CDP limits streamed/large responses. Smaller payloads (<50MB) always have bodies.

---

*Quick ref updated: 2026-08-04*  
*Full docs: skills/har-capture-suite.md*  
*Improvement tracker: memories/har-capture-improvements.md*
