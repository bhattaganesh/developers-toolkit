# Jira Issue Creator — Templates & Examples Reference

Read this file when assembling the final Jira issue document. It contains the full output
template, the Claude CLI section structure, and worked examples.

---

## Table of Contents

1. Final Document Template
2. Claude CLI Section — Full Structure
3. Worked Examples
4. Commit & PR Templates

---

## 1. Final Document Template

Assemble every issue using this exact structure:

```markdown
# [{TYPE}] {Title}

> **Quick Summary**: {One-line description for busy readers}
> **Story Points**: {N} | **Priority**: {P} | **Sprint**: {Sprint name or Backlog}

## 📋 Issue Details

| Field | Value |
|-------|-------|
| **Type** | {Bug 🐛 / Story 📖 / Improvement 🔧 / Task 📋 / Spike 🔍} |
| **Priority** | {Critical / High / Medium / Low} |
| **Story Points** | {N} ({reasoning}) |
| **Component(s)** | {Affected components} |
| **Labels** | {Labels} |
| **Epic** | {Epic name if applicable} |
| **Sprint** | {Sprint or Backlog} |

---

## 📖 User Story / Description

{User story in As a/I want/So that format, or bug report, or improvement proposal}

### Current Behavior
{What happens now}

### Expected Behavior
{What should happen}

### Steps to Reproduce (Bugs only)
1. {Step}
2. {Step}

### Screenshots / Logs
{Reference attached files, paste stack traces, embed images}

---

## ✅ Acceptance Criteria

AC-1: {Title}
  Given {precondition}
  When {action}
  Then {expected outcome}

AC-2: {Title}
  Given {precondition}
  When {action}
  Then {expected outcome}
  And {additional outcome}

{Continue for 6–12 ACs}

---

## ✅ Definition of Done

- [ ] All acceptance criteria met and verified
- [ ] Code reviewed and approved (min 1 reviewer)
- [ ] Unit tests written and passing (≥80% coverage on changed code)
- [ ] Integration tests passing
- [ ] No new lint/type errors introduced
- [ ] Documentation updated (API docs, README, inline comments)
- [ ] Tested in staging environment
- [ ] No regressions in existing test suite
- [ ] PR linked to this Jira issue
{Add issue-specific items}

---

## 🏗️ Implementation Blueprint

{For Features: COMPONENT blocks with files to create/modify, config, DB, API changes}
{For Bugs: ROOT CAUSE ANALYSIS with hypothesis, suspected location, fix approach}
{For Improvements: CURRENT STATE → PROPOSED STATE with migration path}

---

## 🧪 Test Strategy

### Test Cases

TC-001 [Happy Path] {Title}
  Maps to: AC-1
  Priority: Critical
  Preconditions: {setup}
  Steps:
    1. {step}
    2. {step}
  Input Data: {specific values}
  Expected Result: {outcome}
  Automated: Yes - unit
  Validation Command: `{command}`

{Continue for 10–18 test cases}

### Boundary Conditions

BC-001: {Title}
  Boundary: {exact condition}
  Test With: {specific value}
  Expected: {what should happen}
  Risk: {what breaks if mishandled}
  Mitigation: {how to handle in code}

{Continue for 6–10 boundary conditions}

### Test Data Sets

Valid inputs:
  - {field}: {exact value} — {why}
Invalid inputs:
  - {field}: {exact value} — {what error}
Boundary inputs:
  - {field}: {exact value} — {which boundary}

---

## ⚠️ Risk Assessment

| # | Risk | Likelihood | Impact | Mitigation | Owner |
|---|------|-----------|--------|------------|-------|
| R1 | {desc} | H/M/L | H/M/L | {mitigation} | {owner} |

---

## 🤖 Claude CLI Implementation Guide

{Full Claude CLI section — see section 2 below}

---

## 🔗 Dependencies & Related Issues
- Blocked by: {tickets}
- Blocks: {tickets}
- Related: {tickets}

---

## ❓ Open Questions
- {Questions needing team decisions}

---

## 📝 Notes & References
- {Context, design docs, Slack threads, related PRs}
```

---

## 2. Claude CLI Section — Full Structure

This section transforms the Jira issue into an executable specification for Claude CLI / 
Claude Code. The AI agent should be able to read ONLY this section (plus the ACs and test
cases above) and implement the entire change end-to-end.

