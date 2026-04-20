---
name: wp-org-submission
description: >
  This skill should be used when the user asks to "check if plugin is ready for WordPress.org",
  "prepare plugin for submission", "WordPress plugin submission checklist", "submit plugin to
  WordPress repository", "pre-submission check", "plugin directory requirements",
  "WordPress.org plugin review checklist", or wants to audit a plugin before publishing to
  the WordPress plugin directory.
version: 1.0.0
tools: Read, Glob, Grep, Write, Bash
---

# WordPress.org Plugin Submission Checklist Skill

Comprehensive pre-submission audit for the WordPress.org Plugin Directory — covering security, code quality, readme, plugin header, guideline compliance, and naming.

## Quick Reference

**Workflow:** 7 phases with a final report
**Standard:** WordPress.org Plugin Guidelines + Plugin Review Team Common Issues + Plugin Check tool
**Deliverables:** Checklist report with PASS / FAIL / WARN per item, actionable fix instructions
**Principle:** Read-only audit — no code changes unless explicitly asked

---

## When to Use

- Before submitting a new plugin to WordPress.org for the first time
- After making major changes to an existing plugin before a re-submission
- To proactively catch rejection reasons before the review team flags them
- As part of a pre-release quality gate for WordPress plugins

---

## Operating Principles

1. **Read-only by default** — Audit only; do not edit files unless the user explicitly requests fixes.
2. **Evidence-based** — Every finding must cite the exact file and line number.
3. **Actionable output** — Every FAIL and WARN must include a specific fix instruction.
4. **Prioritize blockers first** — Security issues (escape, sanitize, nonces) are the #1 reason for rejection; surface them first.
5. **Check the actual plugin slug** — All prefix and naming checks use the detected slug, not a generic placeholder.
6. **No assumptions** — If a file is missing (e.g., readme.txt), mark it FAIL with instructions to create it.

---

## Phase 0: Gather Context

**Goal:** Identify plugin root directory and key files before starting.

**Ask the user:**
- What is the path to the plugin directory (or the .zip file)?
- What is the intended WordPress.org slug (the URL-safe plugin name)?

**Auto-detect if not provided:**
```bash
# Find main plugin file (has "Plugin Name:" header)
grep -rl "Plugin Name:" /path/to/plugin --include="*.php" | head -5
```

**Identify:**
- Main plugin file (the one with the plugin header)
- `readme.txt` location
- Plugin slug (from directory name or user input)
- Text domain used in the plugin

**Present findings and confirm before proceeding.**

---

## Phase 1: Plugin Header Check

**Goal:** Verify the main plugin file header is complete and valid.

**Read the main plugin file header** (top ~30 lines).

Check each required and recommended field:

| Field | Required | Rule |
|---|---|---|
| `Plugin Name` | ✅ Required | Must be present |
| `Description` | ✅ Required | Max 150 characters |
| `Version` | ✅ Required | Must use SemVer (e.g., `1.0.0`) |
| `Author` | ✅ Required | Real author name |
| `License` | ✅ Required | Must be GPL-compatible (e.g., `GPL-2.0-or-later`) |
| `License URI` | ✅ Required | Must point to valid license URL |
| `Text Domain` | ✅ Required | Must exactly match the plugin slug |
| `Requires at least` | ✅ Required | Minimum WP version (e.g., `6.0`) |
| `Requires PHP` | ⚠️ Recommended | Minimum PHP version (e.g., `7.4`) |
| `Plugin URI` | ⚠️ Recommended | Plugin homepage URL |
| `Author URI` | ⚠️ Recommended | Author homepage |
| `Domain Path` | ⚠️ If translations | Path to `.pot` files (e.g., `/languages`) |

**Critical Checks:**
- `Text Domain` must match the plugin slug exactly (case-sensitive, hyphenated)
- `Version` in the header must match `Stable tag` in readme.txt
- `License` must be GPL v2 or later, or a compatible license

**Grep patterns to use:**
```bash
grep -n "Plugin Name\|Description\|Version\|Author\|License\|Text Domain\|Requires" main-file.php | head -20
```

