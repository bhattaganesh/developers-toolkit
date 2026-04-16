# Sample Findings Report

Example audit report for a fictional "QuickForms" WordPress plugin.

---

# Accessibility Audit Findings: QuickForms Plugin

**Project:** QuickForms - WordPress Form Builder
**Audit Date:** 2026-02-07
**Standard:** WCAG 2.2 Level AA
**Auditor:** Claude Code accessibility-audit skill v1.0.0

---

## Executive Summary

**Scope:** 5 screens audited (3 admin, 2 frontend)
**Findings:** 23 issues found
**Severity:**
- P0 (Blocking): 2 issues
- P1 (High): 8 issues
- P2 (Medium): 10 issues
- P3 (Low): 3 issues

**Quick wins available:** 15 issues can be fixed in ~1 hour with low risk (CSS + attributes)

---

## Methodology

### 9 Audit Categories

1. Semantic HTML & Landmarks
2. Keyboard Navigation
3. Focus Management
4. Screen Reader Support
5. Color & Contrast
6. Forms & Input
7. Tables
8. Interactive Components
9. Motion & Responsiveness

### Testing Approach

**Manual:**
- Keyboard navigation (Tab, no mouse)
- Screen reader (NVDA Windows)
- Contrast check (DevTools)
- 200% zoom test
- Mobile responsive (320px)

**Automated:**
- axe DevTools v4.8.2
- Lighthouse v11.0.0
- pa11y v6.2.3

---

## Screen Inventory

| ID | Screen | Type | File | Priority |
|----|--------|------|------|----------|
| ADMIN-001 | Form Builder | Admin page | admin/form-builder.php | High |
| ADMIN-002 | Plugin Settings | Admin page | admin/settings.php | High |
| ADMIN-003 | Submissions List | Admin page | admin/submissions.php | Medium |
| FRONT-001 | Contact Form | Frontend | templates/contact-form.php | High |
| MODAL-001 | Export Wizard | Modal | assets/js/export-modal.jsx | Medium |

---

## Findings by Screen

### ADMIN-001: Form Builder

**File:** `admin/form-builder.php`
**Priority:** High

**Category 1: Semantic HTML** ✅ Pass
- Heading hierarchy correct (h1 → h2 → h3)
- Uses semantic buttons
- Proper landmark regions

**Category 2: Keyboard Navigation** ❌ Fail
- **FINDING-001:** Drag-and-drop field ordering not keyboard accessible
  - Location: `assets/js/form-builder.js:156`
  - Issue: Can only reorder fields by dragging with mouse
  - Fix: Add keyboard handlers (Alt+Up/Down to reorder)
  - WCAG: 2.1.1 Keyboard

**Category 3: Focus Management** ❌ Fail
- **FINDING-002:** No visible focus indicator
  - Location: Global CSS removes outline
  - Issue: `*:focus { outline: none; }` in `assets/admin.css:23`
  - Fix: Add `:focus-visible` styles
  - WCAG: 2.4.7 Focus Visible

**Category 4: Screen Reader Support** ❌ Fail
- **FINDING-003:** Field type icons missing labels
  - Location: `admin/form-builder.php:203-215`
  - Issue: 8 icon buttons have no `aria-label`
  - Fix: Add `aria-label="Add text field"` to each
  - WCAG: 4.1.2 Name, Role, Value

**Category 5: Color & Contrast** ✅ Pass
**Category 6: Forms** ✅ Pass
**Category 7: Tables** N/A
**Category 8: Components** ✅ Pass
**Category 9: Motion** ✅ Pass

**Summary:** 3 findings (1 P1, 2 P2)

---

### ADMIN-002: Plugin Settings

**File:** `admin/settings.php`
**Priority:** High

**Findings:**
- **FINDING-004:** Required fields not marked (P1)
- **FINDING-005:** Color picker not keyboard accessible (P0)

---

## Findings by Pattern

### Pattern 1: Missing Focus Indicators (8 occurrences)

**Affected screens:** All screens
**Occurrences:** 8 buttons, 12 inputs, 3 dropdowns

**Root cause:**
```css
/* assets/admin.css:23 */
*:focus {
  outline: none;
}
```

**Single fix:**
```css
*:focus-visible {
  outline: 2px solid #2271b1;
  outline-offset: 2px;
}
```

**Impact:** Fixes 23 issues with 1 CSS change
**Effort:** 5 minutes
**Risk:** Low

---

### Pattern 2: Icon Buttons Without Labels (8 occurrences)

**Affected screens:** Form Builder, Settings

**Fix:** Add `aria-label` to each button
**Effort:** 10 minutes
**Risk:** Low

---

## Remediation Plan

### Quick Wins (45 minutes) - Low Risk
- [ ] Fix focus indicators → 23 issues (1 CSS change)
- [ ] Add aria-label to icon buttons → 8 issues
- [ ] Add alt text to 5 images
- [ ] Add prefers-reduced-motion → 2 issues

**Impact:** 15 issues (65%)
**Risk:** Low (CSS + attributes only)

### Structural Fixes (4 hours) - Medium Risk
- [ ] Add keyboard handlers to drag-and-drop
- [ ] Fix color picker (use wp.components.ColorPicker)
- [ ] Mark required fields

**Impact:** 6 issues (26%)
**Risk:** Medium (markup/JS changes)

### UI Changes (Design Review) - High Risk
- [ ] Add visible required indicators

**Impact:** 2 issues (9%)
**Risk:** High (visual changes)

---

## Testing Guide

### Manual Testing

**Keyboard:**
```
1. Unplug mouse
2. Tab through all screens
3. Verify all elements reachable
```

**Screen Reader (NVDA):**
```
1. Download: https://www.nvaccess.org/
2. Start: Ctrl+Alt+N
3. Navigate with Tab, H, B, F
```

### Automated Testing

```bash
# Install tools
npm install -g @axe-core/cli pa11y

# Scan pages
axe http://localhost:8080/wp-admin/admin.php?page=quickforms
pa11y --standard WCAG2AA http://localhost:8080
```

---

## Educational Notes

### What is keyboard navigation?

Many users can't use a mouse:
- Motor impairments (can't click precisely)
- Blind users (can't see cursor)
- Power users (prefer keyboard)

They press **Tab** to move between elements. Every button, link, and input must be reachable via Tab.

### What are focus indicators?

The blue outline that shows which element is focused. Required for keyboard users to know where they are.

---

## Resources

**WordPress:**
- [WP Accessibility Handbook](https://make.wordpress.org/accessibility/handbook/)
- [Gutenberg A11y](https://github.com/WordPress/gutenberg/blob/trunk/docs/contributors/accessibility.md)

**WCAG:**
- [WCAG 2.2 Quick Ref](https://www.w3.org/WAI/WCAG22/quickref/)
- [Understanding WCAG](https://www.w3.org/WAI/WCAG22/Understanding/)

**Tools:**
- [axe DevTools](https://www.deque.com/axe/devtools/)
- [NVDA](https://www.nvaccess.org/)

---

## Next Steps

1. Review this report
2. Implement quick wins (~45 min)
3. Create GitHub issues for remaining items
4. Test with keyboard + screen reader
5. Run automated scans

**Contact:** See tracking issue for questions
