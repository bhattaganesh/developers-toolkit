# Defense in Depth Strategy for WordPress Security

This guide explains the defense in depth (layered security) approach for WordPress security fixes. Defense in depth means implementing multiple security controls so that if one layer fails, others continue to provide protection.

---

## Overview

**Defense in Depth Definition:**
A security strategy where multiple independent layers of security controls are placed throughout a system. If an attacker defeats one layer, they still face additional barriers.

**Why It Matters:**
- No single security control is perfect
- Bugs in one control don't compromise entire system
- Provides redundancy and resilience
- Reduces risk of catastrophic failure

**Key Principle:**
> "Never rely on a single security control. Always implement multiple layers of defense."

---

## The 7 Layers of WordPress Security

### Layer 1: Input Validation

**What:** Validate that input data matches expected format, type, and constraints.

**Why:** Reject malformed data before it enters the system.

**WordPress Implementation:**
```php
// Layer 1: Validate input TYPE and FORMAT
function process_user_id( $user_id ) {
    // Validation: Is it numeric?
    if ( ! is_numeric( $user_id ) ) {
        return new WP_Error( 'invalid_user_id', 'User ID must be numeric' );
    }

    // Validation: Is it within valid range?
    if ( $user_id < 1 ) {
        return new WP_Error( 'invalid_user_id', 'User ID must be positive' );
    }

    // Continue to Layer 2...
}
```

---

### Layer 2: Input Sanitization

**What:** Clean and normalize input data to remove potentially dangerous content.

**Why:** Even if validation passes, sanitize to ensure data is safe.

**WordPress Implementation:**
```php
// Layer 2: Sanitize input
function process_user_input( $input ) {
    // Layer 1: Validate
    if ( empty( $input ) ) {
        return new WP_Error( 'empty_input', 'Input cannot be empty' );
    }

    // Layer 2: Sanitize
    $clean_input = sanitize_text_field( wp_unslash( $input ) );

    // Continue to Layer 3...
}
```

**Key Pattern:**
```php
// ALWAYS: wp_unslash() THEN sanitize
$value = sanitize_text_field( wp_unslash( $_POST['field'] ?? '' ) );
```

---

### Layer 3: Authentication

**What:** Verify the user is who they claim to be.

**Why:** Prevent anonymous attackers from accessing protected resources.

**WordPress Implementation:**
```php
// Layer 3: Authentication
function handle_sensitive_action() {
    // Layer 1 & 2: Validation and sanitization already done...

    // Layer 3: Authenticate
    if ( ! is_user_logged_in() ) {
        wp_send_json_error( 'Authentication required', 401 );
    }

    // Continue to Layer 4...
}
```

---

### Layer 4: Authorization

**What:** Verify the user has permission to perform the action.

**Why:** Authenticated users shouldn't access everything - check permissions.

**WordPress Implementation:**
```php
// Layer 4: Authorization
function delete_user_account( $user_id ) {
    // Layer 1: Validation
    $user_id = absint( $user_id );

    // Layer 2: Sanitization (absint does this)

    // Layer 3: Authentication
    if ( ! is_user_logged_in() ) {
        return new WP_Error( 'not_authenticated', 'Authentication required' );
    }

    // Layer 4: Authorization
    if ( ! current_user_can( 'delete_users' ) ) {
        return new WP_Error( 'insufficient_permissions', 'You cannot delete users' );
    }

    // Continue to Layer 5...
}
```

---

### Layer 5: CSRF Protection

**What:** Verify the request came from your application, not a malicious site.

**Why:** Prevents forged requests from tricking authenticated users.

**WordPress Implementation:**
```php
// Layer 5: CSRF Protection
function process_admin_action() {
    // Layers 1-4: Validation, sanitization, authentication, authorization...

    // Layer 5: CSRF Protection
    if ( ! isset( $_POST['nonce'] ) || ! wp_verify_nonce( wp_unslash( $_POST['nonce'] ), 'admin-action-nonce' ) ) {
        wp_send_json_error( 'Invalid security token', 403 );
    }

    // Continue to Layer 6...
}
```

---

### Layer 6: Data Access Control

**What:** Control access to data at the database/business logic level.

