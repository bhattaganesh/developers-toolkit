#!/bin/bash
# PostToolUse hook: ESLint auto-fix for JS/TS files
# Reads tool result from stdin JSON, extracts file_path via jq
# Install: Copy to project, configure in .claude/settings.json

set -euo pipefail

# Parse input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content.file_path // empty' 2>/dev/null)

# Exit if no file path or not a JS/TS file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" =~ \.(js|jsx|ts|tsx)$ ]]; then
    exit 0
fi

# Run ESLint with auto-fix (optional — only if installed)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

if [ -f "$PROJECT_DIR/node_modules/.bin/eslint" ]; then
    "$PROJECT_DIR/node_modules/.bin/eslint" --fix "$FILE_PATH" 2>&1 || true
elif command -v npx &>/dev/null; then
    npx eslint --fix "$FILE_PATH" 2>&1 || true
fi