See `references/plugin-header-requirements.md` for the full field reference.

---

## Phase 2: Readme.txt Check

**Goal:** Verify readme.txt is present, complete, and correctly formatted.

**Check if readme.txt exists** at the plugin root. If missing → FAIL immediately with creation instructions.

**Required header fields:**

| Field | Rule |
|---|---|
| `Plugin Name` | Must match the plugin header |
| `Contributors` | Comma-separated WordPress.org usernames (lowercase) |
| `Tags` | Maximum 5 tags; no competitor names; no keyword stuffing |
| `Requires at least` | Minimum WP version; must match plugin header |
| `Tested up to` | Latest WP major version tested (e.g., `6.7`) |
| `Stable tag` | Must be a version number — NEVER use `trunk` |
| `License` | Must be GPL-compatible |
| `Short Description` | Max 150 characters; no HTML markup |

**Required sections:**
- `== Description ==` — Full plugin description
- `== Changelog ==` — At minimum, one entry for current version

**Recommended sections:**
- `== Installation ==` (required if non-standard setup)
- `== Frequently Asked Questions ==`
- `== Screenshots ==`
- `== Upgrade Notice ==`

**Critical Checks:**
1. `Stable tag` must NOT be `trunk` — use the actual version number
2. `Stable tag` in readme.txt must exactly match `Version` in the plugin header
3. `Tags` must be 5 or fewer
4. `Short Description` must be 150 characters or fewer
5. readme.txt file must be under 10KB (archive old changelog entries if needed)
6. `Tested up to` must not be a future version

**Grep patterns:**
```bash
grep -n "Stable tag\|Tested up to\|Requires at least\|Version\|Tags\|Contributors" readme.txt
wc -c readme.txt  # Check file size in bytes
```

See `references/readme-requirements.md` for the full format reference and template.

---

## Phase 3: Security Audit

**Goal:** Find the three most common rejection reasons plus other critical security issues.

This is the most important phase. WordPress.org reviewers specifically look for:

### 3.0 — Critical Rule: "Sanitize Early, Escape Late, Always Validate"

This is the WordPress.org reviewer's core mantra. These are three separate operations:
- **Sanitize** (on input, before storing) — strip potentially harmful data
- **Validate** (anywhere) — confirm data matches expected format
- **Escape** (on output, at the point of echo) — make data safe for display

**These cannot be swapped.** Sanitizing is not escaping; escaping is not sanitizing. Both are always required.

---

### 3.1 — Output Escaping (Most Common Rejection Reason)

**Every** piece of output must be escaped at the point of output — even translated strings.

**Search for unescaped output:**
```bash
# Find echo statements without escaping
grep -rn "echo\s" --include="*.php" /path/to/plugin | grep -v "esc_\|wp_kses\|esc_html\|esc_attr\|esc_url\|esc_js\|esc_textarea\|number_format_i18n\|absint\|intval\|wp_json_encode"

# Find direct variable output without escaping
grep -rn "<?=\s*\$" --include="*.php" /path/to/plugin

# Find _e() / _ex() usage — these output without escaping
grep -rn "\b_e(\|\b_ex(" --include="*.php" /path/to/plugin
```

**Required escaping functions by context:**
| Context | Function |
|---|---|
| HTML content | `esc_html()` |
| HTML attribute | `esc_attr()` |
| URL | `esc_url()` |
| JavaScript | `esc_js()` |
| Textarea | `esc_textarea()` |
| Arbitrary HTML | `wp_kses_post()` or `wp_kses()` |
| Integer | `absint()` or `intval()` |
| JSON output | `wp_json_encode()` (never `json_encode()`) |

**Critical: Translation functions and escaping**
- `_e()` and `_ex()` output WITHOUT escaping — **always flag these**
- Prefer `esc_html_e()`, `esc_attr_e()` instead
- `esc_url_raw()` is a sanitization function, NOT an escaping function — use `esc_url()` for output

### 3.2 — Input Sanitization (Second Most Common)

