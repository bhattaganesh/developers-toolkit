# Form Testing Checklist

**Form:** [Form name or identifier]
**Page:** [URL]
**Date:** [YYYY-MM-DD]
**Tested By:** [Name or "Claude Code chrome-debug"]

---

## Form Fields

| Field | Type | UID | Required | Validation |
|-------|------|-----|----------|------------|
| [Field 1] | [text/email/password/select/etc.] | [uid] | [Yes/No] | [Rules] |
| [Field 2] | [text/email/password/select/etc.] | [uid] | [Yes/No] | [Rules] |
| [Field 3] | [text/email/password/select/etc.] | [uid] | [Yes/No] | [Rules] |

---

## Validation Testing

### Required Field Validation
- [ ] **[Field Name]**
  - Leave empty → Error: "[Expected error message]"
  - Error displayed: [✅ / ❌]
  - Error message correct: [✅ / ❌]
  - Screenshot: [path]

- [ ] **[Field Name]**
  - Leave empty → Error: "[Expected error message]"
  - Error displayed: [✅ / ❌]
  - Error message correct: [✅ / ❌]
  - Screenshot: [path]

### Format Validation

#### Email Field
- [ ] Invalid format (e.g., "notanemail")
  - Error: "[Expected error]"
  - Status: [✅ / ❌]

- [ ] Valid format (e.g., "user@example.com")
  - No error: [✅ / ❌]

#### Password Field
- [ ] Too short (< minimum length)
  - Error: "[Expected error]"
  - Status: [✅ / ❌]

- [ ] Missing required characters
  - Error: "[Expected error]"
  - Status: [✅ / ❌]

- [ ] Valid password
  - No error: [✅ / ❌]

#### Phone Field
- [ ] Invalid format
  - Error: "[Expected error]"
  - Status: [✅ / ❌]

- [ ] Valid format
  - No error: [✅ / ❌]

### Custom Validation Rules
- [ ] **[Custom Rule 1]**
  - Test: [What was tested]
  - Expected: [Expected behavior]
  - Actual: [Actual behavior]
  - Status: [✅ / ❌]

---

## Error States

### Error Message Display
- [ ] Error messages visible
- [ ] Error messages clearly associated with fields
- [ ] Error messages use appropriate ARIA attributes (role="alert")
- [ ] Errors styled distinctly (red text, icon, etc.)
- [ ] Screenshot: [path]

### Error Message Clearing
- [ ] Errors clear when field corrected
- [ ] Errors clear on focus
- [ ] Errors clear on blur (after valid input)
- [ ] Screenshot (after fix): [path]

### Multiple Errors
- [ ] All errors shown simultaneously when submitting empty form
- [ ] Errors prioritized/ordered logically
- [ ] Screenshot (all errors): [path]

---

## Keyboard Navigation

### Tab Order
- [ ] Tab order logical (top to bottom, left to right)
- [ ] Tab reaches all interactive elements
- [ ] Tab skips non-interactive elements
- [ ] Shift+Tab reverses order correctly

**Tab Order:**
1. [Field 1]
2. [Field 2]
3. [Field 3]
4. [Submit Button]

### Focus Indicators
- [ ] Focus visible on all fields
- [ ] Focus style distinct from hover
- [ ] Focus persists during interaction
- [ ] Screenshot (focused state): [path]

### Keyboard Controls
- [ ] Enter key submits form
- [ ] Escape key clears/cancels (if applicable)
- [ ] Arrow keys navigate select/radio (if applicable)
- [ ] Space toggles checkboxes

---

## Accessibility

### Labels
- [ ] All fields have associated labels
- [ ] Labels use `<label>` element with `for` attribute
- [ ] Labels visible and descriptive
- [ ] Snapshot shows labels correctly: [✅ / ❌]

### ARIA Attributes
- [ ] Required fields have `aria-required="true"`
- [ ] Invalid fields have `aria-invalid="true"`
- [ ] Error messages have `role="alert"`
- [ ] Fields use `aria-describedby` for help text
- [ ] Snapshot (verbose) confirms ARIA: [✅ / ❌]

### Screen Reader Compatibility
- [ ] Field labels announced
- [ ] Error messages announced
- [ ] Required fields indicated
- [ ] Help text available

---

## Form Submission

### Success State
- [ ] Form submits with valid data
- [ ] Success message displayed
- [ ] Form cleared/redirected as expected
- [ ] Loading indicator shown during submission
- [ ] Screenshot (success): [path]

### Error State (Server-Side)
- [ ] Server errors displayed to user
- [ ] Error messages helpful and specific
- [ ] Form data preserved after error
- [ ] Screenshot (server error): [path]

### Loading State
- [ ] Loading indicator displayed
- [ ] Submit button disabled during submission
- [ ] Form not re-submittable during processing
- [ ] Screenshot (loading): [path]

---

## Edge Cases

### Empty Form Submission
- [ ] All required field errors shown
- [ ] No form submission occurs
- [ ] User remains on page
- [ ] Screenshot: [path]

### Partial Form Submission
- [ ] Only invalid fields show errors
- [ ] Valid fields retain values
- [ ] User can correct and resubmit

### Duplicate Submission
- [ ] Prevents duplicate submissions
- [ ] Button disabled after first submit
- [ ] Loading state prevents re-clicks

---

## Visual Testing

### Field States
- [ ] Default state styled correctly
- [ ] Hover state visible
- [ ] Focus state distinct
- [ ] Error state clearly marked (red border, icon, etc.)
- [ ] Valid state indicated (green checkmark, etc.)
- [ ] Screenshots for each state: [paths]

### Responsive Behavior
- [ ] Mobile (375px): [✅ / ❌] - Screenshot: [path]
- [ ] Tablet (768px): [✅ / ❌] - Screenshot: [path]
- [ ] Desktop (1920px): [✅ / ❌] - Screenshot: [path]

### Layout
- [ ] Fields aligned properly
- [ ] Labels aligned with fields
- [ ] Error messages positioned correctly
- [ ] Submit button prominent
- [ ] Screenshot (full form): [path]

---

## Console Errors

### JavaScript Errors
```
[Paste any console errors encountered during testing]
```

**Status:** [✅ No errors / ❌ Errors found]

---

## Summary

### Passed Tests
- [X / Total] validation tests passed
- [X / Total] keyboard navigation tests passed
- [X / Total] accessibility tests passed
- [X / Total] submission tests passed

### Failed Tests
1. **[Failed Test Name]**
   - Issue: [Description]
   - Severity: [Critical / High / Medium / Low]

2. **[Failed Test Name]**
   - Issue: [Description]
   - Severity: [Critical / High / Medium / Low]

---

## Evidence Files

**Screenshots:** [./screenshots/form-testing/]
- default-state.png
- error-state.png
- success-state.png
- mobile-view.png

**Snapshots:** [./snapshots/form-testing/]
- initial-snapshot.txt
- error-snapshot.txt
- success-snapshot.txt

**Console Logs:** [./logs/form-console.log]

---

## Recommendations

### High Priority Fixes
- [ ] [Fix 1]
- [ ] [Fix 2]

### Medium Priority Improvements
- [ ] [Improvement 1]
- [ ] [Improvement 2]

### Low Priority Enhancements
- [ ] [Enhancement 1]
- [ ] [Enhancement 2]

---

## Sign-Off

**Overall Status:** [✅ Pass / ⚠️ Pass with Minor Issues / ❌ Fail]
**Ready for Production:** [Yes / No / With Fixes]
**Approved By:** [Name]
**Date:** [YYYY-MM-DD]
