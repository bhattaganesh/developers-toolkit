#!/bin/bash
# Weekly tech debt scan — finds duplicated code, dead code, and TODOs
# Usage: ./techdebt.sh [directory]
# Example: ./techdebt.sh app/
# Example: ./techdebt.sh src/

set -euo pipefail

SCAN_DIR="${1:-.}"
MAX_BUDGET="${TECHDEBT_BUDGET:-2.00}"
MODEL="${TECHDEBT_MODEL:-haiku}"
OUTPUT_FILE="${TECHDEBT_OUTPUT:-/tmp/techdebt-$(date +%Y%m%d).md}"

echo "Tech debt scan on $SCAN_DIR (model: $MODEL, budget: \$$MAX_BUDGET)"
echo "Output: $OUTPUT_FILE"

claude -p "Perform a tech debt audit on this codebase. Scan the directory: $SCAN_DIR

Find and report:
1. **Duplicated Code** — Functions or blocks that appear in multiple files with similar logic
2. **Dead Code** — Functions/methods never called, unused imports, unreachable code paths
3. **TODOs/FIXMEs** — Outstanding TODO, FIXME, HACK, XXX comments with file:line references
4. **Large Files** — Files over 500 lines that should be split
5. **Complex Functions** — Functions with high cyclomatic complexity (many branches/conditions)

Output as a markdown report with:
- Executive summary (total issues by category)
- Detailed findings grouped by category
- Suggested action items prioritized by impact

Write the report to: $OUTPUT_FILE" \
    --model "$MODEL" \
    --max-budget-usd "$MAX_BUDGET" \
    --allowedTools Read,Glob,Grep,Write \
    --output-format text 2>&1 || true

if [ -f "$OUTPUT_FILE" ]; then
    echo ""
    echo "Report saved to $OUTPUT_FILE"
    echo "Summary:"
    head -30 "$OUTPUT_FILE"
else
    echo "No report generated — check for errors above."
fi
