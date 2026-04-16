# WordPress Security Checklist

A comprehensive security checklist for WordPress projects mapped to OWASP Top 10 and WordPress-specific concerns.

## OWASP Top 10 Mapped to WordPress

### A01:2021 – Broken Access Control

**WordPress Context:** Users accessing admin functions, editing others' posts, viewing private data

**Checklist:**
- [ ] All admin AJAX handlers check `current_user_can()` with appropriate capability
- [ ] REST API endpoints have proper `permission_callback` (NEVER `return true`)
- [ ] User can only edit their own content unless they have elevated permissions
- [ ] Nonces are verified on all state-changing operations
- [ ] File uploads check file types and user permissions
- [ ] Direct file access is prevented (`defined( 'ABSPATH' ) || exit;`)

**WordPress Functions to Use:**
```php
current_user_can( 'manage_options' )  // Check capabilities
is_user_logged_in()                    // Check authentication
wp_verify_nonce( $nonce, 'action' )   // Verify CSRF tokens
check_admin_referer( 'action' )       // Check referrer for admin actions
check_ajax_referer( 'action' )        // Check referrer for AJAX
```

---

### A02:2021 – Cryptographic Failures

**WordPress Context:** Passwords, API keys, encryption, data transmission

**Checklist:**
- [ ] Never store passwords in plain text (use WP's hashing)
- [ ] API keys stored in options are not exposed in frontend JS
- [ ] Sensitive data transmission uses HTTPS (check `is_ssl()`)
- [ ] Use `wp_generate_password()` for secure passwords
- [ ] Use `wp_hash()` or `wp_hash_password()` for hashing
- [ ] Never output API keys, tokens, or secrets in error messages

**WordPress Functions to Use:**
```php
wp_generate_password( 12, true, true )  // Generate secure password
wp_hash_password( $password )           // Hash passwords
wp_check_password( $password, $hash )   // Verify passwords
is_ssl()                                 // Check HTTPS
wp_hash( $data, 'nonce' )               // Hash data for integrity
```

---

### A03:2021 – Injection

**WordPress Context:** SQL injection, command injection, LDAP injection

**Checklist:**
- [ ] All database queries use `$wpdb->prepare()` with placeholders
- [ ] Never concatenate user input directly into SQL queries
- [ ] File paths from user input are validated with `validate_file()`
- [ ] Shell commands (if any) use `escapeshellarg()` and `escapeshellcmd()`
- [ ] LDAP queries escape user input properly

**WordPress Functions to Use:**
```php
global $wpdb;
$wpdb->prepare( "SELECT * FROM table WHERE id = %d", $id );
// Placeholders: %d (integer), %s (string), %f (float)

validate_file( $file )        // Validate file paths
sanitize_file_name( $name )   // Sanitize filenames
path_join( $base, $path )     // Safely join paths
```

**Bad (Vulnerable):**
```php
$wpdb->query( "SELECT * FROM table WHERE name = '$name'" );  // NEVER DO THIS
```

**Good (Secure):**
```php
$wpdb->get_results( $wpdb->prepare( "SELECT * FROM table WHERE name = %s", $name ) );
```

---

### A04:2021 – Insecure Design

**WordPress Context:** Missing security controls, weak architecture

**Checklist:**
- [ ] Security is considered in initial design, not added later
- [ ] Principle of least privilege: users have minimum necessary permissions
- [ ] Defense in depth: multiple layers of security (nonce + capability + sanitization)
- [ ] Fail securely: errors don't leak sensitive information
- [ ] Rate limiting on sensitive operations (login, password reset, API calls)
- [ ] Logging of security-relevant events (failed logins, permission denials)

**WordPress Patterns:**
```php
// Defense in depth example
function handle_sensitive_action() {
    // Layer 1: Authentication
    if ( ! is_user_logged_in() ) {
        wp_send_json_error( 'Not authenticated', 401 );
    }

    // Layer 2: CSRF protection
    check_ajax_referer( 'my_action', 'nonce' );

    // Layer 3: Authorization
    if ( ! current_user_can( 'manage_options' ) ) {
        wp_send_json_error( 'Insufficient permissions', 403 );
    }

    // Layer 4: Input validation
    $id = absint( $_POST['id'] );
    if ( ! $id ) {
        wp_send_json_error( 'Invalid ID', 400 );
    }

    // Now proceed with action
}
```

---

### A05:2021 – Security Misconfiguration

**WordPress Context:** Debug mode in production, file permissions, default settings

**Checklist:**
- [ ] `WP_DEBUG` is `false` in production
- [ ] `WP_DEBUG_DISPLAY` is `false` in production
- [ ] `WP_DEBUG_LOG` logs to a file outside web root (if enabled)
- [ ] Database table prefix is not default `wp_`
- [ ] Security keys and salts in wp-config.php are unique (not defaults)
- [ ] File permissions: 644 for files, 755 for directories, 600 for wp-config.php
- [ ] Unused plugins and themes are deleted (not just deactivated)
- [ ] WordPress, plugins, and themes are kept up to date

**WordPress Security Keys:**
```php
// In wp-config.php, use unique values from:
// https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
// ... etc
```

---

### A06:2021 – Vulnerable and Outdated Components

**WordPress Context:** Old WordPress core, plugins, themes, libraries

**Checklist:**
- [ ] WordPress core is latest stable version
- [ ] All plugins are updated to latest versions
- [ ] All themes are updated to latest versions
- [ ] Third-party libraries (npm packages, Composer packages) are updated
- [ ] Unused/abandoned plugins are removed
- [ ] Security advisories are monitored (WPScan, Plugin Check, etc.)

---

### A07:2021 – Identification and Authentication Failures

**WordPress Context:** Weak passwords, session management, brute force

**Checklist:**
- [ ] Strong password Capability enforced (use filters like `wp_authenticate_user`)
- [ ] Brute force protection on login (rate limiting, CAPTCHA, or plugin)
- [ ] Password reset tokens expire and are single-use
- [ ] Sessions invalidate on logout
- [ ] "Remember me" uses secure, httponly cookies
- [ ] Two-factor authentication available (plugin or custom)

**WordPress Functions:**
```php
wp_set_auth_cookie( $user_id, $remember )   // Set auth cookie
wp_logout()                                  // Clear auth and destroy session
wp_set_password( $password, $user_id )      // Update password
```

---

### A08:2021 – Software and Data Integrity Failures

**WordPress Context:** Plugin/theme updates, data validation, deserialization

**Checklist:**
- [ ] Plugins and themes installed from trusted sources only
- [ ] Updates are digitally signed (WordPress.org handles this)
- [ ] User input is never unserialized without validation
- [ ] Avoid `unserialize()` on user-controlled data (use `maybe_unserialize()` with caution)
- [ ] JSON is preferred over serialized data for new features
- [ ] File uploads are validated for type, size, and content

**WordPress Functions:**
```php
maybe_unserialize( $data )    // Safely unserialize WP data
wp_unslash( $_POST['data'] )  // Remove slashes added by WP
wp_check_filetype( $file )    // Validate file type
```

---

### A09:2021 – Security Logging and Monitoring Failures

**WordPress Context:** Failed login attempts, suspicious activity, errors

**Checklist:**
- [ ] Failed login attempts are logged
- [ ] Admin actions (plugin activation, user creation, etc.) are logged
- [ ] Suspicious file changes are monitored
- [ ] Error logs are regularly reviewed
- [ ] Logs don't contain sensitive data (passwords, API keys, PII)
- [ ] Log files are not accessible via web (outside web root or protected)

**WordPress Logging:**
```php
// Enable debug logging
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );

// Custom logging
if ( WP_DEBUG ) {
    error_log( 'Security event: ' . $message );
}
```

---

### A10:2021 – Server-Side Request Forgery (SSRF)

**WordPress Context:** HTTP API calls, webhook handling, remote file fetching

**Checklist:**
- [ ] User-supplied URLs are validated before making HTTP requests
- [ ] Whitelist allowed domains for remote requests
- [ ] Use `wp_safe_remote_get()` instead of raw cURL
- [ ] Validate response content type before processing
- [ ] Don't expose raw error messages from remote requests

**WordPress Functions:**
```php
wp_safe_remote_get( $url, $args )      // Safely fetch remote URL
wp_safe_remote_post( $url, $args )     // Safely POST to remote URL
wp_http_validate_url( $url )            // Validate URL format
esc_url_raw( $url )                     // Sanitize URL
```

**Good Pattern:**
```php
$url = esc_url_raw( $_POST['webhook_url'] );

// Whitelist check
$allowed_domains = array( 'example.com', 'trusted-api.com' );
$parsed = parse_url( $url );
if ( ! in_array( $parsed['host'], $allowed_domains, true ) ) {
    return new WP_Error( 'invalid_domain', 'Domain not allowed' );
}

$response = wp_safe_remote_post( $url, array(
    'timeout' => 10,
    'body'    => $data,
) );

if ( is_wp_error( $response ) ) {
    // Handle error without leaking details
    return new WP_Error( 'request_failed', 'Request failed' );
}
```

---

## WordPress-Specific Security Concerns

### Input Sanitization

**Always sanitize user input before saving to database:**

```php
sanitize_text_field( $input )        // Text input (strips tags, encodes)
sanitize_email( $email )              // Email addresses
sanitize_file_name( $filename )       // File names
sanitize_hex_color( $color )          // Hex colors (#fff)
sanitize_html_class( $class )         // CSS class names
sanitize_key( $key )                  // Alphanumeric keys
sanitize_textarea_field( $text )      // Textarea (preserves line breaks)
sanitize_title( $title )              // Slugs/titles
sanitize_url( $url )                  // URLs (alias: esc_url_raw)
wp_kses( $html, $allowed_tags )      // HTML (specify allowed tags)
wp_kses_post( $html )                // HTML (allows post-safe tags)
absint( $number )                     // Absolute integer (always >= 0)
intval( $number )                     // Integer (can be negative)
floatval( $number )                   // Float
```

### Output Escaping

**Always escape dynamic output:**

```php
esc_html( $text )             // HTML output (< becomes &lt;)
esc_attr( $value )             // HTML attributes
esc_url( $url )                // URLs in links/redirects
esc_js( $string )              // JavaScript strings
esc_sql( $data )               // SQL (prefer $wpdb->prepare())
esc_textarea( $text )          // Textarea values
wp_kses_post( $html )         // HTML (allows safe tags)
wp_json_encode( $data )       // JSON encoding (safe for <script>)
```

**Context matters:**

```php
// In HTML
echo '<p>' . esc_html( $user_input ) . '</p>';

// In attribute
echo '<div class="' . esc_attr( $class ) . '">';

// In URL
echo '<a href="' . esc_url( $link ) . '">';

// In JavaScript
echo '<script>var name = "' . esc_js( $name ) . '";</script>';

// In JSON (use wp_json_encode, NOT json_encode)
echo '<script>var data = ' . wp_json_encode( $data ) . ';</script>';
```

### Nonces (CSRF Protection)

**Always verify nonces on state-changing operations:**

```php
// Creating a nonce
$nonce = wp_create_nonce( 'my_action' );

// In a URL
$url = wp_nonce_url( $url, 'my_action' );

// In a form field
wp_nonce_field( 'my_action', 'my_nonce' );

// Verifying in form handler
if ( ! isset( $_POST['my_nonce'] ) || ! wp_verify_nonce( $_POST['my_nonce'], 'my_action' ) ) {
    wp_die( 'Security check failed' );
}

// Verifying in admin action
check_admin_referer( 'my_action' );

// Verifying in AJAX
check_ajax_referer( 'my_action', 'nonce' );
```

### Capability Checks

**Always check user capabilities:**

```php
// Common capabilities
'read'                  // Subscriber
'edit_posts'            // Contributor
'publish_posts'         // Author
'edit_pages'            // Editor
'manage_options'        // Administrator
'manage_network'        // Super Admin (multisite)

// Check capability
if ( ! current_user_can( 'manage_options' ) ) {
    wp_die( 'Insufficient permissions' );
}

// Check for specific post
if ( ! current_user_can( 'edit_post', $post_id ) ) {
    wp_die( 'Cannot edit this post' );
}
```

### REST API Security

**Always define permission_callback:**

```php
register_rest_route( 'myplugin/v1', '/data', array(
    'methods'             => WP_REST_Server::READABLE,
    'callback'            => 'my_callback',
    'permission_callback' => function() {
        return current_user_can( 'edit_posts' );
    },
    'args' => array(
        'id' => array(
            'validate_callback' => function( $param ) {
                return is_numeric( $param );
            },
            'sanitize_callback' => 'absint',
        ),
    ),
) );
```

### AJAX Security

**Always verify nonces and capabilities:**

```php
add_action( 'wp_ajax_my_action', 'my_ajax_handler' );
// Only for logged-in users
// For public AJAX, also add: add_action( 'wp_ajax_nopriv_my_action', 'my_ajax_handler' );

function my_ajax_handler() {
    // 1. Verify nonce
    check_ajax_referer( 'my_action_nonce', 'nonce' );

    // 2. Check capability
    if ( ! current_user_can( 'edit_posts' ) ) {
        wp_send_json_error( 'Insufficient permissions', 403 );
    }

    // 3. Sanitize input
    $data = sanitize_text_field( $_POST['data'] );

    // 4. Process
    $result = do_something( $data );

    // 5. Return
    wp_send_json_success( $result );
}
```

### Database Security

**Always use prepared statements:**

```php
global $wpdb;

// Good
$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}table WHERE id = %d AND status = %s",
    $id,
    $status
) );

// Bad - NEVER DO THIS
$results = $wpdb->get_results( "SELECT * FROM {$wpdb->prefix}table WHERE id = $id" );
```

### File Upload Security

**Always validate file uploads:**

```php
// Check file type
$filetype = wp_check_filetype( $filename, $allowed_mimes );
if ( ! $filetype['ext'] ) {
    return new WP_Error( 'invalid_file', 'Invalid file type' );
}

// Check file size
if ( $filesize > $max_size ) {
    return new WP_Error( 'file_too_large', 'File too large' );
}

// Use wp_handle_upload() which does security checks
$uploaded = wp_handle_upload( $_FILES['file'], array( 'test_form' => false ) );
```

## Quick Security Audit Checklist

Use this when reviewing code for security issues:

### Authentication
- [ ] User is logged in where required (`is_user_logged_in()`)
- [ ] Session handling is secure

### Authorization
- [ ] Capabilities are checked (`current_user_can()`)
- [ ] Users can only access their own data

### CSRF Protection
- [ ] Nonces are used for all state changes
- [ ] Nonces are verified on the backend

### Input Validation & Sanitization
- [ ] All user input is sanitized before saving
- [ ] Input validation rejects invalid data
- [ ] File uploads are validated

### Output Escaping
- [ ] All dynamic output is escaped
- [ ] Correct escaping function for context (html, attr, url, js)

### SQL Security
- [ ] All queries use `$wpdb->prepare()`
- [ ] No direct concatenation of user input

### Error Handling
- [ ] Errors don't leak sensitive information
- [ ] Error messages are user-friendly

### Configuration
- [ ] Debug mode is off in production
- [ ] Security keys are unique
- [ ] Unnecessary features are disabled

---

## Additional Resources

- [WordPress.org Plugin Handbook: Security](https://developer.wordpress.org/plugins/security/)
- [WordPress Codex: Hardening WordPress](https://wordpress.org/support/article/hardening-wordpress/)
- [OWASP WordPress Security Guide](https://owasp.org/www-project-wordpress-security/)
- [WPScan Vulnerability Database](https://wpscan.com/wordpresses)

