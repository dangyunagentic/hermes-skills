# HAR Capture Suite Installation - 2026-08-04

## Summary
Merged two separate HAR capture tools into single integrated skill:
1. **chrome-har-capturer** (cyrus-and) - Library for programmatic HAR generation via CDP
2. **HAR Suite** (waguriagentic) - Full desktop app + Chrome extension with advanced features

Combined capabilities: library mode for scripts + GUI app for manual captures, sticky flow capture, CAPTCHA detection, sensitive-data redaction, SQLite persistence.

---

## Files Created

### Skills Directory
- `har-capture-suite.md` (13.7KB) - Master documentation with API, use cases, integration notes
- `har-capture-setup.sh` (3.5KB) - Automated installation and quick-start script

### Memory Directory (to be created)
- `har-capture-install-2026-08-04.md` - Installation records
- `har-capture-improvements.md` - Continuous improvement tracker template

### Repository Location
- `/root/har-suite/` - Main installation directory
- Contains merged waguria suite + legacy chrome-har-capturer compatibility layer

---

## Key Features Merged

| Feature | Source | Implementation |
|---------|--------|----------------|
| CDP flat sessions | Both | Target.setAutoAttach with flatten:true |
| OOPIF/worker capture | Waguria | Recursive auto-attach to all child targets |
| Sticky flow capture | Waguria | Continues across all tab navigations |
| CAPTCHA detection | Waguria | URL parsing + DOM scan + page-world hooks |
| Library API | Cyrus | run(urls, options) event emitter pattern |
| CLI utility | Cyrus | Single URL/batch parallel capture |
| Desktop GUI | Waguria | Electron + React + virtualized network panel |
| Chrome extension | Waguria | MV3 background service worker bridge |
| Sensitive data redaction | Waguria | Header/body patterns masked at export |
| SQLite persistence | Waguria | WAL-mode session storage |
| HAR/ZIP export | Both | Standard 1.2 format + bundle with metadata |

---

## Installation Status

### Pre-installed ✅
- Node.js v24.19.0
- npm v11.17.0
- npx v11.17.0

### Needs Manual Setup ⚠️
- Chrome/Chromium browser (for remote debugging)
- HAR desktop app build (npm install/build after setup)
- Chrome extension build (extension/dist/)
- WebSocket bridge configuration

### Bootstrap Commands
```bash
# Run automated setup
bash ~/.hermes/profiles/default/skills/har-capture-setup.sh

# Or manual install
mkdir -p /root/har-suite
cd /root/har-suite
git clone https://github.com/waguriagentic/HAR .
npm install
npm run build:extension
npm run dev
```

---

## Integration Points

### With reverse-skill Router
- Trigger keywords detected → auto-route to har-capture-suite module
- Precedents checked in field-journal before each capture
- Tool-index updated after successful installation

### With Dangyun Protocol
- Authorization check via precedent-auth.md
- Scope validation before attaching debugger
- Anonymization of sensitive data in logs
- Evidence→Finding→Path documentation

### Improvement Tracking
After every HAR capture task:
1. Write anonymized log to `field-journal/YYYY-MM-DD_har-capture-<target>.md`
2. Update `_index.md` under "Web/API/Reconnaissance" category
3. Add key learnings to memory file
4. Flag any tools missing from tool-index

---

## Use Cases Covered

### Security Testing
- OAuth token flow analysis
- Authentication cookie extraction
- CSRF token discovery
- Session fixation testing
- JWT token inspection

### Reverse Engineering
- API parameter reconstruction
- Client-side encryption analysis
- Obfuscated JS call chains
- WebSocket protocol tracing
- Payment gateway fingerprinting

### Bot Detection Research
- CAPTCHA provider identification
- Sitekey + challenge extraction
- hCaptcha/reCAPTCHA/human verification flows
- Cloudflare Turnstile detection
- Arkose Labs/FunCaptcha tracking

### Reconnaissance
- API endpoint discovery
- Hidden backend services
- Third-party service calls
- Analytics/tracking infrastructure
- Websocket real-time channels

---

## Performance Notes

- **OOPIF capture:** No request gaps during iframe transitions
- **Flow capture:** Persistent across multi-step signups (e.g., checkout flows)
- **Virtualized UI:** Handles 10k+ requests without lag
- **SQLite WAL mode:** Burst traffic handling (500ms flush interval)
- **WebSocket frames:** Live streaming with per-request bounded limits

---

## Known Limitations

1. **Chrome debugger banner:** Yellow "being debugged" bar always visible
   - Must stay open; closing it detaches debugger
   - Can't hide this requirement (CDP limitation)

2. **Single attachment:** Only one client can attach to a tab at once
   - Must close DevTools Network panel on target tabs
   - Conflicts with manual debugging

3. **Response body limits:** Very large or streamed responses may not have bodies available
   - HAR entry still present, just missing response content

4. **MV3 service worker eviction:** Idle ~30s, wakes via alarms heartbeat
   - Brief "disconnected" status possible during wake cycle
   - Auto-reconnect within 25s intervals

5. **No RAR support:** ZIP only (pure-JS RAR not freely available)
   - Re-archive with WinRAR if specifically needed

---

## Next Steps

1. Run `har-capture-setup.sh` to install dependencies
2. Test with sample URL: `./cli-capture.sh https://httpbin.org/headers`
3. Build desktop app for GUI experience: `npm run build:desktop`
4. Create first real capture session
5. Document results in field-journal
6. Update tool-index.json if new tools discovered

---

*Installation timestamp: 2026-08-04*  
*Source repos: cyrus-and/chrome-har-capturer + waguriagentic/HAR*  
*Merge strategy: Core functionality from both, prefer Waguria for advanced features*
