# Internal Documentation Templates

> Complete templates for all 9 internal documentation files
> Use these as starting points and adapt to your specific project

This file contains detailed templates for creating comprehensive internal documentation. For the full, detailed templates with extensive examples, these are the 13 core files you should create:

1. **README.md** - Project overview and quick start
2. **product-vision.md** - Product goals, user personas, competitive landscape
3. **architecture.md** - High-level architecture and data flow
4. **codebase-map.md** - Folder-by-folder guide
5. **apis.md** - REST endpoints, hooks, filters
6. **coding-standards.md** - PHP/JS conventions
7. **ui-and-copy.md** - User journeys and microcopy
8. **onboarding.md** - 1-hour, 1-day, 1-week paths
9. **ai-agent-guide.md** - AI agent instructions
10. **troubleshooting.md** - Common problems and solutions
11. **faq.md** - Frequently asked questions
12. **glossary.md** - Technical terms and acronyms
13. **maintenance.md** - How to keep docs updated

## Key Template Principles

**Each doc file should include:**
- Clear heading structure (H1 for title, H2 for sections)
- "Last updated" date at the top
- Concise but complete information (500-2000 words per doc)
- Code examples where helpful
- File paths and line references
- Links to related docs

**Tone:**
- Developer-friendly
- Actionable (provide clear next steps)
- Searchable (use terms developers will search for)
- Concise (respect reader's time)

## Template Structure Examples

### README.md Template Structure
\`\`\`markdown
# Project Name

> Internal Documentation - Last updated: [Date]

## What This Is
[2-3 sentence description]

## Quick Start
[Setup steps, key commands]

## Documentation Index
[Links to other docs]
\`\`\`

### architecture.md Template Structure  
\`\`\`markdown
# Architecture

## High-Level Overview
[System description, principles]

## System Diagram
[Text-based diagram]

## Core Components
[Component 1, 2, 3... with files and responsibilities]

## Data Flow Examples
[Request/response flows]

## Security Architecture
[Auth, validation, escaping patterns]

## Extensibility
[Hooks and filters provided]
\`\`\`

### codebase-map.md Template Structure
\`\`\`markdown
# Codebase Map

## Root Directory
[Core files with purposes]

## /inc/ or /src/
[PHP backend folders and files]

## /src/ (frontend)
[JavaScript/React structure]

## /assets/
[Compiled assets]

## Naming Conventions
[File and class naming patterns]
\`\`\`

### apis.md Template Structure
\`\`\`markdown
# APIs and Integrations

## REST API Endpoints
[Endpoint URL, method, purpose, auth, params, response]

## Admin AJAX Actions  
[Action name, purpose, params, response]

## WordPress Hooks
### Actions (Plugin Provides)
[Actions your plugin fires]

### Filters (Plugin Provides)
[Filters your plugin provides]

## WP-CLI Commands
[Command usage and examples]
\`\`\`

### coding-standards.md Template Structure
\`\`\`markdown
# Coding Standards

## PHP Standards
[Style, naming, patterns]

## JavaScript Standards
[Style, naming, React patterns]

## Security Patterns
[Sanitization, escaping, nonces, capabilities]

## Git Commit Standards
[Commit message format]
\`\`\`

### ui-and-copy.md Template Structure
\`\`\`markdown
# UI and Copy Guidelines

## Product Overview
[What users get, value prop]

## Core User Journeys
[Journey 1, 2, 3... with steps and outcomes]

## Microcopy Principles
[Voice, tone, terminology]

## UI Patterns
[Layouts, forms, modals, notifications]
\`\`\`

### onboarding.md Template Structure
\`\`\`markdown
# Developer Onboarding

> Getting new developers productive quickly

## Pre-Onboarding Checklist

**Before Day 1:**
- [ ] GitHub/GitLab access granted
- [ ] Development environment requirements documented
- [ ] Slack/communication channels joined
- [ ] Project management tool access (Jira/Linear/etc.)

**Tools to install:**
- [ ] PHP 8.0+ (check: \`php --version\`)
- [ ] Node.js 18+ (check: \`node --version\`)
- [ ] Composer (check: \`composer --version\`)
- [ ] wp-cli (optional, for WP plugins: \`wp --version\`)
- [ ] IDE with recommended extensions (VSCode, PHPStorm, etc.)

**Repository access:**
- [ ] Clone repository: \`git clone <url>\`
- [ ] Install dependencies: \`composer install && npm install\`
- [ ] Copy environment template: \`cp .env.example .env\`
- [ ] Build assets: \`npm run build\`
- [ ] Run tests: \`npm test && composer test\`

---

## 1-Hour Path: Quick Orientation

**Goal:** Understand what this project does and see it running.

**Tasks:**

1. **Read core documentation** (30 min)
   - Read [README.md](README.md) - Project overview
   - Read [product-vision.md](product-vision.md) - What we're building and why
   - Skim [architecture.md](architecture.md) - High-level structure

2. **Get it running locally** (15 min)
   - Follow setup instructions in README
   - Access the application in browser/CLI
   - Click through main user flows
   - Observe what the product does from a user perspective

3. **Explore the codebase structure** (15 min)
   - Open [codebase-map.md](codebase-map.md)
   - Navigate through key directories in your IDE
   - Find the main entry point (plugin file, index.php, app.js)
   - Locate where user-facing features are implemented

**By end of hour, you should:**
- ✅ Know what problem this project solves
- ✅ Have project running locally
- ✅ Understand folder structure at high level

---

## 1-Day Path: Make Your First Change

**Goal:** Understand how code works and make a small contribution.

**Part 1: Understanding the Codebase**

1. **Deep dive on architecture**
   - Read [architecture.md](architecture.md) thoroughly
   - Understand the request/response flow
   - Identify main components and how they interact
   - Draw a diagram if helpful (for your own understanding)

2. **Pick a feature to trace**
   - Choose a user-facing feature (e.g., "Add new post" or "Search")
   - Start from the UI: Where does the button click trigger?
   - Follow the code path:
     - Frontend: Button → event handler → API call
     - Backend: Route → controller → service → model → database
   - Read the actual code, don't just skim
   - Use debugger/var_dump to see data flow

3. **Review coding standards**
   - Read [coding-standards.md](coding-standards.md)
   - Understand naming conventions
   - Review security patterns (sanitization, escaping, nonces)
   - Check linter/formatter configuration

**Part 2: Making Your First Contribution**

4. **Make your first change**
   - **Option A: Fix a typo or improve wording** (easiest)
     - Find a user-facing string
     - Improve clarity or fix grammar
     - Commit: "fix: improve wording of error message"

   - **Option B: Add a small feature** (intermediate)
     - Add a new field to a form
     - Save and display the field value
     - Add validation if needed

   - **Option C: Fix a "good first issue"** (best)
     - Check issue tracker for "good first issue" label
     - Read issue description carefully
     - Ask questions if requirements unclear
     - Implement fix following coding standards

5. **Create your first PR** (1 hour)
   - Follow [git-workflow.md](git-workflow.md) for worktree/branch process
   - Write clear commit messages
   - Create PR with description explaining WHY
   - Request review from mentor or team lead
   - Respond to feedback professionally

**By end of day, you should:**
- ✅ Understand how a feature works end-to-end
- ✅ Have created your first PR
- ✅ Understand the code review process

---

## 1-Week Path: Ownership of a Small Feature

**Goal:** Take ownership of a feature from design to deployment.

### Day 1: Deep Architecture Understanding
- Read all internal docs thoroughly
- Map out database schema
- Understand authentication/authorization flow
- Trace 2-3 different feature implementations
- Identify patterns: How are new features typically added?

### Day 2: Pick a Feature
- Work with lead to identify appropriate feature
  - Not too simple (just config change)
  - Not too complex (multi-week scope)
  - Touches 2-3 parts of system (frontend + backend + DB)
- Examples: "Add export to CSV", "Email notifications", "Dark mode toggle"

### Day 3: Design and Plan
- Write design doc or RFC (depending on team process)
- Consider:
  - Database schema changes needed?
  - New API endpoints required?
  - Frontend UI/UX changes?
  - Security implications?
  - Testing strategy?
- Get design reviewed by team before coding

### Day 4-5: Implementation
- Create feature branch following git workflow
- Implement feature following coding standards
- Write tests (unit + integration)
- Update documentation:
  - Update [apis.md](apis.md) if new endpoints
  - Update [codebase-map.md](codebase-map.md) if new files
  - Update [ui-and-copy.md](ui-and-copy.md) if new user flows
  - Update [troubleshooting.md](troubleshooting.md) with any gotchas
- Create PR with comprehensive description

**By end of week, you should:**
- ✅ Understand the full codebase architecture
- ✅ Have implemented a feature end-to-end
- ✅ Understand the team's development workflow
- ✅ Feel confident contributing independently

---

## Common Pitfalls

### Pitfall 1: Not Reading Existing Code First
**Symptom:** Implementing features in a style that doesn't match the codebase

**Solution:**
- Always grep for similar features first
- Copy the pattern, don't invent new ones
- When in doubt, ask "How do we normally do X?"

### Pitfall 2: Skipping Tests
**Symptom:** PR doesn't include tests, breaks existing functionality

**Solution:**
- Write tests alongside code, not after
- Run full test suite before creating PR (\`npm test\`)
- Ask for help if unsure how to test something

### Pitfall 3: Not Asking Questions
**Symptom:** Spending hours stuck on something simple

**Solution:**
- **15-minute rule**: If stuck for 15 min, ask for help
- Document what you've tried so far
- Ask specific questions, not "it doesn't work"
- Use team chat, don't suffer in silence

### Pitfall 4: Ignoring Security
**Symptom:** SQL injection, XSS vulnerabilities

**Solution:**
- Read [coding-standards.md](coding-standards.md) security section
- ALWAYS sanitize user input
- ALWAYS escape output
- ALWAYS verify nonces for forms/AJAX
- ALWAYS check capabilities for privileged actions

### Pitfall 5: Making Large PRs
**Symptom:** 2,000+ line PRs that are impossible to review

**Solution:**
- Break features into smaller, reviewable chunks
- Aim for PRs under 400 lines
- Use feature flags if needed to merge partial work
- Discuss chunking strategy with lead before starting

---

## Getting Help

**Quick questions:** Team Slack/Discord
**Code reviews:** GitHub/GitLab PR comments
**Pair programming:** Schedule with team lead or mentor
**Stuck for > 1 hour:** Create issue and tag mentor

---

## Success Metrics

**Week 1:** First PR merged
**Week 2:** Comfortable with codebase navigation
**Month 1:** Independently complete features without hand-holding
**Month 3:** Mentor new developers

---

## Resources

- [Internal Documentation Index](00-index.md)
- [Coding Standards](coding-standards.md)
- [Git Workflow](git-workflow.md)
- [AI Agent Guide](ai-agent-guide.md) (how to use AI effectively)
\`\`\`

### ai-agent-guide.md Template Structure
\`\`\`markdown
# AI Agent Guide

> Critical instructions for AI agents working with this codebase

## Safety Protocols

### Security Boundaries
- **NEVER commit secrets**: No API keys, passwords, tokens, credentials
- **NEVER bypass sanitization**: Always sanitize user input
- **NEVER skip escaping**: Always escape output (esc_html, esc_attr, esc_url)
- **NEVER skip nonce verification**: Always verify nonces for forms and AJAX
- **NEVER skip capability checks**: Always check current_user_can()

### Destructive Operation Warnings
- **Backup before migrations**: Always backup database before schema changes
- **PR before force-push**: NEVER force-push without explicit user approval
- **Test before delete**: Never delete files/data without verification
- **Commit before refactor**: Ensure clean working directory before major refactors

### When to Ask vs. When to Proceed

**Always ask user when:**
- Requirements are ambiguous ("make it better", "fix the issue")
- Multiple valid approaches exist (state management library choice)
- Irreversible actions planned (delete prod data, force-push main)
- Breaking changes needed (API signature changes, DB schema migration)
- Security implications exist (auth changes, permission updates)

**Proceed autonomously when:**
- Requirements are clear and specific
- Action is safe and reversible (add comment, format code)
- Following established patterns (existing code conventions)
- Low-risk changes (typo fixes, add logging)

## Tool Usage Rules

**CRITICAL: Use the correct Claude Code tools**

**File operations:**
- ✅ Use **Read** tool to read files (NOT cat, head, tail)
- ✅ Use **Write** tool to create files (NOT echo >, cat <<EOF)
- ✅ Use **Edit** tool to modify files (NOT sed, awk)

**Search operations:**
- ✅ Use **Glob** tool to find files (NOT find, ls)
- ✅ Use **Grep** tool to search content (NOT grep, rg)

**System operations:**
- ✅ Use **Bash** tool ONLY for: git, npm, composer, wp-cli, php
- ❌ NEVER use Bash for: find, grep, cat, ls, sed, awk

**Why this matters:**
- Proper tools are faster and more reliable
- Proper tools have better error handling
- Proper tools respect permissions correctly
- Improper tool usage can break the skill

## Before Making Changes

1. **Read existing code first**
   - Use Read tool on relevant files
   - Don't guess implementation details

2. **Search for patterns**
   - Use Grep to find similar implementations
   - Follow existing conventions

3. **Check recent changes**
   - Use Bash: `git log --name-only --oneline -10`
   - Understand recent development direction

4. **Verify your understanding**
   - If uncertain, use AskUserQuestion
   - Better to ask than implement incorrectly

## Core Patterns to Follow

[File naming, autoloading, class structure, REST API, settings]
[Project-specific patterns discovered during scanning]

## Security Requirements

[Sanitization patterns, escaping patterns, nonce usage, capability checks]
[Project-specific security conventions]

## Testing Requirements Before PRs

1. **Run all tests**: `npm test` or `composer test`
2. **Build production assets**: `npm run build`
3. **Check for linting errors**: `npm run lint` or `composer lint`
4. **Verify exclusions work**: Build release, check artifact
5. **Review your own changes**: Read the diff before committing

**If any tests fail:**
- Fix the failures before creating PR
- Don't commit broken code with "TODO: fix tests"
- If tests are wrong, update tests first, then implementation

## Where to Add Features

[New REST endpoint instructions]
[New admin page instructions]
[New React component instructions]
[New database table instructions]

## Common Mistakes to Avoid

**Mistake 1: Using bash instead of proper tools**
- ❌ Wrong: `bash find . -name "*.php"`
- ✅ Right: Use Glob tool with pattern `**/*.php`

**Mistake 2: Skipping sanitization**
- ❌ Wrong: `UPDATE option SET value = $_POST['value']`
- ✅ Right: `$value = sanitize_text_field($_POST['value'])`

**Mistake 3: Assuming instead of reading**
- ❌ Wrong: Guessing file locations
- ✅ Right: Use Glob/Grep to discover actual structure

**Mistake 4: Making breaking changes without asking**
- ❌ Wrong: Changing API signatures silently
- ✅ Right: Ask user about backwards compatibility strategy

[Add project-specific anti-patterns here]

## Emergency Procedures

**If you realize you made a mistake:**
1. Stop immediately
2. Assess the damage (committed? pushed?)
3. If not committed: Discard changes, start over
4. If committed: Use git revert, don't force-push
5. Inform user of the mistake and your recovery plan

**If you're blocked:**
1. Document exactly where you're stuck
2. List what you've tried
3. Ask user for guidance
4. Don't brute-force or guess

## Code Review Checklist

Before creating PR, verify:
- [ ] All changes are intentional (no accidental edits)
- [ ] No secrets or credentials committed
- [ ] All user input sanitized
- [ ] All output escaped
- [ ] Nonces verified, capabilities checked
- [ ] Tests pass
- [ ] Build succeeds
- [ ] Follows project conventions
- [ ] Commit messages are clear
- [ ] PR description explains WHY, not just WHAT
\`\`\`

### product-vision.md Template Structure
\`\`\`markdown
# Product Vision

## Product Overview
[What problem does this solve, target audience]

## User Personas
[Primary users, secondary users, use cases]

## Product Goals
[Short-term goals, long-term vision]

## Competitive Landscape
[Similar products, differentiators, positioning]

## Success Metrics
[KPIs, growth targets, quality measures]
\`\`\`

### troubleshooting.md Template Structure
\`\`\`markdown
# Troubleshooting Guide

## Common Issues

### Issue 1: [Problem Name]
**Symptoms:** [What users see]
**Cause:** [Root cause]
**Solution:** [Step-by-step fix]

### Issue 2: [Problem Name]
[Same structure]

## Debugging Techniques
[Tools, approaches, common pitfalls]

## Getting Help
[Support channels, escalation paths]
\`\`\`

### faq.md Template Structure
\`\`\`markdown
# Frequently Asked Questions

## General Questions

**Q: [Question about product/feature]**
A: [Clear, concise answer]

**Q: [Technical question]**
A: [Answer with code examples if needed]

## Development Questions
[Questions developers commonly ask]

## Deployment Questions
[Questions about releases and deployment]
\`\`\`

### glossary.md Template Structure
\`\`\`markdown
# Glossary

## Technical Terms

**Term 1**: Definition with context. Example: "Widget in this context means..."

**Term 2**: Definition with context.

## Acronyms

**API**: Application Programming Interface
**REST**: Representational State Transfer

## Project-Specific Terms

**Custom term**: Project-specific meaning different from industry standard
\`\`\`

### maintenance.md Template Structure
\`\`\`markdown
# Documentation Maintenance

## When to Update Docs
[Always update, consider updating, don't update for]

## How to Update Docs
[Manual, automation script, AI agent]

## Quarterly Review Process
[Review checklist and schedule]
\`\`\`

## Next Steps

1. Copy these template structures
2. Fill in with your project's actual information
3. Derive content from actual code (don't guess)
4. Keep docs concise but complete
5. Include code examples and file paths
6. Link between related docs
7. Update "Last updated" dates

For more detailed examples, see:
- `examples/sample-architecture.md`
- `examples/sample-codebase-map.md`
