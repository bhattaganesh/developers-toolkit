---
description: Check if a WordPress plugin is ready for WordPress.org submission — full pre-submission checklist covering headers, readme, security, code quality, SVN, and assets
---

# WP.org Submission

Run a complete pre-submission audit before uploading a plugin to WordPress.org using the `wp-org-submission` skill — covers every requirement WordPress reviewers check.

## Instructions

1. **Identify the plugin** — Provide the plugin root directory or main plugin file path.

2. **Activate the skill** — Trigger the `wp-org-submission` skill by describing the need:
   > "Check if this plugin is ready for WordPress.org"
   > "Prepare this plugin for WP.org submission"
   > "Run the WordPress.org submission checklist"
   > "Is this plugin ready to submit to the plugin repository?"
   > "Pre-submission audit for WordPress.org"

3. **7-Phase audit** — The skill executes:
   - **Phase 1:** Plugin header validation
   - **Phase 2:** readme.txt validation
   - **Phase 3:** Security audit (escaping, sanitizing, nonces, capabilities)
   - **Phase 4:** Code quality review (WPCS, prohibited patterns)
   - **Phase 5:** Guideline compliance (all 18 WP.org guidelines)
   - **Phase 6:** SVN structure and plugin assets verification
   - **Phase 7:** Submission report generation

4. **Review the report** — The skill produces a table with PASS / WARN / FAIL for 19 categories, plus a prioritized fix list.

## What the Checklist Covers

### Plugin Header
- Required fields: `Plugin Name`, `Description`, `Version`, `Requires at least`, `Tested up to`, `Requires PHP`, `License`
- Valid SPDX license identifier (GPL-2.0-or-later)
- Stable tag matching a tagged SVN release

### readme.txt
- All required sections: `Description`, `Installation`, `Screenshots`, `Changelog`, `Frequently Asked Questions`
- `Tested up to` matches current WordPress version
- `Stable tag` is not `trunk`
- No broken links or placeholder text

### Security
- All output escaped: `esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`
- All input sanitized: `sanitize_text_field()`, `absint()`, `wp_kses_post()`
- Nonces on every form and AJAX handler
- Capability checks before privileged operations
- `$wpdb->prepare()` for direct queries
- No HEREDOC / nowdoc (prohibited), no `ALLOW_UNFILTERED_UPLOADS`

### Code Quality
- All functions, classes, hooks, options, and CSS prefixed with plugin slug
- No output buffering, no `eval()`, no `base64_decode()` on user data
- No bundled libraries that bypass WordPress update checks
- No phone-home / external update checks
- i18n: text domain literal (not variable), all strings translatable

### Guideline Compliance
- All 18 official WordPress.org plugin guidelines
- No iframes injecting external content
- No prohibited files (`.git/`, `node_modules/`, `composer.lock`)

### SVN & Assets
- `trunk/`, `tags/`, `assets/` directory structure
- Plugin banner: 772×250px and 1544×500px (retina)
- Plugin icon: 128×128px and 256×256px (retina)
- Screenshots named `screenshot-1.png` through `screenshot-N.png`

## Dependencies

This command activates the **wp-org-submission** skill bundled with the developers plugin.
Run this BEFORE submitting to WordPress.org to avoid rejection delays.
