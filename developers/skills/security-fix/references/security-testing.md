# WordPress Security Testing & Validation Guide

This guide provides comprehensive testing strategies and validation patterns for WordPress security fixes. Use this to verify that your security patch fully mitigates the vulnerability without introducing regressions.

---

## Overview

**Why Testing Matters:**
- Ensures the vulnerability is actually fixed
- Prevents regressions in existing functionality
- Validates that the fix doesn't create new vulnerabilities
- Provides confidence for deployment

**Testing Strategy:**
1. **Automated Testing** - Unit tests, integration tests
2. **Manual Testing** - Reproduce the vulnerability, verify it's fixed
3. **Regression Testing** - Ensure existing features still work
4. **Edge Case Testing** - Test boundary conditions and error paths

---

## Manual Security Testing

### 1. Reproduce the Original Vulnerability

**CRITICAL: Always reproduce the vulnerability BEFORE applying your fix.**

**Steps:**
1. Set up a test environment matching the vulnerable conditions
2. Follow the security report's reproduction steps exactly
3. Document what you observe (screenshots, logs, network requests)
4. Confirm you can successfully exploit the vulnerability

**If you CANNOT reproduce:**
- Vulnerability may already be patched
- You may have misunderstood the vulnerability
- Environment/configuration may not match the report
- **DO NOT PROCEED** - See Error Recovery Scenario 5 in SKILL.md

---

### 2. Verify the Fix

After applying your security patch:

**Steps:**
1. Apply your security fix
2. Attempt to exploit the vulnerability using the SAME steps
3. Verify the exploit now fails
4. Check that error messages don't leak sensitive information
5. Test with different user roles (unauthenticated, subscriber, admin)
6. Test with different attack vectors (if multiple exist)

**Example: Testing an Authentication Bypass Fix**

```bash
# Before fix - Should succeed (vulnerability exists)
curl -X POST 'https://example.test/wp-json/myplugin/v1/admin-action' \
  -H 'Content-Type: application/json' \
  -d '{"action": "delete_all_users"}'
# Expected: 200 OK (BAD - no auth required)

# After fix - Should fail (vulnerability patched)
curl -X POST 'https://example.test/wp-json/myplugin/v1/admin-action' \
  -H 'Content-Type: application/json' \
  -d '{"action": "delete_all_users"}'
# Expected: 401 Unauthorized (GOOD - auth required)

# With valid auth - Should succeed
curl -X POST 'https://example.test/wp-json/myplugin/v1/admin-action' \
  -H 'Content-Type: application/json' \
  -H 'X-WP-Nonce: [valid-nonce]' \
  -d '{"action": "delete_all_users"}'
# Expected: 200 OK (GOOD - authorized admin can use endpoint)
```

---

### 3. Test Attack Variations

Don't just test the exact exploit from the report. Try variations:

**XSS Testing Variations:**
```javascript
// Basic XSS payload
<script>alert(1)</script>

// HTML entity encoded
&lt;script&gt;alert(1)&lt;/script&gt;

// Attribute-based XSS
" onload="alert(1)

// JavaScript URL
javascript:alert(1)

// SVG-based XSS
<svg/onload=alert(1)>

// Image tag XSS
<img src=x onerror=alert(1)>

// Case variations
<ScRiPt>alert(1)</sCrIpT>

// NULL byte injection (older PHP versions)
<script>alert(1)</script>%00
```

**SQL Injection Testing Variations:**
```sql
-- Basic SQLi
' OR '1'='1

-- Time-based blind SQLi
' AND SLEEP(5)--

-- UNION-based SQLi
' UNION SELECT user_login, user_pass FROM wp_users--

-- Boolean-based blind SQLi
' AND 1=1--
' AND 1=2--

-- Comment variations
' OR '1'='1'--
' OR '1'='1'/*
' OR '1'='1'#
```

