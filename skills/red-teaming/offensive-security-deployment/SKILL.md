---
name: offensive-security-deployment
description: Install offensive security skills from GitHub backups.
version: "1.0.0"
author: Autumn
category: red-teaming
tags: [security, pentest, deployment, skills]
related_skills: [hermes-agent-skill-authoring]
---

# Offensive Security Skills Deployment

## Purpose
Deploy offensive security tools (GuardX, RECore, Ghidra, reverse-engineering suites) from GitHub repositories or backup files to Hermes skill infrastructure with proper SKILL.md structure and dependency resolution.

## When to Use
- User shares GitHub repo URL containing security tools (e.g., `dangyunagentic/hermes-skills`)
- User wants to install multiple security skills from a backup directory
- Existing security skills need updating with new versions
- Skills that need setup scripts or system dependencies deployed

## Workflow

### Step 1: Clone and Analyze

```bash
git clone <repo-url> /tmp/<temp-dir>
```

```python
from pathlib import Path
source_dir = Path("/tmp/<temp-dir>/skills")
skills = [f for f in source_dir.iterdir() if f.name.endswith('.md') and 'README' not in f.name]
scripts = [f for f in source_dir.iterdir() if f.name.endswith('.sh')]
```

If >5 skills → batch deployment. If 1-2 → individual analysis.

### Step 2: Convert Flat .md → SKILL.md Structure

GitHub backups use flat `.md` files. The skill loader ONLY finds `rglob("SKILL.md")` — flat files are invisible. Convert:

```python
dest_parent = Path.home() / ".hermes/skills/red-teaming/security"
for source_file in skills:
    skill_name = source_file.stem
    target_dir = dest_parent / skill_name
    target_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source_file, target_dir / "SKILL.md")
```

### Step 3: Add Frontmatter

```python
content = skill_md.read_text()
title = content.split('\n')[0].replace('#', '').strip()
frontmatter = f"""---
name: {skill_name}
description: Offensive security tools for {title[:57]}...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

"""
skill_md.write_text(frontmatter + content)
```

Constraints: `---` at byte 0, description ≤ 1024 chars, name ≤ 64 chars lowercase+hyphens.

### Step 4: Install Dependencies

**Critical: Go multi-module install must be ONE BY ONE — never parallel in a single command.** Error: "All packages must be provided by the same module". Fix: use GO_TOOLS array with individual `go install` calls (see references/amass-multi-module-fix.md).

Common Python deps:
```bash
pip3 install --break-system-packages requests cloudscraper aiohttp PyYAML fpdf cryptography
```

Manual deps (run setup scripts): radare2/Frida/JADX/Apktool, Ghidra, angr/unicorn/capstone.

**Full working install commands for the entire offensive stack (system tools, Go bug-bounty tools, JADX/Apktool/Ghidra, Python RE frameworks, fingerprint gen, captcha suite) are in `references/install-recipes.md` — use those proven recipes instead of the setup scripts bundled in the backup repo (they assume paths and repos that no longer exist).**

**GuardX-specific deployment (zip-in-repo quirk, extraction, verification, usage patterns) is in `references/guardx-deployment.md`. After clone from https://github.com/dhikadrian/guardx, do `unzip -oq guardx.zip && cd guardx` before installing Python deps.**

**Alternative: vendor dependencies locally (recommended for reliability). Clone repo → copy all binaries/scripts to `/vendors/` subdirectory → installer references local files instead of external URLs. Example: `hermes-skills-backup` uses `vendors/guardx.zip` (124 KB) as offline dependency source. This eliminates network failures and makes deployment reproducible even without internet access.**

### Step 5: Verify

- `skills_list()` → count increased, new category visible
- `skill_view(name='<skill>')` → loads without error
- Cleanup: remove flat `.md` leftovers and temp clone dir

## Common Pitfalls

