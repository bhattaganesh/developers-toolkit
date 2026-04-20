# Developers Plugin Playbook

> Organized by plugin feature. The toolkit uses a high-density **'Super-Agent' architecture** consisting of **10 specialized pro-agents** that consolidate 25+ domain expertise roles into token-optimized models.

## Install the Plugin

```bash
/plugin marketplace add bhattaganesh/developers-toolkit
/plugin install developers --scope project
```

---

# RECOMMENDED SETUP BEFORE YOU START

Complete these configurations once per project. Everything below ensures the plugin's hooks, skills, agents, and commands work at full capability.

---

## 1. CLAUDE.md — Project Context File

Create a `CLAUDE.md` at the project root. This is the single most important configuration — it tells Claude about your project so every response is context-aware.

The plugin provides a template at `developers/templates/CLAUDE.md.template`. Customize it for each project.

**What to include:**

```markdown
# Project Name

## Tech Stack
- Backend: WordPress 6.x
- Frontend: React 18, NextJS 14, Tailwind CSS
- Database: MySQL 8, Redis
- Auth: WP Auth / Bearer token

## Commands
- Dev server: `wp-env start` / `npm run dev`
- Tests: `./vendor/bin/phpunit` / `npx jest`
- Lint: `./vendor/bin/phpstan analyse` / `npx eslint .`
- Build: `npm run build`

## Project Structure
- `includes/` — Business logic / classes
- `assets/` — Frontend assets
- `tests/` — Test suite
- `classes/abilities/` — MCP ability classes (WordPress)

## Patterns We Follow
- Clean classes → separated logic
- Security checks for nonces/caps
- REST API Resources for response formatting
- Abstract_Ability pattern for WordPress abilities

## Gotchas
- Always run migrations before testing
- Redis required for queue and cache
- Exchange tokens have 30s TTL, one-time use
```

**Key rules for CLAUDE.md:**
- Keep it under 500 lines (loaded into every session)
- Be specific about YOUR patterns, not generic framework docs
- Include the commands Claude needs to run tests, lint, and build
- List gotchas that trip up new developers

---

## 2. `.claude/settings.json` — Permissions & Safety

Copy the plugin's recommended settings template to your project. This controls what Claude can and cannot run.

```bash
mkdir -p .claude
```

