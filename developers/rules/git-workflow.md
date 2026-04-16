---
description: Git workflow conventions and best practices
globs:
  - ".gitignore"
  - ".github/**/*"
---

# Git Workflow Rules

## Commit Messages
- Format: `prefix: imperative description`
- Prefixes: `fix:`, `feat:`, `chore:`, `refactor:`, `docs:`, `test:`, `perf:`
- Imperative mood: "add feature" not "added feature" or "adds feature"
- Max 72 chars for first line
- Scope when useful: `fix(auth): resolve token expiry on refresh`
- Body for WHY, not WHAT (the diff shows what)

## Branching
- One branch per task — never mix unrelated changes
- Branch naming: `feat/add-credit-system`, `fix/auth-token-expiry`, `chore/update-deps`
- Branch from `master` (or `main`) for new work
- Delete branches after merge
- Use worktrees for parallel development

## Pull Requests
- Keep PRs focused — one feature/fix per PR
- Title matches commit prefix convention
- Description includes: what changed, why, how to test
- Self-review before requesting review
- All CI checks must pass before merge
- Squash merge to keep history clean (unless history is valuable)

## What to Commit
- Source code, configuration, documentation, tests
- `.gitignore` for the project type

## What NOT to Commit
- `.env` files (use `.env.example` for templates)
- `node_modules/`, `vendor/` (use lockfiles instead)
- Build artifacts (`dist/`, `build/`)
- IDE-specific files (`.idea/`, `.vscode/settings.json`)
- OS files (`.DS_Store`, `Thumbs.db`)
- Database dumps, logs, uploaded files
- Secrets, API keys, credentials (even "temporary" ones)

## .gitignore Essentials
```
.env
.env.local
node_modules/
vendor/
storage/*.log
.DS_Store
.idea/
.claude/settings.local.json
```
