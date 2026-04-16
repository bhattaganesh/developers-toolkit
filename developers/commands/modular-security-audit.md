---
description: Run a comprehensive, feature-by-feature security audit for WordPress plugins using a 5-phase methodology with expert validation
---

# Modular Security Audit

Run a thorough, high-confidence security audit of a WordPress plugin using the `modular-security-audit` skill — breaks the plugin into modules and audits each one systematically.

## Instructions

1. **Identify the target** — Specify what to audit:
   - Full plugin (provide the plugin root directory)
   - Specific modules (e.g., REST API handlers, AJAX endpoints, file upload features)
   - A recent change set (e.g., "audit the new payment integration")

2. **Activate the skill** — Trigger the `modular-security-audit` skill by describing the need:
   > "Run a security audit on this plugin"
   > "Audit this plugin for vulnerabilities"
   > "Modular security audit of [plugin name]"
   > "Pentest this WordPress plugin"
   > "Find security issues in [plugin/feature]"

3. **5-Phase methodology** — The skill executes per module:
   - **Phase 1:** Module identification and threat modeling
   - **Phase 2:** Static analysis (grep patterns, code review)
   - **Phase 3:** Logic analysis (business logic flaws, privilege escalation)
   - **Phase 4:** Expert validation (multi-perspective review to eliminate false positives)
   - **Phase 5:** GitHub issue creation with severity, CVSS score, and remediation

4. **Review deliverables:**
   - Master tracking GitHub issue with module-by-module status
   - Individual GitHub issues per confirmed vulnerability
   - CVSS severity scores (Critical/High/Medium/Low)
   - Proof-of-concept or reproduction steps
   - Prioritized remediation guide

## What the Audit Covers

- **Authentication & Authorization** — Capability checks, role escalation, nonce verification
- **Input Handling** — SQL injection, XSS, command injection, path traversal
- **AJAX & REST endpoints** — Permission callbacks, authentication bypass, data exposure
- **File operations** — Upload validation, MIME type checks, directory traversal
- **Data exposure** — Sensitive data in responses, debug output, error messages
- **CSRF** — Nonce presence and validation on state-changing operations
- **Third-party integrations** — API key exposure, insecure external requests
- **WordPress-specific** — `$wpdb->prepare()`, HEREDOC prohibition, `ALLOW_UNFILTERED_UPLOADS`

## Philosophy

Slow, thorough, high-confidence audits that minimize false positives. Every finding is validated from multiple expert perspectives before being filed as an issue. Focus is on **real exploitable vulnerabilities**, not theoretical risks.

## Dependencies

This command activates the **modular-security-audit** skill bundled with the developers plugin.
For a quick security check (not comprehensive audit), use `/developers:security-check` instead.
For implementing a fix after the audit, use `/developers:security-fix`.
