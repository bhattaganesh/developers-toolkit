# Block Deprecations Pattern Guide

Deprecations are required whenever you change a block's `save()` output. Without them, WordPress will show an "unexpected or invalid content" error for existing saved blocks.

## When Deprecations Are Required

- You changed the HTML structure in `save()`
- You renamed or removed an attribute that was serialized in `save()`
- You changed how an attribute is sourced (e.g., `source: "html"` → no source)
- You changed a CSS class name in `save()` output

**Deprecations are NOT needed when:**
- You only changed `edit()` — editor changes never affect saved content
- You only changed `render.php` — dynamic blocks have no saved HTML
- You only changed attributes that aren't used in `save()`

## Deprecation Object Structure

```js
// In registerBlockType() — the deprecations array
deprecations: [
    {
        // 1. The old attribute schema
        attributes: {
            text: {
                type: 'string',
                source: 'html',
                selector: 'p',
            },
        },

        // 2. Optional: the old supports config (if it changed)
        supports: {
            html: false,
        },

        // 3. The exact old save() function
        save( { attributes } ) {
            return (
                <p className="my-block-text">
                    { attributes.text }
                </p>
            );
        },

        // 4. Optional: migrate old attributes to new shape
        migrate( oldAttributes ) {
            return {
                content: oldAttributes.text, // rename text → content
                version: 1,                  // add new required attribute
            };
        },

        // 5. Optional: validate if save() alone doesn't match
        isEligible( attributes, innerBlocks ) {
            return !! attributes.text; // only run migration if old attr exists
        },
    },
],
```

## Multiple Deprecations (Version History)

List in reverse chronological order — newest deprecation first:

```js
deprecations: [
    // v2 → v3 (most recent change)
    {
        attributes: { content: { type: 'string' } },
        save( { attributes } ) {
            return <div className="my-block-v2">{ attributes.content }</div>;
        },
        migrate( old ) {
            return { content: old.content, layout: 'default' };
        },
    },
    // v1 → v2
    {
        attributes: { text: { type: 'string', source: 'html', selector: 'p' } },
        save( { attributes } ) {
            return <p className="my-block-text">{ attributes.text }</p>;
        },
        migrate( old ) {
            return { content: old.text };
        },
    },
],
```

WordPress tries deprecations in order until one matches. The matching deprecation's `migrate()` is called to produce the final attribute shape used by the current block.

## Common Deprecation Mistakes

### 1. Missing migrate() when attributes changed

```js
// WRONG — attributes renamed but no migrate()
{
    attributes: { text: { type: 'string' } },
    save( { attributes } ) { return <p>{ attributes.text }</p>; },
    // No migrate — block loads with undefined content!
}

// CORRECT
{
    attributes: { text: { type: 'string' } },
    save( { attributes } ) { return <p>{ attributes.text }</p>; },
    migrate( old ) { return { content: old.text }; },
}
```

### 2. save() doesn't exactly match the old output

The deprecated `save()` must produce byte-for-byte identical HTML to what was originally saved. Common mismatches:

```js
// WRONG — attribute interpolation order changed
save( { attributes } ) {
    return <div class="{ attributes.align } my-block">...</div>; // class order different
}

// TIP: Copy the original save() verbatim from git history
git log --all --oneline -- src/my-block/save.js
git show COMMIT_SHA:src/my-block/save.js
```

### 3. Forgetting className in deprecated save()

If you used `useBlockProps()` in the old save(), it auto-adds `wp-block-{namespace}-{name}`. If the new version also uses `useBlockProps.save()`, the class is still there — but if you switched from manual className to useBlockProps, you need to account for that:

```js
// Old save (manual class)
save( { attributes } ) {
    return <div className="wp-block-my-plugin-my-block">...</div>;
}

// New save (useBlockProps)
save( { attributes } ) {
    return <div { ...useBlockProps.save() }>...</div>;
    // useBlockProps.save() adds wp-block-my-plugin-my-block automatically
}

// Deprecation: the old manual version
{
    save( { attributes } ) {
        return <div className="wp-block-my-plugin-my-block">...</div>;
    }
}
```

## Testing Deprecations

1. Save a post with the OLD block version
2. Update block to new version
3. Open post in editor
4. If deprecation works: block loads normally (may show "This block has changed" notice)
5. If deprecation fails: block shows red error — check browser console for mismatch details

**Block validation error format:**
```
Block validation: Expected valid source type `html` but received `undefined`.
Expected: <p class="...">Old content</p>
Actual:   <div class="...">Old content</div>
```

The "Expected" line shows what was saved. The "Actual" line shows what your deprecated save() produced. They must match exactly.
