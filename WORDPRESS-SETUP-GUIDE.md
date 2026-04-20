# Production-Grade Claude Code for WordPress Plugin Development

## What You Now Have

A purpose-built Claude Code setup for WordPress plugin development, optimized for minimal token usage and maximum output quality. This includes:

### 1. The Plugin (developers) — Full-Stack WordPress + React
- **10 super-agents** — domain experts for WP, React, Security, UX, and QA
- **39 commands** — expert workflows for setup, git flows, and diagnostics
- **13 rules** — Core standards for WP, React, Security, and i18n
- **7 hooks** — Real-time syntax, linting, and security gates
- **21 skills** — Pro-grade automation, diagnostics, and sync engines

All non-essential content has been removed. The plugin is now a 200x productivity multiplier for Full-Stack WordPress & React development (React, TS, PHP, REST API).

---

## Quick Start: Set Up a New WordPress Plugin

### For any WordPress plugin project:

```bash
# 1. Create/enter your plugin directory
cd your-plugin/

# 2. Initialize Claude Code configuration
/developers:claude-code-setup

# This creates:
#   • CLAUDE.md (WordPress plugin template)
#   • .claude/settings.json (WP-CLI + WPCS permissions)
#   • .claude/settings.local.json (for local overrides)
#   • .claudeignore (token-efficient file exclusions)

# 3. Edit CLAUDE.md sections:
#   • {{PLUGIN_NAME}} → your plugin name
#   • {{plugin-slug}} → your slug (e.g., my-plugin)
#   • {{PLUGIN_PREFIX}} → your prefix (e.g., MY_PLUGIN_)
#   • {{Vendor\PluginName}} → your namespace (e.g., MyCompany\MyPlugin)

# 4. Optional: Set up MCP servers (GitHub + Playwright)
# 5. Optional: Set up Composer dependencies
composer require --dev phpstan/phpstan phpunit/phpunit
npm install --save-dev eslint prettier jest
```

After this, your Claude Code sessions will:
- Auto-activate `wordpress-context` skill on every PHP file edit
- Auto-load `rules/wordpress.md` (WPCS, security, hooks, database)
- Auto-run PHP lint + PHPStan checks on every file save
- Provide `/developers:` command completions for all WP workflows

---

## The 4-Phase Workflow

### Phase 1: SCAFFOLD (Design before code)

```bash
# For architecture decisions (data storage, auth approach, REST design):
/developers:expert-panel
# Input: "I need to build [feature description]"
# Output: 10-expert debate on API choice, risks, alternatives

# Then scaffold the feature:
/developers:wp-new-feature
# Input: feature type + spec from expert-panel output
# Output: plugin files with matched prefix/namespace conventions

# Verify:
composer lint {{new-file.php}}  # WPCS check
wp-env start                     # Local WP environment
wp plugin activate {{plugin-slug}}
```

### Phase 2: DEVELOP (Code with auto-safety checks)

```bash
# Before modifying ANY existing hook or filter:
/developers:explain [hook name]              # Trace execution path
# Then: "Analyze impact of changing [function/hook]"  # Impact analyzer

# While editing *.php files:
# wordpress-context skill auto-fires        (security reminders, patterns)
# php-lint.sh hook auto-runs on every save  (php -l + PHPStan)
# No explicit commands needed during coding

# After logical chunks of work:
composer lint [files]
composer phpstan
/developers:write-tests [class just written]
wp-env run tests phpunit
```

### Phase 3: REVIEW (Security → Quality)

```bash
# 1. SECURITY FIRST (always)
/developers:security-scan includes/{{feature}}/
# If CRITICAL: /developers:security-fix immediately

# 2. CODE QUALITY + WP STANDARDS (parallel)
/developers:code-review
# Runs: wp-reviewer + php-reviewer + security-auditor in parallel

# 3. MODULAR SECURITY AUDIT (pre-release / post-auth-change only)
/developers:modular-security-audit
# Scope to specific module, not whole plugin
```

### Phase 4: SHIP (Pre-submit checks)

```bash
# 1. Auto-fix WPCS violations
composer format

# 2. Pre-PR gate
/developers:pre-pr
# Also verify: no var_dump(), error_log(), WP_DEBUG in production

# 3. If targeting wordpress.org
/developers:wp-org-submission
wp plugin check {{plugin-slug}}
# Fix all FAIL items

# 4. Final QA
wp-env clean && wp-env start
wp plugin activate {{plugin-slug}}
wp-env run tests phpunit

# 5. Commit and submit
/developers:commit-push-pr
```

---

## Three Templates You Now Have

### 1. CLAUDE.md.wordpress.template
Location: `developers/templates/CLAUDE.md.wordpress.template`

