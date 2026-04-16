# Network Debugging Guide

Comprehensive guide to debugging network requests with Chrome DevTools MCP.

---

## Quick Reference

**Common Tasks:**
- List all requests: `list_network_requests()`
- Filter API calls: `list_network_requests({ resourceTypes: ["xhr", "fetch"] })`
- Get request details: `get_network_request({ reqid: 123 })`
- Find failed requests: Filter by `status >= 400`
- Analyze timing: Check `timing` breakdown in request details

---

## Resource Types

### Available Types

| Type | Description | Examples |
|------|-------------|----------|
| `document` | HTML pages | index.html, page.html |
| `stylesheet` | CSS files | styles.css, theme.css |
| `image` | Images | logo.png, photo.jpg |
| `media` | Video/Audio | video.mp4, audio.mp3 |
| `font` | Web fonts | font.woff2, icons.ttf |
| `script` | JavaScript | app.js, bundle.js |
| `xhr` | XMLHttpRequest | AJAX calls (legacy) |
| `fetch` | Fetch API | Modern API calls |
| `websocket` | WebSocket | Real-time connections |
| `other` | Other types | Manifests, etc. |

### Filtering Examples

```javascript
# API calls only
list_network_requests({ resourceTypes: ["xhr", "fetch"] })

# Images only
list_network_requests({ resourceTypes: ["image"] })

# Assets (CSS + JS)
list_network_requests({ resourceTypes: ["stylesheet", "script"] })

# All except images
# (Filter manually: exclude type === "image")
```

---

## Request Analysis

### Status Codes

**Success (2xx):**
- 200 OK - Request succeeded
- 201 Created - Resource created
- 204 No Content - Success, no response body

**Redirect (3xx):**
- 301 Moved Permanently
- 302 Found (temporary redirect)
- 304 Not Modified (cached)

**Client Error (4xx):**
- 400 Bad Request - Invalid request
- 401 Unauthorized - Authentication required
- 403 Forbidden - Access denied
- 404 Not Found - Resource doesn't exist
- 429 Too Many Requests - Rate limited

**Server Error (5xx):**
- 500 Internal Server Error
- 502 Bad Gateway
- 503 Service Unavailable
- 504 Gateway Timeout

### Finding Failed Requests

```javascript
# Get all requests
const requests = list_network_requests();

# Filter failures
const failed = requests.filter(r => r.status >= 400);

# Get details for each
for (const req of failed) {
  const details = get_network_request({ reqid: req.reqid });
  console.log(`Failed: ${details.url} (${details.status})`);
}
```

---

## CORS Debugging

### What is CORS?

Cross-Origin Resource Sharing - browser security that restricts cross-origin HTTP requests.

### Common CORS Errors

**Error:** "No 'Access-Control-Allow-Origin' header present"
**Cause:** Server doesn't send CORS headers
**Fix:** Add header on server:
```
Access-Control-Allow-Origin: https://yourdomain.com
```

**Error:** "CORS header 'Access-Control-Allow-Origin' does not match"
**Cause:** Origin mismatch
**Fix:** Verify origin matches exactly (including protocol and port)

**Error:** "Preflight request failed"
**Cause:** OPTIONS request blocked or wrong headers
**Fix:** Ensure server responds to OPTIONS with:
```
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
```

### CORS Debugging Workflow

```
# 1. List failed requests
list_network_requests({ resourceTypes: ["xhr", "fetch"] })

# 2. Get failed request details
get_network_request({ reqid: <id> })

# 3. Check response headers
Response Headers:
  Access-Control-Allow-Origin: ?
  Access-Control-Allow-Methods: ?
  Access-Control-Allow-Headers: ?

# 4. Check request headers
Request Headers:
  Origin: https://yourdomain.com
  # Should match allowed origin

# 5. Generate cURL for testing
curl -X POST 'https://api.example.com/endpoint' \
  -H 'Origin: https://yourdomain.com' \
  -H 'Content-Type: application/json' \
  -v
```

---

## Timing Analysis

### Timing Breakdown

**Phases:**
1. **Blocked** - Queued, waiting for available connection
2. **DNS** - DNS lookup time
3. **Connect** - TCP connection establishment
4. **SSL** - TLS/SSL handshake (HTTPS only)
5. **Send** - Sending request to server
6. **Wait** - Waiting for server response (TTFB)
7. **Receive** - Downloading response

**Total = Blocked + DNS + Connect + SSL + Send + Wait + Receive**

### Identifying Bottlenecks

```
Timing example:
{
  blocked: 2ms,     # Queue time (minimal)
  dns: 50ms,        # DNS lookup (can cache)
  connect: 100ms,   # TCP connection (can reuse)
  ssl: 150ms,       # TLS handshake (can reuse)
  send: 5ms,        # Send time (minimal)
  wait: 800ms,      # ⚠️ Server processing (HIGH)
  receive: 100ms,   # Download time
  total: 1207ms
}

Bottleneck: wait (800ms)
Issue: Server slow to process request
Solutions:
- Optimize server-side code
- Add caching
- Use CDN
- Reduce database queries
```

