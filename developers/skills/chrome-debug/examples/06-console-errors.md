# Example: JavaScript Error Investigation

**Scenario:** User reports form not submitting. Need to investigate console errors.

**Page:** https://example.com/contact
**Issue:** "Submit" button does nothing when clicked

---

## Phase 0: Setup

```
list_pages()
select_page({ pageId: 1 })
navigate_page({ type: "url", url: "https://example.com/contact" })
```

---

## Phase 1: Initial Inspection

**Check console:**
```
list_console_messages({ types: ["error", "warn"] })

Output:
[msgid=1] error "Uncaught TypeError: Cannot read property 'value' of null"
[msgid=2] warn "Form validation library not loaded"
```

**Network check:**
```
list_network_requests({ resourceTypes: ["script"] })

Output:
[reqid=45] GET /js/form-validation.js [status=404] ← Failed!
[reqid=46] GET /js/app.js [status=200] ← Loaded
```

---

## Phase 2E: Console Error Investigation

**Get error details:**
```
get_console_message({ msgid: 1 })

Output:
{
  "type": "error",
  "text": "Uncaught TypeError: Cannot read property 'value' of null",
  "source": "javascript",
  "url": "https://example.com/js/app.js",
  "line": 42,
  "column": 10,
  "stackTrace": [
    "at submitForm (app.js:42:10)",
    "at HTMLButtonElement.onclick (contact.html:78:5)"
  ]
}
```

**Key information:**
- File: `/js/app.js`
- Line: 42
- Function: `submitForm`
- Error: Trying to access `.value` of `null`

---

## Phase 3: Targeted Investigation

**Check what's on line 42:**
```
# Would need to read the source file or use DevTools

# Likely code:
const emailInput = document.getElementById('email');
const email = emailInput.value;  // Line 42 - emailInput is null!
```

**Why is emailInput null?**

**Take snapshot (check if email field exists):**
```
take_snapshot()

Output:
[uid=email-field] textbox "Email Address" [role=textbox] [id="email-address"]
                                                          ^^^^^^^^^^^^
# Field ID is "email-address", NOT "email"!
```

**Root Cause:**
- Code looks for `id="email"`
- Actual field has `id="email-address"`
- `getElementById('email')` returns `null`
- Accessing `null.value` throws error

---

## Evidence Collected

1. **Console Error:**
   ```
   Uncaught TypeError: Cannot read property 'value' of null
   File: app.js:42
   ```

2. **Stack Trace:**
   ```
   at submitForm (app.js:42:10)
   at HTMLButtonElement.onclick (contact.html:78:5)
   ```

3. **Snapshot:** Field has `id="email-address"`, not `id="email"`

4. **Network:** form-validation.js failed to load (404)

---

## Findings

### Primary Issue

**JavaScript Error in app.js:42**
- **Cause:** `document.getElementById('email')` returns null
- **Reason:** Field ID is "email-address", not "email"
- **Impact:** Form cannot submit
- **Severity:** Critical

**Fix:**
```javascript
// Before:
const emailInput = document.getElementById('email');

// After:
const emailInput = document.getElementById('email-address');
```

### Secondary Issue

**Missing form-validation.js**
- **Status:** 404 Not Found
- **Impact:** Client-side validation not working
- **Severity:** High
- **Fix:** Ensure file exists at `/js/form-validation.js`

---

## Reproduction Steps

1. Navigate to https://example.com/contact
2. Fill in form fields
3. Click "Submit" button
4. **Expected:** Form submits
5. **Actual:** Nothing happens, console error

---

## Console Error Analysis

### Error Pattern

**Frequency:** Occurs every time submit button clicked
**Type:** TypeError (attempting to access property of null)
**Source:** First-party code (app.js)
**Priority:** P0 (Critical - blocks core functionality)

---

## Recommended Fixes

### Immediate (Critical)

**1. Fix getElementById call:**
```javascript
// File: app.js:42
- const emailInput = document.getElementById('email');
+ const emailInput = document.getElementById('email-address');
```

**2. Add null check (defensive):**
```javascript
const emailInput = document.getElementById('email-address');
if (!emailInput) {
  console.error('Email input field not found');
  return;
}
const email = emailInput.value;
```

### Short Term

**3. Restore form-validation.js:**
- Upload file to `/js/form-validation.js`
- Or update path in HTML if moved

**4. Add error handling:**
```javascript
try {
  const email = emailInput.value;
  // ... rest of form handling
} catch (error) {
  console.error('Form submission error:', error);
  alert('There was an error submitting the form. Please try again.');
}
```

---

## Outcome

**Bug Report:** Created with stack trace and reproduction steps

**Status:** Critical - Deploy fix immediately

**Impact:** 100% of form submissions failing

**Fix ETA:** 15 minutes (change ID reference in JavaScript)

---

## Verification After Fix

**After deploying fix:**
1. Reload page
2. Check console - no errors
3. Fill form
4. Click submit
5. Verify form submits successfully
6. Screenshot success state

---

## Takeaways

1. **Console errors = roadmap** - Stack trace points directly to problem
2. **Check IDs match** - Common issue: JavaScript uses wrong ID
3. **Snapshot to verify** - Quickly confirm element IDs
4. **Null checks** - Always check `getElementById` result before using
5. **Network tab** - Also revealed missing validation library (404)
6. **Defensive coding** - Add try/catch and null checks for user-facing code
