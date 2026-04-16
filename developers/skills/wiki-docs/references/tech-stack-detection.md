# Tech Stack Detection Reference

## Overview

This reference describes a **score-based detection system** for identifying which tech stacks a project uses. Rather than a binary check (present/absent), each indicator contributes a weighted score. This approach handles edge cases gracefully — a stray config file does not trigger a false positive, while strong indicators like framework dependencies carry decisive weight.

**Why score-based?**
- A project might have a `composer.json` without being WordPress (could be a plain PHP project)
- A project might have `.jsx` files without React (could use Preact or another JSX runtime)
- Multiple stacks often coexist (WordPress API + React SPA, WordPress + React blocks)
- Scoring lets us set thresholds that reduce false positives while catching real usage

**General Flow:**
1. Run all detection checks in parallel (they are independent)
2. Sum scores per stack
3. Compare against thresholds
4. Build a detection result object with all detected stacks
5. Use the detection result to determine which wiki pages to generate

---

## WordPress Detection

**Threshold: 15+ points = WordPress detected**

| Indicator | Score | Detection Method |
|-----------|-------|-----------------|
| `wp` file exists in project root | +10 | `Glob: wp` |
| `composer.json` contains `WordPress/framework` | +10 | `Grep: "WordPress/framework" in composer.json` |
| `app/Http/Controllers/` directory exists | +5 | `Glob: app/Http/Controllers/` |
| `routes/web.php` or `routes/api.php` exists | +5 | `Glob: routes/{web,api}.php` |
| `database/migrations/` directory exists | +3 | `Glob: database/migrations/` |
| `config/app.php` exists | +3 | `Glob: config/app.php` |
| PHP files reference `Illuminate\\` namespace | +3 | `Grep: "use Illuminate\\\\" in **/*.php` |
| `.env` file with WordPress-style keys (`APP_KEY`, `APP_NAME`) | +2 | `Grep: "APP_KEY=" in .env` |
| `bootstrap/app.php` exists | +2 | `Glob: bootstrap/app.php` |
| `storage/` directory with `logs/`, `framework/` | +1 | `Glob: storage/{logs,framework}/` |

### Tool Commands for WordPress Detection

```
Glob: {project_root}/wp
Glob: {project_root}/app/Http/Controllers/**/*.php
Glob: {project_root}/routes/{web,api}.php
Glob: {project_root}/database/migrations/*.php
Glob: {project_root}/config/app.php
Glob: {project_root}/bootstrap/app.php

Grep: "WordPress/framework" in {project_root}/composer.json
Grep: "use Illuminate\\\\" in {project_root}/**/*.php (head_limit: 5)
Grep: "APP_KEY=" in {project_root}/.env
```

### WordPress Sub-Detection (after confirmed)

Once WordPress is detected, identify which WordPress features are in use:

| Feature | Detection |
|---------|-----------|
| API Routes | `routes/api.php` exists and has content |
| Queues/Jobs | `app/Jobs/` directory has files |
| Events | `app/Events/` directory has files |
| Middleware | `app/Http/Middleware/` has custom files beyond defaults |
| Scheduling | `app/Console/Kernel.php` contains `schedule()` method |
| Broadcasting | `config/broadcasting.php` exists |
| Service Layer | `app/Services/` directory exists |
| Repository Pattern | `app/Repositories/` directory exists |
| Validations | `app/Http/Requests/` has files |
| API Resources | `app/Http/Resources/` has files |
| Policies | `app/Policies/` has files |
| Observers | `app/Observers/` has files |
| Notifications | `app/Notifications/` has files |

---

## React Detection

**Threshold: 10+ points = React detected**

