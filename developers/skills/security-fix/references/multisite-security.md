# WordPress Multisite Security Reference

This guide covers security considerations specific to WordPress Multisite installations. Multisite introduces additional complexity and potential security vulnerabilities that don't exist in single-site WordPress.

---

## Overview

WordPress Multisite allows managing multiple WordPress sites from a single installation. This introduces unique security challenges:

- Network-wide vs. site-specific permissions
- Super Admin vs. regular Admin roles
- Site switching (`switch_to_blog()`) security
- Cross-site data leakage
- Network-wide settings and options

**Key Principle:** Always check capabilities AFTER switching blogs, and use network-wide capabilities when appropriate.

---

## Super Admin vs. Regular Admin

### Checking for Super Admin

```php
// Check if current user is a Super Admin
if ( ! is_super_admin() ) {
    wp_die( 'Only super admins can access this feature' );
}

// Alternative (less common)
if ( ! is_super_admin( get_current_user_id() ) ) {
    wp_die( 'Unauthorized' );
}
```

### Network-Wide Capabilities

```php
// Network-wide capabilities (require super admin)
$network_capabilities = array(
    'manage_network',         // Manage network settings
    'manage_sites',           // Manage sites in the network
    'manage_network_users',   // Manage users across network
    'manage_network_plugins', // Manage network-activated plugins
    'manage_network_themes',  // Manage network-enabled themes
    'manage_network_options', // Manage network options
);

// Check network-wide capability
if ( ! current_user_can( 'manage_network' ) ) {
    wp_send_json_error( 'Insufficient network permissions', 403 );
}

// Check if user can manage a specific site
$blog_id = absint( $_POST['blog_id'] ?? 0 );
if ( ! current_user_can( 'manage_sites' ) ) {
    wp_send_json_error( 'Cannot manage sites', 403 );
}
```

---

## Site Switching Security

### The switch_to_blog() Problem

**CRITICAL:** Capability checks BEFORE `switch_to_blog()` check the CURRENT blog, not the target blog!

**❌ VULNERABLE:**
```php
// WRONG: Checks capability on CURRENT blog
$target_blog = absint( $_POST['blog_id'] );

if ( ! current_user_can( 'edit_posts' ) ) { // Checks current blog!
    wp_die( 'Unauthorized' );
}

switch_to_blog( $target_blog );
wp_insert_post( $data ); // User might NOT have permission on target blog!
restore_current_blog();
```

**✅ SECURE:**
```php
// CORRECT: Check capability AFTER switching
$target_blog = absint( $_POST['blog_id'] ?? 0 );

if ( ! $target_blog ) {
    wp_send_json_error( 'Invalid blog ID', 400 );
}

switch_to_blog( $target_blog );

// Now check capability on the TARGET blog
if ( ! current_user_can( 'edit_posts' ) ) {
    restore_current_blog();
    wp_send_json_error( 'You do not have permission on this site', 403 );
}

// Proceed with operation
$post_id = wp_insert_post( $data );

restore_current_blog();

if ( is_wp_error( $post_id ) ) {
    wp_send_json_error( $post_id->get_error_message(), 500 );
}

wp_send_json_success( array( 'post_id' => $post_id ) );
```

### Always restore_current_blog()

```php
// ✅ GOOD: Always restore, even on error
$target_blog = absint( $_GET['blog_id'] ?? 0 );

switch_to_blog( $target_blog );

try {
    if ( ! current_user_can( 'edit_posts' ) ) {
        throw new Exception( 'Unauthorized' );
    }

    // Do work...

} catch ( Exception $e ) {
    restore_current_blog();
    wp_die( $e->getMessage() );
}

restore_current_blog();

// ✅ BETTER: Use finally block (PHP 5.5+)
$target_blog = absint( $_GET['blog_id'] ?? 0 );

switch_to_blog( $target_blog );

try {
    if ( ! current_user_can( 'edit_posts' ) ) {
        wp_send_json_error( 'Unauthorized', 403 );
    }

    // Do work...
    wp_send_json_success( $result );

} finally {
    restore_current_blog(); // Always executes
}
```

---

## Network-Wide Operations

### Iterating Over All Sites Safely

