#!/bin/bash
# PostToolUse hook: Suggest related test file when editing app/ PHP files
# Reads tool result from stdin JSON, extracts file_path via jq

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content.file_path // empty' 2>/dev/null)

# Exit if no file path or not in app/ directory
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" =~ ^(.*/)?app/.*\.php$ ]]; then
    exit 0
fi

# Derive the expected test file path
TEST_FILE=$(echo "$FILE_PATH" | sed 's|app/|tests/Feature/|' | sed 's|\.php$|Test.php|')

if [ -f "$TEST_FILE" ]; then
    echo "Related test exists: $TEST_FILE — consider running it"
fi
