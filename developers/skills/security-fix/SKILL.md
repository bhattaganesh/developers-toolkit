---
name: security-fix
description: >
  This skill should be used when the user asks to "fix a security issue", "fix a vulnerability",
  "handle a security report", "patch a CVE", "fix IDOR/RCE/XSS/SQL injection/CSRF",
  "implement a security fix", or mentions "bug bounty", "HackerOne", "Wordfence",
  "Patchstack", "WPScan", "nonce verification", "capability check", "sanitize inputs",
  "escape outputs", or needs to implement a security patch in WordPress plugins, themes, or core.
version: 2.0.0
tools: Read, Glob, Grep, Edit, Write, Bash, Task
context: fork
---

# Security Fix Skill

Implements security patches for WordPress plugins/themes/core.

## When to Use

- Fix reported vulnerability (bug bounty, security scanner, audit)
- Patch CVE/IDOR/RCE/XSS/SQLi/CSRF
- Address authentication/authorization bypass
- Implement security hardening
- Handle disclosure reports (HackerOne, Wordfence, Patchstack)

**ASSUMPTION:** Production code - security impacts real users immediately.

---

## Operating Principles

**Security First:**
- Fix vulnerability completely (no partial patches)
- Defense in depth (multiple layers)
- Fail securely (deny by default)
- Minimal attack surface

**Code Quality:**
- No breaking changes (unless necessary for security)
- Maintain backwards compatibility where safe
- Follow WordPress coding standards
- Add security tests

**Verification:**
- Prove vulnerability exists (before fix)
- Prove vulnerability fixed (after fix)
- Test for regressions
- Document attack vector

**CRITICAL:** Never skip quality gates.

---

## Phase 0: Risk Assessment

**Goal:** Understand severity

**Q:** Vulnerability details?
- Type (XSS, SQLi, CSRF, auth bypass, etc.)
- Attack vector (how to exploit)
- Impact (what attacker can do)
- Affected versions
- Public disclosure status

**CVSS Scoring (quick reference):**
- **Critical (9.0-10.0):** RCE, auth bypass, SQLi (write)
- **High (7.0-8.9):** Stored XSS, privilege escalation, SQLi (read)
- **Medium (4.0-6.9):** Reflected XSS, CSRF, IDOR
- **Low (0.1-3.9):** Info disclosure, low-impact issues

**STOP if:** Cannot determine severity or attack vector

**Priority:**
- Critical/High: Immediate fix
- Medium: Fix within 1 week
- Low: Fix in next release

See `references/cvss-scoring.md` for detailed scoring.

---

## Phase 1: Triage

**Goal:** Understand the vulnerability

**Read:**
- Security report (full details)
- Affected file(s)
- Surrounding code context
- Related functions/classes

**Understand:**
- Attack vector (step-by-step)
- Root cause (why vulnerable)
- Scope (what else affected)
- Prerequisites (auth required?)

**Reproduce (if possible):**
- Set up test environment
- Follow attack steps
- Verify vulnerability exists
- Document proof of concept

**STOP if:** Cannot understand vulnerability

**Output:** Clear description of vulnerability and root cause

---

## ⚠️ QUALITY GATE 1: User Confirmation

**Present findings:**
- Vulnerability summary
- Attack vector explanation
- Root cause identified
- Affected code locations
- Severity assessment

**Q:** Proceed with fix?

**Wait for explicit approval.**

---

## Phase 2: Evidence-Driven Scan

**Goal:** Find all vulnerable code

**ASSUMPTION:** Similar patterns likely exist elsewhere.

**Parallel operations:**

**Group 1 - Direct matches:**
- Grep vulnerable function/pattern
- Grep similar variable names
- Grep related endpoints

**Group 2 - Common patterns:**
- Grep `$_GET|$_POST|$_REQUEST` (unsanitized input)
- Grep `wp_ajax_` (AJAX handlers)
- Grep `register_rest_route` (REST endpoints)
- Grep `$wpdb->query|$wpdb->get_` (SQL queries)
- Grep `echo|print` (unescaped output)

**Group 3 - WordPress security:**
- Grep `wp_verify_nonce|check_ajax_referer` (nonce checks)
- Grep `current_user_can` (capability checks)
- Grep `sanitize_|esc_` (sanitization/escaping)

**Output:** List of all vulnerable locations

See `references/wp-security-checklist.md` for complete patterns.

---

## Phase 3: Solution Options

**Goal:** Identify fix approaches

**For each vulnerable location:**

**Option 1: WordPress native (preferred):**
- Use WP functions (`sanitize_*`, `esc_*`, `wp_verify_nonce`, `current_user_can`)
- Leverage WP APIs (Settings API, REST API with permissions)
- Follow WP security patterns