```php
// Get all sites in the network
function process_all_sites_safely() {
    // Only super admins should do network-wide operations
    if ( ! is_super_admin() ) {
        return new WP_Error( 'unauthorized', 'Only super admins can perform this action' );
    }

    $sites = get_sites( array(
        'number' => 0, // Get all sites (use with caution on large networks!)
    ) );

    foreach ( $sites as $site ) {
        switch_to_blog( $site->blog_id );

        try {
            // Perform operation on this site
            do_site_operation();

        } catch ( Exception $e ) {
            // Log error but continue with other sites
            error_log( sprintf(
                'Error on site %d: %s',
                $site->blog_id,
                $e->getMessage()
            ) );
        } finally {
            restore_current_blog();
        }
    }

    return true;
}

// Better: Limit number of sites per request (for large networks)
function process_sites_in_batches( $offset = 0, $limit = 100 ) {
    if ( ! is_super_admin() ) {
        return new WP_Error( 'unauthorized', 'Super admin required' );
    }

    $sites = get_sites( array(
        'number' => $limit,
        'offset' => $offset,
    ) );

    foreach ( $sites as $site ) {
        switch_to_blog( $site->blog_id );

        try {
            do_site_operation();
        } finally {
            restore_current_blog();
        }
    }

    // If there are more sites, return next offset
    if ( count( $sites ) === $limit ) {
        return $offset + $limit;
    }

    return false; // Done
}
```

---

## Cross-Site Data Access

### Checking User Membership

```php
// Check if user is a member of a specific site
function user_can_access_site( $user_id, $blog_id ) {
    $user_id = absint( $user_id );
    $blog_id = absint( $blog_id );

    if ( ! $user_id || ! $blog_id ) {
        return false;
    }

    // Check if user is a member of the blog
    return is_user_member_of_blog( $user_id, $blog_id );
}

// Example usage
$target_blog = absint( $_POST['blog_id'] ?? 0 );
$user_id = get_current_user_id();

if ( ! user_can_access_site( $user_id, $target_blog ) ) {
    wp_send_json_error( 'You are not a member of this site', 403 );
}
```

### Reading Data from Another Site

```php
// ✅ SECURE: Read post from another site
function get_post_from_site( $blog_id, $post_id ) {
    $blog_id = absint( $blog_id );
    $post_id = absint( $post_id );

    if ( ! $blog_id || ! $post_id ) {
        return null;
    }

    // Check if current user can access this site
    if ( ! is_user_member_of_blog( get_current_user_id(), $blog_id ) && ! is_super_admin() ) {
        return new WP_Error( 'unauthorized', 'Not a member of this site' );
    }

    switch_to_blog( $blog_id );

    // Check if user can read this post on the target site
    if ( ! current_user_can( 'read_post', $post_id ) ) {
        restore_current_blog();
        return new WP_Error( 'unauthorized', 'Cannot read this post' );
    }

    $post = get_post( $post_id );
    restore_current_blog();

    return $post;
}
```

---

## Network Options vs. Site Options

### get_site_option() vs. get_option()

```php
// Site-specific option (stored per-site)
$site_option = get_option( 'my_plugin_settings' );

// Network-wide option (stored once for entire network)
$network_option = get_site_option( 'my_plugin_network_settings' );

// ⚠️ IMPORTANT: Use correct function based on scope
function get_plugin_setting( $key, $default = '' ) {
    if ( is_multisite() ) {
        // Get network-wide setting
        return get_site_option( $key, $default );
    } else {
        // Single site - use regular option
        return get_option( $key, $default );
    }
}
```

### Updating Network Options Securely

```php
// Only super admins should update network options
function update_network_settings( $settings ) {
    if ( ! is_super_admin() ) {
        return new WP_Error( 'unauthorized', 'Only super admins can update network settings' );
    }

    // Sanitize settings
    $safe_settings = array(
        'network_name' => sanitize_text_field( $settings['network_name'] ?? '' ),
        'max_upload_size' => absint( $settings['max_upload_size'] ?? 0 ),
    );

    // Update network option
    update_site_option( 'my_plugin_network_settings', $safe_settings );

    return true;
}
```

---

## Network-Activated Plugins

### Checking if Plugin is Network-Activated

```php
// Check if a plugin is network-activated
function is_plugin_network_active( $plugin_file ) {
    if ( ! is_multisite() ) {
        return false;
    }

    $plugins = get_site_option( 'active_sitewide_plugins' );
    return isset( $plugins[ $plugin_file ] );
}

// Example usage
if ( is_plugin_network_active( 'my-plugin/my-plugin.php' ) ) {
    // Plugin is network-activated
    // Settings should use get_site_option()
} else {
    // Plugin is activated per-site
    // Settings should use get_option()
}
```

