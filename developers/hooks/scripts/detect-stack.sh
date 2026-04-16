#!/bin/bash
# SessionStart hook: Detect project tech stack and git branch
# Provides context to Claude at the start of every session

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" 2>/dev/null || exit 0

STACK=""

# Detect frameworks
[ -f "composer.json" ] && STACK="${STACK}WordPress/PHP "
[ -f "package.json" ] && STACK="${STACK}Node/React "
if [ -d "wp-content" ] || grep -q 'WordPress' style.css 2>/dev/null; then
    STACK="${STACK}WordPress "
fi

# Detect branch
BRANCH=$(git branch --show-current 2>/dev/null || echo "not a git repo")

echo "Stack: ${STACK:-Unknown}"
echo "Branch: $BRANCH"

