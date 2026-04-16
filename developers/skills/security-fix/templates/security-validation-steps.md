# Security Validation Steps

**Plugin/Theme:** [Name]
**Version:** [X.Y.Z]
**Vulnerability:** [Type - XSS/SQLi/CSRF/etc.]
**Test Date:** [YYYY-MM-DD]
**Tester:** [Name]

---

## Prerequisites

**Environment:**
- WordPress Version: [e.g., 6.4.2]
- PHP Version: [e.g., 8.2]
- Plugin/Theme Version: [e.g., 1.5.1 - WITH FIX APPLIED]
- Test Site: [URL or "Local"]

**Test User Accounts:**
- Admin: username `[admin_user]`, password `[password]`
- Editor: username `[editor_user]`, password `[password]`
- Subscriber: username `[subscriber_user]`, password `[password]`
- Unauthenticated: (logged out)

---

## Test 1: Verify Vulnerability is Fixed

**Goal:** Confirm the original exploit no longer works

**Steps:**
1. [Step 1 from original vulnerability reproduction]
2. [Step 2 from original vulnerability reproduction]
3. [Step 3 from original vulnerability reproduction]

**Expected Result:**
- [ ] Exploit attempt is blocked
- [ ] Appropriate error message shown (e.g., "Unauthorized" or "Invalid security token")
- [ ] No security error logged
- [ ] No malicious code executed

**Actual Result:**
[Document what happened]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 2: Verify Authentication Required

**Goal:** Confirm unauthenticated users cannot access protected functionality

**Steps:**
1. Log out of WordPress (or use incognito browser)
2. Attempt to access the vulnerable endpoint
3. Try with various attack payloads

**Expected Result:**
- [ ] Request returns 401 Unauthorized error
- [ ] No sensitive data disclosed
- [ ] No functionality accessible

**Actual Result:**
[Document what happened]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 3: Verify Authorization Required

**Goal:** Confirm users with insufficient privileges cannot access admin-only functionality

**Test 3a: Subscriber User**
1. Log in as subscriber
2. Attempt to access the vulnerable endpoint
3. Try to perform admin-only actions

**Expected Result:**
- [ ] Request returns 403 Forbidden error
- [ ] Subscriber cannot elevate privileges
- [ ] No admin functionality accessible

**Actual Result:**
[Document what happened]

**Status:** [ ] PASS | [ ] FAIL

**Test 3b: Editor User** (if applicable)
1. Log in as editor
2. Attempt to access the vulnerable endpoint
3. Verify editor can/cannot access based on intended permissions

**Expected Result:**
- [ ] Editor permissions respected (can/cannot access as designed)
- [ ] No privilege escalation possible

**Actual Result:**
[Document what happened]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 4: CSRF Protection Verification

**Goal:** Confirm requests without valid nonce are rejected

**Steps:**
1. Open browser DevTools → Network tab
2. Submit a legitimate request (observe nonce in request)
3. Copy the request as cURL
4. Modify the nonce to invalid value
5. Execute the modified request

**Expected Result:**
- [ ] Request with invalid nonce is rejected (403 error)
- [ ] Request with no nonce is rejected (403 error)
- [ ] Request with expired nonce is rejected (403 error)
- [ ] Only valid nonce is accepted

**Actual Result:**
[Document what happened]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 5: Input Validation Testing

**Goal:** Confirm malicious input is properly validated and sanitized

**Test Payloads:**

### XSS Payloads (if applicable)
- [ ] `<script>alert(1)</script>`
- [ ] `<img src=x onerror=alert(1)>`
- [ ] `javascript:alert(1)`
- [ ] `<svg/onload=alert(1)>`

**Expected:** All payloads sanitized/escaped, no JavaScript execution

### SQL Injection Payloads (if applicable)
- [ ] `' OR '1'='1`
- [ ] `1 UNION SELECT user_login, user_pass FROM wp_users--`
- [ ] `1; DROP TABLE wp_posts--`

**Expected:** All payloads escaped, no SQL injection possible

### Path Traversal Payloads (if applicable)
- [ ] `../../../wp-config.php`
- [ ] `....//....//....//etc/passwd`

**Expected:** Path traversal blocked, cannot access files outside allowed directories

**Actual Results:**
[Document results for each payload category]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 6: Edge Case Testing

**Goal:** Verify fix handles edge cases correctly

**Test Cases:**
1. **Empty Input**
   - Submit request with empty/missing parameters
   - Expected: Graceful error handling, no crash
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

2. **Null Values**
   - Submit request with null values
   - Expected: Handled correctly, no PHP warnings
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

3. **Type Mismatches**
   - Submit string where integer expected, array where string expected
   - Expected: Type validation rejects invalid types
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

4. **Very Long Strings**
   - Submit extremely long string (10,000+ characters)
   - Expected: String truncated or request rejected, no DoS
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

5. **Special Characters**
   - Submit strings with Unicode, emoji, quotes, newlines
   - Expected: Properly escaped/sanitized
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

6. **Boundary Values**
   - Submit -1, 0, MAX_INT for numeric fields
   - Expected: Boundary values handled correctly
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

---

## Test 7: Regression Testing

**Goal:** Confirm fix doesn't break existing functionality

**Functional Tests:**
- [ ] Plugin/theme activates without errors
- [ ] Admin dashboard loads correctly
- [ ] Settings page loads and saves correctly
- [ ] Frontend displays correctly
- [ ] AJAX requests work (with valid nonce/auth)
- [ ] User-facing features work as before
- [ ] Integration with other plugins/themes works

