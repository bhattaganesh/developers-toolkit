---
name: coding-standards
description: >
  This skill should be used when the user asks to "apply org standards", "check coding standards",
  "enforce team rules", "review against standards", "what standards apply here", or wants to
  understand what organizational coding standards apply to their project.
  Provides WordPress, React, and security standards enforcement.
version: 1.0.0
---

# Toolkit Coding Standards

Enforces consistent coding standards across WordPress and React projects.

## Quick Reference

**Standards:** WordPress (WPCS), React (ESLint/Prettier), Security (OWASP)
**Stacks:** WordPress, React/NextJS, Tailwind CSS

---

## When to Use

- Setting up a new project with team standards
- Reviewing code against organizational rules
- Running pre-PR quality checks
- Onboarding a developer to team conventions

---

## Standards Summary

### WordPress
- Sanitize all input, escape all output
- Nonce verification on all forms and AJAX
- Capability checks before privileged operations
- $wpdb->prepare() for all queries with variables
- Plugin prefix on all functions, hooks, classes

### React / NextJS
- Functional components only, one per file
- Custom hooks for shared logic
- Server components by default (NextJS)
- Mobile-first Tailwind CSS
- Component tests with @testing-library/react

### Security (All Stacks)
- No hardcoded secrets in source code
- Validate and sanitize all user input
- Parameterized queries for database operations
- Auth middleware on all protected routes
- CSRF protection on state-changing requests

### API Design
- RESTful URL structure with plural nouns
- Consistent response envelope and error format
- Proper HTTP status codes and pagination
- Rate limiting and versioning

### Database Migrations
- Every up() must have a working down()
- Never drop columns without backup strategy
- Use decimal for money, index all foreign keys
- Batch data migrations with chunk()

### Git Workflow
- Commit prefixes: fix:, feat:, chore:, refactor:
- One branch per task, branch from master
- Keep PRs focused, squash merge

---

## Reference

Full standards documentation is in the `rules/` directory:
- `wordpress.md` — Security, plugin standards, hooks, database
- `react.md` — Components, hooks, NextJS, Tailwind
- `security.md` — Secrets, validation, encoding, auth
- `testing.md` — PHPUnit, Jest, test quality
- `api-design.md` — REST design, status codes, pagination
- `database-migrations.md` — Migration safety, schema design
- `git-workflow.md` — Commits, branching, PRs
- `design-patterns.md` — Service, Repository, Strategy, Composition, anti-patterns
- `code-profiling.md` — Performance targets, tools, profiling checklists

