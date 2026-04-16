# Common WordPress Vulnerabilities

This document catalogs common vulnerability patterns found in WordPress plugins and themes, with real-world examples and fixes.

## 1. Missing or Weak permission_callback in REST API

### Description
REST API endpoints without proper `permission_callback` allow unauthenticated users to access or modify data.

### Vulnerable Pattern

```php
register_rest_route( 'myplugin/v1', '/sensitive-data', array(
    'methods'             => 'GET',
    'callback'            => 'get_sensitive_data',
    'permission_callback' => '__return_true',  // BAD!
) );
```

### Fix

```php
register_rest_route( 'myplugin/v1', '/sensitive-data', array(
    'methods'             => 'GET',
    'callback'            => 'get_sensitive_data',
    'permission_callback' => function() {
        return current_user_can( 'manage_options' );
    },
) );
```

### Impact
- **CVSS Score**: 7.5-9.0 (High to Critical)
- **Attack Vector**: Network, no authentication required
- **Common Exploits**: Data theft, privilege escalation, data manipulation

### How to Find
```bash
grep -r "permission_callback.*__return_true" .
grep -r "register_rest_route" . | grep -v "permission_callback"
```

---

## 2. Missing Nonce Verification in AJAX

### Description
AJAX handlers without nonce verification are vulnerable to Cross-Site Request Forgery (CSRF).

### Vulnerable Pattern

```php
add_action( 'wp_ajax_delete_item', 'delete_item_handler' );

function delete_item_handler() {
    // No nonce check!
    $id = intval( $_POST['id'] );
    wp_delete_post( $id );
    wp_send_json_success();
}
```

### Fix

```php
add_action( 'wp_ajax_delete_item', 'delete_item_handler' );

function delete_item_handler() {
    // Verify nonce first
    check_ajax_referer( 'delete_item_nonce', 'nonce' );

    // Then check capability
    if ( ! current_user_can( 'delete_posts' ) ) {
        wp_send_json_error( 'Insufficient permissions', 403 );
    }

    $id = intval( $_POST['id'] );
    wp_delete_post( $id );
    wp_send_json_success();
}
```

### Impact
- **CVSS Score**: 6.5-8.0 (Medium to High)
- **Attack Vector**: Requires victim to be logged in and tricked into visiting attacker's site
- **Common Exploits**: Unauthorized actions, data deletion, settings changes

### How to Find
```bash
grep -r "wp_ajax_" . | grep "function"
# Then manually check each function for check_ajax_referer()
```

---

## 3. Missing Capability Checks

### Description
Admin functions accessible without proper capability checks allow privilege escalation.

### Vulnerable Pattern

```php
add_action( 'wp_ajax_update_settings', 'update_settings' );

function update_settings() {
    check_ajax_referer( 'settings_nonce', 'nonce' );

    // Nonce check is good, but no capability check!
    update_option( 'my_settings', $_POST['settings'] );
    wp_send_json_success();
}
```

### Fix

```php
add_action( 'wp_ajax_update_settings', 'update_settings' );

function update_settings() {
    check_ajax_referer( 'settings_nonce', 'nonce' );

    // Add capability check
    if ( ! current_user_can( 'manage_options' ) ) {
        wp_send_json_error( 'Insufficient permissions', 403 );
    }

    update_option( 'my_settings', $_POST['settings'] );
    wp_send_json_success();
}
```

### Impact
- **CVSS Score**: 7.0-8.5 (High)
- **Attack Vector**: Authenticated users (even low-privilege) can access admin functions
- **Common Exploits**: Settings manipulation, privilege escalation, site configuration changes

### How to Find
Look for state-changing operations without `current_user_can()`:
- `update_option()`
- `delete_option()`
- `wp_insert_post()`
- `wp_update_post()`
- `wp_delete_post()`

---

## 4. SQL Injection via Unsanitized Input

### Description
Database queries with unsanitized user input allow SQL injection attacks.

### Vulnerable Pattern

```php
global $wpdb;

$search = $_GET['search'];
$results = $wpdb->get_results(
    "SELECT * FROM {$wpdb->prefix}table WHERE name LIKE '%$search%'"
);
```

### Fix

