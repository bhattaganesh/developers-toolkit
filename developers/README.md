# Developers

Complete developer toolkit for WordPress and React developers — distributed as a single native Claude Code plugin.

**23 agents (20 standard + 3 expert-panel), 34 commands, 10 rules, 5 hooks, 14 skills — one install.**

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

## Agents (23)

### Review Agents (read-only — never modify files)

| Agent | What It Reviews |
|-------|----------------|
| `security-auditor` | SQL injection, XSS, missing auth, hardcoded secrets, CSRF gaps |
| `security-analyst` | Deep vulnerability analysis and threat modeling specialists |
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
| `dba` | Database schema design, query optimization, and migration planning |
| `css-expert` | Solves complex CSS/Tailwind layouts and responsive patterns |
| `ui-designer` | High-fidelity UI design and visual consistency |
| `ux-designer` | Interaction design and user journey mapping |

---

## Commands (34)

| Category | Commands |
|----------|----------|
| **Core** | `/pre-pr`, `/code-review`, `/security-check`, `/debug`, `/explain` |
| **Scaffolding** | `/scaffold-project`, `/new-component`, `/new-wp-feature` |
| **Testing** | `/write-tests`, `/test-gaps`, `/fix-tests` |
| **Quality** | `/a11y-check`, `/accessibility-audit`, `/ux-audit`, `/ux-review` |
| **Security** | `/security-fix`, `/modular-security-audit` |
| **Performance** | `/profile`, `/api-consistency`, `/impact-analysis` |
| **Ops** | `/commit-push-pr`, `/deploy-check`, `/changelog`, `/jira-issue` |
| **Architecture** | `/expert-panel`, `/refactor`, `/api-docs`, `/db-design` |
| **Docs** | `/wiki-docs`, `/wp-org-submission` |

---

## Rules (10)

Coding standards that auto-apply based on file globs.

| Rule | Covers |
|------|--------|
| `wordpress.md` | Security (sanitize/escape/nonce), plugin standards, hooks |
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

## Hooks (5)

### PostToolUse (auto-run after file edits)

| Trigger | Action |
|---------|--------|
| Edit `.php` file | `php -l` syntax check + PHPStan analysis (if installed) |
| Edit `.js/.jsx/.ts/.tsx` file | `npx eslint --fix` |
| Edit `.css/.scss` file | `npx prettier --write` |
| Edit migration file | `php -l` syntax check |
| Edit `app/**/*.php` | Suggests related test file if it exists |

### PreToolUse (blocks dangerous commands)

| Trigger | Action |
|---------|--------|
| Destructive command | Blocks `wp db reset`, `wp db drop`, `rm -rf`, `DROP TABLE`, `drop database`, `--force` |
| Committing .env | Blocks `git add .env` (allows `.env.example`) |

### Stop (auto-run after Claude responds)

| Trigger | Action |
|---------|--------|
| Claude finishes responding | Auto-detects and runs test suite (PHPUnit, Pest, Jest, Vitest, or npm test) |

---

## Skills (14)

### Context Skills (auto-activate based on files you're editing)

| Skill | Auto-activates When |
|-------|-------------------|
| `rules` | User mentions "coding standards" or "project standards" |
| `react-context` | Editing `.jsx`, `.tsx` files or `components/`, `pages/`, `hooks/` |
| `wordpress-context` | Editing WordPress plugin/theme files |
| `testing-context` | Editing files in `tests/` or `*Test.php`, `*.test.js`, `*.spec.tsx` |

### Workflow Skills (activate based on conversation context)

| Skill | Use When |
|-------|----------|
| `security-fix` | Fixing CVEs, bug bounty reports, security audit findings |
| `modular-security-audit` | Pre-release audits, security reviews, WordPress.org submission prep |
| `accessibility-audit` | WCAG 2.2 compliance audits, accessibility reviews |
| `chrome-debug` | Browser debugging with Chrome DevTools |
| `dev-docs` | Generating documentation for codebases |
| `ux-reviewer` | UX review and usability analysis |

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
├── agents/                        # 23 agents
│   ├── security-auditor.md
│   ├── security-analyst.md
│   ├── php-reviewer.md
│   ├── wp-reviewer.md
│   ├── react-reviewer.md
│   ├── test-critic.md
│   ├── perf-analyzer.md
│   ├── debug-agent.md
│   ├── design-patterns-reviewer.md
│   ├── code-profiler.md
│   ├── impact-analyzer.md
│   ├── a11y-checker.md
│   ├── api-consistency.md
│   ├── architect.md
│   ├── senior-engineer.md
│   ├── frontend-developer.md
│   ├── frontend-designer.md
│   ├── css-expert.md
│   ├── ui-designer.md
│   ├── ux-auditor.md
│   ├── ux-designer.md
│   ├── dba.md
│   └── wp-developer.md
├── commands/                      # 34 commands (partial list)
│   ├── pre-pr.md
│   ├── code-review.md
│   ├── security-check.md
│   ├── debug.md
│   ├── explain.md
│   ├── expert-panel.md
│   ├── scaffold-project.md
│   ├── new-component.md
│   ├── new-wp-feature.md
│   ├── write-tests.md
│   ├── test-gaps.md
│   ├── fix-tests.md
│   ├── modular-security-audit.md
│   ├── chrome-debug.md
│   └── wiki-docs.md
├── rules/                         # 10 rules
│   ├── wordpress.md
│   ├── react.md
│   ├── security.md
│   ├── testing.md
│   ├── api-design.md
│   ├── design-patterns.md
│   ├── code-profiling.md
│   ├── error-handling.md
│   ├── env-validation.md
│   └── git-workflow.md
├── hooks/hooks.json               # 5 hooks
├── skills/                        # 14 skills
│   ├── wordpress-context/
│   ├── react-context/
│   ├── testing-context/
│   ├── security-fix/
│   ├── modular-security-audit/
│   ├── accessibility-audit/
│   ├── expert-panel/
│   ├── chrome-debug/
│   ├── wiki-docs/
│   └── ux-reviewer/
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

