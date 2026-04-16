---
description: Audit and improve UX, microcopy, user flows, and interaction design — covers usability, copy quality, and visual hierarchy
---

# UX Review

Comprehensive UX and copy review using the `ux-reviewer` skill — evaluates usability, interaction patterns, microcopy, navigation, and user psychology.

## Instructions

1. **Define scope** — Ask the user what to review:
   - Specific UI components (forms, modals, dashboards, onboarding)
   - A full user flow (checkout, signup, settings, plugin configuration)
   - Copy and microcopy (error messages, button labels, tooltips, help text)
   - Navigation and information architecture

2. **Activate the skill** — Trigger the `ux-reviewer` skill by describing the need:
   > "Audit the UX of [component/flow]"
   > "Review user experience for [feature]"
   > "Check usability of [page/component]"
   > "Review the copy / microcopy in [area]"
   > "Improve UI text / error messages in [plugin/component]"
   > "Test the user flow for [task]"
   > "Check navigation and information architecture"

3. **Review process** — The skill evaluates:
   - **UX Heuristics** — Nielsen's 10 principles applied to the UI
   - **User Flows** — Task completion paths, unnecessary steps, dead ends
   - **Copy Quality** — Clear, human-readable labels, error messages, CTAs
   - **Microcopy** — Tooltips, placeholders, helper text, validation messages
   - **Visual Hierarchy** — Layout, affordances, consistency across views
   - **Accessibility Basics** — Keyboard navigation, focus management, ARIA labels

4. **Review deliverables:**
   - Prioritized findings with component-level specificity
   - Before/after copy suggestions for every string issue
   - Actionable UX improvements with pattern references
   - Optional: implemented fixes applied to component files

## What the Skill Covers

- **Navigation** — Menu structure, breadcrumbs, back navigation, deep linking
- **Forms** — Labels, placeholders, validation timing, error recovery
- **CTAs** — Button labels, primary vs secondary hierarchy, destructive action warnings
- **Error states** — Human-readable messages, how-to-fix guidance, retry paths
- **Loading states** — Skeletons vs spinners, progress indicators, optimistic updates
- **Empty states** — Illustration + message + primary action CTA
- **Onboarding** — First-run experience, progressive disclosure, setup completion
- **Success flows** — Confirmation messages, next steps, state change feedback

## Dependencies

This command activates the **ux-reviewer** skill bundled with the developers plugin.
For a pure accessibility/WCAG audit, use `/developers:accessibility-audit` instead.
For a read-only UX issues report (no copy changes), use `/developers:ux-audit` instead.
