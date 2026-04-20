#!/bin/bash
# PostToolUse hook: ESLint auto-fix for JS/TS files
# Reads tool result from stdin JSON, extracts file_path via jq

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content.file_path // empty' 2>/dev/null)

# Exit if no file path or not a JS/TS file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" =~ \.(js|jsx|ts|tsx)$ ]]; then
    exit 0
fi

# Run ESLint with auto-fix — only output warnings/errors, suppress success noise
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

if [ -f "$PROJECT_DIR/node_modules/.bin/eslint" ]; then
    ESLINT_OUTPUT=$("$PROJECT_DIR/node_modules/.bin/eslint" --fix "$FILE_PATH" 2>&1)
    ESLINT_EXIT=$?
    if [ $ESLINT_EXIT -ne 0 ]; then
        echo "⚠ ESLint: $FILE_PATH"
        echo "$ESLINT_OUTPUT" | head -30
    fi
elif command -v npx &>/dev/null; then
    ESLINT_OUTPUT=$(npx eslint --fix "$FILE_PATH" 2>&1)
    ESLINT_EXIT=$?
    if [ $ESLINT_EXIT -ne 0 ]; then
        echo "⚠ ESLint: $FILE_PATH"
        echo "$ESLINT_OUTPUT" | head -30
    fi
fi
