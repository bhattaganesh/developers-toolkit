---
name: wiki-docs
description: >
  Generates comprehensive documentation for projects — either GitHub Wiki pages (external-facing)
  or Internal Docs files (developer onboarding, AI agent understanding, kept inside the repo).
  Triggers on "generate wiki docs", "create wiki documentation", "build github wiki", "wiki pages",
  "create project wiki", "document in wiki", "create internal docs", "generate dev docs",
  "document the codebase", "onboarding documentation", or "architecture docs".
  Produces dynamic pages covering full SDLC — architecture, APIs, testing, deployment —
  tailored to detected tech stack (WordPress, React, NextJS, WordPress).
version: 2.0.0
tools: Read, Glob, Grep, Write, Bash
context: fork
---

# Documentation Generation (Wiki & Internal Docs)

Generates project documentation in two modes:
- **GitHub Wiki** — External-facing wiki pages pushed to `<repo>.wiki.git`
- **Internal Docs** — 13 developer-facing files inside the repo (`internal-docs/`), excluded from production releases

Both modes derive all content from actual code, work in a Git worktree, and follow a plan-then-generate workflow.

---

## Mode Selection

At the start, determine which mode to use:

**GitHub Wiki mode** — User wants to publish documentation to the GitHub Wiki tab
- Trigger phrases: "wiki docs", "github wiki", "create project wiki", "document in wiki"

**Internal Docs mode** — User wants internal developer documentation inside the repo
- Trigger phrases: "internal docs", "dev docs", "document the codebase", "onboarding docs", "architecture docs"

**When ambiguous:** Ask — "Should I generate GitHub Wiki pages or internal developer docs inside the repo?"

Proceed with all phases below. Mode-specific steps are marked **[Wiki]** or **[Internal Docs]**.

---

## Phase 0: Plan & Requirements

**Goal:** Understand project scope and create implementation plan

**Always ask:**
- What needs documenting? (entire codebase, recent changes, specific areas)
- What is the project/plugin purpose? (or derive from README)
- Is this a first-time generation or update?

**[Wiki only]:**
- GitHub repository URL (for wiki remote)
- GitHub CLI (`gh`) available?

**[Internal Docs only]:**
- Single plugin or monorepo? Pro/Free split?
- Build/release process? (`npm run build`, `composer install`, `.distignore` exists?)
- Target branch (default: `dev`, fallback: `main`)

**Project structure:**
- Single project or monorepo?
- Special folders or naming conventions?

**STOP if:** Cannot answer core questions about project purpose and structure.

**Plan checklist:**
- [ ] Mode confirmed (GitHub Wiki or Internal Docs)
- [ ] Scope defined (full or incremental)
- [ ] Project structure understood
- [ ] Git branch identified

**Wait for approval before proceeding.**

---

## Phase 1: Pre-Flight & Workspace Setup

**Goal:** Validate environment and isolate work

**MANDATORY: NEVER skip this phase.** Working directly in a tmp directory, a bare clone, or the main working directory is not permitted. All work must happen inside a dedicated git worktree so changes can be reviewed and reverted safely.

**Critical checks:**
- [ ] Git repository exists
- [ ] Target branch available
- [ ] User permission for worktree

**Warning checks:**
- [ ] Working directory clean
- [ ] Remote configured
- [ ] GitHub CLI available (`gh`)

**STOP if:** Critical checks fail

### Step 1 — Fetch Latest Remote State (MUST NOT skip)

```bash
# Always run git fetch before creating a branch — prevents branch naming conflicts
# and ensures the worktree is based on up-to-date remote state
git fetch origin
```

### Step 2 — Worktree Setup — MANDATORY (both modes)

```bash
REPO=$(basename $(git rev-parse --show-toplevel))
BRANCH="chore/wiki-docs"   # or "chore/internal-docs-update" for Internal Docs mode
git worktree add ../${REPO}-docs-work -b $BRANCH

# Verify worktree was created — STOP if not listed
git worktree list
```

**STOP if the worktree does not appear in `git worktree list`.** Resolve the error before proceeding — do NOT fall back to working in the main directory.

**All subsequent file creation happens inside this worktree (`../${REPO}-docs-work`).**

### [Wiki] Wiki Repository Setup

```bash
REMOTE_URL=$(git remote get-url origin)
WIKI_URL="${REMOTE_URL%.git}.wiki.git"

# Test wiki accessibility
git ls-remote "$WIKI_URL" 2>/dev/null
```

**If wiki accessible:**
```bash
git clone "$WIKI_URL" wiki-output
cd wiki-output
```