**Every** piece of user input must be sanitized before use.

**Search for unsanitized input:**
```bash
# Find $_POST, $_GET, $_REQUEST usage without sanitization
grep -rn "\$_POST\|\$_GET\|\$_REQUEST\|\$_SERVER" --include="*.php" /path/to/plugin | grep -v "sanitize_\|absint\|intval\|wp_verify_nonce\|check_admin_referer\|isset\|empty"
```

**Required sanitization functions by type:**
| Input type | Function |
|---|---|
| Plain text | `sanitize_text_field()` |
| Email | `sanitize_email()` |
| URL | `esc_url_raw()` or `sanitize_url()` |
| Integer | `absint()` or `intval()` |
| HTML with some tags | `wp_kses_post()` |
| File name | `sanitize_file_name()` |
| HTML class/ID | `sanitize_html_class()` |
| Textarea content | `sanitize_textarea_field()` |
| Key/slug | `sanitize_key()` |

### 3.3 — Nonce Verification (Third Most Common)

**Every** form submission and AJAX handler must verify a nonce.

**Search for missing nonces on forms:**
```bash
# Forms without nonce fields
grep -rn "<form" --include="*.php" /path/to/plugin -A 10 | grep -v "wp_nonce_field\|nonce"

# admin-ajax.php handlers without nonce check
grep -rn "wp_ajax_\|wp_ajax_nopriv_" --include="*.php" /path/to/plugin -A 5 | grep -v "check_ajax_referer\|wp_verify_nonce"
```

**Required pattern:**
```php
// Creating nonce in form
wp_nonce_field( 'my_plugin_action', 'my_plugin_nonce' );

// Verifying nonce on submission
if ( ! isset( $_POST['my_plugin_nonce'] ) || ! wp_verify_nonce( sanitize_key( $_POST['my_plugin_nonce'] ), 'my_plugin_action' ) ) {
    wp_die( esc_html__( 'Security check failed.', 'my-plugin' ) );
}
```

### 3.4 — Capability Checks

Every privileged action must check user capabilities.

```bash
# Admin actions without capability check
grep -rn "admin_init\|admin_post_\|wp_ajax_" --include="*.php" /path/to/plugin -A 10 | grep -v "current_user_can\|is_admin"
```

### 3.5 — SQL Injection (Direct Database Queries)

```bash
# Direct $wpdb queries with variables — must use $wpdb->prepare()
grep -rn "\$wpdb->" --include="*.php" /path/to/plugin | grep -v "->prepare\|->insert\|->update\|->delete\|->get_results\|->get_row\|->get_var\|->query\|->prefix\|->last_error\|->show_errors"

# Any direct query with user input
grep -rn "\$wpdb->query\|\$wpdb->get_results\|\$wpdb->get_row\|\$wpdb->get_var" --include="*.php" /path/to/plugin
```

### 3.6 — Direct File Access Prevention

Every PHP file must have a direct access guard at the top.

```bash
# Files missing ABSPATH check
grep -rL "defined.*ABSPATH\|ABSPATH.*defined" --include="*.php" /path/to/plugin
```

**Required at the top of every PHP file:**
```php
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
```

### 3.7 — HEREDOC / NOWDOC — Prohibited

```bash
grep -rn "<<<" --include="*.php" /path/to/plugin
```

**Why:** Code sniffers cannot detect missing escaping inside HEREDOC blocks. Replace with regular string concatenation or template tags with explicit `esc_*()` calls.

### 3.8 — ALLOW_UNFILTERED_UPLOADS — Strictly Prohibited

```bash
grep -rn "ALLOW_UNFILTERED_UPLOADS" --include="*.php" /path/to/plugin
```

Instant rejection. Use the `upload_mimes` filter to add specific file types instead.

### 3.9 — filter_var / filter_input Without Explicit Filter

```bash
grep -rn "filter_var\|filter_input" --include="*.php" /path/to/plugin | grep -v "FILTER_SANITIZE\|FILTER_VALIDATE"
```

