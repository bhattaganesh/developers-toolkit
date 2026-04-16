# Modular Security Audit Skill

Comprehensive feature-by-feature security audit for WordPress plugins using 5-phase methodology with expert validation and GitHub issue automation.

**Base directory:** Resolved automatically from skill installation path

---

## Overview

Systematic security assessment that:
- Breaks plugin into logical modules (6-12 modules typical)
- Audits each module through 5 phases
- Validates findings with multi-expert review
- Creates actionable GitHub issues
- Tracks progress in master issue

**Philosophy:** Slow, thorough, high-confidence audits that minimize false positives and discover real exploitable vulnerabilities.

---

## ⚠️ CRITICAL: Context Window Management

Claude Code has a **200K token limit**. This skill WILL EXCEED this limit on medium+ plugins without proper management.

### Token Budget (Per Module)

| Phase | Tokens | Mitigation Strategy |
|-------|--------|---------------------|
| Skill prompt loaded | 8K | One-time cost |
| Phase 1: Discovery | 5-10K | **Save grep outputs to temp files, don't load into context** |
| Phase 2: Code Review | 30-50K | **Read files selectively, use grep -A/-B for context only** |
| Phase 3: Threat Modeling | 10-15K | **Load only vulnerability summaries, not full code** |
| Phase 4: Expert Validation | 15-20K | **Summarize findings, drop code blocks after validation** |
| Phase 5: Documentation | 5-10K | **Write to files, don't reload reports** |
| **Available per module** | **~150K** | **Must stay under to leave headroom** |

### Plugin Size Detection

**Detect size in Phase 0:**

Use Glob tool to count PHP files:
```
Glob: pattern="**/*.php"
```
Count results, then classify:
- **<50 files**: SMALL (<10K LOC)
- **50-200 files**: MEDIUM (10-50K LOC)
- **>200 files**: LARGE (>50K LOC)

### Strategies by Size

#### SMALL Plugins (<50 files, <10K LOC)
- ✅ Standard execution
- Can load files into context as needed
- No special handling required

#### MEDIUM Plugins (50-200 files, 10-50K LOC)
**Mandatory practices:**

1. **Use Grep tool with file output for large result sets:**
```
# ✅ Example: Find all database queries
Grep:
  pattern="\$wpdb->query"
  path="lib/"
  output_mode="files_with_matches"

# Then read specific files to verify vulnerabilities
Read: file_path="lib/controllers/vulnerable_controller.php"
```

**Alternative for very large results - use Write tool:**
```
# If Grep returns 500+ matches, save to external file:
1. Grep: pattern="\$wpdb->query" path="lib/" output_mode="content"
2. Write: file_path="/tmp/db-queries.txt" content="[grep results]"
3. Report summary: "Found 500 database queries, stored in /tmp/db-queries.txt"
4. Read sample lines from file to show in report
```

2. **Read files ONLY when confirmed vulnerable:**
```markdown
Phase 1: Grep finds 50 files with wp_ajax_
Phase 2: Read only the 8 files that lack check_nonce()
```

3. **Summarize between phases:**
```json
// After Phase 2, create summary:
{
  "V001": {"file": "controller.php:45", "type": "CSRF", "severity": "HIGH"},
  "V002": {"file": "model.php:120", "type": "SQLi", "severity": "CRITICAL"}
}
// Save to /tmp/module-N-findings.json
// Don't keep full code in context
```

4. **Write reports immediately, don't reload:**
```markdown
After each phase:
- Write report to /tmp/module-N-phase-M-report.md
- Don't read it back unless user requests
```

#### LARGE Plugins (>200 files, >50K LOC)
**Aggressive chunking required:**

1. **Split large modules into chunks:**
```markdown
Module 3: File Uploads (25 files detected)
Split into:
  - Chunk 3A: Upload Controllers (files 1-12)
  - Chunk 3B: Storage Handlers (files 13-25)
```

2. **Process chunks independently:**
- Run Phases 1-4 on Chunk 3A
- Write findings to `/tmp/module-3a-findings.json`
- Clear context (conceptually - move to next chunk)
- Run Phases 1-4 on Chunk 3B
- Combine findings in Phase 5

3. **Use background tasks for reports:**
```markdown
# Generate large reports in background
Write → /tmp/module-3-report.md (don't reload)
```

### Size Warning System

**Display in Phase 0 after detection:**

```markdown
⚠️ MEDIUM Plugin Detected (127 PHP files)

Context management strategy:
✓ Grep outputs → temp files
✓ Selective file reading
✓ Summarization between phases
✓ Immediate report externalization

Expected: 45-60 hours (6-8 modules × 7.5h/module)
```

```markdown
🔴 LARGE Plugin Detected (342 PHP files)

Aggressive context management:
✓ Module chunking (15-20 chunks)
✓ Background report generation
✓ Progressive disclosure
✓ Minimal context retention

Expected: 80-120 hours (20 modules × 6h/module)

Continue? [yes/no]
```

### Universal Best Practices (ALL Sizes)

1. **Use Glob instead of find:**
```markdown
# ❌ find lib/controllers -name "*.php"
# ✅ Glob: lib/controllers/**/*.php
```

2. **Use Grep tool instead of bash grep:**
```markdown
# ❌ Bash: grep -rn "pattern" lib/ > /tmp/output.txt
# ✅ Grep tool with output_mode and save to file
```

3. **Use Write tool instead of bash redirection:**
```markdown
# ❌ Bash: echo "content" > /tmp/report.md
# ✅ Write tool with file_path parameter
```

4. **Use Read tool selectively:**
```markdown
# Only read confirmed vulnerable files
# Use offset/limit for large files
```

5. **Drop code after each phase:**
- Analyze → Extract details → Drop code
- Next phase loads ONLY summaries

---

## Autonomy Model

**User approval required for:**
1. **Phase 0 completion** - Approve audit plan before starting
2. **CRITICAL vulnerabilities** - Notify immediately if found
3. **Before Phase 5** - Batch approve all GitHub issues before creation

**Autonomous execution for:**
- All discovery and code review (Phases 1-4)
- Progress updates to master issue
- Module transitions
- Report generation

**Override:**
- User can say **"run fully autonomous"** to skip ALL approval gates except initial plan
- User can say **"pause after each module"** for more control

**Default:** Autonomous with 3 approval gates

---

## Progress Tracking

**Use TodoWrite to show module progress:**

```json
{
  "todos": [
    {"content": "Module 1: Auth & Authorization", "status": "completed", "activeForm": "Completed Module 1 (3 vulns found)"},
    {"content": "Module 2: Payment Processing", "status": "completed", "activeForm": "Completed Module 2 (2 vulns found)"},
    {"content": "Module 3: File Upload - Phase 2/5", "status": "in_progress", "activeForm": "Auditing Module 3 Phase 2: Code Review"},
    {"content": "Module 4: External APIs", "status": "pending", "activeForm": "Pending Module 4"},
    {"content": "Module 5: Booking Logic", "status": "pending", "activeForm": "Pending Module 5"}
  ]
}
```

**Provide phase completion summaries:**

```markdown
✅ Phase 2 Complete - Module 3: File Uploads
───────────────────────────────────────────
• Files analyzed: 18 of 18 (100%)
• Potential vulnerabilities: 4 flagged for validation
• Time elapsed: 2.1 hours
• Next: Phase 3 - Threat Modeling (est. 1 hour)
```

**Show time estimates vs actual:**

```markdown
Module 3 Progress:
├─ Phase 1: Discovery ✅ (1.2h / est. 1-2h)
├─ Phase 2: Code Review ✅ (2.1h / est. 2-3h)
├─ Phase 3: Threat Modeling 🔄 (0.3h / est. 1h)
├─ Phase 4: Expert Validation ⏳
└─ Phase 5: Documentation ⏳
```

---

## Error Handling & Recovery

**Common errors and solutions:**

### 1. GitHub CLI Not Configured

**Error:** `gh: command not found` or `gh auth status` fails