```php
global $wpdb;

$search = sanitize_text_field( $_GET['search'] );
$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}table WHERE name LIKE %s",
    '%' . $wpdb->esc_like( $search ) . '%'
) );
```

### Impact
- **CVSS Score**: 9.0-10.0 (Critical)
- **Attack Vector**: Network, often unauthenticated
- **Common Exploits**: Database theft, data modification, authentication bypass, site takeover

### How to Find
```bash
# Find queries without prepare()
grep -r "\$wpdb->query(" .
grep -r "\$wpdb->get_results(" .
grep -r "WHERE.*\$_" .
```

---

## 5. Cross-Site Scripting (XSS) via Unescaped Output

### Description
Dynamic content displayed without escaping allows attackers to inject JavaScript.

### Vulnerable Pattern

```php
// In template file
<div class="user-bio">
    <?php echo $user_bio; ?> <!-- BAD! -->
</div>
```

### Fix

```php
// In template file
<div class="user-bio">
    <?php echo wp_kses_post( $user_bio ); ?> <!-- Allows safe HTML -->
    <!-- OR if no HTML should be allowed: -->
    <?php echo esc_html( $user_bio ); ?>
</div>
```

### Impact
- **CVSS Score**: 6.0-7.5 (Medium to High)
- **Attack Vector**: Stored XSS (persistent) or Reflected XSS (requires victim to click link)
- **Common Exploits**: Session hijacking, phishing, malware distribution, defacement

### Types of XSS

**Stored XSS:**
```php
// Saving without sanitization
update_post_meta( $post_id, 'custom_field', $_POST['custom_field'] );

// Displaying without escaping
echo get_post_meta( $post_id, 'custom_field', true ); // XSS!
```

**Reflected XSS:**
```php
// URL: ?name=<script>alert('XSS')</script>
echo 'Hello, ' . $_GET['name']; // XSS!
```

### How to Find
```bash
# Find potentially unsafe echo/print statements
grep -rn "echo \$" .
grep -rn "print \$" .
grep -rn "<?= \$" .
```

---

## 6. Insecure Direct Object Reference (IDOR)

### Description
Functions that trust user-supplied IDs without verifying ownership.

### Vulnerable Pattern

```php
function delete_my_post() {
    check_ajax_referer( 'delete_nonce', 'nonce' );

    $post_id = intval( $_POST['post_id'] );

    // No ownership check! User can delete ANY post
    wp_delete_post( $post_id );

    wp_send_json_success();
}
```

### Fix

```php
function delete_my_post() {
    check_ajax_referer( 'delete_nonce', 'nonce' );

    $post_id = intval( $_POST['post_id'] );

    // Verify ownership or capability
    if ( ! current_user_can( 'delete_post', $post_id ) ) {
        wp_send_json_error( 'Cannot delete this post', 403 );
    }

    wp_delete_post( $post_id );
    wp_send_json_success();
}
```

### Impact
- **CVSS Score**: 6.5-8.0 (Medium to High)
- **Attack Vector**: Authenticated users accessing/modifying others' data
- **Common Exploits**: Data theft, unauthorized modifications, privacy violations

### How to Find
Look for functions that:
- Accept user-supplied IDs
- Don't verify the current user owns/can access that ID
- Use `get_post()`, `wp_delete_post()`, `update_post_meta()`, etc. without capability checks

---

## 7. Arbitrary File Upload

### Description
File upload functionality without proper validation allows malicious file uploads.

### Vulnerable Pattern

```php
if ( isset( $_FILES['file'] ) ) {
    // No validation!
    $upload_dir = wp_upload_dir();
    move_uploaded_file(
        $_FILES['file']['tmp_name'],
        $upload_dir['path'] . '/' . $_FILES['file']['name']
    );
}
```

### Fix