**Fallback — If wiki not accessible:**
```bash
mkdir -p wiki-output && cd wiki-output
git init && echo "# Wiki" > Home.md
git add Home.md && git commit -m "init: initialize wiki"
```

Inform user: pages will be generated locally in `wiki-output/` and can be pushed manually.

**All wiki file creation happens inside `wiki-output/`.**

See `references/github-wiki-workflow.md` for details.

---

## Phase 2: Tech Stack Detection & Codebase Discovery

**Goal:** Understand the codebase structure and technology stack

**ASSUMPTION:** Derive all content from actual code (never guess).

**MANDATORY PARALLEL EXECUTION:** All detection groups and all discovery groups MUST be issued as a single parallel tool-call batch each. Do NOT read files one by one or ad-hoc between groups. Structured parallel scanning ensures complete, consistent coverage and avoids missing architectural signals.

### Detection Groups — Run All Groups in One Parallel Batch

**Group 1 — WordPress indicators:**
- Glob for `wp` in root
- Read `composer.json` for `WordPress/framework` dependency
- Glob for `routes/*.php`, `app/Http/Controllers/`
- Grep for `Illuminate\\` namespace usage

**Group 2 — React/NextJS indicators:**
- Read `package.json` for `react`, `next` dependencies
- Glob for `*.jsx`, `*.tsx` files
- Glob for `pages/`, `app/`, `components/` directories
- Check for `next.config.js` or `next.config.mjs`

**Group 3 — WordPress indicators:**
- Grep for `Plugin Name:` in PHP files (plugin header)
- Grep for `add_action|add_filter` usage
- Glob for `functions.php`, `style.css` with `Theme Name:`
- Grep for `wp_enqueue_script|wp_enqueue_style`

**Group 4 — General indicators:**
- Read `README.md` for project description
- Glob for `Dockerfile`, `docker-compose.yml`
- Read `.env.example` or `.env.sample`
- Glob for `.github/workflows/*.yml`

See `references/tech-stack-detection.md` for scoring logic.

### Discovery Groups — Run All Groups in One Parallel Batch (after detection)

**Group 1 — Core files:** Main entry point(s), `composer.json`, `package.json`, `README.md`, configuration files

**Group 2 — API endpoints:**
- WordPress: Grep `Route::` in `routes/*.php`
- WordPress: Grep `register_rest_route`, `wp_ajax_`; Grep `add_filter|add_action` (hooks)
- NextJS: Glob `pages/api/**/*.ts`, `app/api/**/route.ts`

**Group 3 — Database:**
- WordPress: Glob `database/migrations/*.php`, read models in `app/Models/`
- WordPress: Grep `$wpdb`, `dbDelta`, `CREATE TABLE`
- General: Read schema files, Grep for ORM usage

**Group 4 — Frontend structure:**
- Glob `components/**/*`, `pages/**/*`
- Grep for state management (Redux, Zustand, Context)
- Glob for style files (CSS, SCSS, Tailwind config)

**Group 5 — Backend structure:**
- WordPress: Glob controllers, services, middleware, jobs, events
- WordPress: Glob `inc/`, `includes/`, `admin/`, `public/`

**Group 6 — Security & patterns (WordPress):**
- Grep `sanitize_text_field|sanitize_email` (sanitization)
- Grep `esc_html|esc_attr|esc_url` (escaping)
- Grep `wp_verify_nonce` (security)
- Grep `current_user_can` (permissions)

**Group 7 — Infrastructure:**
- Glob `.github/workflows/*.yml`
- Read `Dockerfile`, `docker-compose.yml`
- Read `.distignore`, `.gitattributes`
- Glob for test directories and files

**STOP if:** Cannot access key files or cannot determine tech stack.

See `references/scanning-strategy.md` for detailed strategies.

---

## Phase 3: Content Plan & Quality Gate 1

**Goal:** Build page/file list and present to user for approval

### [Wiki] Build Wiki Page List

Based on detected stacks, assemble the wiki page plan:

**Always included (12 common pages):**
1. Home.md
2. Getting-Started.md
3. Architecture-Overview.md
4. Database-Schema.md
5. Environment-Configuration.md
6. Testing-Guide.md
7. Deployment-Guide.md
8. Contributing-Guide.md
9. Troubleshooting-FAQ.md
10. Changelog.md
11. _Sidebar.md
12. _Footer.md

