---
description: Profile code performance and identify bottlenecks with actionable recommendations
---

# Profile

Analyze code performance and generate a profiling plan with specific tools and targets.

## Instructions

1. **Identify scope** — Ask what to profile:
   - A specific endpoint or page (e.g., "the dashboard API is slow")
   - The entire application (general performance audit)
   - A specific area: queries, memory, bundle size, render performance

2. **Detect stack** — Check the project to determine profiling approach:
   - `composer.json` with WordPress → PHP/WordPress profiling
   - WordPress markers → WordPress profiling
   - `package.json` with React/Next → Frontend profiling
   - Mixed stack → profile both backend and frontend

3. **Launch code-profiler** — Use the Task tool to spawn the **code-profiler** agent with the identified scope. The agent will:
   - Scan code for performance anti-patterns
   - Identify what needs measuring
   - Recommend specific tools and commands
   - Set quantified targets

4. **Quick wins** — Before deep profiling, check for obvious issues:
   - **WordPress**: `php wp route:cache`, check for N+1 with `preventLazyLoading()`
   - **WordPress**: Check `SAVEQUERIES`, audit autoloaded options
   - **React**: Run `npx next build` and check bundle size warnings

5. **Present profiling plan** — Structured output with:
   - Immediate checks (commands to run now)
   - Bottlenecks found in code review
   - Recommended tools to install
   - Performance targets to hit

6. **Offer to implement** — After presenting the plan, offer to:
   - Add profiling middleware or logging
   - Install recommended tools
   - Fix the identified bottlenecks

## Dependencies

This command uses the code-profiler and perf-analyzer agents bundled with the **developers** plugin.