**Technical Checks:**
- [ ] No PHP errors in `debug.log`
- [ ] No JavaScript errors in browser console
- [ ] No database errors
- [ ] Page load times not significantly impacted
- [ ] All existing unit tests pass (if applicable)

**Actual Results:**
[Document any issues found]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 8: Performance Impact

**Goal:** Verify security fix doesn't significantly degrade performance

**Metrics to Check:**
- [ ] Page load time: [Before: X ms | After: Y ms | Delta: Z ms]
- [ ] Database queries: [Before: X | After: Y | Delta: Z]
- [ ] Memory usage: [Before: X MB | After: Y MB | Delta: Z MB]
- [ ] Time to First Byte (TTFB): [Before: X ms | After: Y ms | Delta: Z ms]

**Acceptable Thresholds:**
- Page load time increase: <100ms acceptable
- Database query increase: 0-1 queries acceptable
- Memory usage increase: <1MB acceptable

**Actual Results:**
[Document performance measurements]

**Status:** [ ] PASS | [ ] FAIL

---

## Test 9: Multi-User Scenarios

**Goal:** Verify security fix works correctly with concurrent users

**Scenarios:**
1. **Multiple Users Accessing Protected Resource**
   - Have 3+ users attempt access simultaneously
   - Expected: Each user's permissions checked independently
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

2. **Session Security**
   - Log in as admin, get nonce
   - Log out
   - Attempt to use old nonce
   - Expected: Old nonce rejected after logout
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

3. **Role Changes**
   - Log in as subscriber
   - Admin promotes subscriber to editor (in separate browser)
   - Original session should reflect new permissions on next request
   - Result: [Document]
   - Status: [ ] PASS | [ ] FAIL

---

## Test 10: Multisite-Specific Tests (if applicable)

**Goal:** Verify fix works correctly in multisite environment

**Tests:**
- [ ] Fix works on network admin
- [ ] Fix works on individual sites
- [ ] `switch_to_blog()` properly checks permissions on target blog
- [ ] Super admin permissions properly checked
- [ ] Network-wide capabilities respected

**Actual Results:**
[Document multisite-specific test results]

**Status:** [ ] PASS | [ ] FAIL | [ ] N/A (Not multisite)

---

## Test Summary

| Test # | Test Name | Status | Notes |
|--------|-----------|--------|-------|
| 1 | Vulnerability is Fixed | [ ] PASS / [ ] FAIL | |
| 2 | Authentication Required | [ ] PASS / [ ] FAIL | |
| 3 | Authorization Required | [ ] PASS / [ ] FAIL | |
| 4 | CSRF Protection | [ ] PASS / [ ] FAIL | |
| 5 | Input Validation | [ ] PASS / [ ] FAIL | |
| 6 | Edge Cases | [ ] PASS / [ ] FAIL | |
| 7 | Regression Testing | [ ] PASS / [ ] FAIL | |
| 8 | Performance Impact | [ ] PASS / [ ] FAIL | |
| 9 | Multi-User Scenarios | [ ] PASS / [ ] FAIL | |
| 10 | Multisite (if applicable) | [ ] PASS / [ ] FAIL / [ ] N/A | |

**Overall Result:** [ ] ALL PASS (Ready for release) | [ ] SOME FAILURES (Needs rework)

---

## Issues Found

**Issue 1:** [If any issues were found, document them here]
- Severity: [Critical / High / Medium / Low]
- Description: [What went wrong]
- Steps to reproduce: [How to reproduce the issue]
- Recommendation: [How to fix]

**Issue 2:** [If applicable]
- ...

---

## Sign-off

**Tested By:** [Name]
**Test Date:** [YYYY-MM-DD]
**Test Environment:** [Local / Staging / Production-like]
**Recommendation:** [ ] APPROVE FOR RELEASE | [ ] REQUIRES REWORK

**Notes:**
[Any additional notes or observations]

---

## Appendix: cURL Commands for Testing

### Test 1: Unauthenticated Request (Should FAIL)
```bash
curl -X POST 'https://example.test/wp-admin/admin-ajax.php' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'action=[action_name]&param=[value]'
```

### Test 2: Authenticated Request with Valid Nonce (Should SUCCEED)
```bash
# First get nonce by logging in and inspecting page source/network tab
NONCE="[your_nonce_here]"
COOKIE="wordpress_logged_in_xxx=[your_cookie_here]"

curl -X POST 'https://example.test/wp-admin/admin-ajax.php' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Cookie: $COOKIE" \
  -d "action=[action_name]&nonce=$NONCE&param=[value]"
```

### Test 3: Authenticated Request with Invalid Nonce (Should FAIL)
```bash
curl -X POST 'https://example.test/wp-admin/admin-ajax.php' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Cookie: $COOKIE" \
  -d "action=[action_name]&nonce=invalid_nonce&param=[value]"
```

### Test 4: REST API Endpoint (Replace with actual endpoint)
```bash
# Unauthenticated (should fail)
curl 'https://example.test/wp-json/[namespace]/v1/[endpoint]'

# Authenticated (should succeed if authorized)
curl 'https://example.test/wp-json/[namespace]/v1/[endpoint]' \
  -H "X-WP-Nonce: $NONCE" \
  -H "Cookie: $COOKIE"
```