**If WordPress detected (up to 7 pages):**
- Service-Layer-Architecture.md, Controllers-Request-Lifecycle.md, Models-Relationships.md, Middleware-Guards.md, Jobs-Events-Listeners.md, Queues-Scheduling.md, Caching-Strategy.md

**If WordPress detected (up to 6 pages):**
- Plugin-Theme-Architecture.md, Hooks-Filters-Reference.md, Custom-Post-Types-Taxonomies.md, Admin-Pages-Settings.md, Gutenberg-Blocks.md, WP-CLI-Commands.md

**If React/NextJS detected (up to 7 pages):**
- Component-Architecture.md, State-Management.md, Routing-Navigation.md, Styling-Theming.md, Custom-Hooks.md, Form-Handling-Validation.md, Error-Handling-Boundaries.md

**If API endpoints found (up to 6 pages):**
- API-Overview-Authentication.md, Endpoint-Reference.md, Request-Response-Formats.md, Error-Handling-Status-Codes.md, Rate-Limiting-Pagination.md, Webhooks.md

Present plan in this format:
```
Wiki Documentation Plan
========================
Detected stacks: [WordPress, React, WordPress — as applicable]
Pages to generate:
  Common:     12 pages
  WordPress:     X pages
  WordPress:   X pages
  React/Next:  X pages
  API:         X pages
  ─────────────────────
  Total:       XX pages
```

See `references/sdlc-coverage.md` for SDLC phase mapping.

### [Internal Docs] Build File List

Always generate these 13 core files inside `internal-docs/`:

```
internal-docs/
├── README.md              # Project overview, quick start
├── product-vision.md      # Goals, personas, landscape
├── architecture.md        # High-level architecture
├── codebase-map.md        # Folder-by-folder guide
├── apis.md                # REST, AJAX, hooks, filters, WP-CLI
├── coding-standards.md    # PHP/JS conventions
├── ui-and-copy.md         # User journeys, microcopy
├── onboarding.md          # 1-hour, 1-day, 1-week paths
├── ai-agent-guide.md      # How AI agents should work in this codebase
├── troubleshooting.md     # Common problems
├── faq.md                 # Frequently asked questions
├── glossary.md            # Technical terms
└── maintenance.md         # How to update docs
```

Present plan:
```
Internal Documentation Plan
============================
Files to generate: 13 core files in internal-docs/
```

See `references/doc-templates.md` for complete templates for each file.

**STOP and wait for user approval before generating content.**

---

## Phase 4: Generate Content (Tiered, Dependency-Aware)

**Content guidelines (both modes):**
- Derive all content from actual code (never guess)
- ~500–2,000 words per page/file
- Clear headings, bullet points, code examples
- Include file paths and references to actual code

### [Wiki] Generation Order — SEQUENTIAL TIERS (do not skip ahead)

**SEQUENTIAL REQUIREMENT:** Complete every page in Tier N before starting Tier N+1. Later tiers reference content from earlier ones, so writing them out of order produces broken or placeholder cross-links.

**Tier 1 — Foundational (generate first):** Architecture-Overview, Database-Schema, Environment-Configuration
- Verify these files exist in `wiki-output/` before proceeding to Tier 2.

**Tier 2 — Backend (depends on Tier 1):** WordPress/WordPress-specific pages

**Tier 3 — Frontend (depends on Tier 1):** React/NextJS-specific pages

**Tier 4 — Cross-Cutting (depends on Tiers 1-3):** API pages, Testing-Guide, Deployment-Guide, Contributing-Guide, Troubleshooting-FAQ, Changelog

**Tier 5 — Navigation (generate last — depends on all other tiers):** Home, _Sidebar, _Footer, Getting-Started — these link to every other page and can only be written accurately after all other pages exist.

Use `[Text](Page-Name)` format for cross-links (no `.md` extension). All wiki files must be flat (no subdirectories — GitHub Wiki requirement).

See `references/wiki-page-templates.md` for structural templates.
See `references/cross-linking-guide.md` for linking conventions.

### [Internal Docs] Generation Order

1. `architecture.md` and `codebase-map.md` (foundational — read first by agents)
2. `apis.md` and `coding-standards.md` (depend on architecture)
3. `README.md`, `product-vision.md`, `ui-and-copy.md`, `onboarding.md` (context docs)
4. `ai-agent-guide.md` — Special file: instructs AI coding agents how to work in this codebase (patterns to follow, what to never touch, where key logic lives)
5. `troubleshooting.md`, `faq.md`, `glossary.md` (derived from all above)
6. `maintenance.md` (final — describes how to keep the docs updated)

See `references/doc-templates.md` for full templates.

---

