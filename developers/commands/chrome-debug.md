---
description: Debug browser issues, verify visual changes, inspect network requests, and test responsive layouts using Chrome DevTools
---

# Chrome Debug

Use the browser automation tools and Chrome DevTools integration to debug, verify, and test your UI using the `chrome-debug` skill.

## Instructions

1. **Identify the task** — Ask the user what they need:
   - **Visual regression** — Verify a UI change looks correct in the browser
   - **Network debugging** — Inspect failed requests, CORS issues, auth headers, timing
   - **Console errors** — Capture JavaScript errors and stack traces
   - **Performance** — Core Web Vitals, LCP, CLS, FID measurement
   - **Form testing** — Validate client-side validation, error states
   - **Responsive testing** — Test at different breakpoints, device emulation

2. **Activate the skill** — Trigger the `chrome-debug` skill by describing the need:
   > "Debug the browser console errors on [page]"
   > "Take a screenshot and verify [UI change]"
   > "Test responsive layout at mobile breakpoints"
   > "Check network requests for the [feature] API call"

3. **5-Phase workflow** — The skill executes:
   - **Phase 1:** Page navigation and initial capture
   - **Phase 2:** Visual/console/network inspection
   - **Phase 3:** Targeted debugging based on issue type
   - **Phase 4:** Verification and evidence collection
   - **Phase 5:** Report with screenshots and findings

4. **Review deliverables:**
   - Screenshots of current and target states
   - Network trace with request/response details
   - Console error log with stack traces
   - Performance metrics report
   - Bug report with reproduction steps

## What the Skill Does

- **Screenshots** — Capture current UI state, compare before/after
- **Console monitoring** — Read JavaScript errors, warnings, and logs
- **Network inspection** — Request/response headers, payloads, timing, status codes
- **Performance** — Core Web Vitals measurement with improvement suggestions
- **Form validation** — Test input states, error messages, submission flow
- **Responsive** — Test at xs/sm/md/lg/xl breakpoints, device emulation
- **GIF recording** — Record multi-step interactions for documentation

## Dependencies

This command activates the **chrome-debug** skill bundled with the developers plugin.
Requires the Chrome DevTools MCP extension to be installed and active.