```markdown
## 🤖 Claude CLI Implementation Guide

### Context for AI Agent
{2-3 sentence summary. Written as if briefing a senior developer who just joined.
Include: what the system does, what's broken/needed, what the expected outcome is.}

### Codebase Orientation
Before making any changes, read these files to understand the existing patterns:
1. `{path/to/file}` — {reason: understand the current implementation}
2. `{path/to/file}` — {reason: see patterns used in similar features}
3. `{path/to/file}` — {reason: understand test setup and conventions}
4. `{path/to/config}` — {reason: see environment and build configuration}

### Implementation Steps
Execute in order. Each step should be atomic and verifiable.

**Step 1: {Title} (e.g., "Add the new API endpoint")**
- What: {Exactly what to create or change}
- Where: `{file path}` → `{function/class/section}`
- How: {Implementation details — algorithm, pattern, library to use}
- Pattern to follow: `{path/to/similar/existing/code}` does something similar
- Watch out for: {Pitfalls — race conditions, null checks, type coercion, etc.}
- Verify: `{quick command to verify this step worked}`

**Step 2: {Title}**
...continue...

**Step N: Write Tests**
- Create: `{test file path}`
- Framework: {jest/pytest/go test/etc.}
- Test cases to implement: TC-001, TC-003, TC-005 (see Test Strategy section)
- Run with: `{exact test command}`
- Coverage target: {N}% on changed files

### Validation Checklist
After all implementation steps, run these commands. ALL must pass.

```bash
# 1. Unit tests
{exact command, e.g., npm test -- --coverage}

# 2. Integration tests
{exact command}

# 3. Linting
{exact command, e.g., npm run lint}

# 4. Type checking
{exact command, e.g., npx tsc --noEmit}

# 5. Build
{exact command, e.g., npm run build}

# 6. Specific verification
{curl command, script, or manual check for this exact issue}
```

### Acceptance Criteria Verification
For each AC, here's exactly how to verify it:

| AC | Verification Method | Command / Check |
|----|---------------------|-----------------|
| AC-1 | {How to test} | `{command}` |
| AC-2 | {How to test} | `{command}` |

### Done Signal
Implementation is COMPLETE when:
1. All validation checklist commands exit with code 0
2. Every AC in the table above is verified
3. No new warnings in build output
4. Test coverage on changed files ≥ {N}%
5. All boundary conditions (BC-001 through BC-{N}) are handled in code

### Commit Message
```
{type}({scope}): {description}

{body}

Closes: {JIRA-KEY}
```

### PR Description
```markdown
## What
{One-line description of the change}

## Why
{Business context and user impact}

## How
{Technical approach summary}