## Phase 5: Quality Gate 2 — Self-Review (BLOCKING GATE)

**Goal:** Validate all generated content before committing

**BLOCKING GATE — Do NOT proceed to Phase 6 until every item below is verified.** This is not a mental checklist — run the bash commands and fix failures before continuing.

### Step 1 — Cross-link Validation (run these commands)

```bash
# Check for broken link format — links must NOT include .md extension
grep -rn "\.md)" wiki-output/*.md && echo "FIX NEEDED: links with .md extension found" || echo "OK: no .md extension links"

# Check for subdirectory paths in links — wiki links must be flat page names
grep -rn "(wiki/" wiki-output/*.md && echo "FIX NEEDED: subdirectory paths in links found" || echo "OK: no subdirectory paths"

# Verify _Sidebar.md exists
ls wiki-output/_Sidebar.md && echo "OK: _Sidebar.md exists" || echo "FIX NEEDED: _Sidebar.md missing"

# Verify _Footer.md exists
ls wiki-output/_Footer.md && echo "OK: _Footer.md exists" || echo "FIX NEEDED: _Footer.md missing"

# List all generated pages — manually verify _Sidebar.md references all of them
ls wiki-output/*.md
```

**Fix all reported issues before continuing.**

### Step 2 — Content Quality Checklist

**Content quality (both modes):**
- [ ] All content derived from actual code (not guessed)
- [ ] No placeholder text (`TODO`, `TBD`, `FIXME`) — search: `grep -rn "TODO\|TBD\|FIXME" wiki-output/`
- [ ] Code examples are syntactically valid
- [ ] File paths reference actual files in the codebase

**[Wiki] Cross-links:**
- [ ] All `[text](Page-Name)` links point to pages that exist in `wiki-output/`
- [ ] `_Sidebar.md` links to every generated page
- [ ] `Home.md` references all major sections
- [ ] `_Footer.md` is present

**Security (both modes):**
- [ ] No secrets, tokens, or API keys in any file
- [ ] No internal IP addresses or hostnames
- [ ] No credentials or passwords
- [ ] `.env` variable names shown but values are placeholders

**Formatting:**
- [ ] Consistent heading hierarchy (H1 for title, H2 for sections)
- [ ] Fenced code blocks have language hints

**Fix any issues found before proceeding to Phase 6.**

---

## Phase 6: Publish

### [Wiki] Push to Wiki Repository

```bash
cd wiki-output
git add -A
git commit -m "docs: generate comprehensive wiki documentation

- Generated XX wiki pages covering full SDLC
- Detected stacks: [list detected stacks]
- Covers architecture, APIs, testing, deployment, contributing
- Cross-linked navigation via Home.md and _Sidebar.md

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

# Push to wiki (wikis use master branch by default)
git push origin master
```

**Important GitHub Wiki quirks:**
- Wiki repos use `master` branch (not `main`)
- All wiki files must be in the root directory (no subdirectories)
- File names become page titles (hyphens render as spaces)
- `_Sidebar.md` and `_Footer.md` are special files (rendered on every page)

**Fallback — If cannot push to wiki:**
```bash
cd ..  # Back to worktree root
mkdir -p docs/wiki
cp wiki-output/*.md docs/wiki/
git add docs/wiki/
git commit -m "docs: add wiki documentation (manual publish needed)
...
Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
git push -u origin chore/wiki-docs
```

Then create PR with instructions for the user to publish the pages manually.

See `references/github-wiki-workflow.md` for detailed workflow.

### [Internal Docs] Commit, Build Integration & PR

**CRITICAL:** Internal docs must NEVER appear in production releases.

**Commit 1 — Documentation:**
```bash
git add internal-docs/
git commit -m "docs(internal): add comprehensive internal documentation

- 13 core doc files (architecture, APIs, standards, onboarding)
- AI agent guide for autonomous implementation
- Optimized for developer and AI consumption

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

**Commit 2 — Build exclusions:**
```bash
# Update .distignore (WP.org releases)
grep -q "internal-docs" .distignore 2>/dev/null || echo "internal-docs/" >> .distignore

# Update .gitattributes (git archive)
grep -q "internal-docs" .gitattributes 2>/dev/null || echo "/internal-docs/ export-ignore" >> .gitattributes

git add .distignore .gitattributes
git commit -m "build: exclude internal-docs from release artifacts

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

**Verify exclusion:**
```bash
git archive --format=zip --output=/tmp/test.zip HEAD
unzip -l /tmp/test.zip | grep internal-docs  # Should be empty
rm /tmp/test.zip
```

