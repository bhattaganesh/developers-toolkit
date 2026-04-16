# WordPress Security Patterns Reference

This reference provides WordPress-standard security controls and code patterns. Use these when implementing security fixes.

---

## Authentication Patterns

### Basic Authentication Check

```php
if ( ! is_user_logged_in() ) {
    wp_send_json_error( 'Authentication required', 401 );
    exit;
}
```

### Authentication with Specific User Check

```php
$user_id = get_current_user_id();
if ( ! $user_id ) {
    wp_send_json_error( 'Authentication required', 401 );
    exit;
}
```

---

## Authorization Patterns

### Capability Check

```php
if ( ! current_user_can( 'manage_options' ) ) {
    wp_send_json_error( 'Insufficient permissions', 403 );
    exit;
}
```

### Common WordPress Capabilities

- `manage_options` - Administrator-only actions
- `edit_posts` - Create/edit posts (Author, Editor, Admin)
- `edit_pages` - Create/edit pages (Editor, Admin)
- `edit_published_posts` - Edit already-published posts
- `delete_posts` - Delete posts
- `upload_files` - Upload media
- `moderate_comments` - Moderate comments
- `manage_categories` - Manage categories/taxonomies

### Post-Specific Authorization

```php
$post_id = absint( $_POST['post_id'] ?? 0 );

// Check if user can edit THIS specific post
if ( ! current_user_can( 'edit_post', $post_id ) ) {
    wp_send_json_error( 'You cannot edit this post', 403 );
    exit;
}
```

---

## CSRF Protection (Nonces)

### Nonce Verification - AJAX Requests

```php
// Method 1: Using check_ajax_referer (dies on failure)
check_ajax_referer( 'my-action-nonce', 'nonce' );

// Method 2: Using check_ajax_referer with false (doesn't die)
if ( ! check_ajax_referer( 'my-action-nonce', 'nonce', false ) ) {
    wp_send_json_error( 'Invalid security token', 403 );
    exit;
}

// Method 3: Manual verification with isset check
if ( ! isset( $_POST['nonce'] ) || ! wp_verify_nonce( wp_unslash( $_POST['nonce'] ), 'my-action-nonce' ) ) {
    wp_send_json_error( 'Invalid security token', 403 );
    exit;
}
```

### Nonce Verification - Form Submissions

```php
// Verify nonce from form
if ( ! isset( $_POST['my_nonce'] ) || ! wp_verify_nonce( wp_unslash( $_POST['my_nonce'] ), 'my-form-action' ) ) {
    wp_die( 'Security check failed' );
}
```

### Nonce Verification - URL Parameters

```php
// Verify nonce from URL (e.g., ?action=delete&nonce=...)
if ( ! isset( $_GET['nonce'] ) || ! wp_verify_nonce( wp_unslash( $_GET['nonce'] ), 'delete-item' ) ) {
    wp_die( 'Invalid security token' );
}
```

### Generating Nonces

```php
// In PHP (for forms)
wp_nonce_field( 'my-form-action', 'my_nonce' );

// In PHP (for URLs)
$delete_url = add_query_arg( array(
    'action' => 'delete',
    'nonce'  => wp_create_nonce( 'delete-item' ),
), admin_url( 'admin-post.php' ) );

// In JavaScript (enqueued with wp_localize_script)
wp_localize_script( 'my-script', 'myData', array(
    'nonce' => wp_create_nonce( 'my-ajax-action' ),
) );
```

---

## Input Sanitization

### Text Input

```php
// Single-line text (removes tags, encodes special chars)
$safe_text = sanitize_text_field( wp_unslash( $_POST['input'] ?? '' ) );

// Multi-line text (preserves newlines)
$safe_textarea = sanitize_textarea_field( wp_unslash( $_POST['description'] ?? '' ) );

// Alphanumeric key (for option names, meta keys)
$safe_key = sanitize_key( $_POST['option_name'] ?? '' );

// Post title/slug
$safe_title = sanitize_title( wp_unslash( $_POST['title'] ?? '' ) );
```

