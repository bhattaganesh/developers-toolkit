# Example: Checkout Form Validation Testing

**Scenario:** Test checkout form validation before launching new e-commerce site.

**Page:** https://example.com/checkout
**Form:** Payment and shipping information

---

## Phase 0: Setup

```
list_pages()
select_page({ pageId: 1 })
navigate_page({ type: "url", url: "https://example.com/checkout" })
```

---

## Phase 1: Initial Inspection

**Take snapshot (identify fields):**
```
take_snapshot()

Output:
[uid=email] textbox "Email address" [role=textbox] [required]
[uid=card] textbox "Card number" [role=textbox] [required]
[uid=cvv] textbox "CVV" [role=textbox] [required] [type=password]
[uid=zip] textbox "ZIP code" [role=textbox] [required]
[uid=submit] button "Complete Purchase" [role=button]
```

---

## Phase 2D: Form Testing

### Test 1: Required Field Validation

**Submit empty form:**
```
click({ uid: "submit", includeSnapshot: true })

Snapshot output:
[uid=err1] text "Email is required" [role=alert]
[uid=err2] text "Card number is required" [role=alert]
[uid=err3] text "CVV is required" [role=alert]
[uid=err4] text "ZIP code is required" [role=alert]
```

**Screenshot errors:**
```
take_screenshot({ filePath: "./all-errors.png" })
```

✅ **Result:** All required fields show errors

---

### Test 2: Email Format Validation

**Fill invalid email:**
```
fill({ uid: "email", value: "notanemail" })
click({ uid: "submit", includeSnapshot: true })

Snapshot:
[uid=err1] text "Please enter a valid email address" [role=alert]
```

✅ **Result:** Email format validated

**Fill valid email:**
```
fill({ uid: "email", value: "test@example.com" })

# Error clears
take_snapshot()
# No error for email field
```

✅ **Result:** Error clears when fixed

---

### Test 3: Card Number Validation

**Fill invalid card:**
```
fill({ uid: "card", value: "1234" })
click({ uid: "submit", includeSnapshot: true })

Snapshot:
[uid=err2] text "Please enter a valid card number" [role=alert]
```

✅ **Result:** Card format validated

**Fill valid card:**
```
fill({ uid: "card", value: "4111111111111111" })

# Error clears
```

✅ **Result:** Valid card accepted

---

### Test 4: CVV Validation

**Fill invalid CVV (too short):**
```
fill({ uid: "cvv", value: "12" })
click({ uid: "submit" })

Snapshot:
[uid=err3] text "CVV must be 3 or 4 digits" [role=alert]
```

✅ **Result:** CVV length validated

---

### Test 5: Keyboard Navigation

**Test Tab order:**
```
press_key({ key: "Tab" })
take_snapshot()
# Focus on email field

press_key({ key: "Tab" })
take_snapshot()
# Focus on card field

press_key({ key: "Tab" })
# Focus on CVV field

press_key({ key: "Tab" })
# Focus on ZIP field

press_key({ key: "Tab" })
# Focus on submit button
```

✅ **Result:** Tab order logical (email → card → CVV → ZIP → submit)

**Test Enter key submit:**
```
fill_form([
  { uid: "email", value: "test@example.com" },
  { uid: "card", value: "4111111111111111" },
  { uid: "cvv", value: "123" },
  { uid: "zip", value: "12345" }
])

press_key({ key: "Enter" })

wait_for({ text: "Order Confirmed!" })
```

✅ **Result:** Enter key submits form

---

## Evidence Collected

1. **Screenshots:**
   - `all-errors.png` - All validation errors displayed
   - `email-error.png` - Email format error
   - `card-error.png` - Card validation error

2. **Snapshots:**
   - Initial form structure
   - Error states for each field
   - Success state

3. **Console:** No JavaScript errors during testing

---

## Findings

### ✅ Passed Tests

**Validation:**
- Required field validation works
- Email format validation works
- Card number validation works
- CVV length validation works
- ZIP code validation works
- Errors clear when fields fixed

**Keyboard Navigation:**
- Tab order logical
- Focus indicators visible
- Enter key submits form
- All fields reachable via keyboard

**Accessibility:**
- All fields have labels
- Errors use `role="alert"`
- Required fields marked with `aria-required="true"`

### ❌ Issues Found

**Issue 1: CVV Error Message**
- **Current:** "CVV must be 3 or 4 digits"
- **Problem:** Doesn't explain what CVV is
- **Fix:** "CVV (3 or 4 digit security code on your card) is invalid"
- **Severity:** Low

**Issue 2: Focus Indicator**
- **Current:** Very faint blue outline
- **Problem:** Hard to see for keyboard users
- **Fix:** Increase contrast (2px solid blue border)
- **Severity:** Medium

---

## Checklist Summary

- [x] Required fields validated
- [x] Email format validated
- [x] Card number validated
- [x] CVV validated
- [x] ZIP validated
- [x] Errors displayed clearly
- [x] Errors clear when fixed
- [x] Tab order logical
- [x] Enter submits form
- [x] All fields have labels
- [x] Errors use ARIA alerts
- [~] Focus indicators visible (needs improvement)

**Pass Rate:** 12/13 (92%)

---

## Outcome

**Status:** ⚠️ Pass with Minor Issues

**Ready for Production:** Yes, with fixes

**Recommendations:**
1. Improve CVV error message (Low priority)
2. Increase focus indicator contrast (Medium priority - accessibility)

---

## Takeaways

1. **Snapshot first** - Get all field UIDs in one call
2. **Test systematically** - One validation rule at a time
3. **Keyboard testing** - Always test Tab order and Enter key
4. **Error clearing** - Verify errors clear when fields fixed
5. **Accessibility** - Check ARIA attributes in verbose snapshot
