# CVSS v3.1 Scoring & Risk Assessment Guide

This guide helps you assess the severity of security vulnerabilities using the Common Vulnerability Scoring System (CVSS) v3.1, the industry standard for vulnerability assessment.

---

## Overview

**CVSS (Common Vulnerability Scoring System)** provides a standardized way to rate vulnerability severity on a scale of 0.0 to 10.0.

**Why CVSS matters:**
- Helps prioritize vulnerabilities (fix critical first)
- Determines disclosure timeline
- Guides resource allocation
- Provides common language for severity

**CVSS Score Ranges:**
- **0.0**: None
- **0.1-3.9**: Low
- **4.0-6.9**: Medium
- **7.0-8.9**: High
- **9.0-10.0**: Critical

---

## CVSS v3.1 Calculation

CVSS consists of three metric groups:

1. **Base Metrics** - Intrinsic qualities of the vulnerability (required)
2. **Temporal Metrics** - Time-dependent factors (optional)
3. **Environmental Metrics** - Organization-specific factors (optional)

For security fixes, focus on **Base Metrics** - they determine the fundamental severity.

---

## Base Metrics Group

### Exploitability Metrics

These describe how the vulnerability can be exploited.

#### 1. Attack Vector (AV)
**Question:** How can an attacker reach the vulnerable component?

- **Network (N)** [0.85] - Remotely exploitable over the network
  - Examples: REST API without auth, public AJAX endpoint, remote file inclusion

- **Adjacent (A)** [0.62] - Requires local network access
  - Examples: Attacks requiring same LAN, WiFi network

- **Local (L)** [0.55] - Requires local access to the system
  - Examples: Requires shell access, authenticated WordPress admin access

- **Physical (P)** [0.20] - Requires physical access
  - Examples: Direct access to server hardware (rare for WordPress)

**WordPress Context:**
- Network: Most WordPress vulnerabilities (exposed to internet)
- Local: Requires WordPress admin dashboard access
- Adjacent/Physical: Rare for web applications

---

#### 2. Attack Complexity (AC)
**Question:** How difficult is it to exploit?

- **Low (L)** [0.77] - No special conditions required
  - Exploitable by sending a simple HTTP request
  - No race conditions, no timing requirements
  - Example: Missing `current_user_can()` check

- **High (H)** [0.44] - Requires special circumstances
  - Timing-dependent (race conditions)
  - Requires gathering additional information
  - Must overcome security measures
  - Example: Requires knowledge of valid nonce + timing window

**WordPress Context:**
- Low: Most WordPress vulnerabilities (straightforward exploitation)
- High: Race conditions, complex multi-step exploits

---

#### 3. Privileges Required (PR)
**Question:** What level of access does the attacker need?

- **None (N)** [0.85] - Unauthenticated (anyone can exploit)
  - No WordPress login required
  - Example: `wp_ajax_nopriv_` handler without checks

- **Low (L)** [0.62/0.68]* - Basic authenticated user (subscriber, contributor)
  - Requires any WordPress account
  - Example: Subscriber can exploit vulnerability

- **High (H)** [0.27/0.50]* - Privileged user (admin, editor)
  - Requires admin/editor account
  - Example: Only WordPress admins can trigger

*Note: Value depends on Scope (changed vs. unchanged)

**WordPress Context:**
- None: Public-facing vulnerabilities (most severe)
- Low: Requires subscriber+ account
- High: Requires admin/editor account

---

#### 4. User Interaction (UI)
**Question:** Does exploitation require action from a legitimate user?

- **None (N)** [0.85] - No user interaction needed
  - Attacker can exploit directly
  - Example: Direct API call triggers vulnerability

- **Required (R)** [0.62] - Requires victim action
  - User must click a link, submit a form, etc.
  - Example: CSRF attack (requires victim to visit malicious page)
  - Example: Stored XSS (requires victim to view page)

**WordPress Context:**
- None: Most common for WordPress (direct exploitation)
- Required: CSRF, some XSS variants

---

### Impact Metrics

These describe the impact if successfully exploited.

#### 5. Scope (S)
**Question:** Can the vulnerability affect resources beyond its security scope?

- **Unchanged (U)** - Impact limited to the vulnerable component
  - Attacker gains access only within WordPress plugin's scope
  - Example: XSS in plugin only affects that plugin's pages

- **Changed (C)** - Impact extends beyond the vulnerable component
  - Attacker gains access to entire WordPress site
  - Example: SQL injection allows access to any WordPress data
  - Example: Remote code execution (full server compromise)

**WordPress Context:**
- Unchanged: Isolated plugin/theme vulnerabilities
- Changed: RCE, SQL injection, privilege escalation to admin

---

#### 6. Confidentiality Impact (C)
**Question:** How much information can be disclosed?

- **None (N)** [0.0] - No information disclosed