| Indicator | Score | Detection Method |
|-----------|-------|-----------------|
| `package.json` has `react` as dependency or devDependency | +10 | `Grep: "react" in package.json` |
| `.jsx` or `.tsx` files found in project | +5 | `Glob: **/*.{jsx,tsx}` |
| `components/` directory exists (at any depth) | +3 | `Glob: **/components/` |
| `package.json` has `react-dom` | +3 | `Grep: "react-dom" in package.json` |
| State management library present (redux, zustand, recoil, jotai, mobx) | +2 | `Grep: "redux\|zustand\|recoil\|jotai\|mobx" in package.json` |
| `package.json` has `react-router` or `react-router-dom` | +2 | `Grep: "react-router" in package.json` |
| `.jsx`/`.tsx` files import from `react` | +2 | `Grep: "from 'react'" in **/*.{jsx,tsx}` |
| `hooks/` directory exists | +1 | `Glob: **/hooks/` |
| CSS modules or styled-components in use | +1 | `Glob: **/*.module.{css,scss}` or `Grep: "styled-components" in package.json` |

### Tool Commands for React Detection

```
Grep: "\"react\"" in {project_root}/package.json
Grep: "\"react-dom\"" in {project_root}/package.json
Grep: "redux\|zustand\|recoil\|jotai\|mobx" in {project_root}/package.json
Grep: "react-router" in {project_root}/package.json

Glob: {project_root}/**/*.jsx (head_limit: 5)
Glob: {project_root}/**/*.tsx (head_limit: 5)
Glob: {project_root}/**/components/
Glob: {project_root}/**/hooks/
```

### React Sub-Detection (after confirmed)

| Feature | Detection |
|---------|-----------|
| TypeScript | `.tsx` files present, `tsconfig.json` exists |
| State Mgmt | Which library: redux, zustand, recoil, jotai, mobx |
| Routing | react-router, tanstack-router, wouter |
| Form Handling | react-hook-form, formik, final-form |
| Data Fetching | tanstack-query, swr, apollo, urql |
| Styling | tailwind, styled-components, emotion, CSS modules, sass |
| Testing | jest, vitest, testing-library, cypress, playwright |
| Component Library | MUI, Ant Design, Chakra UI, Radix, Shadcn |

---

## NextJS Detection

**Threshold: 10+ points = NextJS detected**

| Indicator | Score | Detection Method |
|-----------|-------|-----------------|
| `package.json` has `next` as dependency | +10 | `Grep: "\"next\"" in package.json` |
| `next.config.js`, `next.config.mjs`, or `next.config.ts` exists | +10 | `Glob: next.config.{js,mjs,ts}` |
| `pages/` directory with route files (`.js`, `.tsx`) | +5 | `Glob: pages/**/*.{js,jsx,ts,tsx}` |
| `app/` directory with `layout.{js,tsx}` or `page.{js,tsx}` | +5 | `Glob: app/**/layout.{js,jsx,ts,tsx}` or `Glob: app/**/page.{js,jsx,ts,tsx}` |
| `pages/api/` or `app/api/` directory exists | +3 | `Glob: {pages,app}/api/` |
| `pages/_app.{js,tsx}` or `pages/_document.{js,tsx}` | +3 | `Glob: pages/_{app,document}.{js,tsx}` |
| `public/` directory exists | +1 | `Glob: public/` |
| Middleware file exists (`middleware.{js,ts}`) | +2 | `Glob: middleware.{js,ts}` |

### Tool Commands for NextJS Detection

```
Grep: "\"next\"" in {project_root}/package.json
Glob: {project_root}/next.config.{js,mjs,ts}
Glob: {project_root}/pages/**/*.{js,jsx,ts,tsx} (head_limit: 5)
Glob: {project_root}/app/**/page.{js,jsx,ts,tsx} (head_limit: 5)
Glob: {project_root}/app/**/layout.{js,jsx,ts,tsx} (head_limit: 5)
Glob: {project_root}/{pages,app}/api/**/*.{js,ts} (head_limit: 5)
Glob: {project_root}/middleware.{js,ts}
```

### NextJS Sub-Detection (after confirmed)

| Feature | Detection |
|---------|-----------|
| Router Type | `app/` directory = App Router; `pages/` directory = Pages Router; both = hybrid |
| API Routes | `pages/api/` or `app/api/` present |
| SSR Pages | `getServerSideProps` usage in pages |
| SSG Pages | `getStaticProps` / `getStaticPaths` usage |
| Server Components | files in `app/` without `"use client"` directive |
| Middleware | `middleware.{js,ts}` in root |
| i18n | `next.config` has `i18n` configuration |
| Image Optimization | `next/image` imports |

