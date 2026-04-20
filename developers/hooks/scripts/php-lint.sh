#!/bin/bash
# PostToolUse hook: PHP syntax check + PHPStan analysis
# Reads tool result from stdin JSON, extracts file_path via jq

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content.file_path // empty' 2>/dev/null)

# Exit if no file path or not a PHP file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" =~ \.php$ ]]; then
    exit 0
fi

# Step 1: PHP syntax check — only output on failure
SYNTAX_OUTPUT=$(php -l "$FILE_PATH" 2>&1)
SYNTAX_EXIT=$?
if [ $SYNTAX_EXIT -ne 0 ]; then
    echo "⚠ PHP syntax error: $FILE_PATH"
    echo "$SYNTAX_OUTPUT"
    exit 0
fi

# Step 2: PHPStan analysis (only if installed in the project) — only output on failure
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
if [ -f "$PROJECT_DIR/vendor/bin/phpstan" ]; then
    PHPSTAN_OUTPUT=$("$PROJECT_DIR/vendor/bin/phpstan" analyse --no-progress --no-ansi "$FILE_PATH" 2>&1)
    PHPSTAN_EXIT=$?
    if [ $PHPSTAN_EXIT -ne 0 ]; then
        echo "⚠ PHPStan: $FILE_PATH"
        echo "$PHPSTAN_OUTPUT" | head -20
    fi
fi
