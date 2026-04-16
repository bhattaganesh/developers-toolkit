# Security Checklist

WordPress.org reviewers cite security issues as the #1 cause of rejection. These are the patterns they specifically look for.

---

## 1. Output Escaping

**Rule:** Escape output at the point of output, every time, without exception.

### Escaping functions by context

| Context | Function | Example |
|---|---|---|
| HTML text content | `esc_html()` | `echo esc_html( $title );` |
| HTML attribute value | `esc_attr()` | `<input value="<?php echo esc_attr( $val ); ?>">` |
| URL in href/src | `esc_url()` | `<a href="<?php echo esc_url( $link ); ?>">` |
| JavaScript value | `esc_js()` | `var x = '<?php echo esc_js( $val ); ?>';` |
| Textarea content | `esc_textarea()` | `<textarea><?php echo esc_textarea( $val ); ?></textarea>` |
| HTML with allowed tags | `wp_kses_post()` | `echo wp_kses_post( $content );` |
| Custom allowed tags | `wp_kses()` | `echo wp_kses( $html, $allowed_tags );` |
| Integer | `absint()` | `echo absint( $count );` |
| Translatable HTML text | `esc_html__()` | `echo esc_html__( 'Save', 'my-plugin' );` |
| Translatable HTML attr | `esc_attr__()` | `<input placeholder="<?php echo esc_attr__( 'Enter email', 'my-plugin' ); ?>">` |

### Common escaping mistakes

```php
// ❌ Wrong: Unescaped variable in echo
echo $user_input;
echo $_POST['name'];
echo get_option( 'my_setting' );

// ✅ Correct
echo esc_html( $user_input );
echo esc_html( sanitize_text_field( wp_unslash( $_POST['name'] ) ) );
echo esc_html( get_option( 'my_setting' ) );

// ❌ Wrong: Unescaped URL
<a href="<?php echo $url; ?>">Link</a>

// ✅ Correct
<a href="<?php echo esc_url( $url ); ?>">Link</a>

// ❌ Wrong: Unescaped in attribute
<input class="<?php echo $class; ?>">

// ✅ Correct
<input class="<?php echo esc_attr( $class ); ?>">
```

---

## 2. Input Sanitization

**Rule:** Sanitize all input before use — storage, processing, or display.

### Sanitization functions by data type

| Input Type | Function |
|---|---|
| Generic text | `sanitize_text_field()` |
| Multi-line text | `sanitize_textarea_field()` |
| Email address | `sanitize_email()` |
| URL | `esc_url_raw()` or `sanitize_url()` |
| Positive integer | `absint()` |
| Any integer | `intval()` |
| Float | `floatval()` |
| HTML content | `wp_kses_post()` |
| File/directory name | `sanitize_file_name()` |
| HTML class name | `sanitize_html_class()` |
| Key/slug/option name | `sanitize_key()` |
| Title | `sanitize_title()` |
| Username | `sanitize_user()` |
| SQL LIKE clause | `$wpdb->esc_like()` (before `$wpdb->prepare()`) |

### Reading $_POST / $_GET safely

```php
// ❌ Wrong: Using superglobals directly
$name = $_POST['name'];
$id   = $_GET['id'];

// ✅ Correct: Unslash then sanitize
$name = sanitize_text_field( wp_unslash( $_POST['name'] ?? '' ) );
$id   = absint( $_GET['id'] ?? 0 );

// ✅ Correct: Check isset before sanitizing
if ( isset( $_POST['email'] ) ) {
    $email = sanitize_email( wp_unslash( $_POST['email'] ) );
}
```

**Why `wp_unslash()`?** WordPress auto-adds slashes to superglobals (magic quotes legacy). Always unslash before sanitizing.

---

## 3. Nonce Verification

**Rule:** Every form submission and every AJAX handler must verify a nonce.

### Form submissions

```php
// In the form template (output nonce field)
<form method="post" action="">
    <?php wp_nonce_field( 'myplugin_save_settings', 'myplugin_nonce' ); ?>
    <!-- form fields -->
</form>

// In the form handler (verify nonce first — before any other processing)
if (
    ! isset( $_POST['myplugin_nonce'] ) ||
    ! wp_verify_nonce( sanitize_key( $_POST['myplugin_nonce'] ), 'myplugin_save_settings' )
) {
    wp_die( esc_html__( 'Security check failed.', 'myplugin' ) );
}
```