### Email

```php
$email = sanitize_email( wp_unslash( $_POST['email'] ?? '' ) );

// Additional validation
if ( ! is_email( $email ) ) {
    wp_send_json_error( 'Invalid email address', 400 );
}
```

### URLs

```php
// For storage (database)
$safe_url = esc_url_raw( wp_unslash( $_POST['url'] ?? '' ) );

// Additional validation
$safe_url = filter_var( $safe_url, FILTER_VALIDATE_URL );
if ( ! $safe_url ) {
    wp_send_json_error( 'Invalid URL', 400 );
}
```

### Numbers

```php
// Positive integers only
$safe_id = absint( $_POST['id'] ?? 0 );

// Any integer (can be negative)
$safe_number = intval( $_POST['count'] ?? 0 );

// Floating point
$safe_price = floatval( $_POST['price'] ?? 0.0 );
```

### HTML Content

```php
// Allow safe HTML tags (for post content)
$safe_html = wp_kses_post( wp_unslash( $_POST['content'] ?? '' ) );

// Custom allowed tags
$allowed_tags = array(
    'a' => array( 'href' => array(), 'title' => array() ),
    'br' => array(),
    'strong' => array(),
);
$safe_html = wp_kses( wp_unslash( $_POST['content'] ?? '' ), $allowed_tags );

// Strip ALL tags
$no_html = wp_strip_all_tags( wp_unslash( $_POST['input'] ?? '' ) );
```

### Arrays

```php
// Sanitize array of text values
$values = isset( $_POST['items'] ) ? (array) $_POST['items'] : array();
$safe_values = array_map( function( $item ) {
    return sanitize_text_field( wp_unslash( $item ) );
}, $values );

// Sanitize array of IDs
$ids = isset( $_POST['ids'] ) ? (array) $_POST['ids'] : array();
$safe_ids = array_map( 'absint', $ids );
```

---

## Output Escaping

### HTML Content

```php
// Escape text for display in HTML
echo esc_html( $user_data );

// Example: <p>User name: John</p>
echo '<p>User name: ' . esc_html( $name ) . '</p>';
```

### HTML Attributes

```php
// Escape for use in HTML attributes
echo '<div class="' . esc_attr( $class_name ) . '">';
echo '<input type="text" value="' . esc_attr( $value ) . '">';
echo '<div data-id="' . esc_attr( $user_id ) . '">';
```

### URLs

```php
// Escape URL for display/links
echo '<a href="' . esc_url( $link ) . '">Click here</a>';

// For href attributes
echo '<link rel="stylesheet" href="' . esc_url( $stylesheet_url ) . '">';
```

### JavaScript

```php
// Escape for use in JavaScript strings
echo '<script>var name = "' . esc_js( $name ) . '";</script>';

// Better: Use wp_json_encode for complex data
$data = array( 'name' => $name, 'email' => $email );
echo '<script>var userData = ' . wp_json_encode( $data ) . ';</script>';
```

### HTML Content (Preserve Formatting)

```php
// Escape but allow safe HTML tags
echo wp_kses_post( $post_content );

// In templates
<div class="content">
    <?php echo wp_kses_post( $description ); ?>
</div>
```

### Translation Functions with Escaping

```php
// Escape translated strings
echo esc_html__( 'Hello World', 'textdomain' );
echo esc_html_e( 'Welcome', 'textdomain' ); // _e = echo

// With variables (use printf)
printf(
    esc_html__( 'Hello, %s', 'textdomain' ),
    esc_html( $name )
);
```

---

## SQL Query Safety

### Basic Prepared Statement

```php
global $wpdb;

// Use prepare() for ALL dynamic queries
$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}posts WHERE ID = %d AND post_type = %s",
    $post_id,
    $post_type
) );

// Placeholders:
// %d = integer
// %s = string
// %f = float
```

### Multiple Values (IN clause)

