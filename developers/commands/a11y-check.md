---
description: Find WCAG 2.2 Level AA accessibility violations in HTML, React, and WordPress code using the a11y-checker agent
---

# A11y Check

Run a focused accessibility audit on the codebase or specified files.

## Instructions

1. **Identify scope** — Determine what to audit:
   - If the user specifies files, components, or a feature area, use those
   - If no scope given, find all UI-rendering files: PHP templates, React components, Blade views, widget files

2. **Launch a11y-checker** — Use the Task tool to spawn the **a11y-checker** agent with the identified scope.

3. **Present findings** — Group violations by WCAG criterion:
   - **Level A** (must fix — breaks core functionality for some users)
   - **Level AA** (should fix — standard compliance requirement)
   - Include: file path, line number, element, violation description

4. **Prioritize** — Surface the highest-impact issues first:
   - Missing keyboard access (users cannot reach element)
   - Missing form labels (screen readers cannot identify inputs)
   - Missing alt text on informational images
   - Insufficient color contrast on primary text

5. **Summary** — End with: files scanned, total violations by level, estimated effort to fix (Quick Wins vs Structural).

## What the Agent Checks

- Semantic HTML and ARIA landmark usage
- Keyboard navigability of all interactive elements
- Focus indicators (visible focus on Tab)
- Screen reader support (alt text, aria-label, aria-describedby)
- Color contrast ratios (4.5:1 normal text, 3:1 large text)
- Form label associations
- Interactive component ARIA roles (modals, tabs, dropdowns)
- Reduced motion support

## Dependencies

This command uses the **a11y-checker** agent bundled with the developers plugin.
For a full WCAG audit workflow with remediation plan and GitHub issues, use `/developers:accessibility-audit` instead.
