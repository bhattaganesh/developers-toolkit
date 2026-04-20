# Interactivity API Directives — Complete Reference

All `data-wp-*` directives for WordPress 6.9+. Values are JavaScript expressions evaluated against the current store/context.

## Namespace Directive

### `data-wp-interactive`

Marks the root element of an interactive region. Sets the default namespace for all child directives.

```html
<div data-wp-interactive="my-plugin">
    <!-- All data-wp-* directives here use the "my-plugin" namespace by default -->
</div>
```

Required on the outermost wrapper. Can be nested for different namespaces.

---

## Content Directives

### `data-wp-text`

Sets the text content of an element. Updates reactively when state changes.

```html
<p data-wp-text="state.message">Loading…</p>
<span data-wp-text="context.item.title">Placeholder</span>
```

The initial HTML value (`Loading…`) is shown until JS hydrates — important for SSR.

### `data-wp-html`

Sets inner HTML. Use only for trusted, pre-sanitized content.

```html
<div data-wp-html="state.richContent"></div>
```

---

## Visibility Directives

### `data-wp-show`

Shows element when value is truthy, hides with `display: none` when falsy.

```html
<div data-wp-show="state.isOpen">Visible when open</div>
<div data-wp-show="!state.isLoading">Content (hidden while loading)</div>
```

### `data-wp-show--no-init`

Same as `data-wp-show` but doesn't apply on initial render — useful when the element should start visible and only hide after user interaction.

---

## Attribute Directives

### `data-wp-bind--{attr}`

Binds any HTML attribute to a reactive value. The suffix after `--` is the attribute name.

```html
<button data-wp-bind--disabled="state.isSubmitting">Submit</button>
<a data-wp-bind--href="state.nextUrl">Next</a>
<input data-wp-bind--value="state.searchQuery" />
<img data-wp-bind--src="state.avatarUrl" data-wp-bind--alt="state.userName" />
<div data-wp-bind--aria-expanded="state.menuOpen" data-wp-bind--aria-label="state.label">…</div>
```

### `data-wp-class--{className}`

Toggles a CSS class when value is truthy.

```html
<div data-wp-class--active="state.isActive">…</div>
<div data-wp-class--loading="state.isFetching">…</div>
<div data-wp-class--is-open="state.menuOpen">…</div>
```

### `data-wp-style--{property}`

Sets an inline CSS property. Property names use camelCase.

```html
<div data-wp-style--color="state.textColor">…</div>
<div data-wp-style--background-color="state.bgColor">…</div>
```

---

## Event Directives

### `data-wp-on--{event}`

Binds an event listener. The suffix after `--` is the event name.

```html
<button data-wp-on--click="actions.increment">+1</button>
<input data-wp-on--input="actions.handleInput" />
<form data-wp-on--submit="actions.handleSubmit" />
<div data-wp-on--keydown="actions.handleKeydown" />
<div data-wp-on--mouseover="actions.handleHover" />
```

### `data-wp-on-window--{event}`

Listens for window-level events. Automatically cleaned up when element is removed.

```html
<div data-wp-on-window--resize="callbacks.onResize">…</div>
<div data-wp-on-window--scroll="callbacks.onScroll">…</div>
```

### `data-wp-on-document--{event}`

Listens for document-level events.

```html
<div data-wp-on-document--keydown="actions.handleGlobalKey">…</div>
```

---

## Context Directives

### `data-wp-context`

Sets local context for this element and all descendants. Value is a JSON string.

```html
<!-- Static context -->
<div data-wp-context='{"itemId": 42, "isSelected": false}'>…</div>

<!-- PHP-generated context (escape carefully) -->
<div data-wp-context="<?php echo esc_attr( wp_json_encode( ['postId' => $post->ID] ) ); ?>">…</div>
```

Context can be read in JS with `getContext()` and in directives as `context.propertyName`.

---

## Lifecycle Directives

### `data-wp-init`

Runs a callback when the element is added to the DOM. Runs once on hydration.

```html
<div data-wp-init="callbacks.onMount">…</div>
```

```js
callbacks: {
    onMount() {
        // Initialize third-party libraries, start timers, etc.
        const { itemId } = getContext();
        console.log( 'Mounted with item:', itemId );
    },
},
```

### `data-wp-watch`

Runs a callback whenever any reactive state it accesses changes. Used for side effects.

```html
<div data-wp-watch="callbacks.onCountChange">…</div>
```

```js
callbacks: {
    onCountChange() {
        // Runs when state.count changes (because we access it here)
        document.title = `Count: ${ state.count }`;
    },
},
```

---

## Loop Directives

### `data-wp-each`

Iterates over an array. The element is repeated for each item. Use with `data-wp-each-key`.

```html
<ul>
    <li
        data-wp-each="state.items"
        data-wp-each-key="context.item.id"
    >
        <span data-wp-text="context.item.title">…</span>
    </li>
</ul>
```

Inside `data-wp-each`, use `context.item` to access the current iteration item.

### `data-wp-each-key`

Unique key expression for list reconciliation. Required for correct DOM diffing.

```html
data-wp-each-key="context.item.id"
data-wp-each-key="context.item.slug"
```

---

## Navigation Directives

### `data-wp-router-region`

Marks a region for client-side navigation (used with the WP Navigation block pattern).

```html
<div data-wp-router-region="main-content">
    <!-- Content replaced on client-side navigation -->
</div>
```

---

## Accessing Values in Directives

Directives resolve expressions in this order:

1. `state.property` — global store state
2. `context.property` — local context set by `data-wp-context`
3. `actions.name` — store actions
4. `callbacks.name` — store callbacks

Examples:
```html
data-wp-text="state.count"              <!-- Global state -->
data-wp-text="context.item.title"       <!-- Local context -->
data-wp-on--click="actions.increment"   <!-- Action reference -->
data-wp-init="callbacks.setup"          <!-- Callback reference -->
data-wp-show="!state.isLoading"         <!-- Negation supported -->
data-wp-text="state.count > 0 ? state.count : 'empty'"  <!-- Ternary supported -->
```