```php
global $wpdb;

// For array of IDs
$ids = array( 1, 2, 3, 5, 8 );
$placeholders = implode( ', ', array_fill( 0, count( $ids ), '%d' ) );

$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}posts WHERE ID IN ({$placeholders})",
    ...$ids // Spread operator for multiple values
) );
```

### LIKE Queries

```php
global $wpdb;

// Escape LIKE wildcards
$search = $wpdb->esc_like( $user_search );

$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}posts WHERE post_title LIKE %s",
    '%' . $search . '%'
) );
```

### Inserting Data

```php
global $wpdb;

// Using wpdb->insert()
$wpdb->insert(
    $wpdb->prefix . 'my_table',
    array(
        'column1' => $value1,
        'column2' => $value2,
    ),
    array( '%s', '%d' ) // Format for each value
);

// Get inserted ID
$inserted_id = $wpdb->insert_id;
```

### Updating Data

```php
global $wpdb;

// Using wpdb->update()
$wpdb->update(
    $wpdb->prefix . 'my_table',
    array( 'column' => $new_value ),  // Data to update
    array( 'ID' => $id ),              // WHERE clause
    array( '%s' ),                     // Data format
    array( '%d' )                      // WHERE format
);

// Get number of rows affected
$rows_affected = $wpdb->rows_affected;
```

---

## REST API Security

### Permission Callback (Required)

```php
register_rest_route( 'myplugin/v1', '/endpoint', array(
    'methods'             => WP_REST_Server::READABLE, // GET
    'callback'            => 'my_callback',
    'permission_callback' => function() {
        // NEVER return true without checking!
        return current_user_can( 'edit_posts' );
    },
) );
```

### REST API Method Constants

```php
// Use constants instead of strings
'methods' => WP_REST_Server::READABLE,   // GET
'methods' => WP_REST_Server::CREATABLE,  // POST
'methods' => WP_REST_Server::EDITABLE,   // POST, PUT, PATCH
'methods' => WP_REST_Server::DELETABLE,  // DELETE
'methods' => WP_REST_Server::ALLMETHODS, // Any method

// Multiple methods
'methods' => array( WP_REST_Server::READABLE, WP_REST_Server::CREATABLE ),
```

### Argument Validation & Sanitization

```php
register_rest_route( 'myplugin/v1', '/posts/(?P<id>\\d+)', array(
    'methods'             => WP_REST_Server::EDITABLE,
    'callback'            => 'my_update_callback',
    'permission_callback' => function( $request ) {
        $post_id = $request->get_param( 'id' );
        return current_user_can( 'edit_post', $post_id );
    },
    'args' => array(
        'id' => array(
            'required'          => true,
            'validate_callback' => function( $param, $request, $key ) {
                return is_numeric( $param );
            },
            'sanitize_callback' => 'absint',
        ),
        'title' => array(
            'required'          => true,
            'type'              => 'string',
            'sanitize_callback' => 'sanitize_text_field',
        ),
    ),
) );
```

### Full REST API Example

```php
function register_my_rest_routes() {
    register_rest_route( 'myplugin/v1', '/data', array(
        'methods'             => WP_REST_Server::READABLE,
        'callback'            => 'get_my_data',
        'permission_callback' => function() {
            return current_user_can( 'edit_posts' );
        },
    ) );

    register_rest_route( 'myplugin/v1', '/data', array(
        'methods'             => WP_REST_Server::CREATABLE,
        'callback'            => 'create_my_data',
        'permission_callback' => function() {
            return current_user_can( 'publish_posts' );
        },
        'args' => array(
            'title' => array(
                'required'          => true,
                'type'              => 'string',
                'sanitize_callback' => 'sanitize_text_field',
            ),
        ),
    ) );
}
add_action( 'rest_api_init', 'register_my_rest_routes' );

function get_my_data( WP_REST_Request $request ) {
    $data = array( /* ... */ );
    return rest_ensure_response( $data );
}

function create_my_data( WP_REST_Request $request ) {
    $title = $request->get_param( 'title' );

    // Process...

    return rest_ensure_response( array(
        'success' => true,
        'id'      => $new_id,
    ) );
}
```

