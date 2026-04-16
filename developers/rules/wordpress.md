---
description: WordPress plugin and theme development standards
globs:
  - "wp-content/**/*.php"
  - "wp-plugin/**/*.php"
  - "includes/**/*.php"
  - "**/wordpress/**/*.php"
---

# WordPress Rules

## Security (Non-Negotiable)
- Sanitize ALL input: `sanitize_text_field()`, `absint()`, `sanitize_email()`, `wp_kses()`
- Escape ALL output: `esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`
- Nonce on ALL forms: `wp_nonce_field()` + `wp_verify_nonce()`
- Nonce on ALL AJAX: `check_ajax_referer()`
- Capability check before ALL privileged operations: `current_user_can()`
- Prepared statements for ALL database queries: `$wpdb->prepare()`
- Never trust `$_GET`, `$_POST`, `$_REQUEST` — always sanitize first

## Plugin Standards
- Every PHP file starts with `defined('ABSPATH') || exit;`
- Plugin prefix on ALL functions, classes, hooks, constants, options
- Consistent text domain for ALL translatable strings
- Proper plugin headers in main file
- Provide `uninstall.php` or `register_uninstall_hook` for cleanup

## Hooks and Actions
- Use `wp_enqueue_scripts` for frontend assets (not `wp_head`)
- Use `admin_enqueue_scripts` for admin assets
- Document non-default hook priorities with inline comment
- Prefix ALL custom hooks with plugin slug
- Clean up hooks in deactivation where appropriate

## Database
- Use `$wpdb->prepare()` for ALL queries with variables — no exceptions
- Use `$wpdb->prefix` for table names
- Use WordPress Options API for simple key-value data
- Use `dbDelta()` for table creation in activation hooks
- Always check `$wpdb->last_error` after critical queries

## Coding Standards
- Follow WordPress Coding Standards (tabs for indentation in PHP)
- Yoda conditions for comparisons: `if ( 'value' === $var )`
- Spaces inside parentheses: `if ( $condition )`
- Use WordPress APIs over raw PHP: `wp_remote_get()` over `curl`
