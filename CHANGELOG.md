# Changelog

All notable changes to the Developers Toolkit will be documented in this file.

## [2.1.0] - 2026-04-20

### Added
- YAML frontmatter with `name`, `description`, and `tools:` declarations to all 10 pro agents (enables orchestrator tool pre-checking)
- `requirements:` field to `plugin.json` — lists `required` (`git`, `php`) and `optional` tools (`gh`, `wp`, `phpcs`, `phpstan`, `eslint`, `prettier`, `npm`, `python3`, `jq`)
- Expert panel skill decomposition: `modes/` (feature, review, bugfix, refactor, architecture) and `experts/debate-rules.md` — reduces per-request context load by 60-70%
- WordPress REST API glob patterns to `api-design.md` rule (covers `includes/**/*rest*.php`, `**/endpoints/**/*.php`, `src/**/*api*.ts`)

### Changed
- Expanded `vibe-pro` agent from 4 bullet points to production-grade spec (motion budget rules, token-first approach, 60fps constraints, WP enqueue guidance)
- Silenced hook success output in `php-lint.sh` and `eslint-check.sh` — now only emit warnings/errors, preventing output noise on clean files
- Expert panel `SKILL.md` refactored to lightweight router (~180 lines vs 957 lines) — mode-specific content lazy-loaded from `modes/*.md`

### Fixed
- CHANGELOG counts corrected to match actual plugin.json state: 10 super-agents, 39 commands, 13 rules, 7 hooks, 21 skills

## [2.0.0] - 2026-04-19

### Added
- **7 new WordPress skills:** `wp-project-triage`, `wp-block-development`, `wp-interactivity-api`, `wp-block-themes`, `wp-wpcli-and-ops`, `wp-playground`, `git-automation`
- **2 new agents:** `wp-block-developer` (Gutenberg block specialist), `wp-interactivity-developer` (Interactivity API specialist)
- **2 new commands:** `/wp-build-block` (scaffold complete block packages), `/wp-playground-test` (generate Playground launch commands)
- **2 new hook scripts:** `phpcs-check.sh` (WPCS validation), `block-json-validate.sh` (apiVersion and field validation)
- `block-editor.md` coding rule for Gutenberg block standards

### Changed
- Renamed `toolkit-rules/` skill directory → `coding-standards/` (clearer naming)
- Renamed `/security-check` command → `/security-scan` (implies read-only quick scan)
- Renamed `/new-wp-feature` command → `/wp-new-feature` (consistent `wp-` prefix)
- Standardized all skill trigger phrases to third-person format
- Updated `wordpress-context` skill with WP 6.9+ modern patterns section
- Updated `wp-developer` agent with detailed block development guidance
- Updated `plugin.json` to v2.0.0 with new agent, command, and keyword entries

### Removed
- `performance-optimizer` agent — redundant with `perf-analyzer` (same domain, less depth)

### Fixed
- All documentation updated to reflect accurate counts: 10 super-agents, 39 commands, 13 rules, 7 hooks, 21 skills

## [1.0.0] - Initial Release

- 24 specialized agents covering WordPress, React, security, performance, and accessibility
- 34 commands for code review, scaffolding, testing, debugging, and documentation
- 10 coding standard rules (WordPress, React, security, testing, API design, and more)
- 5 automated hooks for PHP/JS/CSS linting and stack detection
- 13 skills including context skills (WordPress, React, testing) and workflow skills (security-fix, accessibility-audit, chrome-debug, expert-panel, and more)
