---
description: Pre-deployment checklist — pending migrations, new env variables, new dependencies, new queue jobs, irreversible changes
---

# Deploy Check

Run a pre-deployment readiness checklist to catch deployment issues before they happen.

## Instructions

1. **Check pending migrations** — List all migration files that have not been run:
   - Run `php wp migrate:status` if possible, or diff migration files against the target branch
   - For each migration, check if it is reversible (has a `down()` method)
   - Flag any destructive operations: dropping tables, dropping columns, changing column types
   - Warn explicitly about irreversible migrations

2. **Check environment variables** — Compare `.env.example` changes:
   - Run `git diff main...HEAD -- .env.example` to find new variables
   - List each new variable with its expected purpose
   - Flag any that have empty defaults or need secrets configured
   - Confirm no real secrets are committed in `.env.example`

3. **Check new dependencies** — Review dependency changes:
   - Diff `composer.json` and `composer.lock` for new PHP packages
   - Diff `package.json` and lock files for new JS packages
   - List each new dependency with its version and purpose
   - Flag any that require system-level installation (e.g., PHP extensions)

4. **Check new queue jobs** — Scan for new job classes or queue configuration:
   - Search for new files in `app/Jobs/` or similar directories
   - Check for new queue connections or queue names in config
   - Flag jobs that need dedicated workers or supervisor config updates

5. **Check for breaking changes** — Scan for:
   - API endpoint changes (removed or renamed routes)
   - Configuration key changes
   - Database schema changes that could affect running queries
   - Cache key changes that need cache clearing

6. **Output deploy readiness report** — Present a structured report:
   - **Migrations**: List with reversibility status
   - **Environment**: New variables needed
   - **Dependencies**: New packages to install
   - **Queue workers**: New workers needed
   - **Breaking changes**: Warnings and required manual steps
   - **Overall status**: Ready / Needs attention / Blocked

