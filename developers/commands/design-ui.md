---
description: Design or redesign a UI component with Tailwind CSS — responsive, accessible, and visually polished
---

# Design UI

Design or redesign UI components using the `frontend-designer` agent — layouts, visual polish, responsive patterns.

## Instructions

1. **Understand the design goal** — Ask the user:
   - What is the component? (e.g., pricing card, data table, sidebar nav, modal)
   - Is this a new design or a redesign of an existing component?
   - What is the primary user action? (view, click, fill form, etc.)
   - Any constraints: dark mode support? Existing color palette? RTL?

2. **Read existing design system** — Scan the project for:
   - Existing Tailwind config (`tailwind.config.js`) for custom colors, fonts, spacing
   - Existing similar components to match visual style
   - Any design tokens or component library in use

3. **For redesigns** — Read the existing component file(s) before suggesting changes.

4. **Launch frontend-designer** — Use the Task tool to spawn the **frontend-designer** agent with:
   - Component description and design goal
   - Existing design system context
   - Any constraints or requirements

5. **Review the design** — Confirm the output:
   - Mobile-first responsive (base → sm: → md: → lg:)
   - Accessible: proper heading hierarchy, focus states, color contrast
   - All states handled: default, hover, focus, active, disabled, loading, empty, error
   - Consistent with project's existing visual style

6. **Apply** — After user approval, write the component file.

## Rules

- Mobile-first Tailwind — base styles for mobile, add breakpoints for larger
- Never use arbitrary values when a Tailwind default works
- Always include focus-visible styles — no `outline: none` without alternative
- Use semantic HTML elements in the markup

## Dependencies

This command uses the **frontend-designer** agent bundled with the developers plugin.
For a full React component with logic and data-fetching, use `/developers:new-component` instead.
