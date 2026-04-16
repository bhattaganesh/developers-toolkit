---
description: React, NextJS, and Tailwind CSS conventions
globs:
  - "src/**/*.{js,jsx,ts,tsx}"
  - "resources/js/**/*.{js,jsx,ts,tsx}"
  - "components/**/*.{js,jsx,ts,tsx}"
  - "pages/**/*.{js,jsx,ts,tsx}"
  - "app/**/*.{js,jsx,ts,tsx}"
---

# React / NextJS Rules

## Component Architecture
- One component per file — no multiple component exports from a single file
- Modular design — create a separate component whenever there is possibility of reuse
- Functional components only — no class components
- Container components handle logic, presentational components handle UI
- File naming: PascalCase for components (`CreditDashboard.jsx`), camelCase for hooks (`useCreditData.js`)

## Hooks
- Extract shared logic into custom hooks (prefix with `use`)
- Never call hooks inside conditionals, loops, or nested functions
- Always provide complete dependency arrays in `useEffect` / `useMemo` / `useCallback`
- Always include cleanup functions in `useEffect` for subscriptions, timers, event listeners
- Derive values from state instead of storing redundant state

## State Management
- Use local state (`useState`) for component-specific data
- Use context for data shared across a subtree
- Avoid prop drilling — restructure with composition or context
- Keep state as close to where it's used as possible

## NextJS Specific
- Server components by default — only add `'use client'` when you need interactivity
- Fetch data in server components, not client-side `useEffect`
- Use `loading.tsx`, `error.tsx`, `not-found.tsx` for route states
- Use `next/image` for all images
- Define metadata with `generateMetadata` for SEO

## Tailwind CSS
- Mobile-first responsive design (`sm:`, `md:`, `lg:`)
- No inline `style={}` mixed with Tailwind classes
- Extract repeated class combinations into components (prefer over `@apply`)
- Consistent class ordering: layout > sizing > spacing > typography > colors > effects

## Form Validation
- Use Zod schemas for runtime validation of API responses and form data
- Define schemas once, share between frontend validation and type inference
- Validate API responses before using them — never trust external data shapes

## Testing
- Every component needs at least a render test
- Test user interactions (click, submit, keyboard)
- Mock API calls — test loading, success, and error states
- Custom hooks should have their own test file