**Solutions:**
- **Option A:** Skip GitHub integration, create local markdown reports only
- **Option B:** Ask user to run `gh auth login` first
- **Option C:** Use manual issue creation (provide issue template for user to copy-paste)

**Detection:**
```
# Test at start of Phase 0
Bash: command="gh auth status" description="Check GitHub CLI authentication"

# If fails, inform user:
"GitHub CLI not configured. Using local reports only. To enable GitHub integration, run: gh auth login"
```

### 2. Plugin Directory Structure Varies

**Error:** Grep returns no results for standard paths (`lib/controllers/`, `includes/`, etc.)

**Solutions:**
- **Step 1:** Use Glob to find actual structure:
  ```
  Glob: pattern="**/*controller*.php"
  Glob: pattern="**/*model*.php"
  Glob: pattern="**/admin/**/*.php"
  ```
- **Step 2:** Identify actual controller/model directories
- **Step 3:** Update search paths dynamically
- **Step 4:** Document structure in Phase 0 report

**Common variations:**
- `lib/` vs `includes/` vs `src/` vs `app/`
- `controllers/` vs `admin/` vs `classes/`
- Flat structure (all in root)

### 3. Grep Returns Excessive Matches

**Error:** 500+ results, context window risk

**Solutions:**
- **Phase 1 (Discovery):** Use `output_mode="files_with_matches"` first (file list only)
- **Phase 2 (Analysis):** Read specific files after filtering
- **Large result sets:** Use Write tool to save to `/tmp/`, then summarize
- **Prioritize:** Focus on controllers/admin files first, skip vendor/tests

**Example workflow:**
```
1. Grep: pattern="\$wpdb->query" output_mode="files_with_matches"
   Result: 50 files

2. Prioritize: lib/controllers/ (10 files) > lib/helpers/ (20 files) > views (20 files)

3. Grep specific directory: pattern="\$wpdb->query" path="lib/controllers/" output_mode="content"

4. If still too large: Write results to /tmp/queries.txt, analyze sample
```

### 4. Unable to Access Local WordPress Install

**Error:** Cannot test PoC exploits

**Solutions:**
- **Continue without testing:** Mark findings as "Needs verification"
- **Static analysis only:** Use confidence scoring (8+/10 only)
- **Ask user:** Can you test this PoC? [provide steps]
- **Code-only validation:** If pattern is clear, report without live test

### 5. Module Takes Too Long (>10 hours)

**Error:** Exceeding time estimates significantly

**Solutions:**
- **Check scope:** Is module too large? Split into 2 modules
- **Check approach:** Using Bash instead of tools? Optimize
- **Check depth:** Going too deep? Stick to surface-level patterns
- **Report partial:** Complete phases 1-3, mark phase 4-5 as "In Progress"
- **User approval:** "Module 3 taking longer than expected. Continue or split?"

### 6. False Positive Fatigue

**Error:** Too many low-confidence findings

**Solutions:**
- **Raise threshold:** Only report confidence ≥ 9/10 (instead of 8/10)
- **Focus severity:** Skip MEDIUM, report only HIGH/CRITICAL
- **Expert validation:** Add extra validation round
- **Pattern matching:** If similar finding was rejected before, skip

### 7. Git/GitHub Errors

**Common issues:**
- `fatal: not a git repository` → Ask for repo URL, clone first
- `gh: HTTP 404` → Repo access issue, check permissions
- `git push rejected` → Branch protection, ask user to disable temporarily

---

## Phase 0: Planning & Module Definition

**Goal:** Define audit scope and module boundaries

### Step 1: Understand Plugin Architecture

**Ask user:**
1. **Plugin repository URL?**
2. **Plugin type?** (Core, Pro, Addon, Theme)
3. **Local installation path?**
4. **Base branch?** (main, dev, production)
5. **Priority areas?** (high-risk features, user-reported issues, external integrations)

### Step 2: Map Plugin Structure

**Use Glob and Grep tools:**
```
# Analyze plugin architecture (count files)
Glob: pattern="lib/controllers/**/*.php"
Glob: pattern="lib/models/**/*.php"
Glob: pattern="lib/helpers/**/*.php"

# Identify entry points
Grep: pattern="wp_ajax_" path="lib/" output_mode="count"
Grep: pattern="register_rest_route" path="lib/" output_mode="count"
Grep: pattern="add_action.*admin" path="lib/" output_mode="count"
```

**Note:** Count Glob results to determine file counts. If directory structure differs (e.g., `includes/` instead of `lib/`), adapt paths dynamically (see Error Handling section).

### Step 2.3: Test Environment Setup (Required - CRITICAL)

**Goal:** Prepare local WordPress installation for exploitability testing

**Time:** 10-15 minutes (one-time setup)

**⚠️ CRITICAL REQUIREMENT:**

This step is **MANDATORY** for high-quality security audits. Without a proper test environment:
- ❌ Cannot verify vulnerabilities are exploitable (theoretical findings only)
- ❌ Cannot test proof-of-concepts safely
- ❌ Cannot validate fixes work correctly
- ❌ Cannot document attack paths with real evidence
- ❌ **False positive rate increases from <5% to 20-30%**

**STOP and guide the user through setup before proceeding to Phase 1.**

**Why This Matters:**
- Verify vulnerabilities are exploitable (not just theoretical)
- Test proof-of-concepts safely
- Validate fixes work correctly
- Document attack paths with real evidence
- Reduce false positives by 70%+

**Setup Checklist:**

```bash
# 1. WordPress Installation
[ ] WordPress 6.x (latest stable)
[ ] Plugin installed and activated
[ ] Test database created
[ ] Admin account created

# 2. Debug Configuration
# Add to wp-config.php:
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
define('SCRIPT_DEBUG', true);
define('SAVEQUERIES', true);

# 3. Query Monitoring
[ ] Install Query Monitor plugin
[ ] Install Debug Bar plugin (optional)
[ ] Access wp-content/debug.log for errors

# 4. Browser Tools
[ ] Chrome DevTools open (Network, Console tabs)
[ ] Browser extensions installed:
    - EditThisCookie (for cookie manipulation)
    - Proxy SwitchyOmega (for Burp Suite)
[ ] Or: Playwright MCP for automation
[ ] Or: Chrome DevTools MCP for programmatic access

# 5. Database Access
[ ] phpMyAdmin OR TablePlus installed
[ ] Can view/query database tables
[ ] Can check query logs

# 6. File System Access
[ ] Can edit plugin files locally
[ ] Can view error logs
[ ] Can upload test files

# 7. Network Inspection
[ ] Burp Suite (optional, for advanced testing)
[ ] OR Chrome DevTools Network tab
[ ] OR Playwright network interception
```

**For SQL Injection Testing:**
```bash
# Enable MySQL query logging
# Add to my.cnf or my.ini:
[mysqld]
general_log = 1
general_log_file = /var/log/mysql/query.log

# Or enable in MySQL:
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';

# View queries:
SELECT * FROM mysql.general_log ORDER BY event_time DESC LIMIT 50;
```

**For XSS Testing:**
```javascript
// Test payload (safe to use in local environment)
<script>alert('XSS-Test-' + document.domain)</script>

// Check if executes:
// - Open browser console
// - Look for alert popup
// - Check for blocked by CSP
```

**For CSRF Testing:**
```html
<!-- Create test CSRF page (save as csrf-test.html) -->
<!DOCTYPE html>
<html>
<body>
<h1>CSRF Test</h1>
<form id="csrf" action="http://localhost:8881/wp-admin/admin-ajax.php" method="POST">
    <input type="hidden" name="action" value="delete_booking">
    <input type="hidden" name="id" value="1">
</form>
<script>document.getElementById('csrf').submit();</script>
</body>
</html>
```

**Using Playwright MCP (Advanced):**
```javascript
// Automate XSS testing
await page.goto('http://localhost:8881/wp-admin/...');
await page.fill('#input-field', '<script>alert(1)</script>');
await page.click('#submit');
// Check if script executes or is escaped
```

