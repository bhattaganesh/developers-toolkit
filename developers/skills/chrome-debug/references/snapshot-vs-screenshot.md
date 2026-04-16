# Snapshot vs Screenshot Guide

Comprehensive guide to choosing between text-based snapshots and visual screenshots.

---

## Quick Decision

**Use Snapshot when:**
- Checking page content or structure
- Finding elements by text or role
- Testing accessibility tree
- Speed is important

**Use Screenshot when:**
- Visual appearance matters (colors, layout, styling)
- Creating evidence for bug reports
- Comparing before/after visual states
- Responsive design verification

**Use Both when:**
- Need complete documentation
- Creating comprehensive test reports
- Visual regression with accessibility checks

---

## Snapshot (take_snapshot)

### What It Is

Text-based representation of page using accessibility tree.

**Output Format:**
```
Page: https://example.com
Title: Example Website

[uid=abc123] button "Submit Form" [role=button]
[uid=def456] heading "Welcome" [role=heading] [level=1]
[uid=ghi789] textbox "Email" [role=textbox] [required]
```

### When to Use

✅ **Perfect for:**
- Finding elements to interact with (click, fill, hover)
- Checking if content exists on page
- Verifying text changes
- Accessibility tree inspection
- Quick page structure review
- Element identification by UID

❌ **Not suitable for:**
- Visual appearance verification (colors, fonts, spacing)
- Layout checking (element positions)
- Image content verification
- Styling validation (CSS)

### Advantages

1. **Fast** - Text-based, no image rendering
2. **Searchable** - Use Ctrl+F to find content
3. **Small Size** - ~10KB vs 500KB+ for screenshots
4. **Accessibility-Aware** - Shows ARIA roles, labels
5. **Precise Element Reference** - UIDs for interaction
6. **Terminal-Friendly** - Easy to view in logs

### Parameters

```
take_snapshot({
  verbose: false,        # Include full a11y tree details
  filePath: undefined    # Save to file instead of inline
})
```

**Verbose Mode:**
- Includes full accessibility properties
- Shows computed ARIA attributes
- Displays element states (disabled, checked, etc.)
- Use when debugging accessibility issues

### Examples

**Finding Submit Button:**
```
take_snapshot()

Output:
[uid=abc123] button "Submit" [role=button]

# Now can interact:
click({ uid: "abc123" })
```

**Checking Error Message:**
```
take_snapshot()

Output:
[uid=err456] text "Email is required" [role=alert]

# Message exists - test passes
```

**Form Field Identification:**
```
take_snapshot()

Output:
[uid=email] textbox "Email" [role=textbox] [required]
[uid=pwd] textbox "Password" [role=textbox] [type=password]

# Fill form:
fill({ uid: "email", value: "test@example.com" })
fill({ uid: "pwd", value: "Password123" })
```

---

## Screenshot (take_screenshot)

### What It Is

Visual image of page or element as rendered in browser.

**Output Format:**
- PNG (lossless, best quality, large files)
- JPEG (lossy, smaller files, no transparency)
- WebP (modern, good compression, transparency)

### When to Use

✅ **Perfect for:**
- Visual appearance verification (colors, fonts, styling)
- Layout checking (element positions, spacing)
- Before/after visual comparisons
- Bug report evidence (show visual issues)
- Responsive design testing (screenshots per breakpoint)
- Image content verification

❌ **Not suitable for:**
- Quick content checks (snapshot faster)
- Element identification for interaction (snapshot better)
- Programmatic content verification

### Advantages

1. **Visual Evidence** - Shows exactly what users see
2. **Layout Verification** - Check spacing, alignment, positioning
3. **Styling Validation** - Verify colors, fonts, CSS
4. **Comparative Analysis** - Side-by-side before/after
5. **User-Friendly** - Easy to share with non-technical stakeholders

### Parameters

```
take_screenshot({
  fullPage: false,       # Full page vs viewport only
  format: "png",         # png, jpeg, webp
  quality: 90,           # 0-100 for jpeg/webp
  uid: undefined,        # Specific element only
  filePath: undefined    # Save to file path
})
```

**Format Selection:**
- PNG: Highest quality, lossless, transparency (~1MB)
- JPEG 85%: Good quality, much smaller (~300KB)
- WebP 90%: Best balance, transparency (~500KB)

**Full Page vs Viewport:**
- `fullPage: false` → Current viewport only (fast)
- `fullPage: true` → Entire scrollable page (slow, large)

### Examples

**Button Styling Verification:**
```
take_screenshot({
  format: "png",
  uid: "button123"
})

# Visual check: Is button blue? Correct size?
```

**Responsive Layout Testing:**
```
const breakpoints = [375, 768, 1024, 1920];

for (const width of breakpoints) {
  resize_page({ width, height: 1080 });
  take_screenshot({
    filePath: `./screenshots/homepage-${width}px.png`,
    fullPage: true
  });
}

# Compare layouts across breakpoints
```

**Before/After Comparison:**
```
# Before code change
take_screenshot({ filePath: "./before.png" });

# Make code change
# ...

# After code change
take_screenshot({ filePath: "./after.png" });

# Compare visually
```

---

## Snapshot + Screenshot Combined

### Best Practices

**Workflow:**
1. Take snapshot first (fast, get UIDs)
2. Take screenshot only when visual confirmation needed
3. Save both for comprehensive evidence

