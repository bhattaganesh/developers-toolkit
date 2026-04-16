# Developers Toolkit

**A complete Claude Code plugin for WordPress and React developers**

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Plugin](https://img.shields.io/badge/Plugin-developers%20v1.0.0-blue.svg)](#developers-plugin-toolkit)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## What is This?

This repository is a **Claude Code plugin marketplace** containing the `developers` plugin — a complete toolkit for modern WordPress and React development.

---

## Quick Start

```bash
# Add this repo as a marketplace (one-time)
/plugin marketplace add bhattaganesh/developers-toolkit

# Install the complete developer toolkit
/plugin install developers
```

When installing, choose a scope:

| Scope | Where | Use Case |
|-------|-------|----------|
| **project** | `.claude/settings.json` | Shared across projects (committed to git) |
| **user** | `~/.claude/settings.json` | Personal, across all your projects |
| **local** | `.claude/settings.local.json` | This project only, gitignored |

### Updating

```bash
/plugin marketplace update developers
```

---

## Developers Plugin Toolkit

**One plugin, everything you need.** 23 agents, 34 commands, 10 rules, 5 hooks, 14 skills.

```bash
/plugin marketplace add bhattaganesh/developers-toolkit
/plugin install developers --scope project
```

### Agents (23)

**Review agents** (read-only — never modify files):

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

**Developer agents** (build and modify code):

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

### Commands (34)

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

### Rules (10)

| Standard | Covers |
|----------|--------|
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

### Hooks (5) & Skills (14)

**Hooks:** Auto-lint PHP / JS / CSS on save, stack detection on session start, and test suggestions after edits.

**Skills:** Context skills for React, WordPress, and testing. Plus workflow skills for security fixes, security audits, accessibility, Chrome debugging, wiki generation, and Jira automation.

[View Full Documentation](developers/README.md)

---

## Repository Structure

```
developers-toolkit/
├── .claude-plugin/
│   └── marketplace.json               # Plugin marketplace manifest
│
├── developers/                    # Single consolidated plugin
│   ├── .claude-plugin/plugin.json     # Plugin manifest
│   ├── agents/                        # 23 agents
│   ├── commands/                      # 34 commands
│   ├── rules/                         # 10 coding standards
│   ├── hooks/hooks.json               # 5 hooks
│   ├── skills/                        # 14 skills
│   ├── templates/                     # CLAUDE.md, hooks, CI/CD, scripts
│   └── README.md
│
├── docs/                              # Repository documentation
│   ├── skill-development-guide.md
│   └── installation.md
│
├── README.md                          # This file
├── CONTRIBUTING.md
├── CHANGELOG.md
└── LICENSE
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

## Contributing

We welcome contributions! Here's how:

### Adding New Agents/Commands/Rules
1. **Fork** this repository
2. **Add** your file to the appropriate directory in `developers/`
3. **Update** `plugin.json` — add path to the `agents` or `commands` array
4. **Submit** a pull request

### Adding New Skills
1. **Fork** this repository
2. **Create** a new skill directory with `SKILL.md`
3. **Follow** the [Skill Development Guide](docs/skill-development-guide.md)
4. **Submit** a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## Documentation

- **[Installation Guide](docs/installation.md)** - Detailed installation instructions
- **[Skill Development Guide](docs/skill-development-guide.md)** - How to create new skills
- **[Developers Guide](developers/README.md)** - Full plugin documentation
- **[CHANGELOG](CHANGELOG.md)** - Version history

---

## Roadmap

### Planned Skills
- [ ] **API Design Skill** - REST API design patterns and security
- [ ] **Performance Optimization Skill** - WordPress performance best practices
- [ ] **Database Migration Skill** - Safe database schema changes
- [ ] **Release Management Skill** - WordPress.org and SureCart release workflows
- [ ] **Testing Skill** - Unit, integration, and E2E test generation

Vote for skills or suggest new ones in [Issues](https://github.com/bhattaganesh/developers-toolkit/issues)!

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Maintained by open source contributors**

[GitHub](https://github.com/bhattaganesh/developers-toolkit) | [Issues](https://github.com/bhattaganesh/developers-toolkit/issues)
