---
description: Run a comprehensive WCAG 2.2 Level AA accessibility audit with beginner-friendly findings and a minimal-change remediation plan
---

# Accessibility Audit

Run a full WCAG 2.2 Level AA compliance audit using the `accessibility-audit` skill — covers keyboard navigation, screen reader support, color contrast, ARIA, and more.

## Instructions

1. **Define scope** — Identify what to audit:
   - WordPress plugin admin pages or front-end output
   - React/NextJS components or pages
   - A full theme or website
   - Specific WCAG criteria (e.g., keyboard navigation only, focus management)

2. **Activate the skill** — Trigger the `accessibility-audit` skill by describing the task:
   > "Run an accessibility audit on [scope]"
   > "Check WCAG compliance for [component/plugin/page]"

3. **7-Phase workflow** — The skill executes:
   - **Phase 1:** Scope and inventory
   - **Phase 2:** Automated scanning
   - **Phase 3:** Keyboard navigation testing
   - **Phase 4:** Screen reader verification
   - **Phase 5:** Color contrast analysis
   - **Phase 6:** ARIA and semantic HTML review
   - **Phase 7:** Remediation report

4. **Review deliverables:**
   - Findings report with WCAG criterion reference for each issue
   - GitHub issues for each violation (grouped by severity)
   - Testing guide for manual verification
   - Remediation plan (CSS fix → attribute fix → markup fix → UI change)
   - Optional: PR with fixes applied

## What the Audit Covers

**WCAG 2.2 Level AA (48 criteria)**:
- Keyboard: All interactive elements reachable and operable without a mouse
- Focus: Visible focus indicators, logical focus order, no focus traps
- Labels: Every input associated with `<label>`, every image with `alt`
- Contrast: 4.5:1 text, 3:1 large text and UI components
- Screen reader: Semantic HTML, ARIA roles/states/properties
- Motion: `prefers-reduced-motion` respected
- Touch: Minimum 44×44px touch targets

**Standards met:** ADA, Section 508, EN 301 549

## Dependencies

This command activates the **accessibility-audit** skill bundled with the developers plugin.
For a quick UX/usability scan (not full WCAG audit), use `/developers:ux-audit` instead.
