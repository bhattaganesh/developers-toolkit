# Codebase Scanning Strategy Reference

## Scanning Philosophy

Five principles guide how the wiki-docs skill discovers and analyzes a codebase:

1. **Read, Don't Guess** — Never assume architecture from the stack name alone. A "WordPress project" might use a service-repository pattern, Clean architectures, or action classes. Read the actual code to determine the real patterns in use.

2. **Structure First** — Map the directory tree before reading individual files. Understanding where things live reveals architectural decisions (flat vs. layered, monolith vs. modular, convention vs. configuration).

3. **Follow the Data** — Trace how data flows through the system: entry point (route/URL) -> handler (controller/page) -> business logic (service/model) -> storage (database/API) -> response (view/JSON). This flow becomes the backbone of the wiki.

4. **Pattern Recognition** — Look for repeated patterns across the codebase. If 80% of controllers follow a thin-controller pattern, document that as the standard. Note deviations, but document the norm.

5. **Recent Changes Matter** — Git history reveals active areas, current contributors, and evolving patterns. Recent commits indicate what the team is working on and what documentation is most urgently needed.

---

## Quick Start: Essential Tool Patterns

These are the most commonly used tool patterns during scanning. Reference them throughout the process.

### File Discovery (Glob)

```
# Find all files of a type
Glob: {project_root}/**/*.php
Glob: {project_root}/**/*.{js,jsx,ts,tsx}
Glob: {project_root}/**/*.{css,scss}

# Find specific config files
Glob: {project_root}/**/composer.json
Glob: {project_root}/**/package.json
Glob: {project_root}/**/*.config.{js,mjs,ts}

# Find directories (use trailing pattern)
Glob: {project_root}/**/Controllers/**/*.php
Glob: {project_root}/**/components/**/*.{jsx,tsx}
```

### Content Search (Grep)

```
# Search for patterns in specific file types
Grep: "pattern" in {project_root}/**/*.php
Grep: "pattern" in {project_root}/**/*.{js,ts,jsx,tsx}

# Search in specific files
Grep: "pattern" in {project_root}/composer.json
Grep: "pattern" in {project_root}/package.json

# Use output_mode for different needs
output_mode: "files_with_matches"  -> just file paths (fast)
output_mode: "content"             -> matching lines (detailed)
output_mode: "count"               -> match counts (metrics)
```

### File Reading (Read)

```
# Read full file (short config files)
Read: {project_root}/composer.json
Read: {project_root}/package.json

# Read with line limits (long source files)
Read: {project_root}/{file_path} (offset: 1, limit: 100)
```

---

## Parallel Scanning Groups

After tech stack detection, run these 6 scanning groups **in parallel** since they are independent of each other. Each group gathers a specific category of information.

### Group 1: Core Files & Manifests

**Purpose:** Understand dependencies, project metadata, and entry points.

**Files to Read:**

```
# Package manifests — read in full
Read: {project_root}/composer.json
Read: {project_root}/package.json

# Project documentation
Read: {project_root}/README.md
Read: {project_root}/CLAUDE.md
Read: {project_root}/CONTRIBUTING.md

# Environment configuration
Read: {project_root}/.env.example
Read: {project_root}/.env.sample

# Entry points
Read: {project_root}/wp                        # WordPress
Read: {project_root}/next.config.{js,mjs,ts}        # NextJS
Read: {project_root}/{main_plugin_file}.php          # WordPress
Read: {project_root}/functions.php                   # WordPress theme
Read: {project_root}/style.css                       # WordPress theme (header only)
```

**What to Extract:**
- Project name, version, description
- All dependencies and their versions
- PHP/Node version requirements
- Scripts defined (build, test, lint, deploy)
- License information
- Author and repository URL

### Group 2: API Endpoints & Routes

**Purpose:** Map every API endpoint and route in the system.

**WordPress Routes:**

```
Glob: {project_root}/routes/*.php
Read: {project_root}/routes/api.php
Read: {project_root}/routes/web.php
Read: {project_root}/routes/channels.php
Read: {project_root}/routes/console.php

# Find route groups and middleware assignments
Grep: "Route::" in {project_root}/routes/**/*.php (output_mode: "content")
Grep: "middleware" in {project_root}/routes/**/*.php (output_mode: "content")
```