**Why:** Even if earlier checks pass, ensure data-level permissions.

**WordPress Implementation:**
```php
// Layer 6: Data Access Control
function get_user_email( $user_id ) {
    // Layers 1-5 already checked...

    // Layer 6: Data access control
    $user = get_userdata( $user_id );

    // Verify user exists
    if ( ! $user ) {
        return new WP_Error( 'user_not_found', 'User not found' );
    }

    // Verify current user can access this user's data
    if ( get_current_user_id() !== $user_id && ! current_user_can( 'list_users' ) ) {
        return new WP_Error( 'access_denied', 'You cannot access this user data' );
    }

    // Continue to Layer 7...
}
```

---

### Layer 7: Output Escaping

**What:** Encode output data to prevent execution of malicious content.

**Why:** Last line of defense - even if all other layers fail, prevent XSS.

**WordPress Implementation:**
```php
// Layer 7: Output Escaping
function display_user_profile( $user_id ) {
    // Layers 1-6: All security checks passed...

    $user = get_userdata( $user_id );

    // Layer 7: Escape ALL output
    echo '<div class="user-profile">';
    echo '<h2>' . esc_html( $user->display_name ) . '</h2>';
    echo '<p>Email: ' . esc_html( $user->user_email ) . '</p>';
    echo '<a href="' . esc_url( $user->user_url ) . '">Website</a>';
    echo '</div>';
}
```

---

## Complete Defense in Depth Example

**Scenario:** Admin endpoint to update user role

```php
/**
 * Update user role (admin only)
 * Demonstrates all 7 layers of defense in depth
 */
function handle_update_user_role() {
    // =============================================================================
    // LAYER 1: INPUT VALIDATION
    // =============================================================================

    // Validate user_id exists and is numeric
    if ( ! isset( $_POST['user_id'] ) || ! is_numeric( $_POST['user_id'] ) ) {
        wp_send_json_error( 'Invalid user ID', 400 );
    }

    // Validate role exists and is a string
    if ( ! isset( $_POST['new_role'] ) || ! is_string( $_POST['new_role'] ) ) {
        wp_send_json_error( 'Invalid role', 400 );
    }

    // =============================================================================
    // LAYER 2: INPUT SANITIZATION
    // =============================================================================

    // Sanitize user_id to positive integer
    $user_id = absint( $_POST['user_id'] );

    // Sanitize role to text field
    $new_role = sanitize_text_field( wp_unslash( $_POST['new_role'] ) );

    // Additional validation: role must be in whitelist
    $valid_roles = array( 'subscriber', 'contributor', 'author', 'editor' );
    if ( ! in_array( $new_role, $valid_roles, true ) ) {
        wp_send_json_error( 'Invalid role specified', 400 );
    }

    // =============================================================================
    // LAYER 3: AUTHENTICATION
    // =============================================================================

    // Verify user is logged in
    if ( ! is_user_logged_in() ) {
        wp_send_json_error( 'Authentication required', 401 );
    }

    // =============================================================================
    // LAYER 4: AUTHORIZATION
    // =============================================================================

    // Verify user has capability to edit users
    if ( ! current_user_can( 'edit_users' ) ) {
        wp_send_json_error( 'Insufficient permissions', 403 );
    }

    // Additional authorization: prevent privilege escalation
    // Users cannot assign a role higher than their own
    $current_user = wp_get_current_user();
    $target_user = get_userdata( $user_id );

    if ( ! $target_user ) {
        wp_send_json_error( 'User not found', 404 );
    }

    // Block if trying to edit admin and you're not admin
    if ( in_array( 'administrator', $target_user->roles ) && ! current_user_can( 'manage_options' ) ) {
        wp_send_json_error( 'Cannot modify administrator accounts', 403 );
    }

    // Block if trying to assign admin role and you're not admin
    if ( 'administrator' === $new_role && ! current_user_can( 'manage_options' ) ) {
        wp_send_json_error( 'Cannot assign administrator role', 403 );
    }

    // =============================================================================
    // LAYER 5: CSRF PROTECTION
    // =============================================================================

    // Verify nonce
    if ( ! isset( $_POST['nonce'] ) || ! wp_verify_nonce( wp_unslash( $_POST['nonce'] ), 'update-user-role-nonce' ) ) {
        wp_send_json_error( 'Invalid security token', 403 );
    }

    // =============================================================================
    // LAYER 6: DATA ACCESS CONTROL
    // =============================================================================

    // Verify user exists in database
    if ( ! get_userdata( $user_id ) ) {
        wp_send_json_error( 'User not found', 404 );
    }

    // Prevent users from editing themselves (prevent accidental lockout)
    if ( $user_id === get_current_user_id() ) {
        wp_send_json_error( 'Cannot modify your own role', 403 );
    }

    // Additional check: multisite network admin verification (if multisite)
    if ( is_multisite() && is_super_admin( $user_id ) && ! is_super_admin() ) {
        wp_send_json_error( 'Cannot modify network administrator', 403 );
    }

    // =============================================================================
    // PERFORM OPERATION (All security checks passed)
    // =============================================================================

    $user_to_update = new WP_User( $user_id );
    $user_to_update->set_role( $new_role );

    // =============================================================================
    // LAYER 7: OUTPUT ESCAPING
    // =============================================================================

    // Return safe response
    wp_send_json_success( array(
        'message' => 'User role updated successfully',
        'user_id' => $user_id,  // Already sanitized (absint)
        'new_role' => esc_html( $new_role ),  // Escape for display
        'user_name' => esc_html( $target_user->display_name ),  // Escape user data
    ) );
}
```

