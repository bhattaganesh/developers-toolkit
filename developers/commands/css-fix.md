---
description: Solve complex CSS and Tailwind challenges — layouts, animations, responsive patterns, cross-browser issues
---

# CSS Fix

Solve CSS problems using the `css-expert` agent — layouts, Tailwind edge cases, animations, and cross-browser issues.

## Instructions

1. **Understand the problem** — Ask the user to describe:
   - What should it look like vs what it currently looks like
   - Which browser or screen size is broken (if applicable)
   - The element or component name and its file path
   - Any constraints: can't change markup? Tailwind only? No JS?

2. **Read the current code** — Find and read the relevant CSS/Tailwind classes, the component's markup, and any parent layout containers that might affect it.

3. **Launch css-expert** — Use the Task tool to spawn the **css-expert** agent with:
   - The broken component file(s)
   - The problem description
   - Any constraints provided

4. **Review the solution** — Confirm the fix:
   - Explains WHY it works (not just what to change)
   - Does not introduce Tailwind classes that conflict with existing ones
   - Does not break adjacent elements or parent layout
   - Is responsive (mobile-first)

5. **Apply the fix** — After user confirmation, apply the changes.

## Common Problems the Agent Handles

- Flexbox/Grid alignment edge cases
- Sticky/fixed positioning with scroll containers
- Z-index stacking context conflicts
- Tailwind arbitrary value syntax and JIT mode issues
- CSS animations with `prefers-reduced-motion` support
- Cross-browser `-webkit-` prefix issues
- Overflow and scroll containment
- Dark mode with Tailwind `dark:` variants
- Print stylesheet issues

## Dependencies

This command uses the **css-expert** agent bundled with the developers plugin.
