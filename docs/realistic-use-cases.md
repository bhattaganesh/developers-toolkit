# Developers Plugin — Realistic Use Cases Guide

A sequential, prioritized guide for managing projects effectively using the `developers` plugin. Organized from project setup to advanced workflows.

> **Two-level design:** Some features help manage *this plugin repository* (markdown/JSON), while most are designed for *target projects* (WordPress plugins, React apps) where the plugin is installed.

---

## Phase 1: Project Setup (Priority: P0 — Do Once)

### 1.1 Install the Plugin

```bash
# Add marketplace (one-time)
/plugin marketplace add bhattaganesh/developers-toolkit

# Install — choose scope based on need
/plugin install developers --scope project   # shared across projects (committed to repo)
/plugin install developers --scope user       # personal, all projects
/plugin install developers --scope local      # this project only, gitignored
```

**When:** Once per machine (user scope) or once per project (project scope).

### 1.2 `/developers:scaffold-project` — Initialize Project Standards

**What:** Generates a `CLAUDE.md` + `.claude/settings.json` tailored to the detected stack (WordPress, React, or mixed).

**When:** The **very first thing** you do when starting work on any project. This sets up the foundation that makes every other command work better.

**Scenario:** You clone a new client repo. Run this command — it detects the stack (WordPress + React), generates a CLAUDE.md with the right commands, tech stack, and project structure. Every future Claude Code session in this project now has context.

---

## Phase 2: Building Features (Priority: P1 — Daily Use)

### 2.1 Auto-Activating Context Skills (Passive — Always Running)

These load **automatically** when you edit matching files. Zero invocation needed — they silently enhance Claude's understanding.

| Skill | Activates On | What You Get |
|-------|-------------|--------------|
| `wordpress-context` | WP plugin/theme files | WPCS standards, security patterns, and API conventions |
| `react-context` | `.jsx`, `.tsx`, `components/`, `hooks/` | Component architecture, hooks rules, Tailwind conventions |
| `wordpress-context` | WP plugin/theme files | WPCS reminders, nonce/capability checklist |
| `testing-context` | `tests/`, `*Test.php`, `*.test.tsx` | Assertion best practices, test quality guidelines |
| `rules` | On demand ("check coding standards") | Standard rules: WordPress, React, security, testing, API design, git, etc. |

**Priority:** Free. Works the moment the plugin is installed. No action needed.

### 2.2 `/developers:new-wp-feature` — Scaffold a WordPress Feature

**What:** Provide a feature name, get a complete module: class structure, hooks registration, and admin/REST logic.

**When:** Every time you need a new feature in a WordPress plugin.

**Scenario:**
> You: `/developers:new-wp-feature`
> Claude: "What feature?" → `CustomPostType` with `Book` name
> Result: Files created, following your project's existing patterns. Tests pass immediately.

**Saves:** 30-45 min of boilerplate per feature.

### 2.3 `/developers:new-component` — Scaffold a React Component

**What:** Reads existing component patterns (naming, Tailwind, state management) and creates a new component matching your style.

**When:** Every time you need a new UI component.

**Scenario:** You need a `TeamMemberCard` component. The command scans your project, sees you use TypeScript, Tailwind, and custom hooks for data fetching. It generates a component that fits seamlessly.

**Saves:** Consistency across components without manually copying patterns.

### 2.4 `/developers:explain` — Trace Execution Paths

**What:** Takes a route, file, or class name and produces an ASCII flow diagram showing the full request lifecycle plus a list of every file involved.

**When:**
- Joining a new project and need to understand a feature
- Before modifying a complex flow
- Debugging and need to see all the pieces

**Scenario:**
> You: `/developers:explain POST /api/credits/purchase`
> Result:
> ```
> Request → Route (api.php)
>   → AuthMiddleware
>   → CreditController@purchase
>     → PurchaseRequest (validation)
>     → CreditService@processPurchase
>       → User::find()
>       → CreditTransaction::create()
>       → PurchaseCompleted event
>     → CreditResource (response)
> ```

**Eliminates:** "Where does this even go?" questions.

---

## Phase 3: Safety Guardrails (Priority: P1 — Automatic)

### 3.1 PostToolUse Hooks (After You Edit Code)