```php
if ( isset( $_FILES['file'] ) ) {
    // Check capability
    if ( ! current_user_can( 'upload_files' ) ) {
        wp_die( 'Insufficient permissions' );
    }

    // Validate file type
    $allowed_types = array( 'jpg', 'jpeg', 'png', 'gif' );
    $filetype = wp_check_filetype( $_FILES['file']['name'] );

    if ( ! in_array( $filetype['ext'], $allowed_types, true ) ) {
        wp_die( 'Invalid file type' );
    }

    // Check file size
    if ( $_FILES['file']['size'] > 2 * MB_IN_BYTES ) {
        wp_die( 'File too large' );
    }

    // Use WP's secure upload handler
    $uploaded = wp_handle_upload( $_FILES['file'], array( 'test_form' => false ) );

    if ( isset( $uploaded['error'] ) ) {
        wp_die( $uploaded['error'] );
    }
}
```

### Impact
- **CVSS Score**: 9.0-10.0 (Critical)
- **Attack Vector**: Authenticated or unauthenticated (depending on implementation)
- **Common Exploits**: Remote code execution, site takeover, malware hosting

### How to Find
```bash
grep -r "move_uploaded_file" .
grep -r "\$_FILES" .
grep -r "file_put_contents" .
```

---

## 8. Path Traversal

### Description
File operations using unsanitized user input allow access to arbitrary files.

### Vulnerable Pattern

```php
$file = $_GET['file'];
$content = file_get_contents( '/var/www/uploads/' . $file );
echo $content;
```

**Exploit:**
```
?file=../../../wp-config.php
```

### Fix

```php
$file = sanitize_file_name( $_GET['file'] );

// Validate the file is in allowed directory
$filepath = path_join( '/var/www/uploads/', $file );
$realpath = realpath( $filepath );

if ( ! $realpath || strpos( $realpath, '/var/www/uploads/' ) !== 0 ) {
    wp_die( 'Invalid file path' );
}

// Additional validation
if ( validate_file( $file ) !== 0 ) {
    wp_die( 'Invalid file' );
}

$content = file_get_contents( $realpath );
echo esc_html( $content );
```

### Impact
- **CVSS Score**: 7.5-9.0 (High to Critical)
- **Attack Vector**: Network, often unauthenticated
- **Common Exploits**: Reading sensitive files (wp-config.php, .env), source code disclosure

### How to Find
```bash
grep -r "file_get_contents.*\$_" .
grep -r "include.*\$_" .
grep -r "require.*\$_" .
```

---

## 9. Insecure Deserialization

### Description
Unserializing untrusted data can lead to object injection and remote code execution.

### Vulnerable Pattern

```php
$data = unserialize( $_POST['data'] );  // VERY DANGEROUS!
```

### Fix

```php
// Use JSON instead of PHP serialization
$data = json_decode( stripslashes( $_POST['data'] ), true );

if ( json_last_error() !== JSON_ERROR_NONE ) {
    wp_send_json_error( 'Invalid data format' );
}

// If you MUST use unserialize (e.g., for legacy WP options):
// 1. Never unserialize direct user input
// 2. Only unserialize from trusted sources (like options table)
// 3. Validate the structure after unserializing
$data = maybe_unserialize( get_option( 'my_setting' ) );

if ( ! is_array( $data ) || ! isset( $data['expected_key'] ) ) {
    $data = get_default_settings();
}
```

### Impact
- **CVSS Score**: 9.0-10.0 (Critical)
- **Attack Vector**: Network, often authenticated
- **Common Exploits**: Remote code execution, site takeover

### How to Find
```bash
grep -r "unserialize.*\$_" .
grep -r "unserialize.*POST" .
grep -r "unserialize.*GET" .
```

---

## 10. Authentication Bypass via wp_ajax_nopriv

### Description
Sensitive AJAX actions registered for unauthenticated users allow bypassing authentication.

### Vulnerable Pattern

```php
add_action( 'wp_ajax_get_admin_data', 'get_admin_data' );
add_action( 'wp_ajax_nopriv_get_admin_data', 'get_admin_data' );  // BAD!

function get_admin_data() {
    $data = get_option( 'sensitive_admin_settings' );
    wp_send_json_success( $data );
}
```

### Fix

```php
// Remove the nopriv action - only authenticated users
add_action( 'wp_ajax_get_admin_data', 'get_admin_data' );

function get_admin_data() {
    // Add capability check
    if ( ! current_user_can( 'manage_options' ) ) {
        wp_send_json_error( 'Unauthorized', 403 );
    }

    $data = get_option( 'sensitive_admin_settings' );
    wp_send_json_success( $data );
}
```