**Recommended configuration:**

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run lint:*)",
      "Bash(npm run test)",
      "Bash(npm run test *)",
      "Bash(npm run dev)",
      "Bash(npm run build)",
      "Bash(composer test)",
      "Bash(composer lint)",
      "Bash(./vendor/bin/phpunit)",
      "Bash(./vendor/bin/phpunit *)",
      "Bash(./vendor/bin/phpstan *)",
      "Bash(php -l *)",
      "Bash(npx eslint *)",
      "Bash(npx prettier *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git show *)",
      "Bash(git branch *)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Bash(rm -rf *)",
      "Bash(git push * --force)",
      "Bash(git add .env)"
    ]
  },
  "spinnerVerbs": {
    "mode": "append",
    "verbs": [
      "Analyzing patterns",
      "Reviewing architecture",
      "Running checks",
      "Scanning for issues",
      "Validating structure"
    ]
  }
}
```

**Why this matters:**
- `allow` — Lets Claude run lint, tests, and git commands without asking permission every time. Hooks depend on these being allowed.
- `deny` — Blocks reading `.env` files (secrets), destructive commands (`rm -rf`), force pushes, and committing `.env`. This is the safety net.
- `spinnerVerbs` — Customizes the loading indicator text while Claude works.

**Commit `.claude/settings.json`** to your repo so every project session gets the same permissions.

---

## 3. Tool Dependencies — What to Install

The plugin's hooks and commands call these tools. Install them so auto-linting, auto-testing, and static analysis work.

### Required (Core)

| Tool | Used By | Install |
|------|---------|---------|
| `php` CLI | PHP lint hook, PHPUnit | Comes with your PHP installation |
| `git` | All version control commands | Comes with macOS / `apt install git` |
| `jq` | Hook scripts (JSON parsing) | `brew install jq` / `apt install jq` |

### Recommended (Hooks & Commands)

| Tool | Used By | Install |
|------|---------|---------|
| PHPStan | PHP lint hook (static analysis) | `composer require --dev phpstan/phpstan` |
| ESLint | JS/TS lint hook | `npm install --save-dev eslint` |
| Prettier | CSS/SCSS formatting hook | `npm install --save-dev prettier` |
| PHPUnit | Test hooks, `/write-tests`, `/fix-tests` | `composer require --dev phpunit/phpunit` |
| Jest or Vitest | JS test runner (stop hook) | `npm install --save-dev jest` |

### Optional (Advanced Skills)

| Tool | Used By | Install |
|------|---------|---------|
| `gh` CLI | PR creation, GitHub issue automation | `brew install gh` / [cli.github.com](https://cli.github.com) |
| WP-CLI | Security audit skill (WordPress testing) | `brew install wp-cli` |
| Semgrep | Security audit (static analysis) | `brew install semgrep` |

# WordPress project
composer require --dev phpstan/phpstan phpunit/phpunit
npm install --save-dev eslint prettier jest

---

## 4. Hook Scripts — Copy to Project

The plugin ships hook logic in its configuration, but you can also copy standalone scripts for customization.

```bash
mkdir -p .claude/hooks
```

The hooks.json in the plugin defines 7 hooks that fire automatically:

| Hook | Event | What It Does |
|------|-------|--------------|
| `detect-stack.sh` | SessionStart | Auto-detects your tech stack on session start |
| PHP lint | PostToolUse (Write/Edit `.php`) | Runs `php -l` + PHPStan on every PHP file save |
| ESLint | PostToolUse (Write/Edit `.js/.ts`) | Runs `npx eslint --fix` on JS/TS saves |
| Prettier CSS | PostToolUse (Write/Edit `.css/.scss`) | Runs `npx prettier --write` on style saves |
| Suggest tests | PostToolUse (Write/Edit) | Suggests related test files after edits |
| Block dangerous | PreToolUse (Bash) | Blocks `rm -rf`, `DROP TABLE` |
| Block .env commit | PreToolUse (Bash) | Blocks `git add .env` |

These hooks work automatically once the plugin is installed. No manual setup needed — they read from the plugin's `hooks.json`.

---

## 5. Chrome DevTools Setup — For `chrome-debug` Skill

Required for the browser debugging skill (responsive testing, network debugging, Core Web Vitals profiling).

### Step 1: Install the Claude Chrome Extension

The `chrome-debug` skill uses the **Claude in Chrome** MCP tools. Make sure:
- Chrome or Chromium browser is installed
- The Claude in Chrome extension is installed and connected
- The MCP tools (`mcp__claude-in-chrome__*`) are available in your Claude Code session

### Step 2: Verify Connection

At the start of any browser debugging session, the skill calls `tabs_context_mcp` to check browser tabs. If it can't connect, verify:
- Chrome is running
- The extension is active
- No other process is using the debugging port

### When You Need This

- Debugging CORS errors in iframes
- Responsive testing across breakpoints (375px, 768px, 1920px)
- Network request inspection (headers, status codes)
- Core Web Vitals profiling (CLS, LCP, FID)
- Console error investigation
- Form validation testing

---

## 6. MCP Server Configuration

If you use managed settings for centralized deployment, configure allowed MCP servers:

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverName": "git" },
    { "serverName": "brave-search" },
    { "serverName": "memory" }
  ],
  "deniedMcpServers": [
    { "serverName": "filesystem" }
  ]
}
```

**Why deny `filesystem`?** Claude Code has built-in Read/Write/Edit/Glob/Grep tools that are safer and more controlled than a raw filesystem MCP server.

---

## 7. GitHub Actions — CI/CD Integration

Set up automated PR reviews and auto-fixes in your repository.

### Step 1: Add API Key

```bash
gh secret set ANTHROPIC_API_KEY --body "sk-ant-..."
```

### Step 2: Copy Workflow Files

```bash
mkdir -p .github/workflows
```

The plugin provides two workflow templates:

| Workflow | Trigger | What It Does | Cost |
|----------|---------|-------------|------|
| `claude-review.yml` | PR opened/updated | Reviews changed files, posts findings as PR comment | ~$0.05-0.30/PR |
| `claude-fix.yml` | Push to develop/dev | Auto-fixes lint, formatting, type errors, commits fixes | ~$0.10-1.00/push |

Both use the `haiku` model with budget caps to control costs.

### Step 3: Customize

- Adjust `--max-budget-usd` for your budget tolerance
- Change trigger branches in the `on:` section
- Modify the review prompt for your team's standards

---

## 8. Automation Scripts — Scheduled Scans

For recurring code health tasks (weekly tech debt, nightly security).

```bash
mkdir -p scripts
```