**Example: Form Validation Testing**

```
# Step 1: Snapshot (structure)
take_snapshot();
# Output shows field UIDs

# Step 2: Fill form
fill_form([
  { uid: "email", value: "invalid-email" },
  { uid: "pwd", value: "short" }
]);

# Step 3: Snapshot (check error messages)
take_snapshot();
# Output:
# [uid=err1] text "Email must be valid" [role=alert]
# [uid=err2] text "Password too short" [role=alert]

# Step 4: Screenshot (visual evidence)
take_screenshot({ filePath: "./form-errors.png" });
# Shows red error text, field highlighting
```

---

## Performance Comparison

| Metric | Snapshot | Screenshot |
|--------|----------|------------|
| Speed | ~50ms | ~500ms |
| File Size | ~10KB | ~500KB (PNG) |
| Searchable | Yes | No |
| Visual | No | Yes |
| UIDs | Yes | No |

**Guideline:**
- Use snapshot 80% of the time
- Use screenshot 20% of the time (visual confirmation)
- Use both for critical tests

---

## Use Case Matrix

| Scenario | Tool | Reason |
|----------|------|--------|
| Check if button exists | Snapshot | Fast, searchable |
| Verify button color | Screenshot | Visual appearance |
| Find form fields to fill | Snapshot | Get UIDs |
| Check layout responsive | Screenshot | Visual layout |
| Test screen reader | Snapshot (verbose) | Accessibility tree |
| Bug report evidence | Screenshot | Show visual issue |
| CI/CD quick check | Snapshot | Fast, small files |
| Design review | Screenshot | Visual presentation |

---

## Common Patterns

### Pattern 1: Quick Content Verification

```
# Goal: Check if "Success!" message appears

take_snapshot();

# Search output for "Success!"
# ✓ Fast
# ✓ Reliable
# ✓ No visual needed
```

### Pattern 2: Visual Regression

```
# Goal: Verify button styling unchanged

take_screenshot({
  uid: "submit-button",
  filePath: "./current.png"
});

# Compare with baseline: ./baseline.png
# ✓ Visual comparison
# ✓ Catches CSS changes
```

### Pattern 3: Form Testing

```
# Goal: Test checkout form

# 1. Snapshot (get UIDs)
take_snapshot();

# 2. Fill form using UIDs
fill_form([...]);

# 3. Snapshot (check validation messages)
take_snapshot();

# 4. Screenshot (visual evidence if errors)
if (hasErrors) {
  take_screenshot({ filePath: "./errors.png" });
}
```

### Pattern 4: Responsive Design

```
# Goal: Test mobile layout

const breakpoints = [
  { name: "Mobile", width: 375 },
  { name: "Tablet", width: 768 },
  { name: "Desktop", width: 1920 }
];

for (const bp of breakpoints) {
  resize_page({ width: bp.width, height: 1080 });

  # Snapshot (structure check)
  take_snapshot({ filePath: `./${bp.name}-structure.txt` });

  # Screenshot (visual check)
  take_screenshot({ filePath: `./${bp.name}-visual.png`, fullPage: true });
}
```

---

## Troubleshooting

### Snapshot Shows No Content

**Cause:** Page not fully loaded or dynamic content

**Solution:**
```
# Wait for content
wait_for({ text: "Expected content" });

# Then snapshot
take_snapshot();
```

### Screenshot Too Large

**Cause:** Full page screenshot of long page

**Solutions:**
1. Use viewport only: `fullPage: false`
2. Use JPEG: `format: "jpeg", quality: 85`
3. Screenshot specific element: `uid: "element123"`

### Snapshot Missing Elements

**Cause:** Elements not in accessibility tree (hidden, ARIA issues)

**Solutions:**
1. Use verbose mode: `verbose: true`
2. Take screenshot to see visual elements
3. Use evaluate_script to query DOM directly

### Screenshot Shows Old State

**Cause:** Page not updated after interaction

**Solution:**
```
# After interaction, wait for stable state
click({ uid: "button" });
wait_for({ text: "Updated content" });

# Then screenshot
take_screenshot();
```

---

## Best Practices

### For CI/CD Pipelines

**Use Snapshot:**
- Fast execution (~50ms vs ~500ms)
- Small artifacts (~10KB vs ~500KB)
- Easy to diff (text vs images)
- Searchable in logs

**Use Screenshot:**
- Only for critical visual tests
- Compress with JPEG/WebP
- Store in artifact storage (S3, etc.)
- Generate on failure only

### For Bug Reports

**Include Both:**
1. Snapshot (reproduction steps)
   ```
   [uid=button] button "Submit" [disabled]
   ```

2. Screenshot (visual evidence)
   ![Bug](./bug.png)

3. Explanation
   "Submit button is disabled when it should be enabled"

### For Accessibility Testing

**Prefer Snapshot (Verbose):**
```
take_snapshot({ verbose: true });
```

**Shows:**
- ARIA roles
- Accessible names
- Descriptions
- States (disabled, checked, expanded)
- Required fields
- Invalid fields

---

## See Also

- [chrome-devtools-api.md](./chrome-devtools-api.md) - Full API reference
- [decision-trees.md](./decision-trees.md) - Quick decision guides
- [form-testing.md](./form-testing.md) - Form testing with snapshots