**Option 2: Defense in depth:**
- Input validation (reject invalid)
- Sanitization (clean input)
- Escaping (safe output)
- Nonces (CSRF protection)
- Capability checks (authorization)

**Option 3: Structural changes:**
- Remove vulnerable feature (if not critical)
- Redesign flow (eliminate attack vector)
- Rate limiting (mitigate impact)

**Tradeoffs:**
- Breaking changes vs security
- Performance impact
- Complexity added
- Maintenance burden

**ASSUMPTION:** Long-term maintenance - keep fixes simple and maintainable.

See `references/wordpress-patterns.md` for WP-specific solutions.

---

## ⚠️ QUALITY GATE 2: Approach Approval

**Present solution:**
- Recommended approach
- Why this approach (reasoning)
- Alternatives considered
- Tradeoffs explained
- Breaking changes (if any)
- Code examples

**Q:** Approve this approach?

**Wait for explicit approval.**

---

## Phase 4: Simulated Peer Review

**Goal:** Validate approach before implementation

**Review as 4 experts:**

1. **Security Specialist:**
   - Does this completely fix the vulnerability?
   - Any bypass scenarios?
   - Defense in depth adequate?

2. **WordPress Expert:**
   - Following WP best practices?
   - Using native functions correctly?
   - Backwards compatible?

3. **Senior Developer:**
   - Code quality acceptable?
   - Performance impact reasonable?
   - Maintainable long-term?

4. **QA Engineer:**
   - Testable?
   - Risk of regressions?
   - Edge cases covered?

**Reconcile findings:**
- Agreements → confidence
- Disagreements → investigate further
- Red flags → revise approach

**Output:** Validated approach or revised plan

---

## Phase 5: Worktree Setup

**Goal:** Isolate work

**ASSUMPTION:** Production code - use worktree to avoid disrupting active development.

```bash
git fetch origin
REPO=$(basename $(git rev-parse --show-toplevel))
VULN_TYPE="xss" # or sqli, csrf, etc.
git worktree add ../${REPO}-fix-${VULN_TYPE} -b fix/${VULN_TYPE}-vulnerability
cd ../${REPO}-fix-${VULN_TYPE}
```

**All subsequent work in this worktree.**

---

## Phase 6: Implementation

**Goal:** Fix all vulnerable locations

**For each location:**
1. Read file
2. Identify vulnerable code
3. Apply approved fix
4. Verify fix correct

**WordPress security patterns:**

**XSS (escape output):**
```php
// Before: echo $user_input;
// After: echo esc_html($user_input);
```

**SQLi (use prepared statements):**
```php
// Before: $wpdb->query("DELETE FROM table WHERE id = $id");
// After: $wpdb->query($wpdb->prepare("DELETE FROM table WHERE id = %d", $id));
```

**CSRF (verify nonce):**
```php
// Before: if ($_POST['action']) { ... }
// After: if (check_ajax_referer('my_action', 'nonce', false)) { ... }
```

**Auth bypass (check capabilities):**
```php
// Before: if (is_user_logged_in()) { ... }
// After: if (current_user_can('manage_options')) { ... }
```

**Per-file commits (small, logical):**
```bash
git add inc/ajax.php
git commit -m "security: fix XSS in AJAX handler

- Add nonce verification
- Escape output properly
- Sanitize user input

Fixes: [VULN-ID]
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

**STOP if:** Encounter unexpected code or unsure about fix

See `references/common-vulnerabilities.md` for more patterns.

---

## ✅ QUALITY GATE 3: Self-Check

**Before delivering:**

- [ ] All vulnerable locations fixed
- [ ] No new vulnerabilities introduced
- [ ] WordPress security functions used correctly
- [ ] Nonces verified where needed
- [ ] Capabilities checked appropriately
- [ ] Input sanitized
- [ ] Output escaped
- [ ] SQL queries use prepared statements
- [ ] No breaking changes (or documented)
- [ ] Code follows WP standards
- [ ] Commits focused and reviewable

**STOP if:** Any item unchecked

---

## Phase 7: Security Validation

**Goal:** Prove vulnerability fixed

**Test attack vector:**
1. Attempt original exploit
2. Try bypass scenarios
3. Test edge cases
4. Verify defensive measures work

**Regression testing:**
- [ ] Existing functionality works
- [ ] No new errors
- [ ] Performance acceptable
- [ ] Backwards compatible

**Automated testing (if available):**
```bash
composer test
npm test
wp-env run tests-cli "wp plugin list"
```

**STOP if:** Vulnerability still exploitable or regressions found

---

## Phase 8: Deliverables

**Goal:** Push and create PR

**Use GitHub CLI:**
```bash
git push -u origin fix/${VULN_TYPE}-vulnerability