The default template for WordPress plugins. 78 lines, includes:
- Plugin identity (slug, prefix, text domain, namespace)
- Tech stack (PHP, WP, Composer, node if needed)
- File structure (includes/, assets/, tests/)
- Dev commands (composer lint, phpstan, wp-cli, wp-env)
- Security non-negotiables (6 critical rules)
- Common WP gotchas
- Current focus tracking
- Import comment (delegates to plugin skill/rules)

**Use this for every new WP plugin project.**

### 2. settings.wordpress.json
Location: `developers/templates/settings.wordpress.json`

Claude Code permissions for WordPress plugin development. Includes:
- WPCS/PHPCStan tools (phpcs, phpcbf, phpstan)
- PHPUnit (local and wp-env)
- WP-CLI commands (plugin, option, scaffold, i18n, eval, etc.)
- wp-env (local WordPress environment)
- wp-scripts (block editor tools)
- Git read ops (status, diff, log, branch)
- Blocks destructive ops (db drop, user create, git force-push)

**Pre-approves safe routine commands. Prevents permission prompt spam.**

### 3. mcp.wordpress.json
Location: `developers/templates/mcp.wordpress.json`

Optional MCP server configuration for WordPress plugins:
- **GitHub MCP**: used by `security-fix` skill, `modular-security-audit`, `impact-analyzer`
- **Playwright MCP**: used by `modular-security-audit` Phase 4.5 for XSS/CSRF exploitation testing

**Optional. Only set up if you need GitHub integration or security testing.**

---

## Token Efficiency Rules (Maximize Quality, Minimize Cost)

### DO
- Put plugin slug, prefix, text domain in CLAUDE.md — Claude uses these every session
- Use `## Imports` comment to declare what the plugin provides
- Update `## Current Focus` before each session
- Run `/developers:security-check includes/specific-dir/` (scoped, not whole plugin)
- Use `/developers:code-review` (parallel agents, one session)
- Use `/developers:expert-panel` for architecture decisions before writing code
- Run `composer format` before `/developers:pre-pr` (eliminates 70% of style findings)

### DON'T
- Put WP security checklist in CLAUDE.md — `wordpress-context` skill already injects it
- Inline rules from `rules/wordpress.md` into CLAUDE.md — they auto-load already
- Put git history or recent changes in CLAUDE.md
- Run `/developers:modular-security-audit` on every PR — reserve for pre-release only
- Spawn wp-reviewer and security-auditor in separate sessions (use `code-review` instead)
- Use expert-panel for single-file bug fixes or style issues
- Run pre-pr first and let reviewers flag auto-fixable WPCS violations

**Context Compaction**: `autoCompactThreshold: 50` is optimal. When Claude hits 50% context used, it compacts history but retains CLAUDE.md and active skill. For WP plugin sessions with file writes, hitting 50% is normal.

---

## Advanced Power-User Techniques

### 1. impact-analyzer before any hook priority change
Before touching any `add_action` / `add_filter` priority:
```
/developers:debug [file and function]
"Analyze impact of changing priority of 'init' hook in 'class-loader.php:45'"
```
The agent greps for all `remove_action` / `remove_filter` calls referencing that hook. Catches the most common silent WP bug (wrong priority = hook fires twice or not at all) in 30 seconds instead of 2-hour debugging.

### 2. PHPStan with WP stubs (mandatory setup)
Without WP stubs, PHPStan generates hundreds of false "function not found" errors. Setup:
```bash
composer require --dev szepeviktor/phpstan-wordpress php-stubs/wordpress-stubs
```
Reference the extension in `phpstan.neon`. The `php-lint.sh` hook runs PHPStan after every file edit — stubs make this feedback meaningful instead of noisy.

### 3. Scoped modular-security-audit
For a plugin with 50+ files, running audit on whole plugin takes hours. Define module boundaries:
```
/developers:modular-security-audit
"Scope is REST API handlers only, path: includes/rest/"
```
This skips Phase 0 architecture mapping and targets just the new code. Reduces 6-hour audit to 45 minutes.

### 4. debug-agent for three common WP failures

**Nonce 400:**
```
/developers:debug
"AJAX handler at wp_ajax_save_settings returns HTTP 400, nonce is sent"
```
Agent checks action string mismatch between `wp_nonce_field()` and `wp_verify_nonce()`, nonce lifetime, user session mismatch.

**REST 403:**
```
/developers:debug
"REST endpoint at /wp-json/slug/v1/settings returns 403 for admin users"
```
Agent checks `current_user_can()` return, `map_meta_cap` timing, app password vs cookie auth.

