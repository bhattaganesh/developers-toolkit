# Example: CORS Error Investigation

**Scenario:** API call failing with CORS error in browser console. User cannot submit checkout form.

**Page:** https://example.com/checkout
**API:** https://api.example.com/orders

---

## Phase 0: Setup

```
list_pages()
select_page({ pageId: 1 })
navigate_page({ type: "url", url: "https://example.com/checkout" })
```

---

## Phase 1: Initial Inspection

**Console check:**
```
list_console_messages({ types: ["error"] })

Output:
[msgid=1] error "Access to fetch at 'https://api.example.com/orders' from origin 'https://example.com' has been blocked by CORS Capability"
```

**Network requests:**
```
list_network_requests({ resourceTypes: ["xhr", "fetch"] })

Output:
[reqid=123] POST https://api.example.com/orders [status=0, failed]
```

---

## Phase 2B: Network Debugging

**Get failed request details:**
```
get_network_request({
  reqid: 123,
  responseFilePath: "./response.txt"
})

Output:
{
  "url": "https://api.example.com/orders",
  "method": "POST",
  "status": 0,
  "resourceType": "fetch",
  "requestHeaders": {
    "Origin": "https://example.com",
    "Content-Type": "application/json"
  },
  "responseHeaders": {
    # Empty - CORS preflight failed
  },
  "timing": {
    "total": 0,  # Failed immediately
    "blocked": 0
  }
}
```

**Analysis:**
- Request sent from `https://example.com`
- Target: `https://api.example.com`
- **Missing:** `Access-Control-Allow-Origin` header in response

---

## Phase 3: Targeted Investigation

**Generate cURL reproduction:**
```bash
curl -X POST 'https://api.example.com/orders' \
  -H 'Origin: https://example.com' \
  -H 'Content-Type: application/json' \
  -d '{"item":"Widget","quantity":1}' \
  -v

# Result: 200 OK from server
# But no CORS headers in response!
```

**Root Cause:**
Server accepts request but doesn't include CORS headers, so browser blocks it.

---

## Evidence Collected

1. **Console error:** CORS Capability blocked fetch
2. **Network request:** Status 0 (failed immediately)
3. **Headers:** No `Access-Control-Allow-Origin` in response
4. **cURL test:** Server responds successfully (not a server error)

---

## Findings

**Issue:** CORS headers missing from API response

**Required Headers:**
```
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

**Impact:**
- Users cannot complete checkout
- Severity: **Critical**

---

## Outcome

**Bug Report Created:** network-issue-cors.md

**Recommended Fix:**
Add CORS headers to API server:
```python
# Example for Express.js
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'https://example.com');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});
```

**Workaround:** None available (client-side cannot fix CORS)

---

## Takeaways

1. **Check console first** - CORS errors show clearly in console
2. **Network status 0** - Indicates request blocked before completion
3. **cURL test** - Isolates browser vs server issue
4. **Origin header** - Must match `Access-Control-Allow-Origin` exactly

