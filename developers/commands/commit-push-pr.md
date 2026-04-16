---
description: Commit changes, push branch, and open a pull request in one step
---

# Commit, Push & PR

One-step workflow to commit staged changes, push the branch, and create a pull request.

## Instructions

1. **Check for changes** — Run `git status` and `git diff --stat`. If there are no changes (nothing staged and nothing modified), stop and inform the user there is nothing to commit.

2. **Scan for debug artifacts** — Search the diff for leftover debug statements:
   - PHP: `dd(`, `dump(`, `var_dump(`, `print_r(`, `ray(`
   - JS/TS: `console.log(`, `console.debug(`, `debugger`
   - General: `TODO`, `FIXME`, `HACK`, `XXX`
   - If found, warn the user with file:line references and ask whether to proceed or clean up first.

3. **Stage relevant files** — Stage all modified and new files. NEVER stage `.env` files or files containing secrets. Use `git add` with specific file paths rather than `git add -A`.

4. **Create commit** — Analyze the diff to determine the nature of changes, then create a commit:
   - Detect the project's commit prefix style from recent `git log --oneline -10`
   - Use the matching prefix (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`, `perf:`)
   - Write a concise message (1-2 sentences) focusing on the "why"
   - Append `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

5. **Push branch** — Push the current branch to origin with `-u` flag:
   ```bash
   git push -u origin $(git branch --show-current)
   ```

6. **Detect base branch** — Determine the default branch for the PR target:
   ```bash
   gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
   ```

7. **Create pull request** — Use `gh pr create`:
   - Generate a short title (under 70 characters) from the commit(s)
   - Generate a body with Summary (bullet points from all commits on this branch), Test plan, and the Claude Code attribution
   - Use `git log $(base)...HEAD` to capture all commits, not just the latest one
   - Format:
   ```bash
   gh pr create --title "PR title" --body "$(cat <<'EOF'
   ## Summary
   - Bullet points of changes

   ## Test plan
   - [ ] Testing steps

   Generated with [Claude Code](https://claude.com/claude-code)
   EOF
   )"
   ```

8. **Report** — Display the PR URL to the user.

## Safety Checks

- Never stage `.env` files — warn if `.env` appears in changed files
- Never force-push — always use regular `git push`
- If branch has no upstream, set it with `-u`
- If `gh` CLI is not available, push the branch and provide a manual PR creation URL