---

## Defense in Depth for Common Vulnerabilities

### SQL Injection Defense

```php
// Multi-layer SQL injection defense
function get_posts_by_category( $category_id ) {
    global $wpdb;

    // Layer 1: Validate input type
    if ( ! is_numeric( $category_id ) ) {
        return array();
    }

    // Layer 2: Sanitize to integer
    $category_id = absint( $category_id );

    // Layer 3: Use prepared statements (CRITICAL!)
    $posts = $wpdb->get_results( $wpdb->prepare(
        "SELECT * FROM {$wpdb->posts} WHERE post_category = %d",
        $category_id
    ) );

    // Layer 4: Verify user can access results
    $filtered_posts = array();
    foreach ( $posts as $post ) {
        if ( current_user_can( 'read_post', $post->ID ) ) {
            $filtered_posts[] = $post;
        }
    }

    // Layer 5: Escape output when displaying
    foreach ( $filtered_posts as $post ) {
        echo '<h2>' . esc_html( $post->post_title ) . '</h2>';
    }

    return $filtered_posts;
}
```

---

### XSS Defense

```php
// Multi-layer XSS defense
function display_user_comment( $comment_id ) {
    // Layer 1: Validate input
    $comment_id = absint( $comment_id );
    if ( ! $comment_id ) {
        return;
    }

    // Layer 2: Authorization - can user view this comment?
    $comment = get_comment( $comment_id );
    if ( ! $comment || ! current_user_can( 'read_post', $comment->comment_post_ID ) ) {
        return;
    }

    // Layer 3: Content sanitization (on save, not just display)
    // WordPress already does this via wp_filter_comment()

    // Layer 4: Output escaping (CRITICAL!)
    echo '<div class="comment">';
    echo '<p class="author">' . esc_html( $comment->comment_author ) . '</p>';
    echo '<div class="content">' . wp_kses_post( $comment->comment_content ) . '</div>';
    echo '</div>';

    // Layer 5: Content Security Capability (CSP) headers (at server level)
    // Added in wp-config.php or .htaccess:
    // Content-Security-Capability: default-src 'self'; script-src 'self'
}
```

---

### Authentication Bypass Defense