**Create PR:**
```bash
git push -u origin chore/internal-docs-update
gh pr create \
  --base dev \
  --title "Internal docs: comprehensive documentation system" \
  --body "..."
```

See `references/packaging-exclusions.md` for all exclusion methods (Grunt, Gulp, npm, GitHub Actions, Composer, WP-CLI).

---

## Phase 7: Cleanup & Summary

**Goal:** Clean up worktree and present results

**Do NOT auto-remove worktree.** The worktree is the safety net — leave it in place so the user can review or revert before deleting. Always show the cleanup command explicitly so the user can run it when satisfied.

**Always present the cleanup command to the user:**

```bash
# Run these ONLY when you are satisfied with the wiki output:
git worktree remove ../${REPO}-docs-work
git branch -d chore/wiki-docs   # or chore/internal-docs-update
```

**[Wiki] Present results:**
```
Wiki Documentation Complete
=============================
Wiki URL: https://github.com/{org}/{repo}/wiki
Pages generated: XX
Detected stacks: [list]
Tiers completed: Tier 1 (Foundational) → Tier 2 (Backend) → Tier 3 (Frontend) → Tier 4 (Cross-Cutting) → Tier 5 (Navigation)
Key pages:
  - Home: https://github.com/{org}/{repo}/wiki
  - Getting Started: https://github.com/{org}/{repo}/wiki/Getting-Started
  - Architecture: https://github.com/{org}/{repo}/wiki/Architecture-Overview

Worktree cleanup (run when satisfied):
  git worktree remove ../${REPO}-docs-work
  git branch -d chore/wiki-docs
```

**[Internal Docs] Present results:**
```
Internal Documentation Complete
================================
PR: [PR URL]
Files generated: 13 core files in internal-docs/
Build exclusions: Added to .distignore and .gitattributes

Worktree cleanup (run when satisfied):
  git worktree remove ../${REPO}-docs-work
  git branch -d chore/internal-docs-update
```

---

## Quality Checklist

Before marking complete:

**Both modes:**
- [ ] Content from actual code (not guessed)
- [ ] No secrets/tokens in any file
- [ ] Commits focused and reviewable
- [ ] PR or wiki URL returned to user

**[Wiki]:**
- [ ] All planned pages generated and populated
- [ ] All cross-links validated
- [ ] _Sidebar.md links to all pages
- [ ] Home.md provides complete overview

**[Internal Docs]:**
- [ ] All 13 doc files created and populated
- [ ] Build exclusion verified (artifact checked)
- [ ] ai-agent-guide.md written for AI agent consumption

---

## Safety Rules

- **NEVER** use destructive commands without approval (`reset --hard`, `push --force`, `clean -f`)
- **ALWAYS** run `git fetch origin` before creating the worktree branch
- **ALWAYS** work in a git worktree — working in `/tmp`, a bare clone, or the main directory is never acceptable
- **ALWAYS** verify worktree exists with `git worktree list` before generating any files
- **ALWAYS** run the 6 codebase discovery groups as a parallel batch — no ad-hoc file reads outside the structured groups
- **ALWAYS** generate wiki pages in tier order (Tier 1 → 2 → 3 → 4 → 5) — never write navigation pages before content pages
- **ALWAYS** run Phase 5 cross-link validation commands before pushing — do not rely on a mental check
- **ALWAYS** verify no secrets before committing
- **ALWAYS** commit with descriptive messages
- **ALWAYS** present the worktree cleanup commands to the user at the end — do NOT auto-remove
- **NEVER** overwrite existing wiki pages without user approval
- **NEVER** push to wiki without showing the page plan first
- **[Internal Docs]** NEVER commit internal-docs without verifying build exclusion works

---

## References

- `references/tech-stack-detection.md` — Score-based stack detection
- `references/scanning-strategy.md` — Codebase discovery patterns
- `references/wiki-page-templates.md` — Structural templates for wiki pages
- `references/doc-templates.md` — Templates for 13 internal doc files
- `references/github-wiki-workflow.md` — Wiki git workflow and quirks
- `references/cross-linking-guide.md` — Wiki cross-linking conventions
- `references/sdlc-coverage.md` — SDLC phases mapped to wiki pages
- `references/packaging-exclusions.md` — Release exclusion for .distignore, Grunt, Gulp, npm, GitHub Actions
- `references/edge-cases.md` — Monorepos, hybrid stacks, no wiki access
- `templates/` — Starter templates for common wiki pages
- `examples/` — Example wiki pages for reference

