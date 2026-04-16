# Process Metrics Guide

This guide provides a framework for tracking security fix workflow metrics to measure efficiency, identify bottlenecks, and continuously improve the process.

---

## Overview

**Why Track Metrics?**
- Measure process efficiency over time
- Identify bottlenecks (which phases take longest?)
- Track quality (how often do fixes need rework?)
- Demonstrate continuous improvement
- Build historical data for estimation

**What to Track:**
1. **Time Metrics** - How long does each phase take?
2. **Scope Metrics** - How many files/lines changed?
3. **Quality Metrics** - How many iterations needed?
4. **Complexity Metrics** - How complex was the fix?

---

## Metrics to Track

### 1. Process Completion Tracking

Track phase completion status:

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1: Initial Request | [✓/In Progress] | [Any blockers or notes] |
| Phase 0.5: Risk Assessment | [✓/In Progress] | [Any blockers or notes] |
| Phase 2: Triage | [✓/In Progress] | [Any blockers or notes] |
| Phase 3: Codebase Scan | [✓/In Progress] | [Any blockers or notes] |
| Phase 4: Solution Options | [✓/In Progress] | [Any blockers or notes] |
| Phase 5: Peer Review | [✓/In Progress] | [Any blockers or notes] |
| Phase 6: Implementation | [✓/In Progress] | [Any blockers or notes] |
| Phase 6.5: Validation | [✓/In Progress] | [Any blockers or notes] |
| Phase 7: Deliverables | [✓/In Progress] | [Any blockers or notes] |

**Key Insights:**
- Which phases had the most iterations?
- Where did blockers occur?
- Which phases needed rework?

### 2. Scope Metrics

Track the size of code changes:

| Metric | Value |
|--------|-------|
| Files Modified | [N] |
| Lines Added | [+N] |
| Lines Removed | [-N] |
| Net Lines Changed | [N] |
| Functions Modified | [N] |
| New Functions Added | [N] |
| Files Created | [N] |

**Key Insights:**
- Larger scope = higher regression risk
- Aim for minimal scope (smaller is safer)
- Track if fixes are growing over time

### 3. Quality Metrics

Track rework and iterations:

| Metric | Value |
|--------|-------|
| Phase 4 Iterations | [N] (how many times did user reject approach?) |
| Phase 5 Revisions | [N] (how many times did peer review find issues?) |
| Quality Gate Failures | [N] (how many times did self-checks fail?) |
| Post-Release Issues | [N] (bugs reported after deployment) |
| Test Failures | [N] (how many tests failed initially?) |

**Key Insights:**
- Higher iterations = misalignment with user or process issues
- Quality gate failures suggest rushing
- Post-release issues indicate testing gaps

### 4. Complexity Metrics

Track fix complexity:

| Metric | Value |
|--------|-------|
| CVSS Score | [0.0-10.0] |
| Vulnerability Type | [XSS / SQLi / CSRF / etc.] |
| Solution Approaches Considered | [N] |
| Integration Points Affected | [N] (REST API, AJAX, blocks, etc.) |
| Dependencies Changed | [N] |
| Backwards Incompatible | [Yes / No] |

**Key Insights:**
- Higher CVSS scores may take longer
- More integration points = more testing needed
- Breaking changes require extra care

---

## Metrics Tracking Template

Use this template to track each security fix:

```csv
fix_id,date,plugin_name,cvss_score,severity,vuln_type,phase1_min,phase05_min,phase2_min,phase3_min,phase4_min,phase5_min,phase6_min,phase65_min,phase7_min,total_min,files_changed,lines_added,lines_removed,phase4_iterations,phase5_revisions,quality_gate_failures,breaking_changes,approaches_considered
001,2026-02-07,my-plugin,8.1,High,XSS,5,10,15,30,20,15,45,30,20,190,3,47,12,1,0,0,No,3
002,2026-02-10,another-plugin,9.8,Critical,SQLi,5,15,20,45,25,20,60,40,25,255,5,89,23,2,1,1,No,2
```

**CSV Fields Explained:**
- `fix_id`: Unique identifier for this fix
- `date`: Date fix was started
- `plugin_name`: Plugin/theme name
- `cvss_score`: CVSS v3.1 base score
- `severity`: Critical/High/Medium/Low
- `vuln_type`: XSS/SQLi/CSRF/RCE/etc.
- `phaseN_min`: Minutes spent in phase N
- `total_min`: Total time in minutes
- `files_changed`: Number of files modified
- `lines_added`: Lines added (+)
- `lines_removed`: Lines removed (-)
- `phase4_iterations`: How many times user rejected approach in Phase 4
- `phase5_revisions`: How many times peer review found issues
- `quality_gate_failures`: How many self-check items failed initially
- `breaking_changes`: Yes/No
- `approaches_considered`: Number of solution approaches evaluated

---

## Analyzing Metrics

### Weekly Review

Every week, review metrics to identify trends:

**Time Analysis:**
```sql
-- Average time per phase (if using database)
SELECT
  AVG(phase3_min) as avg_scan_time,
  AVG(phase6_min) as avg_implementation_time,
  AVG(total_min) as avg_total_time
FROM security_fixes
WHERE date >= DATE_SUB(NOW(), INTERVAL 7 DAY);
```

