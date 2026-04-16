# Regression Test Checklist

**Plugin/Theme:** [Name]
**Version:** [X.Y.Z]
**Tested By:** [Name]
**Test Date:** [YYYY-MM-DD]
**Test Environment:** [Local / Staging / Production-like]

---

## Purpose

This checklist ensures the security fix doesn't break existing functionality. **All items must PASS before releasing.**

---

## Installation & Activation

- [ ] Plugin/theme installs without errors
- [ ] Plugin/theme activates without errors
- [ ] No PHP fatal errors in `debug.log`
- [ ] No database errors during activation
- [ ] Activation hooks execute correctly
- [ ] Required tables/options created correctly

**Notes:** [Any issues observed]

---

## Admin Area

### Dashboard
- [ ] WordPress dashboard loads correctly
- [ ] Plugin/theme dashboard widgets display (if applicable)
- [ ] Admin notices display correctly
- [ ] No JavaScript errors in console

### Settings Page
- [ ] Settings page loads without errors
- [ ] All form fields render correctly
- [ ] Settings save successfully
- [ ] Settings are persisted after save
- [ ] Validation messages display correctly
- [ ] Help text/tooltips display correctly

### Admin Menu/Navigation
- [ ] Menu items appear in correct location
- [ ] Submenu items accessible
- [ ] Menu permissions respected (subscriber can't see admin menus)
- [ ] Navigation between pages works

**Notes:** [Any issues observed]

---

## Frontend

### Display
- [ ] Homepage loads correctly
- [ ] Post/page content displays correctly
- [ ] Shortcodes render correctly
- [ ] Widgets display correctly
- [ ] Footer/header elements display correctly
- [ ] Styles load correctly (no broken CSS)
- [ ] Images load correctly

### Functionality
- [ ] Forms submit successfully
- [ ] AJAX requests work (with valid nonce)
- [ ] Pagination works
- [ ] Search functionality works
- [ ] Filtering/sorting works
- [ ] Dynamic content loads correctly

### Gutenberg Blocks (if applicable)
- [ ] Blocks render in editor
- [ ] Block settings work
- [ ] Blocks save correctly
- [ ] Blocks display correctly on frontend
- [ ] Block patterns work
- [ ] No block validation errors

**Notes:** [Any issues observed]

---

## User Functionality

### Authentication
- [ ] Users can log in
- [ ] Users can log out
- [ ] Password reset works
- [ ] Registration works (if enabled)
- [ ] Remember me works

### User Actions
- [ ] Users can create/edit posts (if permitted)
- [ ] Users can upload media (if permitted)
- [ ] User profile page works
- [ ] User can update their profile
- [ ] Comments work (if applicable)

### Permissions
- [ ] Subscriber role limitations respected
- [ ] Contributor role limitations respected
- [ ] Author role capabilities work
- [ ] Editor role capabilities work
- [ ] Administrator has full access

**Notes:** [Any issues observed]

---

## AJAX & REST API

### AJAX Handlers
- [ ] Admin AJAX handlers work (with nonce)
- [ ] Frontend AJAX works (if applicable)
- [ ] Proper error messages for invalid requests
- [ ] No AJAX errors in console

### REST API Endpoints
- [ ] Custom REST endpoints respond
- [ ] Authentication required where appropriate
- [ ] Permission callbacks work correctly
- [ ] Response format is correct
- [ ] Error responses are appropriate

**Notes:** [Any issues observed]

---

## Integrations

### Third-Party Plugins
- [ ] Integration with [Plugin Name 1] works
- [ ] Integration with [Plugin Name 2] works
- [ ] No conflicts with popular plugins:
  - [ ] Yoast SEO
  - [ ] WooCommerce (if applicable)
  - [ ] Contact Form 7 (if applicable)
  - [ ] Elementor/Beaver Builder (if applicable)

### Theme Compatibility
- [ ] Works with Twenty Twenty-Four theme
- [ ] Works with [Primary Theme Name]
- [ ] No theme conflicts

### External Services
- [ ] API calls to external services work
- [ ] Webhooks function correctly
- [ ] OAuth flows work (if applicable)
- [ ] Email sending works

**Notes:** [Any issues observed]

---

## Performance

### Page Load
- [ ] Page load time acceptable (<3 seconds)
- [ ] No significant slowdown compared to previous version
- [ ] Time to First Byte (TTFB) acceptable

### Database
- [ ] No significant increase in query count
- [ ] No slow queries (check Query Monitor plugin)
- [ ] Database writes complete successfully

### Resources
- [ ] Memory usage reasonable
- [ ] CPU usage reasonable
- [ ] No memory leaks during testing

**Measurements:**
- Page load time: [X seconds]
- Database queries: [X queries]
- Memory usage: [X MB]

**Notes:** [Any issues observed]

---

## Data Integrity

- [ ] Existing data not corrupted
- [ ] New data saves correctly
- [ ] Updates work correctly
- [ ] Deletes work correctly
- [ ] Data relationships maintained
- [ ] No orphaned records

**Notes:** [Any issues observed]

---

## Error Handling

### Log Files
- [ ] No new PHP errors in `debug.log`
- [ ] No new JavaScript errors in console
- [ ] No new warnings in logs
- [ ] No database errors logged

### Error Messages
- [ ] User-friendly error messages displayed
- [ ] Error messages don't leak sensitive information
- [ ] Network errors handled gracefully
- [ ] Invalid input handled gracefully

**Notes:** [Any issues observed]

---

## Multisite-Specific (if applicable)

- [ ] Works on network admin
- [ ] Works on individual sites
- [ ] Network activation works
- [ ] Site-specific activation works
- [ ] Network settings save correctly
- [ ] Site-specific settings save correctly
- [ ] `switch_to_blog()` calls work correctly

**Notes:** [Any issues observed] | [ ] N/A (Not multisite)

---

## Internationalization (i18n)

- [ ] Text strings are translatable
- [ ] Translations load correctly
- [ ] RTL languages display correctly (if supported)
- [ ] Date/time formatting respects locale

**Notes:** [Any issues observed]

---

## Accessibility

- [ ] Keyboard navigation works
- [ ] Screen reader compatible (test with NVDA/JAWS)
- [ ] Color contrast meets WCAG 2.1 AA standards
- [ ] Focus indicators visible
- [ ] ARIA labels present where needed

**Notes:** [Any issues observed]

---

## Edge Cases

- [ ] Works with PHP memory limit = 64MB
- [ ] Works with WordPress debug mode ON
- [ ] Works with object caching enabled
- [ ] Works with page caching enabled
- [ ] Works on subdirectory install
- [ ] Works on subdomain install

**Notes:** [Any issues observed]

---

## Browser Compatibility

Test on the following browsers:

- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

**Notes:** [Any browser-specific issues]

---

## WordPress Versions

Test on the following WordPress versions:

- [ ] WordPress [current stable - e.g., 6.4]
- [ ] WordPress [previous stable - e.g., 6.3]
- [ ] WordPress [minimum supported - e.g., 5.9]

**Notes:** [Any version-specific issues]

---

## Uninstall/Deactivation

- [ ] Plugin deactivates without errors
- [ ] Plugin reactivates without errors
- [ ] Plugin uninstalls cleanly (if uninstall.php exists)
- [ ] Database tables removed on uninstall (if intended)
- [ ] Options removed on uninstall (if intended)
- [ ] User data preserved on deactivate (if intended)

**Notes:** [Any issues observed]

---

## Test Summary

**Total Tests:** [X]
**Passed:** [X]
**Failed:** [X]
**Skipped:** [X] (N/A)

### Critical Issues (Must Fix)
[List any critical issues that block release]

### Non-Critical Issues (Can Fix Later)
[List any minor issues that don't block release]

---

## Sign-Off

**Overall Assessment:** [ ] PASS - Ready for Release | [ ] FAIL - Needs Rework

**Tested By:** [Name]
**Date:** [YYYY-MM-DD]
**Approval:** [ ] APPROVED | [ ] REJECTED

**Additional Notes:**
[Any final observations or recommendations]

---

## Testing Checklist for QA Team

Before marking as complete, ensure:

- [ ] All sections completed
- [ ] All PASS/FAIL checkboxes marked
- [ ] Notes provided for any failures
- [ ] Critical issues documented
- [ ] Screenshots attached for visual issues (if applicable)
- [ ] Test environment details recorded
- [ ] Sign-off section completed
