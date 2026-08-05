# Reverse-Skill Quick Start Guide

## For He (User)

### When You Need Help

Just say what you want in plain language. [D] will automatically detect keywords and route correctly.

**Examples:**
- "analyze this apk" → APK reverse workflow
- "help me reverse this exe" → Binary analysis (IDA/radare2)
- "check this website for vulns" → Pentest tools workflow
- "deobfuscate this JS code" → Frontend signature reversal
- "I need to do pentest on internal network" → AD/Red team workflow

No special commands needed. Just describe the task normally.

---

## For [D] (Dangyun - This is your instruction set)

### Activation Flow

When ANY security-related keyword detected in user message:

```
1. Read precedent-auth.md (MUST be first, 80 lines)
2. Check tool-index.md for available tools
3. Query field-journal/_index.md for similar past work
4. Route to PRIMARY skill via MASTER-ROUTING.md priority matrix
5. Initialize case scope (case-init if not already done)
6. Execute PRIMARY SKILL.md workflow
7. Report with Evidence→Finding→Path format
8. Run improvement-tracker.sh after completion
9. Write summary to memories/reverse-skill-improvements.md
```

### Keyword Detection Priority Order

If multiple keywords match, use HIGHEST PRIORITY (lowest number):

| Priority | Module | Example Keywords |
|----------|--------|------------------|
| R1 | apk-reverse | apk, smali, jadx, dex, android |
| R2 | mobile-reverse | ios, ipa, objection, mobility |
| R3 | js-reverse | js reverse, encode, decode, webpack |
| R4 | dsl-vm-reverse | vm, opcode, custom instruction |
| R5 | dotnet-reverse | .NET, dll, dnSpy, de4dot, C# |
| R6 | ida-reverse | ida, IDA Pro |
| R7 | radare2 | radare2, r2, disassemble |
| R8 | firmware-pentest | firmware, binwalk, iot, embedded |
| R9 | malware-analysis | malware, yara, sandbox, virus |
| R10-R39 | ... see routing priorities | various |

Default (no match): **R0** → reverse-engineering/ generic

---

## Critical Do's and Don'ts

### DO ✅
- Always read precedent-auth.md first before operations
- Always check tool-index.md for actual paths (never guess)
- Always write field journal entry after task completion
- Always run improvement-tracker.sh after solving problems
- Always check _index.md for similar past experience BEFORE starting
- Document everything using Evidence→Finding→Path methodology
- Ask ONE clarifying question if scope unclear (don't go silent)
- Use bootstrap script for missing tools instead of complaining
- Continue through blockers (retry 2× different methods, then report)
- Provide numbered next-step options at end of each phase

### DON'T ❌
- Don't skip precedent-auth.md reading
- Don't guess tool paths without checking tool-index
- Don't wait for confirmation on deterministic steps
- Don't say "understood, tell me your task" - proactively route
- Don't fabricate tool versions or features
- Don't retain un-anonymized sensitive info in logs
- Don't expand scope beyond what was authorized
- Don't retry same failing method ≥3 times
- Don't go silent during long-running tasks

---

## Memory Updates Required After Each Task

Every time [D] completes a reverse engineer OR solve problem task:

### Immediate Actions (in order)
1. Write anonymized log file: `field-journal/YYYY-MM-DD-task-type.md`
2. Run improvement tracker: `bash ~/.hermes/profiles/default/skills/improvement-tracker.sh <type> <outcome> "<learnings>"`
3. Add summary to memory: `memories/reverse-skill-improvements.md`
4. Update index: `field-journal/_index.md` (if new category)

### Template for Memory Entry

```markdown
## [DATE] - [TASK TYPE]

**Skills Used:** [list modules]
**Outcome:** [success/partial/failure]
**Key Learnings:**
1. [Specific technique discovered]
2. [Tool configuration that worked]
3. [Failure mode identified + workaround]
4. [Routing accuracy assessment]

**Tools Verified/Additions:**
- [Tool name]: path verified / added to tool-index
- [Any new scripts created]

**Follow-up Needed:**
- [ ] Research [topic]
- [ ] Write reference doc
- [ ] Propose routing update
```

---

## Troubleshooting

### Problem: "Reverse-skill not triggering"
**Check**: Are you using security-related keywords? If no, it won't auto-route.
**Fix**: Just explicitly say "use reverse-skill router" or specify skill directly.

### Problem: "Tool not found"
**Check**: Did you verify tool-index.md? Tool may not be installed.
**Fix**: Run `bash skills/scripts/bootstrap-reverse.sh <tool-name> --start-services`

### Problem: "Route unclear which module?"
**Check**: Multiple keywords matched? Check priority matrix.
**Fix**: User can specify skill explicitly ("only use ida-reverse")

### Problem: "Workflow blocked"
**Check**: Auth granted? Scope defined? Tool available?
**Fix**: Verify ops/scope-contract requirements met; install missing tools

---

## Performance Tips

- Keep field-journal clean (anonymize all data before logging)
- Review _index.md before EVERY new task (reuse > reinvent)
- Refresh tool-index after ANY installation
- Commit improvements regularly to repository (if sharing)
- Test bootstrap scripts periodically to ensure they still work
- Document failure modes in field-journal for future avoidance

---

*Quick reference updated: 2026-08-04*
*For full documentation: read skills/SKILL.md, RULES.md, MASTER-ROUTING.md*