| Hook | What It Catches |
|------|----------------|
| PHP Syntax Check | `php -l` immediately catches syntax errors in PHP files |
| ESLint Fix | Auto-fixes JS/TS/JSX/TSX lint issues after every edit |
| CSS Prettier | Auto-formats CSS/SCSS after every edit |
| Test Suggestion | Reminds you when a related test file exists for the code you edited |

### 3.2 PreToolUse Hooks (Before Commands Run)

| Hook | What It Blocks |
|------|---------------|
| Block Destructive Commands | Stops `wp db reset`, `wp db drop`, `rm -rf`, `DROP TABLE`, `--force` |
| Block .env Commits | Stops `git add .env` from ever happening |

### 3.3 Session Lifecycle Hooks

| Hook | What It Does |
|------|-------------|
| Stack Detection | Auto-detects project tech stack at session start |
| Run Tests | Runs test suite before session ends to catch regressions |

**Priority:** "Set and forget." Install the plugin and they protect you from day one. All hooks fail gracefully (`|| true`) if tools don't exist in the target project.

---

## Phase 4: Quality Assurance Before PRs (Priority: P2 — Every PR)

### 4.1 `/developers:pre-pr` — Pre-PR Checklist

**What:** Scans your branch diff for common mistakes:
- Leftover `error_log()`, `console.log`, `debugger`, `TODO`, `FIXME`
- Routes/Endpoints missing capability checks
- New files without corresponding tests
- Runs the test suite and reports pass/fail
- Generates a PR description

**When:** Run this **before every PR**. Non-negotiable.

**Scenario:** You've been coding for 3 hours. Before pushing, run `/developers:pre-pr`. It finds: a `console.log` on line 12 of `TeamCard.tsx`, your `GET /api/teams/{id}` route is public (no auth), and `TeamService.php` has no test file. You fix all three before the reviewer even sees the PR.

**Output:** Go/no-go checklist:
- [ ] No debug artifacts
- [ ] Proper security checks (nonces/caps)
- [ ] New files have tests
- [ ] Test suite passes

### 4.2 `/developers:code-review` — Multi-Agent Code Review

**What:** Spawns multiple specialized review agents **in parallel** based on your stack:
- `php-reviewer` → PHP coding standards
- `wp-reviewer` → WordPress coding standards
- `react-reviewer` → Component architecture, hooks
- `security-auditor` → Always runs on all code

Consolidates findings by severity: **Critical → High → Medium → Low**.

**When:** Before opening a PR, or as a self-review step on larger changes.

**Scenario:** You've refactored the payment flow touching PHP services, React components, and API routes. Three agents review simultaneously. The php-reviewer catches a missing type hint, the react-reviewer spots a missing `useCallback` dependency, and the security-auditor flags unsanitized user input.

### 4.3 `/developers:security-check` — Focused Security Audit

**What:** Runs the `security-auditor` agent specifically for OWASP top 10 vulnerabilities.

**When:** When making changes to auth, user input, file uploads, payment processing, or any sensitive area.

### 4.4 `/developers:test-gaps` — Find Missing Tests

**What:** Uses the `test-critic` agent to find untested code paths.

**When:** Periodically or before releasing a major feature.

**Scenario:** You've built 5 new endpoints. Run this — it tells you that `TeamInvitation` acceptance has no test covering the "expired invite" edge case, and `TeamService::removeUser()` has no test at all.

### 4.5 `/developers:write-tests` — Generate Tests

**What:** Generates tests for a class, component, or service following TDD patterns. Supports PHPUnit and Jest (React).

**When:** After `/developers:test-gaps` identifies missing coverage, or when building a new feature.

---

## Phase 5: Ship It (Priority: P2 — Every PR)

### 5.1 `/developers:commit-push-pr` — One-Step Delivery

**What:** Commits, pushes, and creates a GitHub PR in one command:
1. Scans for debug artifacts (warns if found)
2. Stages files (never stages `.env`)
3. Creates a conventional commit (`feat:`, `fix:`, etc.)
4. Pushes the branch
5. Creates a PR with summary + test plan
6. Returns the PR URL

**When:** After all quality checks pass.

**Scenario:**
> You: `/developers:commit-push-pr`
> Result: Commits as `feat: add team invitation flow`, pushes to `feat/team-invites`, creates PR with summary, test plan, and link.

---

