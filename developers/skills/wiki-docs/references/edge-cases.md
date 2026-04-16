# Edge Cases and Non-Standard Scenarios

> Handling unusual situations when generating GitHub Wiki documentation
> For use with the wiki-docs skill

## Overview

Not every project fits the standard mold. This guide covers non-standard structures, access limitations, hybrid stacks, and other situations that require adapted approaches during wiki documentation generation.

**Guiding principle:** Adapt the documentation to the project, not the project to the documentation.

---

## Table of Contents

1. [Monorepo Structures](#monorepo-structures)
2. [No Wiki Access](#no-wiki-access)
3. [Pre-existing Wiki Content](#pre-existing-wiki-content)
4. [Hybrid / Multi-Stack Projects](#hybrid--multi-stack-projects)
5. [Small Projects](#small-projects)
6. [No Tests](#no-tests)
7. [No CI/CD](#no-cicd)
8. [Private / Proprietary Projects](#private--proprietary-projects)
9. [Projects with Existing Documentation](#projects-with-existing-documentation)
10. [GitHub Enterprise / Self-Hosted](#github-enterprise--self-hosted)
11. [Unconventional Project Structures](#unconventional-project-structures)
12. [API-Only Projects (No Frontend)](#api-only-projects-no-frontend)
13. [Frontend-Only Projects (No Backend)](#frontend-only-projects-no-backend)
14. [When to Scale Down](#when-to-scale-down)
15. [When to Decline](#when-to-decline)

---

## Monorepo Structures

**Scenario:** Single repository contains multiple packages, services, or applications.

**Challenge:** Wiki is per-repository. One wiki must cover the entire monorepo.

### Recommended Approach: Prefixed Pages

Use page name prefixes to organize wiki pages by package:

```
Home.md                          # Monorepo overview with links to all packages
Getting-Started.md               # Covers setup for all packages
Architecture-Overview.md         # How packages relate to each other

Backend-Architecture.md          # WordPress/backend-specific architecture
Backend-Service-Layer.md         # Backend service patterns
Backend-Controllers.md           # Backend controllers

Frontend-Architecture.md         # React/frontend-specific architecture
Frontend-Component-Architecture.md  # Frontend component patterns
Frontend-State-Management.md     # Frontend state management

API-Overview-Authentication.md   # API documentation (shared)
Database-Schema.md               # Database (shared)
```

### Shared vs Package-Specific Pages

**Shared pages (cover all packages):**
- Home.md
- Getting-Started.md
- Architecture-Overview.md
- Environment-Configuration.md
- Contributing-Guide.md
- Testing-Guide.md
- Deployment-Guide.md
- Troubleshooting-FAQ.md
- Changelog.md
- _Sidebar.md, _Footer.md

**Package-specific pages:**
- Prefixed with package/area name
- Reference shared pages for common setup
- Cross-link to sibling package pages for integration points

### _Sidebar Organization for Monorepos

```markdown
**[Home](Home)**

**Shared**
- [Getting Started](Getting-Started)
- [Architecture](Architecture-Overview)
- [Environment](Environment-Configuration)
- [Database](Database-Schema)
- [API](API-Overview-Authentication)

**Backend**
- [Architecture](Backend-Architecture)
- [Services](Backend-Service-Layer)
- [Controllers](Backend-Controllers)

**Frontend**
- [Architecture](Frontend-Architecture)
- [Components](Frontend-Component-Architecture)
- [State](Frontend-State-Management)

**Operations**
- [Testing](Testing-Guide)
- [Deployment](Deployment-Guide)
- [Contributing](Contributing-Guide)
```

---

## No Wiki Access

**Scenario:** Wiki cannot be cloned or pushed to.

**Common causes:**
- Wiki not enabled in repository settings (Settings > Features > Wikis)
- User doesn't have push access to wiki
- Private repo with restricted wiki permissions
- Organization Capability disables wikis
- First push required via web UI to initialize wiki

### Detection

```bash
# Test wiki accessibility
WIKI_URL="${REMOTE_URL%.git}.wiki.git"
git ls-remote "$WIKI_URL" 2>/dev/null
```

If this fails, wiki is not accessible.

### Solution: Local Generation with PR

Generate pages locally in the worktree and create a PR:

```bash
mkdir -p docs/wiki
# Generate all .md files into docs/wiki/
# Commit to branch
git add docs/wiki/
git commit -m "docs: add wiki documentation (manual publish required)"
git push -u origin chore/wiki-docs
```

Create PR with publish instructions:

```markdown
## To Publish to GitHub Wiki

1. Enable wiki: Repository Settings > Features > check "Wikis"
2. Create initial page via web UI (required for first-time setup)
3. Clone wiki: `git clone {repo_url}.wiki.git`
4. Copy files: `cp docs/wiki/*.md {wiki_dir}/`
5. Push: `cd {wiki_dir} && git add -A && git commit -m "docs: publish wiki" && git push`
6. Remove `docs/wiki/` from main repo if desired
```

### Alternative: Keep in Repository

If wiki will never be enabled, keep pages in `docs/wiki/` permanently. They serve as documentation even without the wiki rendering. Link from the main README:

```markdown
## Documentation

See the [project wiki](docs/wiki/Home.md) for comprehensive documentation.
```

---

## Pre-existing Wiki Content

**Scenario:** Wiki already has pages from previous documentation efforts.

**Critical rule:** NEVER overwrite existing pages without showing a diff to the user.

### Step 1: Inventory Existing Pages

```bash
cd wiki-output
ls *.md
git log --oneline -10  # See recent wiki edits
```

### Step 2: Present Options to User

**Option A: Merge (update sections)**
- Preserve existing page structure
- Update sections that correspond to detected code changes
- Add new sections where content is missing
- Mark updated sections with "Last updated: {date}"

**Option B: Replace (backup first)**
- Create backup branch: `git checkout -b backup-{date}`
- Generate fresh pages on the default branch
- User can compare branches to recover any lost content

**Option C: Append (add new pages only)**
- Keep all existing pages untouched
- Only generate pages that don't yet exist
- Update _Sidebar.md to include new pages

### Step 3: Always Pull Before Modifying

```bash
cd wiki-output
git pull origin master  # Wiki uses master, not main
```

Wiki pages can be edited via the web UI by anyone with access. Always pull latest before making changes to avoid conflicts.

### Conflict Resolution

If merge conflicts occur:
1. Show conflicts to user
2. Let user decide which version to keep
3. Never auto-resolve wiki conflicts -- existing content may have been carefully crafted

---

## Hybrid / Multi-Stack Projects

**Scenario:** Project uses multiple technology stacks that interact with each other.

### Common Combinations

| Combination | Architecture Pattern | Key Integration Points |
|------------|---------------------|----------------------|
| WordPress API + React SPA | API-driven separation | REST/GraphQL endpoints, authentication tokens, CORS |
| WordPress API + NextJS frontend | SSR with API backend | API routes, server-side data fetching, shared auth |
| WordPress + React blocks | Embedded React in WP | `@wordpress/scripts`, block registration, REST API |
| WordPress + NextJS headless | Headless CMS | WP REST API or WPGraphQL, ISR/SSR, preview mode |
| WordPress + WordPress multisite | Shared database/auth | Shared users table, SSO, cross-domain cookies |

### Documentation Strategy

1. **Generate pages for ALL detected stacks** -- do not skip a stack because another was detected
2. **Architecture-Overview must show integration:**
   ```markdown
   ## System Architecture

   {project_name} is a {architecture_description}:

   ### Backend ({backend_stack})
   - Serves API endpoints at `{api_base_url}`
   - Handles authentication via {auth_method}
   - Manages database and business logic

   ### Frontend ({frontend_stack})
   - Consumes backend API
   - Handles client-side routing and state
   - Server-side rendered via {ssr_method} (if applicable)

   ### Integration Points
   - **Authentication:** {auth_flow_description}
   - **Data Flow:** {data_flow_description}
   - **Shared Configuration:** {shared_config_description}
   ```

3. **API pages bridge the stacks** -- document from both producer and consumer perspectives
4. **Cross-link between stack sections** to show how they connect

### Page Naming for Multi-Stack

When pages would conflict, prefix with the stack:

```
Component-Architecture.md         # React components (if only one frontend)
WordPress-Service-Layer.md          # Explicit stack prefix when needed
WordPress-Hooks-Filters.md       # Explicit stack prefix when needed
```

If only one stack per layer exists (one backend, one frontend), prefixing is optional.

---

## Small Projects

**Scenario:** Project has fewer than 10 source files or is a simple utility.

**Challenge:** Generating 38 wiki pages for a tiny project is excessive and creates maintenance burden.

### Minimum Page Set (6 pages)

For small projects, generate only:

1. **Home.md** -- Project overview, quick start, links to other pages
2. **Getting-Started.md** -- Installation and usage
3. **Architecture-Overview.md** -- How the code is organized (even if simple)
4. **Contributing-Guide.md** -- How to contribute changes
5. **_Sidebar.md** -- Navigation
6. **_Footer.md** -- Footer links

### When to Use Minimum Set

Apply the minimum page set when:
- Total source files (excluding config, tests, docs) < 10
- Single-purpose utility or library
- No database or API
- Single technology (not multi-stack)

### Scaling Up

Add pages incrementally as the project grows:

| Project Complexity | Recommended Pages |
|-------------------|------------------|
| Utility (< 10 files) | 6 core pages |
| Small app (10-30 files) | 6 core + Testing-Guide + Environment-Configuration |
| Medium app (30-100 files) | 12 common pages + detected stack pages |
| Large app (100+ files) | Full page plan (12-38 pages) |

---

## No Tests

**Scenario:** Project has no test files, no test configuration, no test dependencies.

### Still Generate Testing-Guide

The Testing-Guide page should still be generated, but with adjusted content:

```markdown
# Testing Guide

## Current State

This project does not currently have automated tests.

## Recommended Test Setup

Based on the detected stack ({detected_stack}), we recommend:

### Test Framework
- **Framework:** {recommended_framework}
- **Install:** `{install_command}`
- **Config file:** `{config_file}`

### Directory Structure
{recommended_test_directory_structure}

### What to Test First
1. {highest_priority_test_target} — {rationale}
2. {second_priority_test_target} — {rationale}
3. {third_priority_test_target} — {rationale}

### Example Test
{example_test_code_for_detected_stack}
```

### Stack-Specific Recommendations

**WordPress (no tests):**
- Framework: PHPUnit (ships with WordPress)
- First tests: Feature tests for critical API endpoints
- Config: `phpunit.xml` already present in WordPress scaffold

**React/NextJS (no tests):**
- Framework: Vitest or Jest + React Testing Library
- First tests: Component render tests for key UI components
- Config: Add to `package.json` or `vitest.config.ts`

**WordPress (no tests):**
- Framework: PHPUnit with WP test suite
- First tests: Integration tests for core plugin functionality
- Config: `phpunit.xml.dist` with WP test bootstrap

---

## No CI/CD

**Scenario:** No `.github/workflows/`, no CI configuration, no deployment automation.

### Still Generate Deployment-Guide

```markdown
# Deployment Guide

## Current State

This project does not currently have automated CI/CD configured.

## Recommended CI/CD Setup

### GitHub Actions Starter Workflow

Create `.github/workflows/ci.yml`:

{starter_workflow_for_detected_stack}

### Deployment Environments

| Environment | Purpose | URL |
|-------------|---------|-----|
| Development | Local development | `{local_url}` |
| Staging | Pre-production testing | `{staging_url_placeholder}` |
| Production | Live application | `{production_url_placeholder}` |

### Manual Deployment (Current Process)

Until CI/CD is configured, deploy manually:

1. {manual_deploy_step_1}
2. {manual_deploy_step_2}
3. {manual_deploy_step_3}
```

Provide stack-appropriate starter workflow examples but use `{placeholder}` values for any project-specific configuration.

---

## Private / Proprietary Projects

**Scenario:** Project is private, proprietary, or under NDA.

### Security Warnings

**Critical:** GitHub Wiki visibility is controlled separately from repository visibility.

- Public repos: Wiki is always public
- Private repos: Wiki is private by default, but verify settings
- **Warn the user** before pushing any content to the wiki

```
WARNING: Please verify your wiki visibility settings before publishing.
Repository Settings > Features > Wikis

If your repository is private, the wiki should also be private.
If you're unsure, generate pages locally (docs/wiki/) instead of
pushing to the wiki repository.
```

### Content Safety Rules

Before committing any wiki page, verify:

- [ ] No API keys, tokens, or secrets
- [ ] No internal IP addresses or hostnames
- [ ] No client names (if under NDA)
- [ ] No proprietary algorithm descriptions that shouldn't be documented
- [ ] No credentials or passwords
- [ ] Environment variables show names only, values use `{placeholder}` format
- [ ] No references to internal tools or systems that shouldn't be public

### Anonymization Patterns

```markdown
<!-- WRONG — exposes proprietary info -->
Integrates with AcmeCorp's BigData platform via their internal API at
analytics.acme-internal.net:8443

<!-- CORRECT — anonymized -->
Integrates with the analytics platform via a configured API endpoint.
Set `ANALYTICS_API_URL` in your environment configuration.
```

---

## Projects with Existing Documentation

**Scenario:** Project already has documentation in `docs/`, `documentation/`, `README.md`, or other locations.

### Step 1: Discover Existing Docs

```bash
# Check common documentation locations
ls -la docs/ documentation/ doc/ wiki/ 2>/dev/null
ls -la *.md
ls -la CONTRIBUTING* CHANGELOG* LICENSE*
```

### Step 2: Reference, Don't Duplicate

If detailed documentation already exists, wiki pages should reference it rather than duplicate it:

```markdown
## API Documentation

For detailed API endpoint documentation, see the
[API docs in the repository]({repo_url}/blob/{branch}/docs/api.md).

This wiki page provides a high-level overview of the API architecture
and authentication patterns.
```

### Step 3: Fill Gaps

Use existing docs as a content source, then generate wiki pages only for topics not yet covered. The wiki adds value by:
- Providing interconnected navigation (sidebar, cross-links)
- Covering SDLC phases not in existing docs
- Offering a single entry point (Home.md) to all documentation
- Making docs discoverable via the GitHub Wiki tab

### Integration Patterns

| Existing Doc Type | Wiki Integration |
|------------------|-----------------|
| Detailed API docs (`docs/api/`) | Wiki API-Overview links to repo docs for endpoint details |
| README with setup instructions | Wiki Getting-Started expands on README, links back |
| CONTRIBUTING.md in repo root | Wiki Contributing-Guide references repo file, adds context |
| CHANGELOG.md in repo root | Wiki Changelog can embed or link to repo file |
| Architecture decision records (`docs/adr/`) | Wiki Architecture-Overview references ADRs |
| Swagger/OpenAPI spec | Wiki API pages reference spec, provide narrative context |

---

## GitHub Enterprise / Self-Hosted

**Scenario:** Project is hosted on GitHub Enterprise Server (GHES), not github.com.

### Differences from GitHub.com

| Feature | GitHub.com | GitHub Enterprise |
|---------|-----------|------------------|
| Wiki URL | `github.com/{org}/{repo}/wiki` | `{ghes_host}/{org}/{repo}/wiki` |
| Wiki clone URL | `github.com/{org}/{repo}.wiki.git` | `{ghes_host}/{org}/{repo}.wiki.git` |
| API base URL | `api.github.com` | `{ghes_host}/api/v3` |
| `gh` CLI support | Full | Requires `GH_HOST` env var |
| Wiki features | Full | May vary by GHES version |

### Handling

1. **Do not hardcode `github.com`** in any wiki content or link
2. **Derive URLs from git remote:** `git remote get-url origin`
3. **Ask user for wiki URL** if auto-detection fails:
   ```
   Could not determine wiki URL automatically.
   Please provide your wiki clone URL:
   (e.g., https://{your_ghes_host}/{org}/{repo}.wiki.git)
   ```
4. **GitHub CLI configuration** for GHES:
   ```bash
   gh auth login --hostname {ghes_host}
   ```

---

## Unconventional Project Structures

**Scenario:** Project doesn't follow standard framework conventions.

### Common Non-Standard Patterns

**No standard directories:**
```
project/
├── backend/          # Instead of app/ or src/
├── web/              # Instead of resources/ or public/
├── scripts/          # Build and utility scripts
└── config.yaml       # Instead of .env
```

**Custom framework or no framework:**
- No `wp`, no `package.json`, no `wp-content`
- Custom routing, custom ORM, custom templating

### Adaptation Strategy

1. **Ask the user** about project structure early in Phase 0:
   ```
   This project uses a non-standard structure. Please clarify:
   - Where is the main application code?
   - Where are configuration files?
   - What is the entry point?
   ```

2. **Document the structure prominently** in Architecture-Overview:
   ```markdown
   ## Project Structure

   This project uses a custom directory layout:

   | Directory | Purpose | Framework Equivalent |
   |-----------|---------|---------------------|
   | `{custom_dir}` | {purpose} | {standard_equivalent} |
   ```

3. **Adjust page names** if framework-specific names don't apply:
   - `Service-Layer-Architecture` might become `Business-Logic-Layer` for non-WordPress projects
   - `Hooks-Filters-Reference` only applies to WordPress
   - Use generic names when stack-specific names don't fit

---

## API-Only Projects (No Frontend)

**Scenario:** Project is a pure API with no frontend code.

### Skip Frontend Pages

Do not generate:
- Component-Architecture
- State-Management
- Routing-Navigation
- Styling-Theming
- Custom-Hooks
- Form-Handling-Validation
- Error-Handling-Boundaries

### Expand API Pages

With no frontend, give extra depth to API documentation:
- Detailed endpoint reference with all parameters
- Multiple request/response examples per endpoint
- Authentication flow diagrams
- Rate limiting details
- Webhook documentation (if applicable)
- SDK/client library documentation (if applicable)

---

## Frontend-Only Projects (No Backend)

**Scenario:** Static site, SPA consuming external APIs, or design system.

### Skip Backend Pages

Do not generate:
- Service-Layer-Architecture
- Controllers-Request-Lifecycle
- Models-Relationships
- Middleware-Guards
- Jobs-Events-Listeners
- Queues-Scheduling
- Caching-Strategy
- Database-Schema (unless using client-side database like IndexedDB)

### Expand Frontend Pages

- Component library/design system documentation
- Build process and optimization
- Environment configuration for API endpoints
- Deployment (static hosting, CDN configuration)

### Document External API Dependencies

```markdown
## External APIs

This application consumes the following external APIs:

| API | Base URL | Auth Method | Used For |
|-----|----------|------------|---------|
| {api_name} | `{api_base_url_env_var}` | {auth_method} | {purpose} |
```

---

## When to Scale Down

**Decision framework for reducing page count:**

```
Total source files < 5?
  → Minimum set (6 pages)

Single file/function utility?
  → README-only (decline wiki generation, suggest comprehensive README)

No database + No API + No frontend?
  → Minimum set + focus on architecture and usage

Only one stack detected?
  → Common pages + that stack's pages only

Stack detected but < 3 files in that stack?
  → Skip stack-specific pages, add a section in Architecture-Overview instead
```

### Scaling Thresholds

| Metric | Below Threshold | Action |
|--------|----------------|--------|
| Source files | < 5 | Minimum 6 pages |
| Source files | < 10 | 6-8 pages |
| Endpoints | < 3 | Fold API docs into Architecture-Overview |
| Components | < 5 | Fold frontend docs into Architecture-Overview |
| Models/tables | < 3 | Fold database docs into Architecture-Overview |
| Test files | 0 | Generate Testing-Guide as recommendation only |
| CI/CD config | none | Generate Deployment-Guide as recommendation only |

---

## When to Decline

**Scenarios where wiki generation is inappropriate:**

### 1. Project is a Prototype/Throwaway

```
This appears to be a prototype or experimental project.
Wiki documentation may be premature at this stage.
Recommendation: Create a comprehensive README.md instead.
Revisit wiki generation when the project stabilizes.
```

### 2. Project is Too Small

```
This project has {n} source files, which may not warrant
a full wiki. Consider a detailed README.md with:
- Overview and purpose
- Installation instructions
- Usage examples
- Contributing guidelines
```

### 3. Legal/Compliance Restrictions

```
Some contracts or compliance requirements may prohibit
documenting code. Please verify with your legal team
before generating wiki documentation.
```

### 4. Existing Documentation is Comprehensive

```
This project already has comprehensive documentation in {location}.
Generating wiki pages would create maintenance burden with
duplicate content. Consider:
- Migrating existing docs to wiki format (restructure, don't regenerate)
- Using the wiki to provide a navigation layer over existing docs
```

---

## Best Practices for All Edge Cases

1. **Ask, don't assume** -- when structure is non-standard, ask the user to clarify
2. **Document deviations** -- clearly note non-standard practices in wiki pages
3. **Adapt, don't force** -- fit documentation to the project as it exists
4. **Warn about risks** -- especially wiki visibility for private projects
5. **Preserve existing content** -- never overwrite without user approval
6. **Scale appropriately** -- match page count to project complexity
7. **Use `{placeholder}` values** -- never hardcode project-specific data in templates or examples

---

## Related Documentation

- [SKILL.md](../SKILL.md) -- Main workflow (Phase 0 handles edge case detection)
- [sdlc-coverage.md](sdlc-coverage.md) -- Full SDLC phase mapping (helps identify gaps)
- [cross-linking-guide.md](cross-linking-guide.md) -- Linking adjustments for non-standard page sets
- [github-wiki-workflow.md](github-wiki-workflow.md) -- Wiki access and push workflow