**WordPress REST API:**

```
Grep: "register_rest_route" in {project_root}/**/*.php (output_mode: "content")
Grep: "wp_ajax_" in {project_root}/**/*.php (output_mode: "content")
Grep: "wp_ajax_nopriv_" in {project_root}/**/*.php (output_mode: "content")
```

**NextJS API Routes:**

```
Glob: {project_root}/pages/api/**/*.{js,ts}
Glob: {project_root}/app/api/**/route.{js,ts}

# Read each API route file to understand handlers
# (iterate over glob results)
```

**GraphQL (any stack):**

```
Glob: {project_root}/**/*.graphql
Glob: {project_root}/**/*.gql
Grep: "type Query" in {project_root}/**/*.{graphql,gql,js,ts,php}
Grep: "type Mutation" in {project_root}/**/*.{graphql,gql,js,ts,php}
```

**What to Extract:**
- Complete list of endpoints (method, path, handler)
- Middleware/guard assignments per route
- Route grouping and prefix patterns
- Authentication requirements per route
- Request parameter expectations

### Group 3: Database & Models

**Purpose:** Map the complete data model and storage layer.

**WordPress:**

```
Glob: {project_root}/database/migrations/*.php
Glob: {project_root}/app/Models/*.php
Read: {project_root}/config/database.php

# Read each model to understand relationships
Grep: "hasMany\|belongsTo\|hasOne\|belongsToMany\|morphTo\|morphMany" in {project_root}/app/Models/**/*.php (output_mode: "content")

# Find scopes
Grep: "scope[A-Z]" in {project_root}/app/Models/**/*.php (output_mode: "content")

# Find casts
Grep: "\\$casts\|protected function casts" in {project_root}/app/Models/**/*.php (output_mode: "content")
```

**WordPress:**

```
Grep: "\\$wpdb->prefix" in {project_root}/**/*.php (output_mode: "content")
Grep: "dbDelta" in {project_root}/**/*.php (output_mode: "content")
Grep: "CREATE TABLE" in {project_root}/**/*.php (output_mode: "content")
Grep: "register_post_type" in {project_root}/**/*.php (output_mode: "content")
Grep: "register_taxonomy" in {project_root}/**/*.php (output_mode: "content")
Grep: "register_meta" in {project_root}/**/*.php (output_mode: "content")
```

**General:**

```
Glob: {project_root}/**/schema.prisma
Glob: {project_root}/**/schema.sql
Glob: {project_root}/**/*.sql
```

**What to Extract:**
- All tables/models and their columns/fields
- Relationships between models (1:1, 1:N, M:N)
- Indexes and constraints
- Custom post types and taxonomies (WordPress)
- Migration history and naming patterns

### Group 4: Frontend Structure

**Purpose:** Map UI components, state management, routing, and styling patterns.

**Components:**

```
Glob: {project_root}/**/components/**/*.{jsx,tsx,js,ts,vue}
Glob: {project_root}/**/pages/**/*.{jsx,tsx,js,ts}
Glob: {project_root}/**/views/**/*.{jsx,tsx,blade.php,vue}
Glob: {project_root}/**/layouts/**/*.{jsx,tsx,js,ts}

# Count components to understand scale
Glob: {project_root}/**/*.{jsx,tsx} (count results)
```

**State Management:**

```
Glob: {project_root}/**/store/**/*.{js,ts}
Glob: {project_root}/**/stores/**/*.{js,ts}
Glob: {project_root}/**/redux/**/*.{js,ts}
Glob: {project_root}/**/slices/**/*.{js,ts}
Grep: "createSlice\|createStore\|create(" in {project_root}/**/*.{js,ts} (output_mode: "files_with_matches")
Grep: "useContext\|createContext" in {project_root}/**/*.{jsx,tsx} (output_mode: "files_with_matches")
```

**Routing:**

```
# NextJS (file-based routing — the file structure IS the routing)
Glob: {project_root}/app/**/page.{js,jsx,ts,tsx}
Glob: {project_root}/pages/**/*.{js,jsx,ts,tsx}

# React Router
Grep: "createBrowserRouter\|<Route\|<Routes" in {project_root}/**/*.{jsx,tsx} (output_mode: "content")

# WordPress Blade views
Glob: {project_root}/resources/views/**/*.blade.php
```

