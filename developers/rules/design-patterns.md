---
description: Design patterns and architectural principles for WordPress and React
globs:
  - "src/**/*.{js,jsx,ts,tsx}"
  - "includes/**/*.php"
---

# Design Patterns Rules

## Core Principles
- Prefer composition over inheritance
- Single Responsibility — one class/component does one thing
- Don't Repeat Yourself — but don't abstract prematurely either
- YAGNI — only add patterns when complexity demands it, not preemptively
- Dependency Inversion — depend on abstractions (interfaces), not concrete classes

## WordPress Patterns

### Required
- **Hooks** — All extensibility via `add_action` / `add_filter`, never direct calls
- **Singleton** — Shared plugin instances via `getInstance()` or container
- **Prefix Everything** — All functions, classes, hooks, constants, options

### Use When Needed
- **Registry** — Managing collections (post types, taxonomies, admin pages)
- **Template Method** — Base class defines workflow, subclasses customize steps
- **MVC-lite** — Separate data handling (models) from rendering (templates)

## React Patterns

### Required
- **Custom Hooks** — All shared stateful logic extracted into `use*` hooks
- **Composition** — Build complex UI from small, focused components
- **Container/Presentational** — Separate data logic from rendering

### Use When Needed
- **Provider Pattern** — React Context for cross-cutting state (theme, auth, locale)
- **Compound Components** — Related components that share implicit state
- **Render Props** — When custom hooks don't fit (rare in modern React)

### Avoid
- Class components — use functional components exclusively
- HOC chains deeper than 2 — prefer custom hooks
- Prop drilling beyond 2 levels — use context or composition

## Anti-Patterns to Avoid (All Stacks)
- **God Class/Component** — doing too many things, split by responsibility
- **Spaghetti Code** — no clear boundaries, logic scattered across files
- **Golden Hammer** — using the same pattern everywhere regardless of fit
- **Premature Abstraction** — abstracting before there's a second use case
- **Magic Numbers/Strings** — hardcoded values without named constants
- **Shotgun Surgery** — one change requires modifications in many unrelated files


