# GitHub Actions Templates for Claude Code

CI/CD workflows that use Claude Code for automated code review and lint fixes.

## Available Workflows

### `developers-review.yml` — Automated PR Review

Runs on every pull request. Claude reviews changed files and posts findings as a PR comment.

- **Model:** haiku (fast, cost-effective)
- **Budget cap:** $1.00 per review
- **Trigger:** `pull_request` (opened, synchronize, reopened)
- **Output:** PR comment grouped by severity

### `developers-fix.yml` — Auto-Fix on Push

Runs on pushes to develop/dev branch. Claude fixes linting, formatting, and type errors, then auto-commits.

- **Model:** haiku (fast, cost-effective)
- **Budget cap:** $3.00 per run
- **Trigger:** `push` to develop/dev
- **Output:** Auto-committed fixes

## Setup

### 1. Add API key as repository secret

```bash
# Using GitHub CLI
gh secret set ANTHROPIC_API_KEY --body "sk-ant-..."
```

Or via GitHub UI: Settings > Secrets and variables > Actions > New repository secret

### 2. Copy workflows

```bash
# Copy to your project's workflow directory
mkdir -p .github/workflows
cp developers-review.yml .github/workflows/
cp developers-fix.yml .github/workflows/
```

### 3. Customize

Edit the workflow files to adjust:

- **Budget cap:** Change `--max-budget-usd` to your preferred limit
- **Model:** Change `--model` (options: `haiku`, `sonnet`, `opus`)
- **Trigger branches:** Modify the `on.push.branches` or `on.pull_request` section
- **Review prompt:** Customize the review instructions in the `claude -p` command
- **Allowed tools:** Restrict tools with `--allowedTools` for safety

## Cost Estimates

| Workflow | Model | Budget Cap | Typical Cost |
|----------|-------|-----------|-------------|
| developers-review | haiku | $1.00 | $0.05-0.30 per PR |
| developers-fix | haiku | $3.00 | $0.10-1.00 per push |

## Security Notes

- The `ANTHROPIC_API_KEY` secret is never exposed in logs
- `developers-fix.yml` only commits to develop/dev branches (never main)
- Budget caps prevent runaway costs
- Both workflows use `timeout-minutes` as a safety net
- Review workflow has read-only code access (only writes PR comments)
