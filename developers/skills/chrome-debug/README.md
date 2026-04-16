# Chrome DevTools Debugging Skill

**Version:** 1.0.0
**Status:** Stable

---

## Overview

The Chrome DevTools Debugging Skill provides comprehensive browser debugging, visual verification, network analysis, and performance profiling workflows using Chrome DevTools MCP.

**Perfect for:**
- Visual regression testing (UI changes, layout verification)
- Network debugging (failed requests, CORS, timing analysis)
- Performance profiling (Core Web Vitals, bottleneck identification)
- Form testing (validation, error states, accessibility)
- Console error investigation (JavaScript errors, stack traces)
- Mobile/responsive testing (breakpoints, device emulation)

---

## Features

### 🎯 Core Capabilities

**Visual Debugging:**
- Text-based snapshots (fast, a11y-aware, searchable)
- Visual screenshots (full page or element-specific)
- Responsive testing across breakpoints
- Before/after comparisons

**Network Debugging:**
- Request/response analysis
- CORS troubleshooting
- Authentication header inspection
- Timing waterfall analysis
- cURL reproduction commands

**Performance Profiling:**
- Core Web Vitals measurement (LCP, CLS, FID)
- Performance trace recording
- Bottleneck identification
- Optimization recommendations

**Form Testing:**
- Field validation testing
- Error state verification
- Keyboard navigation testing
- Accessibility checks

**Console Investigation:**
- JavaScript error tracing
- Stack trace analysis
- Source file correlation
- Error pattern identification

### ✨ Advanced Features

- **Device Emulation** - Mobile, tablet, desktop viewports with touch support
- **Network Throttling** - 3G, 4G, offline simulation
- **Custom Scripts** - Execute JavaScript for advanced DOM queries
- **Geolocation Testing** - Test location-based features
- **Dark Mode Testing** - Color scheme emulation
- **Performance Traces** - Export for manual analysis
- **Screenshot Automation** - Batch screenshots across breakpoints

### 📚 Reference Materials

- **chrome-devtools-api.md** (25+ MCP tools) - Complete tool catalog
- **decision-trees.md** - When to use which approach
- **setup-guide.md** - Launch Chrome in debug mode
- **snapshot-vs-screenshot.md** - Visual verification guide
- **network-debugging.md** - Network analysis patterns
- **performance-profiling.md** - Core Web Vitals guide
- **form-testing.md** - Form interaction workflows
- **emulation-profiles.md** - Mobile/responsive testing
- **script-evaluation.md** - Custom JavaScript patterns
- **00-index.md** - Reference directory guide

### 📋 Templates

- **visual-regression.md** - Screenshot comparison template
- **bug-report.md** - Evidence-based bug report
- **network-issue.md** - Failed request analysis
- **performance-report.md** - Core Web Vitals report
- **form-testing-checklist.md** - Form validation matrix
- **responsive-matrix.md** - Multi-device testing grid

### 📖 Examples

- **01-visual-verification.md** - Button styling change walkthrough
- **02-network-debugging.md** - CORS issue investigation
- **03-performance-audit.md** - Slow page load analysis
- **04-form-testing.md** - Checkout form validation
- **05-mobile-responsive.md** - Responsive layout testing
- **06-console-errors.md** - JavaScript error tracing

---

## Installation

Chrome DevTools MCP tools are built-in - no installation needed.

**Requirements:**
- Chrome browser installed
- Chrome running with remote debugging enabled (see Usage section)

---

## Usage

### Activation Triggers

The skill activates when you mention:
- "debug browser"
- "take screenshot"
- "inspect page"
- "check console errors"
- "test responsive design"
- "debug network requests"
- "verify visual changes"
- "test forms"
- "check performance"
- "mobile debugging"
- Chrome DevTools, browser automation, UI verification, visual regression

### Example Conversations

**Visual Regression Testing:**
```
You: "I changed the button styling - can you verify it looks correct?"
Claude: [Loads chrome-debug skill]

Phase 0: I'll connect to Chrome and navigate to your page.
First, let me check if Chrome is running in debug mode...
```

