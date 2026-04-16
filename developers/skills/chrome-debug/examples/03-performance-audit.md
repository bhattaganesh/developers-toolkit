# Example: Slow Page Load Analysis

**Scenario:** Homepage loading slowly (>5s). Users complaining about poor performance.

**Page:** https://example.com
**Goal:** Identify bottlenecks and optimize for Core Web Vitals

---

## Phase 0: Setup

```
list_pages()
select_page({ pageId: 1 })
```

---

## Phase 1: Initial Inspection

**Quick visual check:**
```
navigate_page({ type: "url", url: "https://example.com" })
# Observation: Page takes ~6 seconds to display content
```

---

## Phase 2C: Performance Analysis

**Start trace (with page reload):**
```
performance_start_trace({
  reload: true,
  autoStop: true,
  filePath: "./trace-homepage.json.gz"
})

# Automatically records page load and stops
```

**Results:**
```
Core Web Vitals:
- LCP: 4.2s (Poor - should be <2.5s)
- CLS: 0.05 (Good)
- FID: 120ms (Needs Improvement - should be <100ms)

Available insights:
- insight1: LCPBreakdown
- insight2: RenderBlocking
- insight3: DocumentLatency
```

**Analyze LCP breakdown:**
```
performance_analyze_insight({
  insightSetId: "insight1",
  insightName: "LCPBreakdown"
})

Output:
LCP Element: <img src="hero-image.jpg" alt="Hero">
LCP Time: 4.2s
Breakdown:
- TTFB: 200ms (Server response)
- Resource load: 4000ms (Image download)
  - Image size: 3.8MB
  - Format: JPEG (unoptimized)
```

**Check render-blocking:**
```
performance_analyze_insight({
  insightSetId: "insight2",
  insightName: "RenderBlocking"
})

Output:
Render-blocking resources:
1. /css/styles.css (450KB, 800ms)
2. /js/vendor.js (1.2MB, 1200ms)
3. /fonts/custom-font.woff2 (200KB, 300ms)
```

---

## Phase 3: Network Analysis

**Check resource sizes:**
```
list_network_requests({ resourceTypes: ["image"] })

Large images:
- hero-image.jpg: 3.8MB (!)
- about-photo.png: 1.2MB
- team-pic.jpg: 900KB

list_network_requests({ resourceTypes: ["script"] })

Large scripts:
- vendor.js: 1.2MB (unminified)
- app.js: 450KB
```

---

## Evidence Collected

1. **Performance trace:** trace-homepage.json.gz (5.2MB)
2. **Core Web Vitals:**
   - LCP: 4.2s (Poor)
   - CLS: 0.05 (Good)
   - FID: 120ms (Needs Improvement)
3. **Bottleneck:** Hero image (3.8MB, 4s download time)
4. **Render-blocking:** CSS (450KB), JS (1.2MB)

---

## Findings

### Critical Issues (Fix Immediately)

**1. Hero Image Too Large - 4s delay**
- **Current:** 3.8MB JPEG
- **Impact:** LCP 4.2s (should be <2.5s)
- **Fix:**
  - Compress image (WebP format, 80% quality)
  - Expected size: ~400KB (10x reduction)
  - Expected LCP: ~1.5s

**2. Render-Blocking JavaScript - 1.2s delay**
- **Current:** vendor.js loaded in `<head>`
- **Impact:** Blocks page render
- **Fix:**
  - Defer non-critical JavaScript
  - Code split vendor bundle
  - Expected improvement: ~800ms faster FCP

### Medium Priority

**3. Large CSS Bundle - 800ms delay**
- **Current:** 450KB CSS loaded synchronously
- **Fix:**
  - Critical CSS inline
  - Defer non-critical styles
  - Expected improvement: ~500ms faster

---

## Recommendations

**High Impact (Implement First):**

1. **Optimize Hero Image**
   ```html
   <picture>
     <source srcset="hero-image.webp" type="image/webp">
     <img src="hero-image.jpg" alt="Hero" width="1200" height="600" loading="eager">
   </picture>
   ```
   Expected improvement: LCP 4.2s → 1.5s

2. **Defer JavaScript**
   ```html
   <script src="/js/vendor.js" defer></script>
   <script src="/js/app.js" defer></script>
   ```
   Expected improvement: FID 120ms → 60ms

3. **Preload Critical Resources**
   ```html
   <link rel="preload" href="/fonts/custom-font.woff2" as="font" crossorigin>
   ```

**Medium Impact:**

4. Code split vendor.js
5. Inline critical CSS
6. Lazy load below-fold images

---

## Expected Results

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| LCP | 4.2s | 1.5s | -2.7s (64%) |
| FID | 120ms | 60ms | -60ms (50%) |
| CLS | 0.05 | 0.05 | No change |
| Page Size | 7.8MB | 2.1MB | -5.7MB (73%) |

---

## Outcome

**Performance Report:** Created comprehensive report
**Priority:** Critical - implement image optimization immediately
**Expected Impact:** LCP Poor → Good, FID Needs Improvement → Good

---

## Takeaways

1. **Images** - Usually the biggest culprit (3.8MB hero image)
2. **WebP** - Modern format saves ~70% file size vs JPEG
3. **Defer JS** - Don't block render for non-critical scripts
4. **Measure first** - Performance trace identified exact bottleneck
5. **Quick wins** - Image compression alone would fix LCP
