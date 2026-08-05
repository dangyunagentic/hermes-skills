#!/bin/bash
# Skills Improvement Tracker
# Auto-generates skill improvement notes after reverse engineer/solve tasks
# Run this script after completing any security task

SKILL_ROOT="${SKILL_ROOT:-/root/reverse-skill-clone}"
FIELD_JOURNAL="$SKILL_ROOT/skills/field-journal"
INDEX_FILE="$FIELD_JOURNAL/_index.md"
TIMESTAMP=$(date +'%Y-%m-%d')
TASK_TYPE="${1:-generic-task}"
TASK_OUTCOME="${2:-completed}"
IMPROVEMENTS="${3:-}"

echo "📝 Reverse-Skill Improvement Tracker"
echo "====================================="
echo "Timestamp: $TIMESTAMP"
echo "Task Type: $TASK_TYPE"
echo "Outcome: $TASK_OUTCOME"

# Create new log entry
LOG_FILE="$FIELD_JOURNAL/${TIMESTAMP}_${TASK_TYPE}.md"

if [ -z "$IMPROVEMENTS" ]; then
    echo ""
    echo "No improvements provided. Creating basic completion log..."
    cat > "$LOG_FILE" << 'EOF'
---
timestamp: 2026-08-04
task_type: generic-task
status: completed
anonymized: true
---

# Task Log

## Overview
Generic task completed successfully.

## Methodology Used
Followed routing protocol:
1. Read precedent-auth.md (authorization check)
2. Checked tool-index.md for available tools
3. Executed PRIMARY skill workflow per MASTER-ROUTING.md
4. Evidence→Finding→Path documented

## Outcome
Task completed. No specific improvements noted.

## Tools Used
Refer to tool-index.md for verification.

## Next Steps
See field-journal _index.md for similar past experience.
EOF
fi

# Write detailed log with user-provided improvements
cat > "$LOG_FILE" << EOF
---
timestamp: ${TIMESTAMP}
task_type: ${TASK_TYPE}
status: ${TASK_OUTCOME}
anonymized: true
---

# ${TASK_TYPE} Task Log

## Overview
${TASK_TYPE} task completed with outcome: ${TASK_OUTCOME}

## Methodology Used
\`\`\`
1. NOW: Read skills/field-journal/precedent-auth.md (authorization pre-declaration)
2. NEXT: Route via MASTER-ROUTING.md → identified PRIMARY skill
3. NEXT: case-init / scope.md established (auth.status=granted checked)
4. ACT: Opened PRIMARY SKILL.md, executed ACTION REQUIRED
5. DURING: Appended timeline/workitems, used Evidence→Finding→Path
6. AFTER: This improvement log written
\`\`\`

## Improvements & Learnings
${IMPROVEMENTS}

## Tools Verified
- Check skills/tool-index.md for actual paths used
- Any missing tools flagged for bootstrap

## Similar Past Experience
Check skills/field-journal/_index.md under "${TASK_TYPE}" section for related work.

## References Created
- Log file: ${LOG_FILE}
- Updated index: ${INDEX_FILE}
EOF

# Update _index.md if entry is new
echo ""
echo "🔍 Checking if task type exists in index..."

if ! grep -q "### $TASK_TYPE" "$INDEX_FILE"; then
    echo "New category '$TASK_TYPE' found, adding to index..."
    
    # Find appropriate insertion point (before "### Other")
    sed -i "/^## 按场景分类/r /dev/stdin" "$INDEX_FILE" << INSERT_EOF
### $TASK_TYPE

No entries yet.
INSERT_EOF
    
    # Fix formatting by removing empty lines before "其他"
    sed -i '/^###.*$/N;/\n\n###/s/\n//' "$INDEX_FILE"
fi

# Add entry to index (append to relevant section)
echo "📌 Adding entry to index..."
CATEGORY_HEADER=$(grep -n "^### $TASK_TYPE" "$INDEX_FILE" | cut -d: -f1)

if [ -n "$CATEGORY_HEADER" ]; then
    # Insert after the category header line
    TEMP_FILE=$(mktemp)
    head -n "$CATEGORY_HEADER" "$INDEX_FILE" > "$TEMP_FILE"
    echo "- [$TIMESTAMP_${TASK_TYPE}]($LOG_FILE)" >> "$TEMP_FILE"
    tail -n +"$((CATEGORY_HEADER + 1))" "$INDEX_FILE" >> "$TEMP_FILE"
    mv "$TEMP_FILE" "$INDEX_FILE"
else
    # Fallback: add at end before other categories
    echo "- [$TIMESTAMP_${TASK_TYPE}]($LOG_FILE)" >> "$INDEX_FILE"
fi

# Count stats
TOTAL_ENTRIES=$(grep -c "^- \[" "$INDEX_FILE")
REAL_ENTRIES=$((TOTAL_ENTRIES - $(grep -c "\[\[种子\]\]" "$INDEX_FILE")))

echo ""
echo "✅ Completed!"
echo "   - New log: $LOG_FILE"
echo "   - Index updated: $INDEX_FILE"
echo "   - Total entries: $TOTAL_ENTRIES ($REAL_ENTRIES real, $((TOTAL_ENTRIES - REAL_ENTRIES)) seed)"
echo ""
echo "Next time you start a task, read this index first to reuse existing experience."