### Timing Thresholds

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| DNS | <50ms | 50-150ms | >150ms |
| Connect | <100ms | 100-300ms | >300ms |
| Wait (TTFB) | <200ms | 200-500ms | >500ms |
| Receive | <100ms | 100-300ms | >300ms |
| **Total** | **<500ms** | **500ms-1s** | **>1s** |

---

## Authentication Debugging

### Common Auth Headers

**Request Headers:**
```
Authorization: Bearer <token>
Authorization: Basic <base64-credentials>
Cookie: session_id=<session>
X-API-Key: <api-key>
```

**Response Headers:**
```
WWW-Authenticate: Bearer realm="API"
Set-Cookie: session_id=<session>; HttpOnly; Secure
```

### Auth Failure Workflow

```
# 1. Get failed auth request
get_network_request({ reqid: <id> })

# 2. Check request headers
Request Headers:
  Authorization: Bearer <token>
  # Is token present? Correct format?

# 3. Check response
Status: 401 Unauthorized

Response Headers:
  WWW-Authenticate: Bearer realm="API", error="invalid_token"

Response Body:
  {"error": "Token expired"}

# 4. Solutions
- Refresh token
- Re-authenticate
- Check token format (Bearer vs Basic)
- Verify token not expired
```

---

## Request/Response Bodies

### Saving Bodies to Files

```javascript
# Save large request/response to files
get_network_request({
  reqid: 123,
  requestFilePath: "./request-body.json",
  responseFilePath: "./response-body.json"
})

# Bodies saved to files instead of inline
# Useful for large payloads (>1MB)
```

### JSON Parsing

```javascript
# Response body is JSON string
const details = get_network_request({ reqid: 123 });
const data = JSON.parse(details.responseBody);

# Now can access data:
console.log(data.error);
console.log(data.message);
```

---

## cURL Reproduction

### Generating cURL Commands

```bash
# From network request details:
# Method: POST
# URL: https://api.example.com/users
# Headers: Content-Type: application/json, Authorization: Bearer token123
# Body: {"name": "John"}

# Generate cURL:
curl -X POST 'https://api.example.com/users' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer token123' \
  -d '{"name": "John"}'

# Test in terminal to isolate browser vs server issues
```

### cURL Testing Workflow

```
# 1. Generate cURL from failed request
# 2. Run in terminal
# 3. Compare results:

Browser: 401 Unauthorized
cURL: 200 OK

# Conclusion: Browser issue (wrong token, CORS, etc.)

Browser: 401 Unauthorized
cURL: 401 Unauthorized

# Conclusion: Server issue (check server logs)
```

---

## Pagination

### Handling Many Requests

```javascript
# Get first page (50 requests)
const page1 = list_network_requests({
  resourceTypes: ["xhr", "fetch"],
  pageSize: 50,
  pageIdx: 0
});

# Get second page (next 50)
const page2 = list_network_requests({
  resourceTypes: ["xhr", "fetch"],
  pageSize: 50,
  pageIdx: 1
});

# Continue until no more results
```

---

## Common Patterns

### Pattern 1: Find Failed API Calls

```javascript
# List all XHR/Fetch requests
const requests = list_network_requests({
  resourceTypes: ["xhr", "fetch"]
});

# Filter failures
const failed = requests.filter(r => r.status >= 400);

# Analyze each
for (const req of failed) {
  const details = get_network_request({ reqid: req.reqid });

  console.log(`URL: ${details.url}`);
  console.log(`Status: ${details.status}`);
  console.log(`Error: ${details.responseBody}`);
}
```

### Pattern 2: Slow Request Analysis

```javascript
# Find requests >1s
const slow = requests.filter(r => r.timing?.total > 1000);

# Analyze timing
for (const req of slow) {
  const details = get_network_request({ reqid: req.reqid });

  console.log(`URL: ${details.url}`);
  console.log(`Total: ${details.timing.total}ms`);
  console.log(`Wait: ${details.timing.wait}ms`);  # Server time
  console.log(`Receive: ${details.timing.receive}ms`);  # Download time
}
```

### Pattern 3: CORS Error Investigation

```javascript
# Find CORS errors in console
list_console_messages({ types: ["error"] });
# Look for "CORS" in message text

# Get failed request
const details = get_network_request({ reqid: <id> });

# Check headers
console.log("Request Origin:", details.requestHeaders.Origin);
console.log("Response CORS:", details.responseHeaders["Access-Control-Allow-Origin"]);

# Compare - should match
```

---

## See Also

- [chrome-devtools-api.md](./chrome-devtools-api.md) - Network tool reference
- [decision-trees.md](./decision-trees.md) - Filtering strategies
- [templates/network-issue.md](../templates/network-issue.md) - Report template