**Using Chrome DevTools MCP (Advanced):**
- Take screenshots of exploits
- Inspect network requests
- Monitor console errors
- Check DOM for injected content
- Verify proper escaping

**Validation:**
```bash
# Test that setup is working:
# 1. Visit plugin admin page
[ ] Loads without errors

# 2. Check debug log
tail -f wp-content/debug.log

# 3. Execute test query
# Visit: /?test_param=<script>alert(1)</script>
[ ] Can see request in Network tab
[ ] Can see query in MySQL log (if applicable)
[ ] Can see errors in debug.log

# 4. Test AJAX endpoint
curl http://localhost:8881/wp-admin/admin-ajax.php \
  -d "action=test" \
  -H "Cookie: wordpress_logged_in_xxx=..."
```

**When Setup Cannot Be Completed:**

If user explicitly states they **cannot** set up a test environment (e.g., no local access, security Capability restrictions):
- Document limitation in audit scope
- Proceed with code-only review (Phase 4.5 will mark findings as "Unable to verify exploitability")
- **Inform user:** Audit quality reduced, false positive rate may increase
- Mark all findings as "REQUIRES MANUAL VERIFICATION"

**Minimum Acceptable Setup:**
- WordPress installation with plugin installed (REQUIRED)
- WP_DEBUG enabled (REQUIRED)
- Access to debug.log (REQUIRED)
- Browser DevTools OR Playwright/Chrome MCP (at least one REQUIRED)

**Optional But Recommended:**
- MySQL query logging (for SQLi testing)
- Query Monitor plugin (for performance/query analysis)
- Burp Suite (for advanced network inspection)

**Integration with Phases:**
- **Phase 2 (Code Review):** Access files locally for line-by-line review
- **Phase 4.5 (Exploitability Verification):** Test all PoCs in this environment
- **Phase 5 (Documentation):** Screenshots and logs as evidence

---

### Step 2.4: Environment Verification & Automated Setup (Required)

**Goal:** Verify test environment is ready OR automatically configure it

**⚠️ MANDATORY VERIFICATION - Execute before Phase 1**

**New Approach:** Instead of guiding the user, **I will configure everything automatically** using WP-CLI and file editing.

#### What I Need From User

Ask the user **ONCE** for:

```markdown
**Test Environment Setup**

To configure your test environment automatically, I need:

1. **WordPress Installation Path**
   - Example: `/path/to/your-wordpress-site`
   - Or: Confirm WP-CLI is available (`wp --info`)

2. **WordPress Admin Credentials** (for verification only)
   - Admin username: [ask]
   - Admin password: [ask]
   - Or: Confirm I can use `wp-cli` without auth

3. **Database Access** (for MySQL query logging)
   - Database host: [usually localhost]
   - Database name: [ask]
   - MySQL root password: [ask if needed for query logging]

With this information, I will:
✅ Install Query Monitor plugin automatically
✅ Configure WP_DEBUG in wp-config.php
✅ Enable MySQL query logging
✅ Verify everything is working
✅ Then proceed to Phase 1

**No manual setup required from you.**
```

#### Automated Setup Execution

Once user provides the information above, execute automated setup:

```markdown
**Test Environment Verification**

Please confirm the following are set up:

1. **WordPress Installation**
   - [ ] WordPress 6.x installed locally
   - [ ] Plugin installed and activated
   - [ ] Can access wp-admin
   - **Local installation path:** [Ask user to provide]

2. **Debug Configuration**
   - [ ] WP_DEBUG enabled in wp-config.php
   - [ ] WP_DEBUG_LOG enabled
   - [ ] Can access wp-content/debug.log
   - **Need help?** I can provide exact wp-config.php code

3. **Database Access**
   - [ ] Can connect to MySQL/MariaDB
   - [ ] Can view plugin's database tables
   - [ ] Can run SQL queries
   - **Need help?** I can guide you through database setup

4. **Browser Tools**
   - [ ] Chrome DevTools available OR
   - [ ] Playwright MCP configured OR
   - [ ] Chrome DevTools MCP configured
   - **Need help?** I can explain how to set up each option

5. **Optional (Recommended) Components**
   - [ ] MySQL query logging enabled (for SQLi testing)
   - [ ] Query Monitor plugin installed (for debugging)
   - [ ] Can edit plugin files locally
   - **Need help?** I can provide step-by-step instructions
```

#### Automated Setup Commands

**I will execute these automatically:**

**Step 1: Verify WP-CLI Access**
```bash
# Navigate to WordPress installation
cd /path/to/wordpress

# Verify WP-CLI works
wp --info

# If WP-CLI not found, install it:
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
```

**Step 2: Install Query Monitor Plugin**
```bash
# Install and activate Query Monitor
wp plugin install query-monitor --activate --path=/path/to/wordpress

# Verify installation
wp plugin list --status=active --path=/path/to/wordpress | grep query-monitor
```

**Step 3: Configure WP_DEBUG (Automated)**
```bash
# Read current wp-config.php
WP_CONFIG="/path/to/wordpress/wp-config.php"

# Check if WP_DEBUG already exists
if ! grep -q "define( 'WP_DEBUG'" "$WP_CONFIG"; then
    # Add WP_DEBUG configuration before "/* That's all" line
    sed -i.bak "/\/\* That's all/i\\
define('WP_DEBUG', true);\\
define('WP_DEBUG_LOG', true);\\
define('WP_DEBUG_DISPLAY', false);\\
define('SCRIPT_DEBUG', true);\\
define('SAVEQUERIES', true);\\
" "$WP_CONFIG"

    echo "✅ WP_DEBUG configuration added"
else
    echo "ℹ️ WP_DEBUG already configured"
fi
```

**Step 4: Enable MySQL Query Logging (Automated)**
```bash
# Enable query logging via MySQL CLI
mysql -u root -p <<EOF
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';
SELECT 'Query logging enabled' AS status;
EOF

# Or using wp-cli with database credentials
wp db query "SET GLOBAL general_log = 'ON';" --path=/path/to/wordpress
wp db query "SET GLOBAL log_output = 'TABLE';" --path=/path/to/wordpress
```

**Step 5: Verify Setup (Automated)**
```bash
# Check WP_DEBUG is enabled
wp config get WP_DEBUG --path=/path/to/wordpress

# Check Query Monitor is active
wp plugin status query-monitor --path=/path/to/wordpress

# Check debug.log exists and is writable
touch /path/to/wordpress/wp-content/debug.log
chmod 644 /path/to/wordpress/wp-content/debug.log

# Test MySQL query logging
wp db query "SELECT 'Test query' AS test;" --path=/path/to/wordpress
wp db query "SELECT * FROM mysql.general_log ORDER BY event_time DESC LIMIT 1;" --path=/path/to/wordpress

echo "✅ All setup complete and verified"
```

#### Decision Point

After automated setup:

**Option A: Setup Complete ✅**
- All automated setup commands executed successfully
- Verification passed (WP_DEBUG enabled, Query Monitor active, MySQL logging enabled)
- Proceed to Step 2.5 (Automated Security Pre-Scan)

**Option B: User Cannot Provide Access ⚠️**
- User explicitly states they **cannot** provide WordPress path/credentials
- Ask: **"Without WordPress access, I cannot verify vulnerabilities are exploitable. This will reduce audit quality by 70%+ and increase false positives. Are you certain you cannot provide access to a local WordPress installation?"**
- If user confirms: Document limitation, proceed with code-only review
- If user wants to provide access: Collect information and run automated setup

**Option C: Automated Setup Failed 🔧**
- Setup commands encountered errors (WP-CLI not available, permission denied, etc.)
- Diagnose error and attempt fix
- If unfixable: Offer manual setup guidance OR proceed with limitations documented

#### Enforcement & Verification

**After automated setup, verify everything works:**