| Script | Schedule | What It Does | Cost |
|--------|----------|-------------|------|
| `review.sh` | Per PR | Reviews changed files vs base branch | ~$0.05-0.30/file |
| `generate-tests.sh` | On demand | Generates missing tests for controllers | ~$0.50-1.50/controller |
| `techdebt.sh` | Weekly (Monday 6am) | Finds duplicated code, dead code, TODOs | ~$0.30-1.00/scan |
| `nightly-health.sh` | Nightly (midnight) | Security + coverage gaps + tech debt | ~$1.00-3.00/run |

**Cron setup example:**

```bash
# Weekly tech debt (Mondays 6am)
0 6 * * 1 cd /path/to/project && ./scripts/techdebt.sh app/ >> /var/log/techdebt.log 2>&1

# Nightly health check
0 0 * * * cd /path/to/project && ./scripts/nightly-health.sh >> /var/log/health.log 2>&1
```

**Required env var:** `ANTHROPIC_API_KEY`

---

## 9. Managed Settings — Enterprise / Team-Wide Enforcement

For organizations that want to enforce policies across all developers. Deploy to the system-level path:

| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Linux | `/etc/claude-code/managed-settings.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-settings.json` |

Key enterprise features:
- **`strictKnownMarketplaces`** — Lock the plugin source to your approved repo
- **`allowManagedPermissionRulesOnly`** — Prevent developers from overriding deny rules
- **`disableBypassPermissionsMode`** — Block the "bypass permissions" mode
- **`companyAnnouncements`** — Show reminders like "Run `/developers:code-review` before submitting PRs"
- **`availableModels`** — Restrict which models developers can use (cost control)

---

## 10. Configuration Hierarchy

Understand how settings layer on top of each other:

```
Managed Settings (system-level, enforced centrally)
  └── Plugin defaults (developers rules, hooks, agents)
       └── Project CLAUDE.md + .claude/settings.json (committed, project-wide)
            └── .claude/settings.local.json (gitignored, personal overrides)
```

- **Managed settings** — Cannot be overridden by developers
- **Plugin defaults** — Active when plugin is installed
- **Project settings** — Committed to repo, shared across sessions
- **Local settings** — Personal preferences, not committed

---

## 11. Pre-Flight Checklist

Run through this before your first session with the developers plugin:

- [ ] **Plugin installed** — `/plugin install developers --scope project`
- [ ] **CLAUDE.md created** — Project root, with stack, commands, patterns, gotchas
- [ ] **`.claude/settings.json` configured** — Permissions allow/deny set
- [ ] **PHP CLI available** — `php -v` returns a version
- [ ] **PHPStan installed** — `./vendor/bin/phpstan --version` (for PHP lint hook)
- [ ] **ESLint installed** — `npx eslint --version` (for JS/TS lint hook)
- [ ] **Prettier installed** — `npx prettier --version` (for CSS formatting hook)
- [ ] **Test runner works** — `./vendor/bin/phpunit` or `npx jest` runs successfully
- [ ] **jq installed** — `jq --version` (for hook scripts)
- [ ] **gh CLI authenticated** — `gh auth status` (for PR commands and security audit GitHub issues)
- [ ] **Chrome extension connected** — Only if using `chrome-debug` skill
- [ ] **`.env` in `.gitignore`** — Verify secrets won't be committed
- [ ] **GitHub Actions secret set** — `ANTHROPIC_API_KEY` (only if using CI/CD workflows)

---

# COMMANDS (36 Slash Commands)

Slash commands are one-step workflows that orchestrate complex multi-step tasks. They combine agents, tools, and rules into repeatable processes any developer can run consistently.

---

## `/developers:code-review`

**What's special:** Instead of one generalist review, you get 2nd domain experts running in parallel -- a WordPress security specialist and a React patterns checker working at the same time.

### Example 1: WordPress Plugin Review

**Problem:** Developer finishes a new MCP ability that creates WordPress users and needs a review before merging.

**Before:** Developer asks Claude to "review this file." Claude gives generic feedback. Misses that the ability doesn't validate the `role` parameter against a whitelist -- allowing anyone with a Bearer token to create administrator accounts. Misses that `$wpdb->query()` on line 45 lacks `$wpdb->prepare()`.

**After:** Running `/developers:code-review` spawns `wp-reviewer` + `security-auditor` in parallel. The `wp-reviewer` flags the missing role whitelist and suggests using `wp_roles()->get_names()` for validation. The `security-auditor` catches the SQL injection vector and rates it HIGH. Both findings come back in one report with exact file:line references and fix suggestions.

---

## `/developers:security-scan`

**Feature:** Focused security audit using the `security-auditor` agent on your changed files. Checks OWASP Top 10 patterns specific to your stack.

