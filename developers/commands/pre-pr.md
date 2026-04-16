---
description: Pre-PR checklist — scans for debug artifacts, validates routes, migrations, tests, and generates PR description
---

# Pre-PR

Run a comprehensive pre-PR checklist before opening a pull request.

## Instructions

1. **Scan all changes** — Run `git diff main...HEAD` to collect all files changed in this branch. Use this as the scope for all subsequent checks.

2. **Check for debug artifacts** — Search the diff for leftover debug statements:
   - PHP: `dd(`, `dump(`, `var_dump(`, `print_r(`, `ray(`
   - JS/TS: `console.log(`, `console.debug(`, `debugger`
   - General: `TODO`, `FIXME`, `HACK`, `XXX`
   - Report each with file:line reference

3. **Validate routes** — For any new routes added in `routes/`:
   - Verify auth middleware is applied (or explicitly documented as public)
   - Check that route names follow project conventions
   - Confirm controller methods exist

4. **Validate migrations** — For any new migration files:
   - Verify each has a `down()` method
   - Check for destructive operations (dropping columns/tables) and flag them
   - Confirm migration order is logical

5. **Check test coverage** — For each new file (controller, service, model, request):
   - Check if a corresponding test file exists
   - Flag new files without tests

6. **Run test suite** — Execute `php wp test` and capture results. Report pass/fail count.

7. **Generate PR description** — Based on the diff, produce:
   - **Summary**: 1-2 sentence overview of the change
   - **What changed**: Bulleted list of key changes
   - **How to test**: Steps a reviewer can follow to verify

8. **Output go/no-go checklist** — Present a final checklist:
   - [ ] No debug artifacts
   - [ ] Routes have auth middleware
   - [ ] Migrations have down() methods
   - [ ] New files have tests
   - [ ] Test suite passes
   - Mark each as pass/fail with details for any failures

