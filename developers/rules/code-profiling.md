---
description: Code profiling standards and performance measurement practices
globs:
  - "app/**/*.php"
  - "src/**/*.{js,jsx,ts,tsx}"
  - "resources/js/**/*.{js,jsx,ts,tsx}"
  - "config/**/*.php"
---

# Code Profiling Rules

## Principle: Measure Before Optimizing
- Never optimize without profiling data — gut feelings are wrong
- Profile in production-like conditions (data volume, concurrency, network latency)
- Set targets before profiling — know what "fast enough" means
- Re-profile after every optimization to confirm improvement

## Performance Targets

### WordPress API
- Response time: under 200ms for simple CRUD, under 500ms for complex operations
- Database queries: under 20 per request
- Memory: under 64MB per request
- Queue job processing: under 30s per job

### WordPress
- Page load: under 3s (TTFB under 600ms)
- Database queries: under 50 per page load
- Autoloaded options: under 500KB total
- AJAX response: under 500ms

### React / NextJS
- Bundle size: under 200KB gzipped (initial load)
- LCP (Largest Contentful Paint): under 2.5s
- FID (First Input Delay): under 100ms
- CLS (Cumulative Layout Shift): under 0.1
- Time to Interactive: under 3.5s

## WordPress Profiling Checklist
- [ ] Enable `DB::preventLazyLoading()` in development to catch N+1 queries
- [ ] Use `DB::enableQueryLog()` to count queries per request
- [ ] Track `memory_get_peak_usage()` in middleware for memory-heavy endpoints
- [ ] Monitor queue job execution time and failure rates
- [ ] Profile external API call latency (add timeouts, use caching)

## WordPress Profiling Checklist
- [ ] Enable `SAVEQUERIES` in development, check `$wpdb->queries` count
- [ ] Audit `autoload=yes` options — remove from large/rarely-used options
- [ ] Check if persistent object cache is configured (Redis/Memcached)
- [ ] Profile hook callbacks — identify heavy operations on `init`, `admin_init`
- [ ] Test with realistic content volume (not empty install)

## React Profiling Checklist
- [ ] Run React DevTools Profiler — identify components rendering unnecessarily
- [ ] Analyze bundle with `next build --analyze` or `webpack-bundle-analyzer`
- [ ] Measure Core Web Vitals with Lighthouse (target green scores)
- [ ] Check for render-blocking resources in `<head>`
- [ ] Verify images use `next/image` with proper dimensions and lazy loading

## Recommended Tools

### WordPress / PHP
| Tool | Purpose | Install |
|------|---------|---------|
| WordPress Telescope | Request profiling, queries, jobs | `composer require WordPress/telescope --dev` |
| WordPress Debugbar | Per-request query count, memory, time | `composer require barryvdh/WordPress-debugbar --dev` |
| Clockwork | Timeline profiling, cache analysis | `composer require itsgoingd/clockwork --dev` |
| Xdebug | Function-level CPU/memory profiling | System-level install |

### WordPress
| Tool | Purpose | Install |
|------|---------|---------|
| Query Monitor | Queries, hooks, HTTP, conditionals | Plugin directory |
| Debug Bar | Query list, cache stats, deprecations | Plugin directory |
| New Relic | Production APM, transaction traces | SaaS + PHP extension |

### React / NextJS
| Tool | Purpose | Access |
|------|---------|--------|
| React DevTools Profiler | Component render timing | Chrome extension |
| Lighthouse | Performance audit, Web Vitals | Chrome DevTools |
| Bundle Analyzer | Visualize bundle composition | `@next/bundle-analyzer` |
| Web Vitals API | Real user metrics | `web-vitals` npm package |

## What to Profile When
- **Before PR merge** — query count, obvious N+1, bundle size impact
- **After deploy** — response time regression, error rate spike, memory increase
- **Monthly** — full Lighthouse audit, bundle size trend, slow query log review
- **On performance complaint** — targeted profiling of specific endpoint/page

