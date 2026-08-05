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

Common Python deps:
```bash
pip3 install --break-system-packages requests cloudscraper aiohttp PyYAML fpdf cryptography
```

Manual deps (run setup scripts): radare2/Frida/JADX/Apktool, Ghidra, angr/unicorn/capstone.

**Full working install commands for the entire offensive stack (system tools, Go bug-bounty tools, JADX/Apktool/Ghidra, Python RE frameworks, fingerprint gen, captcha suite) are in `references/install-recipes.md` — use those proven recipes instead of the setup scripts bundled in the backup repo (they assume paths and repos that no longer exist).**

**GuardX-specific deployment (zip-in-repo quirk, extraction, verification, usage patterns) is in `references/guardx-deployment.md`. After clone from https://github.com/dhikadrian/guardx, do `unzip -oq guardx.zip && cd guardx` before installing Python deps.**

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

## Verification Checklist

- [ ] All skills in `category/name/SKILL.md` structure
- [ ] Frontmatter valid (byte 0 `---`, name+description present)
- [ ] `skills_list()` count increased
- [ ] `skill_view()` spot-check loads content
- [ ] Python deps installed
- [ ] Setup scripts documented for manual install
- [ ] Temp files cleaned up
