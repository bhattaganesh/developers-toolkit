---
name: wp-blocks
description: Modern Gutenberg & Interactivity API development standards
globs: ["**/src/**/*.js", "**/src/**/*.tsx", "**/blocks/**/*.json"]
---

# WordPress Block Development Standards (Elite)

Follow these rules for building high-performance, accessible Gutenberg blocks.

## 1. Metadata and Registration
- **Always** use `apiVersion: 3` in `block.json`.
- **Prefer** static blocks (`save` function) for content-heavy components.
- **Prefer** dynamic blocks (`render` file) for data-heavy or frequently updated components.
- **Namespace:** Always use a consistent prefix (e.g., `prefix/block-name`).

## 2. React & State Management
- **Hooks:** Use `@wordpress/element` hooks (`useState`, `useEffect`) instead of standard React imports when possible to ensure compatibility with the WP runtime.
- **Components:** Use `@wordpress/components` for any UI in the Sidebar (InspectorControls).
- **Data Flow:**
    - Use `useBlockProps()` in the `Edit` component.
    - Use `useBlockProps.save()` in the `Save` component.
    - Never hardcode IDs or ClassNames that conflict with core styling.

## 3. Interactivity API (200x Productivity)
- **Directives:** Use `wp-on`, `wp-bind`, `wp-class` instead of raw JS event listeners.
- **Store:** Define state in a central store using `wp_interactivity_state()`.
- **Client Side:** Use `view.js` only for interactive logic, never for initial rendering.

## 4. Accessibility & UX
- **Focus:** Ensure `BlockControls` and `InspectorControls` are keyboard navigable.
- **Placeholders:** Always provide a `Placeholder` component for empty states (e.g., before an image is selected).
- **Toolbars:** Group primary actions in the `BlockControls` and secondary/configuration in `InspectorControls`.

## 5. Security (Escape Late)
- **Frontend:** Always use `get_block_wrapper_attributes()` in PHP render callbacks.
- **Attributes:** Ensure all attributes in `block.json` have an explicit `type` and `default`.
- **Sanitization:** Sanitize all block attributes before saving or rendering.