`FILTER_DEFAULT` does not sanitize. Always specify `FILTER_SANITIZE_NUMBER_INT`, `FILTER_SANITIZE_EMAIL`, etc.

### 3.10 — File Uploads — Must Use wp_handle_upload()

```bash
grep -rn "move_uploaded_file" --include="*.php" /path/to/plugin
```

WordPress's `wp_handle_upload()` applies security checks. Direct `move_uploaded_file()` bypasses them.

See `references/security-checklist.md` for extended security patterns and all grep commands.

---

## Phase 4: Code Quality & Guidelines Compliance

**Goal:** Check WordPress coding standards and plugin directory guidelines.

### 4.1 — Plugin Prefix Check

ALL of the following must use the plugin's unique prefix:
- Functions
- Classes / namespaces
- Global variables
- Option names (`update_option`)
- Hook names (`do_action`, `apply_filters`)
- Constants (`define`)
- Transient names (`set_transient`)

```bash
# Find functions without prefix (replace 'myplugin' with actual prefix)
grep -rn "^function " --include="*.php" /path/to/plugin | grep -v "function myplugin_\|function MyPlugin"

# Find global variables without prefix
grep -rn "^global \$" --include="*.php" /path/to/plugin | grep -v "myplugin_\|wpdb\|wp_"

# Find option names without prefix
grep -rn "get_option\|update_option\|add_option\|delete_option" --include="*.php" /path/to/plugin | grep -v "'myplugin_\|\"myplugin_"
```

**Reserved prefixes that cannot be used standalone:** `__`, `wp_`, `_`

**Aim for 3+ character prefixes** — two-letter prefixes commonly conflict with other plugins.

### 4.2 — WordPress API Usage

```bash
# Check for direct PHP mail() usage (should use wp_mail())
grep -rn "\bmail(" --include="*.php" /path/to/plugin

# Check for curl (should use wp_remote_get/post)
grep -rn "\bcurl_" --include="*.php" /path/to/plugin

# Check for direct file_get_contents for remote URLs
grep -rn "file_get_contents.*http" --include="*.php" /path/to/plugin

# Check for hardcoded paths (should use plugin_dir_path/url)
grep -rn "dirname.*__FILE__\|__DIR__" --include="*.php" /path/to/plugin | grep -v "plugin_dir\|plugins_url"
```

**WordPress API replacements:**
| PHP Function | WordPress Equivalent |
|---|---|
| `mail()` | `wp_mail()` |
| `curl_*()` | `wp_remote_get()`, `wp_remote_post()` |
| `file_get_contents(url)` | `wp_remote_get()` |
| `setcookie()` | `wc_setcookie()` or WP session |
| `header()` | `wp_redirect()`, `wp_safe_redirect()` |

### 4.3 — Script/Style Enqueueing

```bash
# Direct script tags (should use wp_enqueue_script)
grep -rn "<script\|<link.*stylesheet" --include="*.php" /path/to/plugin | grep -v "//.*<script\|wp_enqueue"

# Enqueue without wp_enqueue_scripts hook
grep -rn "wp_enqueue_script\|wp_enqueue_style" --include="*.php" /path/to/plugin
```

### 4.4 — No Code Obfuscation

```bash
# Common obfuscation patterns
grep -rn "base64_decode\|eval(\|str_rot13\|gzinflate\|gzuncompress\|rawurldecode" --include="*.php" /path/to/plugin
```

**Rule:** Any use of `eval()` or `base64_decode()` used to execute code is a rejection reason. Encoding for data (e.g., storing base64 images) is acceptable.

### 4.5 — GPL License Compatibility

```bash
# Check all included third-party libraries
find /path/to/plugin/vendor -name "LICENSE*" -o -name "composer.json" 2>/dev/null | head -20

# Check for non-GPL license headers in PHP files
grep -rn "MIT License\|Apache License\|BSD License\|ISC License" --include="*.php" /path/to/plugin
```

**Rule:** MIT, Apache 2.0, BSD, and ISC licenses are all GPL-compatible and allowed. Non-GPL-compatible licenses are not.

