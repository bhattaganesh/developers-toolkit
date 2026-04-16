#!/bin/bash
# Code review on changed files using Claude Code
# Usage: ./review.sh [base-branch]
# Example: ./review.sh main
# Example: ./review.sh develop

set -euo pipefail

BASE_BRANCH="${1:-main}"
MAX_BUDGET="${REVIEW_BUDGET:-1.00}"
MODEL="${REVIEW_MODEL:-haiku}"

echo "Reviewing changes against $BASE_BRANCH (model: $MODEL, budget: \$$MAX_BUDGET)"

# Get changed files
FILES=$(git diff --name-only "$BASE_BRANCH"...HEAD)

if [ -z "$FILES" ]; then
    echo "No changes found against $BASE_BRANCH"
    exit 0
fi

echo "Files to review:"
echo "$FILES" | sed 's/^/  - /'
echo ""

# Review each file
echo "$FILES" | while read -r file; do
    if [ -f "$file" ]; then
        echo "Reviewing: $file"
        claude -p "Review this file for security vulnerabilities, code quality issues, and anti-patterns. Be concise — only report problems. Include line numbers. File: $file" \
            --model "$MODEL" \
            --max-budget-usd "$MAX_BUDGET" \
            --allowedTools Read,Grep,Glob \
            --output-format text 2>&1 || true
        echo "---"
    fi
done

echo "Review complete."
