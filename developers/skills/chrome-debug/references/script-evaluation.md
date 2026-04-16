# JavaScript Evaluation Guide

Guide to executing custom JavaScript with Chrome DevTools MCP.

---

## Basic Usage

```javascript
evaluate_script({
  function: "() => { return document.title; }"
});

# Returns: "Page Title"
```

---

## Important Rules

### ✅ Return Values Must Be JSON-Serializable

**Allowed:**
- Strings, numbers, booleans
- Arrays, objects (plain)
- null

**NOT Allowed:**
- Functions
- DOM elements
- Promises
- undefined
- Circular references

### ✗ Bad Examples

```javascript
# ✗ Returns DOM element (not serializable)
evaluate_script({
  function: "() => { return document.querySelector('#button'); }"
});

# ✗ Returns function (not serializable)
evaluate_script({
  function: "() => { return () => 'hello'; }"
});

# ✗ Returns Promise (not serializable)
evaluate_script({
  function: "async () => { return await fetch('/api'); }"
});
```

### ✓ Good Examples

```javascript
# ✓ Returns string
evaluate_script({
  function: "() => { return document.title; }"
});

# ✓ Returns object
evaluate_script({
  function: "() => { return { width: window.innerWidth, height: window.innerHeight }; }"
});

# ✓ Returns array
evaluate_script({
  function: "() => { return Array.from(document.querySelectorAll('a')).map(a => a.href); }"
});
```

---

## Common Patterns

### Get Computed Styles

```javascript
evaluate_script({
  function: "(el) => { const styles = window.getComputedStyle(el); return { color: styles.color, fontSize: styles.fontSize }; }",
  args: [{ uid: "button123" }]
});
```

### Check Element Visibility

```javascript
evaluate_script({
  function: "(el) => { return el.offsetParent !== null; }",
  args: [{ uid: "element123" }]
});
```

### Get Form Values

```javascript
evaluate_script({
  function: "() => { const form = document.querySelector('form'); const data = new FormData(form); const obj = {}; for (const [key, value] of data.entries()) { obj[key] = value; } return obj; }"
});
```

### Count Elements

```javascript
evaluate_script({
  function: "() => { return document.querySelectorAll('.item').length; }"
});
```

---

## With Element Arguments

### Passing UIDs

```javascript
# Get element UID from snapshot first
take_snapshot();
# Output: [uid=abc123] button "Submit"

# Use UID in script
evaluate_script({
  function: "(el) => { return { text: el.innerText, disabled: el.disabled }; }",
  args: [{ uid: "abc123" }]
});
```

---

## Troubleshooting

### Error: "Return value not JSON-serializable"

**Cause:** Returned function, DOM element, Promise, etc.

**Fix:** Extract serializable properties:
```javascript
# ✗ Bad
"() => { return document.querySelector('#button'); }"

# ✓ Good
"() => { const el = document.querySelector('#button'); return { id: el.id, text: el.innerText, disabled: el.disabled }; }"
```

### Error: "Undefined is not valid JSON"

**Cause:** Function returns undefined

**Fix:** Return explicit value:
```javascript
# ✗ Bad
"() => { console.log('test'); }"  # Returns undefined

# ✓ Good
"() => { console.log('test'); return true; }"
```

---

## See Also

- [chrome-devtools-api.md](./chrome-devtools-api.md) - evaluate_script reference
- [snapshot-vs-screenshot.md](./snapshot-vs-screenshot.md) - When to use snapshot vs script