## Testing
- [ ] Unit tests: {what's covered}
- [ ] Integration tests: {what's covered}
- [ ] Manual testing: {what was verified and in which environment}

## Rollback
{How to revert if needed — "revert this commit" or more complex steps}

## Screenshots / Evidence
{Before/after for UI changes, test output for backend}
```
```

---

## 3. Worked Examples

### Example A: Bug — "Payment fails with special characters in coupon code"

**User says:** "Create a bug ticket — coupon codes with & or % cause a 500 error at checkout"

**Generated output highlights:**

User Story / Description:
> Users applying coupon codes containing special characters (& % # etc.) receive a 500
> Internal Server Error during checkout. This blocks purchases for promotional campaigns
> using codes like "SAVE&WIN" or "50%OFF".

Acceptance Criteria (sample):
```
AC-1: Valid coupon with special characters
  Given a valid coupon code "SAVE&WIN" exists in the system
  When a customer applies "SAVE&WIN" at checkout
  Then the discount is applied correctly
  And the checkout proceeds to payment

AC-2: Error message for invalid coupon (not a crash)
  Given a coupon code "INVALID&CODE" does not exist
  When a customer applies "INVALID&CODE"
  Then the system returns a user-friendly error "Invalid coupon code"
  And no 500 error occurs

AC-3: SQL injection prevention
  Given a malicious input "'; DROP TABLE coupons; --"
  When a customer enters this as a coupon code
  Then the input is sanitized and rejected gracefully
  And no database operations are affected
```

Claude CLI section (sample):
```
### Codebase Orientation
1. `src/services/checkout/coupon.service.ts` — current coupon validation logic
2. `src/services/checkout/__tests__/coupon.test.ts` — existing test patterns
3. `src/middleware/input-sanitizer.ts` — existing sanitization middleware

### Implementation Steps
Step 1: Fix coupon input sanitization
- Where: `src/services/checkout/coupon.service.ts` → `validateCoupon()`
- How: URL-encode the coupon code before passing to the database query.
       Use parameterized queries instead of string interpolation.
- Pattern to follow: `src/services/checkout/promo.service.ts` already does this correctly
- Watch out for: Double-encoding — check if the frontend already encodes

Step 2: Add input validation
- Where: `src/api/routes/checkout.routes.ts` → POST /checkout/apply-coupon
- How: Add Joi/Zod validation schema for the coupon field.
       Allow alphanumeric + &%#- characters, max 50 chars.
- Verify: `curl -X POST localhost:3000/api/checkout/apply-coupon -d '{"code":"SAVE&WIN"}'`
```

### Example B: Story — "Add dark mode to the dashboard"

**User says:** "Feature ticket: add dark mode toggle to the dashboard"

**Generated user story:**
```
As a user who works extended hours at a computer,
I want a dark mode toggle on the dashboard,
So that I can reduce eye strain in low-light environments and customize my visual preference.
```

**Story points:** 5 (multi-file frontend change, component-by-component theming, persistence,
new tests, accessibility audit needed)

**Claude CLI Implementation Steps (sample):**
```
Step 1: Create theme provider and context
- Create: `src/providers/ThemeProvider.tsx`
- How: React context with "light" | "dark" state, persisted to localStorage
- Pattern: Follow `src/providers/AuthProvider.tsx` structure

Step 2: Define CSS custom properties for both themes
- Create: `src/styles/themes.css`
- How: CSS custom properties (--color-bg-primary, --color-text-primary, etc.)
       Two classes: [data-theme="light"] and [data-theme="dark"]
- Watch out for: Hardcoded colors in existing components — search for hex codes

Step 3: Add toggle component
- Create: `src/components/ThemeToggle/ThemeToggle.tsx`
- Where to mount: `src/layouts/DashboardLayout.tsx` → header section, right side
- Accessibility: aria-label, keyboard operable, respects prefers-color-scheme
```

### Example C: Improvement — "Add Redis caching to slow API endpoints"

**Key sections generated:**

Current State:
> GET /api/products and GET /api/categories hit PostgreSQL on every request.
> Average response time: 780ms (p95: 1.2s). No caching layer exists.

Proposed State:
> Add Redis caching with 5-minute TTL for read-heavy endpoints.
> Target: <100ms for cache hits, <800ms for cache misses.

Migration:
> No breaking changes. Feature-flagged rollout via ENABLE_REDIS_CACHE env var.
> Rollback: set ENABLE_REDIS_CACHE=false, restart services.

---

## 4. Commit & PR Templates

### Conventional Commit Types

| Type | When to use |
|------|------------|
| `fix` | Bug fix |
| `feat` | New feature |
| `improve` or `refactor` | Improvement / refactor |
| `chore` | Task (build, CI, deps) |
| `docs` | Documentation only |
| `test` | Adding/fixing tests |
| `perf` | Performance improvement |

### Commit Message Examples

Bug:
```
fix(checkout): sanitize special characters in coupon codes

- Use parameterized queries for coupon validation
- Add input validation schema (alphanumeric + &%#-, max 50 chars)
- Add 6 unit tests for special character handling

Closes: PROJ-1234
```

Feature:
```
feat(dashboard): add dark mode toggle with theme persistence

- Create ThemeProvider with light/dark mode context
- Add CSS custom properties for both themes  
- Add ThemeToggle component in dashboard header
- Persist preference to localStorage, respect prefers-color-scheme
- Add WCAG AA contrast ratio compliance

Closes: PROJ-5678
```

Improvement:
```
perf(api): add Redis caching for product and category endpoints

- Add Redis cache layer with 5-minute TTL
- Cache GET /api/products and GET /api/categories responses
- Add cache invalidation on product/category mutations
- Feature-flagged via ENABLE_REDIS_CACHE env var
- Reduces p95 latency from 1.2s to <100ms for cache hits

Closes: PROJ-9012
```