**What's special:** Stack-aware security scanning. In WordPress, it checks for missing nonces, unsanitized input, unescaped output, and `$wpdb->prepare()` gaps. It also verifies capability checks for all endpoints.

### Example: Quick Security Scan During Development

**Problem:** Developer modifies the REST API handler in `rest-api.php` to support a new authentication method and wants a quick security check before continuing.

**Before:** Developer asks Claude to "check if this is secure." Claude gives surface-level feedback like "looks fine" or "you should validate input" without specific findings.

**After:** `/developers:security-scan` runs the `security-auditor` on the diff. It finds that the new auth method falls back to `wp_get_current_user()` without verifying the request origin, potentially allowing cross-site authenticated requests. Rates it HIGH with a specific fix: add nonce verification for session-based auth paths.

---

## `/developers:pre-pr`

**Feature:** Comprehensive pre-PR checklist that scans for debug artifacts, validates routes/migrations/tests, runs the test suite, and generates a PR description.

**What's special:** Catches the things developers forget under time pressure -- leftover `dd()` calls, routes without auth middleware, migrations without `down()` methods, new files without tests. Produces a go/no-go verdict.

**After:** `/developers:pre-pr` catches all three issues before the PR is even created. Reports: "2 debug artifacts found (error_log() at line 89, console.log at line 42), missing capability checks, 2 new methods without test coverage." Developer fixes everything. PR passes review on first attempt.

---

## `/developers:commit-push-pr`

**Feature:** One-step commit, push, and PR creation. Scans for debug artifacts, stages files safely (never .env), generates a conventional commit message matching your project's style, pushes, and creates a PR with summary and test plan.

**What's special:** Automates the entire "done with code, ship it" workflow. Blocks .env commits, detects and warns about debug leftovers, reads your git log to match commit prefix style (`fix:`, `feat:`, `chore:`), and generates a structured PR description from the diff.

### Example: Ship a Feature

**Problem:** Developer finishes adding a new ability to the WordPress plugin and wants to get it to PR quickly.

**Before:** Developer manually writes "updated code" as the commit message. Accidentally stages the `.env` file. PR description is empty. Reviewer has no context about what changed or how to test.

**After:** `/developers:commit-push-pr` scans the diff, detects it's a new feature, generates "feat: add site performance metrics ability with test coverage", skips .env, creates a PR with bullet-point summary of changes and a test plan with checkboxes.

---

## `/developers:wp-new-feature`

**Feature:** Scaffolds a complete WordPress plugin feature in one pass -- class structure, hooks registration, and REST API handlers.

**What's special:** It doesn't use generic boilerplates. It reads your actual codebase to match your class naming, hook registration style, and security patterns.

### Example: New Feature for Agent Memory

**Problem:** Product wants to add conversation memory to the AI assistant. Developer needs a new CPT and REST handlers.

**Before:** Developer asks Claude to "create a feature." Claude generates generic code. Developer spends 30 minutes adapting it to match the project's standards and security requirements.

**After:** `/developers:wp-new-feature` with feature name. The `wp-developer` agent reads existing classes to match the style, then generates: CPT registration, REST handler with proper permissions, and a feature test covering success/403/404.

---

## `/developers:new-component`

**Feature:** Creates a React/NextJS component that's responsive, accessible, and matches your project's existing patterns. Generates the component and its test file.

**What's special:** Produces components with proper ARIA attributes, responsive Tailwind classes, and follows the component architecture patterns already in your project. Reads existing components first to match style.

### Example: Memory Indicator Component

**Problem:** Frontend needs a component to show memory status in the ERA chat iframe.

**Before:** Developer asks Claude to create a component. Gets a functional component but without ARIA labels, no responsive behavior, and the Tailwind class naming doesn't match the rest of the project.

**After:** `/developers:new-component` with props definition. Creates a component matching the project's existing patterns, with ARIA attributes for screen readers, responsive breakpoints, and a test file covering render, interaction, loading, and error states.

---

## `/developers:explain`

**Feature:** Traces the full execution path of a file, class, or route. Produces an ASCII flow diagram showing every layer from entry point to response, listing all files involved.

**What's special:** Traces across layers -- from route to middleware to controller to service to model to events. Shows the complete picture, not just one file. Lists every file involved with its role.

**After:** `/developers:explain POST /wp-json/v1/agent/chat/stream` traces the complete path: REST Route → Auth check → Capability check → Controller handler → Logic service → DB queries. Shows every file, every decision point, every fallback. Full picture in 30 seconds.

