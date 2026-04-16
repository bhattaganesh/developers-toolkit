---
description: Security checklist applied to all code
---

# Security Rules

These rules apply to ALL code regardless of framework or language.

## Never Hardcode
- No API keys, secrets, passwords, or tokens in source code
- No database credentials in code — use environment variables
- No hardcoded URLs to internal services — use config files
- Store secrets in `.env` files, ensure `.env` is in `.gitignore`

## Input Validation
- Validate and sanitize ALL user input at system boundaries
- Use framework-provided validators (Validations, Zod schemas, sanitize_* functions)
- Never trust client-side validation alone — always validate server-side
- Reject unexpected input types — don't just coerce

## Output Encoding
- Escape ALL dynamic output in HTML context (prevent XSS)
- Use parameterized queries for ALL database operations (prevent SQL injection)
- Encode URLs properly when including user data
- Never use `eval()`, `dangerouslySetInnerHTML`, or raw SQL concatenation without explicit justification

## Authentication & Authorization
- Auth middleware on ALL protected routes
- Capability/permission checks before ALL privileged operations
- CSRF protection on ALL state-changing requests
- Rate limiting on authentication endpoints
- Session management: proper expiry, regeneration after login

## File Handling
- Validate file type, size, and content — not just extension
- Never serve uploaded files from the application directory
- Sanitize filenames before storage
- Restrict upload directories with `.htaccess` or web server config

## Dependencies
- Keep dependencies updated — check for known vulnerabilities
- Use lockfiles (`composer.lock`, `package-lock.json`) for reproducible builds
- Review new dependencies before adding — check maintenance, popularity, security

