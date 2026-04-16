# Master Tracking Issue Template

Template for master GitHub tracking issue.

```markdown
---
Title: [Accessibility] WCAG 2.2 Audit - {X} Issues Found
Labels: accessibility, a11y, audit, tracking
---

## Summary

Comprehensive WCAG 2.2 Level AA accessibility audit.

**Scope:** {X} screens ({Y} admin, {Z} frontend)
**Findings:** {Total} issues across 9 categories
**Patterns:** Grouped into {N} repeating patterns

### By Severity

- **P0 (Blocking):** {X} issues - Must fix (Level A violations)
- **P1 (High):** {X} issues - Should fix (Level AA violations)
- **P2 (Medium):** {X} issues - Nice to fix (best practices)
- **P3 (Low):** {X} issues - Enhancement

### By Category

- Keyboard Navigation: {X} issues
- Focus Management: {X} issues
- Screen Reader Support: {X} issues
- Color & Contrast: {X} issues
- Forms & Input: {X} issues
- Semantic HTML: {X} issues
- Interactive Components: {X} issues
- Tables: {X} issues
- Motion & Responsive: {X} issues

---

## P0 - Blocking Issues

- [ ] #{issue} - {title}

---

## Quick Wins

Fixes that address multiple issues with minimal work:

### 1. {Pattern Name} ({time estimate})
**Fixes:** #{issues}
**Approach:** {CSS/Attributes}
**Risk:** Low

---

## Remediation Roadmap

### Sprint 1: Quick Wins
- {Issues} ({percentage}%)

### Sprint 2: Structural Fixes
- {Issues} ({percentage}%)

---

## Testing

### Manual
- [ ] Keyboard navigation
- [ ] Screen reader (NVDA/VoiceOver)
- [ ] 200% zoom
- [ ] Mobile (320px)

### Automated
\`\`\`bash
axe http://localhost:8080
pa11y --standard WCAG2AA http://localhost:8080
\`\`\`

---

**Audit:** WCAG 2.2 Level AA
**Date:** {YYYY-MM-DD}
```