**CSRF Testing Variations:**
```html
<!-- GET-based CSRF -->
<img src="https://example.com/wp-admin/admin-ajax.php?action=delete_user&user_id=1" />

<!-- POST-based CSRF -->
<form action="https://example.com/wp-admin/admin-ajax.php" method="POST">
  <input type="hidden" name="action" value="delete_user" />
  <input type="hidden" name="user_id" value="1" />
</form>
<script>document.forms[0].submit();</script>

<!-- JSON CSRF (if CORS misconfigured) -->
<script>
fetch('https://example.com/wp-json/myplugin/v1/delete-user', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({user_id: 1})
});
</script>
```

---

### 4. Test Different User Roles

**CRITICAL: Test with ALL WordPress roles to ensure proper authorization.**

| Role | Can Access? | Should Succeed? |
|------|-------------|-----------------|
| Unauthenticated | Try to access endpoint | ❌ Should fail (401/403) |
| Subscriber | Try to access endpoint | Depends on endpoint |
| Contributor | Try to access endpoint | Depends on endpoint |
| Author | Try to access endpoint | Depends on endpoint |
| Editor | Try to access endpoint | Depends on endpoint |
| Administrator | Try to access endpoint | ✅ Should succeed (if admin-only) |

**Test Script:**
```php
// Test with different user roles
$roles = array( 'subscriber', 'contributor', 'author', 'editor', 'administrator' );

foreach ( $roles as $role ) {
    // Create test user
    $user_id = wp_create_user( "test_{$role}", 'password', "{$role}@example.com" );
    $user = new WP_User( $user_id );
    $user->set_role( $role );

    // Authenticate as this user
    wp_set_current_user( $user_id );

    // Attempt to exploit vulnerability
    $result = myplugin_vulnerable_function( $malicious_input );

    // Verify result matches expectations
    if ( $role === 'administrator' ) {
        // Admin should be able to use the function
        assert( $result !== false, "Admin should be able to access function" );
    } else {
        // Non-admin should be blocked
        assert( $result === false, "Role {$role} should be blocked" );
    }

    // Cleanup
    wp_delete_user( $user_id );
}
```

---

### 5. Test Edge Cases

**Common Edge Cases to Test:**

**Empty/Null Input:**
```php
// Test with empty strings
test_function( '' );

// Test with null
test_function( null );

// Test with undefined array keys
test_function( $_POST['nonexistent'] ?? null );
```

**Type Juggling:**
```php
// Test with unexpected types
test_function( array() );  // Array instead of string
test_function( 0 );        // Integer instead of string
test_function( false );    // Boolean instead of string
test_function( '0' );      // String zero
```

**Boundary Values:**
```php
// Test numeric boundaries
test_function( -1 );           // Negative number
test_function( 0 );            // Zero
test_function( PHP_INT_MAX );  // Maximum integer
test_function( 99999999 );     // Very large number
```

**Special Characters:**
```php
// Test special characters in strings
test_function( "O'Reilly" );           // Single quote
test_function( 'Line1\nLine2' );       // Newline
test_function( 'Tab\tSeparated' );     // Tab
test_function( 'Unicode: 你好' );      // Unicode
test_function( 'Emoji: 🔒' );          // Emoji
test_function( str_repeat( 'A', 10000 ) );  // Very long string
```

---

## Automated Testing

### 1. PHPUnit Tests for Security Fixes

**Example: Testing Nonce Verification**

