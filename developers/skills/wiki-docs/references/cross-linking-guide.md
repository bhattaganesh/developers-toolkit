# Cross-Linking Guide

> Conventions for cross-linking between GitHub Wiki pages
> For use with the wiki-docs skill

## Overview

Wiki pages should form an **interconnected knowledge graph**, not isolated documents. Cross-linking enables developers to navigate between related topics naturally, discover relevant documentation they didn't know existed, and understand how concepts relate to each other.

**Goals of cross-linking:**
- Every page is reachable from Home.md and _Sidebar.md
- Related concepts link to each other inline
- Developers can follow any learning path without dead ends
- No orphan pages (pages with zero incoming links)

---

## Table of Contents

1. [GitHub Wiki Link Format](#github-wiki-link-format)
2. [Page Name Rules](#page-name-rules)
3. [Anchor Link Rules](#anchor-link-rules)
4. [Cross-Link Strategy per Page Type](#cross-link-strategy-per-page-type)
5. [Common Cross-Link Patterns](#common-cross-link-patterns)
6. [Common Mistakes](#common-mistakes)
7. [Validation Checklist](#validation-checklist)

---

## GitHub Wiki Link Format

### Basic Page Link

```markdown
[Display Text](Page-Name)
```

**Critical:** Do NOT include the `.md` extension. GitHub Wiki strips it automatically when rendering page titles, and including it will create broken links.

```markdown
<!-- CORRECT -->
[Architecture Overview](Architecture-Overview)

<!-- WRONG — will break -->
[Architecture Overview](Architecture-Overview.md)
```

### Link with Anchor

```markdown
[Display Text](Page-Name#section-heading)
```

Navigate to a specific section within another page:

```markdown
[Authentication Setup](API-Overview-Authentication#token-management)
[WordPress Models](Models-Relationships#defining-relationships)
[React Hooks](Custom-Hooks#data-fetching-hooks)
```

### Same-Page Anchor

```markdown
[Section Name](#section-heading)
```

Navigate within the current page:

```markdown
See [Error Codes](#error-codes) below.
Refer to the [Prerequisites](#prerequisites) section.
```

### External Links

```markdown
[Text](https://example.com)
```

Link to external resources:

```markdown
[WordPress Documentation](https://WordPress.com/docs)
[React Official Docs](https://react.dev)
[WordPress Developer Resources](https://developer.wordpress.org)
```

### Image Links

```markdown
![Alt text](https://raw.githubusercontent.com/{org}/{repo}/main/docs/images/diagram.png)
```

**Note:** Wiki images must use absolute URLs. Relative image paths do not work in GitHub Wiki.

---

## Page Name Rules

### File-to-Link Mapping

The wiki page filename (without `.md`) is the link target:

| File on Disk | Link Target | Rendered Page Title |
|-------------|-------------|-------------------|
| `Home.md` | `Home` | Home |
| `Architecture-Overview.md` | `Architecture-Overview` | Architecture Overview |
| `Getting-Started.md` | `Getting-Started` | Getting Started |
| `API-Overview-Authentication.md` | `API-Overview-Authentication` | API Overview Authentication |
| `_Sidebar.md` | `_Sidebar` | (sidebar navigation) |
| `_Footer.md` | `_Footer` | (footer content) |

### Key Conventions

1. **Hyphens become spaces** in page titles: `Getting-Started` renders as "Getting Started"
2. **Links are case-sensitive**: `Architecture-Overview` is not the same as `architecture-overview`
3. **Use Title-Case-With-Hyphens** for all page names: `Component-Architecture`, not `component-architecture`
4. **No subdirectories**: GitHub Wiki is flat. All `.md` files must be in the root of the wiki repo
5. **Special pages** (`_Sidebar.md`, `_Footer.md`, `Home.md`):
   - `_Sidebar` and `_Footer` render on every wiki page automatically
   - `Home` is the wiki landing page
   - Other pages link FROM these; do not link TO them from content pages

### Naming Patterns by Stack

**WordPress pages:**
- `Service-Layer-Architecture`
- `Controllers-Request-Lifecycle`
- `Models-Relationships`
- `Middleware-Guards`
- `Jobs-Events-Listeners`

**React/NextJS pages:**
- `Component-Architecture`
- `State-Management`
- `Routing-Navigation`
- `Custom-Hooks`

**WordPress pages:**
- `Plugin-Theme-Architecture`
- `Hooks-Filters-Reference`
- `Custom-Post-Types-Taxonomies`
- `Gutenberg-Blocks`

**API pages:**
- `API-Overview-Authentication`
- `Endpoint-Reference`
- `Request-Response-Formats`

---

## Anchor Link Rules

### How Anchors Are Generated

GitHub generates anchors from markdown headings automatically:

| Heading | Generated Anchor |
|---------|-----------------|
| `## My Section` | `#my-section` |
| `## API Overview` | `#api-overview` |
| `### 1. Getting Started` | `#1-getting-started` |
| `## What's New?` | `#whats-new` |
| `## Error Codes & Status` | `#error-codes--status` |

### Transformation Rules

1. **Convert to lowercase**: `My Section` becomes `my-section`
2. **Spaces become hyphens**: `API Overview` becomes `api-overview`
3. **Special characters stripped**: Apostrophes, question marks, periods removed
4. **Ampersands** become double hyphens: `&` becomes `--`
5. **Leading numbers preserved**: `1. Setup` becomes `1-setup`
6. **Parentheses removed**: `Setup (Optional)` becomes `setup-optional`

### Duplicate Heading Handling

When a page has duplicate headings, GitHub appends a numeric suffix:

```markdown
## Configuration          → #configuration
## Configuration          → #configuration-1
## Configuration          → #configuration-2
```

**Best practice:** Avoid duplicate headings. Use descriptive, unique headings instead:

```markdown
## WordPress Configuration
## React Configuration
## WordPress Configuration
```

### Cross-Page Anchor Examples

```markdown
<!-- Link to a specific section on another page -->
[Setting up the database](Getting-Started#database-setup)
[Controller middleware](Controllers-Request-Lifecycle#middleware-assignment)
[Redux store structure](State-Management#redux-store-setup)
[Plugin activation hooks](Hooks-Filters-Reference#activation-deactivation)
```

---

## Cross-Link Strategy per Page Type

### Home.md

**Role:** Primary entry point. Links to ALL major pages.

**Linking pattern:**
- Table of contents with links to every generated page
- Grouped by category (Getting Started, Architecture, Backend, Frontend, API, Operations)
- Brief description next to each link

```markdown
## Documentation

### Getting Started
- [Getting Started](Getting-Started) — Prerequisites, installation, first run
- [Environment Configuration](Environment-Configuration) — Config files, env variables

### Architecture
- [Architecture Overview](Architecture-Overview) — System design and components
- [Database Schema](Database-Schema) — Tables, relationships, migrations

### Backend
- [Service Layer](Service-Layer-Architecture) — Business logic patterns
- [Controllers](Controllers-Request-Lifecycle) — Request handling
...
```

### _Sidebar.md

**Role:** Persistent navigation visible on every page.

**Linking pattern:**
- Hierarchical list with ALL pages
- Grouped logically, indented for sub-topics
- No descriptions (space is limited)

```markdown
**[Home](Home)**

**Getting Started**
- [Setup Guide](Getting-Started)
- [Environment](Environment-Configuration)

**Architecture**
- [Overview](Architecture-Overview)
- [Database](Database-Schema)

**Backend**
- [Services](Service-Layer-Architecture)
- [Controllers](Controllers-Request-Lifecycle)
- [Models](Models-Relationships)
...
```

### _Footer.md

**Role:** Minimal footer on every page.

**Linking pattern:**
- Link back to Home
- Link to Contributing Guide
- Optional: link to external project resources

```markdown
[Home](Home) | [Contributing](Contributing-Guide) | [Changelog](Changelog)
```

### Architecture-Overview.md

**Links TO:**
- [Database-Schema](Database-Schema) — when referencing data layer
- Stack-specific pages (Service-Layer, Component-Architecture, Plugin-Theme-Architecture)
- [API-Overview-Authentication](API-Overview-Authentication) — when referencing API layer
- [Environment-Configuration](Environment-Configuration) — when referencing config

**Links FROM:**
- Home, _Sidebar, Getting-Started, most stack-specific pages

### Getting-Started.md

**Links TO:**
- [Environment-Configuration](Environment-Configuration) — config details
- [Contributing-Guide](Contributing-Guide) — next steps after setup
- [Architecture-Overview](Architecture-Overview) — understanding the codebase
- [Troubleshooting-FAQ](Troubleshooting-FAQ) — if setup goes wrong

**Links FROM:**
- Home, _Sidebar

### Stack-Specific Pages (WordPress, React, WordPress)

**Links TO:**
- Other pages in the same stack group
- [Architecture-Overview](Architecture-Overview) — for context
- [Testing-Guide](Testing-Guide) — how to test this area
- [API pages](API-Overview-Authentication) — if the stack exposes/consumes APIs

**Links FROM:**
- Home, _Sidebar, Architecture-Overview

### API Pages

**Links TO:**
- Each other (Overview links to Endpoint-Reference, which links to Request-Response-Formats)
- [Architecture-Overview](Architecture-Overview) — system context
- Stack-specific backend pages (Controllers, Plugin-Theme-Architecture)
- [Testing-Guide](Testing-Guide) — API testing

**Links FROM:**
- Home, _Sidebar, Architecture-Overview, backend stack pages

### Testing-Guide.md

**Links TO:**
- Stack-specific pages (what to test and how)
- [Contributing-Guide](Contributing-Guide) — test requirements for PRs
- [Deployment-Guide](Deployment-Guide) — tests in CI/CD

**Links FROM:**
- Home, _Sidebar, Contributing-Guide, stack-specific pages

### Deployment-Guide.md

**Links TO:**
- [Environment-Configuration](Environment-Configuration) — production config
- [Testing-Guide](Testing-Guide) — pre-deploy testing
- [Troubleshooting-FAQ](Troubleshooting-FAQ) — deployment issues

**Links FROM:**
- Home, _Sidebar

### Contributing-Guide.md

**Links TO:**
- [Getting-Started](Getting-Started) — environment setup
- [Testing-Guide](Testing-Guide) — test requirements
- [Architecture-Overview](Architecture-Overview) — understanding codebase
- Stack-specific pages — coding conventions

**Links FROM:**
- Home, _Sidebar, _Footer, Getting-Started

### Troubleshooting-FAQ.md

**Links TO:**
- Relevant stack pages for specific issues
- [Environment-Configuration](Environment-Configuration) — config problems
- [Getting-Started](Getting-Started) — setup issues

**Links FROM:**
- Home, _Sidebar, Getting-Started, Deployment-Guide

---

## Common Cross-Link Patterns

### Pattern 1: Inline Contextual Links

Embed links naturally within prose:

```markdown
The application uses a [service layer pattern](Service-Layer-Architecture) to
separate business logic from [controllers](Controllers-Request-Lifecycle). Each
service interacts with [WPDB models](Models-Relationships) and may dispatch
[queued jobs](Jobs-Events-Listeners) for async processing.
```

### Pattern 2: "See Also" Section

Add a dedicated section at the bottom of each page:

```markdown
---

## See Also

- [Architecture Overview](Architecture-Overview) — System-level design context
- [Database Schema](Database-Schema) — Related table structures
- [Testing Guide](Testing-Guide) — How to test services
```

### Pattern 3: Related Pages Footer

Smaller than "See Also", for tightly related pages:

```markdown
---

**Related:** [Controllers](Controllers-Request-Lifecycle) | [Middleware](Middleware-Guards) | [Models](Models-Relationships)
```

### Pattern 4: "Prerequisites" or "Before You Begin"

At the top of a page, guide the reader:

```markdown
## Prerequisites

Before diving into this section, review:
- [Architecture Overview](Architecture-Overview) — understand the system design
- [Environment Configuration](Environment-Configuration) — ensure your local setup is ready
```

### Pattern 5: "Next Steps" Section

Guide the reader forward:

```markdown
## Next Steps

- Set up your [local development environment](Getting-Started#local-development)
- Review the [contribution guidelines](Contributing-Guide)
- Explore the [API documentation](API-Overview-Authentication)
```

### Pattern 6: Callout Links

Draw attention to important related pages:

```markdown
> **Note:** This page covers the backend service layer. For frontend state
> management, see [State Management](State-Management).
```

---

## Common Mistakes

### 1. Including `.md` Extension

```markdown
<!-- WRONG -->
[Architecture](Architecture-Overview.md)

<!-- CORRECT -->
[Architecture](Architecture-Overview)
```

The `.md` extension causes 404 errors in GitHub Wiki.

### 2. Wrong Case in Page Names

```markdown
<!-- WRONG — case mismatch -->
[Getting Started](getting-started)

<!-- CORRECT — match exact filename -->
[Getting Started](Getting-Started)
```

Wiki links are case-sensitive. The link must match the filename exactly.

### 3. Linking to Non-Existent Pages

Always verify that the target page exists in the wiki page plan before adding a link. A link to a page not yet generated creates a "create this page" prompt in GitHub Wiki, which confuses readers.

**Prevention:** Cross-reference every link against the page plan from Phase 3.

### 4. Linking TO Special Pages

```markdown
<!-- WRONG — don't link to sidebar/footer from content -->
See the [Sidebar](_Sidebar) for navigation.

<!-- CORRECT — sidebar is automatic, no need to link to it -->
Use the sidebar navigation to browse all pages.
```

`_Sidebar.md` and `_Footer.md` are rendered automatically. Content pages should not link to them.

### 5. Circular Links Without Context

```markdown
<!-- UNHELPFUL — circular without reason -->
Page A: "See [Page B](Page-B)"
Page B: "See [Page A](Page-A)"

<!-- HELPFUL — each link explains what the reader will find -->
Page A: "For implementation details, see [Page B](Page-B)"
Page B: "For the design rationale behind this, see [Page A](Page-A)"
```

### 6. Over-Linking

```markdown
<!-- WRONG — too many links, unreadable -->
The [application](Architecture-Overview) uses [WordPress](Getting-Started)
[controllers](Controllers-Request-Lifecycle) with [middleware](Middleware-Guards)
and [models](Models-Relationships) connected to the [database](Database-Schema).

<!-- CORRECT — link key terms on first mention -->
The application uses WordPress controllers with [middleware](Middleware-Guards)
and models connected to the database. For the full architecture, see
[Architecture Overview](Architecture-Overview).
```

**Rule of thumb:** Link a term the first time it appears on a page. Do not re-link the same term in subsequent paragraphs.

### 7. Broken Anchor Links

```markdown
<!-- WRONG — anchor doesn't match heading format -->
[Setup](#SetUp)

<!-- CORRECT — lowercase, hyphens -->
[Setup](#set-up)
```

Always convert anchors to lowercase with hyphens.

### 8. Relative File Paths

```markdown
<!-- WRONG — relative paths don't work in wiki -->
See [the config](./docs/config.md)
![Diagram](../images/arch.png)

<!-- CORRECT — use wiki page names or absolute URLs -->
See [Environment Configuration](Environment-Configuration)
![Diagram](https://raw.githubusercontent.com/{org}/{repo}/main/docs/images/arch.png)
```

---

## Validation Checklist

Run this checklist after generating all wiki pages:

### Link Integrity

- [ ] Every `[text](Page-Name)` link targets a page that exists in the wiki
- [ ] No links contain `.md` extension
- [ ] All page name references match exact filename case
- [ ] All anchor links use lowercase-hyphenated format
- [ ] No links to `_Sidebar` or `_Footer` from content pages

### Coverage

- [ ] Home.md links to every generated page
- [ ] _Sidebar.md lists every generated page
- [ ] Every page has at least one incoming link (no orphans)
- [ ] Every page has at least one outgoing link (no dead ends)
- [ ] Stack-specific pages link to related pages within the same stack

### Quality

- [ ] Links have descriptive display text (not "click here" or "this page")
- [ ] Each term is linked on first mention only (no over-linking)
- [ ] "See Also" or "Related" sections at bottom of content pages
- [ ] External links open to valid URLs
- [ ] No placeholder links (`[TODO](TODO)` or `[TBD](TBD)`)

### Automated Verification

To verify links programmatically after generating pages:

```bash
# Find all wiki-style links in generated pages
grep -oP '\[.*?\]\(([A-Z][a-zA-Z-]+)\)' wiki-output/*.md | \
  sed 's/.*(\(.*\))/\1/' | sort -u > linked-pages.txt

# List all generated page names (without .md)
ls wiki-output/*.md | sed 's|.*/||;s|\.md||' > actual-pages.txt

# Find broken links (pages linked but don't exist)
comm -23 linked-pages.txt actual-pages.txt
```

If any page names appear in `linked-pages.txt` but not in `actual-pages.txt`, those links will be broken.

---

## Related Documentation

- [SKILL.md](../SKILL.md) — Main workflow (Phase 4 uses cross-linking)
- [wiki-page-templates.md](wiki-page-templates.md) — Templates with link placeholders
- [sdlc-coverage.md](sdlc-coverage.md) — Which pages exist to link between
- [edge-cases.md](edge-cases.md) — Link handling for monorepos and hybrid stacks

