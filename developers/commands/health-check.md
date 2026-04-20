---
description: Run a project-wide health check to detect configuration drift and productivity blockers
---

# Health Check

Audit the project's health, configuration, and environment to ensure a "200x Productivity" state.

## Instructions

1. **Verify Setup** — Check if `CLAUDE.md` and `.claude/settings.json` exist and are up to date with the latest toolkit version.
2. **Environment Audit**:
   - **WordPress**: Check if `wp-config.php` correctly defines `WP_DEBUG`.
   - **React**: Check if `package.json` has all essential `@wordpress/scripts`.
   - **Git**: Check if the current branch is dirty or needs a rebase from `trunk`/`main`.
3. **Dependency Check**:
   - Run `npm list --depth=0` (quietly) to find missing modules.
   - Run `composer diagnose` (if PHP) to check for vendor issues.
4. **Project ID Sync**: Ensure the `projectId` in `CLAUDE.md` matches the remote origin hash.
5. **Report**:
   - Provide a "Health Score" (0-100%).
   - List critical blockers (e.g., "Missing node_modules").
   - List optimization suggestions (e.g., "Inconsistent i18n detected").

## When to use
- At the start of every session.
- After complex merges or dependency updates.
- When Claude seems to have lost context of the project structure.