```php
<?php
class Test_Security_Fix extends WP_UnitTestCase {

    /**
     * Test that function requires valid nonce
     */
    public function test_function_requires_valid_nonce() {
        // Setup
        $_POST['action'] = 'delete_user';
        $_POST['user_id'] = 1;
        $_POST['nonce'] = 'invalid_nonce';

        // Execute
        $result = myplugin_delete_user_handler();

        // Assert
        $this->assertFalse( $result, 'Function should reject invalid nonce' );
    }

    /**
     * Test that function accepts valid nonce
     */
    public function test_function_accepts_valid_nonce() {
        // Setup: Create admin user and authenticate
        $admin_id = $this->factory->user->create( array( 'role' => 'administrator' ) );
        wp_set_current_user( $admin_id );

        $_POST['action'] = 'delete_user';
        $_POST['user_id'] = 1;
        $_POST['nonce'] = wp_create_nonce( 'delete-user-nonce' );

        // Execute
        $result = myplugin_delete_user_handler();

        // Assert
        $this->assertTrue( $result, 'Function should accept valid nonce from admin' );
    }

    /**
     * Test that function requires admin capability
     */
    public function test_function_requires_admin_capability() {
        // Setup: Create subscriber user and authenticate
        $subscriber_id = $this->factory->user->create( array( 'role' => 'subscriber' ) );
        wp_set_current_user( $subscriber_id );

        $_POST['action'] = 'delete_user';
        $_POST['user_id'] = 1;
        $_POST['nonce'] = wp_create_nonce( 'delete-user-nonce' );

        // Execute
        $result = myplugin_delete_user_handler();

        // Assert
        $this->assertFalse( $result, 'Function should reject subscriber user' );
    }
}
```

---

### 2. WP-CLI Testing Commands

**Test Authentication:**
```bash
# Test unauthenticated access (should fail)
wp eval 'echo myplugin_admin_function();'
# Expected: Error or false

# Test authenticated access (should succeed)
wp eval 'wp_set_current_user(1); echo myplugin_admin_function();'
# Expected: Success
```

**Test Sanitization:**
```bash
# Test XSS payload is sanitized
wp eval '
$input = "<script>alert(1)</script>";
$output = myplugin_sanitize_function( $input );
echo $output;
'
# Expected: Sanitized output (no script tags)
```

**Test SQL Injection Prevention:**
```bash
# Test SQL injection payload is escaped
wp eval '
global $wpdb;
$id = "1 OR 1=1";
$result = $wpdb->get_var( $wpdb->prepare( "SELECT * FROM table WHERE id = %d", $id ) );
echo $result;
'
# Expected: No results (injection prevented)
```

---

### 3. REST API Testing

**Testing REST API Endpoints:**

```bash
# Test without authentication (should fail)
curl -X POST 'https://example.test/wp-json/myplugin/v1/admin-action' \
  -H 'Content-Type: application/json' \
  -d '{"action": "sensitive_operation"}'
# Expected: 401 Unauthorized

# Get nonce for authenticated testing
NONCE=$(curl -s 'https://example.test/wp-json/' \
  --cookie "wordpress_logged_in_xxx=..." | \
  jq -r '.nonce')

# Test with authentication (should succeed if authorized)
curl -X POST 'https://example.test/wp-json/myplugin/v1/admin-action' \
  -H 'Content-Type: application/json' \
  -H "X-WP-Nonce: $NONCE" \
  -d '{"action": "sensitive_operation"}' \
  --cookie "wordpress_logged_in_xxx=..."
# Expected: 200 OK (if user is authorized)

# Test with malicious payload (should be sanitized)
curl -X POST 'https://example.test/wp-json/myplugin/v1/save-content' \
  -H 'Content-Type: application/json' \
  -H "X-WP-Nonce: $NONCE" \
  -d '{"content": "<script>alert(1)</script>"}' \
  --cookie "wordpress_logged_in_xxx=..."
# Expected: Content sanitized, XSS prevented
```

---

### 4. Browser-Based Testing

**Using Browser DevTools:**

```javascript
// Test AJAX endpoint security
fetch('/wp-admin/admin-ajax.php', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
  },
  body: 'action=myplugin_sensitive_action&param=value'
})
.then(response => response.json())
.then(data => console.log('Response:', data));
// Expected: Should fail without nonce

// Test with nonce
fetch('/wp-admin/admin-ajax.php', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
  },
  body: 'action=myplugin_sensitive_action&param=value&nonce=' + window.myPluginNonce
})
.then(response => response.json())
.then(data => console.log('Response:', data));
// Expected: Should succeed with valid nonce (if authorized)
```

