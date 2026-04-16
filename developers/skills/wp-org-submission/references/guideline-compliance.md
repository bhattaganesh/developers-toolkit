# WordPress.org Plugin Guidelines — Compliance Reference

Full breakdown of all 18 official WordPress.org plugin guidelines and what to check for each.

Source: https://developer.wordpress.org/plugins/wordpress-org/detailed-plugin-guidelines/

---

## Guideline 1: GPL-Compatible License

**Rule:** The plugin and all its code must use the GPL v2 (or later) or a compatible license.

**Compatible licenses (allowed):**
- GPL v2+, GPL v3+
- MIT License
- Apache License 2.0
- BSD 2-Clause, BSD 3-Clause
- ISC License
- LGPL v2+

**Incompatible licenses (NOT allowed):**
- Creative Commons NC (non-commercial)
- Proprietary / commercial licenses
- AGPL v3 (technically compatible but tricky)
- Any license restricting use/distribution

**What to check:**
- Main plugin file has `License: GPL-2.0-or-later` (or compatible)
- readme.txt has matching `License` field
- All third-party libraries in `vendor/` or bundled JS/CSS have compatible licenses
- License file (`LICENSE` or `LICENSE.txt`) exists in plugin root

---

## Guideline 2: Developer Responsibility

**Rule:** You are responsible for everything in your plugin, including third-party code and external APIs you call.

**What to check:**
- You have verified the license of every bundled library
- You have read and comply with the terms of every external API you use
- No copyrighted code included without proper attribution

---

## Guideline 3: Stable Version Must Be in the Directory

**Rule:** If you distribute updates anywhere (your own site, GitHub), the WordPress.org directory version must be kept up to date.

**What to check:**
- The `Stable tag` in readme.txt points to an actual SVN tag that exists
- The `Stable tag` is NOT `trunk`

---

## Guideline 4: Human-Readable Code

**Rule:** Code must be readable by humans. Obfuscation is not allowed.

**Prohibited patterns:**
- `eval()` used to execute dynamically generated code
- `base64_decode()` used to hide actual code logic
- `str_rot13()` used to obfuscate strings
- PHP packers/minifiers that make code unreadable
- Intentionally unclear variable naming designed to obscure logic

**Acceptable:**
- Minified JavaScript (if source `.js` files are also included or linked)
- `base64_decode()` used for legitimate data encoding (e.g., decoding a stored image)
- Code generators that produce readable output

**Grep:**
```bash
grep -rn "eval(\|base64_decode\|str_rot13\|gzinflate\|gzuncompress" --include="*.php" /path/to/plugin
```

---

## Guideline 5: No Trialware

**Rule:** Plugin functionality must not be restricted, locked behind paywalls, or disabled after a trial period in the free version.

**Prohibited:**
- Features that stop working after X days
- Core functionality locked behind a "Go Premium" gate
- API keys that only work for 30 days

**Allowed:**
- Premium version with additional features (freemium is OK)
- Integration with a paid external SaaS service (see Guideline 6)
- Upsells to a paid version (if not intrusive — see Guideline 11)

---

## Guideline 6: SaaS Integrations Are Permitted

**Rule:** Plugins that connect to external paid services are allowed — IF:
- The service provides substantial functionality
- The service is clearly documented in the readme.txt
- Terms of Use and Privacy Capability links are included

**What to check:**
- readme.txt `== Description ==` discloses the external service
- Terms of Service URL is linked
- Privacy Capability URL is linked
- What data is sent to the service is explained

---

## Guideline 7: User Tracking Requires Consent

**Rule:** Any data sent to external servers requires explicit, informed opt-in consent.

**Prohibited:**
- Sending usage data, error reports, or analytics without opt-in
- Opt-out (not opt-in) consent mechanisms
- Tracking that defaults to ON

**Required:**
- Opt-in checkbox on plugin activation or settings page
- Clear description of what data is collected
- Privacy Capability link in readme.txt and settings

**What to check:**
```bash
grep -rn "wp_remote_post\|wp_remote_get\|google-analytics\|gtag\|_gaq" --include="*.php" --include="*.js" /path/to/plugin
```

