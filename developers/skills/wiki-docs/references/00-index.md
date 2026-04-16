# Wiki-Docs Skill Index

> Complete navigation guide for the wiki-docs skill reference documentation
> Last updated: 2026-02-17

## Quick Navigation

### Core Documentation

| File | Purpose | Keywords |
|------|---------|----------|
| [SKILL.md](../SKILL.md) | Main skill workflow (8 phases) | workflow, phases, generation, wiki |
| [tech-stack-detection.md](tech-stack-detection.md) | Score-based stack detection logic | WordPress, React, NextJS, WordPress, detection, scoring |
| [scanning-strategy.md](scanning-strategy.md) | Codebase discovery and analysis patterns | scanning, discovery, parallel, Glob, Grep, Read |
| [wiki-page-templates.md](wiki-page-templates.md) | Structural templates for all wiki page types | templates, structure, pages, format, Home, Sidebar |
| [github-wiki-workflow.md](github-wiki-workflow.md) | Wiki git workflow, quirks, and push mechanics | wiki, git, clone, push, master, worktree |
| [cross-linking-guide.md](cross-linking-guide.md) | Wiki page cross-linking conventions | links, anchors, cross-reference, navigation, sidebar |
| [sdlc-coverage.md](sdlc-coverage.md) | SDLC phases mapped to wiki pages | lifecycle, coverage, phases, planning, gap analysis |
| [edge-cases.md](edge-cases.md) | Non-standard scenarios and adaptations | monorepo, hybrid, no-wiki, small projects, edge cases |

### Examples

| File | Purpose | Keywords |
|------|---------|----------|
| [sample-home.md](../examples/sample-home.md) | Example Home.md for a multi-stack project | home, landing, example, table of contents |
| [sample-sidebar.md](../examples/sample-sidebar.md) | Example _Sidebar.md with full navigation | sidebar, navigation, example, hierarchical |
| [sample-api-page.md](../examples/sample-api-page.md) | Example API endpoint reference page | api, endpoints, example, REST, authentication |

### Templates

| File | Purpose |
|------|---------|
| Home.md template | Wiki landing page with project overview and TOC |
| Getting-Started.md template | Prerequisites, installation, first run |
| Architecture-Overview.md template | System design, components, tech stack |
| Database-Schema.md template | Tables, relationships, migrations |
| Environment-Configuration.md template | Config files, env variables, secrets |
| Testing-Guide.md template | Test setup, writing tests, running tests |
| Deployment-Guide.md template | CI/CD, environments, release process |
| Contributing-Guide.md template | PR process, coding standards, review |
| Troubleshooting-FAQ.md template | Symptom-cause-solution entries |
| Changelog.md template | Version history with categorized entries |
| _Sidebar.md template | Hierarchical navigation for all pages |

See [wiki-page-templates.md](wiki-page-templates.md) for all template definitions.

---

## Reading Paths by Audience

### First-Time Users
**Goal:** Understand what this skill does and how to use it

1. Start: [SKILL.md](../SKILL.md) -- Overview and 8-phase workflow
2. Context: [github-wiki-workflow.md](github-wiki-workflow.md) -- How GitHub Wiki works
3. Output: [wiki-page-templates.md](wiki-page-templates.md) -- What pages will be generated
4. Examples: [sample-home.md](../examples/sample-home.md) -- See output quality

### Technical Implementers
**Goal:** Understand detection, scanning, and edge case handling

1. Core: [SKILL.md](../SKILL.md) -- Full workflow (all 8 phases)
2. Detection: [tech-stack-detection.md](tech-stack-detection.md) -- How stacks are identified
3. Scanning: [scanning-strategy.md](scanning-strategy.md) -- Codebase analysis approach
4. Templates: [wiki-page-templates.md](wiki-page-templates.md) -- Page structure and content
5. Edge cases: [edge-cases.md](edge-cases.md) -- Non-standard scenarios

### AI Agents
**Goal:** Execute the skill correctly and produce high-quality wiki output