---

## `/developers:debug`

**Feature:** Systematic debugging with structured root cause analysis. Follows a 5-step methodology: reproduce, isolate, root cause, fix, verify.

**What's special:** Doesn't guess. Follows a structured methodology that traces the execution path, compares working vs broken paths, and identifies the exact point of failure before suggesting a fix.

**After:** `/developers:debug` with the bug description. The `debug-agent` identifies two paths (direct API vs agent pipeline), reads the executor class, traces how it constructs the request, compares with the direct call format, finds the mismatch, proposes a one-line fix, and verifies. Five minutes.

---

## `/developers:write-tests` and `/developers:test-gaps` and `/developers:fix-tests`

**Feature:** Three commands covering the full testing lifecycle -- find missing coverage, generate tests, and fix broken tests.

**What's special:** `test-gaps` uses the `test-critic` agent to scan the entire codebase and prioritize by risk. `write-tests` generates tests following your project's existing patterns (factories, naming, assertions). `fix-tests` classifies failures by type (setup issue, assertion mismatch, missing mock) and applies minimal fixes.

**After:** `/developers:test-gaps` returns prioritized gaps: "CRITICAL: Security check missing in CPT registration. HIGH: REST handler has no capability check test." Then `/developers:write-tests includes/MyClass.php` generates a complete test file using factories.

**After:** `/developers:fix-tests` runs the suite, classifies failures: "3 setup issues (factory missing new field), 4 assertion mismatches." Applies minimal fixes. Reruns tests. All pass.

---

## `/developers:refactor`

**Feature:** Guided refactoring with safety checks at each step. Identifies refactoring type, reads all affected code and tests, performs the change, updates all references, and verifies tests pass.

**What's special:** Finds all callers and references via Grep before making changes. Updates import paths, namespaces, config files, and string references. Runs tests after to verify nothing broke. Makes refactoring safe.

**After:** `/developers:refactor` identifies it as a rename refactoring. Greps every reference across all files. Plans the rename sequence. Executes changes maintaining consistency. Updates hook registrations, parameters, and autoloader mappings. Runs tests to verify.

---

## `/developers:profile` and `/developers:deploy-check` and `/developers:changelog` and `/developers:api-docs`

**Feature:** Specialized workflow commands for performance profiling, deployment readiness, changelog generation, and API documentation.

**What's special:** Each command encapsulates expert knowledge into a repeatable process. `profile` creates a specific measurement plan with recommended tools. `deploy-check` catches missing env vars and pending migrations. `changelog` groups by commit prefix. `api-docs` generates from actual route files and Validations.

### Example 1: Performance Profiling

**Problem:** Tool registration takes 400ms per request because 235+ abilities load eagerly.

**Before:** Developer asks for optimization help. Gets generic suggestions. No measurement plan. No targeted analysis.

**After:** `/developers:profile` traces the bottleneck to `Abilities_Service_Provider::boot()`, identifies that `configure()` runs on every ability regardless of use, provides specific measurements to take, and recommends three optimizations in priority order with expected improvement percentages.

---

# AGENTS (25 Specialized Agents)

Agents are persistent AI personas with deep domain expertise. Unlike commands (which are workflows), agents are specialists you invoke for specific tasks. They maintain their expertise boundaries -- review agents never modify files, developer agents write code following project patterns.

---

## Review Agents (14 specialized agents)

**What's special:** Review agents are **read-only** -- they analyze code but never modify it. Each agent has deep expertise in one domain. You can run multiple review agents in parallel on the same code for comprehensive coverage.

### `security-auditor`

Checks: SQL injection, XSS, CSRF, missing auth, hardcoded secrets, vulnerability chains.

**Example:** Before a release, run the security-auditor on all files changed in the release branch. It traces data flow from user input to database query, identifies that a new ability in `classes/abilities/zipwp/options/update-option.php` allows updating ANY WordPress option without whitelist validation -- an attacker could change `admin_email` or `siteurl`. Before: generic "validate your input" advice. After: exact attack scenario with file:line and fix code.

### `impact-analyzer`

Traces all usages of a file, method, or database column to show what breaks before you change anything.

**Example:** Developer wants to modify a core service. Before: makes the change, hope nothing breaks. After: `impact-analyzer` shows all callers. Developer refactors safely.

### `perf-analyzer`

Checks for N+1 queries, bundle size issues, missing indexes, and lazy loading opportunities.

### `a11y-checker`

Finds WCAG violations in semantic HTML, ARIA usage, forms, keyboard navigation, and color contrast.