---

## Guideline 8: No Executable Code from Third Parties

**Rule:** Plugins cannot receive executable PHP or JavaScript code from external systems at runtime.

**Prohibited:**
- Loading remote PHP scripts and executing them
- Injecting remote JavaScript that executes arbitrary code
- Dynamic code loading from untrusted CDNs

**Exceptions:**
- Well-known, documented font CDNs (Google Fonts, etc.)
- Documented JavaScript from named services (e.g., Stripe.js from stripe.com)
- All external JS/CSS must be documented in readme.txt

**What to check:**
```bash
# Dynamic remote code loading
grep -rn "eval.*wp_remote\|include.*http\|require.*http" --include="*.php" /path/to/plugin

# Remote script injection
grep -rn "wp_enqueue_script.*http\|add_action.*wp_head.*echo.*<script" --include="*.php" /path/to/plugin
```

---

## Guideline 9: Legal and Ethical Conduct

**Rule:** The plugin and its developer must not engage in prohibited activities.

**Prohibited:**
- Black-hat SEO (link schemes, hidden text, cloaking)
- Fake reviews or sockpuppeting on WordPress.org
- Plagiarism or misattribution
- False GPL/legal compliance claims
- Unauthorized use of others' servers or resources
- Harassment of users, reviewers, or the WordPress community
- Community Code of Conduct violations

---

## Guideline 10: Optional Credit Links

**Rule:** "Powered by" links, admin footer credits, and similar displays must be optional and default to OFF.

**Prohibited:**
- Credit links enabled by default
- Settings buried so deeply that users can't find the opt-out
- Mandatory attribution in user-visible areas

**Allowed:**
- Optional credit link with a clear toggle in Settings

---

## Guideline 11: Dashboard Notices Must Be Respectful

**Rule:** Admin notices, upgrade prompts, and dashboard widgets must be minimal and non-intrusive.

**Rules:**
- Site-wide notices must be dismissible (or self-dismiss after N seconds)
- Upgrade notices should appear only on the plugin's own settings page — not every admin page
- Dashboard advertising is strongly discouraged
- Do not show notices on unrelated admin pages

**What to check:**
```bash
grep -rn "admin_notices\|network_admin_notices" --include="*.php" /path/to/plugin
```

---

## Guideline 12: Readme Must Not Be Spam

**Rule:** The readme.txt must be written for human readers, not search engines.

**Prohibited:**
- More than 5 tags (keyword stuffing)
- Competitor plugin names in tags or description
- Excessive affiliate links
- SEO-optimized fake reviews or testimonials
- Misleading descriptions

**What to check:**
- Count `Tags:` in readme.txt — maximum 5
- No competitor names in tags
- Description is honest and descriptive

---

## Guideline 13: Use WordPress Bundled Libraries

**Rule:** Do not bundle separate versions of libraries that WordPress already includes.

**WordPress-bundled libraries (do NOT bundle your own copy):**
- jQuery (use `wp_enqueue_script('jquery')`)
- jQuery UI
- Backbone.js (`wp_enqueue_script('backbone')`)
- Underscore.js (`wp_enqueue_script('underscore')`)
- Moment.js (`wp_enqueue_script('moment')`)
- React + ReactDOM (`wp_enqueue_script('react')`)
- Lodash (`wp_enqueue_script('lodash')`)
- SimplePie
- PHPMailer

**What to check:**
```bash
find /path/to/plugin -name "jquery*.js" -o -name "backbone*.js" -o -name "underscore*.js" -o -name "lodash*.js" 2>/dev/null
```

---

## Guideline 14: SVN Commits Should Be Deployment-Ready

**Rule:** The WordPress.org SVN repository is a release tool, not a development/CI repository.

**Rules:**
- Only commit production-ready code
- Do not make many small/frequent commits (it shows as "recently updated" each time)
- Do not commit development tools, test files, or node_modules

---

## Guideline 15: Version Numbers Must Increment

