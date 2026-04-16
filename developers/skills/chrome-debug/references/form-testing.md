# Form Testing Guide

Comprehensive guide to testing forms with Chrome DevTools MCP.

---

## Quick Workflow

```
1. take_snapshot() → Get field UIDs
2. fill() or fill_form() → Fill fields
3. take_snapshot() → Check validation messages
4. take_screenshot() → Visual evidence (if needed)
```

---

## Fill Methods

### fill() - Sequential

**Use when:**
- Validation triggers on blur
- Fields depend on each other
- Need to test one field at a time

```javascript
take_snapshot();
# Output: [uid=email] textbox "Email"

fill({ uid: "email", value: "test@example.com" });
# Triggers blur event → validation may run

fill({ uid: "pwd", value: "Password123" });
```

### fill_form() - Parallel

**Use when:**
- Validation only on submit
- Fields independent
- Faster bulk filling

```javascript
take_snapshot();

fill_form([
  { uid: "email", value: "test@example.com" },
  { uid: "pwd", value: "Password123" },
  { uid: "name", value: "John Doe" }
]);
# All filled at once
```

---

## Validation Testing

### Client-Side Validation

```
# 1. Fill with INVALID data
fill({ uid: "email", value: "invalid-email" });

# 2. Take snapshot (check error messages)
take_snapshot();
# Output: [uid=err1] text "Email must be valid" [role=alert]

# 3. Take screenshot (visual evidence)
take_screenshot({ filePath: "./email-error.png" });

# 4. Fill with VALID data
fill({ uid: "email", value: "valid@example.com" });

# 5. Verify error cleared
take_snapshot();
# Error message gone
```

### Required Field Validation

```
# Leave field empty
fill({ uid: "email", value: "" });

# Try to submit
click({ uid: "submit-button" });

# Check error
take_snapshot();
# Expected: [uid=err] text "Email is required" [role=alert]
```

---

## Keyboard Navigation Testing

### Tab Order

```
# Press Tab to move between fields
press_key({ key: "Tab" });

# Take snapshot after each Tab
# Verify focus order logical

# Expected order:
# Email → Password → Submit button
```

### Enter Key Submit

```
# Fill form
fill_form([...]);

# Press Enter (should submit)
press_key({ key: "Enter" });

# Wait for submission
wait_for({ text: "Success!" });
```

---

## Error States

### Testing Error Display

```
# Submit empty form
click({ uid: "submit" });

# Snapshot (all errors should appear)
take_snapshot();

# Expected errors:
# - "Email is required"
# - "Password is required"
# - "Name is required"

# Screenshot for visual evidence
take_screenshot({ filePath: "./all-errors.png" });
```

---

## Accessibility Checks

### Labels

```
take_snapshot({ verbose: true });

# Verify each field has label:
# [uid=email] textbox "Email" [label="Email address"]

# Missing labels = accessibility issue
```

### ARIA Attributes

```
take_snapshot({ verbose: true });

# Check for:
# - aria-required="true" on required fields
# - aria-invalid="true" on invalid fields
# - aria-describedby linking to error messages
```

---

## Form Testing Checklist

**Basic Validation:**
- [ ] Required fields validated
- [ ] Email format validated
- [ ] Password strength validated
- [ ] Error messages displayed
- [ ] Error messages cleared when fixed

**Keyboard Navigation:**
- [ ] Tab order logical
- [ ] Focus indicators visible
- [ ] Enter submits form
- [ ] Escape clears/closes

**Accessibility:**
- [ ] All fields have labels
- [ ] Error messages use role="alert"
- [ ] aria-required on required fields
- [ ] aria-invalid on invalid fields

**Visual:**
- [ ] Error states visually distinct
- [ ] Success states shown
- [ ] Loading states displayed

---

## See Also

- [snapshot-vs-screenshot.md](./snapshot-vs-screenshot.md) - When to use each
- [templates/form-testing-checklist.md](../templates/form-testing-checklist.md) - Full checklist