### 4.6 — No Bundled WordPress Libraries

```bash
# Check for bundled versions of libraries WordPress includes
find /path/to/plugin -name "jquery*.js" -o -name "jquery*.min.js" 2>/dev/null
find /path/to/plugin -name "backbone*.js" -o -name "underscore*.js" 2>/dev/null
```

**Rule:** Do not bundle jQuery, Backbone.js, Underscore.js, or any other library that WordPress includes by default. Enqueue the WordPress-bundled version instead.

### 4.7 — Internationalization (i18n)

```bash
# Strings without text domain
grep -rn "__(\|_e(\|_n(\|_x(\|esc_html__(\|esc_attr__(" --include="*.php" /path/to/plugin | grep -v "'{plugin_slug}'\|\"{plugin_slug}\""

# Text domain consistency
grep -rn "load_plugin_textdomain\|load_textdomain" --include="*.php" /path/to/plugin
```

**Rule:** Every translatable string must include the text domain. The text domain must match the plugin slug.

### 4.8 — Dashboard Notices

```bash
# Site-wide admin notices
grep -rn "admin_notices\|network_admin_notices" --include="*.php" /path/to/plugin
```

**Rule:** Admin notices must be dismissible or context-specific. Site-wide persistent notices are strongly discouraged.

### 4.9 — External Service Documentation

```bash
# External API calls
grep -rn "wp_remote_get\|wp_remote_post\|wp_remote_request" --include="*.php" /path/to/plugin
```

**Rule:** If the plugin connects to external services, the readme.txt must disclose:
- What data is sent
- The service's Terms of Use / Privacy Capability URL

### 4.10 — User Tracking Consent

```bash
# Look for tracking/analytics code
grep -rn "google-analytics\|gtag\|_gaq\|mixpanel\|segment\|amplitude" --include="*.php" --include="*.js" /path/to/plugin
```

**Rule:** Sending user data to external servers requires explicit opt-in consent. Opt-in must default to OFF.

### 4.11 — Internationalization (i18n) Audit

```bash
# Strings with missing text domain
grep -rn "\b__(\|\b_e(\|\besc_html__(\|\besc_attr__(" --include="*.php" /path/to/plugin | grep -v "'your-plugin-slug'\|\"your-plugin-slug\""

# Variable text domain — PROHIBITED
grep -rn "\b__(\|\b_e(" --include="*.php" /path/to/plugin | grep "\$[a-z_]*[,)]"

# _e() / _ex() without escaping — PROHIBITED (use esc_html_e instead)
grep -rn "\b_e(\|\b_ex(" --include="*.php" /path/to/plugin
```

**Rules:**
- Text domain must be a string literal (never a variable)
- Text domain must exactly match the plugin slug
- Use `esc_html_e()` instead of `_e()` — `_e()` outputs without escaping
- Use `esc_html__()` instead of `__()` in HTML contexts
- Never embed PHP variables in translatable strings — use `printf()` with placeholders
- Use `_n()` for singular/plural — not two separate `__()` calls

See `references/i18n-requirements.md` for the complete i18n guide.

### 4.12 — No Custom Update Checker Bypassing WordPress.org

```bash
# Check for custom update check logic
grep -rn "pre_set_site_transient_update_plugins\|site_transient_update_plugins" --include="*.php" /path/to/plugin
```

**Rule:** Plugins hosted on WordPress.org must use WordPress.org's update infrastructure. Do not call your own server for update checks.

### 4.13 — No Modifying Active Plugins List

```bash
grep -rn "active_plugins" --include="*.php" /path/to/plugin | grep -v "is_plugin_active\|is_plugin_inactive\|plugin_basename"
```

**Rule:** Never programmatically modify the `active_plugins` option to activate or deactivate plugins.

### 4.14 — No iframes in Admin Pages

```bash
grep -rn "<iframe" --include="*.php" /path/to/plugin
```

**Rule:** Use WordPress REST API or admin-ajax.php to fetch data. Never embed admin functionality in iframes.

See `references/guideline-compliance.md` for the full guidelines reference.

---

