---
description: WordPress Block Editor (Gutenberg) development standards
globs:
  - "src/blocks/**/*"
  - "**/block.json"
  - "**/edit.js"
  - "**/save.js"
---

# Block Editor Rules

## Core Standards
- Use `block.json` for all block registrations (Version 3 preferred)
- Keep blocks modular — one directory per block
- Use `@wordpress/scripts` for build process
- Define clear `attributes` in `block.json` instead of local component state where persistence is needed

## React in Gutenberg
- Use `@wordpress/element` (WordPress's React wrapper)
- Use standard Gutenberg components from `@wordpress/components`
- Use `useBlockProps` hook in `Edit` and `Save` functions
- Always include `useBlockProps.save()` in the `Save` component

## Performance
- Only enqueue assets when the block is present on the page
- Use `render_callback` in PHP for dynamic blocks
- Avoid heavy computation in the `Edit` component — use `useMemo` for expensive operations

## Accessibility
- Use proper ARIA labels on custom controls
- Ensure all interactive elements in the editor are keyboard accessible
- Use standard `TextControl`, `SelectControl`, etc., which handle a11y by default
