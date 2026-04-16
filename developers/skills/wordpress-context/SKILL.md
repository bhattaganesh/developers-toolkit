---
name: wordpress-context
description: "Auto-activates when working on WordPress plugin or theme files. Use this skill when editing files with WordPress functions like add_action, add_filter, or in wp-content/ directories. Provides WPCS reminders and security checklist."
version: 1.0.0
---

# WordPress Context

## Security Checklist (MANDATORY)
- **Sanitize all input** — use `sanitize_text_field()`, `sanitize_email()`, `absint()`, `wp_kses_post()` for every piece of user input
- **Escape all output** — use `esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()` at the point of output
- **Nonce verification** — use `wp_verify_nonce()` on every form submission and AJAX handler
- **Capability checks** — use `current_user_can()` before performing any privileged operation
- **Prepared statements** — always use `$wpdb->prepare()` for database queries with variables. Never concatenate SQL.

## Coding Standards (WPCS)
- Prefix all functions, classes, hooks, and global variables with the plugin/theme prefix
- Use consistent text domain for all translatable strings: `__('text', 'text-domain')`
- Follow WordPress naming: `snake_case` for functions, hooks, and variables
- Use WordPress APIs over direct PHP equivalents (`wp_remote_get()` not `curl`, `wp_mail()` not `mail()`)
- File naming: `class-{name}.php` for class files, `functions-{feature}.php` for function files

## Hooks & Filters
- Use specific hook priorities when order matters — default is 10
- Remove hooks before re-adding modified versions to avoid double-firing
- Document custom hooks with PHPDoc for discoverability
- Use `add_action` for side effects, `add_filter` for data transformation

## Database
- Use WordPress table prefix: `$wpdb->prefix . 'custom_table'`
- Always use `$wpdb->prepare()` for parameterized queries
- Use `dbDelta()` for table creation in activation hooks
- Store plugin options with `get_option()` / `update_option()` — not custom tables for simple key-value data

## REST API
- Register custom endpoints with `register_rest_route()` in the `rest_api_init` action
- Use `permission_callback` on every route — never set to `__return_true` for authenticated endpoints
- Return `WP_Error` for error responses — WordPress handles HTTP status mapping
- Use `sanitize_callback` and `validate_callback` on all args

## Common Patterns
- Enqueue scripts/styles with `wp_enqueue_script()` / `wp_enqueue_style()` — never hardcode `<script>` tags
- Use `wp_localize_script()` or `wp_add_inline_script()` to pass PHP data to JavaScript
- Check `is_wp_error()` on every function that can return `WP_Error`
- Use transients (`get_transient()` / `set_transient()`) for caching expensive operations