```php
// Multi-layer authentication defense
function handle_sensitive_api_request( WP_REST_Request $request ) {
    // Layer 1: REST API permission_callback
    // (Already checked by WordPress before this function is called)

    // Layer 2: is_user_logged_in() check (redundant but safe)
    if ( ! is_user_logged_in() ) {
        return new WP_Error( 'not_authenticated', 'Authentication required', array( 'status' => 401 ) );
    }

    // Layer 3: Nonce verification
    $nonce = $request->get_header( 'X-WP-Nonce' );
    if ( ! wp_verify_nonce( $nonce, 'wp_rest' ) ) {
        return new WP_Error( 'invalid_nonce', 'Invalid security token', array( 'status' => 403 ) );
    }

    // Layer 4: Capability check
    if ( ! current_user_can( 'edit_posts' ) ) {
        return new WP_Error( 'insufficient_permissions', 'Insufficient permissions', array( 'status' => 403 ) );
    }

    // Layer 5: Rate limiting (prevent brute force)
    $user_id = get_current_user_id();
    $transient_key = "api_rate_limit_{$user_id}";
    $request_count = get_transient( $transient_key );

    if ( false === $request_count ) {
        set_transient( $transient_key, 1, MINUTE_IN_SECONDS );
    } elseif ( $request_count > 60 ) {  // Max 60 requests per minute
        return new WP_Error( 'rate_limit_exceeded', 'Too many requests', array( 'status' => 429 ) );
    } else {
        set_transient( $transient_key, $request_count + 1, MINUTE_IN_SECONDS );
    }

    // All checks passed - proceed with operation
}
```

---

## Defense in Depth Checklist

Use this checklist when implementing security fixes:

### Input Layer
- [ ] **Validation:** Type, format, range, whitelist checks
- [ ] **Sanitization:** Clean/normalize with appropriate WordPress functions
- [ ] **wp_unslash()** called before sanitization for `$_POST`/`$_GET`/`$_REQUEST`

### Access Control Layer
- [ ] **Authentication:** `is_user_logged_in()` check
- [ ] **Authorization:** `current_user_can()` check with appropriate capability
- [ ] **CSRF Protection:** Nonce verification with `wp_verify_nonce()`

### Data Layer
- [ ] **Data Existence:** Verify data exists before use
- [ ] **Data Ownership:** Verify user can access this specific data
- [ ] **SQL Safety:** Use `$wpdb->prepare()` for all queries

### Output Layer
- [ ] **Output Escaping:** All output escaped for context
- [ ] **Error Handling:** Generic error messages (no information leakage)
- [ ] **Response Validation:** Only expected data returned in response

### Supporting Layers
- [ ] **Rate Limiting:** Protect against brute force/DoS
- [ ] **Logging:** Log security-relevant events (failed auth, etc.)
- [ ] **Monitoring:** Alert on suspicious patterns

---

## Common Defense in Depth Mistakes

### ❌ Mistake 1: Single Layer Only

```php
// BAD: Only sanitizes, no validation or authorization
function bad_update_setting( $value ) {
    $clean_value = sanitize_text_field( $value );  // Only 1 layer!
    update_option( 'my_setting', $clean_value );
}
```

**Problem:** If sanitization has a bug, there's no backup protection.

### ✅ Fix: Multiple Layers

```php
// GOOD: Validation, authorization, sanitization, escaping
function good_update_setting( $value ) {
    // Layer 1: Validation
    if ( empty( $value ) ) {
        return new WP_Error( 'empty_value', 'Value cannot be empty' );
    }

    // Layer 2: Authorization
    if ( ! current_user_can( 'manage_options' ) ) {
        return new WP_Error( 'unauthorized', 'Insufficient permissions' );
    }

    // Layer 3: Sanitization
    $clean_value = sanitize_text_field( wp_unslash( $value ) );

    // Layer 4: Update (with validation)
    $result = update_option( 'my_setting', $clean_value );

    // Layer 5: Output escaping when displaying
    // echo esc_html( get_option( 'my_setting' ) );

    return $result;
}
```

---

### ❌ Mistake 2: Assuming Earlier Layers Work

```php
// BAD: Assumes current_user_can() is enough
function bad_delete_user( $user_id ) {
    if ( current_user_can( 'delete_users' ) ) {
        wp_delete_user( $user_id );  // No validation, no additional checks!
    }
}
```

**Problem:** Missing input validation, CSRF protection, data access control.

### ✅ Fix: Don't Trust Any Single Layer