### Impact
- **CVSS Score**: 7.5-9.0 (High to Critical)
- **Attack Vector**: Network, no authentication required
- **Common Exploits**: Data theft, unauthorized access, information disclosure

### How to Find
```bash
grep -r "wp_ajax_nopriv_" .
```

Then manually review each to determine if it should be public.

---

## 11. Open Redirect

### Description
Unvalidated redirect URLs allow phishing attacks.

### Vulnerable Pattern

```php
$redirect_to = $_GET['redirect'];
wp_redirect( $redirect_to );
exit;
```

**Exploit:**
```
?redirect=http://evil.com/phishing-page
```

### Fix

```php
$redirect_to = isset( $_GET['redirect'] ) ? $_GET['redirect'] : home_url();

// Validate it's a local URL
$redirect_to = wp_validate_redirect( $redirect_to, home_url() );

wp_safe_redirect( $redirect_to );
exit;
```

### Impact
- **CVSS Score**: 4.0-6.5 (Medium)
- **Attack Vector**: Requires victim to click malicious link
- **Common Exploits**: Phishing, credential theft, malware distribution

### How to Find
```bash
grep -r "wp_redirect.*\$_" .
grep -r "header.*Location.*\$_" .
```

---

## 12. Privilege Escalation via Meta Capabilities

### Description
Not using WordPress's meta capability system allows users to bypass ownership checks.

### Vulnerable Pattern

```php
// Bad - bypasses ownership check
if ( current_user_can( 'edit_posts' ) ) {
    wp_update_post( array( 'ID' => $post_id, 'post_title' => $new_title ) );
}
```

### Fix

```php
// Good - WordPress checks if user owns this specific post
if ( current_user_can( 'edit_post', $post_id ) ) {
    wp_update_post( array( 'ID' => $post_id, 'post_title' => $new_title ) );
}
```

### Meta Capabilities

Always use meta capabilities when dealing with specific objects:
- `edit_post` (not `edit_posts`) for specific posts
- `delete_post` (not `delete_posts`)
- `edit_user` (not `edit_users`)
- etc.

### Impact
- **CVSS Score**: 6.5-8.0 (Medium to High)
- **Attack Vector**: Authenticated low-privilege users
- **Common Exploits**: Editing others' content, data manipulation

---

## Quick Vulnerability Scan Commands

Use these commands to quickly scan for common issues:

```bash
# 1. Find REST API endpoints without permission checks
grep -r "register_rest_route" . | grep -v "permission_callback"

# 2. Find AJAX handlers without nonce verification
grep -r "wp_ajax_" . | cut -d: -f1 | sort -u | xargs grep -L "check_ajax_referer"

# 3. Find SQL queries without prepare()
grep -rn "\$wpdb->query(" . | grep -v "prepare"

# 4. Find potential XSS (echo with variables)
grep -rn "echo.*\$_" .

# 5. Find file operations with user input
grep -rn "file_get_contents.*\$_" .

# 6. Find unserialize with user input
grep -rn "unserialize.*\$_" .

# 7. Find nopriv AJAX (manually review each)
grep -rn "wp_ajax_nopriv_" .

# 8. Find redirects with user input
grep -rn "wp_redirect.*\$_" .
```

---

## Security Testing Checklist

After fixing a vulnerability, test:

- [ ] **Authentication bypass**: Try accessing as unauthenticated user → should fail
- [ ] **Authorization bypass**: Try accessing as low-privilege user → should fail
- [ ] **CSRF**: Try accessing without nonce → should fail
- [ ] **Input validation**: Try with malicious input (SQL, XSS, etc.) → should be sanitized/rejected
- [ ] **IDOR**: Try accessing other users' data → should fail
- [ ] **Error messages**: Check errors don't leak sensitive info → should be generic
- [ ] **Regression**: Verify existing functionality still works → should work normally

---

## Additional Resources

- [WPScan Vulnerability Database](https://wpscan.com/)
- [Wordfence Intelligence](https://www.wordfence.com/threat-intel/)
- [Patchstack Database](https://patchstack.com/database/)
- [WordPress.org Plugin Security](https://developer.wordpress.org/plugins/security/)
