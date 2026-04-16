---
description: Build a new WordPress feature — custom post types, REST endpoints, admin pages, Gutenberg blocks, hooks, and filters following WPCS
---

# New WP Feature

Generate production-quality WordPress plugin or theme code using the `wp-developer` agent — CPTs, REST endpoints, admin pages, Gutenberg blocks, hooks, and filters.

## Instructions

1. **Identify what to build** — Ask the user:
   - **Custom Post Type / Taxonomy** — Resource name, labels, capabilities, meta fields
   - **REST API endpoint** — Route, methods (GET/POST/PUT/DELETE), permission model
   - **Admin page** — Menu placement, settings fields, options storage
   - **Gutenberg block** — Block name, attributes, server-side vs client-side rendering
   - **Hook / Filter** — Action or filter name, priority, expected use

2. **Read existing code** — Find and read:
   - Main plugin file (for namespace and prefix conventions)
   - Similar existing features (CPT, REST, admin) to match project patterns
   - `composer.json` or `package.json` for available dependencies

3. **Launch wp-developer** — Use the Task tool to spawn the **wp-developer** agent with:
   - Feature type and full specification
   - Existing plugin prefix and file structure
   - Related existing code to match patterns

4. **Review output** — Confirm the generated code:
   - All functions, hooks, meta keys, option names, CSS classes prefixed
   - All input sanitized: `sanitize_text_field()`, `absint()`, `wp_kses_post()`
   - All output escaped: `esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`
   - Nonces verified on every form and AJAX handler
   - Capability checks before every privileged operation
   - Assets enqueued properly (not inlined in PHP)
   - All strings translatable with text domain

5. **Verify** — Run a quick syntax check:
   ```bash
   php -l path/to/new-file.php
   ```

## What the Agent Builds

- **Custom Post Types** — Labels, capabilities, rewrite rules, meta boxes
- **Taxonomies** — Hierarchical or flat, with proper rewrite rules
- **REST endpoints** — `register_rest_route()`, permission callbacks, schema validation
- **Admin pages** — Settings API, menu/submenu registration, per-page asset enqueueing
- **Gutenberg blocks** — `block.json`, `register_block_type()`, server-side rendering
- **Hooks & Filters** — Descriptive names, documented parameters, explicit priority/args

## Rules

- Read existing code first — match project patterns exactly
- Use `$wpdb->prepare()` for all direct database queries
- Never output inline scripts or styles from PHP
- Flush rewrite rules on plugin activation only
- Keep it simple: don't abstract until there's a second use case

## Dependencies

This command uses the **wp-developer** agent bundled with the developers plugin.
