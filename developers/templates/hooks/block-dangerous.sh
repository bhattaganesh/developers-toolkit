#!/bin/bash
# PreToolUse hook: Block dangerous commands
# Reads tool input from stdin JSON, checks command against deny list
# Install: Copy to project, configure in .claude/settings.json

set -euo pipefail

# Parse input from stdin
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Exit if no command
if [ -z "$COMMAND" ]; then
    exit 0
fi

# Dangerous patterns to block
BLOCKED_PATTERNS=(
    "wp db reset"
    "wp db drop"
    "rm -rf"
    "DROP TABLE"
    "drop database"
    "--force"
    "git push.*--force"
    "git reset --hard"
    "git clean -f"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        # Return JSON response to block the command
        echo "{\"decision\": \"block\", \"reason\": \"Blocked dangerous command matching pattern: $pattern\"}"
        exit 2
    fi
done

# Check for .env in git add
if echo "$COMMAND" | grep -qE "git add.*\.env[^.]"; then
    echo "{\"decision\": \"block\", \"reason\": \"Blocked: never commit .env files to git\"}"
    exit 2
fi

exit 0
