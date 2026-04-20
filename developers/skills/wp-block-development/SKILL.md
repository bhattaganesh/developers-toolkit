---
name: wp-block-development
description: >
  This skill should be used when the user asks to "create a Gutenberg block",
  "build a WordPress block", "add a block to my plugin", "create a dynamic block",
  "create an FSE block", "update block.json", "fix a block deprecation",
  "add inner blocks", "scaffold a new block", "register a block", "create a static block",
  or when editing files in a blocks/ or src/ directory that contains block.json files.
version: 1.0.0
tools: Read, Write, Edit, Glob, Grep, Bash
---

# WordPress Block Development

Build production-quality Gutenberg blocks. Always use `apiVersion: 3` — required for WP 6.9+ iframe editor compatibility. Anything lower breaks block editing in modern WordPress.

## Before Writing a Single Line

1. Run triage (or check mentally):
   ```
   Glob: **/block.json
   Read: package.json   → confirm @wordpress/scripts is installed
   ```
2. Read an existing block in the project (if any) — match its patterns exactly.
3. Confirm with the user: **static or dynamic block?**

## Static vs Dynamic — Decision Rule

| Use static when... | Use dynamic when... |
|---|---|
| Output is fully determined at save time | Output depends on live data (posts, options, user state) |
| No PHP rendering needed | Block needs `current_user_can()` or auth context |
| Saved content doesn't go stale | Output would be stale if post content changes |

**Static:** `save()` returns JSX → WordPress serializes it into post content.  
**Dynamic:** `render` in block.json points to a PHP file → WordPress calls it on every page load.

## block.json — Required Fields

```json
{
  "$schema": "https://schemas.wp.org/trunk/block.json",
  "apiVersion": 3,
  "name": "my-plugin/my-block",
  "version": "1.0.0",
  "title": "My Block",
  "category": "common",
  "icon": "star-filled",
  "description": "Brief description for the block inserter.",
  "attributes": {
    "content": {
      "type": "string",
      "source": "html",
      "selector": "p",
      "default": ""
    }
  },
  "supports": {
    "html": false,
    "align": true
  },
  "editorScript": "file:./index.js",
  "style": "file:./style-index.css",
  "editorStyle": "file:./index.css"
}
```

For **dynamic blocks** — replace `editorScript` / save setup with:
```json
  "render": "file:./render.php"
```

For **Interactivity API blocks** — add (see `wp-interactivity-api` skill):
```json
  "viewScriptModule": "file:./view.js"
```

See `references/block-json-complete-reference.md` for all fields.

## File Structure (per block)

```
blocks/my-block/
├── block.json          ← Single source of truth
├── index.js            ← registerBlockType() call
├── edit.js             ← Editor component (always needed)
├── save.js             ← Frontend markup (static blocks only)
├── render.php          ← PHP render callback (dynamic blocks only)
├── style-index.css     ← Frontend styles
└── index.css           ← Editor-only styles
```

## index.js — Registration

```js
import { registerBlockType } from '@wordpress/blocks';
import Edit from './edit';
import Save from './save'; // omit for dynamic blocks
import metadata from './block.json';

registerBlockType( metadata.name, {
    edit: Edit,
    save: Save, // or: save: () => null for dynamic blocks
} );
```

## edit.js — Editor Component

```js
import { useBlockProps, RichText, InspectorControls } from '@wordpress/block-editor';
import { PanelBody, TextControl } from '@wordpress/components';

export default function Edit( { attributes, setAttributes } ) {
    const { content } = attributes;
    const blockProps = useBlockProps();

    return (
        <>
            <InspectorControls>
                <PanelBody title="Settings">
                    <TextControl
                        label="Label"
                        value={ content }
                        onChange={ ( val ) => setAttributes( { content: val } ) }
                    />
                </PanelBody>
            </InspectorControls>
            <div { ...blockProps }>
                <RichText
                    tagName="p"
                    value={ content }
                    onChange={ ( val ) => setAttributes( { content: val } ) }
                    placeholder="Enter content…"
                />
            </div>
        </>
    );
}
```

## save.js — Static Frontend

```js
import { useBlockProps, RichText } from '@wordpress/block-editor';

export default function Save( { attributes } ) {
    const { content } = attributes;
    return (
        <div { ...useBlockProps.save() }>
            <RichText.Content tagName="p" value={ content } />
        </div>
    );
}
```

## render.php — Dynamic Frontend

```php
<?php
// $attributes — block attributes array
// $content    — inner block content (if any)
// $block      — WP_Block instance

$wrapper_attributes = get_block_wrapper_attributes();
?>
<div <?php echo $wrapper_attributes; ?>>
    <?php echo esc_html( $attributes['content'] ?? '' ); ?>
</div>
```

## Deprecations

Required whenever `save()` output changes. Missing deprecations break existing saved blocks.

```js
// In index.js registerBlockType():
deprecations: [
    {
        attributes: { /* old attribute shape */ },
        save( { attributes } ) {
            // Exact copy of the OLD save() function
            return <p>{ attributes.text }</p>;
        },
        migrate( oldAttributes ) {
            // Return new attribute shape
            return { content: oldAttributes.text };
        },
    },
],
```

See `references/deprecations-pattern.md` for complete examples.

## Inner Blocks

```js
import { useBlockProps, useInnerBlocksProps, InnerBlocks } from '@wordpress/block-editor';

// In edit.js:
const innerBlocksProps = useInnerBlocksProps(
    useBlockProps(),
    {
        allowedBlocks: [ 'core/paragraph', 'core/image' ],
        template: [ [ 'core/paragraph', { placeholder: 'Add content…' } ] ],
        templateLock: false, // 'all' prevents reordering, 'insert' prevents adding/removing
    }
);

return <div { ...innerBlocksProps } />;

// In save.js:
export default function Save() {
    return <div { ...useBlockProps.save() }><InnerBlocks.Content /></div>;
}
```

## Build Tooling

```json
// package.json minimum
{
  "scripts": {
    "build": "wp-scripts build",
    "start": "wp-scripts start",
    "lint:js": "wp-scripts lint-js"
  },
  "devDependencies": {
    "@wordpress/scripts": "^30.0.0"
  }
}
```

Entry point defaults to `src/index.js`. For multiple blocks, use `wp-scripts build blocks/*/index.js`.

After scaffolding: `npm install && npm run build` to verify no build errors.

## Registration in PHP

```php
function my_plugin_register_blocks() {
    register_block_type( __DIR__ . '/blocks/my-block/' );
    // block.json is read automatically — no manual attribute registration needed
}
add_action( 'init', 'my_plugin_register_blocks' );
```

## Quality Checklist

- [ ] `apiVersion: 3` in block.json
- [ ] `useBlockProps()` in both edit and save
- [ ] `useBlockProps.save()` in save (note: `.save()` variant)
- [ ] All user input goes through `setAttributes()` — never direct DOM manipulation
- [ ] Dynamic blocks return `null` from `save()` and have `render.php`
- [ ] Deprecations added if modifying `save()` of an existing block
- [ ] `npm run build` completes without errors
- [ ] Block activates in editor without console errors

## References

- [block.json complete reference](references/block-json-complete-reference.md)
- [Deprecations pattern guide](references/deprecations-pattern.md)
- [Dynamic block pattern](references/dynamic-block-pattern.md)
- For Interactivity API blocks: see `wp-interactivity-api` skill