---

## User Management in Multisite

### Adding User to a Site

```php
// Add user to a specific site
function add_user_to_site_safely( $user_id, $blog_id, $role = 'subscriber' ) {
    // Only super admins or site admins can add users
    if ( ! current_user_can( 'manage_network_users' ) && ! current_user_can( 'promote_users' ) ) {
        return new WP_Error( 'unauthorized', 'Cannot add users' );
    }

    $user_id = absint( $user_id );
    $blog_id = absint( $blog_id );

    if ( ! $user_id || ! $blog_id ) {
        return new WP_Error( 'invalid_input', 'Invalid user or blog ID' );
    }

    // Validate role
    $allowed_roles = array( 'subscriber', 'contributor', 'author', 'editor' );
    if ( ! in_array( $role, $allowed_roles, true ) ) {
        $role = 'subscriber'; // Default to subscriber
    }

    // Add user to blog
    add_user_to_blog( $blog_id, $user_id, $role );

    return true;
}
```

### Removing User from a Site

```php
// Remove user from a specific site
function remove_user_from_site_safely( $user_id, $blog_id ) {
    // Only super admins or site admins can remove users
    if ( ! current_user_can( 'manage_network_users' ) && ! current_user_can( 'remove_users' ) ) {
        return new WP_Error( 'unauthorized', 'Cannot remove users' );
    }

    $user_id = absint( $user_id );
    $blog_id = absint( $blog_id );

    if ( ! $user_id || ! $blog_id ) {
        return new WP_Error( 'invalid_input', 'Invalid user or blog ID' );
    }

    // Cannot remove yourself
    if ( $user_id === get_current_user_id() ) {
        return new WP_Error( 'cannot_remove_self', 'You cannot remove yourself' );
    }

    // Remove user from blog
    remove_user_from_blog( $user_id, $blog_id );

    return true;
}
```

---

## Multisite-Specific AJAX Security

### Network Admin AJAX

```php
// Register network admin AJAX handler
add_action( 'wp_ajax_my_network_action', 'handle_network_ajax' );

function handle_network_ajax() {
    // 1. Verify nonce
    check_ajax_referer( 'my-network-nonce', 'nonce' );

    // 2. Check if super admin
    if ( ! is_super_admin() ) {
        wp_send_json_error( array(
            'message' => 'Only super admins can perform this action',
        ), 403 );
    }

    // 3. Sanitize inputs
    $blog_id = absint( $_POST['blog_id'] ?? 0 );

    if ( ! $blog_id ) {
        wp_send_json_error( array(
            'message' => 'Invalid blog ID',
        ), 400 );
    }

    // 4. Switch to blog
    switch_to_blog( $blog_id );

    try {
        // Perform operation on target blog
        $result = do_something();

        wp_send_json_success( array(
            'message' => 'Operation successful',
            'data'    => $result,
        ) );

    } catch ( Exception $e ) {
        wp_send_json_error( array(
            'message' => $e->getMessage(),
        ), 500 );

    } finally {
        restore_current_blog();
    }
}
```

---

## Multisite REST API Security

### Network-Wide REST Endpoint