## Phase 6: Debugging & Maintenance (Priority: P3 — As Needed)

### 6.1 `/developers:debug` — Structured Root Cause Analysis

**What:** Spawns the `debug-agent` with structured methodology:
1. Gather context (error, stack trace, recent changes)
2. Form 2-3 ranked hypotheses
3. Investigate with code evidence
4. Verify root cause with `file:line` references
5. Suggest minimal fix + regression test
6. **Does NOT auto-fix** — offers to fix after presenting findings

**When:** When a bug isn't immediately obvious from the error message.

**Scenario:** "The dashboard API returns 500 intermittently." The debug agent checks recent commits, finds a race condition in `CreditService::processExpiry()` where a soft-deleted record is still being queried. Reports root cause with file:line and offers the fix.

### 6.2 `/developers:fix-tests` — Diagnose Failing Tests

**What:** Runs the test suite, classifies each failure (broken assertion vs. missing mock vs. real bug), and suggests the minimal fix.

**When:** When tests break after a change and you're not sure if it's the code or the tests.

### 6.3 `/developers:refactor` — Safe Refactoring

**What:** Guided refactoring with safety checks at every step:
1. Classify type (extract, rename, move, split, convert pattern)
2. Read all callers and references first
3. Perform the refactoring
4. Update all imports, namespaces, configs
5. Run tests to verify

**When:** Any refactoring that touches more than one file.

**Scenario:** You want to rename a core service. The command finds all references across the project. Updates all references. Runs the test suite. Reports success.

### 6.4 `/developers:profile` — Performance Analysis

**What:** Uses the `code-profiler` and `perf-analyzer` agents to scan for performance anti-patterns, identify bottlenecks, and recommend tools/targets.

**When:** When an endpoint or page is slow, or for periodic performance reviews.

---

## Phase 7: Pre-Deployment (Priority: P4 — Every Release)

### 7.1 `/developers:deploy-check` — Deployment Readiness

**What:** Catches deployment surprises:
- New environment variables or constants
- New dependencies to install
- Breaking API changes

**When:** Before every deployment to staging/production.

**Scenario:** "Ready to deploy?" → "Warning: 1 migration drops the `legacy_credits` column (irreversible), 2 new env variables needed (`STRIPE_WEBHOOK_SECRET`, `REDIS_QUEUE_CONNECTION`), and the new `ProcessRefund` job needs a supervisor config."

### 7.2 `/developers:changelog` — Generate Changelog

**What:** Reads git log from last tag to HEAD, groups commits by conventional prefix, generates a formatted changelog entry.

**When:** Before releasing a new version.

**Output format:**
```markdown
## [2.5.0] - 2026-02-17

### Features
- Add team invitation flow (aa68a54)

### Bug Fixes
- Correct misleading instructions in README (f943907)
```

### 7.3 `/developers:api-docs` — Generate API Documentation

**What:** Generates API documentation from routes, REST controllers, and hooks.

**When:** Before releases or when API changes need documentation.

---

## Phase 8: Advanced / Specialized Workflows (Priority: P5-P6 — Situational)

### 8.1 Impact Analyzer Agent (Before Risky Changes)

**What:** The `impact-analyzer` agent traces all usages of a file, method, or database column to answer: **"What breaks if I change this?"**

**When:** Before renaming a public method, dropping a column, or changing a return type.

**Output:** Breaking changes, safe changes, test coverage gaps, dependency map with `file:line` references.

### 8.2 Security Fix Skill (On Vulnerability Reports)

**Trigger phrase:** "fix a security vulnerability", mention HackerOne, Patchstack, CVE.

**What:** Multi-phase workflow — risk assessment, reproduce, patch, verify fix, write tests, generate security advisory.

**When:** When you receive a vulnerability report from a bug bounty program or security scanner.

### 8.3 Modular Security Audit Skill (Quarterly)

**Trigger phrase:** "run a security audit" or "pentest this WordPress plugin."

**What:** Breaks the codebase into 6-12 modules, audits each through 5 phases, validates with multi-expert review, creates GitHub issues.

**When:** Quarterly security reviews or before major releases.

### 8.4 Accessibility Audit Skill

**Trigger phrase:** "audit accessibility" or "check WCAG compliance."

**What:** WCAG 2.2 Level AA compliance audit with beginner-friendly explanations and remediation plan.

