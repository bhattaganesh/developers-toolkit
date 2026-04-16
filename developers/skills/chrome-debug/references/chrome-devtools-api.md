# Chrome DevTools MCP API Reference

Complete catalog of all Chrome DevTools MCP tools with parameters and examples.

---

## Page Management

### list_pages

List all open pages/tabs in Chrome.

**Parameters:** None

**Returns:**
```json
[
  {
    "id": 1,
    "title": "Example Page",
    "url": "https://example.com",
    "type": "page"
  }
]
```

**Example:**
```javascript
list_pages()
```

---

### select_page

Select a page as context for future operations.

**Parameters:**
- `pageId` (number, required): Page ID from list_pages
- `bringToFront` (boolean, optional): Focus the page

**Example:**
```javascript
select_page({ pageId: 1, bringToFront: true })
```

---

### new_page

Create a new page/tab.

**Parameters:**
- `url` (string, required): URL to load
- `background` (boolean, optional): Open in background (default: false)
- `timeout` (number, optional): Max wait time in ms

**Example:**
```javascript
new_page({
  url: "https://example.com",
  background: false,
  timeout: 30000
})
```

---

### close_page

Close a page by ID. Cannot close last page.

**Parameters:**
- `pageId` (number, required): Page ID to close

**Example:**
```javascript
close_page({ pageId: 2 })
```

---

### navigate_page

Navigate currently selected page.

**Parameters:**
- `type` (string, optional): "url", "back", "forward", "reload"
- `url` (string, required for type="url"): Target URL
- `ignoreCache` (boolean, optional): Ignore cache on reload
- `timeout` (number, optional): Max wait time in ms
- `handleBeforeUnload` (string, optional): "accept" or "decline" for dialogs
- `initScript` (string, optional): JavaScript to run on each new document

**Examples:**
```javascript
# Navigate to URL
navigate_page({ type: "url", url: "https://example.com" })

# Go back
navigate_page({ type: "back" })

# Reload (ignore cache)
navigate_page({ type: "reload", ignoreCache: true })
```

---

### resize_page

Resize page viewport.

**Parameters:**
- `width` (number, required): Width in pixels
- `height` (number, required): Height in pixels

**Example:**
```javascript
resize_page({ width: 375, height: 667 })  # iPhone SE
```

---

## Visual Verification

### take_snapshot

Take text-based snapshot of page (accessibility tree).

**Parameters:**
- `verbose` (boolean, optional): Include full a11y details
- `filePath` (string, optional): Save to file instead of inline

**Returns:**
```
[uid=abc123] button "Submit" [role=button]
[uid=def456] textbox "Email" [role=textbox] [required]
```

**Examples:**
```javascript
# Basic snapshot
take_snapshot()

# Verbose (full a11y tree)
take_snapshot({ verbose: true })

# Save to file
take_snapshot({ filePath: "./snapshot.txt" })
```

---

### take_screenshot

Take visual screenshot.

**Parameters:**
- `fullPage` (boolean, optional): Full page vs viewport (default: false)
- `format` (string, optional): "png", "jpeg", "webp" (default: "png")
- `quality` (number, optional): 0-100 for jpeg/webp (default: 90)
- `uid` (string, optional): Screenshot specific element only
- `filePath` (string, optional): Save to file

**Examples:**
```javascript
# Viewport screenshot (PNG)
take_screenshot()

# Full page (JPEG)
take_screenshot({
  fullPage: true,
  format: "jpeg",
  quality: 85,
  filePath: "./page.jpg"
})

# Element only
take_screenshot({
  uid: "button123",
  format: "png"
})
```

---

## Interaction

### click

Click an element.

**Parameters:**
- `uid` (string, required): Element UID from snapshot
- `dblClick` (boolean, optional): Double click (default: false)
- `includeSnapshot` (boolean, optional): Return snapshot after click

**Example:**
```javascript
click({ uid: "abc123", includeSnapshot: true })
```

---

### fill

Fill input field.

**Parameters:**
- `uid` (string, required): Element UID
- `value` (string, required): Value to fill
- `includeSnapshot` (boolean, optional): Return snapshot after

**Example:**
```javascript
fill({
  uid: "email-field",
  value: "test@example.com",
  includeSnapshot: true
})
```

---

### fill_form

Fill multiple fields at once.

**Parameters:**
- `elements` (array, required): Array of {uid, value} objects
- `includeSnapshot` (boolean, optional): Return snapshot after

**Example:**
```javascript
fill_form({
  elements: [
    { uid: "email", value: "test@example.com" },
    { uid: "pwd", value: "Password123" }
  ],
  includeSnapshot: true
})
```

---

### hover

Hover over element.

