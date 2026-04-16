---
description: Audit UI/UX for usability, accessibility, flow, and consistency — get actionable fixes grouped by impact
---

# UX Audit

Audit your UI/UX for usability issues, accessibility gaps, and interaction problems using the `ux-auditor` agent.

## Instructions

1. **Define scope** — Ask the user what to audit:
   - Specific component(s) (e.g., `CheckoutForm`, `DataTable`, `Sidebar`)
   - A page or screen (e.g., the onboarding flow, settings page)
   - The full application UI

2. **Gather context** — Understand the stack:
   - React/NextJS components (`components/`, `pages/`, `app/`)
   - WordPress plugin admin pages (`admin/`, `templates/`)
   - Any known UX concerns the user wants prioritised

3. **Launch ux-auditor** — Use the Task tool to spawn the **ux-auditor** agent with:
   - Target components or directories
   - Stack context (React, WordPress admin, etc.)
   - Any specific UX concerns to prioritise

4. **Present findings** — The agent groups issues by impact:
   - **Critical** — Blocks users from completing tasks
   - **Major** — Frustrates or confuses users
   - **Minor** — Polish and consistency improvements

5. **Top 3 Actions** — Highlight the three highest-priority fixes with component references.

## What the Agent Checks

- **Flow** — Can users complete tasks in minimal steps?
- **Clarity** — Is it obvious what each element does?
- **Feedback** — Loading, success, error states for every action
- **Recovery** — Undo, confirmation on destructive actions
- **Accessibility** — Keyboard nav, focus indicators, ARIA, contrast (WCAG 2.2 AA)
- **Mobile UX** — Touch targets ≥ 44×44px, no hover-only interactions
- **Forms** — Labels, real-time validation, inline errors that explain how to fix
- **Empty states** — Not blank white space; include illustration + CTA
- **Error states** — Human-readable messages, retry buttons

## Dependencies

This command uses the **ux-auditor** agent bundled with the developers plugin.
For comprehensive UX + copy review including microcopy improvement, use `/developers:ux-review` instead.
