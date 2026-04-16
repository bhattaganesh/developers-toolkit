# Performance Report

**Page:** [URL]
**Date:** [YYYY-MM-DD]
**Tested By:** [Name or "Claude Code chrome-debug"]
**Device:** [Desktop / Mobile / Tablet]
**Network:** [Fast 4G / Slow 3G / No Throttling]

---

## Core Web Vitals

### LCP (Largest Contentful Paint)
**Score:** [X.XX seconds]
**Rating:** [🟢 Good (<2.5s) / 🟡 Needs Improvement (2.5-4s) / 🔴 Poor (>4s)]

**LCP Element:** [Description of largest element, e.g., "Hero image"]
**LCP URL:** [URL of resource if applicable]

### CLS (Cumulative Layout Shift)
**Score:** [X.XX]
**Rating:** [🟢 Good (<0.1) / 🟡 Needs Improvement (0.1-0.25) / 🔴 Poor (>0.25)]

**Major Shifts:** [Number of significant layout shifts]
**Shift Sources:** [What caused shifts, e.g., "Images without dimensions"]

### FID (First Input Delay)
**Score:** [XXX ms]
**Rating:** [🟢 Good (<100ms) / 🟡 Needs Improvement (100-300ms) / 🔴 Poor (>300ms)]

**First Interaction:** [What was the first interaction, e.g., "Button click"]

---

## Additional Metrics

| Metric | Score | Goal |
|--------|-------|------|
| Time to Interactive (TTI) | [X.X s] | <3s |
| First Contentful Paint (FCP) | [X.X s] | <1.8s |
| Speed Index | [X.X s] | <3.4s |
| Total Blocking Time (TBT) | [XXX ms] | <200ms |

---

## Key Performance Insights

### 1. [Insight Name]
**Impact:** [High / Medium / Low]
**Description:** [What the insight reveals]
**Affected Metrics:** [Which Core Web Vitals are impacted]

### 2. [Insight Name]
**Impact:** [High / Medium / Low]
**Description:** [What the insight reveals]
**Affected Metrics:** [Which Core Web Vitals are impacted]

### 3. [Insight Name]
**Impact:** [High / Medium / Low]
**Description:** [What the insight reveals]
**Affected Metrics:** [Which Core Web Vitals are impacted]

---

## Performance Bottlenecks

### Critical Issues (Fix Immediately)
1. **[Issue Name]** - [Duration: XX ms]
   - **Cause:** [What's causing this]
   - **Impact:** [How it affects performance]
   - **Fix:** [Recommended solution]

### High Priority (Fix Soon)
1. **[Issue Name]** - [Duration: XX ms]
   - **Cause:** [What's causing this]
   - **Impact:** [How it affects performance]
   - **Fix:** [Recommended solution]

### Medium Priority (Optimize Later)
1. **[Issue Name]** - [Duration: XX ms]
   - **Cause:** [What's causing this]
   - **Impact:** [How it affects performance]
   - **Fix:** [Recommended solution]

---

## Resource Breakdown

| Resource Type | Count | Total Size | % of Total |
|---------------|-------|------------|------------|
| JavaScript | [N] | [XXX KB] | [XX%] |
| CSS | [N] | [XXX KB] | [XX%] |
| Images | [N] | [XXX KB] | [XX%] |
| Fonts | [N] | [XXX KB] | [XX%] |
| Other | [N] | [XXX KB] | [XX%] |
| **Total** | **[N]** | **[XXX KB]** | **100%** |

---

## Recommendations

### High Impact (Implement First)
- [ ] **[Recommendation 1]**
  - **Expected Improvement:** [LCP -X.Xs, CLS -X.XX, etc.]
  - **Effort:** [Low / Medium / High]
  - **Implementation:** [Brief how-to]

- [ ] **[Recommendation 2]**
  - **Expected Improvement:** [LCP -X.Xs, CLS -X.XX, etc.]
  - **Effort:** [Low / Medium / High]
  - **Implementation:** [Brief how-to]

### Medium Impact
- [ ] **[Recommendation 3]**
  - **Expected Improvement:** [LCP -X.Xs, CLS -X.XX, etc.]
  - **Effort:** [Low / Medium / High]
  - **Implementation:** [Brief how-to]

### Low Impact (Nice to Have)
- [ ] **[Recommendation 4]**
  - **Expected Improvement:** [LCP -X.Xs, CLS -X.XX, etc.]
  - **Effort:** [Low / Medium / High]
  - **Implementation:** [Brief how-to]

---

## Comparison (if applicable)

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| LCP | [X.X s] | [X.X s] | [±X.X s] |
| CLS | [X.XX] | [X.XX] | [±X.XX] |
| FID | [XXX ms] | [XXX ms] | [±XXX ms] |
| Page Size | [XXX KB] | [XXX KB] | [±XXX KB] |
| Requests | [N] | [N] | [±N] |

---

## Trace File

**Location:** [path/to/trace.json.gz]
**Size:** [XX MB]
**Duration:** [XX seconds]

To analyze manually:
1. Open Chrome DevTools
2. Performance tab → Load profile
3. Select trace file

---

## Next Steps

1. **Immediate Actions:**
   - [Action 1]
   - [Action 2]

2. **Short Term (This Sprint):**
   - [Action 1]
   - [Action 2]

3. **Long Term (Roadmap):**
   - [Action 1]
   - [Action 2]

---

## Performance Budget

**Current Status vs Budget:**

| Resource | Budget | Current | Status |
|----------|--------|---------|--------|
| Total Page Size | <1MB | [XXX KB] | [✅ / ⚠️ / ❌] |
| JavaScript | <200KB | [XXX KB] | [✅ / ⚠️ / ❌] |
| Images | <500KB | [XXX KB] | [✅ / ⚠️ / ❌] |
| Fonts | <100KB | [XXX KB] | [✅ / ⚠️ / ❌] |
| LCP | <2.5s | [X.X s] | [✅ / ⚠️ / ❌] |
| CLS | <0.1 | [X.XX] | [✅ / ⚠️ / ❌] |
| FID | <100ms | [XXX ms] | [✅ / ⚠️ / ❌] |

---

## Notes

[Any additional observations, context, or considerations for optimization]
