---
description: Scaffold a complete Gutenberg block — block.json (apiVersion 3), edit/save/render components, PHP registration, and build verification
---

# Build Gutenberg Block

Scaffold a complete, production-ready Gutenberg block using the `wp-block-developer` agent. Reads existing project patterns, generates all required files, and verifies the build.

## Instructions

1. **Gather block requirements** — Ask the user:
   - Block name and namespace (e.g., `my-plugin/hero-section`)
   - Block type: **static** (saved HTML) or **dynamic** (PHP renders on load)?
   - What attributes does the block need? (text, image, toggle, number, etc.)
   - Does it need inner blocks? (for container blocks)
   - Does it need interactivity? (if yes, will also wire Interactivity API)

2. **Read existing project structure** — Before generating anything:
   ```
   Glob: **/block.json         ← Find existing blocks, read their patterns
   Read: package.json           ← Confirm @wordpress/scripts is available
   Read: {main-plugin-file}.php ← Get plugin namespace/prefix
   ```

3. **Launch wp-block-developer** — Use the Task tool to spawn the **wp-block-developer** agent with:
   - Block name, type (static/dynamic), and attribute spec
   - Existing plugin prefix and namespace
   - Any existing block to match patterns from
   - Whether Interactivity API is needed

4. **Verify the build**:
   ```bash
   npm run build
   ```
   Fix any errors before reporting completion.

5. **Confirm registration** — Verify the block is registered in the main plugin PHP file:
   ```php
   register_block_type( __DIR__ . '/blocks/my-block/' );
   ```

6. **Final checklist**:
   - [ ] `apiVersion: 3` in block.json
   - [ ] `useBlockProps()` in edit, `useBlockProps.save()` in save
   - [ ] Dynamic blocks have `render.php` and `save: () => null`
   - [ ] `get_block_wrapper_attributes()` in render.php
   - [ ] All inputs sanitized, all outputs escaped
   - [ ] `npm run build` passes

## What Gets Created

For a **static block:**
- `blocks/{name}/block.json` — metadata, attributes, supports
- `blocks/{name}/index.js` — registerBlockType
- `blocks/{name}/edit.js` — editor component
- `blocks/{name}/save.js` — frontend JSX
- `blocks/{name}/style-index.css` — shared styles

For a **dynamic block:**
- `blocks/{name}/block.json` — with `"render": "file:./render.php"`
- `blocks/{name}/index.js` — registerBlockType with `save: () => null`
- `blocks/{name}/edit.js` — editor component (preview or ServerSideRender)
- `blocks/{name}/render.php` — PHP render callback

For an **interactive block** — everything from dynamic block plus:
- `blocks/{name}/view.js` — Interactivity API store

## Dependencies

Uses the **wp-block-developer** agent bundled with this plugin.
For Interactivity API blocks, also uses **wp-interactivity-developer** agent.
