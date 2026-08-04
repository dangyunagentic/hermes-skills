# CAPTCHA Solver Suite - Skills Improvement Tracker

## Purpose
Auto-track improvements after every CAPTCHA solve, bypass operation, or bot detection research task. This ensures continuous enhancement of solving strategies and provider selection.

## Memory Storage Location
`/root/.hermes/profiles/default/memories/captcha-solver-improvements.md`

## Workflow

### After EVERY CAPTCHA Solve Task

1. **Verify solution applied:**
   - Token extracted successfully?
   - Redirect completed (no further challenges)?
   - Session established if needed?

2. **Write field journal entry** (reverse-skill workflow):
   ```bash
   echo "# captcha-bypass-$(date +'%Y%m%d')_<target>" >> 
     /root/reverse-skill-clone/skills/field-journal/$(date +'%Y-%m-%d')_captcha-<target>.md
   ```

3. **Run improvement tracker**:
   ```bash
   bash ~/.hermes/profiles/default/skills/improvement-tracker.sh \
     captcha-bypass <outcome> "<specific learnings>"
   ```

4. **Update this memory file**:
   Add new techniques/discovered patterns to sections below

## Improvement Categories

### 1. Provider Selection Improvements
- Which AI API works best for each target
- When to use browser mode vs API-only
- Proxy type recommendations per provider
- Fingerprint configuration optimizations

### 2. Solving Strategy Refinements
- New sites solved with specific methods
- Edge cases handled successfully
- Timeout adjustments that reduced failures
- Error recovery patterns that worked

### 3. CAPTCHA Type Discovery
- Novel CAPTCHA variants identified
- Sitekey extraction accuracy improvements
- Challenge detection automation opportunities
- Provider detection heuristics refined

### 4. Proxy & Anti-Detection Learnings
- Residential proxy providers that work best
- Rotation frequency recommendations
- Geo-location optimization tips
- Browser fingerprint configurations

### 5. Integration Patterns
- HAR capture + CAPTCHA bypass workflows
- Playwright/Puppeteer injection methods
- Multi-step flow handling (login → CAPTCHA → redirect)
- Batch solve queue management

### 6. Failure Mode Analysis
- Common error patterns identified
- Recovery procedures developed
- False positive/negative rates tracked
- Provider reliability rankings updated

## Manual Update Template

When completing complex CAPTCHA bypass tasks, add:

```markdown
## [DATE] - [TARGET DOMAIN]

**CAPTCHA Type:** [reCAPTCHA/hCaptcha/Turnstile/etc]
**Solver Used:** [NopeCHA/Capsolver/Browser/API/etc]
**Proxy Type:** [residential/mobile/datacenter]
**Outcome:** [success/partial/failure]
**Key Learnings:**

1. [Capsolver worked better than NopeCHA for Turnstile]
2. [Residential proxy essential for AWS WAF on DC IPs]
3. [Timeout increased to 90s reduced failures by 40%]
4. [Browser mode required for hCaptcha video challenges]

**Solve Metrics:**
- Time taken: X seconds
- Success rate: X/Y attempts
- Cost (API credits): Z
- Proxy cost: $W

**Follow-up Actions:**
- [ ] Test same method on similar targets
- [ ] Share sitekey patterns with team
- [ ] Add to CAPTCHA detection database
- [ ] Propose solver performance update
```

---

## Quick Reference Commands

```bash
# Run automated setup
bash ~/.hermes/profiles/default/skills/captcha-solver-setup.sh

# Start Turnstile API server
./start-turnstile-server.sh

# Unified client test
python3 unified_solver.py

# Check installation status
ls -lh /root/captcha-suite/{turnstile-solver,capsolver,nopecha}

# View recent solves in field journal
ls -lt /root/reverse-skill-clone/skills/field-journal/*captcha*.md | head -10

# Regenerate tool index if new tools added
bash /root/reverse-skill-clone/skills/scripts/refresh-tool-index.sh
```

## Integration Notes

### When He Asks For CAPTCHA Bypass
[D] should:
1. Detect keywords ("captcha", "turnstile", "bypass captchas")
2. Route to `captcha-solver-suite` module
3. Check precedent-auth.md first
4. Query field-journal/_index.md for similar work
5. Identify CAPTCHA type/provider
6. Select best solving method (API/browser/extension)
7. Configure appropriate proxy/residential pool
8. Execute solve, monitor progress
9. Apply token immediately upon success
10. After completion → run improvement-tracker.sh
11. Write summary to memories/ directory

### Auto-Routing Priority
If multiple keywords match:
- captcha-solver overrides basic web automation
- Takes precedence over generic pentest tools
- Combined with HAR capture for full traffic trace

---

## Performance Benchmarks (Continuous Tracking)

Track these metrics after each batch of solves:

### By Provider
| Provider | Avg Time | Success Rate (DC) | Success Rate (Residential) | Credits Used |
|----------|----------|------------------|----------------------------|--------------|
| NopeCHA | TBD | TBD% | TBD% | TBD |
| Capsolver | TBD | TBD% | TBD% | TBD |
| Turnstile-API | TBD | TBD% | TBD% | Free |
| Buster (Audio) | TBD | TBD% | TBD% | N/A |

### By CAPTCHA Type
| Type | Easiest Method | Hardest Case | Fallback Options |
|------|---------------|--------------|------------------|
| reCAPTCHA v2 | Audio (Buster) | Enterprise v3 | AI visual solver |
| hCaptcha slider | Browser drag | Video challenge | Click alternative |
| Cloudflare Turnstile | Stub page browser | IUAM hardened | Extended timeout |
| AWS WAF | AI API | Image complexity | Multiple retries |

### By Proxy Provider
| Provider | Cost/Solve | Success Rate | Best For |
|----------|-----------|--------------|----------|
| Residential-A | $$ | 95% | Cloudflare/AWS |
| Residential-B | $$$ | 97% | DataDome/PerimeterX |
| Mobile-C | $$$$ | 98% | Hardened targets |
| Datacenter | $ | 65% | Low-security sites |

---

## Success Metrics

Track these after each solve:
- ✅ CAPTCHA type correctly identified
- ✅ Appropriate solver/method selected
- ✅ Token extracted successfully
- ✅ Application to target page successful
- ✅ No secondary CAPTCHA encountered
- ✅ Resolve time within expected window
- ✅ Cost efficiency acceptable (credits/proxy)
- ✅ Field journal documentation complete
- ✅ Next-step menu clarity for He

---

## Provider Comparison Matrix

Update this regularly based on real-world testing:

| Provider | Strengths | Weaknesses | Best Use Case | Price Range |
|----------|-----------|------------|---------------|-------------|
| **NopeCHA** | Multimodal AI, extension mode, free tier | Limited provider coverage | General purpose, low-volume | Free-$$/mo |
| **Capsolver** | Broad provider support, API-first | Requires hosting, paid tiers | High-volume automation | $$$/mo |
| **Turnstile-Solver** | Specialized Turnstile/IUAM, self-hosted | Only CF products | Cloudflare-protected sites | Free |
| **Buster** | Audio challenges, open-source | reCAPTCHA only, slower | Accessibility focus | Free |
| **Aliyun-Slider** | Works on DC IPs, 100% accuracy | Aliyun-specific only | Chinese platforms | Free |
| **Custom Scripts** | Target-specific optimizations | Maintenance burden | Production automation | Variable |

---

*Last updated: 2026-08-04*  
*Integration source: merged 6 repos into unified suite*  
*Next review trigger: after next complex CAPTCHA-protected authentication flow*