```bash
# Final verification checklist
echo "🔍 Final Setup Verification..."

# 1. WP-CLI works
wp --info --path=/path/to/wordpress && echo "✅ WP-CLI accessible" || echo "❌ WP-CLI failed"

# 2. Query Monitor installed and active
wp plugin status query-monitor --path=/path/to/wordpress | grep "Status: Active" && echo "✅ Query Monitor active" || echo "❌ Query Monitor not active"

# 3. WP_DEBUG enabled
grep "define( 'WP_DEBUG', true )" /path/to/wordpress/wp-config.php && echo "✅ WP_DEBUG enabled" || echo "❌ WP_DEBUG not enabled"

# 4. Debug log writable
touch /path/to/wordpress/wp-content/debug.log && echo "✅ Debug log writable" || echo "❌ Debug log not writable"

# 5. MySQL query logging enabled
wp db query "SHOW VARIABLES LIKE 'general_log';" --path=/path/to/wordpress | grep "ON" && echo "✅ MySQL query logging enabled" || echo "⚠️ MySQL query logging failed (optional)"

echo ""
echo "📊 Setup Status Summary:"
echo "─────────────────────────────"
```

**Gate Check Before Phase 1:**

```markdown
⚠️ **GATE CHECK - Test Environment Setup**

Automated setup completed:
- [✅/❌] WP-CLI accessible
- [✅/❌] Query Monitor plugin installed and active
- [✅/❌] WP_DEBUG enabled in wp-config.php
- [✅/❌] Debug log writable
- [✅/⚠️] MySQL query logging enabled (optional)
- [✅/⚠️] Browser DevTools OR MCP available

Status: [PASS ✅ | FAIL ❌ | PARTIAL ⚠️]

If PASS (all required ✅): Proceed to Step 2.5
If PARTIAL (optional items missing): Proceed to Step 2.5 with documented limitations
If FAIL (required items missing): Re-run automated setup OR document limitations
```

**Never silently proceed to Phase 1 without completing automated setup.**

---

### Step 2.5: Automated Security Pre-Scan (Optional)

**Goal:** Run automated tools to identify quick wins and known CVEs

**Time:** 5-10 minutes

This step is **optional** and tools are not required. If tools aren't available, skip to Step 3.

#### Dependency Audit (Recommended)

Check for known CVEs in dependencies:

```bash
# PHP dependencies (Composer)
cd /path/to/plugin
composer audit --format=json > /tmp/composer-audit.json 2>&1 || echo "Composer audit not available"

# JavaScript dependencies (npm)
npm audit --json > /tmp/npm-audit.json 2>&1 || echo "npm audit not available"
```

**Interpret results:**
- **HIGH/CRITICAL vulnerabilities:** Add to Phase 1 discovery report
- **MEDIUM vulnerabilities:** Review during Phase 2
- **LOW vulnerabilities:** Document but may defer

#### Semgrep Static Analysis (Recommended)

Run WordPress-specific security patterns:

```bash
# Install semgrep if not present (skip if unavailable)
pip3 install semgrep 2>/dev/null || echo "Semgrep not available, skipping"

# Run WordPress security rules
cd /path/to/plugin

# Detect Semgrep config path dynamically
if [ -f "$HOME/.claude/skills/modular-security-audit/.semgrep/wordpress-security.yml" ]; then
    SEMGREP_CONFIG="$HOME/.claude/skills/modular-security-audit/.semgrep/wordpress-security.yml"
else
    # Fallback: search common skill locations
    SEMGREP_CONFIG=$(find ~/.claude/skills -name "wordpress-security.yml" 2>/dev/null | head -1)
fi

if [ -n "$SEMGREP_CONFIG" ]; then
    semgrep --config="$SEMGREP_CONFIG" --json > /tmp/semgrep-results.json lib/ includes/ 2>/dev/null
else
    echo "Semgrep WordPress rules not found, skipping"
fi
```

**Interpret results:**
- **ERROR severity:** Likely real vulnerabilities, add to discovery report
- **WARNING severity:** Review during code review phase
- Focus on HIGH confidence findings first

#### Integration with 5-Phase Audit

**Phase 1 (Discovery):**
- Include dependency audit findings
- Include Semgrep ERROR-level findings
- Mark as "Pre-scan identified, needs validation"

**Phase 2 (Code Review):**
- Manually verify automated findings
- Use Semgrep results as hints for where to look
- Don't trust automation 100% - always read code

**Phase 4 (Expert Validation):**
- Automated findings still require expert panel review
- Confidence scoring based on manual verification, not tool output

**Graceful Degradation:**
If tools aren't available:
- Proceed with manual audit (Phases 1-5)
- No impact on audit quality
- May take 10-20% longer without automated hints

**Tool Installation Notes:**
```bash
# Semgrep (Python)
pip3 install semgrep

# Composer audit (built-in to Composer 2.4+)
composer self-update

# npm audit (built-in to npm 6+)
npm install -g npm@latest
```

### Step 3: Define Modules

**Module Classification Criteria:**
- **Feature cohesion:** Related functionality grouped together
- **Security impact:** High-risk features get own modules
- **Attack surface:** Entry points, external APIs, file operations
- **Business logic:** Payment, authentication, authorization

**Example Module Structure:**
1. Authentication & Authorization (P0 - CRITICAL)
2. Payment Processing (P0 - CRITICAL)
3. File Upload & Management (P1 - HIGH)
4. External Integrations (P1 - HIGH)
5. Booking/Cart Logic (P2 - MEDIUM)
6. Configuration & Settings (P2 - MEDIUM)
7. Reporting & Analytics (P3 - LOW)

**Priority Classification:**
- **P0 (CRITICAL):** Auth, payments, RCE-prone features
- **P1 (HIGH):** File ops, external APIs, PII handling
- **P2 (MEDIUM):** Business logic, CRUD operations
- **P3 (LOW):** Read-only, reporting, UI-only features

### Step 4: Create Master Tracking Issue

```bash
gh issue create \
  --title "[Security Audit] Master Tracking - [Plugin Name]" \
  --body-file /tmp/master-tracking-template.md \
  --label "security,audit"
```

**Template:** `references/master-tracking-template.md`

### Step 5: Create Audit Plan Document

Write plan to `/tmp/audit-plan-[plugin-name].md`:
- Module breakdown
- Priority order
- Estimated timeline (6-8 hours per module)
- Known issues to verify
- Success criteria

**Wait for user approval before proceeding.**

---

## Phase 1: Discovery (Per Module)

**Goal:** Map attack surface and entry points

**Time:** 1-2 hours per module

### Entry Point Discovery

**Use Grep tool - run searches in parallel where possible:**

**1. AJAX Endpoints:**
```
Grep: pattern="wp_ajax_" path="lib/controllers/" output_mode="files_with_matches"
Grep: pattern="add_action.*ajax" path="lib/" output_mode="files_with_matches"
```

**2. REST API Endpoints:**
```
Grep: pattern="register_rest_route" path="lib/" output_mode="files_with_matches"
Grep: pattern="rest_api_init" path="lib/" output_mode="files_with_matches"
```

**3. File Operations:**
```
Grep: pattern="file_get_contents|file_put_contents|fopen|fwrite" path="lib/" output_mode="files_with_matches"
Grep: pattern="\$_FILES" path="lib/" output_mode="files_with_matches"
```

**4. Database Queries:**
```
Grep: pattern="\$wpdb->query|\$wpdb->get_" path="lib/" output_mode="files_with_matches"
Grep: pattern="prepare|%s|%d" path="lib/" output_mode="count"
```

**5. User Input:**
```
Grep: pattern="\$_GET|\$_POST|\$_REQUEST" path="lib/" output_mode="files_with_matches"
Grep: pattern="\$_COOKIE|\$_SERVER" path="lib/" output_mode="files_with_matches"
```

**Important:** Use `output_mode="files_with_matches"` first to get file list, then use `output_mode="content"` with specific files for detailed analysis.

### Document Findings