### `api-consistency`

Reviews API endpoints for REST conventions, response envelope consistency, and middleware patterns.

### `design-patterns-reviewer`

Identifies pattern misuse, missing patterns, and anti-patterns across all stacks.

---

## Developer Agents (12 code-writing specialists)

**What's special:** Developer agents write production code that matches your project's existing patterns. They read your codebase first, then generate code that fits seamlessly -- not generic scaffolding.

### `wp-developer`

Writes WordPress plugin code -- CPTs, REST endpoints, admin pages, Gutenberg blocks.

**Example:** Need a new feature. Before: developer asks Claude to create it, gets a class that doesn't match the project style. After: `wp-developer` reads the existing modules, matches the exact pattern, and uses proper security checks.

### `frontend-developer`

Writes React/NextJS components, custom hooks, API integration, and state management.

### `frontend-designer`

Designs and builds UI components with Tailwind CSS -- responsive, accessible, and polished.

### `css-expert`

Solves complex CSS/Tailwind challenges -- layouts, animations, responsive patterns, and cross-browser issues.

### `dba`

Database schema design, query optimization, indexing strategy, and planning.

---

# SKILLS (21 Deep-Workflow Skills)

Skills are comprehensive, multi-phase workflows with their own reference materials, templates, and examples. They activate automatically based on what you ask for. Skills are more thorough than commands -- they include decision trees, quality gates, error recovery, and structured deliverables.

---

## `modular-security-audit`

**Feature:** 5-phase security audit methodology with module-based analysis, expert validation panel, vulnerability chaining, and GitHub issue automation.

**What's special:** This is the most comprehensive feature in the plugin. It breaks a codebase into security modules, runs each through 5 phases (discovery → code review → threat modeling → expert validation → documentation), uses 4 AI expert personas for consensus validation (<5% false positive rate), detects vulnerability chains where two medium issues combine into a critical one, and outputs GitHub issues with PoC code and fix recommendations.

### Example 1: Full Plugin Security Audit

**Problem:** Management wants a security audit of a plugin before a major release.

**Before:** Developer asks Claude to "check for security issues." Claude reads a few files, finds some obvious problems, reports them without structure. Misses 80% of vulnerabilities.

**After:** The skill maps the plugin into security modules. For each module, it discovers entry points, reviews code for vulnerabilities, and validates findings with multi-expert personas. Creates GitHub issues for confirmed bugs.

---

## `chrome-debug`

**Feature:** 5-phase browser debugging workflow using Chrome DevTools -- visual verification, network debugging, performance profiling, form testing, and console investigation.

**What's special:** Programmatic browser testing through Chrome DevTools. Takes screenshots at multiple breakpoints, captures network requests with full headers, measures Core Web Vitals, tests keyboard navigation, and generates cURL reproduction commands for failing requests. All evidence is saved as artifacts.

### Example 1: Debugging Browser Errors

**Problem:** After deployment, a feature stops working. Browser shows errors but the developer can't identify the cause.

**After:** The `chrome-debug` skill connects to the browser, lists all network requests, captures headers, and pinpoints the root cause. Saves screenshots as evidence.

### Example 2: Responsive Testing After UI Changes

**Problem:** Developer modified the chat iframe layout and needs to verify it works across mobile, tablet, and desktop.

**Before:** Developer manually resizes the browser window to a few widths. Misses that the chat input overlaps the send button at 375px.

**After:** The skill tests at 375px (iPhone SE), 768px (iPad), and 1920px (desktop). Takes screenshots at each breakpoint. Measures CLS (Cumulative Layout Shift) to detect layout instability. Catches the overlap issue at 375px with a screenshot as evidence.

---

## `security-fix`

**Feature:** Structured workflow for fixing security vulnerabilities with defense-in-depth thinking, regression tests, and security advisory generation.

**What's special:** Doesn't just patch the immediate issue. Analyzes the vulnerability in context, checks for similar patterns elsewhere, applies defense-in-depth (multiple layers of protection), generates regression tests that specifically test the attack vector, and creates a security advisory template for disclosure.

### Example: Fixing Missing Nonce Verification

**Problem:** Security audit found that the REST API handler accepts session-based auth without nonce verification, enabling CSRF attacks.

**Before:** Developer adds a nonce check. Done. Doesn't check if other handlers have the same issue. Doesn't write a regression test. The same vulnerability pattern exists in 3 other handlers.

**After:** The skill fixes the immediate issue, then greps for the same pattern across all handlers. Finds 3 more instances. Applies nonce verification to all 4. Generates regression tests that specifically craft CSRF payloads to verify the fix works. Creates a security advisory template with timeline, affected versions, and remediation steps.