**Styling:**

```
Glob: {project_root}/**/*.module.{css,scss}
Glob: {project_root}/**/tailwind.config.{js,ts,mjs}
Glob: {project_root}/**/*.styled.{js,ts,tsx}
Grep: "styled-components\|@emotion\|tailwindcss" in {project_root}/package.json
```

**Hooks (React):**

```
Glob: {project_root}/**/hooks/**/*.{js,ts}
Grep: "export function use[A-Z]\|export const use[A-Z]" in {project_root}/**/*.{js,ts,jsx,tsx} (output_mode: "content")
```

**What to Extract:**
- Component hierarchy and naming conventions
- State management approach and store structure
- Routing pattern (file-based vs. config-based)
- Styling methodology (CSS modules, Tailwind, styled-components)
- Shared/reusable components vs. page-specific components
- Custom hooks catalog

### Group 5: Backend Structure

**Purpose:** Map controllers, services, middleware, background processing, and business logic.

**WordPress:**

```
Glob: {project_root}/app/Http/Controllers/**/*.php
Glob: {project_root}/app/Services/**/*.php
Glob: {project_root}/app/Http/Middleware/**/*.php
Glob: {project_root}/app/Jobs/**/*.php
Glob: {project_root}/app/Events/**/*.php
Glob: {project_root}/app/Listeners/**/*.php
Glob: {project_root}/app/Observers/**/*.php
Glob: {project_root}/app/Policies/**/*.php
Glob: {project_root}/app/Http/Requests/**/*.php
Glob: {project_root}/app/Http/Resources/**/*.php
Glob: {project_root}/app/Actions/**/*.php
Glob: {project_root}/app/Notifications/**/*.php

Read: {project_root}/app/Http/Kernel.php
Read: {project_root}/app/Providers/AppServiceProvider.php
Read: {project_root}/app/Providers/AuthServiceProvider.php
```

**WordPress:**

```
Grep: "add_action\|add_filter" in {project_root}/**/*.php (output_mode: "content")
Grep: "add_menu_page\|add_submenu_page" in {project_root}/**/*.php (output_mode: "content")
Grep: "add_meta_box" in {project_root}/**/*.php (output_mode: "content")
Grep: "register_setting" in {project_root}/**/*.php (output_mode: "content")
Grep: "add_shortcode" in {project_root}/**/*.php (output_mode: "content")
Grep: "WP_CLI::add_command" in {project_root}/**/*.php (output_mode: "content")
Grep: "register_block_type" in {project_root}/**/*.php (output_mode: "content")
```

**NextJS Server-Side:**

```
Grep: "getServerSideProps\|getStaticProps\|getStaticPaths" in {project_root}/**/*.{js,jsx,ts,tsx} (output_mode: "files_with_matches")
Grep: "'use server'" in {project_root}/**/*.{js,ts,jsx,tsx} (output_mode: "files_with_matches")
Glob: {project_root}/app/**/loading.{js,tsx}
Glob: {project_root}/app/**/error.{js,tsx}
Glob: {project_root}/middleware.{js,ts}
```

**What to Extract:**
- Controller/handler patterns (thin vs. fat, resource vs. custom)
- Service layer presence and pattern
- Middleware stack and order
- Background job types and queue assignments
- Event-driven architecture patterns
- Authentication and authorization strategy

### Group 6: Infrastructure & DevOps

**Purpose:** Understand CI/CD, containerization, testing setup, and deployment.