### AJAX handlers

```php
// Register AJAX action
add_action( 'wp_ajax_myplugin_do_action', 'myplugin_ajax_handler' );
add_action( 'wp_ajax_nopriv_myplugin_do_action', 'myplugin_ajax_handler' ); // if public

// In JavaScript — pass nonce via wp_localize_script
wp_localize_script( 'myplugin-script', 'mypluginData', [
    'ajaxUrl' => admin_url( 'admin-ajax.php' ),
    'nonce'   => wp_create_nonce( 'myplugin_ajax_nonce' ),
] );

// In AJAX handler — verify nonce first
function myplugin_ajax_handler() {
    check_ajax_referer( 'myplugin_ajax_nonce', 'nonce' );
    // ... rest of handler
    wp_send_json_success( $data );
}
```

### REST API endpoints

```php
register_rest_route( 'myplugin/v1', '/items', [
    'methods'             => 'POST',
    'callback'            => 'myplugin_create_item',
    'permission_callback' => function() {
        return current_user_can( 'edit_posts' ); // ✅ Always check capability
    },
    'args' => [
        'title' => [
            'required'          => true,
            'sanitize_callback' => 'sanitize_text_field', // ✅ Sanitize args
            'validate_callback' => function( $param ) {
                return is_string( $param ) && ! empty( $param );
            },
        ],
    ],
] );
```

---

## 4. Capability Checks

**Rule:** Verify user permissions before any privileged action.

```php
// ❌ Wrong: Admin page without capability check
add_action( 'admin_init', function() {
    update_option( 'myplugin_setting', $_POST['value'] );
} );

// ✅ Correct
add_action( 'admin_init', function() {
    if ( ! current_user_can( 'manage_options' ) ) {
        return;
    }
    // ... process
} );

// Common capabilities
current_user_can( 'manage_options' )  // Admin settings
current_user_can( 'edit_posts' )       // Edit content
current_user_can( 'upload_files' )     // Media uploads
current_user_can( 'manage_categories' ) // Taxonomy management
current_user_can( 'edit_others_posts' ) // Edit any post
```

---

## 5. SQL Injection Prevention

**Rule:** Always use `$wpdb->prepare()` for queries containing variables. Never concatenate SQL.

```php
global $wpdb;

// ❌ Wrong: Direct variable in query
$results = $wpdb->get_results(
    "SELECT * FROM {$wpdb->prefix}my_table WHERE id = $id"
);

// ✅ Correct: Use prepare()
$results = $wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM {$wpdb->prefix}my_table WHERE id = %d",
        absint( $id )
    )
);

// Placeholders
// %d — integer
// %s — string (automatically quoted)
// %f — float

// ✅ Insert with wpdb->insert() (auto-escapes)
$wpdb->insert(
    $wpdb->prefix . 'my_table',
    [ 'name' => $name, 'value' => $value ],
    [ '%s', '%s' ]
);

// ✅ Update with wpdb->update() (auto-escapes)
$wpdb->update(
    $wpdb->prefix . 'my_table',
    [ 'name' => $name ],
    [ 'id' => $id ],
    [ '%s' ],
    [ '%d' ]
);
```

---

## 6. Direct File Access Prevention

**Rule:** Every PHP file must prevent direct HTTP access (except the main plugin file, which boots WordPress on direct access differently).

```php
// At the very top of every PHP file (after <?php)
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
```

**Files that need this guard:** All PHP files in your plugin except the main plugin file itself.

---

## 7. File Upload Security

```php
// ✅ Use wp_handle_upload() for file uploads
$upload = wp_handle_upload( $_FILES['my_file'], [ 'test_form' => false ] );

// ✅ Validate file types
$allowed_types = [ 'image/jpeg', 'image/png', 'image/gif' ];
if ( ! in_array( $upload['type'], $allowed_types, true ) ) {
    wp_die( esc_html__( 'Invalid file type.', 'myplugin' ) );
}
```

---

## 8. wp_options Security

```php
// ✅ Use autoload=no for large or rarely-used options
add_option( 'myplugin_large_data', $data, '', 'no' );

// ✅ Sanitize on save, escape on output
update_option( 'myplugin_url', esc_url_raw( $url ) );
echo esc_url( get_option( 'myplugin_url' ) );
```

---

## 9. HEREDOC / NOWDOC Syntax — Prohibited