---

## Regression Testing

### Regression Test Checklist

After applying your security fix, verify these don't break:

**Core Functionality:**
- [ ] Plugin/theme activates without errors
- [ ] Admin settings page loads correctly
- [ ] Frontend displays correctly
- [ ] User-facing features work as expected
- [ ] Admin-facing features work as expected

**Data Operations:**
- [ ] Create operations still work
- [ ] Read operations still work
- [ ] Update operations still work
- [ ] Delete operations still work
- [ ] Bulk operations still work

**User Experience:**
- [ ] No new error messages for legitimate users
- [ ] Forms still submit successfully (with nonce)
- [ ] AJAX requests still work
- [ ] Page loads aren't significantly slower

**Integration Points:**
- [ ] REST API endpoints still respond correctly
- [ ] AJAX handlers still work
- [ ] Shortcodes still render
- [ ] Gutenberg blocks still function
- [ ] Widgets still display
- [ ] WP-CLI commands still work
- [ ] Cron jobs still execute

**Third-Party Integrations:**
- [ ] Integrations with other plugins still work
- [ ] Theme compatibility maintained
- [ ] External API calls still succeed

---

## Security Validation Checklist

**Use this checklist after implementing any security fix.**

### Authentication Security

- [ ] All sensitive endpoints require authentication
- [ ] `is_user_logged_in()` checked where appropriate
- [ ] No authentication bypasses possible
- [ ] Session handling is secure
- [ ] Logout properly terminates sessions

### Authorization Security

- [ ] Capability checks use `current_user_can()`
- [ ] Correct capabilities used for each action
- [ ] No privilege escalation possible
- [ ] Authorization checked on EVERY request (not cached from earlier request)
- [ ] Authorization logic cannot be bypassed

### CSRF Protection

- [ ] All state-changing operations require nonce
- [ ] Nonces generated with `wp_create_nonce()`
- [ ] Nonces verified with `wp_verify_nonce()`, `check_admin_referer()`, or `check_ajax_referer()`
- [ ] Nonce action names are unique and descriptive
- [ ] GET requests don't modify state (idempotent)

### Input Validation & Sanitization

- [ ] ALL user input is sanitized
- [ ] Appropriate sanitization function used for data type:
  - [ ] `sanitize_text_field()` for plain text
  - [ ] `sanitize_email()` for emails
  - [ ] `esc_url_raw()` for URLs
  - [ ] `absint()` for IDs
  - [ ] `wp_kses_post()` for HTML content
- [ ] `wp_unslash()` called before sanitization (for `$_POST`/`$_GET`/`$_REQUEST`)
- [ ] Type validation performed (string, int, array, etc.)
- [ ] Range validation performed (min/max values)
- [ ] Whitelist validation for known values

### Output Escaping

- [ ] ALL output is escaped for context:
  - [ ] `esc_html()` for HTML content
  - [ ] `esc_attr()` for HTML attributes
  - [ ] `esc_url()` for URLs
  - [ ] `esc_js()` for JavaScript strings
  - [ ] `wp_kses_post()` for trusted HTML
- [ ] No raw `echo` of user input
- [ ] JSON responses properly encoded

### SQL Security

- [ ] ALL SQL queries use `$wpdb->prepare()`
- [ ] Correct placeholders used (`%s`, `%d`, `%f`)
- [ ] No direct variable interpolation in queries
- [ ] Table/column names validated against whitelist (if dynamic)

### File Operations

- [ ] File uploads validated (type, size, extension)
- [ ] Files stored outside web root or with random names
- [ ] No direct file inclusion of user-supplied paths
- [ ] `validate_file()` used for path validation

### API Security

- [ ] REST API endpoints have `permission_callback`
- [ ] AJAX endpoints verify nonce and capabilities
- [ ] Rate limiting implemented where appropriate
- [ ] Sensitive data not exposed in API responses