**Rule:** Every new release must have a higher version number than the previous one.

**Rules:**
- Version in plugin header must match `Stable tag` in readme.txt
- Version must use SemVer format (`major.minor.patch`)
- Never re-use or lower a version number

---

## Guideline 16: Complete Plugin Required at Submission

**Rule:** Placeholder, skeleton, or incomplete plugins are rejected.

**What counts as incomplete:**
- Placeholder files with no actual functionality
- "Coming soon" features that don't work
- Plugins that cause PHP fatal errors or warnings

---

## Guideline 17: Trademark and Copyright Respect

**Rule:** Plugin must not infringe on trademarks, copyrights, or project names.

**Rules:**
- Cannot use another product's trademark as the start of your plugin name
- Cannot copy another plugin's code without GPL-compatible licensing and attribution
- Cannot claim to be an "official" plugin for a product/company if not authorized

**Allowed (trademark coexistence):**
- "Feature for WooCommerce" ✅
- "My Plugin — Stripe Integration" ✅

**Not allowed:**
- "WooCommerce Extended Checkout" (starts with WooCommerce trademark) ❌
- "The Official Stripe Plugin" (not authorized by Stripe) ❌

---

## Guideline 18: WordPress.org Reserves Directory Rights

**Rule:** WordPress.org can remove plugins, suspend accounts, or restrict access for violations.

**Consequences escalate:**
1. Plugin temporarily closed → email sent → fix required
2. Repeated violations → data may not be restored
3. Severe violations → complete account ban from WordPress.org hosting

---

---

## Additional Code Compliance Rules (from Common Issues)

These are specific requirements beyond the 18 guidelines that reviewers actively check:

### No Custom Update Checker
**Rule:** Do not implement a custom update checker that bypasses WordPress.org's update infrastructure.

```php
// ❌ Wrong — custom update check calling your own server
add_filter( 'pre_set_site_transient_update_plugins', 'myplugin_check_updates' );
function myplugin_check_updates( $transient ) {
    $response = wp_remote_get( 'https://my-server.com/update-check' );
    // ... inject updates from own server
}
```

**Allowed:** If distributing through your own site (not WordPress.org), document the update mechanism clearly. Plugins on WordPress.org should use WordPress.org's update system.

---

### No Modifying Active Plugin List
**Rule:** Do not programmatically modify the list of active plugins.

```php
// ❌ Wrong — forcing plugin activation/deactivation
$active_plugins = get_option( 'active_plugins' );
$active_plugins[] = 'other-plugin/other-plugin.php';
update_option( 'active_plugins', $active_plugins );
```

**Why:** Violates user trust, can cause instability, and is considered unauthorized server use.

---

### No iframes in Admin Pages
**Rule:** Do not use iframes to embed admin pages or functionality. Use WordPress APIs instead.

```php
// ❌ Wrong — iframe embedding your service in WP admin
echo '<iframe src="https://myservice.com/dashboard"></iframe>';

// ✅ Correct — fetch data via REST API and render natively in WordPress
$data = wp_remote_get( 'https://myservice.com/api/data' );
// render $data using WP-native HTML
```

---

### No Offloading Static Assets to Remote Servers
**Rule:** Do not load images, JavaScript, or CSS from external servers unnecessarily.

```php
// ❌ Wrong — loading plugin JS from your CDN
wp_enqueue_script( 'my-plugin', 'https://cdn.my-server.com/my-plugin.js' );

// ✅ Correct — bundle assets locally
wp_enqueue_script( 'my-plugin', plugin_dir_url( __FILE__ ) . 'assets/js/my-plugin.js', [], '1.0.0', true );
```

**Permitted remote assets:**
- Google Fonts (GPL-compatible fonts)
- Your own SaaS service API calls (documented in readme)
- oEmbed calls (Twitter, YouTube, etc.)
- Well-known CDNs for documented external services

---

### Third-Party Libraries Must Be Maintained and Up-to-Date

**Rule:** All bundled third-party libraries must:
1. Be actively maintained (not abandoned)
2. Be at the latest stable version
3. Not use beta/alpha/development releases