**Network Debugging:**
```
You: "The API call is failing with a CORS error. Can you debug it?"
Claude: [Loads chrome-debug skill]

Phase 0: I'll connect to Chrome and inspect the network requests.
Let me list all network requests and identify the failed ones...
```

**Performance Audit:**
```
You: "The page is loading slowly. Can you profile it?"
Claude: [Loads chrome-debug skill]

Phase 0: I'll start a performance trace and analyze Core Web Vitals.
Starting trace...
```

**Form Testing:**
```
You: "Can you test the checkout form validation?"
Claude: [Loads chrome-debug skill]

Phase 0: I'll take a snapshot to identify form fields, then test validation.
Let me see the form structure...
```

**Mobile Responsive:**
```
You: "Does the layout work on mobile devices?"
Claude: [Loads chrome-debug skill]

Phase 0: I'll emulate mobile viewports and screenshot each breakpoint.
Testing at 320px, 375px, 768px, 1024px, 1920px...
```

---

## Setup: Launch Chrome in Debug Mode

Before using the skill, Chrome must be running with remote debugging enabled.

### macOS
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --headless
```

### Windows
```cmd
chrome.exe --remote-debugging-port=9222 --headless
```

### Linux
```bash
google-chrome --remote-debugging-port=9222 --headless
```

### Options

- `--remote-debugging-port=9222` - Enable debugging on port 9222
- `--headless` - Run without UI (optional, remove to see browser window)
- `--disable-gpu` - Disable GPU acceleration (helpful on some systems)
- `--no-sandbox` - Disable sandbox (use only in trusted environments)

### Troubleshooting

**Cannot connect:**
- Check port 9222 not in use: `lsof -i :9222` (Mac/Linux) or `netstat -ano | findstr :9222` (Windows)
- Ensure Chrome installed and in PATH
- Try non-headless mode (remove `--headless`)

**Page won't load:**
- Check URL correct (http:// or https://)
- Verify network connectivity
- Check for HTTPS certificate errors

See `references/setup-guide.md` for detailed troubleshooting.

---

## Workflow Phases

### Phase 0: Setup & Connection
- Connect to Chrome debug mode
- List available pages
- Select target page or create new
- Define debugging scope

### Phase 1: Initial Inspection
- Take baseline snapshot (page structure, a11y tree)
- List console messages (errors, warnings)
- List network requests (failed, slow)
- Select debugging path based on findings

### Phase 2A-E: Targeted Debugging
- **2A: Visual** - Screenshots, responsive testing, layout verification
- **2B: Network** - Request analysis, CORS, timing, cURL reproduction
- **2C: Performance** - Trace recording, Core Web Vitals, bottlenecks
- **2D: Form** - Validation testing, error states, keyboard navigation
- **2E: Console** - Error tracing, stack traces, source correlation

### Phase 3: Deep Investigation
- Custom script execution
- State comparisons
- Edge case testing
- Detailed reproduction steps

### Phase 4: Documentation & Cleanup
- Generate bug reports
- Save artifacts (screenshots, traces, logs)
- Create summary report
- Clean up resources

---

## What You Get

### 1. Evidence Package
```
chrome-debug-artifacts/
├── screenshots/
│   ├── homepage-desktop-1920px.png
│   ├── homepage-mobile-375px.png
│   └── form-error-state.png
├── traces/
│   └── performance-trace-2026-02-07.json.gz
├── network/
│   ├── failed-requests.txt
│   └── curl-reproduction.sh
└── reports/
    ├── visual-regression-report.md
    └── performance-report.md
```

### 2. Bug Reports (GitHub-ready)
```markdown
# Bug Report: CORS Error on API Endpoint

**Severity:** High
**Type:** Network

## Reproduction Steps
1. Navigate to checkout page
2. Fill form and click submit
3. Observe network error in console

## Evidence
- Network trace: network/failed-requests.txt
- cURL reproduction: `curl -X POST 'https://api.example.com/checkout' ...`

## Recommended Fix
Add CORS headers to API response:
Access-Control-Allow-Origin: https://example.com
```

### 3. Performance Report
```markdown
# Performance Report

**Page:** https://example.com
**Date:** 2026-02-07

