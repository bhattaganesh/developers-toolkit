---
name: chrome-debug
description: Use when you need "debug browser", "take screenshot", "inspect page", "check console errors", "test responsive", "debug network", "verify visual changes", "test forms", "check performance", "mobile debug", or mentions Chrome DevTools, browser automation, UI verification, visual regression.
version: 1.0.0
tools: Read, Glob, Grep, Bash
context: fork
disable-model-invocation: true
---

# Chrome DevTools Debugging Skill

Comprehensive browser debugging, visual verification, and performance analysis using Chrome DevTools MCP.

## Quick Reference

**Workflow:** 5 phases with quality gates
**Tools:** Chrome DevTools MCP (25+ tools)
**Deliverables:** Screenshots, network traces, performance reports, bug reports
**Principle:** Visual verification first, non-destructive by default

---

## When to Use

- Visual regression testing (verify UI changes, layout, styling)
- Network debugging (failed requests, CORS, authentication, timing)
- Performance profiling (Core Web Vitals, LCP, CLS, FID)
- Form testing and validation (client-side validation, error states)
- Console error investigation (JavaScript errors, stack traces)
- Mobile/responsive testing (breakpoints, device emulation)

---

## Operating Principles

**1. Visual Verification First:**
- Snapshot (text-based) before screenshot (visual)
- Faster, a11y-aware, searchable
- Screenshot only when visual confirmation needed

**2. Non-Destructive:**
- Read-only by default
- Never submit forms without approval
- Never modify page state without permission

**3. Evidence-Based:**
- Save all artifacts (screenshots, traces, network logs)
- Document reproduction steps
- Provide concrete evidence for every finding

**4. Real Browser Testing:**
- Test in actual Chrome, not assumptions
- Use headless mode for efficiency
- Verify behavior in real browser environment

**5. Resource Aware:**
- Clean up traces after export
- Manage screenshot file sizes
- Close unused pages
- Limit parallel operations

**ASSUMPTION:** Production websites - changes affect real users.

See `references/00-index.md` for detailed references.

---

## Phase 0: Setup & Connection

**Goal:** Establish Chrome connection and define debugging scope

### Actions

1. Check Chrome debug mode connection
2. List available pages
3. Select target page (or create new)
4. Define debugging scope

### If Chrome Not Running

Provide setup command based on OS:

**macOS:**
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --headless
```

**Windows:**
```cmd
chrome.exe --remote-debugging-port=9222 --headless
```

**Linux:**
```bash
google-chrome --remote-debugging-port=9222 --headless
```

**Troubleshooting:**
- Check port 9222 not already in use: `lsof -i :9222` (macOS/Linux) or `netstat -ano | findstr :9222` (Windows)
- Ensure Chrome installed and in PATH
- Try non-headless mode (remove `--headless`) to see Chrome window

### Quality Gate

- [ ] Chrome responds to `list_pages`
- [ ] Target page selected successfully
- [ ] Debugging scope clear

### STOP if:

- Cannot connect to Chrome (port not responding)
- Target page won't load (404, timeout, network error)
- No debugging scope defined

**Wait for all prerequisites before proceeding.**

---

## Phase 1: Initial Inspection

**Goal:** Gather baseline evidence and identify debugging path

### Parallel Operations

Run these in parallel for efficiency:

**Group 1: Page State**
- `take_snapshot` - Get page structure, a11y tree
- Record URL, title, viewport size

**Group 2: Console Health**
- `list_console_messages` - Filter by errors, warnings
- `get_console_message` - Get critical error details

**Group 3: Network Health**
- `list_network_requests` - Filter by status, resourceType
- Identify failed requests (4xx, 5xx)
- Identify slow requests (>1s)

### Decision Tree

Based on findings, select debugging path:

```
What needs debugging?
├─ Visual issue (layout, styling, appearance) → Phase 2A
├─ Network issue (failed requests, CORS, timing) → Phase 2B
├─ Performance issue (slow load, high CLS) → Phase 2C
├─ Form issue (validation, error states) → Phase 2D
└─ JavaScript error (console errors, exceptions) → Phase 2E
```

### Quality Gate

- [ ] Baseline snapshot captured
- [ ] Console messages reviewed
- [ ] Network requests analyzed
- [ ] Debugging path selected

---

## Phase 2A: Visual Debugging

**Goal:** Verify visual changes, layout, and styling

### Workflow

1. **Take Snapshot**
   - Text-based, fast, searchable
   - Identify elements by UID
   - Review page structure

2. **Screenshot (if visual confirmation needed)**
   - Full page or element-specific
   - Save with descriptive filename
   - Format: PNG for quality, JPEG/WebP for smaller size

3. **Responsive Testing (if needed)**
   - Emulate common breakpoints:
     - Mobile: 320px, 375px (iPhone SE, iPhone 12)
     - Tablet: 768px (iPad)
     - Desktop: 1024px, 1920px (Laptop, Desktop)
   - Take screenshot at each breakpoint
   - Compare layouts

4. **Compare States**
   - Before/after code changes
   - Document differences
   - Annotate screenshots with findings

### Deliverable

- Screenshots with annotations
- Element UIDs for reference
- Visual comparison report (use `templates/visual-regression.md`)

See `references/snapshot-vs-screenshot.md` for decision guide.

---

## Phase 2B: Network Debugging

**Goal:** Analyze network requests and identify failures

### Workflow

1. **List Network Requests**
   - Filter by `resourceType`:
     - XHR, Fetch (API calls)
     - Document (page loads)
     - Script, Stylesheet (assets)
   - Filter by status code:
     - 4xx (client errors)
     - 5xx (server errors)
     - Pending/failed

2. **Get Detailed Request Info**
   - Request headers (Authorization, Content-Type, Origin)
   - Response headers (Access-Control-*, Set-Cookie, Cache-Control)
   - Request/response bodies
   - Timing breakdown:
     - Blocked, DNS, Connect, Send, Wait, Receive
     - Total time

3. **Analyze Issues**
   - CORS errors → Check Access-Control-* headers
   - Authentication failures → Check Authorization header
   - Timeout → Check server response time
   - 404 → Verify URL correctness

4. **Correlate with Console**
   - Match network errors with console messages
   - Get stack traces if available

5. **Create cURL Reproduction**
   - Generate cURL command for failed request
   - Include all relevant headers
   - Test in terminal to isolate issue

### Deliverable

- Network issue report (use `templates/network-issue.md`)
- cURL reproduction commands
- Request/response evidence
- Root cause analysis

See `references/network-debugging.md` for detailed patterns.

---

## Phase 2C: Performance Analysis

**Goal:** Profile page performance and Core Web Vitals

### Workflow

1. **Start Performance Trace**
   - `performance_start_trace` with reload
   - Or manual navigation after trace starts

2. **Perform User Interactions**
   - Page load
   - Scroll
   - Click interactions
   - Form fills

3. **Stop Performance Trace**
   - `performance_stop_trace`
   - Export trace file (compressed: .json.gz)

4. **Analyze Insights**
   - Core Web Vitals:
     - LCP (Largest Contentful Paint): <2.5s good
     - CLS (Cumulative Layout Shift): <0.1 good
     - FID (First Input Delay): <100ms good
   - Performance insights from trace
   - Bottleneck identification

5. **Get Detailed Breakdowns**
   - `performance_analyze_insight` for specific insights
   - LCP breakdown (what element, why slow)
   - Render-blocking resources
   - Long tasks

### Deliverable

- Performance report (use `templates/performance-report.md`)
- Core Web Vitals scores
- Trace file for manual review
- Optimization recommendations

See `references/performance-profiling.md` for CWV guide.

---

## Phase 2D: Form Testing

**Goal:** Test form validation, interaction, and accessibility

### Workflow

1. **Take Snapshot**
   - Identify form fields by UID
   - Note field types (input, select, textarea)
   - Document required fields

2. **Fill Form**
   - Sequential: `fill` for each field
   - Parallel: `fill_form` for multiple fields
   - Test validation on blur/change

3. **Verify Validation States**
   - Required field validation
   - Format validation (email, phone, URL)
   - Custom validation rules
   - Error message display

4. **Test Keyboard Navigation**
   - `press_key` with Tab
   - Verify tab order logical
   - Check focus indicators visible
   - Test Escape key (close modals)

5. **Check Error Messages**
   - Take snapshot after validation
   - Check console for client-side errors
   - Verify error messages clear and helpful

6. **Test Submission (with approval)**
   - Ask user before submitting
   - Verify success state
   - Check loading indicators

### Deliverable

- Form testing checklist (use `templates/form-testing-checklist.md`)
- Validation results
- Screenshots of error states
- Accessibility notes

See `references/form-testing.md` for detailed workflows.

---

## Phase 2E: Console Investigation

**Goal:** Trace JavaScript errors to source

### Workflow

1. **List Console Messages**
   - Filter by type:
     - error (critical errors)
     - warn (warnings)
     - info (informational)
   - Sort by timestamp or frequency

2. **Get Detailed Messages**
   - `get_console_message` for each error
   - Stack trace
   - Source file and line number
   - Error message

3. **Correlate with Source**
   - Map stack trace to source files
   - Identify error patterns
   - Check for repeated errors

4. **Document Reproduction**
   - Steps to trigger error
   - Browser state when error occurs
   - Related network/console activity

### Deliverable

- Console error report
- Stack traces
- Source file references (file:line)
- Reproduction steps

---

## Quality Gate 2: Findings Review

**Goal:** Review evidence before deep investigation

### Approval Checklist

- [ ] All findings documented
- [ ] Evidence collected (screenshots, traces, console logs)
- [ ] Reproduction steps clear and testable
- [ ] Root causes identified (or hypotheses documented)

### User Review

Present findings to user for approval:
- Summary of issues found
- Evidence for each issue
- Proposed next steps

**If approved:** Proceed to Phase 3
**If rejected:** Return to Phase 1 or clarify scope

---

## Phase 3: Targeted Investigation

**Goal:** Deep dive into specific issues with advanced techniques

### Actions

1. **Execute Custom Scripts**
   - `evaluate_script` for advanced DOM queries
   - Custom checks not possible with standard tools
   - Extract computed styles, element properties
   - Note: Return values must be JSON-serializable

2. **Compare States**
   - Before/after code changes
   - Different user states (logged in/out)
   - Different data scenarios

3. **Test Edge Cases**
   - Boundary conditions
   - Error states
   - Empty states
   - Loading states

4. **Document Detailed Steps**
   - Precise reproduction steps
   - Environment details
   - Browser version, viewport size
   - User agent if relevant

See `references/script-evaluation.md` for safe script patterns.

---

## Phase 4: Documentation & Cleanup

**Goal:** Create deliverables and clean up resources

### Actions

1. **Generate Bug Reports**
   - Use `templates/bug-report.md`
   - One report per issue
   - Include all evidence
   - Severity rating (Critical/High/Medium/Low)

2. **Create GitHub Issues** (if applicable)
   ```bash
   # For each bug found
   gh issue create \
     --title "[Bug] ${ISSUE_TITLE}" \
     --body-file ./chrome-debug-artifacts/reports/bug-report.md \
     --label "bug,needs-triage,chrome-debug" \
     --assignee @me
   ```

3. **Save Artifacts**
   - Create artifact directory: `./chrome-debug-artifacts/`
   - Organize by type:
     - `screenshots/` - All screenshots with descriptive names
     - `traces/` - Performance traces (compressed)
     - `network/` - Network logs, cURL commands
     - `reports/` - Bug reports, summary

4. **Create Summary Report**
   - Executive summary of all findings
   - Evidence index
   - Reproduction steps
   - Recommended fixes (if applicable)

5. **Cleanup**
   - Close unused pages (`close_page`)
   - Delete large temporary files
   - Compress traces if not already compressed
   - Archive artifacts

### Final Deliverables

- Evidence report with all artifacts
- Bug reports (ready for GitHub issues)
- Reproduction steps for each issue
- Recommended fixes (when possible)
- Archive of all artifacts

---

## STOP Conditions

**Never proceed if:**
- Chrome not running in debug mode (cannot connect)
- Page fails to load (404, timeout, network error)
- Critical security dialog appears (handle with `handle_dialog` first)
- Resource limits exceeded (too many screenshots, traces)
- User explicitly requests to stop

**Ask before:**
- Submitting forms
- Navigating away from page (may lose state)
- Modifying page state with scripts
- Taking actions visible to other users

---

## Safety Rules

### Non-Destructive by Default

- Never submit forms without explicit approval
- Never delete data
- Never modify page state (except with approval)
- Always ask before navigation that might lose state

### Resource Management

- Close unused pages after debugging
- Export traces before stopping (avoid data loss)
- Clean up large screenshots (compress or delete)
- Limit parallel operations (max 3-5 concurrent)

### Security

- Never expose credentials in screenshots (redact sensitive data)
- Warn when capturing payment forms
- Handle authentication dialogs carefully
- Don't log sensitive headers (Authorization, Cookie)

---

## Reference Materials

See `references/` directory for detailed guides:

- **00-index.md** - Reference directory guide
- **chrome-devtools-api.md** - Complete MCP tool catalog (25+ tools)
- **decision-trees.md** - When to use which approach
- **setup-guide.md** - Launch Chrome in debug mode
- **snapshot-vs-screenshot.md** - Visual verification decision guide
- **network-debugging.md** - Network request analysis patterns
- **performance-profiling.md** - Core Web Vitals and trace analysis
- **form-testing.md** - Form interaction workflows
- **emulation-profiles.md** - Mobile/responsive testing
- **script-evaluation.md** - Custom JavaScript execution

---

## Templates

Use templates in `templates/` directory for common deliverables:

- **visual-regression.md** - Screenshot comparison template
- **bug-report.md** - Evidence-based bug report
- **network-issue.md** - Failed request analysis
- **performance-report.md** - Core Web Vitals report
- **form-testing-checklist.md** - Form validation matrix
- **responsive-matrix.md** - Multi-device testing grid

---

## Examples

See `examples/` directory for complete walkthroughs:

- **01-visual-verification.md** - Button styling change
- **02-network-debugging.md** - CORS issue investigation
- **03-performance-audit.md** - Slow page load analysis
- **04-form-testing.md** - Checkout form validation
- **05-mobile-responsive.md** - Responsive layout testing
- **06-console-errors.md** - JavaScript error tracing

---

**Version:** 1.0.0
**Last Updated:** 2026-02-07