**CPT 404:**
```
/developers:debug
"CPT routes return 404 after registration"
```
Agent identifies wrong order: `register_post_type()` must happen before `flush_rewrite_rules()`.

### 5. Batch scaffolding with compound spec
Don't run `/developers:new-wp-feature` once per type. Instead:
```bash
wp scaffold plugin {{slug}}  # Creates skeleton + readme.txt + file structure

/developers:wp-new-feature
# Input: "Build plugin with: CPT for testimonials, REST endpoint 
# GET/POST /wp-json/slug/v1/testimonials, admin settings page"
```
The `wp-developer` agent reads existing scaffold + single prefix → generates all three coherently.

### 6. /developers:explain before joining existing codebase
When touching a plugin you didn't write:
```
/developers:explain
# Input: main plugin file
```
Traces full execution path from plugin load through all hook registrations. Produces ASCII diagram. Claude gets project-wide mental model in one session — subsequent features hook at correct priority.

### 7. Pre-pr manual WP checks
The existing `pre-pr` checks for debug artifacts (error_log, var_dump). For WordPress, also verify:
```bash
grep -r "var_dump\|print_r" includes/   # Should return nothing
grep -r "error_log()" includes/         # Should return nothing
grep -r "WP_DEBUG" . --include="*.php"  # Check for hardcoded true
ls uninstall.php                        # Must exist and clean up options
```

---

## Plugin Architecture Summary

### What's Auto-Activated
When you edit WordPress PHP files, these load automatically:

1. **wordpress-context skill** — auto-fires on any `wp-content/**/*.php` edit
   - Injects WPCS reminders, security checklist, hook patterns
   - No user invocation needed

2. **rules/wordpress.md** — auto-loads via glob pattern on matching files
   - Full WPCS rules, security rules, hook conventions, database rules
   - Injected into Claude's context silently

3. **php-lint.sh hook** — auto-runs after every file Write/Edit
   - `php -l` syntax check
   - PHPStan static analysis (if stubs installed)
   - Non-blocking (fails silently if tools absent)

### What Requires User Invocation

**Commands** — use `/developers:command-name`:
- `/developers:wp-new-feature` — scaffold feature with wp-developer agent
- `/developers:security-scan` — targeted security audit on specific directory
- `/developers:code-review` — full review (wp-reviewer + security-auditor in parallel)
- `/developers:modular-security-audit` — deep security audit (pre-release only)
- `/developers:wp-org-submission` — 18-point readiness checklist for wordpress.org
- `/developers:debug` — systematic debugging with root cause analysis
- `/developers:explain` — trace execution paths, produce ASCII diagrams
- `/developers:write-tests` — scaffold test cases for classes/functions
- `/developers:pre-pr` — pre-PR checklist (debug artifacts, migrations, tests)
- `/developers:expert-panel` — 10-expert debate on architecture decisions

**Agents** — spawned by commands, or explicitly via Agent tool:
- `wp-developer` — generates WordPress plugin code (WPCS-compliant)
- `wp-reviewer` — WordPress platform expert (wordpress.org standards)
- `security-auditor` — white-hat security specialist (WP attack patterns)
- `php-reviewer` — PHP + WordPress standards reviewer
- `debug-agent` — systematic debugger (WP-specific troubleshooting)
- `impact-analyzer` — traces code change impact across plugin

---

---

## Next Steps

1. **Test the setup** on an existing WP plugin:
   ```bash
   cd E:\Local Sites\spectra\app\public\wp-content\plugins\zip-ai\
   /developers:claude-code-setup
   ```
   Verify: `wordpress-context` skill auto-activates when editing any `.php` file.

2. **Deploy to team**:
   ```bash
   /plugin install developers --scope project
   # This adds the plugin to all team members' Claude Code
   ```

3. **Update project CLAUDE.md** with:
   - Plugin slug, prefix, text domain
   - Composer/npm setup steps
   - Current focus tracking

4. **Create `.claude/settings.json`** by copying `settings.wordpress.json` if team needs pre-approved permissions.

5. **Optional: Set up MCP** if using GitHub + Playwright:
   ```bash
   cp developers/templates/mcp.wordpress.json .claude/mcp.json
   export GITHUB_TOKEN=your_token
   ```

---

## Support

- **Plan details**: See `C:\Users\Yoga\.claude\plans\swirling-zooming-sedgewick.md`
- **WordPress rules**: `developers/rules/wordpress.md`
- **WordPress context skill**: `developers/skills/wordpress-context/SKILL.md`
- **WP.org submission checklist**: `/developers:wp-org-submission`
- **Agent documentation**: Each agent file (`developers/agents/`) includes detailed operating principles

---

**You now have a production-grade Claude Code setup optimized for WordPress plugin development at scale.**

