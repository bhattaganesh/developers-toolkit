---
description: Diagnose and fix failing tests — runs suite, classifies failures, suggests or implements minimal fixes
---

# Fix Tests

Diagnose and fix failing tests with minimal, targeted changes.

## Instructions

1. **Run test suite** — Execute the test suite and capture all failures:
   - Run `php wp test` (or the project's test command)
   - If the user specifies a subset, run only those tests
   - Capture the full error output including stack traces

2. **Analyze each failure** — For each failing test:
   - Read the test file to understand what it expects
   - Read the source code being tested
   - Check `git log --oneline -10` for recent changes that may have caused the failure
   - Identify the exact assertion or line that fails and why

3. **Classify the failure** — Categorize each failure as one of:
   - **Test is outdated** — The code intentionally changed but the test was not updated
   - **Code has a regression** — The test is correct but the code has a bug
   - **Setup is wrong** — Missing fixtures, factories, mocks, or environment config
   - **Flaky test** — Timing, ordering, or external dependency issue

4. **Suggest or implement fix** — For each failure:
   - Present the classification and root cause
   - Suggest the minimal fix (change as few lines as possible)
   - Ask the user if they want you to implement the fix, or implement it if they already requested it
   - For regressions: fix the source code, not the test
   - For outdated tests: update the test to match new behavior
   - For setup issues: fix the test setup/teardown

5. **Re-run and confirm** — After all fixes are applied:
   - Re-run the full test suite
   - Confirm all previously failing tests now pass
   - Confirm no new failures were introduced
   - Report final pass/fail counts