**Note:** When NextJS is detected, React is also implicitly detected (NextJS includes React). Add React score automatically if NextJS passes threshold.

---

## WordPress Detection

**Threshold: 10+ points = WordPress detected**

| Indicator | Score | Detection Method |
|-----------|-------|-----------------|
| PHP file with `Plugin Name:` header comment | +10 | `Grep: "Plugin Name:" in *.php` (root-level) |
| `functions.php` exists AND `style.css` has `Theme Name:` | +10 | `Glob: functions.php` + `Grep: "Theme Name:" in style.css` |
| `add_action` or `add_filter` function calls | +5 | `Grep: "add_action\|add_filter" in **/*.php` |
| `wp_enqueue_script` or `wp_enqueue_style` calls | +3 | `Grep: "wp_enqueue_script\|wp_enqueue_style" in **/*.php` |
| `$wpdb` usage | +3 | `Grep: "\\$wpdb" in **/*.php` |
| `register_rest_route` usage | +3 | `Grep: "register_rest_route" in **/*.php` |
| `register_post_type` or `register_taxonomy` | +3 | `Grep: "register_post_type\|register_taxonomy" in **/*.php` |
| `wp-config.php` exists | +5 | `Glob: wp-config.php` |
| `includes/` or `inc/` directory with PHP files | +2 | `Glob: {includes,inc}/**/*.php` |
| `admin/` directory with PHP files | +2 | `Glob: admin/**/*.php` |
| `languages/` directory with `.pot`/`.po` files | +1 | `Glob: languages/*.{pot,po}` |

### Tool Commands for WordPress Detection

```
Grep: "Plugin Name:" in {project_root}/*.php
Grep: "Theme Name:" in {project_root}/style.css
Grep: "add_action\|add_filter" in {project_root}/**/*.php (head_limit: 5)
Grep: "wp_enqueue_script\|wp_enqueue_style" in {project_root}/**/*.php (head_limit: 5)
Grep: "\\$wpdb" in {project_root}/**/*.php (head_limit: 5)
Grep: "register_rest_route" in {project_root}/**/*.php (head_limit: 5)

Glob: {project_root}/functions.php
Glob: {project_root}/wp-config.php
```

### WordPress Sub-Detection (after confirmed)

| Feature | Detection |
|---------|-----------|
| Plugin vs Theme | `Plugin Name:` header = plugin; `Theme Name:` in style.css = theme |
| REST API | `register_rest_route` usage |
| AJAX Handlers | `wp_ajax_` action hooks |
| Custom Post Types | `register_post_type` calls |
| Taxonomies | `register_taxonomy` calls |
| Gutenberg Blocks | `register_block_type` or `block.json` files |
| Settings API | `register_setting` / `add_settings_section` |
| Admin Pages | `add_menu_page` / `add_submenu_page` |
| WP-CLI Commands | `WP_CLI::add_command` |
| Meta Boxes | `add_meta_box` calls |
| Shortcodes | `add_shortcode` calls |
| Widgets | extends `WP_Widget` |
| Cron Jobs | `wp_schedule_event` / `wp_cron` |

---

## Hybrid / Multi-Stack Detection

Many real-world projects combine multiple stacks. Run all detection checks independently and report all stacks that pass their threshold.

### Common Combinations

| Combination | Typical Structure | Wiki Strategy |
|-------------|-------------------|---------------|
| WordPress + React SPA | WordPress in root, React in `resources/js/` or separate `frontend/` dir | Generate both WordPress and React wiki pages, plus API pages for the contract between them |
| WordPress + NextJS | WordPress API in one directory, NextJS in another (monorepo) | Generate both sets of pages, emphasize API documentation as the integration layer |
| WordPress + React Blocks | WordPress plugin/theme with React-based Gutenberg blocks | Generate WordPress pages plus React component pages for block internals |
| NextJS Full Stack | NextJS with API routes serving as backend | Generate NextJS pages with emphasis on API routes, server components, and data flow |
| WordPress + REST API consumers | WordPress as headless CMS, separate frontend | Generate WordPress pages focused on REST API, plus frontend pages |

