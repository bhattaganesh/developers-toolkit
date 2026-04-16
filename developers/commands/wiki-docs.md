---
description: Generate project documentation — GitHub Wiki pages (external-facing) or internal developer docs inside the repo (onboarding, AI agent guide, architecture). Detects tech stack and covers full SDLC.
---

# Wiki & Internal Docs

Generate comprehensive project documentation in two modes:
- **GitHub Wiki** — External-facing wiki pages pushed to `<repo>.wiki.git`
- **Internal Docs** — 13 developer-facing files inside the repo (`internal-docs/`), excluded from production releases

## Instructions

1. **Detect project context** — Read the project root to identify tech stack:
   - `composer.json` with `WordPress/framework` → WordPress
   - `package.json` with `react` or `next` → React / NextJS
   - PHP files with `Plugin Name:` header or `add_action`/`add_filter` → WordPress
   - Multiple indicators → multi-stack project

2. **Gather requirements** — Ask the user:
   - GitHub repository URL (for wiki remote)
   - Project purpose / one-line description (or derive from README)
   - Wiki scope: full generation (first time) or update existing
   - Any sections to skip or prioritize

3. **Set up workspace** — Create an isolated worktree:
   - Fetch latest: `git fetch origin`
   - Create worktree: `git worktree add ../${REPO}-wiki-docs -b chore/wiki-docs`
   - Test wiki access: `git ls-remote "${REMOTE_URL%.git}.wiki.git"`
   - Clone wiki repo or initialize local `wiki-output/` fallback

4. **Scan codebase** — Run parallel discovery groups:
   - Core files (manifests, entry points, README)
   - API endpoints (REST routes, AJAX, GraphQL)
   - Database (migrations, models, schema)
   - Frontend structure (components, hooks, state, routing)
   - Backend structure (controllers, services, middleware, jobs)
   - Infrastructure (CI/CD, Docker, test config)

5. **Build page plan** — Dynamically assemble wiki page list based on detected stacks:
   - 12 common pages (always included): Home, Getting-Started, Architecture-Overview, Database-Schema, Environment-Configuration, Testing-Guide, Deployment-Guide, Contributing-Guide, Troubleshooting-FAQ, Changelog, _Sidebar, _Footer
   - Up to 7 WordPress pages (if detected)
   - Up to 6 WordPress pages (if detected)
   - Up to 7 React/NextJS pages (if detected)
   - Up to 6 API pages (if endpoints found)
   - **Present plan and wait for user approval before generating**

6. **Generate wiki pages** — Write pages in dependency order (5 tiers):
   - Tier 1: Foundational (Architecture, Database, Environment)
   - Tier 2: Backend (WordPress/WordPress specific)
   - Tier 3: Frontend (React/NextJS specific)
   - Tier 4: Cross-cutting (API, Testing, Deployment, Contributing, Troubleshooting, Changelog)
   - Tier 5: Navigation (Home, _Sidebar, _Footer, Getting-Started — reference all other pages)

7. **Self-review** — Validate all generated pages:
   - Content derived from actual code (not guessed)
   - No secrets, tokens, or API keys
   - All cross-links point to existing pages
   - Consistent heading hierarchy and formatting

8. **Publish** — Commit and push wiki pages:
   - **Primary:** Push to `<repo>.wiki.git` (uses `master` branch)
   - **Fallback:** If wiki not accessible, commit to `docs/wiki/` in a branch and create PR with publishing instructions

9. **Present results** — Show the user:
   - Wiki URL or PR URL
   - List of pages generated with count
   - Worktree location for review
   - Cleanup command when satisfied

## Rules

- Derive ALL content from actual code — never guess or fabricate
- Always present page plan before generating — user must approve
- Work in worktree — never modify the main working directory
- Verify no secrets before committing
- Use `[Text](Page-Name)` format for cross-links (no `.md` extension)
- All wiki files must be flat (no subdirectories — GitHub Wiki requirement)