Create `/tmp/module[N]-phase1-discovery-report.md`:
- Controllers identified
- Entry points mapped
- Data flow paths
- External dependencies
- Initial risk assessment

**Output:** Attack surface map

---

## Phase 2: Code Review (Per Module)

**Goal:** Line-by-line examination for security issues

**Time:** 2-3 hours per module

### Vulnerability Categories

**1. CSRF Protection:**
```
# Find state-changing functions
Grep: pattern="function (delete|update|create|save|destroy)" path="lib/controllers/" output_mode="content" -A=10

# Then check each for nonce verification
Grep: pattern="check_nonce|wp_verify_nonce|check_ajax_referer" path="[specific_controller.php]" output_mode="content"
```

**Pattern:** State-changing operations without `check_nonce()` calls

**2. SQL Injection:**
```
# Find database queries
Grep: pattern="\$wpdb->query|\$wpdb->get_" path="lib/" output_mode="content"

# Filter out prepared statements (manual review of results)
# Look for queries WITHOUT $wpdb->prepare() wrapper
```

**Pattern:** User input in queries without `$wpdb->prepare()`

**3. XSS (Cross-Site Scripting):**
```
# Find echo/print statements in views
Grep: pattern="echo \$|print \$" path="lib/views/" output_mode="content"

# Review results for missing esc_ functions
```

**Pattern:** User data output without `esc_html()`, `esc_attr()`, `esc_url()`

**4. Input Validation:**
```
# Find user input access
Grep: pattern="\$_POST|\$_GET|\$_REQUEST" path="lib/" output_mode="files_with_matches"

# Then read specific files to check sanitization
Read: file_path="[suspicious_file.php]"
```

**Pattern:** Direct use of `$_POST`/`$_GET` without `sanitize_*()` functions

**5. File Upload Security:**
```
# Find file upload handling
Grep: pattern="wp_handle_upload|move_uploaded_file|\$_FILES" path="lib/" output_mode="content"
```

**Check for:**
- File type validation
- File size limits
- Path traversal prevention
- Secure filenames

**6. Authorization Bypass:**
```
# Find admin functions
Grep: pattern="function.*(destroy|delete|update)" path="lib/controllers/" output_mode="content" -A=15

# Review for current_user_can() checks in first 15 lines
```

**Pattern:** Admin functions without `current_user_can()` checks

### Validation Process

For each potential vulnerability:

1. **Read vulnerable code** (with context)
2. **Trace data flow** (input → processing → output)
3. **Identify attack vector**
4. **Check for compensating controls**
5. **Assign confidence level** (1-10, only report ≥8)

**Reference:** See `references/wordpress-helpers.md` for 14 common WordPress helper function misuse patterns (wp_mail, wp_redirect, update_option, wp_kses, add_query_arg, wp_remote_*, etc.)

### Document Findings

Create `/tmp/module[N]-phase2-code-review-report.md`:
- Vulnerabilities identified (V001, V002, etc.)
- Code locations (file:line)
- Attack vectors
- Confidence levels
- Potential false positives flagged

---

## Phase 3: Threat Modeling (Per Module)

**Goal:** Real-world attack scenarios

**Time:** 1 hour per module

### Attack Scenario Template

For each vulnerability, create:

**1. Attacker Goal**
- What do they want to achieve?
- What's the business impact?

**2. Prerequisites**
- What access is needed?
- What conditions must exist?

**3. Attack Steps**
1. Step-by-step exploitation
2. Proof-of-concept code
3. Expected outcome

**4. CVSS Scoring**
- Base score (exploitability + impact)
- Temporal score (if applicable)
- Environmental score (business context)

**5. Likelihood Assessment**
- High (>40%): Simple, common scenario
- Medium (15-40%): Requires specific conditions
- Low (<15%): Complex, rare scenario

**6. Business Impact**
- Technical impact (RCE, data breach, DoS)
- Financial impact ($10k-$50k, $50k-$250k, $250k+)
- Compliance impact (GDPR, CCPA, PCI-DSS)

### Systematic Vulnerability Chaining Analysis

**CRITICAL:** Many individual vulnerabilities become CRITICAL when combined. Analyze chains systematically.

**Process:**