**Parameters:**
- `uid` (string, required): Element UID
- `includeSnapshot` (boolean, optional): Return snapshot after

**Example:**
```javascript
hover({ uid: "menu-item", includeSnapshot: true })
```

---

### drag

Drag element onto another element.

**Parameters:**
- `from_uid` (string, required): Element to drag
- `to_uid` (string, required): Drop target
- `includeSnapshot` (boolean, optional): Return snapshot after

**Example:**
```javascript
drag({
  from_uid: "draggable",
  to_uid: "dropzone",
  includeSnapshot: true
})
```

---

### press_key

Press keyboard key or combination.

**Parameters:**
- `key` (string, required): Key or combination (e.g., "Enter", "Control+A")
- `includeSnapshot` (boolean, optional): Return snapshot after

**Examples:**
```javascript
# Single key
press_key({ key: "Enter" })

# Tab navigation
press_key({ key: "Tab" })

# Keyboard shortcut
press_key({ key: "Control+A" })  # Select all
press_key({ key: "Control++" })  # Zoom in
press_key({ key: "Control+Shift+R" })  # Hard reload
```

---

### upload_file

Upload file via file input.

**Parameters:**
- `uid` (string, required): File input element UID
- `filePath` (string, required): Local file path to upload
- `includeSnapshot` (boolean, optional): Return snapshot after

**Example:**
```javascript
upload_file({
  uid: "file-input",
  filePath: "/path/to/file.pdf",
  includeSnapshot: true
})
```

---

### wait_for

Wait for text to appear on page.

**Parameters:**
- `text` (string, required): Text to wait for
- `timeout` (number, optional): Max wait time in ms (default: system default)

**Example:**
```javascript
wait_for({ text: "Success!", timeout: 10000 })
```

---

### handle_dialog

Handle browser dialog (alert, confirm, prompt).

**Parameters:**
- `action` (string, required): "accept" or "dismiss"
- `promptText` (string, optional): Text to enter for prompt dialogs

**Examples:**
```javascript
# Accept alert
handle_dialog({ action: "accept" })

# Dismiss confirm
handle_dialog({ action: "dismiss" })

# Answer prompt
handle_dialog({
  action: "accept",
  promptText: "My answer"
})
```

---

## Emulation

### emulate

Emulate device features.

**Parameters:**
- `viewport` (object, optional): { width, height, deviceScaleFactor, hasTouch, isMobile, isLandscape }
- `networkConditions` (string, optional): "No emulation", "Offline", "Slow 3G", "Fast 3G", "Slow 4G", "Fast 4G"
- `cpuThrottlingRate` (number, optional): 1-20 (1 = no throttling)
- `geolocation` (object, optional): { latitude, longitude } or null
- `colorScheme` (string, optional): "dark", "light", "auto"
- `userAgent` (string, optional): Custom user agent or null

**Examples:**
```javascript
# iPhone 12
emulate({
  viewport: {
    width: 390,
    height: 844,
    deviceScaleFactor: 3,
    hasTouch: true,
    isMobile: true
  }
})

# Slow 3G network
emulate({
  networkConditions: "Slow 3G",
  cpuThrottlingRate: 4
})

# Dark mode
emulate({ colorScheme: "dark" })

# Geolocation
emulate({
  geolocation: {
    latitude: 37.7749,
    longitude: -122.4194
  }
})
```

---

## Network

### list_network_requests

List network requests since last navigation.

**Parameters:**
- `resourceTypes` (array, optional): Filter by types (e.g., ["xhr", "fetch"])
- `pageSize` (number, optional): Max requests to return
- `pageIdx` (number, optional): Page number (0-based) for pagination
- `includePreservedRequests` (boolean, optional): Include last 3 navigations

**Resource Types:**
"document", "stylesheet", "image", "media", "font", "script", "texttrack", "xhr", "fetch", "prefetch", "eventsource", "websocket", "manifest", "signedexchange", "ping", "cspviolationreport", "preflight", "fedcm", "other"

**Examples:**
```javascript
# All requests
list_network_requests()

# API calls only
list_network_requests({
  resourceTypes: ["xhr", "fetch"]
})

# Paginated (first 50)
list_network_requests({
  pageSize: 50,
  pageIdx: 0
})
```

---

### get_network_request

Get detailed network request info.

**Parameters:**
- `reqid` (number, optional): Request ID (if omitted, gets currently selected request)
- `requestFilePath` (string, optional): Save request body to file
- `responseFilePath` (string, optional): Save response body to file

**Returns:**
```json
{
  "reqid": 123,
  "url": "https://api.example.com/users",
  "method": "POST",
  "status": 200,
  "resourceType": "fetch",
  "requestHeaders": { ... },
  "responseHeaders": { ... },
  "requestBody": "...",
  "responseBody": "...",
  "timing": {
    "blocked": 2,
    "dns": 50,
    "connect": 100,
    "ssl": 150,
    "send": 5,
    "wait": 800,
    "receive": 100,
    "total": 1207
  }
}
```

