# WordPress.org Compliance & Security Standards

This guide covers WordPress.org plugin/theme compliance requirements and security standards. Following these guidelines ensures your security fixes meet WordPress.org review standards and security best practices.

---

## Overview

**Why Compliance Matters:**
- Required for WordPress.org submission/approval
- Prevents common security vulnerabilities
- Ensures compatibility with WordPress ecosystem
- Protects user data and site integrity
- Builds trust with WordPress community

**Key Areas:**
1. Prefix requirements
2. Direct access prevention
3. Third-party library vetting
4. Uninstall cleanup
5. Internationalization (i18n) security
6. Data validation & sanitization
7. Nonce verification
8. Output escaping

---

## 1. Prefix Requirements

**Requirement:** All functions, classes, constants, and global variables MUST use a unique prefix.

**Why:** Prevents naming collisions with other plugins/themes or WordPress core.

### Functions

```php
// ❌ WRONG - No prefix
function get_user_data() {
    // This could conflict with other plugins
}

// ✅ CORRECT - Prefixed
function myplugin_get_user_data() {
    // Unique to your plugin
}
```

### Classes

```php
// ❌ WRONG - Generic name
class Settings {
    // Likely to conflict
}

// ✅ CORRECT - Prefixed
class MyPlugin_Settings {
    // Unique namespace
}

// ✅ BEST - PHP namespace
namespace MyPlugin;
class Settings {
    // Even better
}
```

### Constants

```php
// ❌ WRONG - Generic constant
define( 'VERSION', '1.0.0' );

// ✅ CORRECT - Prefixed
define( 'MYPLUGIN_VERSION', '1.0.0' );
```

### Global Variables

```php
// ❌ WRONG - Generic global
global $settings;

// ✅ CORRECT - Prefixed
global $myplugin_settings;
```

### Database Tables

```php
// ❌ WRONG - No prefix
$table = $wpdb->prefix . 'data';

// ✅ CORRECT - Plugin prefix + WP prefix
$table = $wpdb->prefix . 'myplugin_data';
```

### Hooks (Actions & Filters)

```php
// ✅ CORRECT - Always prefix custom hooks
do_action( 'myplugin_after_save', $data );
apply_filters( 'myplugin_data', $data );
```

**Checklist:**
- [ ] All functions prefixed or namespaced
- [ ] All classes prefixed or namespaced
- [ ] All constants prefixed
- [ ] All global variables prefixed
- [ ] Database tables use plugin prefix + WP prefix
- [ ] Custom hooks use plugin prefix

---

## 2. Direct Access Prevention

**Requirement:** Plugin/theme files must not be directly accessible via URL.

**Why:** Prevents unauthorized direct execution of PHP files.

### Standard Check

Add to **every PHP file**:

```php
<?php
// Prevent direct access
if ( ! defined( 'ABSPATH' ) ) {
    exit; // Exit if accessed directly
}

// Or more verbose version:
if ( ! defined( 'WPINC' ) ) {
    die;
}
```

### Alternative Methods

```php
// Method 1: Check for WordPress environment
defined( 'ABSPATH' ) || exit;

// Method 2: Check for specific constant
if ( ! defined( 'MYPLUGIN_VERSION' ) ) {
    return;
}

// Method 3: Function exists check (for includes)
if ( ! function_exists( 'add_action' ) ) {
    exit;
}
```

### .htaccess Protection (Optional Additional Layer)

```apache
# In your plugin directory
<Files *.php>
    Order allow,deny
    Deny from all
</Files>

# Allow only specific entry files
<Files index.php>
    Allow from all
</Files>
```

**Checklist:**
- [ ] All PHP files have ABSPATH check
- [ ] Check is at the very top of the file (after `<?php`)
- [ ] Consistent across all files
- [ ] No PHP files directly executable

---

## 3. Third-Party Library Vetting

**Requirement:** Third-party libraries must be vetted for security and licensing.

**Why:** Vulnerable libraries can compromise your plugin and user sites.

### Library Checklist

Before including any third-party library:

**Security:**
- [ ] Library is actively maintained (last update <6 months)
- [ ] No known CVEs or security issues
- [ ] Library has good security track record
- [ ] Library source code reviewed
- [ ] Dependencies are also secure

**Licensing:**
- [ ] License is GPL-compatible (GPL, MIT, BSD, Apache 2.0)
- [ ] License documented in readme
- [ ] Attribution provided where required

