# Developers

Complete developer toolkit for WordPress and React developers — distributed as a single native Claude Code plugin.

**10 super-agents, 39 commands, 13 rules, 7 hooks, 21 skills — one install.**

---

## Quick Start

```bash
# Add marketplace (one-time)
/plugin marketplace add bhattaganesh/developers-toolkit

# Install everything with one command
/plugin install developers
```

When installing, choose a scope:

| Scope | Where | Use Case |
|-------|-------|----------|
| **project** | `.claude/settings.json` | Shared across projects (committed to git) |
| **user** | `~/.claude/settings.json` | Personal, across all your projects |
| **local** | `.claude/settings.local.json` | This project only, gitignored |

**Recommendation:** Install at **project** scope so all your projects get the same tools.

---

## Agents (25)

### Review Agents (read-only — never modify files)

| Agent | What It Reviews |
|-------|----------------|
| `security-auditor` | SQL injection, XSS, missing auth, hardcoded secrets, CSRF gaps |
| `security-analyst` | Threat modeling, GDPR compliance, audit logging, defense-in-depth architecture |
| `php-reviewer` | PHP code standards, type hints, and platform-specific patterns |
| `wp-reviewer` | WordPress standards: sanitize/escape, nonces, capabilities, $wpdb |
| `react-reviewer` | Component architecture, hooks rules, NextJS, and Tailwind conventions |
| `test-critic` | Missing feature tests, untested validation, and coverage gaps |
| `perf-analyzer` | N+1 queries, bundle size, missing indexes, and lazy loading |
| `debug-agent` | Systematic root cause analysis with structured methodology |
| `design-patterns-reviewer` | Pattern misuse, missing patterns, and anti-patterns |
| `code-profiler` | Performance profiling plan and bottleneck identification |
| `impact-analyzer` | Traces usages of files/methods to identify what breaks before changes |
| `a11y-checker` | WCAG violations: semantic HTML, ARIA, forms, and keyboard nav |
| `api-consistency` | API consistency: REST conventions, status codes, and response formats |
| `ux-auditor` | Audits usability, flow, and UI consistency |

### Developer Agents (build and modify code)

| Agent | What It Does |
|-------|-------------|
| `senior-engineer` | Architectural planning and high-level technical leadership |
| `architect` | System design and multi-component architecture planning |
| `frontend-developer` | Writes React/NextJS components, hooks, and state management |
| `frontend-designer` | Designs and builds polished, responsive UI with Tailwind CSS |
| `wp-developer` | Writes WordPress plugin/theme code: CPTs, REST, admin pages |
| `wp-block-developer` | Builds Gutenberg blocks: block.json, edit/save, dynamic render, deprecations |
| `wp-interactivity-developer` | Builds Interactivity API features: store, data-wp-* directives, SSR init |
| `dba` | Database schema design, query optimization, and migration planning |
| `css-expert` | Solves complex CSS/Tailwind layouts and responsive patterns |
| `ui-designer` | High-fidelity UI design and visual consistency |
| `ux-designer` | Interaction design and user journey mapping |

---

## Commands (36)

| Category | Commands |
|----------|----------|
| **Core** | `/pre-pr`, `/code-review`, `/security-scan`, `/debug`, `/explain` |
| **Scaffolding** | `/claude-code-setup`, `/new-component`, `/wp-new-feature`, `/wp-build-block` |
| **Testing** | `/write-tests`, `/test-gaps`, `/fix-tests` |
| **Quality** | `/a11y-check`, `/accessibility-audit`, `/ux-audit`, `/ux-review` |
| **Security** | `/security-fix`, `/modular-security-audit` |
| **Performance** | `/profile`, `/api-consistency`, `/impact-analysis` |
| **Ops** | `/commit-push-pr`, `/deploy-check`, `/changelog`, `/jira-issue` |
| **Architecture** | `/expert-panel`, `/refactor`, `/api-docs`, `/db-design` |
| **WordPress** | `/wp-org-submission`, `/wp-playground-test` |
| **Docs** | `/wiki-docs` |

---

## Rules (11)

Coding standards that auto-apply based on file globs.

| Rule | Covers |
|------|--------|
| `wordpress.md` | Security (sanitize/escape/nonce), plugin standards, hooks |
| `block-editor.md` | Gutenberg block development, apiVersion 3, block.json standards |
| `react.md` | Component architecture, hooks, NextJS, Tailwind CSS |
| `security.md` | Secrets, input validation, output encoding, auth |
| `testing.md` | PHPUnit, Jest, test quality, coverage requirements |
| `api-design.md` | REST URL structure, HTTP methods, status codes, response format |
| `design-patterns.md` | Service, Strategy, Observer, Composition, anti-patterns |
| `error-handling.md` | Exception classes, error JSON format, WP_Error patterns |
| `code-profiling.md` | Performance targets, profiling checklists, recommended tools |
| `git-workflow.md` | Commit messages, branching, PR conventions, .gitignore |
| `env-validation.md` | Ensure env vars exist in .env.example, no env() in code |

---

## Hooks (7)

### SessionStart

| Trigger | Action |
|---------|--------|
| Session begins | Detects project stack (WordPress, React, Laravel, etc.) |

### PostToolUse (auto-run after file edits)

