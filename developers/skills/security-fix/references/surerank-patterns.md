# SureRank Security Patterns

This document outlines SureRank and SureRank Pro specific security patterns, conventions, and common security checks used throughout the codebase.

## SureRank Architecture Overview

**Two-plugin system:**
- **SureRank** (free) - Core SEO toolkit
- **SureRank Pro** (paid addon) - Advanced features, requires free plugin

**Key architectural patterns:**
- Singleton pattern via `Get_Instance` trait
- REST API controllers extend `Api_Base`
- Settings accessed via `Get::option()` / `Update::option()`
- Pro extends Free via WordPress hooks only

## REST API Security Patterns

### Standard SureRank API Controller

SureRank REST API controllers extend `Api_Base` and should follow this pattern:

```php
namespace SureRank\Inc\Api;

use SureRank\Inc\Api\Api_Base;
use SureRank\Inc\Traits\Get_Instance;
use SureRank\Inc\Utility\Send_Json;

class My_Endpoint extends Api_Base {

    use Get_Instance;

    /**
     * Register routes
     */
    public function register_routes() {
        register_rest_route(
            $this->namespace, // 'surerank/v1'
            '/my-endpoint',
            array(
                'methods'             => \WP_REST_Request::READABLE, // or CREATABLE, DELETABLE
                'callback'            => array( $this, 'get_data' ),
                'permission_callback' => array( $this, 'validate_permission' ),
            )
        );
    }

    /**
     * Permission callback
     */
    public function validate_permission( $request ) {
        // ALWAYS use validate_permission from Api_Base
        // This checks nonce and user capabilities
        return $this->validate_request_permission( $request );
    }

    /**
     * Endpoint callback
     */
    public function get_data( $request ) {
        // 1. Sanitize inputs
        $post_id = absint( $request->get_param( 'post_id' ) );

        // 2. Validate inputs
        if ( ! $post_id ) {
            return Send_Json::error( 'Invalid post ID', 400 );
        }

        // 3. Additional authorization if needed
        if ( ! current_user_can( 'edit_post', $post_id ) ) {
            return Send_Json::error( 'Insufficient permissions', 403 );
        }

        // 4. Process...
        $data = $this->do_something( $post_id );

        // 5. Return response
        return Send_Json::success( $data );
    }
}
```

### Api_Base Parent Class

The `Api_Base` class (located at `surerank/inc/api/api-base.php`) provides:

- **`validate_request_permission( $request )`** - Standard permission check
  - Verifies nonce
  - Checks user capabilities (typically `edit_posts` or `manage_options`)
  - Returns WP_Error on failure, true on success

**Always use this method** rather than implementing custom permission checks.

### Send_Json Utility

Use `Send_Json` for all API responses (located at `surerank/inc/utility/send-json.php`):

```php
use SureRank\Inc\Utility\Send_Json;

// Success response
return Send_Json::success(
    array( 'data' => $result ),
    'Operation successful', // optional message
    200 // optional status code
);

// Error response
return Send_Json::error(
    'Error message',
    400, // status code
    array( 'additional' => 'context' ) // optional data
);
```

**Never use** `wp_send_json()` or `wp_send_json_error()` directly - always use `Send_Json`.

## Settings Security

### Reading Settings

```php
use SureRank\Inc\Utility\Get;

// Get entire settings array
$settings = Get::option();

// Get specific setting with default
$api_key = Get::option( 'google_search_console_api_key', '' );
```

### Updating Settings

```php
use SureRank\Inc\Utility\Update;

// Update entire settings array
Update::option( $new_settings );

// Update specific setting
$settings = Get::option();
$settings['new_key'] = sanitize_text_field( $value );
Update::option( $settings );
```

**NEVER use:**
- `get_option( SURERANK_SETTINGS )` directly
- `update_option( SURERANK_SETTINGS, $data )` directly

Always go through `Get::option()` and `Update::option()` - they handle sanitization and validation.

## Common Entry Points to Audit

When fixing a security issue, check these common entry points for similar vulnerabilities:

### 1. REST API Endpoints

**Location:** `surerank/inc/api/` and `surerank-pro/inc/api/`

**Check for:**
- Missing or weak `permission_callback`
- Missing nonce verification
- Insufficient capability checks
- Input sanitization

**Search command:**
```bash
grep -r "register_rest_route" surerank/inc/api/
```

### 2. Admin AJAX Handlers

**Location:** Search for `wp_ajax_` hooks

**Check for:**
- Missing `check_ajax_referer()`
- Missing capability checks
- Public handlers (`wp_ajax_nopriv_`) that shouldn't be public

**Search command:**
```bash
grep -r "wp_ajax_" surerank/inc/
```

### 3. Settings Pages

**Location:** `surerank/inc/admin/` and related admin classes

**Check for:**
- Settings saved without sanitization
- Settings displayed without escaping
- CSRF protection on settings forms

### 4. Post Meta Operations

**Location:** Anywhere using `get_post_meta()` or `update_post_meta()`

**Check for:**
- Unsanitized meta values
- Missing capability checks before updates
- Meta values displayed without escaping

### 5. Frontend Rendering

**Location:** Public-facing templates, shortcodes, blocks

