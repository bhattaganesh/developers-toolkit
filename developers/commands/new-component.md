---
name: new-component
description: Create a new React/NextJS component — reads existing patterns, builds with Tailwind, responsive and accessible
---

# New Component

Creates a production-ready React/NextJS component using the `frontend-developer` and `frontend-designer` agents.

## Instructions

1. **Read existing patterns** — Scan the project for component structure, naming conventions, Tailwind usage, state management approach
2. **Gather input** — Ask the user for: component name, purpose, data it displays/accepts, interactive behavior
3. **Design** — Use the `frontend-designer` agent for:
   - Layout structure (responsive grid/flex)
   - Visual design with Tailwind classes
   - Loading, empty, and error states
   - Mobile-first responsive breakpoints
4. **Build** — Use the `frontend-developer` agent for:
   - Component file with props interface
   - Custom hooks for stateful logic (if needed)
   - API integration (if data-fetching)
   - Event handlers and state management
5. **Verify** — Check the component renders without errors

## Rules

- One component per file, PascalCase naming
- Mobile-first Tailwind — base styles for mobile, breakpoints for larger
- Accessible: proper labels, roles, keyboard navigation, focus-visible
- Match existing project design system — colors, spacing, typography
- Split container (data) from presentational (UI) when component is complex
