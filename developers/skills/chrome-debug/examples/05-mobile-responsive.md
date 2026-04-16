# Example: Responsive Layout Testing

**Scenario:** Test new landing page across mobile, tablet, and desktop breakpoints.

**Page:** https://example.com/landing
**Breakpoints:** 375px, 768px, 1920px

---

## Phase 0: Setup

```
list_pages()
select_page({ pageId: 1 })
navigate_page({ type: "url", url: "https://example.com/landing" })
```

---

## Phase 1: Initial Inspection

**Desktop baseline (1920px):**
```
resize_page({ width: 1920, height: 1080 })
take_snapshot()
take_screenshot({
  fullPage: true,
  filePath: "./desktop-1920px.png"
})
```

---

## Phase 2A: Visual Debugging (Responsive)

### Test Mobile (375px - iPhone)

```
resize_page({ width: 375, height: 667 })

# Snapshot (structure check)
take_snapshot()

# Screenshot (visual verification)
take_screenshot({
  fullPage: true,
  filePath: "./mobile-375px.png"
})
```

**Observations:**
- ✅ Navigation collapses to hamburger menu
- ✅ Hero image scales correctly
- ✅ Text readable (not too small)
- ❌ **Issue:** Footer columns overlap!

**Screenshot issue:**
```
take_screenshot({
  uid: "footer",
  filePath: "./mobile-footer-issue.png"
})
```

---

### Test Tablet (768px - iPad)

```
resize_page({ width: 768, height: 1024 })

take_snapshot()
take_screenshot({
  fullPage: true,
  filePath: "./tablet-768px.png"
})
```

**Observations:**
- ✅ 2-column grid layout
- ✅ Navigation bar visible (not hamburger)
- ✅ Images scale appropriately
- ❌ **Issue:** CTA button too small (touch target <44px)

**Measure button:**
```
evaluate_script({
  function: "(el) => { return { width: el.offsetWidth, height: el.offsetHeight }; }",
  args: [{ uid: "cta-button" }]
})

Output: { width: 120, height: 36 }
```

❌ Height only 36px (should be ≥44px for touch)

---

### Test Desktop (1920px)

```
resize_page({ width: 1920, height: 1080 })

take_screenshot({
  fullPage: true,
  filePath: "./desktop-1920px.png"
})
```

**Observations:**
- ✅ 3-column grid layout
- ✅ Full navigation visible
- ✅ All content properly spaced
- ✅ No issues detected

---

## Comparison Grid

**Create side-by-side screenshots:**
```
# Screenshots collected:
- mobile-375px.png
- tablet-768px.png
- desktop-1920px.png
```

---

## Evidence Collected

1. **Screenshots:**
   - Mobile (375px): Full page + footer issue
   - Tablet (768px): Full page + button measurement
   - Desktop (1920px): Full page

2. **Snapshots:** Structure verified at each breakpoint

3. **Measurements:** CTA button 120x36px (too small for tablet)

---

## Findings

### ✅ Working Correctly

**Mobile (375px):**
- Navigation → hamburger menu
- Single column layout
- Text legible (16px minimum)
- Images scale correctly

**Tablet (768px):**
- 2-column grid
- Navigation bar visible
- Images scale correctly

**Desktop (1920px):**
- 3-column grid
- Full navigation
- Proper spacing

### ❌ Issues Found

**Issue 1: Footer Overlap on Mobile**
- **Breakpoint:** 375px
- **Description:** Footer columns stack incorrectly, text overlaps
- **Screenshot:** mobile-footer-issue.png
- **Severity:** High
- **Fix:**
  ```css
  @media (max-width: 767px) {
    .footer-column {
      width: 100%;
      margin-bottom: 20px;
    }
  }
  ```

**Issue 2: CTA Button Too Small on Tablet**
- **Breakpoint:** 768px
- **Description:** Button height 36px (should be ≥44px for touch)
- **Severity:** Medium (accessibility/usability)
- **Fix:**
  ```css
  @media (min-width: 768px) {
    .cta-button {
      padding: 12px 24px; /* Increases height to 48px */
    }
  }
  ```

---

## Responsive Matrix

| Breakpoint | Width | Layout | Issues | Status |
|------------|-------|--------|--------|--------|
| Mobile | 375px | 1 column | Footer overlap | ❌ Fail |
| Tablet | 768px | 2 columns | Button too small | ⚠️ Minor |
| Desktop | 1920px | 3 columns | None | ✅ Pass |

---

## Recommendations

**High Priority:**
1. **Fix footer overlap on mobile**
   - Impact: Affects all mobile users
   - Effort: Low (CSS fix)
   - Expected time: 15 minutes

**Medium Priority:**
2. **Increase CTA button size on tablet**
   - Impact: Improves touch usability
   - Effort: Low (CSS padding)
   - Expected time: 10 minutes

---

## Outcome

**Status:** ⚠️ Pass with Fixes Required

**Ready for Production:** No (footer overlap blocks mobile users)

**After Fixes:**
- Re-test mobile (375px)
- Re-test tablet (768px)
- Verify touch targets ≥44px
- Take updated screenshots

---

## Takeaways

1. **Test all breakpoints** - Issues often appear only at specific widths
2. **Check touch targets** - Tablets need ≥44px for accessibility
3. **Screenshot full page** - Catches issues below the fold (like footer)
4. **Measure elements** - Use evaluate_script for precise measurements
5. **Test real devices** - Emulation good, but test on actual devices when possible
