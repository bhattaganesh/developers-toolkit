# Accessibility Testing Checklist

Manual and automated testing procedures for WCAG 2.2 compliance.

## Manual Testing

### 1. Keyboard Navigation Test

**Goal:** Verify all functionality works without a mouse

**Steps:**
1. **Unplug mouse** (or don't use it)
2. Press **Tab** to move forward through interactive elements
3. Press **Shift+Tab** to move backward
4. Press **Enter** or **Space** to activate buttons/links
5. Press **Escape** to close modals/dropdowns
6. Use **Arrow keys** in custom components (tabs, accordions)

**Verify:**
- ✓ All buttons, links, inputs reachable via Tab
- ✓ Tab order is logical (matches visual flow)
- ✓ No keyboard traps (can Tab out of every component)
- ✓ Focus indicator clearly visible
- ✓ Enter/Space activates buttons
- ✓ Escape closes modals

### 2. Screen Reader Test (NVDA - Windows)

**Install:** https://www.nvaccess.org/ (free)

**Steps:**
1. Start NVDA: **Ctrl+Alt+N**
2. Navigate with:
   - **Tab** - Interactive elements
   - **H** - Headings
   - **B** - Buttons
   - **F** - Form fields
   - **G** - Graphics/images
   - **T** - Tables
3. Listen for announcements

**Verify:**
- ✓ Images have alt text (not "Unlabeled graphic")
- ✓ Buttons have accessible names (not just "Button")
- ✓ Form inputs have labels
- ✓ Status messages announced
- ✓ Error messages announced and associated

**Common issues:**
- "Unlabeled graphic" = missing alt text
- "Button" with no name = missing aria-label
- "Edit" with no label = form input without label

### 3. Screen Reader Test (VoiceOver - Mac Desktop)

**Enable:** Cmd+F5

**Steps:**
1. Navigate: **VO+Right Arrow** (VO = Ctrl+Option)
2. Headings: **VO+Cmd+H**
3. Links: **VO+Cmd+L**
4. Rotor: **VO+U** (landmarks, headings, links, forms)

**Verify:** Same as NVDA

### 4. Mobile Screen Reader Test (TalkBack - Android)

**Enable:** Settings → Accessibility → TalkBack → Turn on

**Steps:**
1. **Swipe right** to move to next element
2. **Swipe left** to move to previous element
3. **Double-tap** anywhere to activate focused element
4. **Two-finger swipe down** to read from current position
5. **Swipe down then right** to access reading controls

**Navigate by element type:**
- **Local context menu:** Swipe up then right
- **Headings:** Swipe up then down (or down then up)
- **Links:** Change reading controls to "Links"

**Verify:**
- ✓ All interactive elements announced with role
- ✓ Images have alt text descriptions
- ✓ Form labels announced before inputs
- ✓ Status messages announced automatically
- ✓ Touch target sizes adequate (≥ 48x48dp)

**Common issues:**
- "Button, unlabeled" = missing accessible name
- "Graphic, unlabeled" = missing alt text
- Silent form fields = missing labels

### 5. Mobile Screen Reader Test (VoiceOver - iOS)

**Enable:** Settings → Accessibility → VoiceOver → On
**Quick toggle:** Triple-click side/home button (if configured)

**Steps:**
1. **Swipe right** to move to next element
2. **Swipe left** to move to previous element
3. **Double-tap** to activate focused element
4. **Two-finger swipe down** to read from current position
5. **Three-finger swipe** up/down to scroll page

**Navigate by element type:**
- **Rotor:** Two-finger rotate (dial gesture)
- **Headings:** Set rotor to "Headings", swipe up/down
- **Links:** Set rotor to "Links", swipe up/down
- **Landmarks:** Set rotor to "Landmarks", swipe up/down

**Verify:**
- ✓ All elements have clear, descriptive labels
- ✓ Images announce meaningful descriptions
- ✓ Form fields have associated labels
- ✓ Dynamic updates announced
- ✓ Touch targets ≥ 44x44pt

**Common issues:**
- "Button" (no description) = missing label
- "Image" (no description) = missing alt
- Form field doesn't announce label = disconnected label/input

### 6. Windows High Contrast Mode

**Enable:** Alt+Shift+Print Screen (toggle)
**Or:** Settings → Ease of Access → High Contrast

**Steps:**
1. Enable High Contrast mode
2. Navigate through all screens
3. Check all UI components visible

**Verify:**
- ✓ All text visible and readable
- ✓ Focus indicators visible
- ✓ Borders and boundaries visible
- ✓ Icons remain recognizable
- ✓ Custom colors respect High Contrast mode

**Common issues:**
- Background images hide text (use system colors)
- Custom focus indicators invisible (use system colors)
- Borders defined by background-image (use border property)

**CSS Fix:**
```css
@media (prefers-contrast: high) {
  /* Ensure borders visible */
  .button {
    border: 2px solid currentColor;
  }

  /* Ensure focus visible */
  *:focus-visible {
    outline: 3px solid;
  }
}
```

### 7. Contrast Test

**Tools:**
- Browser DevTools → Inspect element → Color picker
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/

**Steps:**
1. Inspect text element
2. Click color swatch in Styles panel
3. DevTools shows contrast ratio

**Verify:**
- ✓ Normal text: ≥ 4.5:1
- ✓ Large text (18px+ or bold 14px+): ≥ 3:1
- ✓ UI components (buttons, inputs): ≥ 3:1
- ✓ Disabled states: ≥ 3:1 (still readable)

### 8. Zoom Test (200%)

**Steps:**
1. Browser zoom: **Ctrl/Cmd + Plus** (200%)
2. Navigate through page

**Verify:**
- ✓ No horizontal scrolling
- ✓ All text readable (not clipped)
- ✓ No overlapping content
- ✓ Layout doesn't break

### 9. Responsive Test (320px)

**Steps:**
1. Browser DevTools → Device toolbar
2. Set width to 320px (smallest mobile)

**Verify:**
- ✓ Layout works at narrow width
- ✓ All content accessible
- ✓ Touch targets ≥ 44x44px

---

## Automated Testing

### 1. axe DevTools (Browser Extension)

**Install:**
- Chrome: https://chrome.google.com/webstore (search "axe DevTools")
- Firefox: https://addons.mozilla.org/en-US/firefox/ (search "axe DevTools")

**Usage:**
1. Open page to test
2. Open DevTools (F12)
3. Go to "axe DevTools" tab
4. Click "Scan ALL of my page"
5. Review issues by severity

**Severity levels:**
- **Critical:** MUST fix (WCAG failure)
- **Serious:** Should fix (likely WCAG failure)
- **Moderate:** Fix recommended
- **Minor:** Best practice

### 2. Lighthouse (Chrome DevTools)

**Usage:**
1. Open Chrome DevTools (F12)
2. Go to "Lighthouse" tab
3. Select "Accessibility" category
4. Click "Analyze page load"
5. Review score (aim for 100)

**Note:** Lighthouse uses axe-core, so results overlap with axe DevTools

### 3. WAVE (Browser Extension)

**Install:** https://wave.webaim.org/extension/

**Usage:**
1. Click WAVE icon in browser toolbar
2. Review issues:
   - **Red icons:** Errors (MUST fix)
   - **Yellow icons:** Alerts (check manually)
   - **Green icons:** Features (good!)

### 4. axe-core CLI

**Install:**
```bash
npm install -g @axe-core/cli
```

**Usage:**
```bash
# Scan single page
axe http://localhost:8080/wp-admin/options-general.php

# Scan with JSON output
axe http://localhost:8080 --save results.json

# Scan specific WCAG level
axe http://localhost:8080 --tags wcag2a,wcag2aa
```

### 5. pa11y CLI

**Install:**
```bash
npm install -g pa11y
```

**Usage:**
```bash
# Scan with WCAG 2.2 AA standard
pa11y --standard WCAG2AA http://localhost:8080

# Scan multiple URLs
cat urls.txt | xargs -I {} pa11y {}

# JSON output
pa11y --reporter json http://localhost:8080 > results.json
```

---

## Interpreting Results

### axe Issues

**Critical:** WCAG Level A violation - MUST fix
- Example: Form inputs without labels

**Serious:** Likely WCAG failure - Should fix
- Example: Color contrast below 4.5:1

**Moderate:** May be WCAG failure - Investigate
- Example: Links without distinguishable text

**Minor:** Best practice - Consider fixing
- Example: Redundant alternative text

### Common False Positives

**Color contrast:** Automated tools may flag correct contrast
- **Fix:** Check manually with DevTools

**Landmark nesting:** Context-dependent
- **Fix:** Verify if warning is relevant to your layout

**Link text:** "Click here" flagged but may have context
- **Fix:** Check if link makes sense in context

**Empty buttons:** Icon buttons flagged
- **Fix:** Verify aria-label is present

### What Automated Tools Miss (~30%)

❌ **Keyboard traps** - Can't detect without interaction
❌ **Focus management** - Requires manual testing
❌ **Screen reader experience** - Semantic correctness requires listening
❌ **Logical tab order** - Order may be valid but illogical
❌ **Motion sensitivity** - Requires observing animations

**Bottom line:** Automated testing finds obvious issues. Manual testing finds UX issues.

---

## Testing Workflow

**Recommended order:**

1. **Automated scan** (axe/Lighthouse) - 2 minutes
   - Finds obvious issues
   - Quick wins identified

2. **Keyboard navigation** - 5 minutes
   - Tab through all screens
   - Finds navigation issues

3. **Screen reader (desktop)** - 10 minutes
   - NVDA (Windows) or VoiceOver (Mac)
   - Finds semantic issues

4. **Mobile screen reader** (optional) - 10 minutes
   - TalkBack (Android) or VoiceOver (iOS)
   - Finds mobile-specific issues

5. **Zoom/responsive** - 3 minutes
   - 200% zoom, 320px width
   - Finds layout issues

6. **Manual contrast check** - 2 minutes
   - Verify automated findings
   - Check edge cases

7. **High Contrast Mode** (optional) - 3 minutes
   - Windows High Contrast
   - Verify custom colors respect system

**Total:** ~20-25 minutes per screen (30-35 with mobile testing)

---

## Tools Installation Summary

**Free (Desktop):**
- ✅ NVDA (Windows): https://www.nvaccess.org/
- ✅ VoiceOver (Mac): Built-in, Cmd+F5
- ✅ Windows High Contrast: Built-in, Alt+Shift+Print Screen
- ✅ axe DevTools: Browser extension
- ✅ Lighthouse: Chrome DevTools (built-in)
- ✅ WAVE: Browser extension
- ✅ DevTools color picker: Built-in

**Free (Mobile):**
- ✅ TalkBack (Android): Settings → Accessibility → TalkBack
- ✅ VoiceOver (iOS): Settings → Accessibility → VoiceOver

**Commercial (Optional):**
- 💰 JAWS (Windows): $95/year personal, $1,200+ professional
  - Most-used screen reader (~50% market share)
  - 40-minute demo mode available
  - https://www.freedomscientific.com/products/software/jaws/

**CLI (optional):**
```bash
npm install -g @axe-core/cli pa11y
```

---

**Version:** 1.0.1
**Updated:** 2026-02-07 - Added mobile screen reader testing, Windows High Contrast Mode