1. **Before execution:** Read [SKILL.md](../SKILL.md) Phases 0-7 carefully
2. **During scanning:** Reference [scanning-strategy.md](scanning-strategy.md) for tool usage patterns
3. **When building page plan:** Use [sdlc-coverage.md](sdlc-coverage.md) for phase mapping
4. **When writing pages:** Use [wiki-page-templates.md](wiki-page-templates.md) for structure
5. **When adding links:** Follow [cross-linking-guide.md](cross-linking-guide.md) conventions
6. **For git operations:** Follow [github-wiki-workflow.md](github-wiki-workflow.md) strictly
7. **For unusual projects:** Check [edge-cases.md](edge-cases.md) for adaptations

**Critical:** Always validate cross-links before committing. Never push to wiki without user approval.

### Documentation Writers
**Goal:** Understand documentation standards and quality expectations

1. Templates: [wiki-page-templates.md](wiki-page-templates.md) -- All page types with structure
2. Linking: [cross-linking-guide.md](cross-linking-guide.md) -- How pages interconnect
3. Coverage: [sdlc-coverage.md](sdlc-coverage.md) -- Ensuring comprehensive documentation
4. Examples: [sample-home.md](../examples/sample-home.md), [sample-sidebar.md](../examples/sample-sidebar.md), [sample-api-page.md](../examples/sample-api-page.md)

---

## Quick Task Lookup

### "How do I...?"

| Task | Reference | Section |
|------|-----------|---------|
| Detect the project's tech stack | [tech-stack-detection.md](tech-stack-detection.md) | Detection Groups |
| Scan the codebase for content | [scanning-strategy.md](scanning-strategy.md) | All phases |
| Build the wiki page plan | [SKILL.md](../SKILL.md) | Phase 3: Page Plan |
| Determine which pages to generate | [sdlc-coverage.md](sdlc-coverage.md) | SDLC Phase Mapping |
| Structure a specific page type | [wiki-page-templates.md](wiki-page-templates.md) | Template for page type |
| Add cross-links between pages | [cross-linking-guide.md](cross-linking-guide.md) | Cross-Link Strategy |
| Clone and push to wiki repo | [github-wiki-workflow.md](github-wiki-workflow.md) | Wiki Repository Setup |
| Handle monorepo documentation | [edge-cases.md](edge-cases.md) | Monorepo Structures |
| Handle no wiki access | [edge-cases.md](edge-cases.md) | No Wiki Access |
| Handle pre-existing wiki | [edge-cases.md](edge-cases.md) | Pre-existing Wiki Content |
| Handle multi-stack projects | [edge-cases.md](edge-cases.md) | Hybrid / Multi-Stack |
| Scale down for small projects | [edge-cases.md](edge-cases.md) | Small Projects |
| Validate all links work | [cross-linking-guide.md](cross-linking-guide.md) | Validation Checklist |
| Verify SDLC coverage is complete | [sdlc-coverage.md](sdlc-coverage.md) | Coverage Verification |
| Set up worktree for wiki work | [SKILL.md](../SKILL.md) | Phase 1: Pre-Flight |
| Create PR when wiki push fails | [github-wiki-workflow.md](github-wiki-workflow.md) | Fallback Path |
| Self-review generated pages | [SKILL.md](../SKILL.md) | Phase 5: Quality Gate 2 |
| Clean up after generation | [SKILL.md](../SKILL.md) | Phase 7: Cleanup |

---

## Search Keywords

### By Concept

**Git & Wiki Operations:**
- Wiki clone: [github-wiki-workflow.md](github-wiki-workflow.md)
- Wiki push: [github-wiki-workflow.md](github-wiki-workflow.md)
- Master branch: [github-wiki-workflow.md](github-wiki-workflow.md)
- Worktree: [SKILL.md](../SKILL.md)
- Fallback/PR: [github-wiki-workflow.md](github-wiki-workflow.md)

**Stack Detection:**
- WordPress: [tech-stack-detection.md](tech-stack-detection.md)
- React: [tech-stack-detection.md](tech-stack-detection.md)
- NextJS: [tech-stack-detection.md](tech-stack-detection.md)
- WordPress: [tech-stack-detection.md](tech-stack-detection.md)
- Scoring: [tech-stack-detection.md](tech-stack-detection.md)
- Multi-stack: [edge-cases.md](edge-cases.md)

**Codebase Discovery:**
- Scanning: [scanning-strategy.md](scanning-strategy.md)
- API endpoints: [scanning-strategy.md](scanning-strategy.md)
- Database schema: [scanning-strategy.md](scanning-strategy.md)
- Frontend components: [scanning-strategy.md](scanning-strategy.md)
- Hooks/filters: [scanning-strategy.md](scanning-strategy.md)

