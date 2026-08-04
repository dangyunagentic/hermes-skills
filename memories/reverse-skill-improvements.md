# Skills Improvement Tracker - Dangyan Protocol

## Purpose
Auto-track improvements after every reverse engineer or solve problem task. This ensures continuous skill enhancement and experience reuse.

## Memory Storage Location
`/root/.hermes/profiles/default/memories/reverse-skill-improvements.md`

## Workflow

### After EVERY Task (Reverse Engineer / Security Solve)

1. **Write field journal entry** (if not already done by reverse-skill):
   ```bash
   echo "# <task-name>" >> /root/reverse-skill-clone/skills/field-journal/$(date +'%Y-%m-%d')_<type>.md
   ```

2. **Run improvement tracker**:
   ```bash
   bash ~/.hermes/profiles/default/skills/improvement-tracker.sh <task-type> <outcome> "<improvements>"
   ```

3. **Update this memory file**:
   Add new skills/methods learned to the section below

## Improvement Categories

### 1. Tool Discovery
- New tools discovered during task
- Tool paths added/updated in tool-index.md
- Bootstrap scripts tested

### 2. Methodology Improvements
- Routing decisions that worked well
- Alternative approaches when primary failed
- Evidence chain enhancements

### 3. Knowledge Gaps Found
- Topics requiring research
- References that should be added
- Skills that need expansion

### 4. Automation Opportunities
- Repetitive tasks that could be scripted
- Patterns worth codifying
- MCP services to configure

## Manual Update Template

When you complete a complex task, add this format:

```markdown
## [DATE] - [TASK NAME]

**Skills Used:** [list primary skills]
**Outcome:** [success/failure/partial]
**Improvements:**

1. [Specific learning #1]
2. [Specific learning #2]
3. [Tool discovered: X now available]
4. [Method improved: Y workflow optimized]

**Follow-up Actions:**
- [ ] Research Z topic
- [ ] Write reference document
- [ ] Propose routing update
- [ ] Auto-script repetitive step
```

## Quick Reference Commands

```bash
# Check existing experience before starting
cat /root/reverse-skill-clone/skills/field-journal/_index.md

# Run improvement tracker after task
bash ~/.hermes/profiles/default/skills/improvement-tracker.sh apk-reverse completed "Learned new Frida hook technique for SSL pinning"

# View recent improvements
ls -lt /root/reverse-skill-clone/skills/field-journal/*.md | head -10

# Regenerate tool index if needed
bash /root/reverse-skill-clone/skills/scripts/refresh-tool-index.sh
```

## Integration with Daily Operation

Every time Dangyun completes a security task:
1. Route through reverse-skill methodology ✅
2. Execute PRIMARY skill per MASTER-ROUTING.md ✅
3. Document findings in field-journal ✅
4. Run improvement-tracker.sh ✅
5. Update memory file with key learnings ✅

This creates a self-improving loop where each task makes future tasks faster and more effective.

---

*Last updated: 2026-08-04*
