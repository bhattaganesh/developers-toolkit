---
description: Run a security audit on the codebase using the security-auditor agent
---

# Security Scan

Run a focused security audit on the codebase.

## Instructions

1. **Identify scope** — Determine what to audit:
   - If the user specifies files or directories, use those
   - If no scope given, audit all source files (`app/`, `src/`, `includes/`, `resources/js/`)

2. **Launch security-auditor** — Use the Task tool to spawn the **security-auditor** agent with the identified scope.

3. **Review findings** — Present the security-auditor's findings grouped by severity (Critical, High, Medium, Low).

4. **Actionable next steps** — For each Critical and High finding, suggest the specific fix pattern (one line each). Do NOT implement fixes unless the user explicitly asks.

5. **Summary** — End with: files scanned, findings by severity, and whether the codebase passes a basic security review.

## Reference Standards

The security-auditor checks against these rules:
- No hardcoded secrets, passwords, or API keys
- Input validation at all system boundaries
- Output encoding to prevent XSS
- Parameterized queries for all database operations
- Auth middleware on all protected routes
- CSRF protection on state-changing requests
- File upload validation (type, size, content)

## Dependencies

This command uses the security-auditor agent bundled with the **developers** plugin.
