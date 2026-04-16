---
description: Review code for misused, missing, or overcomplicated design patterns in WordPress, and React codebases
---

# Design Patterns

Audit code for design pattern correctness and architectural fit using the `design-patterns-reviewer` agent.

## Instructions

1. **Identify scope** — Determine what to review:
   - If the user specifies files or a module, use those
   - If no scope given, audit core business logic:
     - WordPress: `app/Services/`, `app/Http/Controllers/`, `app/Models/`
     - WordPress: main plugin class, admin controllers, REST endpoint handlers
     - React: `components/`, `hooks/`, `store/`, `context/`

2. **Launch design-patterns-reviewer** — Use the Task tool to spawn the **design-patterns-reviewer** agent with the identified scope.

3. **Present findings** — Group by pattern category:
   - **Misused patterns** — Pattern applied incorrectly (e.g., God Object, Anemic Domain Model)
   - **Missing patterns** — Obvious place where a pattern should be applied but isn't (e.g., no Repository when there should be)
   - **Over-engineered patterns** — Pattern applied where simpler code would work better
   - **Anti-patterns** — Code smells: Singleton abuse, deep inheritance, feature envy

4. **For each finding:**
   - File path and line reference
   - Current pattern (or lack thereof)
   - Recommended pattern and why it fits better
   - Concrete refactoring hint (not full implementation)

5. **Summary** — End with: files reviewed, total findings by category, top 3 highest-priority refactors.

## What the Agent Reviews

**WordPress:** Repository, Service Layer, Observer, Factory, Strategy, Decorator, Command Bus
**WordPress:** Singleton plugin bootstrap, Hook composition, Template Method
**React:** Container/Presentational, Compound Component, Custom Hooks, Render Props, Context patterns

## Dependencies

This command uses the **design-patterns-reviewer** agent bundled with the developers plugin.