**Page Generation:**
- Templates: [wiki-page-templates.md](wiki-page-templates.md)
- Page plan: [SKILL.md](../SKILL.md)
- Tier order: [SKILL.md](../SKILL.md)
- Content guidelines: [SKILL.md](../SKILL.md)
- SDLC mapping: [sdlc-coverage.md](sdlc-coverage.md)

**Cross-Linking:**
- Link format: [cross-linking-guide.md](cross-linking-guide.md)
- Anchors: [cross-linking-guide.md](cross-linking-guide.md)
- Page names: [cross-linking-guide.md](cross-linking-guide.md)
- Validation: [cross-linking-guide.md](cross-linking-guide.md)
- Sidebar: [cross-linking-guide.md](cross-linking-guide.md)

**Edge Cases:**
- Monorepo: [edge-cases.md](edge-cases.md)
- No wiki: [edge-cases.md](edge-cases.md)
- Small projects: [edge-cases.md](edge-cases.md)
- No tests: [edge-cases.md](edge-cases.md)
- No CI/CD: [edge-cases.md](edge-cases.md)
- Private repos: [edge-cases.md](edge-cases.md)
- Existing docs: [edge-cases.md](edge-cases.md)

**Quality & Validation:**
- Self-review: [SKILL.md](../SKILL.md)
- Link validation: [cross-linking-guide.md](cross-linking-guide.md)
- Coverage check: [sdlc-coverage.md](sdlc-coverage.md)
- Security check: [SKILL.md](../SKILL.md)

### By Tool

**Claude Code Tools:**
- Glob: [scanning-strategy.md](scanning-strategy.md) -- File finding patterns
- Grep: [scanning-strategy.md](scanning-strategy.md) -- Content search patterns
- Read: [scanning-strategy.md](scanning-strategy.md) -- File reading usage, [tech-stack-detection.md](tech-stack-detection.md) -- Config files
- Write: [SKILL.md](../SKILL.md) -- Wiki page creation
- Bash: [github-wiki-workflow.md](github-wiki-workflow.md) -- Git commands, [SKILL.md](../SKILL.md) -- Worktree setup

**External Tools:**
- Git: [github-wiki-workflow.md](github-wiki-workflow.md) -- Wiki repo operations
- GitHub CLI (gh): [SKILL.md](../SKILL.md) -- PR creation fallback
- GitHub Wiki: [github-wiki-workflow.md](github-wiki-workflow.md) -- Rendering, quirks

---

## Document Status

| File | Status | Last Major Update |
|------|--------|-------------------|
| SKILL.md | Current | 2026-02-17 |
| tech-stack-detection.md | Planned | -- |
| scanning-strategy.md | Planned | -- |
| wiki-page-templates.md | Planned | -- |
| github-wiki-workflow.md | Planned | -- |
| cross-linking-guide.md | Current | 2026-02-17 |
| sdlc-coverage.md | Current | 2026-02-17 |
| edge-cases.md | Current | 2026-02-17 |
| sample-home.md | Planned | -- |
| sample-sidebar.md | Planned | -- |
| sample-api-page.md | Planned | -- |

---

## Contribution Guidelines

When updating wiki-docs skill documentation:

1. **Update this index** if you add, remove, or rename files
2. **Update "Last Major Update"** dates when making significant changes
3. **Maintain keyword consistency** across documents
4. **Test all internal links** before committing
5. **Add new tasks** to "Quick Task Lookup" when adding features
6. **Follow `{placeholder}` convention** -- never hardcode project-specific values
7. **Keep content depth** between 200-400 lines per reference file

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-17 | Initial skill creation with SKILL.md and 3 reference files (cross-linking-guide, sdlc-coverage, edge-cases) |

---

## Need Help?

**Can't find what you're looking for?**
1. Use `Ctrl+F` or `Cmd+F` to search this page
2. Check the [Quick Task Lookup](#quick-task-lookup) section
3. Browse by [audience path](#reading-paths-by-audience)
4. Search by [keyword](#search-keywords)

**Found an issue?**
- File a bug report with the wiki-docs skill maintainer
- Include: what you were looking for, what you found instead, suggested fix
