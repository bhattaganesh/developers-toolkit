#!/bin/bash
# PostToolUse hook: Prettier format for CSS/SCSS files
# Reads tool result from stdin JSON, extracts file_path via jq

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content.file_path // empty' 2>/dev/null)

# Exit if no file path or not a CSS/SCSS file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" =~ \.(css|scss)$ ]]; then
    exit 0
fi

# Run Prettier (prefer project-local, fallback to npx)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

if [ -f "$PROJECT_DIR/node_modules/.bin/prettier" ]; then
    "$PROJECT_DIR/node_modules/.bin/prettier" --write "$FILE_PATH" 2>&1 || true
elif command -v npx &>/dev/null; then
    npx prettier --write "$FILE_PATH" 2>&1 || true
fi
