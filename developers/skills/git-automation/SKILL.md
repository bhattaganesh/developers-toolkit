---
name: git-automation
description: >
  This skill should be used when the user asks to "commit my changes", "push and create a PR",
  "commit and push", "create a pull request", "open a PR", "commit this", "git commit",
  "create a GitHub PR", "ship this", "I'm done with this feature", "submit for review",
  or when the user has finished a task and wants to get the code into version control and review.
version: 1.0.0
tools: Read, Bash, Glob, Grep
---

# Git Automation

Smart commit → push → PR flow. Reads actual diff, infers message style from project history, stages safely, and creates a PR with a useful description.

## Full Workflow

### Step 1 — Understand What Changed

Run in parallel:
```bash
git diff --staged          # What's already staged
git diff                   # What's unstaged
git status --short         # Overall picture
git log --oneline -5       # Project's commit style
```

### Step 2 — Infer Commit Message Style

Look at `git log --oneline -5` output:
- Uses conventional commits? (`feat:`, `fix:`, `docs:`) → follow the same format
- Uses imperative sentences? ("Add login page") → match that style
- Has ticket references? ("PROJ-123:") → ask user for ticket number

If no clear style exists → default to conventional commits.

### Step 3 — Analyze the Changes

Read the diff to understand:
- **What changed** (files, functions, components)
- **Why it changed** (infer from context — is this a bug fix? new feature? refactor?)
- **Scope** (single file change, or multi-file feature)

### Step 4 — Stage Changes (Safely)

**Never** `git add .` or `git add -A` blindly. Check each file first.

```bash
# See all unstaged changes
git diff --name-only

# Stage specific files
git add src/feature.js tests/feature.test.js

# Avoid staging:
# - .env, .env.local, *.env files
# - credentials.json, secrets.json, *.key
# - __pycache__/, node_modules/, vendor/ (if not in .gitignore somehow)
# - Large binary files unless intentional
```

If potentially sensitive files are unstaged, warn the user before staging.

### Step 5 — Write the Commit Message

Format for conventional commits:
```
type(scope): short description (50 chars max)

Optional body — why this change was made.
What problem it solves, not what the code does.
Wrap at 72 chars.
```

**Types:**
- `feat:` — new feature or capability
- `fix:` — bug fix
- `docs:` — documentation only
- `style:` — formatting, no logic change
- `refactor:` — restructure, no behavior change
- `test:` — adding or fixing tests
- `chore:` — build, deps, config, tooling
- `perf:` — performance improvement

**Examples:**
```
feat(auth): add Google OAuth login

fix(posts): prevent XSS in comment sanitization

docs: add WP-CLI usage examples to README

refactor(api): extract rate limiter into middleware

chore: bump @wordpress/scripts to 30.x
```

### Step 6 — Commit

```bash
git commit -m "$(cat <<'EOF'
feat(feature): add new capability

Brief explanation of why this change was made.
EOF
)"
```

**Never use `--no-verify`** unless user explicitly asks. Hooks exist for a reason.

### Step 7 — Push

```bash
# Check if branch has remote tracking
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null

# If no upstream, push and set tracking
git push -u origin HEAD

# If upstream exists
git push
```

### Step 8 — Create Pull Request

```bash
gh pr create \
    --title "feat: add new capability" \
    --body "$(cat <<'EOF'
## Summary

- Adds [feature description]
- Fixes [problem description]

## Changes

- `path/to/file.js` — [what changed]
- `path/to/other.php` — [what changed]

## Testing
[Automated results from /developers:pre-pr attached]
- [ ] [How to verify this works]
- [ ] [Edge case to test]
- [ ] Tests pass: `npm test` / `composer test`

## Changelog
- Updated [CHANGELOG.md](file:///CHANGELOG.md) with new feature details.

## Notes

[Any context reviewers need — dependencies, follow-up work, etc.]
EOF
)"

### Step 9 — Automated Quality Audit (200x Multiplier)

If a repo has multiple agents available, trigger `/developers:code-review` in parallel with the PR submission. Attach the initial agent report as the first comment on the PR to accelerate human review.
```

### Step 9 — Output

Always end by showing:
```
✓ Committed: "feat(feature): add new capability"
✓ Pushed to: origin/feat/feature-name
✓ PR created: https://github.com/owner/repo/pull/123
```

## Handling Common Situations

### Merge Conflicts on Push

```bash
# Pull with rebase (preferred)
git pull --rebase origin main

# Resolve conflicts, then
git rebase --continue
git push
```

### Branch Doesn't Exist Yet

```bash
# Create branch from current state
git checkout -b feat/new-feature
git push -u origin feat/new-feature
```

### Draft PR

If the user says "not ready for review yet" or "draft":
```bash
gh pr create --draft --title "..." --body "..."
```

### Amend Last Commit (Before Push)

Only if user explicitly says to amend AND commit hasn't been pushed:
```bash
git add [files]
git commit --amend --no-edit
```

## Safety Rules

- **Never force push** to `main` or `master` — warn user if they request it
- **Never commit secrets** — check diff for API keys, passwords, tokens before staging
- **Never skip hooks** (`--no-verify`) without explicit user instruction
- **Always confirm** before pushing to protected branches
- **Don't create empty commits** — if there's nothing to commit, say so
