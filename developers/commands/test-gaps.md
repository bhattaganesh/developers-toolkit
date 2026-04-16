---
description: Find gaps in test coverage using the test-critic agent
---

# Test Gaps

Identify missing test coverage across the codebase.

## Instructions

1. **Identify scope** — Determine what to analyze:
   - If the user specifies files or a feature, focus there
   - If no scope given, analyze all controllers (`app/Http/Controllers/`) and components (`resources/js/components/`, `src/components/`)

2. **Launch test-critic** — Use the Task tool to spawn the **test-critic** agent with the identified scope.

3. **Present findings** — Show the test-critic's findings grouped by:
   - Controllers/endpoints with no test file at all
   - Controller actions missing feature tests
   - Validation rules not tested
   - Authorization paths not tested
   - Components missing render/interaction tests

4. **Prioritize** — Highlight the highest-risk gaps first:
   - Auth endpoints without tests
   - Payment/financial endpoints without tests
   - Data mutation endpoints without tests

5. **Summary** — End with: controllers/components analyzed, total gaps found, suggested first 5 tests to write.

## Dependencies

This command uses the test-critic agent bundled with the **developers** plugin.