## Phase 5: Pre-Submission Readiness

**Goal:** Final checks before zipping and uploading.

### 5.1 — File & Size Checks

```bash
# Check for development/test files that should be excluded
find /path/to/plugin -name "*.log" -o -name "node_modules" -o -name ".git" -o -name "phpunit.xml" -o -name ".travis.yml" -o -name "Makefile" -o -name "Gruntfile.js" -o -name "package.json" -o -name "package-lock.json" -o -name ".eslintrc*" -o -name ".phpcs.xml" 2>/dev/null

# Check zip size (must be under 10MB)
du -sh /path/to/plugin/
```

**Files that MUST be excluded from submission zip:**
- `.git/` directory
- `node_modules/`
- `vendor/` (full Composer vendor directory — only include what's needed)
- Test files (`phpunit.xml`, `tests/`, `*.test.php`)
- Build config files (`Gruntfile.js`, `webpack.config.js`, `package.json`)
- Log files (`*.log`, `debug.log`)
- `.env` files
- Documentation source files (if large)

### 5.2 — PHP Syntax Check

```bash
# Check all PHP files for syntax errors
find /path/to/plugin -name "*.php" -exec php -l {} \; 2>&1 | grep -v "No syntax errors"
```

### 5.3 — WordPress.org Account Requirements

Confirm with the user:
- [ ] WordPress.org account exists
- [ ] Two-Factor Authentication (2FA) is enabled on the account (mandatory as of Oct 2024)
- [ ] Email `plugins@wordpress.org` is whitelisted in email client
- [ ] Submission will be made with the account that owns the plugin

### 5.4 — Plugin Naming Check

Confirm with the user:
- [ ] Plugin name does not duplicate an existing WordPress.org plugin slug
- [ ] Plugin name does not start with a trademarked term (e.g., "WooCommerce Feature" → use "Feature for WooCommerce")
- [ ] Plugin name does not include competitor plugin names
- [ ] Plugin display name and slug are finalized (the slug/URL **cannot be changed** after submission)

### 5.5 — Run Plugin Check Tool (if available)

```bash
# If WP-CLI and Plugin Check are installed
wp plugin check /path/to/plugin --format=table 2>/dev/null || echo "Plugin Check not available"
```

If Plugin Check is not installed, instruct the user to run it manually:
- Install via: `wp plugin install plugin-check --activate`
- Or use the online checker at https://wordpress.org/plugins/plugin-check/

See `references/plugin-check-tool.md` for Plugin Check setup and common errors.

---

## Phase 6: Post-Approval — SVN Deployment & Assets

**Goal:** Ensure the developer knows what to do AFTER the plugin is approved — the SVN deployment and visual asset requirements. This phase is informational; present it as a "what comes next" guide.

> This phase applies **after WordPress.org approves your submission**. They will email you with SVN access.

### 6.1 — SVN Repository Structure

After approval, you receive an SVN repository at `https://plugins.svn.wordpress.org/{your-plugin-slug}/` with three directories:

```
your-plugin-slug/
├── trunk/     ← Your working code (latest)
├── tags/      ← Numbered version snapshots (e.g., tags/1.0.0)
└── assets/    ← Screenshots, banners, icons (NOT inside trunk)
```

**Critical rules:**
- Main plugin file must be **directly in trunk/** — not in a subfolder
- Screenshots and banners go in **assets/** — NOT inside trunk (keeps download size small)
- `Stable tag` in readme.txt must point to an existing **tags/** directory

### 6.2 — First Release Checklist

```bash
# 1. Check out the repo
svn co https://plugins.svn.wordpress.org/{slug}/ /local/{slug}/

# 2. Copy plugin files to trunk
cp -r /path/to/my-plugin/* /local/{slug}/trunk/

# 3. Stage all files
cd /local/{slug}/ && svn add trunk/*

# 4. Commit trunk
svn ci trunk/ -m "Initial release 1.0.0"

# 5. Tag the release (copy from trunk — do NOT create manually)
svn cp https://plugins.svn.wordpress.org/{slug}/trunk \
       https://plugins.svn.wordpress.org/{slug}/tags/1.0.0 \
       -m "Tagging version 1.0.0"

# 6. Update Stable tag in trunk/readme.txt
# Edit: Stable tag: 1.0.0
svn ci trunk/readme.txt -m "Update Stable tag to 1.0.0"
```

### 6.3 — Plugin Assets (Banners, Icons, Screenshots)

All visual assets go in the **assets/** directory of the SVN repo:

| Asset | Dimensions | Filename | Format | Max Size |
|---|---|---|---|---|
| Banner (standard) | 772 × 250 px | `banner-772x250.png` | JPG/PNG | 4 MB |
| Banner (retina) | 1544 × 500 px | `banner-1544x500.png` | JPG/PNG | 4 MB |
| Icon (standard) | 128 × 128 px | `icon-128x128.png` | PNG/JPG/GIF | 1 MB |
| Icon (retina) | 256 × 256 px | `icon-256x256.png` | PNG/JPG/GIF | 1 MB |
| Icon (vector) | Any | `icon.svg` | SVG | 1 MB |
| Screenshot | Any | `screenshot-1.png`, `screenshot-2.png` | JPG/PNG | 10 MB |

**Rules:**
- SVG icon requires a PNG fallback (`icon-128x128.png`)
- Screenshots map sequentially to lines in the `== Screenshots ==` section of readme.txt
- Set MIME types: `svn propset svn:mime-type image/png assets/icon-128x128.png`

### 6.4 — What NOT to Include in SVN

```
❌ .git/            ❌ node_modules/     ❌ .DS_Store
❌ tests/           ❌ phpunit.xml        ❌ package.json
❌ webpack.config.js ❌ .phpcs.xml        ❌ *.log
❌ README.md        ← Use readme.txt, not README.md
```

See `references/svn-and-assets.md` for complete SVN deployment guide.

---

## Phase 7: Generate Submission Report

**Goal:** Produce a single, actionable report with all findings from Phases 1–5.

**Create report file:** `wp-org-submission-report-[date].md`

### Report Format

```markdown
# WordPress.org Submission Checklist Report
**Plugin:** {Plugin Name}
**Version:** {Version}
**Slug:** {plugin-slug}
**Date:** {YYYY-MM-DD}
**Auditor:** Claude Code (wp-org-submission skill v1.0.0)

---

## Summary

| Category | PASS | WARN | FAIL |
|---|---|---|---|
| Plugin Header | x | x | x |
| Readme.txt | x | x | x |
| Security | x | x | x |
| Code Quality | x | x | x |
| Pre-Submission | x | x | x |
| **Total** | **x** | **x** | **x** |

**Submission Readiness:** 🔴 NOT READY / 🟡 READY WITH WARNINGS / 🟢 READY

---

## Blocker Issues (Must Fix Before Submission)

[List all FAIL items with file:line references and exact fix instructions]

---

## Warnings (Should Fix)

[List all WARN items with recommendations]

---

## Passed Checks

[Brief list of passed items for confidence]

---

## Next Steps

1. Fix all FAIL items above
2. Review WARN items
3. Run Plugin Check tool: `wp plugin check /path/to/plugin`
4. Create submission zip (excluding dev files)
5. Submit at: https://wordpress.org/plugins/developers/add/
```

---

## Deliverables

1. **Submission Report** (`wp-org-submission-report-[date].md`)
   - Summary table with PASS/WARN/FAIL counts
   - All findings with file + line references
   - Actionable fix instructions per finding
   - Overall readiness verdict

2. **Checklist Summary** (printed to conversation)
   - Quick overview of blockers and warnings
   - Estimated effort to fix

---

## Quality Checklist

Before marking complete:

- [ ] Main plugin file identified and header validated
- [ ] readme.txt validated (exists, complete, versions match)
- [ ] Security: escaping, sanitization, nonces checked
- [ ] Security: capability checks and SQL injection checked
- [ ] Code quality: prefixes, WP APIs, enqueuing checked
- [ ] Guidelines compliance: GPL, no obfuscation, external services
- [ ] Pre-submission: file size, dev files excluded, PHP syntax clean
- [ ] Report generated with PASS/WARN/FAIL per item
- [ ] All FAIL items have fix instructions with file:line references

---

## References

- `references/00-index.md` — Navigation index
- `references/plugin-header-requirements.md` — Complete header field reference
- `references/readme-requirements.md` — readme.txt format, template, and rules
- `references/security-checklist.md` — Extended security patterns: escaping, sanitization, nonces, HEREDOC, ALLOW_UNFILTERED_UPLOADS, wp_json_encode, wp_handle_upload
- `references/guideline-compliance.md` — All 18 WordPress.org guidelines + additional code compliance rules
- `references/plugin-check-tool.md` — Plugin Check setup, all error codes, and fixes
- `references/svn-and-assets.md` — SVN structure, first release, banners/icons/screenshots requirements
- `references/i18n-requirements.md` — Complete i18n guide: text domain rules, translation functions, variable placeholders, translator comments
- `templates/submission-report.md` — Blank report template

---

## Quality Checklist

Before marking complete:

- [ ] Main plugin file identified and header validated (all required fields, versions match)
- [ ] readme.txt validated (exists, complete, Stable tag ≠ trunk, versions match, ≤5 tags)
- [ ] Security — escaping checked (including `_e()`, `_ex()`, `wp_json_encode`)
- [ ] Security — sanitization checked (including `filter_var` explicit filters)
- [ ] Security — nonces checked (forms + AJAX handlers)
- [ ] Security — capability checks checked
- [ ] Security — SQL injection / `$wpdb->prepare()` checked
- [ ] Security — ABSPATH guards on all PHP files
- [ ] Security — HEREDOC/NOWDOC usage checked
- [ ] Security — ALLOW_UNFILTERED_UPLOADS checked
- [ ] Security — move_uploaded_file → wp_handle_upload checked
- [ ] Code quality — all prefixes unique (functions, classes, options, constants, hooks)
- [ ] Code quality — WordPress APIs used (no curl, mail(), file_get_contents for remote)
- [ ] Code quality — scripts/styles properly enqueued
- [ ] Code quality — no bundled WordPress libraries (jQuery, Backbone, etc.)
- [ ] Code quality — no obfuscation (eval, base64 for code hiding)
- [ ] Code quality — i18n complete (text domain literal, no _e(), translatable strings)
- [ ] Code quality — no iframes in admin
- [ ] Code quality — no custom update checker
- [ ] Code quality — no modifying active plugins list
- [ ] Code quality — third-party libraries maintained and up-to-date
- [ ] Guidelines — GPL-compatible license
- [ ] Guidelines — no remote asset offloading
- [ ] Guidelines — external services documented in readme
- [ ] Guidelines — user tracking requires opt-in
- [ ] Guidelines — admin notices dismissible
- [ ] Guidelines — credit links default off
- [ ] Pre-submission — dev files excluded (node_modules, .git, tests, package.json, README.md)
- [ ] Pre-submission — zip size under 10 MB
- [ ] Pre-submission — PHP syntax clean
- [ ] Pre-submission — 2FA on WordPress.org account
- [ ] Pre-submission — plugin slug confirmed (cannot change after submission)
- [ ] Pre-submission — Plugin Check tool passes
- [ ] Report generated with PASS/WARN/FAIL per item

---

## Notes

- Audit is read-only by default — do not modify plugin files without explicit user request
- Every finding must include the specific file path and line number
- Security checks are the highest priority (top 3 rejection reasons are all security)
- The plugin slug cannot be changed after submission — confirm it before submitting
- `Stable tag` must never be `trunk` in readme.txt — always use a version number
- `README.md` is ignored by WordPress.org — use `readme.txt`
- 2FA on WordPress.org account is mandatory as of October 2024
- Reply to rejection emails with fixes — do NOT resubmit a new plugin
- Only one plugin can be in review at a time per account
- After approval, SVN zip rebuild can take up to 6 hours

