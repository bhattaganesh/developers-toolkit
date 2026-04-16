# ARIA Patterns

When and how to use ARIA (Accessible Rich Internet Applications).

## First Rule of ARIA

**No ARIA is better than bad ARIA.**

Before using ARIA, ask:
1. Can I use native HTML? (prefer `<button>` over `role="button"`)
2. Does semantic HTML work? (prefer `<nav>` over `<div role="navigation">`)
3. Is ARIA really needed? (most cases: NO)

## When to Use ARIA

✅ **Icon buttons** - Add accessible name
```html
<button aria-label="Close">×</button>
```

✅ **Live regions** - Announce status updates
```html
<div aria-live="polite" role="status">Saving...</div>
```

✅ **Expanded/collapsed** - Toggle states
```html
<button aria-expanded="false">Show More</button>
```

✅ **Custom components** - When no HTML equivalent exists

## When NOT to Use ARIA

❌ **Native elements** - Don't override
```html
<!-- BAD -->
<button role="button">Click</button>
<!-- GOOD -->
<button>Click</button>
```

❌ **Redundant ARIA**
```html
<!-- BAD -->
<nav role="navigation">
<!-- GOOD -->
<nav>
```

## Common ARIA Attributes

- `aria-label` - Accessible name
- `aria-labelledby` - Reference to label element
- `aria-describedby` - Additional description
- `aria-expanded` - Expanded state (true/false)
- `aria-hidden` - Hide from screen readers
- `aria-live` - Announce changes (polite/assertive)
- `aria-required` - Required field
- `aria-invalid` - Invalid input

## WordPress Pattern

```javascript
import { speak } from '@wordpress/a11y';
speak('Settings saved'); // Better than aria-live
```

Resources:
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [Using ARIA](https://www.w3.org/TR/using-aria/)