---

## Admin AJAX Security

### Complete AJAX Handler Pattern

```php
// Register AJAX handler
add_action( 'wp_ajax_my_action', 'handle_my_ajax_request' );
// Note: Only registered for logged-in users
// To allow public access, also add: wp_ajax_nopriv_my_action

function handle_my_ajax_request() {
    // 1. Verify nonce
    check_ajax_referer( 'my-nonce-action', 'nonce' );

    // 2. Check capabilities
    if ( ! current_user_can( 'edit_posts' ) ) {
        wp_send_json_error( array(
            'message' => 'Unauthorized',
        ), 403 );
    }

    // 3. Sanitize inputs
    $data = sanitize_text_field( wp_unslash( $_POST['data'] ?? '' ) );
    $post_id = absint( $_POST['post_id'] ?? 0 );

    // 4. Validate inputs
    if ( ! $post_id ) {
        wp_send_json_error( array(
            'message' => 'Invalid post ID',
        ), 400 );
    }

    // 5. Additional authorization (post-specific)
    if ( ! current_user_can( 'edit_post', $post_id ) ) {
        wp_send_json_error( array(
            'message' => 'You cannot edit this post',
        ), 403 );
    }

    // 6. Process...
    $result = do_something( $post_id, $data );

    // 7. Return success (with escaped output)
    wp_send_json_success( array(
        'message' => esc_html( $result ),
        'post_id' => $post_id,
    ) );
}
```

### Enqueuing AJAX Script with Nonce

```php
function enqueue_my_ajax_script() {
    wp_enqueue_script(
        'my-ajax-script',
        plugin_dir_url( __FILE__ ) . 'js/ajax.js',
        array( 'jquery' ),
        '1.0.0',
        true
    );

    wp_localize_script( 'my-ajax-script', 'myAjaxData', array(
        'ajaxurl' => admin_url( 'admin-ajax.php' ),
        'nonce'   => wp_create_nonce( 'my-nonce-action' ),
    ) );
}
add_action( 'admin_enqueue_scripts', 'enqueue_my_ajax_script' );
```

### JavaScript AJAX Request

```javascript
jQuery(document).ready(function($) {
    $('#my-button').on('click', function() {
        $.post(myAjaxData.ajaxurl, {
            action: 'my_action',
            nonce: myAjaxData.nonce,
            data: 'some value',
            post_id: 123
        }, function(response) {
            if (response.success) {
                console.log('Success:', response.data);
            } else {
                console.error('Error:', response.data.message);
            }
        });
    });
});
```

---

## File Upload Security

### Basic File Upload Validation

```php
// Check if file was uploaded
if ( ! isset( $_FILES['file'] ) || $_FILES['file']['error'] !== UPLOAD_ERR_OK ) {
    wp_send_json_error( 'File upload failed', 400 );
}

// Validate file type
$allowed_types = array( 'image/jpeg', 'image/png', 'image/gif' );
$file_type = $_FILES['file']['type'];

if ( ! in_array( $file_type, $allowed_types, true ) ) {
    wp_send_json_error( 'Invalid file type', 400 );
}

// Check file extension
$file_name = sanitize_file_name( $_FILES['file']['name'] );
$file_ext = strtolower( pathinfo( $file_name, PATHINFO_EXTENSION ) );
$allowed_extensions = array( 'jpg', 'jpeg', 'png', 'gif' );

if ( ! in_array( $file_ext, $allowed_extensions, true ) ) {
    wp_send_json_error( 'Invalid file extension', 400 );
}

// Use WordPress file handling
$upload = wp_handle_upload( $_FILES['file'], array(
    'test_form' => false,
) );

if ( isset( $upload['error'] ) ) {
    wp_send_json_error( $upload['error'], 400 );
}

// File uploaded successfully
$file_url = $upload['url'];
$file_path = $upload['file'];
```

### Using wp_check_filetype_and_ext()