- **Low (L)** [0.22] - Limited information disclosure
  - Attacker can access some restricted data
  - Example: Leak specific post IDs, user counts

- **High (H)** [0.56] - Total information disclosure
  - Attacker can access all data
  - Example: Database dump, all user emails, password hashes

**WordPress Context:**
- None: No data leakage
- Low: Leaks non-sensitive info (post titles, public data)
- High: Leaks passwords, emails, PII, database contents

---

#### 7. Integrity Impact (I)
**Question:** Can the attacker modify data?

- **None (N)** [0.0] - No data modification possible

- **Low (L)** [0.22] - Limited data modification
  - Attacker can modify some data
  - Example: Edit their own user profile fields

- **High (H)** [0.56] - Total data modification
  - Attacker can modify any data
  - Example: SQL injection (modify any database record)
  - Example: XSS (modify any page content)

**WordPress Context:**
- None: Read-only vulnerabilities
- Low: Modify limited data (own posts, own profile)
- High: Modify any data (other users' content, site settings)

---

#### 8. Availability Impact (A)
**Question:** Can the attacker disrupt service availability?

- **None (N)** [0.0] - No availability impact

- **Low (L)** [0.22] - Reduced performance or partial DoS
  - Degraded performance
  - Example: Resource exhaustion (slowdown but not crash)

- **High (H)** [0.56] - Total unavailability
  - Complete denial of service
  - Example: Crash WordPress site, delete critical files

**WordPress Context:**
- None: No service disruption
- Low: Performance degradation
- High: Site crash, database corruption

---

## CVSS Calculation Examples

### Example 1: Unauthenticated SQL Injection

**Vulnerability:** REST API endpoint with SQL injection, no authentication required

**Metrics:**
- **AV:** Network (N) - Remotely exploitable
- **AC:** Low (L) - Simple HTTP request
- **PR:** None (N) - No authentication required
- **UI:** None (N) - Direct exploitation
- **S:** Changed (C) - Can access entire database
- **C:** High (H) - Can read all database data
- **I:** High (H) - Can modify all database data
- **A:** High (H) - Can drop tables (DoS)

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H`

**CVSS Score:** **10.0 (Critical)**

**Action:** Emergency fix, coordinate disclosure immediately

---

### Example 2: Authenticated Stored XSS (Subscriber)

**Vulnerability:** Subscriber can inject XSS in custom field, executed when admin views post

**Metrics:**
- **AV:** Network (N) - Remote exploit
- **AC:** Low (L) - Simple form submission
- **PR:** Low (L) - Requires subscriber account
- **UI:** Required (R) - Admin must view the post
- **S:** Changed (C) - XSS can access admin cookies, session
- **C:** High (H) - Can read admin session, steal credentials
- **I:** High (H) - Can modify site content as admin
- **A:** None (N) - No availability impact

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:L/UI:R/S:C/C:H/I:H/A:N`

**CVSS Score:** **8.1 (High)**

**Action:** Fix within 7 days, coordinate disclosure

---

### Example 3: CSRF on Admin Action

**Vulnerability:** Admin action (delete users) missing nonce verification

**Metrics:**
- **AV:** Network (N) - Remote exploit
- **AC:** Low (L) - Simple request
- **PR:** None (N) - Attacker doesn't need auth (tricks admin)
- **UI:** Required (R) - Admin must visit attacker's page
- **S:** Unchanged (U) - Limited to WordPress scope
- **C:** None (N) - No data disclosure
- **I:** High (H) - Can delete users, modify settings
- **A:** Low (L) - Could delete critical users (partial DoS)

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:N/I:H/A:L`

**CVSS Score:** **7.1 (High)**

**Action:** Fix within 7 days

---

### Example 4: Information Disclosure (Post IDs)

**Vulnerability:** REST API leaks draft post IDs to unauthenticated users

**Metrics:**
- **AV:** Network (N) - Remote
- **AC:** Low (L) - Simple API call
- **PR:** None (N) - No auth required
- **UI:** None (N) - Direct call
- **S:** Unchanged (U) - Only affects plugin
- **C:** Low (L) - Leaks limited info (post IDs)
- **I:** None (N) - No modification
- **A:** None (N) - No availability impact

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N`

**CVSS Score:** **5.3 (Medium)**

**Action:** Fix in next regular release (30 days)

---

### Example 5: Privilege Escalation (Subscriber → Admin)

**Vulnerability:** Subscriber can call admin-only function, escalate to admin role

**Metrics:**
- **AV:** Network (N) - Remote
- **AC:** Low (L) - Simple API call
- **PR:** Low (L) - Requires subscriber account
- **UI:** None (N) - Direct exploitation
- **S:** Changed (C) - Gains full admin access
- **C:** High (H) - Can read all data as admin
- **I:** High (H) - Can modify all data as admin
- **A:** High (H) - Can delete site

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:H/A:H`

**CVSS Score:** **9.9 (Critical)**

**Action:** Emergency fix, coordinate disclosure immediately

---

## Severity-Based Response

### Critical (9.0-10.0)

**Examples:**
- Unauthenticated RCE
- Unauthenticated SQL injection
- Authentication bypass
- Privilege escalation to admin

**Response:**
- **Timeline:** 7-day disclosure max
- **Fix Priority:** Emergency (drop everything)
- **Testing:** Immediate verification
- **Disclosure:** Coordinate with security researcher
- **Patch Distribution:** Force update if possible

---

### High (7.0-8.9)

**Examples:**
- Authenticated SQL injection
- Stored XSS (authenticated)
- CSRF on critical actions
- Sensitive data exposure

**Response:**
- **Timeline:** 30-day disclosure
- **Fix Priority:** High (fix within 7 days)
- **Testing:** Thorough testing + staging
- **Disclosure:** Standard coordinated disclosure
- **Patch Distribution:** Standard update + advisory

---

### Medium (4.0-6.9)

**Examples:**
- Information disclosure (limited)
- Reflected XSS (authenticated)
- CSRF on non-critical actions
- Missing rate limiting

**Response:**
- **Timeline:** 90-day disclosure
- **Fix Priority:** Medium (fix within 30 days)
- **Testing:** Standard testing
- **Disclosure:** Changelog mention
- **Patch Distribution:** Next regular release

---

### Low (0.1-3.9)

**Examples:**
- Information disclosure (minimal)
- Security hardening opportunities
- Minor configuration issues

**Response:**
- **Timeline:** Next major version
- **Fix Priority:** Low (fix when convenient)
- **Testing:** Standard testing
- **Disclosure:** Changelog only
- **Patch Distribution:** Next major release

---

## CVSS Calculator

Use official CVSS calculator: https://www.first.org/cvss/calculator/3.1

**Quick Reference Card:**

```
Attack Vector (AV):       N=Network, A=Adjacent, L=Local, P=Physical
Attack Complexity (AC):   L=Low, H=High
Privileges Required (PR): N=None, L=Low, H=High
User Interaction (UI):    N=None, R=Required
Scope (S):                U=Unchanged, C=Changed
Confidentiality (C):      N=None, L=Low, H=High
Integrity (I):            N=None, L=Low, H=High
Availability (A):         N=None, L=Low, H=High
```

---

## WordPress-Specific CVSS Guidance

### Determining Scope (S)

**Unchanged (U):**
- Vulnerability affects only the plugin/theme
- Cannot escalate beyond plugin boundaries
- Example: XSS in plugin settings page (admin-only)

**Changed (C):**
- Vulnerability affects WordPress core or other components
- Can escalate privileges
- Can access/modify data outside plugin scope
- Examples: RCE, SQL injection, privilege escalation, admin XSS

**Rule of Thumb:** If attacker gains admin access OR can execute code → Scope is Changed

---

### Determining Privileges Required (PR)

**None (N):**
- `wp_ajax_nopriv_` handlers
- Public REST API endpoints (no `permission_callback`)
- Shortcodes accessible to visitors
- Any unauthenticated code path

**Low (L):**
- Requires any WordPress account (subscriber, contributor, author)
- `wp_ajax_` handlers (authenticated but no capability check)
- REST API with `is_user_logged_in()` only

**High (H):**
- Requires admin, editor, or specific high capability
- `current_user_can( 'manage_options' )`
- WordPress admin dashboard access required

---

### Common WordPress Vulnerability CVSS Scores

| Vulnerability | Typical Score | Severity |
|---------------|---------------|----------|
| Unauthenticated RCE | 10.0 | Critical |
| Unauthenticated SQL Injection | 9.8-10.0 | Critical |
| Authentication Bypass | 9.8 | Critical |
| Privilege Escalation (Subscriber → Admin) | 9.9 | Critical |
| Authenticated SQL Injection (Admin) | 7.2 | High |
| Stored XSS (Subscriber) | 7.1-8.1 | High |
| Stored XSS (Admin-only) | 4.8 | Medium |
| CSRF (Admin action) | 6.5-8.1 | Med-High |
| Reflected XSS (Authenticated) | 5.4 | Medium |
| Information Disclosure (User emails) | 6.5 | Medium |
| Information Disclosure (Post IDs) | 5.3 | Medium |
| Missing Rate Limiting | 5.3 | Medium |

---

## Additional Resources

- [CVSS v3.1 Specification](https://www.first.org/cvss/v3.1/specification-document)
- [CVSS v3.1 Calculator](https://www.first.org/cvss/calculator/3.1)
- [NVD CVSS Calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
- [CVSS User Guide](https://www.first.org/cvss/user-guide)
