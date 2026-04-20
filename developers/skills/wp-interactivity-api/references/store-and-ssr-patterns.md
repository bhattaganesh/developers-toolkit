# Interactivity API Store Patterns & SSR

## Store Architecture

### Basic Store

```js
import { store, getContext, getElement } from '@wordpress/interactivity';

const { state, actions } = store( 'my-plugin', {
    // Reactive global state — changes trigger re-renders
    state: {
        count: 0,
        isLoading: false,
        items: [],

        // Derived state (getter) — recomputes when dependencies change
        get hasItems() {
            return state.items.length > 0;
        },
        get itemCount() {
            return state.items.length;
        },
    },

    // Actions — mutate state, handle events
    actions: {
        increment() {
            state.count++;
        },

        // Async action (generator function)
        async * fetchItems() {
            state.isLoading = true;
            yield; // Yield before async operation — allows UI to update

            try {
                const response = await fetch( '/wp-json/my-plugin/v1/items' );
                state.items = await response.json();
            } catch ( error ) {
                console.error( 'Fetch failed:', error );
            } finally {
                state.isLoading = false;
            }
        },

        // Access per-block context
        selectItem() {
            const { itemId } = getContext();
            state.selectedId = itemId;
        },

        // Access the DOM element
        focusNext() {
            const { ref } = getElement();
            ref.nextElementSibling?.focus();
        },
    },

    // Callbacks — side effects, lifecycle
    callbacks: {
        // Runs on mount and whenever accessed state changes
        syncTitle() {
            document.title = `Items: ${ state.count }`;
        },

        // Init callback — runs once on element mount
        initBlock() {
            const { blockId } = getContext();
            console.log( 'Block initialized:', blockId );
        },
    },
} );
```

### Multiple Stores

Stores are namespaced — each plugin should use its own namespace. Stores can read each other:

```js
// Store A
const storeA = store( 'plugin-a', {
    state: { count: 0 },
} );

// Store B reads Store A
store( 'plugin-b', {
    actions: {
        readFromA() {
            // Access another store's state
            const { state: stateA } = store( 'plugin-a' );
            console.log( 'Store A count:', stateA.count );
        },
    },
} );
```

---

## SSR State Initialization

### Why SSR State is Critical

Without server-side state initialization:
1. PHP renders block HTML with placeholder values (`0`, empty string, etc.)
2. Browser displays placeholder
3. JS loads and creates store with `count: 0` (default)
4. Hydration checks: PHP HTML matches JS defaults ✓
5. But if defaults don't match real data → blank content or hydration error

With `wp_interactivity_state()`:
1. PHP renders HTML with `<p data-wp-text="state.count">5</p>` (actual value in HTML)
2. PHP calls `wp_interactivity_state('my-plugin', ['count' => 5])`
3. WordPress serializes this into the page as inline JSON
4. JS store hydrates with `count: 5` from serialized state
5. HTML `5` matches JS `5` → clean hydration, no flash

### PHP: wp_interactivity_state()

```php
// render.php

// ALWAYS call before HTML output
wp_interactivity_state( 'my-plugin', array(
    'count'     => absint( get_option( 'my_plugin_count', 0 ) ),
    'isOpen'    => false,
    'items'     => array_map( function( $post ) {
        return array(
            'id'    => $post->ID,
            'title' => $post->post_title,
            'url'   => get_permalink( $post->ID ),
        );
    }, get_posts( array( 'numberposts' => 5 ) ) ),
    'nonce'     => wp_create_nonce( 'my-plugin-action' ),
    'ajaxUrl'   => admin_url( 'admin-ajax.php' ),
    'apiBase'   => rest_url( 'my-plugin/v1' ),
) );
```

### State Merging

`wp_interactivity_state()` merges with existing state — safe to call multiple times:

```php
// First call (e.g., in block render)
wp_interactivity_state( 'my-plugin', array( 'count' => 5 ) );

// Second call merges (doesn't overwrite)
wp_interactivity_state( 'my-plugin', array( 'isOpen' => false ) );

// Result: { count: 5, isOpen: false }
```

### Reading Server State in JS

```js
// state in store() is automatically populated from wp_interactivity_state() output
// No extra code needed — the values are already in state when store() runs

const { state } = store( 'my-plugin', {
    state: {
        count: 0,   // This default is overridden by wp_interactivity_state() value
    },
    actions: {
        init() {
            // state.count is already 5 (from PHP), not 0 (from JS default)
            console.log( state.count ); // 5
        },
    },
} );
```

---

## Context Patterns

### Per-Instance Context (Most Common)

Use when the same block is repeated with different data (e.g., in a loop):

```php
// render.php — within a loop
foreach ( $posts as $post ) :
    wp_interactivity_state( 'my-plugin', array(
        // Global state updates
    ) );
    ?>
    <article
        data-wp-interactive="my-plugin"
        data-wp-context="<?php echo esc_attr( wp_json_encode( array(
            'postId'    => $post->ID,
            'postTitle' => $post->post_title,
            'isExpanded'=> false,
        ) ) ); ?>"
    >
        <button data-wp-on--click="actions.togglePost">
            <span data-wp-text="context.postTitle">…</span>
        </button>
        <div data-wp-show="context.isExpanded">
            <p>Details for post <?php echo absint( $post->ID ); ?></p>
        </div>
    </article>
    <?php
endforeach;
```

```js
// view.js
store( 'my-plugin', {
    actions: {
        togglePost() {
            const context = getContext();
            context.isExpanded = ! context.isExpanded; // Mutate context directly
        },
    },
} );
```

### Nested Context

Child elements inherit parent context. Child `data-wp-context` merges with parent:

```html
<div data-wp-context='{"sectionId": "hero"}'>
    <div data-wp-context='{"itemId": 1}'>
        <!-- context here = { sectionId: "hero", itemId: 1 } -->
        <button data-wp-on--click="actions.select">Select</button>
    </div>
</div>
```

---

## Async Actions Pattern

Async actions should use generator functions to yield before side effects:

```js
actions: {
    // Pattern: generator with yield before async
    async * search( event ) {
        const query = event.target.value;

        if ( query.length < 3 ) {
            state.results = [];
            return;
        }

        state.isSearching = true;
        yield; // UI updates to show loading state

        try {
            const res = await fetch(
                `/wp-json/my-plugin/v1/search?q=${ encodeURIComponent( query ) }`,
                {
                    headers: {
                        'X-WP-Nonce': state.nonce,
                    },
                }
            );
            state.results = await res.json();
        } finally {
            state.isSearching = false;
        }
    },
},
```

---

## Common Anti-Patterns

```js
// WRONG: Direct DOM manipulation bypasses reactivity
actions: {
    toggle() {
        document.querySelector( '.my-element' ).style.display = 'none'; // ❌
    },
},

// CORRECT: Mutate state — directives handle DOM
actions: {
    toggle() {
        state.isVisible = false; // ✓ data-wp-show="state.isVisible" handles the rest
    },
},
```

```js
// WRONG: Accessing store outside of store callbacks
import { store } from '@wordpress/interactivity';
const { state } = store( 'my-plugin', {} );
setTimeout( () => state.count++, 1000 ); // ❌ May not trigger reactivity

// CORRECT: Use callbacks with data-wp-watch or data-wp-init
callbacks: {
    startTimer() {
        setInterval( () => { state.count++; }, 1000 ); // ✓ Inside store context
    },
},
```
