---
description: Systematically debug an issue using structured root cause analysis
---

# Debug

Systematically debug an issue using structured root cause analysis.

## Instructions

1. **Gather context** — Ask the user for:
   - Error message, stack trace, or symptom description
   - Steps to reproduce (if known)
   - When it started (recent deploy? code change?)
   - If not provided, check `git log --oneline -10` for recent changes

2. **Launch debug-agent** — Use the Task tool to spawn the **debug-agent** with the error context and relevant file paths.

3. **Structured analysis** — Ensure the agent follows:
   - **Reproduce**: Identify exact error location
   - **Hypothesize**: Form 2-3 ranked hypotheses
   - **Investigate**: Search for evidence, check related files
   - **Verify**: Confirm root cause with file:line references

4. **Present findings** — Show:
   - Root cause with evidence chain
   - Minimal fix suggestion
   - Regression prevention (test to add)
   - Related issues (same pattern elsewhere)

5. **Offer to fix** — After presenting findings, ask if the user wants you to implement the fix. Do NOT fix automatically.

## Common Quick Checks

Before deep investigation, run these quick checks:
- **WordPress**: `php wp config:clear && php wp cache:clear && php wp route:clear`
- **React**: Check browser console for errors, check `npm run build` for warnings
- **WordPress**: Check `wp-config.php` for `WP_DEBUG true`, check error log

## Dependencies

This command uses the debug-agent bundled with the **developers** plugin.