### Detection Logic for Hybrids

```
1. Run all 4 stack detections independently
2. Collect all stacks that pass threshold
3. If multiple stacks detected:
   a. Check if they share the same package.json/composer.json (monolith)
   b. Check if they live in separate directories (monorepo)
   c. Identify the integration points (API routes, shared database, etc.)
4. Generate wiki pages for ALL detected stacks
5. Add integration-specific pages (API docs, shared models, etc.)
```

### Monorepo Detection

If the project root contains multiple independent directories with their own manifests:

```
Glob: {project_root}/*/composer.json
Glob: {project_root}/*/package.json
Glob: {project_root}/packages/*/package.json
Glob: {project_root}/apps/*/package.json
```

If found, run stack detection independently in each sub-directory and report per-directory results.

---

## Decision Matrix: Stacks to Wiki Pages

Based on detection results, determine which wiki page templates to generate.

| Detected Stack | Wiki Pages to Include |
|----------------|----------------------|
| **Always** (any project) | Home, Getting-Started, Architecture-Overview, Environment-Configuration, Testing-Guide, Deployment-Guide, Contributing-Guide, Troubleshooting-FAQ, Changelog, _Sidebar, _Footer |
| **WordPress** | Service-Layer-Architecture, Controllers-Request-Lifecycle, Models-Relationships, Middleware-Guards, Jobs-Events-Listeners, Queues-Scheduling, Caching-Strategy |
| **React** | Component-Architecture, State-Management, Routing-Navigation, Styling-Theming, Custom-Hooks, Form-Handling-Validation, Error-Handling-Boundaries |
| **NextJS** | All React pages PLUS NextJS-specific sections (SSR/SSG, App Router, Middleware) integrated into the React templates |
| **WordPress** | Plugin-Theme-Architecture, Hooks-Filters-Reference, Custom-Post-Types-Taxonomies, Admin-Pages-Settings, Gutenberg-Blocks, WP-CLI-Commands |
| **Has API** (any stack) | API-Overview-Authentication, Endpoint-Reference, Request-Response-Formats, Error-Handling-Status-Codes, Rate-Limiting-Pagination, Webhooks |
| **Has Database** | Database-Schema (included in common, but enhanced with stack-specific ORM details) |

### Conditional Page Inclusion

Some pages are only generated if the corresponding feature is detected during sub-detection:

- Jobs-Events-Listeners: only if `app/Jobs/` or `app/Events/` exist
- Queues-Scheduling: only if queue config or scheduled tasks found
- Gutenberg-Blocks: only if `block.json` or `register_block_type` found
- WP-CLI-Commands: only if `WP_CLI::add_command` found
- Webhooks: only if webhook handlers or dispatchers found
- Custom-Hooks: only if `hooks/` directory with custom hooks found
- State-Management: only if state management library detected

Pages should still be listed in the sidebar even if marked as "No {feature} detected in this project" — this helps developers know where to document these features when they add them.

---

## Detection Result Structure

After running all checks, produce a mental model like this:

```
Detection Results:
  WordPress: {score}/36 (threshold: 15) -> {detected: true/false}
  React: {score}/29 (threshold: 10) -> {detected: true/false}
  NextJS: {score}/39 (threshold: 10) -> {detected: true/false}
  WordPress: {score}/47 (threshold: 10) -> {detected: true/false}

  Detected Stacks: [{stack_list}]
  Project Type: {monolith|monorepo|single-stack}

  Sub-features:
    WordPress: [{feature_list}]
    React: [{feature_list}]
    WordPress: [{feature_list}]

  Wiki Pages to Generate: [{page_list}]
```

This result drives the entire wiki generation process — scanning strategy, page selection, and content depth all depend on accurate detection.


