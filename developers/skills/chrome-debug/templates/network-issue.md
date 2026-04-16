# Network Issue Report

**Request:** [METHOD] [URL]
**Status:** [Status Code]
**Date:** [YYYY-MM-DD]
**Type:** [XHR / Fetch / Document / Script / Other]

---

## Request Summary

**URL:** [Full URL]
**Method:** [GET / POST / PUT / DELETE / etc.]
**Status Code:** [200 / 404 / 500 / etc.]
**Status Text:** [OK / Not Found / Internal Server Error / etc.]
**Resource Type:** [XHR / Fetch / Document / Script / Stylesheet / etc.]

---

## Request Headers

```
[Paste request headers]

Example:
Accept: application/json
Authorization: Bearer <token>
Content-Type: application/json
Origin: https://example.com
```

---

## Response Headers

```
[Paste response headers]

Example:
Access-Control-Allow-Origin: *
Content-Type: application/json
Set-Cookie: session_id=<id>
```

---

## Timing Breakdown

| Phase | Time (ms) | Notes |
|-------|-----------|-------|
| Blocked | [ms] | Queue/waiting time |
| DNS | [ms] | DNS lookup |
| Connect | [ms] | TCP connection |
| SSL | [ms] | TLS handshake |
| Send | [ms] | Sending request |
| Wait | [ms] | Server processing (TTFB) |
| Receive | [ms] | Downloading response |
| **Total** | **[ms]** | **End-to-end time** |

**Bottleneck:** [Which phase took longest]

---

## Request Body

```json
[Paste request body if applicable]
```

---

## Response Body

```json
[Paste response body - first 500 chars or full if short]
```

**Full Response:** [path/to/response.json]

---

## Issue Analysis

### Problem Type
- [ ] CORS Error
- [ ] Authentication Failure
- [ ] Timeout
- [ ] 404 Not Found
- [ ] 500 Server Error
- [ ] Rate Limiting
- [ ] Network Disconnection
- [ ] Other: [specify]

### Root Cause
[Detailed analysis of what's causing the issue]

### CORS Details (if applicable)
- **Request Origin:** [origin from request headers]
- **Allowed Origin:** [from Access-Control-Allow-Origin response header]
- **Match:** [Yes / No]
- **Preflight:** [Required / Not Required / Failed]

### Authentication Details (if applicable)
- **Auth Type:** [Bearer / Basic / API Key / Cookie]
- **Token Present:** [Yes / No]
- **Token Format:** [Correct / Incorrect]
- **Error Message:** [from response]

---

## cURL Reproduction

```bash
curl -X [METHOD] '[URL]' \
  -H 'Header-1: value1' \
  -H 'Header-2: value2' \
  [-d 'request body']

Example:
curl -X POST 'https://api.example.com/users' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer token123' \
  -d '{"name":"John Doe"}'
```

**cURL Result:** [Describe what happens when running cURL command]

---

## Console Errors

```
[Related console errors that correlate with this network issue]
```

---

## Recommended Fix

### Short Term (Workaround)
[Immediate solution or workaround if available]

### Long Term (Proper Fix)
[Correct fix to resolve the issue permanently]

**Example Fixes:**

**CORS:** Add server-side header:
```
Access-Control-Allow-Origin: https://yourdomain.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

**Authentication:** Verify token format:
```
Authorization: Bearer <valid-token>
```

**Timeout:** Increase timeout or optimize server:
```javascript
fetch(url, { timeout: 10000 })
```

---

## Impact

**Severity:** [Critical / High / Medium / Low]
**User Impact:** [How this affects users]
**Frequency:** [Always / Often / Sometimes / Rarely]

---

## Status

**Status:** [Open / Investigating / Fixed / Won't Fix]
**Assigned To:** [Name]
**Fixed In:** [PR/Version number]
