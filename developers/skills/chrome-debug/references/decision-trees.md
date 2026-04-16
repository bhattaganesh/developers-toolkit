# Decision Trees for Chrome Debugging

Quick decision guides for common debugging scenarios.

---

## 1. Snapshot vs Screenshot

**When to use which visualization method?**

```
Need to verify page state?
│
├─ Need text content, structure, or a11y tree
│  → use take_snapshot
│  ✓ Fast (text-based)
│  ✓ Searchable
│  ✓ Shows accessibility tree
│  ✓ Includes UIDs for element reference
│  ✗ No visual appearance
│
├─ Need visual appearance, layout, or styling
│  → use take_screenshot
│  ✓ Visual evidence
│  ✓ Shows actual rendered appearance
│  ✓ Good for bug reports
│  ✗ Slower
│  ✗ Larger files
│
└─ Need both content and appearance
   → use take_snapshot FIRST, then screenshot if needed
   (Snapshot is faster - only screenshot when necessary)
```

**Examples:**

| Scenario | Use |
|----------|-----|
| Find element by text | Snapshot |
| Check if error message displayed | Snapshot |
| Verify button color changed | Screenshot |
| Responsive layout testing | Screenshot |
| Accessibility tree inspection | Snapshot (verbose mode) |
| Before/after visual comparison | Screenshot |

---

## 2. Debugging Path Selection

**What type of debugging do I need?**

```
What's the problem?
│
├─ Visual issue (layout wrong, styling broken, UI glitch)
│  → Phase 2A: Visual Debugging
│  Tools: take_snapshot, take_screenshot, emulate, resize_page
│
├─ Network issue (requests failing, CORS, slow API)
│  → Phase 2B: Network Debugging
│  Tools: list_network_requests, get_network_request
│
├─ Performance issue (slow load, high CLS, poor LCP)
│  → Phase 2C: Performance Analysis
│  Tools: performance_start_trace, performance_stop_trace, performance_analyze_insight
│
├─ Form issue (validation broken, fields not working)
│  → Phase 2D: Form Testing
│  Tools: take_snapshot, fill, fill_form, press_key
│
└─ JavaScript error (console errors, exceptions)
   → Phase 2E: Console Investigation
   Tools: list_console_messages, get_console_message
```

**Multiple issues?**
- Prioritize by severity (Critical → High → Medium → Low)
- Start with Phase 1 (Initial Inspection) to identify all issues
- Address one issue at a time

---

## 3. Mobile Testing Approach

**How to test on mobile devices?**

```
Need to test mobile?
│
├─ Quick viewport check only
│  → use resize_page
│  ✓ Simple, fast
│  ✗ No touch events
│  ✗ No device-specific behavior
│
│  resize_page(width=375, height=812)  # iPhone 12
│
├─ Device-specific testing
│  → use emulate with viewport + touch
│  ✓ Touch events enabled
│  ✓ Mobile user agent
│  ✓ Device pixel ratio
│  ✗ More setup required
│
│  emulate({
│    viewport: { width: 375, height: 812, deviceScaleFactor: 3, hasTouch: true, isMobile: true },
│    userAgent: "Mozilla/5.0 (iPhone; ...)"
│  })
│
└─ Full multi-device audit
   → use emulate for each device + take screenshots
   ✓ Complete coverage
   ✓ Screenshot evidence per device
   ✗ Time consuming

   For each device in [iPhone SE, iPhone 12, iPad, Desktop]:
     - emulate device
     - take screenshot
     - save to responsive-matrix
```

**Common Breakpoints:**

| Device | Width | Height | Scale | Use Case |
|--------|-------|--------|-------|----------|
| iPhone SE | 375px | 667px | 2x | Smallest mobile |
| iPhone 12 | 390px | 844px | 3x | Modern mobile |
| iPad | 768px | 1024px | 2x | Tablet |
| Laptop | 1366px | 768px | 1x | Small desktop |
| Desktop | 1920px | 1080px | 1x | Standard desktop |

---

## 4. Network Request Filtering

**How to find the right network requests?**

```
Looking for specific requests?
│
├─ By type
│  → use resourceType filter
│
│  list_network_requests({ resourceTypes: ["xhr", "fetch"] })  # API calls
│  list_network_requests({ resourceTypes: ["script"] })        # JavaScript
│  list_network_requests({ resourceTypes: ["document"] })      # Page loads
│
├─ By status
│  → filter response by status code
│
│  Failures: status >= 400
│  Redirects: status >= 300 && status < 400
│  Success: status >= 200 && status < 300
│
├─ By timing
│  → filter by total time
│
│  Slow: timing.total > 1000  # >1 second
│  Very slow: timing.total > 3000  # >3 seconds
│
└─ By URL pattern
   → use pageSize + pageIdx for pagination

   Get first 50: pageSize=50, pageIdx=0
   Get next 50: pageSize=50, pageIdx=1
```

**Common Filters:**

```javascript
// Failed API calls
resourceTypes: ["xhr", "fetch"]
status: >= 400

// Slow images
resourceTypes: ["image"]
timing.total > 1000

// JavaScript errors
resourceTypes: ["script"]
status: >= 400

// All CORS errors
Check response headers: Access-Control-Allow-Origin missing
```

---

