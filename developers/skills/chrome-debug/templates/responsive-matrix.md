# Responsive Testing Matrix

**Page:** [URL]
**Date:** [YYYY-MM-DD]
**Tested By:** [Name or "Claude Code chrome-debug"]

---

## Test Matrix

| Breakpoint | Width | Height | Device Example | Screenshot | Issues | Status |
|------------|-------|--------|----------------|------------|--------|--------|
| Mobile S   | 320px | 568px  | iPhone SE      | [path]     | [list] | [✅/❌] |
| Mobile M   | 375px | 667px  | iPhone 8       | [path]     | [list] | [✅/❌] |
| Mobile L   | 390px | 844px  | iPhone 12      | [path]     | [list] | [✅/❌] |
| Mobile XL  | 428px | 926px  | iPhone 14 Pro Max | [path]  | [list] | [✅/❌] |
| Tablet     | 768px | 1024px | iPad           | [path]     | [list] | [✅/❌] |
| Laptop     | 1024px| 768px  | Small Laptop   | [path]     | [list] | [✅/❌] |
| Desktop    | 1366px| 768px  | Standard Desktop| [path]    | [list] | [✅/❌] |
| Desktop L  | 1920px| 1080px | Full HD        | [path]     | [list] | [✅/❌] |

---

## Issues Found

### Mobile S (320px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Mobile M (375px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Mobile L (390px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Mobile XL (428px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Tablet (768px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Laptop (1024px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Desktop (1366px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

### Desktop L (1920px)
- [ ] **Issue 1:** [Description]
  - Severity: [Critical / High / Medium / Low]
  - Screenshot: [path]
  - Fix: [Recommended solution]

---

## Layout Checks

### Navigation
- [ ] Mobile menu functional (hamburger icon)
- [ ] Desktop menu displayed correctly
- [ ] Logo visible and appropriately sized
- [ ] Breakpoint transition: [at what width does nav change?]

### Typography
- [ ] Headings scale appropriately
- [ ] Body text readable at all sizes
- [ ] Line length comfortable (45-75 characters)
- [ ] No text overflow or truncation

### Images
- [ ] Images scale appropriately
- [ ] No distortion or stretching
- [ ] Lazy loading working (if implemented)
- [ ] Alt text present

### Grid/Layout
- [ ] Columns stack correctly on mobile
- [ ] Spacing consistent across breakpoints
- [ ] No horizontal scrolling (except intentional)
- [ ] Container widths appropriate

### Forms
- [ ] Form fields full width on mobile
- [ ] Labels and inputs aligned
- [ ] Buttons appropriately sized (min 44px touch target)
- [ ] Error messages visible and readable

### Interactive Elements
- [ ] Buttons large enough for touch (min 44x44px)
- [ ] Links have adequate spacing
- [ ] Hover states work on desktop
- [ ] Touch interactions work on mobile

---

## Orientation Testing

### Portrait
- [ ] Mobile portrait: [✅ / ❌] - Screenshot: [path]
- [ ] Tablet portrait: [✅ / ❌] - Screenshot: [path]

### Landscape
- [ ] Mobile landscape: [✅ / ❌] - Screenshot: [path]
- [ ] Tablet landscape: [✅ / ❌] - Screenshot: [path]

---

## Touch Interactions (Mobile/Tablet)

- [ ] Tap targets min 44x44px
- [ ] Swipe gestures work (if applicable)
- [ ] Pinch zoom allowed/prevented correctly
- [ ] Touch feedback visible (hover states adapt)
- [ ] No accidental clicks on close elements

---

## Critical Breakpoints

**Where layout changes:**

| From | To | Change |
|------|-----------|--------|
| 0px  | 767px  | Mobile: Single column |
| 768px | 1023px | Tablet: 2 columns |
| 1024px+ | ∞ | Desktop: 3+ columns |

**Custom Breakpoints:**
- [XXXpx]: [Description of change]
- [XXXpx]: [Description of change]

---

## Comparison Screenshots

### Before (if redesign)
- Mobile: [path/to/before-mobile.png]
- Tablet: [path/to/before-tablet.png]
- Desktop: [path/to/before-desktop.png]

### After
- Mobile: [path/to/after-mobile.png]
- Tablet: [path/to/after-tablet.png]
- Desktop: [path/to/after-desktop.png]

---

## Performance Notes

| Breakpoint | Page Size | Load Time | Notes |
|------------|-----------|-----------|-------|
| Mobile (375px) | [XXX KB] | [X.X s] | [Notes] |
| Tablet (768px) | [XXX KB] | [X.X s] | [Notes] |
| Desktop (1920px) | [XXX KB] | [X.X s] | [Notes] |

---

## Browser Testing

| Browser | Mobile | Tablet | Desktop | Issues |
|---------|--------|--------|---------|--------|
| Chrome | [✅/❌] | [✅/❌] | [✅/❌] | [list] |
| Safari | [✅/❌] | [✅/❌] | [✅/❌] | [list] |
| Firefox | [✅/❌] | [✅/❌] | [✅/❌] | [list] |
| Edge | [✅/❌] | [✅/❌] | [✅/❌] | [list] |

---

## Summary

### Devices Tested
- ✅ [X] breakpoints tested
- ✅ [X] orientations tested
- ✅ [X] browsers tested

### Issues Summary
- **Critical:** [X] issues
- **High:** [X] issues
- **Medium:** [X] issues
- **Low:** [X] issues

### Recommendations

**High Priority:**
1. [Fix 1]
2. [Fix 2]

**Medium Priority:**
1. [Improvement 1]
2. [Improvement 2]

**Low Priority:**
1. [Enhancement 1]
2. [Enhancement 2]

---

## Approval

- [ ] All breakpoints tested
- [ ] All critical issues documented
- [ ] Screenshots captured for all sizes
- [ ] Layout acceptable at all sizes
- [ ] Touch interactions work on mobile
- [ ] Performance acceptable

**Approved By:** [Name]
**Date:** [YYYY-MM-DD]
**Status:** [✅ Approved / ❌ Needs Fixes]

---

## Evidence Files

**Screenshots Folder:** [./screenshots/responsive/]
- mobile-320px.png
- mobile-375px.png
- mobile-390px.png
- mobile-428px.png
- tablet-768px.png
- laptop-1024px.png
- desktop-1366px.png
- desktop-1920px.png

**Comparison Grid:** [./responsive-comparison-grid.png]
