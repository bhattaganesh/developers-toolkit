# Example: Button Styling Verification

**Scenario:** Developer changed submit button styling (blue → green). Need to verify visual change and ensure no regressions.

**Page:** https://example.com/checkout
**Change:** Submit button color changed from #0066cc (blue) to #00cc66 (green)

---

## Phase 0: Setup

```
# Chrome already running in debug mode

# List pages
list_pages()
# → Page 1: Checkout page

# Select page
select_page({ pageId: 1 })
```

---

## Phase 1: Initial Inspection

**Snapshot (structure check):**
```
take_snapshot()

Output:
[uid=submit-btn] button "Complete Purchase" [role=button]
[uid=cancel-btn] button "Cancel" [role=button]
```

**Console (check for errors):**
```
list_console_messages({ types: ["error"] })

Output: No errors
```

---

## Phase 2A: Visual Debugging

**Take screenshot (before state - if you had one saved):**
```
# Would compare with baseline: ./before.png
```

**Take current screenshot:**
```
take_screenshot({
  uid: "submit-btn",
  format: "png",
  filePath: "./current-button.png"
})

# Visual confirmation: Button is green
```

**Screenshot full form (context):**
```
take_screenshot({
  fullPage: false,
  format: "png",
  filePath: "./checkout-form.png"
})
```

**Responsive check:**
```
# Test mobile
resize_page({ width: 375, height: 667 })
take_screenshot({ filePath: "./button-mobile.png" })

# Test tablet
resize_page({ width: 768, height: 1024 })
take_screenshot({ filePath: "./button-tablet.png" })

# Test desktop
resize_page({ width: 1920, height: 1080 })
take_screenshot({ filePath: "./button-desktop.png" })
```

---

## Evidence Collected

1. **Screenshots:**
   - `current-button.png` - Green button (element-specific)
   - `checkout-form.png` - Full form context
   - `button-mobile.png` - Mobile view (375px)
   - `button-tablet.png` - Tablet view (768px)
   - `button-desktop.png` - Desktop view (1920px)

2. **Snapshot:** Confirmed button text and structure unchanged

3. **Console:** No JavaScript errors

---

## Findings

✅ **Visual Change Verified:**
- Button color changed from blue to green
- Color appears to be #00cc66 (as intended)
- Visible across all breakpoints

✅ **No Regressions:**
- Button text unchanged ("Complete Purchase")
- Button position unchanged
- Button functionality unchanged (clickable)
- No console errors
- Responsive behavior maintained

✅ **Layout:**
- No layout shifts detected
- Button size consistent across breakpoints
- Spacing around button maintained

---

## Outcome

**Status:** ✅ Change approved - no regressions detected

**Recommendation:** Deploy to production

---

## Takeaways

1. **Snapshot first** - Quick structure verification (1s vs 10s for screenshot)
2. **Element screenshots** - Faster than full page for specific elements
3. **Test responsive** - Color changes can affect visibility on different backgrounds
4. **Check console** - Ensure no CSS/JS errors introduced