## 5. Screenshot Format Selection

**Which image format should I use?**

```
Taking screenshot?
│
├─ Need highest quality (evidence, comparison)
│  → format: "png"
│  ✓ Lossless
│  ✓ Best quality
│  ✗ Large file size
│
├─ Need smaller file size (many screenshots, CI/CD)
│  → format: "jpeg", quality: 85
│  ✓ Much smaller files
│  ✓ Good quality at 85%
│  ✗ Lossy compression
│  ✗ No transparency
│
└─ Need balance (web optimization)
   → format: "webp", quality: 90
   ✓ Smaller than PNG
   ✓ Better quality than JPEG
   ✓ Transparency support
   ✗ Not universally supported
```

**File Size Comparison:**
- PNG: 100% (baseline)
- JPEG 85%: ~30% of PNG size
- WebP 90%: ~50% of PNG size

---

## 6. Performance Trace Workflow

**When to start/stop trace?**

```
Need performance data?
│
├─ Page load performance
│  → start trace with reload: true
│
│  performance_start_trace({ reload: true, autoStop: true })
│  # Automatically stops after page load
│
├─ User interaction performance
│  → start trace, interact, then stop manually
│
│  performance_start_trace({ reload: false, autoStop: false })
│  # Perform interactions (click, scroll, fill forms)
│  performance_stop_trace()
│
└─ Full user journey
   → navigate to start page, start trace, complete journey, stop

   navigate_page("https://example.com/checkout")
   performance_start_trace({ reload: false, autoStop: false })
   # Complete checkout flow
   performance_stop_trace()
```

---

## 7. Form Fill Strategy

**How to fill form fields?**

```
Filling form?
│
├─ Sequential (validate on blur)
│  → use fill for each field
│
│  fill(uid="field1", value="test@example.com")
│  # Validation may trigger on blur
│  fill(uid="field2", value="Password123")
│
├─ Parallel (validate on submit)
│  → use fill_form for all fields
│
│  fill_form([
│    { uid: "field1", value: "test@example.com" },
│    { uid: "field2", value: "Password123" }
│  ])
│
└─ Mixed (some fields need blur events)
   → use fill for fields with blur validation
   → use fill_form for remaining fields
```

---

## 8. Console Error Priority

**Which console errors to investigate first?**

```
Console has errors?
│
├─ Filter by type
│
│  Errors (type: "error")        → Priority 1 (critical)
│  Warnings (type: "warn")       → Priority 2 (investigate)
│  Info (type: "info")           → Priority 3 (review)
│
├─ Filter by frequency
│
│  Repeated errors (count > 10)  → Priority 1 (systemic issue)
│  One-time errors (count: 1)    → Priority 2 (edge case)
│
└─ Filter by source

   Third-party (source: external domain) → Priority 3 (limited control)
   First-party (source: your domain)     → Priority 1 (your code)
```

**Investigation Order:**
1. Errors from your code that repeat
2. Errors from your code that are one-time
3. Warnings from your code
4. Third-party errors (if affecting functionality)

---

## 9. Element Selection Method

**How to reference elements for interaction?**

```
Need to interact with element?
│
├─ Element visible in snapshot
│  → use UID from take_snapshot
│
│  take_snapshot()
│  # Find element in snapshot output
│  click(uid="abc123")
│
├─ Element not in snapshot (dynamic, hidden)
│  → use evaluate_script to find
│
│  evaluate_script("() => {
│    const el = document.querySelector('.dynamic-button');
│    return { uid: el.getAttribute('data-uid') };
│  }")
│
└─ Need custom element properties
   → use evaluate_script with element query

   evaluate_script("() => {
│     const el = document.querySelector('#submit');
│     return {
│       text: el.innerText,
│       disabled: el.disabled,
│       visible: el.offsetParent !== null
│     };
│   }")
```

---

## 10. Error Handling Decision

**What to do when tools fail?**

```
Tool call failed?
│
├─ Page not responding
│  → wait_for or increase timeout
│
│  wait_for({ text: "Expected content", timeout: 10000 })
│
├─ Element not found
│  → take fresh snapshot
│
│  take_snapshot()  # Get updated UIDs
│
├─ Network timeout
│  → check page loaded, retry with longer timeout
│
├─ Dialog blocking
│  → handle dialog first
│
│  handle_dialog({ action: "accept" })
│  # Then retry original operation
│
└─ Script error
   → check return value is JSON-serializable

   ✓ Strings, numbers, booleans, arrays, objects
   ✗ Functions, DOM elements, Promises
```

---

## Quick Reference

| Scenario | Decision | Tool |
|----------|----------|------|
| Check content | Snapshot | take_snapshot |
| Check styling | Screenshot | take_screenshot |
| Mobile test | Device-specific? | emulate or resize_page |
| Find requests | By type | resourceTypes filter |
| Image format | Quality vs size | png, jpeg, webp |
| Form fill | Blur validation? | fill vs fill_form |
| Console errors | Your code first | Filter by source |

---

## See Also

- [chrome-devtools-api.md](./chrome-devtools-api.md) - Tool parameter reference
- [snapshot-vs-screenshot.md](./snapshot-vs-screenshot.md) - Detailed snapshot guide
- [network-debugging.md](./network-debugging.md) - Network filtering examples