## Core Web Vitals
- **LCP:** 1.8s (Good)
- **CLS:** 0.05 (Good)
- **FID:** 85ms (Good)

## Recommendations
- [ ] Optimize hero image (2.4MB → 400KB)
- [ ] Defer non-critical JavaScript
- [ ] Implement code splitting
```

### 4. Visual Comparison
```markdown
# Visual Regression Test

**Change:** Button styling update

## Before
![Before](before.png)

## After
![After](after.png)

## Approval
✅ Change approved - no regressions
```

---

## Operating Principles

1. **Visual Verification First** - Snapshot (text) before screenshot (visual); faster, a11y-aware, searchable
2. **Non-Destructive** - Read-only by default; never submit forms or modify state without approval
3. **Evidence-Based** - Save all artifacts (screenshots, traces, logs) for every finding
4. **Real Browser Testing** - Test in actual Chrome, not assumptions; use headless for efficiency
5. **Resource Aware** - Clean up traces, manage screenshots, close unused pages

---

## File Structure

```
chrome-debug/
├── SKILL.md                          # Main skill workflow (8KB)
├── README.md                         # This file
├── references/                       # 10 detailed guides
│   ├── 00-index.md                   # Reference directory
│   ├── chrome-devtools-api.md        # Complete MCP tool catalog
│   ├── decision-trees.md             # When to use which approach
│   ├── setup-guide.md                # Launch Chrome in debug mode
│   ├── snapshot-vs-screenshot.md     # Visual verification guide
│   ├── network-debugging.md          # Network analysis patterns
│   ├── performance-profiling.md      # Core Web Vitals guide
│   ├── form-testing.md               # Form interaction workflows
│   ├── emulation-profiles.md         # Mobile/responsive testing
│   └── script-evaluation.md          # Custom JavaScript patterns
├── templates/                        # 6 reusable templates
│   ├── visual-regression.md          # Screenshot comparison
│   ├── bug-report.md                 # Evidence-based bug report
│   ├── network-issue.md              # Failed request analysis
│   ├── performance-report.md         # Core Web Vitals report
│   ├── form-testing-checklist.md     # Form validation matrix
│   └── responsive-matrix.md          # Multi-device testing grid
└── examples/                         # 6 complete walkthroughs
    ├── 01-visual-verification.md     # Button styling change
    ├── 02-network-debugging.md       # CORS issue
    ├── 03-performance-audit.md       # Slow page load
    ├── 04-form-testing.md            # Checkout form
    ├── 05-mobile-responsive.md       # Responsive layout
    └── 06-console-errors.md          # JavaScript errors
```

---

## Requirements

- **Chrome** - Latest version recommended
- **Remote Debugging** - Chrome launched with `--remote-debugging-port=9222`
- **Network Access** - For pages being tested

---

## Related Skills

- **[accessibility-audit](../accessibility-audit/README.md)** - Use for WCAG compliance checks and screen reader testing
- Combine chrome-debug (visual verification) with accessibility-audit (a11y compliance) for comprehensive UI testing

---

## Tips & Best Practices

### When to Use Snapshot vs Screenshot

**Use Snapshot when:**
- Checking page structure or content
- Finding elements by text or role
- Testing accessibility tree
- Fast verification needed

**Use Screenshot when:**
- Visual appearance matters (colors, layout, styling)
- Creating evidence for bug reports
- Comparing before/after states
- Responsive design verification

### Network Debugging Tips

- Filter by `resourceType` to narrow down (XHR, Fetch, Script, Document)
- Check timing breakdown to identify bottlenecks
- Use cURL reproduction to isolate client vs server issues
- Correlate with console errors for full picture

### Performance Testing Tips

- Start trace before navigation for full capture
- Reload page during trace for accurate LCP
- Export trace for manual DevTools analysis
- Focus on Core Web Vitals first (LCP, CLS, FID)

### Form Testing Tips

- Take snapshot first to map field UIDs
- Test validation on blur, not just submit
- Check both client-side and server-side validation
- Test keyboard navigation (Tab, Enter, Escape)

---

## License

MIT License

---

**Made with 🔍 for comprehensive browser debugging**
