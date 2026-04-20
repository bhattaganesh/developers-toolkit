---
name: wp-interactivity-api
description: >
  This skill should be used when the user asks to "add interactivity to a block",
  "use the WordPress Interactivity API", "add data-wp directives", "make a block interactive",
  "build a WordPress store", "use wp-interactivity", "replace jQuery with Interactivity API",
  "add reactive state to a block", or when debugging data-wp-* directive issues,
  store hydration problems, SSR state mismatches, or context inheritance errors.
version: 1.0.0
tools: Read, Write, Edit, Glob, Grep, Bash
---

# WordPress Interactivity API

Build interactive block-based UI using WordPress's native reactivity system — no jQuery, no external framework. Lighter than `@wordpress/element` for most use cases. Requires WP 6.5+, recommended for WP 6.9+.

## When to Use This (vs Alternatives)

| Situation | Use |
|---|---|
| Block needs reactive state (counters, toggles, filters) | Interactivity API |
| Block needs to fetch data and re-render | Interactivity API |
| Full admin page or complex app | `@wordpress/element` (React) |
| Simple click → show/hide with no state | CSS + vanilla JS |
| Legacy jQuery already in project | Migrate gradually — new blocks should use IA |

## Core Concepts in 3 Lines

1. **Store** — define reactive `state`, `actions`, and `callbacks` in JS
2. **Directives** — `data-wp-*` HTML attributes wire elements to store reactively
3. **SSR** — PHP passes initial state via `wp_interactivity_state()` to prevent hydration mismatch

## Step 1 — block.json Setup

```json
{
  "apiVersion": 3,
  "name": "my-plugin/counter",
  "supports": {
    "interactivity": true
  },
  "viewScriptModule": "file:./view.js",
  "render": "file:./render.php"
}
```

**Critical:** Use `viewScriptModule` (ES module) NOT `viewScript` (classic script). The Interactivity API requires ES modules.

## Step 2 — PHP: Initialize Server-Side State

```php
<?php
// render.php

// Initialize state BEFORE rendering HTML — prevents hydration mismatch
wp_interactivity_state( 'my-plugin', array(
    'count'    => 0,
    'isOpen'   => false,
    'items'    => get_posts( array( 'numberposts' => 5 ) ),
) );

$wrapper_attributes = get_block_wrapper_attributes();
?>
<div
    <?php echo $wrapper_attributes; ?>
    data-wp-interactive="my-plugin"
>
    <p data-wp-text="context.count">0</p>
    <button data-wp-on--click="actions.increment">+1</button>
</div>
```

**Why this matters:** Without `wp_interactivity_state()`, the initial HTML and the JS store start with different values → hydration mismatch → blank or broken block on first load.

## Step 3 — JS: Define the Store

```js
// view.js
import { store, getContext } from '@wordpress/interactivity';

const { state, actions } = store( 'my-plugin', {
    state: {
        // Reactive state — changes here re-render bound elements
        count: 0,
        get doubled() {
            return state.count * 2; // Derived (computed) value
        },
    },
    actions: {
        increment() {
            state.count++;
        },
        decrement() {
            state.count--;
        },
        reset() {
            state.count = 0;
        },
        async fetchData() {
            const response = await fetch( '/wp-json/my-plugin/v1/data' );
            const data = await response.json();
            state.items = data;
        },
    },
    callbacks: {
        // Run when element enters DOM — like useEffect
        logMount() {
            console.log( 'Block mounted, count:', state.count );
        },
    },
} );
```

## Directive Reference (Most Common)

