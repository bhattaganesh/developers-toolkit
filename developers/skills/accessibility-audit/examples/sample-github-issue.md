# Sample GitHub Issue

Example of a filled accessibility issue following the template.

---

## Title
[Accessibility] Missing focus indicators for keyboard navigation

## Labels
accessibility, a11y, P1, keyboard, enhancement

---

## Summary

Buttons and inputs don't have visible focus indicators, making keyboard navigation impossible.

**Severity:** P1 High
**WCAG:** 2.4.7 Focus Visible (Level AA)
**Screens:** Settings page, Meta box, Export modal, Contact form

## What's the Issue?

When you press Tab to navigate with your keyboard, there's no visual indicator showing which element has focus. It's like trying to navigate a maze blindfolded.

## Why This Matters

**Who is affected:** Keyboard users, motor impairment users (can't use mouse), power users (prefer keyboard)

**What breaks:** Users can't see where they are on the page. They have to click randomly with the mouse to find buttons.

**Impact:** ~10% of users rely on keyboard navigation. This blocks them completely.

## User Impact Example

> "I have a motor impairment and can't use a mouse precisely. I rely on keyboard navigation. When I Tab through your settings page, I have no idea where my focus is. I have to give up and ask someone to help me."

## How to Reproduce

1. Go to Settings: `http://localhost:8080/wp-admin/options-general.php?page=my-plugin`
2. **Don't use your mouse**
3. Press Tab key repeatedly
4. **Expected:** Blue outline around focused element
5. **Actual:** No visual indicator

**Evidence:**
- File: `assets/admin.css:23`
- Code:
```css
*:focus {
  outline: none;  /* Removes all focus indicators */
}
```

## Root Cause

Global CSS removes all focus outlines without alternative. Done for aesthetic reasons but breaks accessibility.

**Affected elements:** 8 buttons, 12 inputs, 3 dropdowns

## Suggested Fix

**Approach:** CSS-only
**Effort:** 5 minutes
**Risk:** Low

**Recommended solution:**
```css
/* Remove this: */
*:focus {
  outline: none;
}

/* Add this: */
*:focus-visible {
  outline: 2px solid #2271b1;  /* WP admin blue */
  outline-offset: 2px;
}

*:focus:not(:focus-visible) {
  outline: none;
}
```

**Why this fix:**
- Shows outline for keyboard, hides for mouse clicks
- Uses WordPress admin blue
- Zero impact on mouse users

## Design Considerations

**Visual impact:** None for mouse users
**Layout changes:** None
**Brand consistency:** Uses WP admin blue

## Testing Checklist

- [ ] Tab through page, see outline
- [ ] Click buttons, no outline
- [ ] Screen reader tested (NVDA)
- [ ] axe DevTools passes
- [ ] Chrome, Firefox, Safari

## Acceptance Criteria

- [ ] All elements have visible focus indicator (keyboard)
- [ ] No indicator for mouse clicks
- [ ] Focus indicator meets 3:1 contrast
- [ ] Passes axe DevTools
- [ ] Works in all browsers

## Learn More

- [WCAG 2.4.7 Focus Visible](https://www.w3.org/WAI/WCAG22/Understanding/focus-visible)
- [MDN: :focus-visible](https://developer.mozilla.org/en-US/docs/Web/CSS/:focus-visible)

---
**Audit Date:** 2026-02-07
**Auditor:** Claude Code accessibility-audit skill v1.0.0
