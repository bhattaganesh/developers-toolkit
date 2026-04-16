# Git Workflow for Accessibility Fixes

Parallel-safe git workflow using worktrees.

## Safety Rules

- NEVER force push to main/dev
- NEVER skip hooks (--no-verify)
- NEVER amend published commits
- ONLY commit when user approves

## Worktree Setup

```bash
# Fetch latest
git fetch origin

# Create branch
git checkout -b chore/accessibility-audit origin/dev

# Create worktree in sibling directory
git worktree add ../accessibility-audit-work chore/accessibility-audit

# Work in worktree
cd ../accessibility-audit-work
```

## Making Changes

```bash
# Make accessibility fixes
# Test changes

# Stage specific files
git add path/to/file.css
git add path/to/component.php

# Commit with Co-Authored-By
git commit -m "$(cat <<'EOF'
accessibility: Fix focus indicators and add alt text

- Added :focus-visible styles
- Added alt text to 12 images
- Added aria-label to 5 buttons

Tested with keyboard + NVDA screen reader.

Fixes: #123, #124

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

# Push
git push -u origin chore/accessibility-audit
```

## Cleanup

```bash
# Return to main repo
cd ../original-repo

# Remove worktree after PR merged
git worktree remove ../accessibility-audit-work
git branch -D chore/accessibility-audit
```
