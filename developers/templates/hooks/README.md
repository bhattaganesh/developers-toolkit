# Hook Script Templates

Script-based hooks for Claude Code that provide more robust behavior than inline commands. These use `$CLAUDE_PROJECT_DIR` for proper path resolution and parse stdin JSON with `jq` for reliable input handling.

## Setup

### 1. Copy scripts to your project

```bash
# Create hooks directory in your project
mkdir -p .claude/hooks

# Copy the scripts you want
cp php-lint.sh .claude/hooks/
cp eslint-check.sh .claude/hooks/
cp block-dangerous.sh .claude/hooks/
cp run-tests.sh .claude/hooks/

# Make them executable
chmod +x .claude/hooks/*.sh
```

### 2. Configure in `.claude/settings.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "pattern": "\\.php$",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/php-lint.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit",
        "pattern": "\\.(js|jsx|ts|tsx)$",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/eslint-check.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/block-dangerous.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/run-tests.sh"
          }
        ]
      }
    ]
  }
}
```

## Available Scripts

| Script | Event | Purpose |
|--------|-------|---------|
| `php-lint.sh` | PostToolUse (Write/Edit) | PHP syntax check + PHPStan analysis |
| `eslint-check.sh` | PostToolUse (Write/Edit) | ESLint auto-fix for JS/TS files |
| `block-dangerous.sh` | PreToolUse (Bash) | Block destructive commands (wp db reset, rm -rf, etc.) |
| `run-tests.sh` | Stop | Auto-detect and run test suite after Claude responds |

## Optional: SessionStart Hook

You can add a SessionStart hook to display project context when Claude starts:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"Project: $(basename $CLAUDE_PROJECT_DIR) | Branch: $(git branch --show-current 2>/dev/null || echo 'N/A') | PHP: $(php -v 2>/dev/null | head -1 || echo 'N/A') | Node: $(node -v 2>/dev/null || echo 'N/A')\""
          }
        ]
      }
    ]
  }
}
```

## Requirements

- `jq` — for parsing JSON input in hook scripts
- `php` — for PHP lint checks
- `phpstan` (optional) — for static analysis
- `eslint` (optional) — for JS/TS linting
- `phpunit`/`jest`/`vitest` (optional) — for test running

## How Hooks Work

- **PostToolUse hooks** receive the tool result as JSON on stdin after Write/Edit
- **PreToolUse hooks** receive the tool input as JSON on stdin before Bash execution
- **Stop hooks** run when Claude finishes responding (no stdin)
- All scripts use `|| true` for graceful failure when tools aren't installed
- Scripts use `$CLAUDE_PROJECT_DIR` to reference the project root

