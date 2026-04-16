#!/bin/bash
# Block git add commands that include .env files
# Reads JSON input from stdin, checks tool_input.command

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'git add.*\.env[^.]'; then
  echo "Blocked: committing .env files is not allowed" >&2
  exit 2
fi

exit 0
