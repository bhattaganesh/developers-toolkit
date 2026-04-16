# Plugin Check Tool

The Plugin Check (PCP) tool is an official WordPress.org tool that automatically scans plugins for common issues before submission. As of 2024, all new plugin submissions are auto-scanned.

## What Plugin Check Catches

- PHP syntax errors
- Usage of deprecated or forbidden functions
- Missing text domain in translatable strings
- Incorrect or missing output escaping
- Version mismatches between plugin header and readme.txt
- Missing `Stable tag` or use of `trunk`
- Missing required readme.txt sections
- Improper script/style enqueueing
- Use of bundled WordPress libraries
- `ABSPATH` checks missing
- Direct database queries without `$wpdb->prepare()`
- Use of `eval()` or code obfuscation

## Installation

### Via WP-CLI

```bash
# Install and activate Plugin Check
wp plugin install plugin-check --activate

# Run check on your plugin (by slug or path)
wp plugin check my-plugin-slug

# Run check with detailed output
wp plugin check my-plugin-slug --format=table

# Run check and save to file
wp plugin check my-plugin-slug --format=json > plugin-check-results.json

# Run only specific categories
wp plugin check my-plugin-slug --categories=security,general

# Exclude specific checks (use with caution)
wp plugin check my-plugin-slug --ignore-codes=late_escaping
```

### Via WordPress Admin

1. Go to **Plugins → Plugin Check** in your WordPress admin
2. Select your plugin from the dropdown
3. Click **Check it!**
4. Review results by category

### Via GitHub Actions (CI/CD)

```yaml
name: Plugin Check
on: [push, pull_request]

jobs:
  plugin-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Plugin Check
        uses: wordpress/plugin-check-action@v1
        with:
          build-dir: ./your-plugin
```

## Common Errors and Fixes

### Error: `late_escaping`
**Message:** Output is not escaped at the point of output.

**Fix:**
```php
// ❌
echo $variable;
// ✅
echo esc_html( $variable );
```

### Error: `no_direct_access`
**Message:** Missing direct access check.

**Fix:** Add to every PHP file:
```php
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
```

### Error: `missing_textdomain`
**Message:** Translatable string missing text domain.

**Fix:**
```php
// ❌
__( 'Save Settings' );
// ✅
__( 'Save Settings', 'my-plugin' );
```

### Error: `incorrect_textdomain`
**Message:** Text domain does not match plugin slug.

**Fix:** Ensure the text domain in all `__()`, `_e()`, `esc_html__()` etc. calls matches exactly the plugin slug (directory name).

### Error: `version_mismatch`
**Message:** Version in plugin header does not match Stable tag in readme.txt.

**Fix:** Make both values identical:
```
# Plugin header
Version: 1.2.0

# readme.txt
Stable tag: 1.2.0
```

### Error: `stable_tag_trunk`
**Message:** Stable tag is set to "trunk".

**Fix:**
```
# ❌
Stable tag: trunk

# ✅
Stable tag: 1.0.0
```

### Error: `enqueue_no_in_footer`
**Message:** Scripts should be enqueued in the footer when possible.

**Fix:**
```php
// ❌
wp_enqueue_script( 'my-script', $url, [], '1.0.0', false );

// ✅
wp_enqueue_script( 'my-script', $url, [], '1.0.0', true ); // true = footer
```

### Error: `enqueue_scripts_in_wrong_hook`
**Message:** Scripts enqueued outside of `wp_enqueue_scripts` or `admin_enqueue_scripts`.

**Fix:**
```php
// ❌ Enqueuing in init or template_redirect
add_action( 'init', function() {
    wp_enqueue_script( 'my-script', $url );
} );

// ✅ Use the correct hook
add_action( 'wp_enqueue_scripts', function() {
    wp_enqueue_script( 'my-script', $url );
} );
```

### Error: `wp_register_scripts_with_extra_steps`
**Message:** `wp_register_script()` should not be called in the body of the plugin.

**Fix:** Move all `wp_register_script()` and `wp_register_style()` calls inside a hook callback.

### Error: `deprecated_function_used`
**Message:** Using a deprecated WordPress function.

**Fix:** Replace with the recommended alternative shown in the error. Common ones:
- `the_permalink()` → `get_permalink()`
- `get_bloginfo('url')` → `home_url()`
- `add_option_whitelist()` → `add_allowed_options()`

### Error: `readme_missing`
**Message:** readme.txt is missing or cannot be parsed.

**Fix:** Create a valid `readme.txt` in the plugin root directory.

## Running Plugin Check Before Submission

Recommended workflow:

```bash
# 1. Install Plugin Check in your local WP installation
wp plugin install plugin-check --activate

# 2. Run the check
wp plugin check your-plugin-slug --format=table 2>&1 | tee plugin-check-report.txt

# 3. Review all errors (not just warnings)
grep "ERROR" plugin-check-report.txt

# 4. Fix all errors, re-run until clean
# 5. Then address warnings
```

## Resources

- **Plugin Check on WordPress.org:** https://wordpress.org/plugins/plugin-check/
- **Plugin Check GitHub:** https://github.com/WordPress/plugin-check
- **Plugin Check Docs:** https://developer.wordpress.org/plugins/wordpress-org/plugin-check/
- **Plugin Check Action (GitHub Actions):** https://github.com/WordPress/plugin-check-action