```php
// GOOD: Multiple independent layers
function good_delete_user( $user_id ) {
    // Layer 1: Validate input
    $user_id = absint( $user_id );
    if ( ! $user_id ) {
        return new WP_Error( 'invalid_id', 'Invalid user ID' );
    }

    // Layer 2: Authentication
    if ( ! is_user_logged_in() ) {
        return new WP_Error( 'not_authenticated', 'Authentication required' );
    }

    // Layer 3: Authorization
    if ( ! current_user_can( 'delete_users' ) ) {
        return new WP_Error( 'unauthorized', 'Insufficient permissions' );
    }

    // Layer 4: CSRF protection (if from POST request)
    if ( ! wp_verify_nonce( $_POST['nonce'] ?? '', 'delete-user-nonce' ) ) {
        return new WP_Error( 'invalid_nonce', 'Invalid security token' );
    }

    // Layer 5: Data access control
    $user = get_userdata( $user_id );
    if ( ! $user ) {
        return new WP_Error( 'user_not_found', 'User not found' );
    }

    // Prevent deleting yourself
    if ( $user_id === get_current_user_id() ) {
        return new WP_Error( 'cannot_delete_self', 'Cannot delete your own account' );
    }

    // Prevent non-admins from deleting admins
    if ( in_array( 'administrator', $user->roles ) && ! current_user_can( 'manage_options' ) ) {
        return new WP_Error( 'cannot_delete_admin', 'Cannot delete administrator' );
    }

    // All layers passed - safe to proceed
    return wp_delete_user( $user_id );
}
```

---

## WordPress-Specific Defense in Depth Patterns

### REST API Endpoints

```php
register_rest_route( 'myplugin/v1', '/admin-action', array(
    'methods'             => 'POST',
    'callback'            => 'myplugin_admin_action_callback',

    // Layer 1: permission_callback (authorization)
    'permission_callback' => function() {
        return current_user_can( 'manage_options' );
    },

    // Layer 2: args validation and sanitization
    'args'                => array(
        'action' => array(
            'required'          => true,
            'type'              => 'string',
            'sanitize_callback' => 'sanitize_text_field',
            'validate_callback' => function( $param ) {
                return in_array( $param, array( 'action1', 'action2' ), true );
            },
        ),
    ),
) );

function myplugin_admin_action_callback( WP_REST_Request $request ) {
    // Layer 3: Additional authentication check (defense in depth)
    if ( ! is_user_logged_in() ) {
        return new WP_Error( 'not_authenticated', 'Authentication required', array( 'status' => 401 ) );
    }

    // Layer 4: Nonce verification (redundant with REST API nonce, but safe)
    $nonce = $request->get_header( 'X-WP-Nonce' );
    if ( ! wp_verify_nonce( $nonce, 'wp_rest' ) ) {
        return new WP_Error( 'invalid_nonce', 'Invalid nonce', array( 'status' => 403 ) );
    }

    // Layer 5: Get sanitized parameter (already sanitized by REST API)
    $action = $request->get_param( 'action' );

    // Layer 6: Additional validation (even though validate_callback already ran)
    $allowed_actions = array( 'action1', 'action2' );
    if ( ! in_array( $action, $allowed_actions, true ) ) {
        return new WP_Error( 'invalid_action', 'Invalid action', array( 'status' => 400 ) );
    }

    // All layers passed - proceed
    $result = perform_admin_action( $action );

    // Layer 7: Escape output
    return rest_ensure_response( array(
        'success' => true,
        'action'  => esc_html( $action ),
        'result'  => esc_html( $result ),
    ) );
}
```

---

## Key Takeaways

1. **Never rely on a single security control** - Always implement multiple layers
2. **Each layer is independent** - Failure of one layer shouldn't compromise others
3. **Be redundant** - It's OK to check the same thing twice in different ways
4. **Validate AND sanitize** - Both are necessary
5. **Sanitize input AND escape output** - Both are necessary (XSS defense)
6. **Authenticate AND authorize** - Both are necessary
7. **Use WordPress functions** - They implement defense in depth correctly

**Remember:** The goal is NOT to write perfect code (impossible), but to ensure that even if your code has bugs, multiple layers of defense prevent exploitation.

---

## Additional Resources

- [WordPress Security Patterns](wordpress-patterns.md)
- [Security Testing Guide](security-testing.md)
- [OWASP Defense in Depth](https://owasp.org/www-community/Defense_in_Depth)
- [WordPress Security Whitepaper](https://wordpress.org/about/security/)