```
# CI/CD
Glob: {project_root}/.github/workflows/*.{yml,yaml}
Glob: {project_root}/.gitlab-ci.yml
Glob: {project_root}/Jenkinsfile
Glob: {project_root}/.circleci/config.yml

# Containerization
Glob: {project_root}/Dockerfile*
Glob: {project_root}/docker-compose*.{yml,yaml}
Glob: {project_root}/.dockerignore

# Testing
Glob: {project_root}/phpunit.xml*
Glob: {project_root}/jest.config.{js,ts,mjs}
Glob: {project_root}/vitest.config.{js,ts,mjs}
Glob: {project_root}/cypress.config.{js,ts}
Glob: {project_root}/playwright.config.{js,ts}

# Linting & Formatting
Glob: {project_root}/.eslintrc*
Glob: {project_root}/eslint.config.{js,mjs}
Glob: {project_root}/.prettierrc*
Glob: {project_root}/phpcs.xml*
Glob: {project_root}/pint.json
Glob: {project_root}/phpstan.neon*

# Deployment
Glob: {project_root}/deploy.{sh,yml,yaml}
Glob: {project_root}/Procfile
Glob: {project_root}/vercel.json
Glob: {project_root}/netlify.toml
Glob: {project_root}/fly.toml
Glob: {project_root}/render.yaml

# Environment
Read: {project_root}/.env.example
Glob: {project_root}/.env*
```

**What to Extract:**
- CI/CD pipeline stages and triggers
- Test runner configuration and coverage targets
- Docker services and build configuration
- Deployment targets and strategies
- Environment variables required
- Code quality tools in use

---

## Sequential Operations (After Parallel Groups)

These steps depend on results from the parallel groups and must run after them.

### 1. Analyze Patterns

After collecting all data, identify repeating patterns:

```
# What pattern do controllers follow?
# Read 3-5 controller files and compare structure

# What naming conventions are used?
# Compare file names, class names, function names across the codebase

# What is the test-to-source ratio?
# Count test files vs. source files
Glob: {project_root}/**/tests/**/*.php (count)
Glob: {project_root}/**/*.test.{js,ts,jsx,tsx} (count)
Glob: {project_root}/**/*.spec.{js,ts,jsx,tsx} (count)
```

### 2. Check Git History

```bash
# Recent activity (last 20 commits)
git log --oneline -20

# Active contributors
git shortlog -sn --no-merges | head -10

# Recently modified files (indicates active development areas)
git log --name-only --pretty=format: -20 | sort | uniq -c | sort -rn | head -20

# Tag history (releases)
git tag --sort=-creatordate | head -10

# Branch patterns
git branch -r --sort=-committerdate | head -10
```

### 3. Identify Conventions

Read a representative sample of files from each category (3-5 files per category) and note:

- Naming conventions (camelCase, snake_case, PascalCase, kebab-case)
- File organization patterns (by feature, by type, by domain)
- Comment/documentation style (JSDoc, PHPDoc, inline)
- Error handling patterns (try/catch, Result types, exception classes)
- Import organization (grouped, sorted, aliased)

---

## Stack-Specific Deep Dives

After the general scan, perform stack-specific deep analysis on confirmed stacks.

### WordPress Deep Dive

```
# Service Providers — reveal bootstrapping and bindings
Glob: {project_root}/app/Providers/**/*.php
# Read each provider to understand service bindings

# Configuration — reveals feature flags and environment-dependent behavior
Glob: {project_root}/config/*.php
# Read key configs: app.php, auth.php, database.php, queue.php, cache.php, mail.php

# wp Commands — reveals CLI tools available
Glob: {project_root}/app/Console/Commands/**/*.php
Read: {project_root}/app/Console/Kernel.php

# Exception Handling
Read: {project_root}/app/Exceptions/Handler.php

# API Versioning (if applicable)
Glob: {project_root}/routes/api_v*.php
Grep: "prefix.*v[0-9]" in {project_root}/routes/*.php (output_mode: "content")
```

### WordPress Deep Dive

```
# Main plugin/theme file — reveals initialization order
Read: {project_root}/{main_plugin_file}.php

# Autoloading or file includes
Grep: "require_once\|include_once\|require \|include " in {project_root}/**/*.php (output_mode: "content", head_limit: 30)

# Activation/Deactivation hooks
Grep: "register_activation_hook\|register_deactivation_hook" in {project_root}/**/*.php (output_mode: "content")

# Internationalization
Grep: "__(\|_e(\|esc_html__(\|esc_attr__(" in {project_root}/**/*.php (output_mode: "count")
Glob: {project_root}/languages/*.pot

# Block Editor assets
Glob: {project_root}/**/block.json
Glob: {project_root}/src/blocks/**/*.{js,jsx,ts,tsx}
```

### React/NextJS Deep Dive