---

## `accessibility-audit`

**Feature:** WCAG 2.2 AA compliance audit with findings report, GitHub issue automation, and fix templates.

**What's special:** Checks semantic HTML, ARIA patterns, keyboard navigation, color contrast, and form accessibility. Creates actionable GitHub issues for each violation with specific fix code. Includes a master tracking issue for overall progress.

### Example: Auditing the Plugin Settings Page

**Problem:** The zipwp-mcp settings page in WordPress admin needs to be accessible for users with disabilities.

**Before:** Developer asks Claude if the page is accessible. Gets generic advice about adding alt text and ARIA labels.

**After:** The skill checks WCAG 2.2 criteria systematically: finds that the settings form has no `<label>` elements associated with inputs (1.3.1 failure), the save button lacks focus indicator (2.4.7 failure), and error messages aren't announced to screen readers (4.1.3 failure). Creates GitHub issues for each with exact HTML fixes.

---

## `dev-docs`

**Feature:** Generates developer documentation by scanning the codebase -- architecture overview, codebase map, extension guides.

**What's special:** Reads the actual code to generate documentation, not just templates. Produces architecture diagrams from real file relationships, maps files to their purpose, and documents extension points based on actual interfaces and hooks.

### Example: Onboarding Documentation

**Problem:** New developers take two weeks to understand the plugin architecture.

**After:** The skill scans the codebase, documents the architecture, explains execution modes with diagrams, and creates a step-by-step guide for common tasks.

---

## Context Skills (`react-context`, `wordpress-context`, `testing-context`)

**Feature:** Auto-activating context skills that load framework-specific knowledge when Claude detects you're working in that stack.

**What's special:** These activate automatically -- no command needed. When you're in a React project, `react-context` loads. When you're in WordPress, `wordpress-context` loads. They provide framework-specific patterns, anti-patterns, and best practices that improve every response Claude gives.

### Example: Automatic WordPress Awareness

**Problem:** Developer asks Claude to write a database query in the WordPress plugin.

**After:** With `wordpress-context` active, Claude automatically uses `$wpdb->prepare()`, follows WordPress database API conventions, and uses proper table prefix handling.

---

# HOOKS (7 Automatic Protections)

Hooks run automatically in response to events -- file edits, command execution, session start, session end. No developer action needed. They enforce quality and safety silently.

---

## PostToolUse Hooks (Auto-Lint on Save)

**Feature:** Every time Claude edits or creates a PHP, JS, or CSS file, the corresponding linter runs automatically. PHP files get `php -l` + PHPStan. JS files get ESLint. CSS files get Prettier.

**What's special:** Catches syntax errors and type violations the moment they're introduced, not hours later in CI. Also includes a `suggest-tests.sh` hook that reminds which test files might need updating when you change a source file.

### Example: Catching a Type Error Immediately

**Problem:** Claude writes a new method that returns `string|null` but the caller expects `string`.

**Before:** The error isn't caught until CI runs 10 minutes later, or worse, until production when the null case is hit.

**After:** PHPStan runs immediately after the file is saved. The developer sees "PHPStan: Method return type (string|null) does not match expected type (string) at line 45" in the same Claude session, before any commit happens.

---

## PreToolUse Hooks (Destructive Command Blocker)

**Feature:** Blocks dangerous commands before they execute: `rm -rf`, `wp db reset`, `DROP TABLE`, `git add .env`.

**What's special:** Acts as a safety net against accidental destruction. If Claude or the developer tries to run any destructive command, it's blocked with an explanation. Separate hook specifically prevents `.env` files from being committed.

### Example 1: Blocking Accidental Database Wipe

**Problem:** Developer asks Claude to "reset the database" during debugging. Claude runs `wp db reset` which drops all tables.

**Before:** All data in the development database is gone. Developer spends 30 minutes re-seeding and recreating test data.

**After:** The hook intercepts `wp db reset` before it executes. Claude sees the block and suggests safe database commands or asks the developer to confirm if they really want a full reset.

### Example 2: Preventing .env Commit

**Problem:** Developer stages all files with `git add -A` and the `.env` file (containing API keys, database passwords) gets included.

**Before:** `.env` with production secrets gets committed and pushed. Secret rotation required. Security incident.

**After:** The hook pattern `git add.*\.env[^.]` blocks the command. Claude warns: "Blocked: .env file should not be committed. Use .env.example for template variables."

---

## Stop Hook (Auto-Run Tests)

