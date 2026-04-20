---
description: Implement a security patch for a WordPress vulnerability — XSS, SQLi, CSRF, IDOR, auth bypass, and more
---

# Security Fix

Implement a complete, production-ready security patch for a WordPress plugin or theme vulnerability using the `security-fix` skill.

## Instructions

1. **Describe the vulnerability** — Provide one of the following:
   - A security report (HackerOne, Wordfence, Patchstack, WPScan, internal audit)
   - A CVE or CVSS score with description
   - A specific vulnerability type and location (file + line)
   - An audit finding from `/developers:modular-security-audit`

2. **Activate the skill** — Trigger the `security-fix` skill by describing the issue:
   > "Fix a security vulnerability in [file/feature]"
   > "Patch this XSS / SQLi / CSRF / IDOR"
   > "Implement a fix for this security report: [description]"
   > "Address this HackerOne / Wordfence finding"
   > "Fix the nonce verification / capability check issue in [location]"

3. **Review the fix** — The skill produces:
   - Patched code with inline comments explaining each security control
   - Before/after diff for code review
   - Test cases demonstrating the vulnerability is closed
   - Regression check to ensure no functionality is broken
   - Changelog entry for responsible disclosure

4. **Verify** — Run the provided verification commands to confirm the fix.

## What the Skill Fixes

- **XSS** — Missing output escaping (`esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`)
- **SQL Injection** — Unparameterized queries → `$wpdb->prepare()`
- **CSRF** — Missing nonce creation and verification
- **IDOR** — Missing ownership/authorization checks
- **Authentication bypass** — Missing capability checks (`current_user_can()`)
- **Path traversal** — Unsafe file path construction
- **File upload** — Missing MIME type validation, extension whitelist
- **Data exposure** — Debug output, sensitive data in REST responses
- **SSRF** — Unvalidated external URLs in server-side requests

## Operating Principles

- **Complete fix** — No partial patches; vulnerability fully closed
- **Defense in depth** — Multiple layers where appropriate
- **Fail securely** — Deny by default on any error
- **Minimal footprint** — Change only what's necessary to fix the issue
- **No functionality broken** — Regression-tested against happy path

## Dependencies

This command activates the **security-fix** skill bundled with the developers plugin.
To find vulnerabilities first, run `/developers:modular-security-audit` or `/developers:security-scan`.
