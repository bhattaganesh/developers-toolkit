# Performance Profiling Guide

Guide to analyzing page performance and Core Web Vitals.

---

## Core Web Vitals

### LCP (Largest Contentful Paint)
**What:** Time until largest content element visible
**Good:** <2.5s | **Needs Improvement:** 2.5-4s | **Poor:** >4s

**Common Causes:**
- Large images not optimized
- Slow server response
- Render-blocking resources
- Client-side rendering delays

**Solutions:**
- Optimize images (WebP, compression, lazy loading)
- Use CDN
- Preload critical resources
- Server-side rendering

### CLS (Cumulative Layout Shift)
**What:** Visual stability - unexpected layout shifts
**Good:** <0.1 | **Needs Improvement:** 0.1-0.25 | **Poor:** >0.25

**Common Causes:**
- Images without dimensions
- Ads/embeds without reserved space
- Web fonts causing FOIT/FOUT
- Dynamic content injected

**Solutions:**
- Set explicit width/height on images/videos
- Reserve space for ads
- Use `font-display: swap`
- Avoid inserting content above existing

### FID (First Input Delay)
**What:** Time from first interaction to browser response
**Good:** <100ms | **Needs Improvement:** 100-300ms | **Poor:** >300ms

**Common Causes:**
- Large JavaScript execution
- Long tasks blocking main thread
- Heavy third-party scripts

**Solutions:**
- Code splitting
- Defer non-critical JS
- Web workers for heavy computation
- Reduce JavaScript execution time

---

## Performance Trace Workflow

### Basic Workflow

```javascript
# 1. Start trace (auto-reload)
performance_start_trace({
  reload: true,
  autoStop: true
});

# Trace automatically stops after page load
# Results include Core Web Vitals
```

### Manual Workflow

```javascript
# 1. Start trace
performance_start_trace({
  reload: false,
  autoStop: false
});

# 2. Perform interactions
# (click, scroll, navigate, etc.)

# 3. Stop trace
performance_stop_trace({
  filePath: "./trace-2026-02-07.json.gz"
});

# Trace saved for manual analysis
```

---

## Analyzing Insights

### Available Insights

- **LCPBreakdown** - Why LCP slow, what element
- **DocumentLatency** - Document load time
- **RenderBlocking** - Blocking resources
- **LayoutShift** - What causes CLS
- **SlowCSSSelector** - Inefficient selectors

### Getting Insight Details

```javascript
# After stopping trace, list available insights
# (from trace results)

# Analyze specific insight
performance_analyze_insight({
  insightSetId: "abc123",
  insightName: "LCPBreakdown"
});

# Returns detailed breakdown of LCP
```

---

## Performance Budget

### Recommended Thresholds

| Metric | Good | Budget |
|--------|------|--------|
| Total Page Size | <1MB | <2MB |
| JavaScript | <200KB | <500KB |
| Images | <500KB | <1MB |
| Fonts | <100KB | <200KB |
| Time to Interactive | <3s | <5s |
| Total Requests | <50 | <100 |

---

## Common Issues & Fixes

### Issue: Slow LCP

**Diagnosis:**
- LCP > 2.5s
- Analyze LCPBreakdown insight

**Fixes:**
1. Optimize LCP element (usually hero image)
2. Preload critical resources: `<link rel="preload">`
3. Use CDN for images
4. Compress images (WebP, 85% quality)
5. Server-side rendering

### Issue: High CLS

**Diagnosis:**
- CLS > 0.1
- Analyze LayoutShift insight

**Fixes:**
1. Set dimensions on images/videos:
   ```html
   <img src="hero.jpg" width="1200" height="600" alt="Hero">
   ```
2. Reserve space for ads:
   ```css
   .ad-container {
     min-height: 250px;
   }
   ```
3. Use `font-display: swap`:
   ```css
   @font-face {
     font-display: swap;
   }
   ```

### Issue: Poor FID

**Diagnosis:**
- FID > 100ms
- Long tasks blocking main thread

**Fixes:**
1. Code splitting (load only needed code)
2. Defer non-critical JavaScript:
   ```html
   <script defer src="non-critical.js"></script>
   ```
3. Use web workers for heavy computation
4. Reduce third-party scripts

---

## See Also

- [chrome-devtools-api.md](./chrome-devtools-api.md) - Performance tool reference
- [templates/performance-report.md](../templates/performance-report.md) - Report template