### Error Handling

- [ ] Error messages don't leak sensitive information
- [ ] No stack traces shown to users
- [ ] No database errors shown to users
- [ ] Generic error messages for security failures

---

## Tools for Security Testing

### Static Analysis Tools

**PHP_CodeSniffer with WordPress Standards:**
```bash
# Install
composer require --dev wp-coding-standards/wpcs
phpcs --config-set installed_paths vendor/wp-coding-standards/wpcs

# Run security checks
phpcs --standard=WordPress-Extra,WordPress-VIP-Go path/to/plugin/
```

**Psalm with WordPress Plugin:**
```bash
# Install
composer require --dev vimeo/psalm
composer require --dev psalm/plugin-wordpress

# Run static analysis
psalm --init
psalm
```

### Dynamic Analysis Tools

**WPScan:**
```bash
# Scan WordPress site for vulnerabilities
wpscan --url https://example.test --api-token YOUR_TOKEN

# Scan specific plugin
wpscan --url https://example.test --enumerate p --plugins-detection aggressive
```

**SQLMap (for SQL injection testing):**
```bash
# Test for SQL injection
sqlmap -u "https://example.test/wp-admin/admin-ajax.php?action=my_action&id=1" \
  --cookie="wordpress_logged_in_xxx=..." \
  --batch --level=5 --risk=3
```

**Burp Suite:**
- Intercept and modify HTTP requests
- Test authentication bypasses
- Test CSRF protection
- Test XSS payloads
- Fuzz input parameters

### Browser Extensions

**Wappalyzer:**
- Identify WordPress version
- Identify plugins/themes
- Identify security headers

**Cookie Editor:**
- Modify cookies for testing
- Test session security

---

## Security Testing Workflow

**Step-by-step testing process after implementing a fix:**

1. **Pre-Fix Testing**
   - [ ] Reproduce vulnerability in test environment
   - [ ] Document exact steps to exploit
   - [ ] Capture evidence (screenshots, logs)

2. **Apply Fix**
   - [ ] Apply security patch
   - [ ] Clear all caches
   - [ ] Restart services if needed

3. **Verify Fix**
   - [ ] Attempt to reproduce vulnerability (should fail)
   - [ ] Test attack variations (should all fail)
   - [ ] Test with different user roles
   - [ ] Test edge cases

4. **Regression Testing**
   - [ ] Run automated test suite
   - [ ] Manually test core functionality
   - [ ] Test integration points
   - [ ] Verify no new errors in logs

5. **Security Validation**
   - [ ] Complete security checklist
   - [ ] Run static analysis tools
   - [ ] Review all modified code paths

6. **Performance Testing**
   - [ ] Measure page load times
   - [ ] Check database query count
   - [ ] Monitor memory usage
   - [ ] Verify no significant degradation

7. **Documentation**
   - [ ] Document testing results
   - [ ] Update changelog
   - [ ] Create manual verification checklist for QA
   - [ ] Document any breaking changes

---

## Common Testing Mistakes

**❌ DON'T:**
- Test only the exact exploit from the security report
- Test only with admin users
- Skip regression testing
- Assume sanitization alone prevents XSS (must also escape output)
- Trust error messages to indicate security (must verify actual behavior)
- Test only in development environment (test in staging too)

**✅ DO:**
- Test multiple attack variations
- Test all user roles
- Run full regression suite
- Verify both input sanitization AND output escaping
- Verify actual security behavior (not just error messages)
- Test in environment matching production

---

## Additional Resources

- [WordPress Plugin Unit Tests](https://make.wordpress.org/cli/handbook/plugin-unit-tests/)
- [WP-CLI Testing Commands](https://developer.wordpress.org/cli/commands/)
- [PHPUnit Documentation](https://phpunit.de/documentation.html)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [WordPress Security Patterns](wordpress-patterns.md)