gh pr create \
  --base dev \
  --title "Security: Fix [VULN_TYPE] vulnerability" \
  --body "$(cat <<'EOF'
## Summary

Fixes [VULN_TYPE] vulnerability in [component].

## Vulnerability Details

**Type:** [XSS/SQLi/CSRF/etc.]
**Severity:** [Critical/High/Medium/Low]
**Attack Vector:** [How to exploit]
**Impact:** [What attacker can do]
**Affected:** [Versions/files]

## Root Cause

[Technical explanation]

## Fix Applied

- [Change 1]
- [Change 2]
- [Change 3]

## Security Validation

- ✅ Original exploit no longer works
- ✅ Bypass scenarios tested
- ✅ Defense in depth applied
- ✅ No regressions introduced
- ✅ WordPress security functions used correctly

## Testing

**Attack vector tested:**
1. [Step 1]
2. [Step 2]
3. **Result:** Exploit blocked

**Regression testing:**
- ✅ Existing functionality works
- ✅ No new errors
- ✅ Performance acceptable
- ✅ Backwards compatible

## Disclosure

**Status:** [Private/Public/Coordinated]
**Reported by:** [Researcher name/platform]
**Date:** [YYYY-MM-DD]

## References

- [Security report link]
- [Related CVE if applicable]
- [WordPress security documentation]

Generated with security-fix skill v2.0.0

**⚠️ This PR contains security fixes. Review carefully before merging.**
EOF
)"
```

**Include:**
- Vulnerability summary (sanitized if still private)
- Fix details
- Security validation steps
- Testing results
- Disclosure status

**⚠️ Mark PR as security-sensitive:**
- Limit reviewer access if not publicly disclosed
- Don't leak exploit details in commits
- Coordinate disclosure timeline

Return PR URL to user.

See `templates/security-advisory.md` for disclosure templates.

---

## Phase 9: Cleanup

**After PR merged:**
```bash
cd /path/to/original/directory
git worktree remove ../${REPO}-fix-${VULN_TYPE}
git branch -d fix/${VULN_TYPE}-vulnerability
```

---

## Error Handling

**Cannot reproduce vulnerability:**
- Request more details from reporter
- Try different environment
- Check prerequisites (auth, versions)
- Document findings, ask user to decide

**Peer review reveals flaw:**
- Revise approach
- Go back to Quality Gate 2
- Don't proceed until validated

**Fix breaks functionality:**
- Identify what broke
- Balance security vs compatibility
- Consider alternative approach
- Document breaking changes if necessary

**User rejects approach:**
- Understand concerns
- Present alternatives
- Explain security tradeoffs
- Find compromise or defer

---

## WordPress Security Checklist

**Input Validation:**
- [ ] `sanitize_text_field()` for text
- [ ] `sanitize_email()` for emails
- [ ] `sanitize_url()` for URLs
- [ ] `absint()` for integers
- [ ] `sanitize_key()` for keys

**Output Escaping:**
- [ ] `esc_html()` for HTML
- [ ] `esc_attr()` for attributes
- [ ] `esc_url()` for URLs
- [ ] `esc_js()` for JavaScript
- [ ] `wp_kses()` for allowed HTML

**Authorization:**
- [ ] `current_user_can()` capability checks
- [ ] `wp_verify_nonce()` or `check_ajax_referer()` for CSRF
- [ ] `is_admin()` for admin-only features

**Database:**
- [ ] `$wpdb->prepare()` for all queries
- [ ] Never use user input directly in queries
- [ ] Use `%d`, `%s`, `%f` placeholders

See `references/wp-security-checklist.md` for complete list.

---

## References

Detailed guidance:
- `references/common-vulnerabilities.md` - Vulnerability patterns + fixes
- `references/wordpress-patterns.md` - WP-specific security patterns
- `references/cvss-scoring.md` - Severity scoring guide
- `references/defense-in-depth.md` - Layered security approach
- `references/security-testing.md` - Testing procedures
- `templates/security-advisory.md` - Disclosure templates
- `templates/security-validation-steps.md` - Validation checklist

---

## Notes

- Security fixes are time-sensitive (prioritize)
- Never skip quality gates
- Test attack vector before and after
- Use WordPress native functions
- Defense in depth (multiple layers)
- Document breaking changes
- Coordinate disclosure if private
- Small, focused commits
- Write for long-term maintenance