**Rule:** Do not use HEREDOC or NOWDOC syntax in any PHP plugin files.

**Why:** Code sniffers (including Plugin Check) **cannot detect missing escaping** inside HEREDOC/NOWDOC blocks. This creates a blind spot for security reviews.

```php
// ❌ Wrong — HEREDOC: code sniffer cannot detect unescaped $variable
echo <<<HTML
<div class="wrap">{$variable}</div>
HTML;

// ❌ Wrong — NOWDOC: same problem
echo <<<'HTML'
<div class="wrap"><!-- static, but pattern is banned --></div>
HTML;

// ✅ Correct — use regular string concatenation or ob_start()
echo '<div class="wrap">' . esc_html( $variable ) . '</div>';

// ✅ Correct — or use a template with proper escaping
?>
<div class="wrap"><?php echo esc_html( $variable ); ?></div>
<?php
```

---

## 10. ALLOW_UNFILTERED_UPLOADS — Strictly Prohibited

**Rule:** Never set or use the `ALLOW_UNFILTERED_UPLOADS` constant.

**Why:** Setting it to `true` allows uploading **any file type** including `.php` executables, which is a critical Remote Code Execution (RCE) vulnerability.

```php
// ❌ STRICTLY PROHIBITED — instant rejection
define( 'ALLOW_UNFILTERED_UPLOADS', true );

// ✅ Correct: Use the upload_mimes filter to add specific file types
add_filter( 'upload_mimes', function( $mimes ) {
    $mimes['svg'] = 'image/svg+xml';
    return $mimes;
} );
```

---

## 11. filter_var / filter_input — Must Specify Filter

**Rule:** When using `filter_var()` or `filter_input()`, you MUST specify a sanitizing filter explicitly. The default `FILTER_DEFAULT` does **not** sanitize.

```php
// ❌ Wrong — FILTER_DEFAULT doesn't sanitize anything
$id = filter_input( INPUT_GET, 'post_id' );
$val = filter_var( $_POST['value'] );

// ✅ Correct — always specify a sanitizing filter
$id = filter_input( INPUT_GET, 'post_id', FILTER_SANITIZE_NUMBER_INT );
$email = filter_input( INPUT_POST, 'email', FILTER_SANITIZE_EMAIL );

// ✅ Or use WordPress sanitization functions (preferred)
$id    = absint( $_GET['post_id'] ?? 0 );
$email = sanitize_email( wp_unslash( $_POST['email'] ?? '' ) );
```

---

## 12. Don't Process Entire $_POST / $_GET Arrays

**Rule:** Never process the entire `$_POST`, `$_GET`, or `$_REQUEST` array. Only extract the specific keys your plugin needs.

**Why:** Performance degradation and unnecessary data processing.

```php
// ❌ Wrong — processing the entire POST array
foreach ( $_POST as $key => $value ) {
    update_option( 'myplugin_' . $key, sanitize_text_field( $value ) );
}

// ✅ Correct — only process what you need
if ( isset( $_POST['myplugin_title'] ) ) {
    $title = sanitize_text_field( wp_unslash( $_POST['myplugin_title'] ) );
    update_option( 'myplugin_title', $title );
}
if ( isset( $_POST['myplugin_count'] ) ) {
    $count = absint( $_POST['myplugin_count'] );
    update_option( 'myplugin_count', $count );
}
```

---

## 13. esc_url_raw() is NOT an Escaping Function

**Rule:** `esc_url_raw()` is a **sanitization** function (safe for database storage). It is NOT safe for output. Use `esc_url()` for output.

```php
// ✅ Saving a URL to the database
update_option( 'myplugin_api_url', esc_url_raw( $url ) );

// ✅ Outputting a URL in HTML
echo '<a href="' . esc_url( get_option( 'myplugin_api_url' ) ) . '">';

// ❌ Wrong — esc_url_raw() used for output
echo '<a href="' . esc_url_raw( $url ) . '">';  // Not safe for output
```

---

## 14. json_encode() → wp_json_encode()

**Rule:** Always use `wp_json_encode()` instead of PHP's native `json_encode()`. Never pass options to avoid escaping.

```php
// ❌ Wrong
echo json_encode( $data );
echo json_encode( $data, JSON_UNESCAPED_UNICODE );

// ✅ Correct
echo wp_json_encode( $data );

// Common use — passing data to JavaScript
wp_localize_script(
    'my-script',
    'myPluginData',
    [
        'ajaxUrl' => admin_url( 'admin-ajax.php' ),
        'nonce'   => wp_create_nonce( 'myplugin_nonce' ),
        'settings' => wp_json_encode( $settings ),  // if nested JSON needed
    ]
);
```

