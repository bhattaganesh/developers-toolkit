# Findings Report Template

Structure for complete accessibility audit report.

```markdown
# Accessibility Audit Findings

**Project:** {Plugin/Theme Name}
**Audit Date:** {YYYY-MM-DD}
**Standard:** WCAG 2.2 Level AA
**Auditor:** Claude Code accessibility-audit skill

---

## Executive Summary

**Scope:** {X} screens audited ({Y} admin, {Z} frontend)
**Findings:** {Total} issues found
**Severity:** {P0} blocking, {P1} high, {P2} medium, {P3} low

**Quick wins available:** {X} issues can be fixed in {time} with low risk

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

- **Manual:** Keyboard, screen reader (NVDA), contrast check, zoom
- **Automated:** axe DevTools, Lighthouse, pa11y

---

## Screen Inventory

| ID | Screen | Type | File | Priority |
|----|--------|------|------|----------|
| ADMIN-001 | Settings | Admin | path/to/file.php | High |

---

## Findings by Screen

### ADMIN-001: Settings Page

**Category 1: Semantic HTML** ✅ Pass
**Category 2: Keyboard** ❌ Fail
- FINDING-001: Color picker not keyboard accessible

[Continue for all categories...]

---

## Findings by Pattern

### Pattern 1: Missing Focus Indicators (8 occurrences)

**Affected screens:** {list}
**Root cause:** {description}
**Fix:** {solution}
**Impact:** Fixes {X} issues with {Y} change

---

## Remediation Plan

### Quick Wins (15-30 min)
- [ ] Fix focus indicators → {X} issues
- [ ] Add alt text → {X} issues

### Structural (4-6 hours)
- [ ] Fix heading hierarchy
- [ ] Convert div buttons

---

## Testing Guide

{Manual and automated testing procedures}

---

## Resources

- [WCAG 2.2](https://www.w3.org/WAI/WCAG22/quickref/)
- [WordPress Accessibility](https://make.wordpress.org/accessibility/)
```