| Directive | Effect | Example |
|---|---|---|
| `data-wp-interactive` | Marks the interactive region + sets namespace | `data-wp-interactive="my-plugin"` |
| `data-wp-context` | Sets local block context (JSON) | `data-wp-context='{"itemId": 42}'` |
| `data-wp-text` | Sets element text content | `data-wp-text="state.count"` |
| `data-wp-html` | Sets inner HTML (trusted content only) | `data-wp-html="state.content"` |
| `data-wp-show` | Shows/hides element (display:none) | `data-wp-show="state.isOpen"` |
| `data-wp-on--click` | Click event handler | `data-wp-on--click="actions.toggle"` |
| `data-wp-on--keydown` | Keyboard event | `data-wp-on--keydown="actions.handleKey"` |
| `data-wp-bind--class` | Binds attribute | `data-wp-bind--class="state.activeClass"` |
| `data-wp-bind--aria-expanded` | ARIA binding | `data-wp-bind--aria-expanded="state.isOpen"` |
| `data-wp-bind--disabled` | Disable control | `data-wp-bind--disabled="state.isLoading"` |
| `data-wp-class--active` | Toggles CSS class | `data-wp-class--active="state.isActive"` |
| `data-wp-each` | Loops over array | `data-wp-each="state.items"` |
| `data-wp-each-key` | Unique key for each item | `data-wp-each-key="context.item.id"` |
| `data-wp-init` | Run callback on mount | `data-wp-init="callbacks.onInit"` |
| `data-wp-watch` | Re-run callback on state change | `data-wp-watch="callbacks.onCountChange"` |
| `data-wp-router-region` | Marks region for client-side navigation | `data-wp-router-region="main"` |

See `references/directives-reference.md` for full examples.

## Context vs State

| | `state` | `context` |
|---|---|---|
| Scope | Global — shared across all instances | Local — per block instance |
| Define | In `store()` | Via `data-wp-context` attribute in HTML |
| Read in JS | `state.value` | `getContext().value` |
| Read in directive | `state.value` | `context.value` |
| Use for | Shared reactive data | Per-instance data (item IDs, local toggles) |

```php
// PHP: set per-instance context
foreach ( $items as $item ) :
?>
    <div
        data-wp-interactive="my-plugin"
        data-wp-context="<?php echo esc_attr( wp_json_encode( array( 'itemId' => $item->ID ) ) ); ?>"
    >
        <button data-wp-on--click="actions.selectItem">
            <?php echo esc_html( $item->post_title ); ?>
        </button>
    </div>
<?php endforeach; ?>
```

```js
// JS: read context in action
actions: {
    selectItem() {
        const { itemId } = getContext();
        state.selectedId = itemId;
    },
},
```

## WP 6.9 Breaking Change

`data-wp-ignored` is **deprecated** and breaks context inheritance in WP 6.9+. Remove it from all blocks. Previously used to exclude elements from processing — use targeted `data-wp-interactive` regions instead.

## Debug Checklist

When the block shows blank, doesn't react, or throws console errors:

1. Check `data-wp-interactive="my-plugin"` is on the wrapper (namespace must match store name)
2. Check `wp_interactivity_state('my-plugin', ...)` is called in render.php **before** HTML output
3. Check browser console for: `Uncaught Error: store is not defined`
4. Check `viewScriptModule` (not `viewScript`) in block.json
5. Check `"supports": { "interactivity": true }` in block.json
6. Run `npm run build` — view.js must be compiled
7. Inspect `window.__wpInteractivityApiConfig` in console — store names visible there

## Full Working Example

```php
<?php
// render.php — accordion block
wp_interactivity_state( 'my-plugin', array(
    'isOpen' => false,
) );

$wrapper_attributes = get_block_wrapper_attributes();
?>
<div
    <?php echo $wrapper_attributes; ?>
    data-wp-interactive="my-plugin"
    data-wp-context='{"panelId": "<?php echo esc_attr( wp_unique_id( "panel-" ) ); ?>"}'
>
    <button
        data-wp-on--click="actions.toggle"
        data-wp-bind--aria-expanded="state.isOpen"
    >
        Toggle
    </button>
    <div data-wp-show="state.isOpen">
        <?php echo $content; ?>
    </div>
</div>
```

```js
// view.js
import { store } from '@wordpress/interactivity';

store( 'my-plugin', {
    state: {
        isOpen: false,
    },
    actions: {
        toggle() {
            store( 'my-plugin' ).state.isOpen = ! store( 'my-plugin' ).state.isOpen;
        },
    },
} );
```

## References

- [Directives complete reference](references/directives-reference.md)
- [Store patterns and SSR examples](references/store-and-ssr-patterns.md)