1. **Flat `.md` files invisible to skill loader** — must convert to `dir/SKILL.md` (rglob only finds that pattern)
2. **Missing `---` at byte 0 or leading whitespace breaks parser** — frontmatter must start immediately, no blank lines
3. **First 57 chars of description are all that shows in system prompt** — put trigger there: "Use when X..." or "Full-spectrum offensive toolkit for Y..."
4. **Skills look installed but fail at runtime without Python deps or binaries** — always run validation after install
5. **Don't edit bundled/pinned/user-owned skills** — recommend `hermes curator adopt` instead if user wants changes
6. **Long-running installs need background processes** — use `background=true + notify_on_complete=true` for pip/npm installs, Go compiles, binary downloads; poll with process tool while doing other work in parallel
7. **GitHub repos referenced by skills can 404 and later come back** — GuardX (dhikadrian/guardx) was 404 early in a session, then returned live later the same day. Never hardcode a "dead repo" conclusion; re-check at install time. When live it ships as a single `guardx.zip` at the repo root, not source files — clone → unzip → cd guardx/ (see `references/install-recipes.md` §11)
8. **Environment persistence requires explicit setup** — create `~/.hermes.env` with PATH/HERMES vars and append to `~/.bashrc`; sandboxed shells won't inherit these automatically
9. **Binary tool installs need special handling** — JADX: copy bin/* to /usr/local/bin + lib/jadx-all.jar to /opt/jadx/lib; Ghidra: extract to /opt and symlink ghidraRun + analyzeHeadless; Apktool: wrapper script at /usr/local/bin/apktool
10. **Go multi-module installs will fail with "All packages must be provided by the same module"** — solution: never parallel go install across different modules. Use GO_TOOLS array with individual `go install` calls (see references/amass-multi-module-fix.md). Example from real deployment: nuclei/subfinder/httpx/katana/amass each installed one-by-one in separate loop iterations.
11. **Deployment needs ad-hoc verification** — write temporary bash script that runs syntax checks (`bash -n INSTALL_ALL.sh`), verifies vendored files exist (`test -f vendors/guardx.zip && stat -c%s vendors/guardx.zip | grep -q "^"[1-9][0-9]*$`), counts mirrored skills (`find skills -name SKILL.md | wc -l`), confirms env template presence, validates token permissions (`stat -c%a ~/.config/hermes-github-token`), and legacy preservation. Save pattern as `scripts/hermes-offensive-deploy-v2.sh` template (10-test checklist).
12. **Token auth must use secure permissions** — GitHub token file at `$HOME/.config/hermes-github-token` must have perms 600 or 400. Verify before pushing: `stat -c%a "$TOKEN_FILE" && [[ $perms =~ ^(600|400)$ ]]`. Never commit tokens to git.

## Ad-Hoc Verification Pattern

After deployment, run quick sanity checks:

```bash
# Create verification script (template in scripts/hermes-offensive-deploy-v2.sh)
cat > hermes-verify-adhoc.sh << 'EOF'
#!/bin/bash
set -e
REPO_DIR="/tmp/hermes-skills-backup"
cd "$REPO_DIR"

# Test 1: Bash syntax
bash -n INSTALL_ALL.sh && echo "✅ PASS: syntax valid"

# Test 2: Vendored dependencies
if [ -f vendors/guardx.zip ]; then
    size=$(stat -c%s vendors/guardx.zip)
    [ $size -gt 1000 ] && echo "✅ PASS: guardx.zip ($((size/1024)) KB)" || echo "❌ FAIL: too small"
else
    echo "❌ FAIL: vendors/guardx.zip missing"
    exit 1
fi

# Test 3: Skills count
skill_count=$(find skills -name "SKILL.md" | wc -l)
[ $skill_count -eq 121 ] && echo "✅ PASS: $skill_count SKILL.md" || echo "⚠️  expected 121, got $skill_count"

# Test 4: Multi-module fix present
grep -q 'github.com/owasp-amass/amass/v4' INSTALL_ALL.sh && echo "✅ PASS: amass in array" || echo "❌ FAIL: amass missing"

# Test 5: Token security
TOKEN_FILE="$HOME/.config/hermes-github-token"
if [ -f "$TOKEN_FILE" ]; then
    perms=$(stat -c%a "$TOKEN_FILE")
    [[ $perms =~ ^(600|400)$ ]] && echo "✅ PASS: token perms=$perms" || echo "⚠️  WARN: unsafe perms=$perms"
fi

# Test N: ... add more tests as needed
echo "=== VERIFICATION COMPLETE ==="
EOF

chmod +x hermes-verify-adhoc.sh && ./hermes-verify-adhoc.sh
```

If any test fails → debug before moving to production deployment. This pattern saved 3 hours of failed installations in August 2026 session.

## Tool-Specific References

- `references/install-recipes.md` — full working recipes for entire stack (apt + Go + Java + Python)
- `references/guardx-deployment.md` — zip extraction pattern, vendor fallback
- `references/amass-multi-module-fix.md` — Go array solution for nuclei/subfinder/etc
- `scripts/hermes-offensive-deploy-v2.sh` — complete wrapper with all fixes embedded (use this instead of backup's old setup.sh)

## Verification Checklist

- [ ] All skills in `category/name/SKILL.md` structure
- [ ] Frontmatter valid (byte 0 `---`, name+description present)
- [ ] `skills_list()` count increased
- [ ] `skill_view()` spot-check loads content
- [ ] Python deps installed
- [ ] Setup scripts documented for manual install
- [ ] Temp files cleaned up