```php
// Register network-wide REST route
function register_network_rest_routes() {
    register_rest_route( 'myplugin/v1', '/network/sites', array(
        'methods'             => WP_REST_Server::READABLE,
        'callback'            => 'get_network_sites',
        'permission_callback' => function() {
            // Only super admins can list all sites
            return is_super_admin();
        },
    ) );

    register_rest_route( 'myplugin/v1', '/network/sites/(?P<id>\d+)', array(
        'methods'             => WP_REST_Server::EDITABLE,
        'callback'            => 'update_network_site',
        'permission_callback' => function( $request ) {
            $blog_id = absint( $request->get_param( 'id' ) );

            // Super admin can edit any site
            if ( is_super_admin() ) {
                return true;
            }

            // Or must be admin of the specific site
            switch_to_blog( $blog_id );
            $can_edit = current_user_can( 'manage_options' );
            restore_current_blog();

            return $can_edit;
        },
        'args' => array(
            'id' => array(
                'required'          => true,
                'validate_callback' => function( $param ) {
                    return is_numeric( $param ) && $param > 0;
                },
                'sanitize_callback' => 'absint',
            ),
        ),
    ) );
}
add_action( 'rest_api_init', 'register_network_rest_routes' );

function update_network_site( WP_REST_Request $request ) {
    $blog_id = absint( $request->get_param( 'id' ) );

    switch_to_blog( $blog_id );

    try {
        // Check permission again (defense in depth)
        if ( ! current_user_can( 'manage_options' ) && ! is_super_admin() ) {
            throw new Exception( 'Unauthorized' );
        }

        // Update site settings
        $settings = $request->get_json_params();
        update_option( 'blogname', sanitize_text_field( $settings['name'] ?? '' ) );
        update_option( 'blogdescription', sanitize_text_field( $settings['description'] ?? '' ) );

        $response = array(
            'success' => true,
            'blog_id' => $blog_id,
        );

    } catch ( Exception $e ) {
        restore_current_blog();
        return new WP_Error( 'update_failed', $e->getMessage(), array( 'status' => 500 ) );
    }

    restore_current_blog();

    return rest_ensure_response( $response );
}
```

---

## Common Multisite Vulnerabilities

### 1. Capability Check Before switch_to_blog()

**❌ VULNERABLE:**
```php
if ( ! current_user_can( 'edit_posts' ) ) { // Checks current blog
    wp_die( 'Unauthorized' );
}

switch_to_blog( $target_blog );
wp_insert_post( $data ); // Might not have permission here!
restore_current_blog();
```

**✅ FIXED:**
```php
switch_to_blog( $target_blog );

if ( ! current_user_can( 'edit_posts' ) ) { // Checks target blog
    restore_current_blog();
    wp_die( 'Unauthorized' );
}

wp_insert_post( $data );
restore_current_blog();
```

### 2. Forgetting to restore_current_blog()

**❌ VULNERABLE:**
```php
switch_to_blog( $target_blog );

if ( some_error_condition() ) {
    return; // BUG: Never restored current blog!
}

do_something();
restore_current_blog();
```

**✅ FIXED:**
```php
switch_to_blog( $target_blog );

try {
    if ( some_error_condition() ) {
        throw new Exception( 'Error' );
    }

    do_something();

} finally {
    restore_current_blog(); // Always executes
}
```

### 3. Network Option vs. Site Option Confusion

**❌ VULNERABLE:**
```php
// Storing network-wide setting in site option
update_option( 'network_api_key', $api_key ); // Wrong! Only stores on current site

// Later, on different site:
$api_key = get_option( 'network_api_key' ); // Not found!
```

**✅ FIXED:**
```php
// Storing network-wide setting correctly
update_site_option( 'network_api_key', $api_key ); // Stored network-wide

// Later, on any site:
$api_key = get_site_option( 'network_api_key' ); // Found!
```

---

## Multisite Security Checklist

Use this when reviewing multisite code:

### General
- [ ] Checked if code needs to work in multisite environment
- [ ] Tested code on both single-site and multisite installations

### Capabilities
- [ ] Used `is_super_admin()` for network-wide operations
- [ ] Used network capabilities (`manage_network`, `manage_sites`, etc.) where appropriate
- [ ] Checked capabilities AFTER `switch_to_blog()`, not before

### Blog Switching
- [ ] Always call `restore_current_blog()` after `switch_to_blog()`
- [ ] Used try/finally or equivalent to ensure restoration
- [ ] Verified authorization on target blog, not current blog

### Options & Settings
- [ ] Used `get_site_option()` for network-wide settings
- [ ] Used `get_option()` for site-specific settings
- [ ] Updated network options only as super admin

### User Management
- [ ] Checked `is_user_member_of_blog()` before granting access
- [ ] Used `add_user_to_blog()` / `remove_user_from_blog()` correctly
- [ ] Validated user cannot remove themselves from blog

### Data Isolation
- [ ] Ensured data from one site doesn't leak to another
- [ ] Validated cross-site data access is authorized
- [ ] Used appropriate table prefix when querying database

---

## Additional Resources

- [WordPress Multisite Administration Handbook](https://wordpress.org/support/article/multisite-network-administration/)
- [WordPress Multisite Codex](https://codex.wordpress.org/Multisite)
- [WordPress Security Patterns](wordpress-patterns.md)
- [WordPress Security Checklist](wp-security-checklist.md)