| Trigger | Action |
|---------|--------|
| Edit `.php` file | `php -l` syntax check |
| Edit `.php` file | `phpcs --standard=WordPress` coding standards check |
| Edit `.js/.jsx/.ts/.tsx` file | `npx eslint --fix` |
| Edit `.css/.scss` file | `npx prettier --write` |
| Edit any file | Suggests related test file |
| Edit `block.json` | Validates apiVersion, required fields, viewScriptModule usage |

---

## Skills (20)

### Context Skills (auto-activate based on files you're editing)

| Skill | Auto-activates When |
|-------|-------------------|
| `coding-standards` | User mentions "coding standards", "project standards", or "enforce rules" |
| `react-context` | Editing `.jsx`, `.tsx` files or `components/`, `pages/`, `hooks/` |
| `wordpress-context` | Editing WordPress plugin/theme files |
| `testing-context` | Editing files in `tests/` or `*Test.php`, `*.test.js`, `*.spec.tsx` |

### WordPress Skills

| Skill | Use When |
|-------|----------|
| `wp-project-triage` | Classifying an unknown WordPress project (plugin/theme/block theme/FSE) |
| `wp-block-development` | Creating or editing Gutenberg blocks |
| `wp-interactivity-api` | Adding interactivity with data-wp-* directives and store() |
| `wp-block-themes` | Building FSE themes: theme.json, templates, parts, patterns |
| `wp-wpcli-and-ops` | Running WP-CLI commands with safe backup/dry-run protocol |
| `wp-playground` | Spinning up a disposable WordPress environment for quick testing |
| `wp-org-submission` | Preparing a plugin for WordPress.org submission |

### Workflow Skills

| Skill | Use When |
|-------|----------|
| `git-automation` | Committing, pushing, and creating PRs with conventional commits |
| `security-fix` | Fixing CVEs, bug bounty reports, security audit findings |
| `modular-security-audit` | Pre-release audits, security reviews |
| `accessibility-audit` | WCAG 2.2 compliance audits |
| `chrome-debug` | Browser debugging with Chrome DevTools |
| `ux-reviewer` | UX review and usability analysis |
| `wiki-docs` | Generating documentation for codebases |
| `jira-issue-creator` | Creating structured Jira issues from bugs or feature requests |
| `expert-panel` | Multi-expert panel review: architecture, security, UX, performance |

---

## Templates

| Template | Purpose |
|----------|---------|
| `CLAUDE.md.template` | Starter CLAUDE.md for new projects — tech stack, commands, patterns, testing |
| `managed-settings.json` | Managed settings template for multi-project deployment |
| `hooks/` | Script-based hook templates (PHP lint, ESLint, block dangerous, run tests) |
| `github-actions/` | CI/CD templates (PR review with Claude, auto-fix on push) |
| `scripts/` | Automation scripts (code review, test generation, tech debt, nightly health) |

---

## Plugin Structure

```
developers/
├── .claude-plugin/plugin.json     # Plugin manifest
├── agents/                        # 10 super-agents
│   ├── wordpress-pro.md
│   ├── react-pro.md
│   ├── security-pro.md
│   ├── ux-pro.md
│   ├── architect-pro.md
│   ├── qa-pro.md
│   ├── data-pro.md
│   ├── vibe-pro.md
│   ├── perf-pro.md
│   └── php-core.md
├── commands/                      # 39 commands
│   ├── pre-pr.md
│   ├── code-review.md
│   ├── security-scan.md
│   ├── debug.md
│   ├── explain.md
│   ├── expert-panel.md
│   ├── claude-code-setup.md
│   ├── new-component.md
│   ├── wp-new-feature.md
│   ├── wp-build-block.md
│   ├── wp-playground-test.md
│   ├── write-tests.md
│   ├── test-gaps.md
│   ├── fix-tests.md
│   ├── modular-security-audit.md
│   ├── chrome-debug.md
│   └── wiki-docs.md
├── rules/                         # 11 rules
│   ├── wordpress.md
│   ├── block-editor.md
│   ├── react.md
│   ├── security.md
│   ├── testing.md
│   ├── api-design.md
│   ├── design-patterns.md
│   ├── code-profiling.md
│   ├── error-handling.md
│   ├── env-validation.md
│   └── git-workflow.md
├── hooks/hooks.json               # 7 hooks
├── skills/                        # 21 pro-skills
│   ├── wordpress-context/
│   ├── react-context/
│   ├── testing-context/
│   ├── coding-standards/
│   ├── wp-project-triage/
│   ├── wp-block-development/
│   ├── wp-interactivity-api/
│   ├── wp-block-themes/
│   ├── wp-wpcli-and-ops/
│   ├── wp-playground/
│   ├── wp-org-submission/
│   ├── git-automation/
│   ├── security-fix/
│   ├── modular-security-audit/
│   ├── accessibility-audit/
│   ├── expert-panel/
│   ├── chrome-debug/
│   ├── wiki-docs/
│   ├── ux-reviewer/
│   └── jira-issue-creator/
└── README.md
```

---

## Customization

The plugin provides the standard baseline. Projects customize on top:

```
Developers plugin (standard baseline)
  └── Project CLAUDE.md + .claude/rules/ (project-specific)
       └── .claude/settings.local.json (developer overrides)
```

- **Add project-specific rules:** Create `.claude/rules/my-project.md` in your repo
- **Override hooks:** Add entries in `.claude/settings.local.json` (gitignored)
- **Extend agents:** Add custom agents in `.claude/agents/` in your repo

---

## Updating

```bash
/plugin marketplace update developers
```

---

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT — See [LICENSE](../LICENSE)