```bash
# Check for outdated Composer packages
composer outdated --direct

# Update all dependencies
composer update
```

**Prohibited:**
- Libraries that haven't had updates in years and have known vulnerabilities
- Beta, alpha, or RC versions of libraries (unless technically required with justification)

---

### Prohibited Files Must Not Be Included

**Rule:** The following files must be excluded from distribution:

| File/Directory | Reason |
|---|---|
| `.DS_Store` | macOS system file, no plugin function |
| `.git/` | Version control history, not needed |
| `.gitignore` | Developer tool, not needed |
| `node_modules/` | Dev dependencies, massive size |
| `vendor/` (full Composer dir) | Include only what's needed |
| `tests/` | Development only |
| `phpunit.xml` | Development only |
| `package.json` / `package-lock.json` | Build tool config |
| `webpack.config.js` / `Gruntfile.js` | Build tool config |
| `README.md` | WordPress.org uses `readme.txt`, not README.md |
| `*.log` | Debug logs, potential data exposure |
| `.env` / `.env.example` | Config with potential credentials |
| `src/` (if compiled output exists) | Development sources |

---

### Function/Class/Option Prefixing (Full Scope)

**Rule:** ALL of the following must be prefixed with your unique plugin prefix:

| Item | Correct Example |
|---|---|
| Functions | `myplugin_save_settings()` |
| Classes | `MyPlugin_Admin` or `namespace MyPlugin;` |
| Global variables | `global $myplugin_options;` |
| Option names | `update_option( 'myplugin_settings', ... )` |
| Hook names | `do_action( 'myplugin_after_save' )` |
| Constants/Defines | `define( 'MYPLUGIN_VERSION', '1.0.0' )` |
| Transient names | `set_transient( 'myplugin_cache_key', ... )` |

**Reserved prefixes (cannot use as standalone):**
- `__` (double underscore — PHP magic methods)
- `wp_` (WordPress core)
- `_` (single underscore)

These ARE allowed inside class methods (e.g., `$this->_validate()`).

**Aim for distinctiveness:** Two-letter prefixes like `my_` cause conflicts with the ~100,000+ plugins that exist. Use 3+ characters or use namespaces.

---

## Quick Compliance Checklist

| Category | Check |
|---|---|
| **License** | `License:` field in header and readme.txt; GPL-compatible |
| **No obfuscation** | No `eval()`, `base64_decode()` for code hiding; no HEREDOC/NOWDOC |
| **No trialware** | No feature locks or trial expiry |
| **SaaS disclosed** | External services documented in readme with ToS + Privacy links |
| **No hidden tracking** | No opt-out-only analytics; tracking defaults to OFF |
| **Credit links optional** | Defaults to off; user must explicitly opt-in |
| **Notices dismissible** | Admin notices can be dismissed |
| **Max 5 readme tags** | Count tags in readme.txt |
| **WP bundled libraries used** | No bundled jQuery/Backbone/Underscore/React/etc. |
| **Stable tag = version** | Both fields match exactly |
| **Complete plugin** | All features functional, no placeholders |
| **No trademark issues** | Name cleared of conflicts |
| **No remote asset offloading** | All static JS/CSS/images bundled locally |
| **No ALLOW_UNFILTERED_UPLOADS** | Constant not used anywhere |
| **All prefixes unique** | Functions, classes, hooks, options, constants all prefixed |
| **No custom update checker** | Not bypassing WordPress.org update system |
| **No modifying active plugins** | Not programmatically changing active plugin list |
| **No iframes in admin** | Using WordPress APIs instead |
| **Libraries up-to-date** | No abandoned or outdated third-party libraries |
| **No prohibited files** | No .DS_Store, .git, node_modules, tests, package.json in zip |
| **wp_json_encode used** | Not using json_encode() |
| **wp_handle_upload used** | Not using move_uploaded_file() for uploads |
| **i18n complete** | Text domain is literal string, all strings translatable |
| **Readme.txt exists** | Not README.md — WordPress.org requires readme.txt |

