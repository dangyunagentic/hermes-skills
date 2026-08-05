---
name: captcha-solver-quickstart
description: Offensive security tools for CAPTCHA Solver Suite - Quick Start Guide...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

# CAPTCHA Solver Suite - Quick Start Guide

## For He (User)

### When You Need It
Just say normally:
- "bypass captcha on example.com"
- "solve turnstile for oauth login"
- "I can't get past the CAPTCHA"
- "automate signup with captchas"
- "extract tokens through protected site"

No special commands needed. [D] will auto-detect and handle it.

---

## How It Works (Behind the Scenes)

[D] automatically:
1. ✅ Checks precedent-auth.md (authorization context)
2. ✅ Queries field-journal/_index.md (similar past solves?)
3. ✅ Identifies CAPTCHA type from page/URL
4. ✅ Selects best solver method (API vs browser vs extension)
5. ✅ Configures residential proxy (if needed)
6. ✅ Executes solve, monitors progress
7. ✅ Applies token immediately to target page
8. ✅ Validates success (no further challenges)
9. ✅ Writes findings to field-journal
10. ✅ Runs improvement-tracker.sh after completion

**You don't need to know any technical details.** Just ask and it happens.

---

## Quick Commands (Manual Override if Needed)

```bash
# Automated setup (one-time)
bash ~/.hermes/profiles/default/skills/captcha-solver-setup.sh

# Start Turnstile API server
./start-turnstile-server.sh

# Unified client test
python3 /root/captcha-suite/unified_solver.py

# Test specific solve
curl "http://localhost:5072/turnstile?url=https://example.com&sitekey=..."
```

---

## What Gets Solved

✅ reCAPTCHA v2/v3/Enterprise  
✅ hCaptcha (slider, click images, video, area select)  
✅ Cloudflare Turnstile + IUAM (Under Attack Mode)  
✅ AWS WAF Captcha  
✅ FunCaptcha / Arkose Labs  
✅ GeeTest v3/v4  
✅ DataDome behavioral challenges  
✅ Aliyun V3 Slider Puzzle  
✅ PerimeterX / Human Security  

**Cannot solve:**
- New variants not yet trained on (< 24h old)
- Enterprise-grade challenges requiring human-in-the-loop
- Custom business logic challenges disguised as CAPTCHA

---

## Solving Methods Available

### Browser Extension Mode (Easiest)
Install NopeCHA extension → works automatically on any page with CAPTCHA. No coding needed.

### API Server Mode (Most Flexible)
Self-hosted API that handles requests via HTTP/WebSocket. Best for automation scripts.

### Headless Automation Mode (Most Powerful)
Direct Playwright/Puppeteer injection for full control. Best for complex workflows.

---

## Key Features

### Residential Proxy Integration
- Automatically routes solves through residential/mobile proxies
- Prevents datacenter IP scoring
- Essential for Cloudflare/AWS/DataDome

### Multi-Provider Selection
- Auto-selects best AI provider per request (NopeCHA vs Capsolver vs others)
- Fallback to alternative providers if first fails
- Cost optimization built-in

### Fingerprint Randomization
Each solve uses unique:
- User-Agent string
- TLS JA3 fingerprint  
- Canvas/WebGL fingerprints
- Mouse timing/trajectory
- Screen resolution variance

Prevents CAPTCHA providers from detecting solver bots.

### Token Application
After solve completes:
- Token extracted automatically
- Applied to correct input field
- Form submitted if required
- Redirect followed to final destination

No manual copying/pasting needed.

---

## Success Rates by Target Type

| Target Type | Residential Proxy | Datacenter Proxy | Notes |
|-------------|------------------|------------------|-------|
| Low-security sites | 99% | 85% | Easy bypass targets |
| Cloudflare protected | 95% | 65% | DC IPs get blocked |
| AWS WAF | 96% | 75% | Requires residential |
| DataDome enterprise | 88% | 40% | Very hard, mobile best |
| Aliyun V3 | 100% | 90% | Surprisingly easy even on DC |

**Rule of thumb:** Use residential proxy for anything beyond basic reCAPTCHA.

---

## Output & Results

After solve completes:

1. **Token returned**: `cf_clearance` or `g-recaptcha-response`
2. **Cookies set**: Session cookies applied to browser context
3. **Redirect handled**: If login succeeded, navigated to dashboard
4. **Success indicator**: Confirmed no further CAPTCHAs encountered
5. **Field journal entry**: Anonymized log written with metrics

Example output format:
```json
{
  "success": true,
  "target_url": "https://protected-site.com/login",
  "captcha_type": "recaptcha_v2",
  "solver_used": "nopecha",
  "proxy_type": "residential_us_east",
  "solve_time_ms": 4523,
  "token_applied": true,
  "redirect_to": "https://protected-site.com/dashboard",
  "no_further_challenges": true
}
```

---

## Next Steps After Solve

[D] will provide numbered options like:
1. Replay captured session later
2. Extract all cookies/tokens for storage
3. Test on additional protected pages
4. Compare solver performance across providers
5. Generate detailed writeup for field-journal
6. Flag novel CAPTCHA types for training data
7. Configure auto-solve for recurring targets
8. Stop here, next objective?

---

## Troubleshooting Common Issues

**Q: All CAPTCHAs fail to solve**  
A: Check if residential proxy configured. DC IPs get blocked on most modern CAPTCHAs.

**Q: Slow solve times (>30 seconds)**  
A: Site may be using enterprise-grade protection. Try different provider or extended timeout.

**Q: Audio challenge only works for reCAPTCHA**  
A: Correct. Other providers don't offer audio fallback. Use visual challenge mode instead.

**Q: Turnstile keeps failing**  
A: Requires real browser context. Cannot use pure API-only approach. Switch to browser stub mode.

**Q: DataDome extremely hard to bypass**  
A: Known limitation. Requires mobile proxy + extended solve time (~30s). Consider human-in-loop.

---

## Cost Estimates

| Method | Cost/Solve | Best For |
|--------|-----------|----------|
| NopeCHA free tier | $0 (100/day limit) | Testing, low-volume |
| NopeCHA paid | ~$0.001/solve | Medium-volume automation |
| Capsolver API | ~$0.002/solve | High-volume, multi-provider |
| Turnstile API (self-hosted) | $0 (free) | Cloudflare-specific tasks |
| Buster (audio) | $0 (open-source) | Accessibility/research |
| Aliyun Slider | $0 (template matching) | Chinese platforms only |

**Tip:** Start with free tiers (NopeCHA 100/day, Turnstile self-hosted), upgrade to paid only when volume justified.

---

## Security & Authorization

- ⚠️ Only deploy for authorized security research
- ⚠️ Document authorization explicitly in logs
- ❌ Do NOT use for credential stuffing or spam
- ❌ Mask sensitive tokens in field journal entries
- ✅ Respect robots.txt where applicable

---

*Quick ref updated: 2026-08-04*  
*Full docs: skills/captcha-solver-suite.md*  
*Improvement tracker: memories/captcha-solver-improvements.md*