**Check for:**
- Output escaping (`esc_html()`, `esc_url()`, `esc_attr()`)
- Sanitized shortcode attributes
- Escaped JSON data in inline scripts

## SureRank-Specific Constants

Use these constants instead of hardcoding strings:

```php
SURERANK_SETTINGS        // 'surerank_settings' - main settings meta key
SURERANK_PREFIX          // 'surerank' - plugin prefix
SURERANK_PRO_PREFIX      // 'surerank-pro' - pro plugin prefix
SURERANK_VERSION         // Current version
SURERANK_FILE            // Main plugin file path
```

## Pro Plugin Security

SureRank Pro extends the free plugin via hooks. Security considerations:

### Hook-Based Extension

Pro should NEVER directly modify Free's code. It extends via filters and actions:

```php
// In surerank-pro/inc/some-class.php

// Extend API controllers
add_filter( 'surerank_api_controllers', array( $this, 'add_pro_controllers' ) );

// Add Pro components
add_action( 'surerank_before_load_components', array( $this, 'load_pro_components' ) );
```

### Pro-Specific Security Checks

When adding Pro features, ensure:
- Free plugin is active and meets minimum version
- Pro license is valid (if applicable)
- All security checks from Free apply to Pro as well

## Common Security Checklist for SureRank

Use this checklist when reviewing or fixing security issues:

### ✅ REST API Security
- [ ] `permission_callback` is defined and calls `validate_request_permission()`
- [ ] Nonce is verified via `Api_Base` parent class
- [ ] User has required capabilities (`edit_posts`, `manage_options`, etc.)
- [ ] All inputs are sanitized (`sanitize_text_field()`, `absint()`, etc.)
- [ ] All outputs use `Send_Json::success()` or `Send_Json::error()`
- [ ] Error messages don't leak sensitive information

### ✅ AJAX Handler Security
- [ ] `check_ajax_referer()` is called first thing
- [ ] User capabilities are checked
- [ ] `wp_ajax_nopriv_` is NOT registered unless public access is intended
- [ ] Inputs are sanitized
- [ ] Response uses `wp_send_json_success()` or `wp_send_json_error()`

### ✅ Settings Security
- [ ] Settings are retrieved via `Get::option()`
- [ ] Settings are saved via `Update::option()`
- [ ] Form submissions verify nonce
- [ ] User has `manage_options` capability
- [ ] All settings values are sanitized before saving
- [ ] Settings are escaped when displayed

### ✅ Post Meta Security
- [ ] User can edit the post before updating meta
- [ ] Meta values are sanitized before saving
- [ ] Meta values are escaped when displayed
- [ ] Meta keys use SURERANK_PREFIX to avoid conflicts

### ✅ Frontend Security
- [ ] All dynamic output is escaped (`esc_html()`, `esc_url()`, `esc_attr()`)
- [ ] Shortcode attributes are sanitized
- [ ] Inline JavaScript data is escaped (`wp_json_encode()` + `esc_html()`)
- [ ] No direct use of `$_GET`, `$_POST`, or `$_REQUEST` without sanitization

### ✅ SQL Security
- [ ] All dynamic queries use `$wpdb->prepare()`
- [ ] Placeholders (`%d`, `%s`, `%f`) are used correctly
- [ ] No direct concatenation of user input into queries

## Links to Documentation

For more context on SureRank architecture and patterns:

- **Main documentation:** `surerank/docs/`
- **Architecture guide:** `surerank/docs/ARCHITECTURE.md`
- **Coding standards:** `surerank/docs/CODING-STANDARDS.md`
- **Database schema:** `surerank/docs/DATABASE-SCHEMA.md`
- **Hooks reference:** `surerank/docs/HOOKS-REFERENCE.md`

## Example: Fixing a Missing Capability Check

**Vulnerable code:**

```php
public function validate_permission( $request ) {
    // BAD: No capability check!
    return true;
}
```

**Fixed code:**

```php
public function validate_permission( $request ) {
    // GOOD: Use parent class method
    return $this->validate_request_permission( $request );
}
```

## Example: Fixing Missing Input Sanitization

**Vulnerable code:**

```php
public function save_settings( $request ) {
    $settings = $request->get_param( 'settings' );
    Update::option( $settings ); // BAD: Unsanitized input!
}
```

**Fixed code:**

```php
public function save_settings( $request ) {
    $settings = $request->get_param( 'settings' );

    // Sanitize each field
    $sanitized = array(
        'api_key' => sanitize_text_field( $settings['api_key'] ?? '' ),
        'enabled' => (bool) ( $settings['enabled'] ?? false ),
        'url'     => esc_url_raw( $settings['url'] ?? '' ),
    );

    Update::option( $sanitized );
}
```

## Example: Fixing Missing Output Escaping

**Vulnerable code:**

```php
// In a template file
<div class="surerank-title"><?php echo $title; ?></div> <!-- BAD: XSS risk! -->
```

**Fixed code:**

```php
// In a template file
<div class="surerank-title"><?php echo esc_html( $title ); ?></div> <!-- GOOD -->
```

---

**Remember:** When in doubt, over-sanitize and over-escape. It's better to be overly cautious with security than to leave a vulnerability.