**When:** Before major UI releases or to meet compliance requirements.

### 8.5 UX Reviewer Skill

**Trigger phrase:** "audit UX" or "review user experience."

**What:** Reviews usability, microcopy quality, navigation flow, and UI consistency.

**When:** Before major UI releases or to improve user experience.

### 8.6 Dev Docs Skill

**Trigger phrase:** "generate dev docs" or "create internal documentation."

**What:** Creates 13 internal documentation files covering architecture, API endpoints, hooks, filters, database schema, etc. Optimized for developer onboarding and AI agent understanding.

**When:** Once per project lifecycle, or after major architectural changes.

### 8.7 CI/CD Templates (For Automation)

Ready-to-use GitHub Actions at `developers/templates/github-actions/`:

| Template | What It Does |
|----------|-------------|
| `developers-review.yml` | Auto-runs Claude Code review on every PR (Haiku model, $1 budget cap) |
| `developers-fix.yml` | Auto-fix template for CI pipelines |

**When:** When you want automated AI code review on every PR without human invocation.

---

## Priority Summary — Quick Reference

| Priority | Phase | Command / Feature | Frequency |
|----------|-------|-------------------|-----------|
| **P0** | Setup | Install plugin (`/plugin install`) | Once |
| **P0** | Setup | `/developers:scaffold-project` | Once per project |
| **P1** | Build | Context skills (auto-activate) | Every session (automatic) |
| **P1** | Build | `/developers:new-wp-feature` | Per new feature |
| **P1** | Build | `/developers:new-component` | Per new UI component |
| **P1** | Understand | `/developers:explain` | When exploring unfamiliar code |
| **P1** | Safety | Hooks (auto-lint, auto-block) | Every edit (automatic) |
| **P2** | Quality | `/developers:pre-pr` | Every PR |
| **P2** | Quality | `/developers:code-review` | Every PR |
| **P2** | Quality | `/developers:write-tests` | Per new feature |
| **P2** | Ship | `/developers:commit-push-pr` | Every PR |
| **P3** | Debug | `/developers:debug` | When bugs arise |
| **P3** | Debug | `/developers:fix-tests` | When tests break |
| **P3** | Maintain | `/developers:refactor` | During refactoring sprints |
| **P3** | Maintain | `/developers:profile` | When performance degrades |
| **P4** | Release | `/developers:deploy-check` | Before each deployment |
| **P4** | Release | `/developers:changelog` | Before each release |
| **P4** | Release | `/developers:api-docs` | When API changes |
| **P5** | Audit | `/developers:security-check` | Security-sensitive changes |
| **P5** | Audit | `/developers:test-gaps` | Weekly / sprint review |
| **P6** | Advanced | Security fix / modular audit skills | Quarterly or on report |
| **P6** | Advanced | Accessibility / UX audit skills | Before major UI releases |
| **P6** | Advanced | Impact analyzer agent | Before risky refactors |
| **P6** | Advanced | Dev docs skill | Once per project lifecycle |
| **P6** | Advanced | CI/CD templates | Once per repo setup |

---

## Daily Workflow Summary

```
Morning:
  → Start coding (context skills auto-activate)
  → Hooks auto-lint your code as you write

Building:
  → /developers:new-wp-feature   (scaffold WP features)
  → /developers:new-component   (scaffold React components)
  → /developers:explain         (understand existing flows)

Stuck:
  → /developers:debug           (structured root cause analysis)
  → /developers:fix-tests       (diagnose test failures)

Ready for PR:
  → /developers:pre-pr          (quality gate — run first)
  → /developers:code-review     (multi-agent review)
  → /developers:commit-push-pr  (commit + push + PR in one step)

Before deploy:
  → /developers:deploy-check    (catch deployment surprises)
  → /developers:changelog       (generate release notes)
```

---

## Architecture Notes

- **Review agents (11)** are strictly read-only — they can never accidentally modify your code
- **Builder agents** have full tool access (Read, Write, Edit, Bash) for code generation
- **Context skills** are passive — they load based on file type and augment Claude's knowledge silently
- **Workflow skills** are active — triggered by natural language phrases
- **Hooks** act as a passive safety net — protection with zero effort after install
- **All hooks fail gracefully** (`|| true`) if tools don't exist in the target project