```
# App entry point and providers
Read: {project_root}/src/index.{js,jsx,ts,tsx}
Read: {project_root}/src/App.{js,jsx,ts,tsx}
Read: {project_root}/pages/_app.{js,jsx,ts,tsx}
Read: {project_root}/app/layout.{js,jsx,ts,tsx}

# Types/Interfaces (TypeScript projects)
Glob: {project_root}/**/types/**/*.{ts,tsx}
Glob: {project_root}/**/*.d.ts
Grep: "interface \|type " in {project_root}/**/types/**/*.ts (output_mode: "content", head_limit: 50)

# API integration layer
Glob: {project_root}/**/api/**/*.{js,ts}
Glob: {project_root}/**/services/**/*.{js,ts}
Grep: "fetch(\|axios\|useSWR\|useQuery" in {project_root}/**/*.{js,ts,jsx,tsx} (output_mode: "files_with_matches")

# Environment and config
Read: {project_root}/.env.local.example
Read: {project_root}/.env.development
Grep: "process.env\.\|import.meta.env\." in {project_root}/**/*.{js,ts,jsx,tsx} (output_mode: "content", head_limit: 30)
```

---

## Scanning Checklist

Before generating wiki pages, verify you have gathered:

### General (All Projects)
- [ ] Project name, version, and description
- [ ] All dependencies listed with versions
- [ ] Runtime requirements (PHP version, Node version)
- [ ] Environment variables catalog
- [ ] Directory structure mapped
- [ ] Git history analyzed (recent commits, contributors, tags)
- [ ] README content reviewed
- [ ] Testing framework and configuration identified
- [ ] CI/CD pipeline understood
- [ ] Deployment strategy identified
- [ ] License information

### WordPress Projects
- [ ] All routes mapped (web, API, console, channels)
- [ ] All models listed with relationships
- [ ] All migrations reviewed for schema understanding
- [ ] Service providers and their bindings
- [ ] Middleware stack documented
- [ ] Controller patterns identified
- [ ] Job/Event/Listener catalog
- [ ] Queue configuration
- [ ] Cache configuration
- [ ] Authentication/Authorization strategy

### WordPress Projects
- [ ] Plugin/Theme type identified
- [ ] Main file and initialization flow
- [ ] All hooks (actions/filters) cataloged
- [ ] Custom post types and taxonomies listed
- [ ] REST API endpoints mapped
- [ ] Admin pages and settings documented
- [ ] Block editor integration assessed
- [ ] WP-CLI commands listed
- [ ] Database tables (custom) identified

### React/NextJS Projects
- [ ] Component hierarchy mapped
- [ ] State management approach documented
- [ ] Routing structure outlined
- [ ] Custom hooks cataloged
- [ ] Styling approach identified
- [ ] Data fetching patterns documented
- [ ] TypeScript usage and type definitions
- [ ] Error boundary strategy
- [ ] Form handling approach

### API Documentation
- [ ] All endpoints with method, path, description
- [ ] Authentication method documented
- [ ] Request/response formats for key endpoints
- [ ] Error response format
- [ ] Pagination approach
- [ ] Rate limiting configuration

---

## After Scanning: What You Should Have

By the end of scanning, you should have a mental model that includes:

1. **Project Identity** — name, version, description, purpose, license
2. **Architecture Map** — how the pieces fit together, data flow, integration points
3. **Tech Stack Details** — frameworks, libraries, tools, and their versions
4. **Directory Blueprint** — what lives where and why
5. **Data Model** — tables, models, relationships, key business entities
6. **API Surface** — all endpoints, their purposes, and auth requirements
7. **Frontend Map** — component tree, state flow, routing, styling
8. **Backend Map** — controller patterns, service layer, background processing
9. **DevOps Overview** — CI/CD, deployment, monitoring, environments
10. **Team Conventions** — naming, structure, patterns, code style

This information feeds directly into wiki page generation. Each wiki page template draws from specific parts of this data — the Architecture-Overview page uses the architecture map, the Database-Schema page uses the data model, and so on.

**Key Principle:** It is better to over-scan than under-scan. Missing information results in incomplete or inaccurate wiki pages. If a scan produces no results, that is still valuable information (e.g., "no queue system detected" means skip the Queues page or note its absence).


