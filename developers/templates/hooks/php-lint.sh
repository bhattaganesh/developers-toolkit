#!/bin/bash
# PostToolUse hook: PHP lint + PHPStan
# Reads tool result from stdin JSON, extracts file_path via jq
# Install: Copy to project, configure in .claude/settings.json

set -euo pipefail

# Parse input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content.file_path // empty' 2>/dev/null)

# Exit if no file path or not a PHP file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" =~ \.php$ ]]; then
    exit 0
fi

# Step 1: PHP syntax check (required)
if ! php -l "$FILE_PATH" 2>&1; then
    echo "PHP syntax check failed for $FILE_PATH"
    exit 1
fi

# Step 2: PHPStan analysis (optional — only if installed)
if [ -f "${CLAUDE_PROJECT_DIR:-.}/vendor/bin/phpstan" ]; then
    "${CLAUDE_PROJECT_DIR:-.}/vendor/bin/phpstan" analyse --no-progress --no-ansi "$FILE_PATH" 2>&1 || true
fi
