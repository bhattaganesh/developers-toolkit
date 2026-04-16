#!/bin/bash
# Block destructive commands like wp db reset, wp db drop, rm -rf, DROP TABLE, --force
# Reads JSON input from stdin, checks tool_input.command

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'wp db reset|wp db drop|rm -rf|DROP TABLE|drop database|--force'; then
  echo "Blocked: destructive command detected" >&2
  exit 2
fi

exit 0
