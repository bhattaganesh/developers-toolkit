---
name: react-context
description: >
  This skill should be used when the user is editing React or NextJS files (.jsx, .tsx),
  or files in components/, pages/, or hooks/ directories. Provides component architecture
  guidance, React hooks rules, state management patterns, and Tailwind CSS conventions.
version: 1.0.0
---

# React Context

## Component Architecture
- **Functional components only** — never use class components
- **One component per file** — file name matches component name in PascalCase
- **Modular design** — extract reusable pieces into separate components whenever possible
- **Composition over inheritance** — use props, children, and render props for flexibility
- **Server Components by default** in Next.js — only add `"use client"` when the component needs interactivity, state, or browser APIs

## Hooks Rules
- Custom hooks for shared logic — prefix with `use` (e.g., `useCredits`, `useAuth`)
- Never call hooks conditionally or inside loops
- Keep hooks focused — one concern per hook
- Use `useMemo` and `useCallback` only when there is a measured performance need — avoid premature optimization

## State Management
- Local state with `useState` for component-specific data
- Context for shared state across a subtree — avoid prop drilling
- Server state with React Query / SWR for API data — separate from UI state
- Avoid global state libraries unless genuinely needed at scale

## Tailwind CSS Conventions
- Mobile-first approach — base styles for mobile, then `sm:`, `md:`, `lg:` breakpoints
- Use semantic class grouping — layout, spacing, typography, colors
- Extract repeated patterns into components, not utility classes
- Use `cn()` or `clsx()` for conditional class merging

## File Organization
```
components/
  ui/           # Reusable UI primitives (Button, Input, Modal)
  features/     # Feature-specific components (CreditCard, UserProfile)
hooks/          # Custom hooks
lib/            # Utilities and helpers
services/       # API service functions
types/          # TypeScript type definitions
```

## Best Practices
- Use TypeScript for all new files — define props interfaces explicitly
- Destructure props in function signature for clarity
- Use `key` prop correctly in lists — never use array index as key for dynamic lists
- Handle loading, error, and empty states in every data-fetching component
- Lazy load heavy components with `React.lazy()` and `Suspense`