1. **Review all module findings together** (don't analyze in isolation)
2. **Identify chain patterns** (see common chains below)
3. **Calculate combined severity** (use escalation rules)
4. **Document as separate finding** (V003 = V001 + V002)
5. **Update original findings** with chain references

**Common WordPress Vulnerability Chains:**

**Chain Pattern 1: CSRF + Data Modification = Privilege Escalation**
- Example: CSRF on admin settings + Options injection = Admin account creation
- Severity: MEDIUM + MEDIUM → CRITICAL
- Impact: Unauthenticated attacker gains admin access

**Chain Pattern 2: CSRF + SQL Injection = Remote Code Execution**
- Example: Missing nonce + Unprepared query in admin action
- Severity: MEDIUM + HIGH → CRITICAL
- Impact: Unauthenticated SQLi via CSRF, potential RCE via SQL file writes

**Chain Pattern 3: XSS + CSRF = Session Hijacking**
- Example: Stored XSS in admin panel + CSRF on sensitive action
- Severity: HIGH + MEDIUM → CRITICAL
- Impact: XSS executes CSRF attack on behalf of admin

**Chain Pattern 4: Authentication Bypass + IDOR = Mass Data Breach**
- Example: Weak session validation + Missing ownership checks
- Severity: HIGH + MEDIUM → CRITICAL
- Impact: Access all user data without authentication

**Chain Pattern 5: File Upload + Path Traversal = Remote Code Execution**
- Example: Weak file type validation + Unrestricted file path
- Severity: HIGH + HIGH → CRITICAL
- Impact: Upload PHP shell to arbitrary location

**Chain Pattern 6: Information Disclosure + Weak Crypto = Account Takeover**
- Example: Exposed password reset tokens + Predictable token generation
- Severity: MEDIUM + MEDIUM → HIGH
- Impact: Enumerate and forge password reset tokens

**Chain Pattern 7: Open Redirect + OAuth Flow = Account Takeover**
- Example: Unvalidated wp_redirect() + Social login callback
- Severity: LOW + MEDIUM → HIGH
- Impact: Steal OAuth tokens via redirect to attacker domain

**Chain Pattern 8: SSRF + Internal Service = Data Exfiltration**
- Example: User-controlled wp_remote_get() + Internal API without auth
- Severity: HIGH + MEDIUM → CRITICAL
- Impact: Access internal services, exfiltrate sensitive data

**Severity Escalation Rules:**

```
Individual Severities → Combined Severity
─────────────────────────────────────────
CRITICAL + any        → CRITICAL
HIGH + HIGH           → CRITICAL
HIGH + MEDIUM         → HIGH (or CRITICAL if auth bypass)
MEDIUM + MEDIUM       → HIGH (if clear attack path)
MEDIUM + LOW          → MEDIUM (rarely escalates)
LOW + LOW             → LOW (document but don't escalate)
```

**Documentation Template:**

For each chain, create combined finding:

```markdown
## V[XXX]: [Chain Description] (CHAIN)

**Chain Components:**
- V001: CSRF - Missing nonce verification in `admin_action_update_settings`
- V002: Options Injection - User-controlled option name in `update_option()`

**Combined Attack Vector:**

1. Attacker crafts malicious form targeting `admin_action_update_settings`
2. Admin visits attacker page, form auto-submits (CSRF)
3. Request includes malicious option name: `update_option($_POST['option_name'], 'malicious')`
4. Attacker can now modify ANY WordPress option (e.g., `admin_email`, `siteurl`)

**Severity Escalation:**
- V001 alone: MEDIUM (CSRF allows unauthorized actions)
- V002 alone: MEDIUM (Options injection requires authenticated request)
- **V001 + V002: CRITICAL** (Unauthenticated attacker can modify any WP option)

**CVSS Score:** 9.8 (CRITICAL)
- Attack Vector: Network (AV:N)
- Attack Complexity: Low (AC:L)
- Privileges Required: None (PR:N)
- User Interaction: Required (UI:R)
- Scope: Changed (S:C)
- Impact: High (C:H/I:H/A:H)

**Proof of Concept:**
[Detailed PoC showing combined exploit]

**Remediation:**
Must fix BOTH vulnerabilities:
1. Add nonce verification to prevent CSRF
2. Whitelist allowed option names to prevent injection
```

**Chain Discovery Checklist:**

For each module, systematically check:

- [ ] **Auth chains:** Can any auth bypass enable other vulns?
- [ ] **CSRF chains:** Do CSRF-vulnerable actions have SQLi/XSS/Injection?
- [ ] **XSS chains:** Can stored XSS trigger other vulns via JavaScript?
- [ ] **Data flow chains:** Do information disclosure vulns reveal tokens/keys enabling other attacks?
- [ ] **File operation chains:** Do upload + path traversal = RCE?
- [ ] **External service chains:** Do SSRF + weak validation = data breach?

**False Chain Patterns (Don't Report):**

- ❌ Two unrelated vulns in different modules (no interaction)
- ❌ Chains requiring admin privileges (already critical)
- ❌ Theoretical chains with no realistic attack path
- ❌ Chains where compensating controls prevent exploitation

**Document in:** `/tmp/module[N]-phase3-threat-modeling-report.md`

**Chain findings section:**
```markdown
## Vulnerability Chains Identified

### V[XXX]: [Chain Name]
- Components: V001 + V002
- Severity: CRITICAL
- Attack path: [description]
- Remediation: [must fix all components]
```

---

## Phase 4: Expert Validation (Per Module)

**Goal:** Multi-expert review to eliminate false positives

**Time:** 1 hour per module

### Expert Panel Process (Multi-Perspective AI Review)

**CRITICAL:** This is NOT a perfunctory check. Each expert must provide INDEPENDENT reasoning before consensus.

**Execution:**
1. Present finding to all 4 experts simultaneously
2. Each expert provides independent verdict (ACCEPT/REJECT) with reasoning
3. Calculate consensus (3/4 required to accept)
4. For disagreements, review code again with conflicting perspectives
5. Final verdict requires >= 8/10 confidence

---

### Expert #1: Security Specialist

**Role-play instructions:**
You are a senior penetration tester with 15 years of experience in web application security. You've published CVEs and found critical vulnerabilities in major WordPress plugins.

**Your task for EACH finding:**

```
<internal_reasoning>
1. EXPLOITABILITY CHECK:
   - Can I write a working proof-of-concept?
   - What's the attack vector? (Remote/Local, Auth Required/Unauth)
   - What privileges does attacker need?
   - What's the complexity? (Low/Medium/High)

2. IMPACT ASSESSMENT:
   - Confidentiality: What data is exposed?
   - Integrity: What can be modified?
   - Availability: Can this cause DoS?
   - Scope: Single user or system-wide?

3. REAL-WORLD LIKELIHOOD:
   - Would this be found in a real penetration test?
   - Does it require insider knowledge?
   - Is it in a common code path?

4. CVSS VALIDATION:
   - Attack Vector (Network/Adjacent/Local/Physical)
   - Attack Complexity (Low/High)
   - Privileges Required (None/Low/High)
   - User Interaction (None/Required)
   - Calculate: Base Score = ?

5. FIX COMPLETENESS:
   - Does proposed fix eliminate the root cause?
   - Are there bypass scenarios?
   - Does fix introduce new vulnerabilities?
</internal_reasoning>

VERDICT: [ACCEPT/REJECT]
CONFIDENCE: [8-10]/10
SEVERITY: [CRITICAL/HIGH/MEDIUM/LOW]
REASONING: [2-3 sentences explaining decision]
```

---

### Expert #2: WordPress Core Expert

**Role-play instructions:**
You are a WordPress Core Committer with deep knowledge of WordPress internals, hooks system, and security best practices. You've reviewed thousands of plugin submissions.

**Your task for EACH finding:**

```
<internal_reasoning>
1. WORDPRESS PROTECTION CHECK:
   - Does WordPress core already sanitize this input?
   - Is there a wp-content/.htaccess rule protecting this?
   - Does add_filter/add_action provide validation?
   - Is this handled by wp_verify_nonce() automatically?

2. NATIVE FUNCTION AVAILABILITY:
   - What's the WordPress-recommended way to do this?
   - Are there sanitization functions we missed?
   - Is there a core API that makes this safe?

3. PLUGIN BEHAVIOR ANALYSIS:
   - Is this standard WordPress plugin behavior?
   - Do other popular plugins do this the same way?
   - Is there a WordPress Coding Standards violation?

4. COMPENSATING CONTROLS:
   - Does register_activation_hook add protection?
   - Are there WordPress filters intervening?
   - Does multisite provide additional checks?

5. FALSE POSITIVE CHECK:
   - Is this a misunderstanding of WordPress architecture?
   - Are we missing a hook that validates this?
   - Is this a documented WordPress pattern?
</internal_reasoning>

VERDICT: [ACCEPT/REJECT]
CONFIDENCE: [8-10]/10
WP CONTEXT: [WordPress-specific factors]
REASONING: [2-3 sentences]
```

---

### Expert #3: Senior Software Engineer

**Role-play instructions:**
You are a Lead Engineer with 20 years in PHP/JavaScript development. You've architected large-scale applications and debugged complex security issues. You're skeptical of theoretical vulnerabilities.

**Your task for EACH finding:**

```
<internal_reasoning>
1. CODE CONTEXT ANALYSIS:
   - What's happening BEFORE this code executes?
   - What's happening AFTER?
   - Are there parent class validations we missed?
   - Is there middleware/interceptor logic?

2. FALSE POSITIVE DETECTION:
   - Is there sanitization we didn't see?
   - Are there type hints preventing this?
   - Does PHP error handling make this unexploitable?
   - Is there a database constraint preventing abuse?

3. HIDDEN VALIDATION CHECK:
   - Check parent class constructors
   - Check trait implementations
   - Check __call() magic methods
   - Check early returns/guards

4. REALISTIC ATTACKER SCENARIO:
   - Can an attacker actually reach this code?
   - What's the realistic attack chain?
   - How many stars need to align?

5. FIX COMPLEXITY:
   - Is fix a 1-line change or major refactor?
   - Will fix break existing functionality?
   - Are there performance implications?
</internal_reasoning>

VERDICT: [ACCEPT/REJECT]
CONFIDENCE: [8-10]/10
TECHNICAL ASSESSMENT: [Code-level factors]
REASONING: [2-3 sentences]
```

---

### Expert #4: DevOps/Platform Engineer

**Role-play instructions:**
You manage production WordPress deployments at scale. You've seen security issues break sites and understand operational constraints.

**Your task for EACH finding:**

```
<internal_reasoning>
1. SERVER-LEVEL MITIGATION:
   - Does Nginx/Apache config block this?
   - Does PHP.ini setting prevent exploitation?
   - Does WAF (Cloudflare, Sucuri) catch this?
   - Does mod_security rule block this pattern?

2. DEPLOYMENT RISK:
   - If we deploy fix, what breaks?
   - Is this a breaking change for users?
   - What's the rollback plan?
   - How do we test the fix?

3. REAL-WORLD EXPLOITABILITY:
   - In a properly configured WordPress hosting environment, is this exploitable?
   - Do all major hosts (WP Engine, Kinsta, etc.) have protections?
   - Is this only exploitable on misconfigured servers?

4. OPERATIONAL CONTEXT:
   - Can we monitor/detect exploitation attempts?
   - Can we add a fail-safe without code changes?
   - Is there a configuration-based mitigation?

5. RISK VS EFFORT:
   - What's the probability of exploitation in the wild?
   - What's the effort to implement fix?
   - Should we fix now or schedule for next release?
</internal_reasoning>

VERDICT: [ACCEPT/REJECT]
CONFIDENCE: [8-10]/10
OPERATIONAL VIEW: [Deployment/infrastructure factors]
REASONING: [2-3 sentences]
```

---

### Consensus Protocol

**Step 1: Calculate votes**
- 4/4 ACCEPT → ACCEPTED (high confidence)
- 3/4 ACCEPT → REVIEW AGAIN with dissenting view
- 2/4 ACCEPT → REJECTED (insufficient consensus)
- ≤1/4 ACCEPT → REJECTED (false positive)

**Step 2: For 3/4 scenarios**
- Re-read vulnerable code with dissenting expert's perspective
- Look for what we missed
- Revote after clarification

**Step 3: Final verdict**
- Require >= 3/4 experts to ACCEPT
- Require >= 8/10 average confidence
- Require >= 1 expert with 10/10 confidence OR >= 2 experts with 9/10

**Example consensus:**
```
Security Expert: ACCEPT (9/10) - Clear SQL injection, no prepare()
WordPress Expert: ACCEPT (8/10) - No WP protection, violates standards
Senior Dev: REJECT (7/10) - Might be parent class validation
DevOps: ACCEPT (8/10) - No server-level mitigation

Result: 3/4 ACCEPT → RE-REVIEW
[Re-check parent class]
[No validation found]
Senior Dev revises: ACCEPT (8/10)

FINAL: 4/4 ACCEPT, avg 8.25/10 → ACCEPTED
```

### Document Results

Create `/tmp/module[N]-phase4-expert-validation-report.md`:

```markdown
# Module [N] - Expert Validation Results

## Summary
- **Total findings reviewed:** X
- **Accepted vulnerabilities:** Y
- **Rejected false positives:** Z
- **Consensus rate:** Y/(Y+Z) %

## Accepted Vulnerabilities

### V001: SQL Injection in booking_controller.php:45
**Expert Verdicts:**
- Security: ACCEPT (9/10) - [reasoning]
- WordPress: ACCEPT (8/10) - [reasoning]
- Senior Dev: ACCEPT (8/10) - [reasoning]
- DevOps: ACCEPT (8/10) - [reasoning]
**Consensus:** 4/4 ACCEPT, avg 8.25/10 ✅
**Final Severity:** CRITICAL

[Repeat for each accepted vuln]

## Rejected False Positives

### FP001: Alleged XSS in settings_helper.php:120
**Expert Verdicts:**
- Security: REJECT (6/10) - WordPress escapes this automatically
- WordPress: REJECT (5/10) - wp_kses_post() called by framework
- Senior Dev: REJECT (7/10) - Parent class sanitizes
- DevOps: REJECT (6/10) - Not exploitable in practice
**Consensus:** 0/4 ACCEPT → REJECTED ❌
**Reason:** WordPress core provides automatic protection

[Repeat for each rejected finding]
```

---

## Phase 4.5: Exploitability Verification (Per Module)

**Goal:** Verify accepted vulnerabilities are actually exploitable

**Time:** 30-60 minutes per module

### Purpose

Expert validation (Phase 4) confirms vulnerabilities exist in code, but **doesn't prove they're exploitable**. This phase ensures we only report vulnerabilities that pose real security risk.

### Verification Checklist

For each **ACCEPTED** vulnerability from Phase 4:

**1. Trace Complete Data Flow**
```
User Input → Sanitization? → Processing → Storage? → Retrieval → Output → Exploitation
```

**Example SQL Injection Check:**
- ✅ User input reaches query: `$_GET['id']` → `$wpdb->query()`
- ✅ No prepare() wrapper: Direct concatenation
- ✅ Query executes: In active code path, not dead code
- ✅ Output affects application: Returns data or modifies state
- **Verdict:** EXPLOITABLE ✅

**Example False Exploitability:**
- ❌ User input reaches query BUT output is re-escaped before display
- ❌ OR vulnerable code is in unused legacy function
- ❌ OR WordPress core provides compensating control
- **Verdict:** NOT EXPLOITABLE ❌ (downgrade or reject)

**2. Check Compensating Controls**

Even if vulnerability exists, check if mitigations prevent exploitation:

```php
// Vulnerable code found:
$id = $_POST['id'];
$wpdb->query("DELETE FROM table WHERE id = $id");

// BUT check if there's a filter:
add_filter('sanitize_post', function($data) {
    $data['id'] = absint($data['id']);  // ← Compensating control!
    return $data;
});
```

**Questions to ask:**
- Does WordPress add automatic sanitization via hooks?
- Does server config (WAF, mod_security) block exploit?
- Does parent class/method provide validation?
- Is vulnerability in admin-only code with proper capability checks?

**3. Assess Attack Prerequisites**

**Simple Attack (HIGH exploitability):**
- No authentication required
- Single HTTP request
- No special conditions

**Complex Attack (MEDIUM exploitability):**
- Requires authentication (but any user role)
- Multiple steps (e.g., CSRF → trigger vulnerable function)
- Timing-dependent (race condition)

**Theoretical Attack (LOW exploitability - consider rejecting):**
- Requires admin access + other vulnerability
- Requires impossible preconditions
- Requires server misconfiguration (not default)

**4. Write Minimal Proof of Concept**

Don't actually execute exploits, but document how it would work:

**Example PoC Template:**
```markdown
## Proof of Concept

**V001: SQL Injection in bookings_controller.php:45**

Step 1: Send malicious request
POST /wp-admin/admin-ajax.php
action=delete_booking&id=1' OR '1'='1

Step 2: Observe behavior
- Query executed: DELETE FROM bookings WHERE id = 1' OR '1'='1
- Result: All bookings deleted (SQL injection confirmed)

Step 3: Verify impact
- Database query log shows injected SQL
- All booking records removed

**Exploitability:** HIGH (single unauthenticated request)
**Impact:** CRITICAL (data destruction)
```

**5. Downgrade or Reject Non-Exploitable Findings**

If verification shows vulnerability **cannot be exploited**:

**Option A: Downgrade Severity**
- CRITICAL → HIGH (if hard to exploit)
- HIGH → MEDIUM (if requires special conditions)
- MEDIUM → LOW (if only theoretical)

**Option B: Reject Finding**
- If exploit requires impossible prerequisites
- If compensating controls fully mitigate
- If attack path doesn't actually work

**Document reasoning:**
```markdown
V005: Originally reported as CRITICAL SQL injection

**Exploitability Verification:**
- User input DOES reach query
- BUT: WordPress filter 'pre_get_posts' sanitizes before query
- AND: Query only executes for admin users (capability check present)
- AND: Output is re-escaped with esc_sql() before use

**Revised Assessment:**
- Downgrade to MEDIUM (defense-in-depth issue)
- OR Reject (adequate compensating controls)

**Justification:** Multiple layers prevent exploitation despite vulnerable pattern
```

### Output

Create `/tmp/module[N]-phase4.5-exploitability-report.md`:

```markdown
# Module [N] - Exploitability Verification Results

## Exploitable Vulnerabilities (Confirmed)

### V001: SQL Injection (bookings_controller.php:45)
- **Data Flow:** $_GET['id'] → query() → database execution
- **Compensating Controls:** None
- **Attack Complexity:** Low (single HTTP request)
- **PoC Summary:** Send id=1' OR '1'='1 → deletes all records
- **Verdict:** ✅ EXPLOITABLE AS REPORTED

### V003: CSRF (coupons_controller.php:89)
- **Data Flow:** $_POST → delete_coupon() → database delete
- **Compensating Controls:** None (no nonce check)
- **Attack Complexity:** Medium (requires user to visit attacker site)
- **PoC Summary:** Attacker hosts page with hidden form → auto-submits
- **Verdict:** ✅ EXPLOITABLE AS REPORTED

## Non-Exploitable Findings (Revised)

### V002: XSS (settings_helper.php:120) - DOWNGRADED
- **Data Flow:** $_POST['title'] → echo $title
- **Compensating Controls:** wp_kses_post() called by parent class
- **Original Severity:** HIGH
- **Revised Severity:** LOW (defense-in-depth)
- **Verdict:** ⚠️ DOWNGRADE SEVERITY

### V004: SQL Injection (reports_controller.php:200) - REJECTED
- **Data Flow:** $_GET['filter'] → query()
- **Compensating Controls:** sanitize_text_field() applied + whitelist validation
- **Why Not Exploitable:** Input fully sanitized before query
- **Verdict:** ❌ REJECT (false positive)

## Statistics

- **Total from Phase 4:** 8 vulnerabilities
- **Confirmed Exploitable:** 6 (75%)
- **Downgraded:** 1 (12.5%)
- **Rejected:** 1 (12.5%)
```

### Integration with Phase 5

**Only create GitHub issues for:**
- ✅ Confirmed exploitable vulnerabilities
- ✅ Downgraded vulnerabilities (with revised severity)

**Do NOT create issues for:**
- ❌ Rejected non-exploitable findings

---

## Phase 5: Documentation & GitHub Issues (Per Module)

**Goal:** Create actionable issues with complete information

**Time:** 30 minutes per module

### Issue Template

For each validated vulnerability, create:

```markdown
## Summary

**Severity:** [CRITICAL/HIGH/MEDIUM/LOW] (CVSS X.X)
**Type:** [CSRF/SQLi/XSS/etc.] (CWE-XXX)
**Priority:** [P0/P1/P2/P3]

[1-2 sentence description]

## Vulnerability Details

**Location:** `file.php:line`

[Vulnerable code block]

## Proof of Concept

[Attack demonstration]

## Business Impact

**Technical Impact:**
- [Bullet points]

**Business Impact:** $XXk-$XXXk
- [Cost breakdown]

## Recommended Fix

[Fixed code block]

**Additional Hardening:**
- [Suggestions]

## Testing

[Test cases]

**Module:** [Module Name] | **Priority:** PX | **Confidence:** XX%

## Related Issues

- #XX (Related vulnerability)
```

### Create GitHub Issues

```bash
cd /path/to/plugin
gh issue create \
  --title "[Security] VXXX (SEVERITY): Brief Description" \
  --body-file /tmp/issue-vXXX.md \
  --label "security"
```

### Update Master Tracking Issue

Add module completion section:
- Vulnerabilities found
- Issues created
- Statistics
- Next steps

```bash
gh issue comment [master-issue-number] \
  --body-file /tmp/module[N]-completion-update.md
```

---

## Multi-Module Workflow

**For each module (in priority order):**

1. ✅ Phase 1: Discovery (1-2 hours)
2. ✅ Phase 2: Code Review (2-3 hours)
3. ✅ Phase 3: Threat Modeling (1 hour)
4. ✅ Phase 4: Expert Validation (1 hour)
5. ✅ Create GitHub Issues (30 min)
6. ✅ Update Master Tracking Issue

**Total per module:** 5.5-7.5 hours

**Pause after each module for user confirmation** (unless instructed otherwise)

---

## Final Deliverables

### 1. Master Tracking Issue (Updated)

Final statistics:
- Total modules audited
- Total vulnerabilities found
- Severity breakdown
- Priority deployment plan
- Remediation timeline

### 2. Individual GitHub Issues

One issue per vulnerability with:
- Complete technical details
- Proof of concept
- Fix recommendations
- Testing instructions

### 3. Module Reports

For each module:
- Phase 1: Discovery report
- Phase 2: Code review report
- Phase 3: Threat modeling report
- Phase 4: Expert validation report
- Phase 5: Documentation summary

### 4. Executive Summary

Create `/tmp/audit-executive-summary.md`:
- Overview of findings
- Critical vulnerabilities
- Business impact assessment
- Remediation priorities
- Timeline recommendations

---

## Quality Checklist

Before marking audit complete:

- [ ] All modules audited through 5 phases
- [ ] All vulnerabilities validated by expert panel
- [ ] False positives documented with reasoning
- [ ] GitHub issues created for all valid findings
- [ ] Master tracking issue updated
- [ ] Module reports saved
- [ ] Executive summary written
- [ ] Remediation plan provided
- [ ] No sensitive data in public issues

---

## Common Vulnerability Patterns (WordPress)

### 1. CSRF (Most Common)

**Pattern:**
```php
public function dangerous_action() {
    // ❌ NO check_nonce() call
    // Performs state-changing operation
}
```

**Fix:**
```php
public function dangerous_action() {
    $this->check_nonce('dangerous_action');  // ✅
    // ...
}
```

### 2. SQL Injection

**Pattern:**
```php
$id = $_GET['id'];
$wpdb->query("DELETE FROM table WHERE id = $id");  // ❌
```

**Fix:**
```php
$id = absint($_GET['id']);
$wpdb->query($wpdb->prepare("DELETE FROM table WHERE id = %d", $id));  // ✅
```

### 3. XSS (Unescaped Output)

**Pattern:**
```php
echo "<div>$user_input</div>";  // ❌
```

**Fix:**
```php
echo "<div>" . esc_html($user_input) . "</div>";  // ✅
```

### 4. Authorization Bypass

**Pattern:**
```php
public function delete_user() {
    // ❌ NO capability check
    wp_delete_user($_POST['user_id']);
}
```

**Fix:**
```php
public function delete_user() {
    if (!current_user_can('delete_users')) {  // ✅
        wp_die('Insufficient permissions');
    }
    wp_delete_user($_POST['user_id']);
}
```

### 5. File Upload Vulnerabilities

**Pattern:**
```php
move_uploaded_file($_FILES['file']['tmp_name'], $target);  // ❌
```

**Fix:**
```php
$allowed_types = ['image/jpeg', 'image/png'];
$file_type = $_FILES['file']['type'];

if (!in_array($file_type, $allowed_types)) {
    wp_die('Invalid file type');
}

// Use wp_handle_upload with validation
$upload = wp_handle_upload($_FILES['file'], [
    'test_form' => false,
    'mimes' => ['jpg' => 'image/jpeg', 'png' => 'image/png']
]);  // ✅
```

---

## References

Detailed methodology:
- `references/vulnerability-patterns.md` - 21 WordPress vulnerability types with detection commands
- `references/wordpress-helpers.md` - 14 WordPress helper function misuse patterns
- `references/master-tracking-template.md` - Tracking issue format

Example audits:
- `examples/latepoint-summary.md` - LatePoint Pro results (26 vulns, 34 hours, 0 false positives)
- `examples/workflow-example.md` - Complete Phase 0-5 execution walkthrough

---

## Usage Example

**User:** "Perform modular security audit on MyPlugin Pro"

**Agent:**

1. **Planning Phase:**
   - Asks for plugin repo, path, priorities
   - Maps plugin architecture
   - Defines 8 modules
   - Creates master tracking issue
   - Gets user approval

2. **Module 1 (Authentication):**
   - Phase 1: Discovers 5 entry points
   - Phase 2: Finds 3 CSRF vulnerabilities, 1 SQL injection
   - Phase 3: Models attack scenarios
   - Phase 4: Validates all 4 (100% confidence)
   - Phase 5: Creates GitHub issues #1-#4
   - Updates master issue

3. **Continues through all 8 modules...**

4. **Final Summary:**
   - 28 vulnerabilities discovered
   - 5 CRITICAL, 12 HIGH, 11 MEDIUM
   - All issues created (#1-#28)
   - Master tracking issue complete
   - Executive summary provided

---

## Notes

- **Autonomous operation:** Can run unattended after initial approval
- **High accuracy:** Expert validation ensures <5% false positive rate
- **Actionable output:** Every issue includes fix + test cases
- **Business context:** Impact assessments include financial estimates
- **Reusable:** Works for any WordPress plugin/theme
- **Scalable:** Handles plugins from 1k to 100k+ lines of code

**Estimated Time:**
- Small plugin (1-3 modules): 8-24 hours
- Medium plugin (4-8 modules): 24-48 hours
- Large plugin (9-15 modules): 48-100 hours

