# SDLC Coverage Mapping

> Maps Software Development Lifecycle phases to wiki pages for comprehensive documentation coverage
> For use with the wiki-docs skill

## Overview

A well-documented project wiki should cover every phase of the software development lifecycle (SDLC). This ensures developers have documentation for any stage of work -- from initial setup to production deployment and ongoing maintenance.

This reference maps each SDLC phase to the wiki pages that document it, helps identify coverage gaps, and provides guidance on content depth appropriate for each phase.

---

## Table of Contents

1. [SDLC Phase Mapping](#sdlc-phase-mapping)
2. [Detailed Phase Breakdown](#detailed-phase-breakdown)
3. [Coverage Verification](#coverage-verification)
4. [Gap Analysis](#gap-analysis)
5. [Content Depth Guidelines](#content-depth-guidelines)
6. [Stack-Specific Coverage](#stack-specific-coverage)
7. [Coverage Matrix](#coverage-matrix)

---

## SDLC Phase Mapping

| SDLC Phase | Primary Wiki Pages | Secondary Wiki Pages | What to Document |
|------------|-------------------|---------------------|-----------------|
| **Planning & Design** | Architecture-Overview, Home | Contributing-Guide | System design decisions, tech stack choices, constraints, architectural decision records |
| **Environment Setup** | Getting-Started, Environment-Configuration | Troubleshooting-FAQ | Prerequisites, installation steps, configuration, local development setup, tool versions |
| **Development** | Contributing-Guide, stack-specific pages | Architecture-Overview | Code patterns, conventions, where to add features, coding standards |
| **Database** | Database-Schema | Models-Relationships (WordPress), Custom-Post-Types-Taxonomies (WordPress) | Schema design, migrations, relationships, indexes, seeding |
| **API Development** | API-Overview-Authentication, Endpoint-Reference, Request-Response-Formats | Error-Handling-Status-Codes, Rate-Limiting-Pagination | Endpoints, authentication, request/response formats, error handling |
| **Frontend Development** | Component-Architecture, State-Management, Routing-Navigation | Custom-Hooks, Styling-Theming, Form-Handling-Validation | Component patterns, state flow, routing, styling conventions |
| **Backend Development** | Service-Layer-Architecture, Controllers-Request-Lifecycle | Middleware-Guards, Jobs-Events-Listeners, Queues-Scheduling | Service patterns, request lifecycle, background processing |
| **CMS Development** | Plugin-Theme-Architecture, Hooks-Filters-Reference | Custom-Post-Types-Taxonomies, Admin-Pages-Settings, Gutenberg-Blocks | Extension points, hooks system, content types, admin UI |
| **Testing** | Testing-Guide | Contributing-Guide, stack-specific pages | Unit, integration, E2E strategies, how to write and run tests |
| **Code Review** | Contributing-Guide | Testing-Guide | PR process, review checklist, coding standards, merge requirements |
| **Deployment** | Deployment-Guide | Environment-Configuration, Testing-Guide | CI/CD pipeline, environments, release process, rollback procedures |
| **Operations** | Environment-Configuration | Caching-Strategy, Queues-Scheduling, Deployment-Guide | Runtime configuration, caching, queue workers, monitoring, logging |
| **Maintenance** | Troubleshooting-FAQ, Changelog | Contributing-Guide | Common issues, debugging procedures, version history, upgrade guides |
| **Security** | Middleware-Guards, API-Overview-Authentication | Deployment-Guide, Contributing-Guide | Auth patterns, input validation, OWASP considerations, security headers |

---

## Detailed Phase Breakdown

### Planning & Design

**Primary pages:** Architecture-Overview, Home

**What developers need at this phase:**
- Understanding of system architecture and component relationships
- Technology choices and rationale
- System constraints and non-functional requirements
- High-level data flow diagrams

**Content to include:**
- System architecture diagram (ASCII or linked image)
- Technology stack with versions
- Key architectural decisions and why they were made
- External system integrations
- Scaling considerations

**Example content structure (Architecture-Overview):**
```markdown
## System Architecture

{project_name} follows a {architecture_pattern} architecture.

### Components
- **{component_name}** — {responsibility}
- **{component_name}** — {responsibility}

### Technology Stack
| Layer | Technology | Version |
|-------|-----------|---------|
| {layer} | {technology} | {version} |

### Key Decisions
- **Why {technology}?** — {rationale}
```

---

### Environment Setup

**Primary pages:** Getting-Started, Environment-Configuration

**What developers need at this phase:**
- Exact steps to go from zero to running project
- All prerequisites with version requirements
- Configuration file explanations
- Common setup pitfalls and solutions

**Content to include:**
- System requirements (language versions, tools)
- Step-by-step installation instructions
- Environment variable documentation (names, purpose, example values)
- Verification steps (how to confirm setup works)
- IDE/editor recommendations

**Critical rule:** Environment variable documentation must show names and purposes but **never** include real values. Use `{placeholder}` format:

```markdown
## Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `APP_KEY` | Application encryption key | `base64:{generated_key}` |
| `DB_HOST` | Database server hostname | `{your_db_host}` |
| `API_SECRET` | Third-party API secret | `{your_api_secret}` |
```

---

### Development (Active Coding)

**Primary pages:** Contributing-Guide, all stack-specific pages

**What developers need at this phase:**
- How to add features to the correct location
- Code patterns and conventions to follow
- File organization and naming rules
- Available utilities, helpers, and base classes

**Content to include per stack:**

**WordPress:**
- Where to add controllers, services, models, migrations
- Request validation patterns
- Service layer usage
- WPDB conventions (scopes, accessors, relationships)

**React/NextJS:**
- Component creation patterns
- State management approach
- Routing conventions
- Styling methodology

**WordPress:**
- Hook registration patterns
- Custom post type definitions
- Admin page creation
- Block development workflow

---

### Database

**Primary pages:** Database-Schema

**What developers need at this phase:**
- Complete schema documentation
- Relationship diagrams
- Migration conventions
- Index strategy

**Content to include:**
- Table listing with column descriptions
- Relationship documentation (one-to-many, many-to-many, polymorphic)
- Migration naming and ordering conventions
- Seeding instructions for development data
- Performance indexes and their rationale

**For WordPress projects:**
- Custom tables (if any) with `dbDelta` usage
- Post meta keys and their purposes
- Options table usage
- Taxonomy relationships

---

### API Development

**Primary pages:** API-Overview-Authentication, Endpoint-Reference, Request-Response-Formats

**What developers need at this phase:**
- Complete endpoint inventory
- Authentication mechanism and token management
- Request/response format specifications
- Error handling conventions

**Content to include:**
- Base URL and versioning strategy
- Authentication methods (Bearer tokens, API keys, OAuth, cookies)
- Endpoint table with method, path, description, auth requirement
- Request body schemas with field types and validation rules
- Response format with example payloads
- Error response format with status codes
- Pagination format
- Rate limiting rules

**Per-endpoint documentation pattern:**
```markdown
### {HTTP_METHOD} {path}

**Description:** {what_this_endpoint_does}
**Authentication:** {auth_requirement}

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `{param}` | `{type}` | {yes/no} | {description} |

**Response:** `{status_code}`
```

---

### Testing

**Primary page:** Testing-Guide

**What developers need at this phase:**
- How to run the test suite
- How to write new tests following project conventions
- Test organization and naming
- Mocking and fixture strategies

**Content to include per stack:**

**WordPress:** PHPUnit setup, feature vs unit tests, database testing (RefreshDatabase, factories), mocking services, HTTP tests

**React/NextJS:** Jest/Vitest setup, React Testing Library patterns, component tests, hook tests, snapshot testing, E2E with Playwright/Cypress

**WordPress:** WP_UnitTestCase setup, integration test patterns, mocking WordPress functions, plugin activation tests

**General:**
- Test directory structure
- How to run specific test files or suites
- CI test configuration
- Coverage requirements (if any)
- How to write test fixtures and factories

---

### Deployment

**Primary page:** Deployment-Guide

**What developers need at this phase:**
- CI/CD pipeline documentation
- Environment-specific configurations
- Release process and versioning
- Rollback procedures

**Content to include:**
- CI/CD workflow description (GitHub Actions, GitLab CI, etc.)
- Environment tiers (development, staging, production)
- Deployment commands or trigger mechanisms
- Pre-deployment checklist
- Post-deployment verification steps
- Rollback procedure with specific commands
- Environment variable differences across tiers
- Database migration execution in production

---

### Maintenance

**Primary pages:** Troubleshooting-FAQ, Changelog

**What developers need at this phase:**
- Solutions to common problems
- Debugging procedures
- Version history and upgrade paths
- Known issues and workarounds

**Content to include:**

**Troubleshooting-FAQ:**
- Organized by symptom (what the developer observes)
- Each entry: symptom, likely cause, solution, prevention
- Common error messages with explanations
- Debug mode instructions
- Log file locations and formats

**Changelog:**
- Organized by version (newest first)
- Categorized entries (Added, Changed, Fixed, Removed, Security)
- Links to PRs or issues where applicable
- Migration notes for breaking changes

---

## Coverage Verification

After generating all wiki pages, verify SDLC coverage using this procedure:

### Step 1: Map Generated Pages to Phases

For each SDLC phase in the table above, confirm at least one primary wiki page was generated. Mark as covered or uncovered:

```
Planning & Design:     [x] Architecture-Overview generated
Environment Setup:     [x] Getting-Started generated
Development:           [x] Contributing-Guide generated
Database:              [x] Database-Schema generated
API Development:       [ ] No API pages (no endpoints detected)
Frontend Development:  [x] Component-Architecture generated
Backend Development:   [x] Service-Layer-Architecture generated
CMS Development:       [ ] No WordPress pages (not detected)
Testing:               [x] Testing-Guide generated
Code Review:           [x] Contributing-Guide covers this
Deployment:            [x] Deployment-Guide generated
Operations:            [x] Environment-Configuration covers this
Maintenance:           [x] Troubleshooting-FAQ generated
Security:              [x] Middleware-Guards generated
```

### Step 2: Evaluate Uncovered Phases

Uncovered phases are acceptable when:
- The stack doesn't apply (no WordPress pages for a pure WordPress project)
- No relevant code was detected (no API pages if no endpoints exist)

Uncovered phases need attention when:
- The stack was detected but pages were skipped
- A universal phase (Testing, Deployment, Maintenance) is missing

### Step 3: Verify Depth

Each covered phase should have content proportional to the project's actual code. A project with 50 API endpoints needs detailed API pages. A project with 2 endpoints needs a brief section.

---

## Gap Analysis

### When a Phase Has No Wiki Page

**Option 1: Add a section to an existing page**

If the gap is small, fold coverage into a related page:

```markdown
<!-- In Architecture-Overview.md -->
## Security Considerations

Authentication uses {auth_method}. All API endpoints require
{auth_requirement}. See [API Authentication](API-Overview-Authentication#authentication)
for implementation details.
```

**Option 2: Generate a dedicated page**

If the gap represents significant project functionality, create a new wiki page following the naming convention.

**Option 3: Document as "not applicable"**

If the phase genuinely doesn't apply, note it in Architecture-Overview:

```markdown
## What's Not Covered

- **CMS/WordPress:** This project is a standalone {framework} application,
  not a WordPress plugin/theme
- **Background Jobs:** The application processes all requests synchronously
```

### Common Gaps and Solutions

| Gap | Typical Cause | Solution |
|-----|--------------|----------|
| No Testing-Guide | No tests exist in project | Generate page documenting recommended test approach |
| No Deployment-Guide | No CI/CD configured | Generate page with recommended CI/CD setup for detected stack |
| No API pages | API exists but wasn't detected | Check for non-standard API patterns (GraphQL, RPC, WebSocket) |
| No Security coverage | Security is implicit | Add security section to Architecture-Overview and Contributing-Guide |
| No Operations coverage | Small/early-stage project | Add basic operations notes to Deployment-Guide |

---

## Content Depth Guidelines

### Depth Levels

| Depth Level | Description | Word Count | Code Examples |
|------------|-------------|-----------|---------------|
| **Deep** | Comprehensive with code examples, file paths, patterns | 1,000-2,000 | 5-10 examples |
| **Medium** | Decisions, rationale, high-level patterns | 500-1,000 | 2-5 examples |
| **Practical** | Commands, configs, step-by-step procedures | 500-1,500 | 3-8 examples |
| **Reference** | Lookup tables, symptom-cause-solution entries | 300-800 | 1-3 examples |

### Recommended Depth per Phase

| SDLC Phase | Recommended Depth | Rationale |
|------------|------------------|-----------|
| Planning & Design | Medium | Decisions and rationale, not implementation details |
| Environment Setup | Practical | Step-by-step commands that must be exact |
| Development | Deep | Developers spend most time here, need detailed patterns |
| Database | Deep | Schema details, relationship patterns, migration examples |
| API Development | Deep | Endpoint specifications must be precise and complete |
| Frontend Development | Deep | Component patterns, state flow, styling conventions |
| Backend Development | Deep | Service patterns, request lifecycle, business logic |
| CMS Development | Deep | Hook system, extension patterns, admin UI |
| Testing | Practical | How to run tests, how to write new ones |
| Code Review | Medium | Process and checklist, not deep technical detail |
| Deployment | Practical | Exact commands, configs, verification steps |
| Operations | Practical | Runtime commands, monitoring, scaling procedures |
| Maintenance | Reference | Symptom lookup, quick solutions |
| Security | Medium | Patterns and principles, with code examples for critical areas |

---

## Stack-Specific Coverage

### WordPress Project Coverage

| Phase | Pages | Notes |
|-------|-------|-------|
| Setup | Getting-Started, Environment-Configuration | `php wp` commands, `.env` setup, `composer install` |
| Development | Service-Layer-Architecture, Controllers-Request-Lifecycle, Models-Relationships | WPDB patterns, Clean architectures, service injection |
| Database | Database-Schema, Models-Relationships | Migrations, factories, seeders, relationships |
| Security | Middleware-Guards | Gates, policies, middleware, CSRF, validation |
| Background | Jobs-Events-Listeners, Queues-Scheduling | Queue configuration, event-driven patterns, task scheduling |
| Performance | Caching-Strategy | Cache drivers, tagged caching, cache invalidation |

### React/NextJS Project Coverage

| Phase | Pages | Notes |
|-------|-------|-------|
| Setup | Getting-Started, Environment-Configuration | `npm install`, `.env.local`, `next.config` |
| Development | Component-Architecture, Custom-Hooks | Component composition, hook patterns, code splitting |
| State | State-Management | Redux/Zustand/Context patterns, server state, hydration |
| Routing | Routing-Navigation | File-based routing (Next), React Router, layouts |
| UI | Styling-Theming | CSS Modules, Tailwind, styled-components, theme system |
| Forms | Form-Handling-Validation | Form libraries, validation schemas, error display |
| Errors | Error-Handling-Boundaries | Error boundaries, fallback UI, error reporting |

### WordPress Project Coverage

| Phase | Pages | Notes |
|-------|-------|-------|
| Setup | Getting-Started, Environment-Configuration | WordPress installation, plugin/theme activation |
| Architecture | Plugin-Theme-Architecture | File structure, loading order, dependency management |
| Extensibility | Hooks-Filters-Reference | `add_action`, `add_filter`, custom hooks provided |
| Content | Custom-Post-Types-Taxonomies | CPT registration, meta boxes, taxonomy setup |
| Admin | Admin-Pages-Settings | Settings API, admin menu pages, option storage |
| Editor | Gutenberg-Blocks | Block registration, `block.json`, editor components |
| CLI | WP-CLI-Commands | Custom commands, bulk operations, maintenance tasks |

### Multi-Stack Project Coverage

For projects with multiple stacks (e.g., WordPress API + React SPA):

1. Generate pages for ALL detected stacks
2. Architecture-Overview should document how stacks connect:
   ```markdown
   ## System Architecture

   {project_name} is a {architecture_description}:
   - **Backend:** {backend_stack} serves the API
   - **Frontend:** {frontend_stack} consumes the API
   - **Communication:** {communication_method}
   ```
3. API pages serve as the bridge documentation between stacks
4. Cross-link between stack sections to show integration points

---

## Coverage Matrix

Use this matrix to verify all phases are documented. Mark each cell with the page that covers it:

```
                    | Plan | Setup | Dev | DB | API | FE | BE | CMS | Test | Review | Deploy | Ops | Maint | Security |
Home                |  x   |       |     |    |     |    |    |     |      |        |        |     |       |          |
Getting-Started     |      |   x   |     |    |     |    |    |     |      |        |        |     |       |          |
Architecture        |  x   |       |  x  |    |     |    |    |     |      |        |        |     |       |          |
Database-Schema     |      |       |     | x  |     |    |    |     |      |        |        |     |       |          |
Env-Configuration   |      |   x   |     |    |     |    |    |     |      |        |        |  x  |       |          |
Testing-Guide       |      |       |     |    |     |    |    |     |  x   |        |        |     |       |          |
Deployment-Guide    |      |       |     |    |     |    |    |     |      |        |   x    |     |       |          |
Contributing-Guide  |      |       |  x  |    |     |    |    |     |      |   x    |        |     |       |          |
Troubleshoot-FAQ    |      |       |     |    |     |    |    |     |      |        |        |     |   x   |          |
Changelog           |      |       |     |    |     |    |    |     |      |        |        |     |   x   |          |
[WordPress pages]     |      |       |  x  | x  |     |    | x  |     |      |        |        |  x  |       |    x     |
[React pages]       |      |       |  x  |    |     | x  |    |     |      |        |        |     |       |          |
[WordPress pages]   |      |       |  x  |    |     |    |    |  x  |      |        |        |     |       |          |
[API pages]         |      |       |     |    |  x  |    |    |     |      |        |        |     |       |    x     |
```

**Every column must have at least one `x`.** If a column is empty, that SDLC phase has a documentation gap that needs to be addressed.

---

## Related Documentation

- [SKILL.md](../SKILL.md) — Main workflow (Phase 3 uses this mapping)
- [cross-linking-guide.md](cross-linking-guide.md) — How to link between the pages identified here
- [edge-cases.md](edge-cases.md) — Handling gaps for small or unusual projects
- [wiki-page-templates.md](wiki-page-templates.md) — Templates for each page type