---

## 15. File Uploads — Use wp_handle_upload()

**Rule:** Always use WordPress's built-in `wp_handle_upload()` instead of `move_uploaded_file()`.

```php
// ❌ Wrong — bypasses WordPress security checks
$tmp  = $_FILES['my_file']['tmp_name'];
$dest = wp_upload_dir()['path'] . '/' . $_FILES['my_file']['name'];
move_uploaded_file( $tmp, $dest );

// ✅ Correct — WordPress handles type validation, permissions, naming
if ( ! function_exists( 'wp_handle_upload' ) ) {
    require_once ABSPATH . 'wp-admin/includes/file.php';
}

$upload = wp_handle_upload(
    $_FILES['my_file'],
    [ 'test_form' => false ]
);

if ( isset( $upload['error'] ) ) {
    wp_die( esc_html( $upload['error'] ) );
}

$file_url  = $upload['url'];
$file_path = $upload['file'];
$file_type = $upload['type'];
```

---

## Grep Commands for Security Audit

```bash
PLUGIN_DIR="/path/to/plugin"

# 1. Unescaped echo (needs manual review — false positives possible)
grep -rn "echo\s" --include="*.php" "$PLUGIN_DIR" | grep -v "esc_\|wp_kses\|absint\|intval\|number_format\|wp_json_encode"

# 2. Unescaped short echo tags
grep -rn "<?=" --include="*.php" "$PLUGIN_DIR"

# 3. Raw superglobal usage
grep -rn "\$_POST\|\$_GET\|\$_REQUEST\|\$_FILES" --include="*.php" "$PLUGIN_DIR" | grep -v "sanitize_\|wp_verify_nonce\|check_ajax_referer\|check_admin_referer\|isset\|wp_unslash"

# 4. AJAX handlers — check for nonce verification
grep -rn "wp_ajax_" --include="*.php" "$PLUGIN_DIR" -A 10 | grep -v "check_ajax_referer\|wp_verify_nonce\|check_admin_referer"

# 5. Direct $wpdb queries without prepare()
grep -rn "\$wpdb->query\|\$wpdb->get_results\|\$wpdb->get_row\|\$wpdb->get_var" --include="*.php" "$PLUGIN_DIR" -B2 | grep -v "prepare"

# 6. eval() and code execution (obfuscation)
grep -rn "\beval(\|base64_decode.*eval\|create_function\|str_rot13\|gzinflate\|gzuncompress" --include="*.php" "$PLUGIN_DIR"

# 7. Files missing ABSPATH guard
grep -rL "defined.*ABSPATH\|ABSPATH.*defined" --include="*.php" "$PLUGIN_DIR"

# 8. Missing capability checks in admin
grep -rn "admin_init\|admin_post_\|wp_ajax_" --include="*.php" "$PLUGIN_DIR" -A 15 | grep -v "current_user_can\|check_admin_referer\|check_ajax_referer"

# 9. HEREDOC/NOWDOC usage
grep -rn "<<<" --include="*.php" "$PLUGIN_DIR"

# 10. ALLOW_UNFILTERED_UPLOADS (strictly prohibited)
grep -rn "ALLOW_UNFILTERED_UPLOADS" --include="*.php" "$PLUGIN_DIR"

# 11. filter_var/filter_input without explicit FILTER
grep -rn "filter_var\|filter_input" --include="*.php" "$PLUGIN_DIR" | grep -v "FILTER_SANITIZE\|FILTER_VALIDATE\|FILTER_CALLBACK"

# 12. json_encode() (should be wp_json_encode)
grep -rn "\bjson_encode(" --include="*.php" "$PLUGIN_DIR"

# 13. move_uploaded_file (should use wp_handle_upload)
grep -rn "move_uploaded_file" --include="*.php" "$PLUGIN_DIR"

# 14. _e() and _ex() without escaping (potential XSS in translations)
grep -rn "\b_e(\|\b_ex(" --include="*.php" "$PLUGIN_DIR"

# 15. esc_url_raw() used for output (should be esc_url for output)
grep -rn "esc_url_raw" --include="*.php" "$PLUGIN_DIR"
```