**Best Practices:**
- [ ] Library is necessary (can't use WordPress native alternative?)
- [ ] Library is from reputable source
- [ ] Library version is pinned (not "latest")
- [ ] Library is included in plugin (not loaded from CDN)
- [ ] Library files are prefixed to avoid conflicts

### WordPress Native Alternatives

**Before adding a library, check if WordPress provides equivalent functionality:**

| Need | Library | WordPress Native Alternative |
|------|---------|------------------------------|
| HTTP Requests | Guzzle, cURL | `wp_remote_get()`, `wp_remote_post()` |
| JSON handling | Custom parser | `wp_json_encode()`, `json_decode()` |
| Image manipulation | Imagick | `wp_get_image_editor()` |
| Cron jobs | Custom scheduler | `wp_schedule_event()` |
| Database queries | PDO, MySQLi | `$wpdb->prepare()` |
| File uploads | Custom handler | `wp_handle_upload()` |
| Email sending | PHPMailer (OK) | `wp_mail()` (uses PHPMailer) |
| Sanitization | Custom | `sanitize_*()` functions |
| Escaping | Custom | `esc_*()` functions |

### Prefixing Third-Party Code

If you must include a library, prefix it to avoid conflicts:

```php
// Original library namespace
namespace Vendor\Library;

// Prefix it
namespace MyPlugin\Vendor\Library;
```

Or use tools like:
- PHP-Scoper (for PHP libraries)
- Webpack aliasing (for JS libraries)

### Declaring Dependencies

Document all third-party code in readme:

```markdown
## Third-Party Libraries

This plugin includes the following third-party libraries:

1. **Library Name** (v1.2.3)
   - License: MIT
   - Source: https://github.com/vendor/library
   - Purpose: HTTP client for API requests
   - Security: No known vulnerabilities (checked 2026-02-07)
```

**Checklist:**
- [ ] All third-party code documented
- [ ] Licenses verified as GPL-compatible
- [ ] Security checked (no CVEs)
- [ ] WordPress native alternatives considered first
- [ ] Libraries prefixed to avoid conflicts
- [ ] Library versions pinned

---

## 4. Uninstall Cleanup

**Requirement:** Plugins must clean up after themselves when uninstalled.

**Why:** Leaving data behind clutters databases and can cause security issues.

### Uninstall Script

Create `uninstall.php` in plugin root:

```php
<?php
/**
 * Uninstall script
 * Fired when plugin is uninstalled (not just deactivated)
 */

// Prevent direct access
if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
    exit;
}

// Delete options
delete_option( 'myplugin_settings' );
delete_option( 'myplugin_version' );

// Delete transients
delete_transient( 'myplugin_cache' );

// Delete user meta
delete_metadata( 'user', 0, 'myplugin_preference', '', true );

// Delete post meta
delete_post_meta_by_key( 'myplugin_data' );

// Drop custom tables
global $wpdb;
$table_name = $wpdb->prefix . 'myplugin_data';
$wpdb->query( "DROP TABLE IF EXISTS {$table_name}" );

// Clear scheduled hooks
wp_clear_scheduled_hook( 'myplugin_daily_task' );

// Delete uploaded files (be careful!)
$upload_dir = wp_upload_dir();
$plugin_dir = $upload_dir['basedir'] . '/myplugin/';
if ( is_dir( $plugin_dir ) ) {
    // Only delete if it's definitely your plugin's directory
    // Consider leaving user-uploaded files
}
```

### What to Clean Up

**Always Delete:**
- [ ] Plugin options (`delete_option()`)
- [ ] Plugin transients (`delete_transient()`)
- [ ] Scheduled cron jobs (`wp_clear_scheduled_hook()`)
- [ ] Custom database tables (if appropriate)

**Consider Keeping:**
- [ ] User-generated content (posts, comments)
- [ ] User-uploaded files
- [ ] Data that might be needed by other plugins

**Ask User:**
Some plugins offer a setting: "Delete all data on uninstall?" (default: NO)

```php
// Check user preference before deleting
$delete_data = get_option( 'myplugin_delete_on_uninstall', false );

if ( $delete_data ) {
    // Delete everything
    delete_option( 'myplugin_settings' );
    // ... etc
}
```

### Multisite Cleanup

For multisite, clean up network-wide data:

```php
if ( is_multisite() ) {
    global $wpdb;

    // Get all blog IDs
    $blog_ids = $wpdb->get_col( "SELECT blog_id FROM {$wpdb->blogs}" );

    foreach ( $blog_ids as $blog_id ) {
        switch_to_blog( $blog_id );

        // Delete options for this blog
        delete_option( 'myplugin_settings' );

        restore_current_blog();
    }

    // Delete network-wide options
    delete_site_option( 'myplugin_network_settings' );
}
```

**Checklist:**
- [ ] `uninstall.php` exists
- [ ] ABSPATH check at top
- [ ] All plugin options deleted
- [ ] All transients deleted
- [ ] Scheduled hooks cleared
- [ ] Custom tables dropped (if appropriate)
- [ ] Multisite cleanup handled
- [ ] User preference for data deletion (optional)

---

## 5. Internationalization (i18n) Security

**Requirement:** All user-facing strings must be internationalization-ready AND properly escaped.

**Why:** Translated strings can contain malicious code if not escaped.

### Correct i18n + Escaping

```php
// ❌ WRONG - Not escaped
echo __( 'Welcome, User', 'myplugin' );

// ✅ CORRECT - Escaped for HTML context
echo esc_html__( 'Welcome, User', 'myplugin' );

// ✅ CORRECT - Escaped for attribute context
echo '<div title="' . esc_attr__( 'Welcome', 'myplugin' ) . '">';

// ✅ CORRECT - Escaped with placeholders
echo esc_html( sprintf(
    __( 'Welcome, %s', 'myplugin' ),
    $user_name
) );

// ❌ WRONG - Variable not escaped
echo esc_html__( "Welcome, {$user_name}", 'myplugin' );

// ✅ CORRECT - Variable escaped separately
echo esc_html( sprintf(
    __( 'Welcome, %s', 'myplugin' ),
    $user_name // WordPress will escape this in the sprintf context, but better to be explicit
) );
```

### Translation Functions with Escaping

WordPress provides combined translation + escaping functions:

```php
// HTML context
esc_html__( $text, $domain );           // Returns translated & escaped string
esc_html_e( $text, $domain );           // Echoes translated & escaped string
esc_html_x( $text, $context, $domain ); // With context

// Attribute context
esc_attr__( $text, $domain );
esc_attr_e( $text, $domain );
esc_attr_x( $text, $context, $domain );

// URL context
esc_url( __( $text, $domain ) );

// For admin notices
wp_kses_post( __( $text, $domain ) );
```

### Pluralization with Security

```php
// ❌ WRONG - Not escaped
echo sprintf(
    _n( '%d item', '%d items', $count, 'myplugin' ),
    $count
);

// ✅ CORRECT - Escaped
echo esc_html( sprintf(
    _n( '%d item', '%d items', $count, 'myplugin' ),
    number_format_i18n( $count )
) );
```

### JavaScript i18n

```php
// Enqueue script with translations
wp_enqueue_script( 'myplugin-script', plugins_url( 'js/script.js', __FILE__ ), array( 'wp-i18n' ), '1.0.0', true );
wp_set_script_translations( 'myplugin-script', 'myplugin' );
```

```javascript
// In JavaScript file
import { __ } from '@wordpress/i18n';

// ✅ Escaped automatically in React
<p>{ __( 'Welcome, User', 'myplugin' ) }</p>

// ❌ If using vanilla JS, sanitize user input
const message = __( 'Welcome', 'myplugin' );
element.textContent = message; // Safe (textContent auto-escapes)
element.innerHTML = message;   // UNSAFE if message contains HTML
```

**Checklist:**
- [ ] All strings use text domain
- [ ] Translation functions include escaping (`esc_html__()`, not `__()`)
- [ ] Variables never inside translatable strings
- [ ] Placeholders used for variables (`sprintf` pattern)
- [ ] Numbers escaped with `number_format_i18n()`
- [ ] JS translations properly enqueued

---

## 6. Security Best Practices Summary

### Input Validation

```php
// Always validate input type and format
$user_id = isset( $_POST['user_id'] ) ? absint( $_POST['user_id'] ) : 0;

if ( ! $user_id ) {
    wp_send_json_error( 'Invalid user ID', 400 );
}
```

### Sanitization

```php
// Always sanitize before saving
$text = sanitize_text_field( wp_unslash( $_POST['text'] ?? '' ) );
$email = sanitize_email( wp_unslash( $_POST['email'] ?? '' ) );
$url = esc_url_raw( wp_unslash( $_POST['url'] ?? '' ) );
```

### Output Escaping

```php
// Always escape before output
echo esc_html( $user_input );
echo '<a href="' . esc_url( $link ) . '">' . esc_html( $title ) . '</a>';
echo '<input value="' . esc_attr( $value ) . '" />';
```

### Nonce Verification

```php
// Always verify nonces for state-changing operations
if ( ! wp_verify_nonce( $_POST['nonce'] ?? '', 'myplugin-action' ) ) {
    wp_send_json_error( 'Invalid security token', 403 );
}
```

### Capability Checks

```php
// Always check user capabilities
if ( ! current_user_can( 'manage_options' ) ) {
    wp_send_json_error( 'Insufficient permissions', 403 );
}
```

### SQL Queries

```php
// Always use prepared statements
$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}myplugin_table WHERE id = %d",
    $id
) );
```

---

## 7. WordPress.org Specific Requirements

### Required Files

- [ ] `readme.txt` (with proper format)
- [ ] `LICENSE` or `license.txt` (GPL v2 or later)
- [ ] `uninstall.php` (if plugin stores data)

### Forbidden Practices

**❌ DO NOT:**
- Use `eval()`, `create_function()`, or `assert()`
- Use `extract()` on user input
- Use `call_user_func()` with user input
- Include external scripts/files from CDN in admin
- Use `@` error suppression extensively
- Disable WordPress security features
- Phone home without user consent
- Obfuscate code
- Include cryptominers or similar malware
- Track users without explicit consent

**✅ DO:**
- Use WordPress APIs and functions
- Follow WordPress coding standards
- Escape all output
- Sanitize all input
- Use nonces for forms
- Check user capabilities
- Use prepared SQL statements
- Document your code

### Plugin Headers

Required headers in main plugin file:

```php
<?php
/**
 * Plugin Name: My Plugin
 * Plugin URI: https://example.com/my-plugin
 * Description: Brief description
 * Version: 1.0.0
 * Requires at least: 5.9
 * Requires PHP: 7.4
 * Author: Your Name
 * Author URI: https://example.com
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: myplugin
 * Domain Path: /languages
 */
```

---

## 8. Security Review Checklist

Before submitting to WordPress.org or deploying a security fix:

### Code Security
- [ ] All functions/classes prefixed or namespaced
- [ ] Direct access prevented (ABSPATH check)
- [ ] No `eval()`, `create_function()`, or `assert()`
- [ ] No `extract()` on untrusted data
- [ ] SQL queries use `$wpdb->prepare()`
- [ ] All user input sanitized
- [ ] All output escaped
- [ ] Nonces verified on forms/AJAX
- [ ] Capabilities checked on admin actions
- [ ] File uploads validated (type, size, extension)
- [ ] No hardcoded credentials

### WordPress.org Compliance
- [ ] Unique prefix used throughout
- [ ] GPL-compatible license
- [ ] Third-party libraries documented
- [ ] Uninstall cleanup implemented
- [ ] i18n ready (all strings translatable)
- [ ] Translation strings properly escaped
- [ ] No external dependencies loaded from CDN
- [ ] No tracking without consent
- [ ] No cryptocurrency miners
- [ ] No obfuscated code

### Best Practices
- [ ] WordPress coding standards followed
- [ ] Code is readable and maintainable
- [ ] Inline comments for complex logic
- [ ] PHPDoc blocks for functions/classes
- [ ] No deprecated WordPress functions
- [ ] Minimum WordPress version specified
- [ ] Minimum PHP version specified
- [ ] Backwards compatibility maintained

---

## 9. Common WordPress.org Rejection Reasons

**Top reasons plugins get rejected:**

1. **Generic function/class names** - Must be prefixed
2. **No ABSPATH check** - Direct access not prevented
3. **Unsanitized input** - User input used without sanitization
4. **Unescaped output** - Data output without escaping
5. **Calling external files** - Loading scripts from CDN
6. **Using eval()** - Forbidden function
7. **Including exploitable files** - Shells, backdoors
8. **Phone home** - Unauthorized data collection
9. **No uninstall.php** - Not cleaning up data
10. **GPL violation** - Non-GPL compatible license

---

## 10. Additional Resources

- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/)
- [Plugin Review Guidelines](https://developer.wordpress.org/plugins/wordpress-org/detailed-plugin-guidelines/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/)
- [Security Best Practices](https://developer.wordpress.org/apis/security/)
- [WordPress.org Plugin Review Team](https://make.wordpress.org/plugins/)
- [Common Guideline Violations](https://developer.wordpress.org/plugins/wordpress-org/common-issues/)