**Example:**
```javascript
get_network_request({
  reqid: 123,
  responseFilePath: "./response.json"
})
```

---

## Console

### list_console_messages

List console messages.

**Parameters:**
- `types` (array, optional): Filter by types
- `pageSize` (number, optional): Max messages
- `pageIdx` (number, optional): Page number
- `includePreservedMessages` (boolean, optional): Include last 3 navigations

**Message Types:**
"log", "debug", "info", "error", "warn", "dir", "dirxml", "table", "trace", "clear", "startGroup", "startGroupCollapsed", "endGroup", "assert", "profile", "profileEnd", "count", "timeEnd", "verbose", "issue"

**Examples:**
```javascript
# All messages
list_console_messages()

# Errors only
list_console_messages({ types: ["error"] })

# Errors and warnings
list_console_messages({ types: ["error", "warn"] })
```

---

### get_console_message

Get detailed console message.

**Parameters:**
- `msgid` (number, required): Message ID from list_console_messages

**Returns:**
```json
{
  "msgid": 456,
  "type": "error",
  "level": "error",
  "text": "Uncaught TypeError: Cannot read property 'foo' of undefined",
  "source": "javascript",
  "url": "https://example.com/app.js",
  "line": 42,
  "column": 10,
  "stackTrace": [ ... ]
}
```

**Example:**
```javascript
get_console_message({ msgid: 456 })
```

---

## Performance

### performance_start_trace

Start performance trace recording.

**Parameters:**
- `reload` (boolean, required): Reload page when trace starts
- `autoStop` (boolean, required): Auto-stop after page load
- `filePath` (string, optional): Save trace to file

**Example:**
```javascript
# Auto trace (reload + auto-stop)
performance_start_trace({
  reload: true,
  autoStop: true,
  filePath: "./trace.json.gz"
})

# Manual trace (for user interactions)
performance_start_trace({
  reload: false,
  autoStop: false
})
```

---

### performance_stop_trace

Stop performance trace.

**Parameters:**
- `filePath` (string, optional): Save trace to file

**Returns:** Trace results with Core Web Vitals and available insights

**Example:**
```javascript
performance_stop_trace({
  filePath: "./trace-2026-02-07.json.gz"
})
```

---

### performance_analyze_insight

Get detailed insight from trace.

**Parameters:**
- `insightSetId` (string, required): Insight set ID from trace results
- `insightName` (string, required): Insight name (e.g., "LCPBreakdown")

**Available Insights:**
- DocumentLatency
- LCPBreakdown
- LayoutShift
- RenderBlocking
- SlowCSSSelector

**Example:**
```javascript
performance_analyze_insight({
  insightSetId: "abc123",
  insightName: "LCPBreakdown"
})
```

---

## Script Execution

### evaluate_script

Execute JavaScript in page context.

**Parameters:**
- `function` (string, required): JavaScript function declaration
- `args` (array, optional): Array of {uid} objects to pass as arguments

**Returns:** JSON-serializable return value

**Important:** Return values must be JSON-serializable (strings, numbers, booleans, arrays, plain objects). Cannot return functions, DOM elements, Promises.

**Examples:**
```javascript
# No arguments
evaluate_script({
  function: "() => { return document.title; }"
})

# With element argument
evaluate_script({
  function: "(el) => { return { text: el.innerText, disabled: el.disabled }; }",
  args: [{ uid: "button123" }]
})

# Multiple returns
evaluate_script({
  function: "() => { return { width: window.innerWidth, height: window.innerHeight, userAgent: navigator.userAgent }; }"
})
```

---

## Tool Combinations

### Common Workflows

**Visual Regression:**
```
take_snapshot() → take_screenshot() → compare
```

**Form Testing:**
```
take_snapshot() → fill_form() → take_snapshot() → take_screenshot()
```

**Network Debugging:**
```
navigate_page() → list_network_requests() → get_network_request()
```

**Performance Analysis:**
```
performance_start_trace() → [interactions] → performance_stop_trace() → performance_analyze_insight()
```

**Responsive Testing:**
```
for (const width of [375, 768, 1920]) {
  resize_page() → take_screenshot()
}
```

---

## See Also

- [decision-trees.md](./decision-trees.md) - When to use which tool
- [snapshot-vs-screenshot.md](./snapshot-vs-screenshot.md) - Snapshot vs screenshot guide
- [network-debugging.md](./network-debugging.md) - Network debugging patterns
- [performance-profiling.md](./performance-profiling.md) - Performance analysis guide
