# Automation Script Templates

Shell scripts that use Claude Code for automated code analysis tasks. Run manually, via cron, or in CI/CD pipelines.

## Available Scripts

| Script | Purpose | Recommended Schedule |
|--------|---------|---------------------|
| `review.sh` | Code review on changed files vs base branch | Per PR / on demand |
| `generate-tests.sh` | Generate missing tests for WordPress features | On demand |
| `techdebt.sh` | Find duplicated code, dead code, TODOs | Weekly |
| `nightly-health.sh` | Security + coverage gaps + tech debt | Nightly |

## Setup

### 1. Copy scripts to your project

```bash
mkdir -p scripts/
cp review.sh generate-tests.sh techdebt.sh nightly-health.sh scripts/
chmod +x scripts/*.sh
```

### 2. Set environment variables

All scripts use environment variables for configuration with sensible defaults:

```bash
# Required
export ANTHROPIC_API_KEY="sk-ant-..."

# Optional overrides (shown with defaults)
export REVIEW_MODEL="haiku"        # Model for review.sh
export REVIEW_BUDGET="1.00"        # Budget cap for review.sh
export TEST_GEN_MODEL="sonnet"     # Model for generate-tests.sh
export TEST_GEN_BUDGET="2.00"      # Budget cap for generate-tests.sh
export TECHDEBT_MODEL="haiku"      # Model for techdebt.sh
export TECHDEBT_BUDGET="2.00"      # Budget cap for techdebt.sh
export HEALTH_MODEL="haiku"        # Model for nightly-health.sh
export HEALTH_BUDGET="5.00"        # Budget cap for nightly-health.sh
```

### 3. Run manually

```bash
# Review changes against main
./scripts/review.sh main

# Generate tests for controllers
./scripts/generate-tests.sh app/Http/Controllers

# Run tech debt scan
./scripts/techdebt.sh app/

# Full health check
./scripts/nightly-health.sh
```

## Cron Setup

```bash
# Edit crontab
crontab -e

# Weekly tech debt scan (Mondays at 6am)
0 6 * * 1 cd /path/to/project && ./scripts/techdebt.sh app/ >> /var/log/techdebt.log 2>&1

# Nightly health check (midnight)
0 0 * * * cd /path/to/project && ./scripts/nightly-health.sh >> /var/log/health.log 2>&1
```

## Cost Estimates

All scripts use `--max-budget-usd` safety nets to prevent runaway costs:

| Script | Model | Budget Cap | Typical Cost |
|--------|-------|-----------|-------------|
| review.sh | haiku | $1.00/file | $0.05-0.30 per file |
| generate-tests.sh | sonnet | $2.00/controller | $0.50-1.50 per controller |
| techdebt.sh | haiku | $2.00 | $0.30-1.00 per scan |
| nightly-health.sh | haiku | $5.00 | $1.00-3.00 per run |

## Requirements

- Claude Code CLI (`npm install -g @anthropic-ai/claude-code`)
- `ANTHROPIC_API_KEY` environment variable
- `git` (for review.sh)
- `jq` (optional, for parsing output)
