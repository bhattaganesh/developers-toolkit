---
description: Run a comprehensive code review using specialized review agents
---

# Code Review

Run a comprehensive code review on the current codebase or specified files.

## Instructions

1. **Identify scope** — Ask what files, directories, or recent changes to review. If the user says "everything" or "all", use `git diff` to find recently changed files.

2. **Detect stack** — Look at the project structure to determine which reviewers to use:
   - PHP files in `app/`, `routes/`, `database/` → Use **php-reviewer** agent
   - PHP files in `wp-content/`, `includes/` with WordPress functions → Use **wp-reviewer** agent
   - JS/JSX/TS/TSX files in `src/`, `resources/js/`, `components/` → Use **react-reviewer** agent
   - Always run **security-auditor** agent on all code

3. **Launch agents in parallel** — Use the Task tool to spawn the appropriate reviewer agents as subagents. Run them concurrently for speed.

4. **Consolidate findings** — Merge results from all agents into a single report grouped by severity:
   - **Critical** — Security vulnerabilities, data loss risks
   - **High** — Architecture violations, missing auth/validation
   - **Medium** — Code quality, anti-patterns, missing tests
   - **Low** — Style, naming, minor improvements

5. **Summarize** — End with a brief summary: files reviewed, issues by severity, top 3 action items.

## Dependencies

This command uses the specialized review agents bundled with the **developers** plugin (security-auditor, php-reviewer, wp-reviewer, react-reviewer). These agents run in parallel for faster, more thorough reviews.