```php
// More thorough file type checking
$file_data = wp_check_filetype_and_ext(
    $_FILES['file']['tmp_name'],
    $_FILES['file']['name']
);

$file_type = $file_data['type'];
$file_ext = $file_data['ext'];

if ( ! $file_type || ! $file_ext ) {
    wp_send_json_error( 'Invalid file', 400 );
}
```

---

## Redirects

### Safe Redirects

```php
// Use wp_safe_redirect() instead of wp_redirect()
// This only allows redirects to the same site (prevents open redirects)
wp_safe_redirect( admin_url( 'admin.php?page=my-page' ) );
exit;

// With custom allowed hosts
$redirect_url = 'https://example.com/page';
wp_safe_redirect( $redirect_url, 302, 'My Plugin' );
exit;

// Validate redirect URL from user input
$redirect = isset( $_GET['redirect_to'] ) ? wp_unslash( $_GET['redirect_to'] ) : '';
$redirect = wp_validate_redirect( $redirect, home_url() ); // Fallback to home
wp_safe_redirect( $redirect );
exit;
```

---

## Common Pitfalls to Avoid

### ❌ DON'T: Return true in permission_callback

```php
// VULNERABLE
register_rest_route( 'myplugin/v1', '/endpoint', array(
    'permission_callback' => '__return_true', // Anyone can access!
) );
```

### ✅ DO: Check capabilities

```php
// SECURE
register_rest_route( 'myplugin/v1', '/endpoint', array(
    'permission_callback' => function() {
        return current_user_can( 'edit_posts' );
    },
) );
```

---

### ❌ DON'T: Forget wp_unslash()

```php
// INCOMPLETE
$value = sanitize_text_field( $_POST['value'] ); // Still has slashes!
```

### ✅ DO: Always wp_unslash() first

```php
// CORRECT
$value = sanitize_text_field( wp_unslash( $_POST['value'] ?? '' ) );
```

---

### ❌ DON'T: Skip isset() checks

```php
// VULNERABLE to PHP warnings/notices
$value = sanitize_text_field( wp_unslash( $_POST['value'] ) );
```

### ✅ DO: Always check isset() or use null coalescing

```php
// SECURE
$value = isset( $_POST['value'] ) ? sanitize_text_field( wp_unslash( $_POST['value'] ) ) : '';

// Or use null coalescing operator (PHP 7+)
$value = sanitize_text_field( wp_unslash( $_POST['value'] ?? '' ) );
```

---

### ❌ DON'T: Only sanitize OR escape

```php
// INCOMPLETE - Only sanitizing on input
update_post_meta( $post_id, 'custom_field', sanitize_text_field( $_POST['value'] ) );

// Later in template - no output escaping!
echo get_post_meta( $post_id, 'custom_field', true ); // XSS RISK!
```

### ✅ DO: Both sanitize AND escape (Defense in Depth)

```php
// Sanitize on input
update_post_meta( $post_id, 'custom_field', sanitize_text_field( wp_unslash( $_POST['value'] ?? '' ) ) );

// Escape on output (defense in depth)
echo esc_html( get_post_meta( $post_id, 'custom_field', true ) );
```

---

### ❌ DON'T: Concatenate SQL queries

```php
// VULNERABLE to SQL injection
global $wpdb;
$results = $wpdb->get_results(
    "SELECT * FROM {$wpdb->prefix}posts WHERE ID = {$_GET['id']}"
);
```

### ✅ DO: Use $wpdb->prepare()

```php
// SECURE
global $wpdb;
$id = absint( $_GET['id'] ?? 0 );
$results = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}posts WHERE ID = %d",
    $id
) );
```

---

## Additional Resources

For comprehensive security coverage, see:
- [WordPress Security Checklist](wp-security-checklist.md) - OWASP Top 10 mapped to WordPress
- [Common Vulnerabilities](common-vulnerabilities.md) - Common WordPress vulnerability patterns
- [SureRank Security Patterns](surerank-patterns.md) - SureRank-specific patterns (if working on SureRank)