**Feature:** When Claude finishes responding, `run-tests.sh` automatically runs the relevant test suite.

**What's special:** Every change Claude makes is automatically verified by tests. If a test breaks, the developer sees it immediately in the same session -- not 10 minutes later in CI.

### Example: Catching Regressions Immediately

**Problem:** Claude refactors a service method. The refactoring is logically correct but breaks a test that was asserting on the old response format.

**Before:** Developer doesn't run tests manually. Pushes. CI fails. Has to context-switch back to fix it.

**After:** Tests auto-run when Claude finishes. The failing test appears immediately: "test_consume_returns_remaining_balance FAILED: Expected array key 'remaining', got 'balance'." Claude can fix it in the same session.

---

# RULES (12 Always-Active Coding Standards)

Rules are loaded into every Claude session automatically. They define coding standards, patterns, and constraints that Claude follows in every response without being asked.

---

## `wordpress.md` + `react.md`

**Feature:** Stack-specific coding standards that Claude follows automatically. WordPress rules enforce sanitize/escape/nonce patterns. React rules enforce hook rules and component architecture.

**What's special:** Every developer on the team gets the same quality standards enforced automatically. No need to remember or manually enforce conventions. New team members get the same guardrails as senior developers.

### Example 1: Automatic WordPress Security Patterns

**Problem:** Developer asks Claude to write a form handler in the WordPress plugin.

**Before:** Claude writes `$_POST['name']` directly into a database query without sanitization or nonce verification. Works but is insecure.

**After:** With `wordpress.md` rule active, Claude automatically uses `sanitize_text_field()` on input, `wp_verify_nonce()` for CSRF protection, `$wpdb->prepare()` for queries, and `esc_html()` on output. The developer doesn't ask for this -- it happens by default.

### Example 2: Automatic Design Patterns Enforcement

**Problem:** Developer asks Claude to add a core feature to the plugin.

**After:** With `design-patterns.md` rule active, Claude creates a Clean architecture that delegates to a service, uses proper validation, returns a consistent response format, and follows PSR naming conventions. The architectural pattern is enforced without the developer specifying it.

---

## `security.md` + `api-design.md` + `database-migrations.md` + `git-workflow.md`

**Feature:** Cross-cutting standards for security, API design, database safety, and git conventions.

**What's special:** `security.md` ensures secrets never appear in code and inputs are always validated. `api-design.md` enforces REST conventions and response envelope format. `database-migrations.md` requires rollback support and safe migration patterns. `git-workflow.md` enforces commit message conventions and branching strategy.

### Example: Safe Migration by Default

**Problem:** Developer asks Claude to add a column to a table.

**Before:** Claude creates a migration without a `down()` method. Uses `->change()` on a large table without considering locking.

**After:** With `database-migrations.md` rule active, Claude always includes `down()` with proper rollback, flags that the table has many rows and suggests using `ALGORITHM=INPLACE`, and names the migration following the project's convention.

---

# MULTI-AGENT TEAMS

**Feature:** Spawn multiple specialized agents working in parallel on a large feature, coordinated through a shared task list.

**What's special:** Instead of one agent doing everything sequentially, you get 4+ specialists working simultaneously. A `backend-developer` builds the API while a `wp-developer` builds the WordPress abilities and a `frontend-developer` builds the UI -- all at the same time. They coordinate through task dependencies.

### Example: Building a Full Feature Across the Codebase

**Problem:** Team needs to add a new complex component. This requires backend endpoints, WordPress abilities, and frontend UI changes.

**Before:** Developer works with Claude sequentially: first the schema, then the data layer, then switch to WordPress, then the UI. Takes a full day.

**After:** Developer spawns a team:
- `senior-engineer`: Plans the architecture
- `wp-developer`: Creates the WordPress integration
- `frontend-developer`: Creates UI components with Tailwind
- `dba`: Designs the schema and migration

Four agents work simultaneously. Each follows the project's rules automatically (loaded by the plugin). Everything connects because all agents share the same coding standards.

---

---

# QUICK REFERENCE

| Feature Type | Count | Runs |
|-------------|-------|------|
| Commands | 39 | When you type the slash command |
| Agents | 10 | 'Super-Agent' consolidated architecture |
| Skills | 21 | Auto-activate or when triggered |
| Hooks | 7 | Automatically on events |
| Rules | 13 | Always active in every session |

---

*Plugin: [developers-toolkit](https://github.com/bhattaganesh/developers-toolkit)*
*Projects: ZipWP MCP (WordPress) + React Apps*