**Quality Analysis:**
- How many fixes had 0 iterations? (Good!)
- How many had >2 iterations? (Investigate why)
- Are post-release issues trending up or down?

**Scope Analysis:**
- Average files changed: [N]
- Average lines changed: [N]
- Are fixes getting larger over time? (Red flag)

### Monthly Trends

Track monthly trends to measure improvement:

| Month | Avg Time (min) | Avg Files Changed | Avg Iterations | Quality Score |
|-------|----------------|-------------------|----------------|---------------|
| Jan   | 240            | 4.2               | 1.5            | 85%           |
| Feb   | 210            | 3.8               | 1.2            | 90%           |
| Mar   | 195            | 3.5               | 0.8            | 93%           |

**Quality Score Calculation:**
```
Quality Score = 100% - (10% × avg_iterations) - (20% × quality_gate_failures) - (30% × post_release_issues)
```

### Benchmarks

**Target Metrics (Good Performance):**
- Files changed: <5 files
- Lines changed: <100 lines (net)
- Phase 4 iterations: ≤1
- Phase 5 revisions: 0
- Quality gate failures: 0
- Post-release issues: 0

**Red Flags:**
- Files changed >10 - scope too large, consider splitting
- Phase 4 iterations >2 - misalignment with user
- Quality gate failures >1 - rushing, slow down
- Post-release issues >0 - testing gaps

---

## Continuous Improvement

### Retrospective Questions

After each fix, ask:

1. **What went well?**
   - Which phases were efficient?
   - What patterns worked?

2. **What went poorly?**
   - Which phases took too long?
   - What caused rework?

3. **What can be improved?**
   - Process changes?
   - Tool improvements?
   - Template updates?

### Actionable Improvements

Based on metrics, implement improvements:

**If Phase 3 (Codebase Scan) takes too long:**
- Create better search patterns
- Build a catalog of common vulnerable patterns
- Automate with grep/Glob scripts

**If Phase 4 (Solution Options) has many iterations:**
- Ask clarifying questions earlier
- Provide more detailed tradeoff analysis
- Use decision matrix more consistently

**If Phase 6 (Implementation) takes too long:**
- Break large fixes into smaller chunks
- Use more WordPress helper functions
- Create code snippets for common patterns

**If validation finds issues:**
- Add more edge case tests
- Use security testing checklist more thoroughly
- Automate validation with scripts

---

## Reporting Metrics

### Monthly Report Template

```
# Security Fix Workflow Metrics - [Month Year]

## Summary
- Total Fixes: [N]
- Quality Score: [N]%

## Top Performers
- Smallest Scope: [N] lines ([plugin name])
- Highest Quality: 0 rework ([plugin name])

## Areas for Improvement
- Most Rework: [N] iterations in Phase 4
- Largest Scope: [N] files changed ([plugin name])

## Trends
- Quality score: [↑ / ↓ / →] [N]% vs last month
- Scope size: [↑ / ↓ / →] [N]% vs last month

## Actions for Next Month
1. [Action item 1]
2. [Action item 2]
3. [Action item 3]
```

---

## Automation

### Tracking Metrics Automatically

**Using Git:**
```bash
# Lines changed
git diff --stat origin/main...HEAD

# Files changed
git diff --name-only origin/main...HEAD | wc -l

# Commit time tracking
git log --pretty=format:"%H,%an,%ad,%s" --date=iso
```

**Using WP-CLI:**
```bash
# Count affected endpoints
wp eval "echo count( \$GLOBALS['wp_filter']['wp_ajax_'] );"

# Check plugin size
du -sh wp-content/plugins/my-plugin/
```

**Using Scripts:**
Create a simple metrics tracker:
```bash
#!/bin/bash
# metrics-tracker.sh

FIX_ID=$1
START_TIME=$2
END_TIME=$3

DURATION=$(( ($END_TIME - $START_TIME) / 60 ))
FILES=$(git diff --name-only origin/main...HEAD | wc -l)
LINES_ADDED=$(git diff --stat origin/main...HEAD | tail -1 | awk '{print $4}')
LINES_REMOVED=$(git diff --stat origin/main...HEAD | tail -1 | awk '{print $6}')

echo "$FIX_ID,$(date +%Y-%m-%d),$DURATION,$FILES,$LINES_ADDED,$LINES_REMOVED" >> metrics.csv
```

---

## Additional Resources

- [DORA Metrics](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) - Industry-standard DevOps metrics
- [Cycle Time Analysis](https://www.atlassian.com/agile/kanban/cycle-time) - Understanding process bottlenecks
- [Quality Metrics in Software](https://www.iso.org/standard/35733.html) - ISO 25010 quality model

---

## Quick Start

**To start tracking metrics today:**

1. Copy the CSV template above
2. Save as `security-fix-metrics.csv`
3. After each fix, add one row with:
   - Basic info (ID, date, plugin, CVSS)
   - Time per phase (estimated or actual)
   - Scope metrics (files, lines)
   - Quality metrics (iterations, failures)
4. Review monthly
5. Identify improvement opportunities

**Start simple** - don't track everything at once. Start with just:
- Total time
- Files changed
- CVSS score
- Quality gate pass/fail

Add more metrics as you build the habit.
