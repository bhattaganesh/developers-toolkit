---
name: jira-issue-creator
description: >
  Creates comprehensive, AI-executable Jira issues following Agile/Scrum methodology.
  Each issue is designed to serve two audiences: (1) the dev team for sprint planning,
  and (2) Claude CLI / Claude Code for autonomous implementation. Generates user stories
  with acceptance criteria, technical analysis, test strategies, boundary conditions,
  implementation blueprints with file-level guidance, and a structured Claude CLI prompt
  section that enables an AI agent to pick up the ticket and execute it end-to-end.
  
  Use this skill whenever the user says "create a Jira issue", "create a Jira task",
  "create a Jira ticket", "file a bug", "log a ticket", "create a story", "create a spike",
  "make an improvement ticket", "backlog this", "write a ticket for...", or anything
  related to creating structured work items. Also trigger when the user describes a bug,
  feature, or improvement and wants it tracked, or says "analyze this for a ticket",
  "turn this into a Jira issue", or "spec this out". Even if the user just says
  "ticket for X" or "issue for X" — use this skill.
---

# Jira Issue Creator

Create Agile-ready, AI-executable Jira issues. Every issue this skill produces is designed
to be **both a human-readable Agile work item AND a machine-readable specification** that
Claude CLI or Claude Code can pick up and implement autonomously.

The dual-audience principle drives every section: sprint planning teams get clean Agile
artifacts (user stories, acceptance criteria, story points guidance), while AI agents get
structured implementation blueprints, file paths, validation commands, and done-verification
steps.

---

## Workflow Overview

```
1. Gather Context        → Understand the problem from user, Slack, files, conversation
2. Classify & Scope      → Issue type, Agile metadata, story points estimation
3. Write Agile Artifacts → User story, acceptance criteria, definition of done
4. Deep Technical Analysis → Test strategy, boundaries, implementation blueprint
5. Generate Claude CLI Section → AI-executable specification
6. Assemble & Output     → Markdown file ready for Jira + Claude CLI
```

---

## Step 1: Gather Context

Extract as much as possible from what the user already said. Don't interrogate — ask at most
2-3 clarifying questions, and only for truly missing critical info.

### What to extract (from conversation, Slack, files, etc.)

**Always needed:**
- What is the problem or need? (one-line summary)
- What type of work? (Bug / Story / Improvement / Task / Spike)
- Which part of the system? (service, module, component, repo)

**Extract if available (don't block on these):**
- Priority and severity
- Affected users / blast radius
- Environment details (prod/staging, browser, OS, API version)
- Steps to reproduce (for bugs)
- Related tickets or PRs
- Sprint, epic, or project key
- Tech stack / framework in use
- Repository URL or name

### Context sources to check

- **Current conversation** — primary source; re-read the user's messages carefully
- **Slack** — if user references a thread, use `slack_search_public`, `slack_read_thread`, `slack_read_channel` to extract full context
- **Uploaded files** — check `/mnt/user-data/uploads/` for logs, screenshots, stack traces, design docs
- **Web/browser** — if user shares a URL, fetch or browse it for context
- **Past conversations** — use `conversation_search` if user references prior discussions

### Handling ambiguity

When information is missing, don't block. Instead:
1. Make reasonable inferences and tag them with `⚠️ Assumption:` so the team can verify
2. Add an **Open Questions** section at the bottom for decisions the team needs to make
3. Use sensible defaults (Medium priority, current sprint, etc.)

---

## Step 2: Classify & Scope

### Issue types and their Agile framing

**🐛 Bug** — Defect in existing functionality
- Agile artifact: Bug report with reproduction steps
- Story points: Based on investigation + fix complexity
- Sprint fit: Usually current sprint if P1/P2

**📖 Story (Feature)** — New user-facing capability
- Agile artifact: User story with acceptance criteria
- Story points: Based on implementation + testing effort
- Sprint fit: Backlog → sprint planning
- Consider: Does this need to be broken into sub-tasks?

**🔧 Improvement** — Enhancement to existing functionality
- Agile artifact: Improvement proposal with before/after
- Story points: Based on refactor scope + regression risk
- Sprint fit: Backlog or tech debt sprint

**📋 Task** — Technical or operational work (not user-facing)
- Agile artifact: Task with checklist
- Story points: Based on effort
- Sprint fit: Current sprint or next

**🔍 Spike** — Research / investigation / POC
- Agile artifact: Time-boxed investigation with specific questions to answer
- Story points: Time-box (e.g., 3 points = 1 day)
- Sprint fit: Current sprint
- Output: Findings doc, not code

### Story Points Guidance

Provide a story points estimate using this scale:

| Points | Complexity | Typical Work |
|--------|-----------|--------------|
| 1 | Trivial | Config change, copy update, one-line fix |
| 2 | Small | Single-file change, well-understood fix |
| 3 | Medium | Multi-file change, some investigation needed |
| 5 | Large | Cross-module change, new component, integration work |
| 8 | Very Large | Architectural change, multi-service, needs design |
| 13 | Epic-sized | Consider breaking into smaller stories |

Always explain the reasoning behind the estimate so the team can adjust during planning poker.

---

## Step 3: Write Agile Artifacts

### User Story (for Stories/Features)

Use the standard format with clear role, action, and value:

```
As a [specific role/persona],
I want [specific capability],
So that [measurable benefit/outcome].
```

Bad: "As a user, I want dark mode, so that it looks better."
Good: "As a user who works late hours, I want a dark mode toggle on the dashboard, so that I can reduce eye strain and work comfortably in low-light environments."

### Acceptance Criteria (EVERY issue type gets these)

Write acceptance criteria using the **Given/When/Then** (Gherkin) format. These serve double
duty: the QA team uses them for testing, and Claude CLI uses them for validation.

```
AC-1: [Title]
  Given [precondition/context]
  When [action/trigger]
  Then [expected observable outcome]
  And [additional outcomes if any]
```

Rules for good acceptance criteria:
- Each criterion is independently testable
- Use specific, measurable outcomes (not "it should work well")
- Cover the happy path AND key failure modes
- Include performance criteria where relevant (e.g., "within 200ms")
- Include accessibility criteria for UI changes
- Write **6–12 acceptance criteria** per issue
- Number them AC-1, AC-2, etc. — these will be referenced by test cases

### Definition of Done (standard checklist)

Every issue gets a DoD checklist. Start with these defaults and add issue-specific items:

```
Definition of Done:
- [ ] All acceptance criteria met and verified
- [ ] Code reviewed and approved (min 1 reviewer)
- [ ] Unit tests written and passing (≥80% coverage on changed code)
- [ ] Integration tests passing
- [ ] No new lint/type errors introduced
- [ ] Documentation updated (API docs, README, inline comments)
- [ ] Tested in staging environment
- [ ] No regressions in existing test suite
- [ ] PR linked to this Jira issue
```

Add issue-specific items like:
- [ ] Database migration tested (rollback verified)
- [ ] Feature flag configured for gradual rollout
- [ ] Performance benchmark meets target (<200ms p95)
- [ ] Accessibility audit passed (WCAG 2.1 AA)
- [ ] Security review completed
- [ ] Monitoring/alerting configured
- [ ] Backward compatibility verified
- [ ] API versioning handled

---

## Step 4: Deep Technical Analysis

This is where the issue becomes implementation-ready, for both humans and Claude CLI.

### 4A: Implementation Blueprint

This section tells a developer (or Claude CLI) exactly where to make changes and how.

#### For Stories/Features:

```
COMPONENT: {Name of module/service/component}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Repository: {repo name or URL}
  
  Files to CREATE:
    - {path/to/new/file.ts} → {Purpose: what this file does}
    - {path/to/new/file.test.ts} → {Test file for above}
  
  Files to MODIFY:
    - {path/to/existing/file.ts}
      → Change: {What to change and why}
      → Function/Method: {Specific function to modify}
      → Lines (approx): {Line range if known}
    
  Configuration Changes:
    - {config file} → {What to add/change}
    - {env variable} → {New env var needed}
  
  Database Changes:
    - {Migration description}
    - {Schema change: add column X to table Y}
    - {Seed data needed?}
  
  API Changes:
    - {New endpoint: POST /api/v2/resource}
    - {Modified endpoint: add query param to GET /api/v1/resource}
    - {Request/response schema changes}
  
  Dependencies:
    - {Internal: depends on auth-service for token validation}
    - {External: needs new npm package "xyz" for ...}
    - {Blocked by: PROJ-456 must merge first}
```

#### For Bugs:

```
ROOT CAUSE ANALYSIS:
━━━━━━━━━━━━━━━━━━━
  Hypothesis: {What is likely causing this}
  Evidence: {Stack trace, logs, behavior patterns}
  
  Suspected Location:
    - File: {path/to/file.ts}
    - Function: {functionName()}
    - Line range: {~L120-L145}
    - Reason: {Why this location is suspected}
  
  Fix Approach:
    - {Step 1 of the fix}
    - {Step 2 of the fix}
  
  Side Effects to Watch:
    - {Other code paths that call this function}
    - {Downstream services that depend on this behavior}
    - {Data that may be in a bad state and needs cleanup}
  
  Regression Check:
    - {Did this work before? When did it break?}
    - {Related commits or deploys to investigate}
```

#### For Improvements:

```
CURRENT STATE:
━━━━━━━━━━━━━
  How it works now: {Description}
  Location: {Files and functions involved}
  Limitations: {Why this needs improvement}
  Performance baseline: {Current metrics if applicable}

PROPOSED STATE:
━━━━━━━━━━━━━━
  How it should work: {Description}
  Changes required: {High-level approach}
  Migration path: {Steps to get from current → proposed}
  Rollback plan: {How to revert safely}
  
  Backward Compatibility:
    - API: {Breaking changes? Versioning strategy?}
    - Data: {Schema migration? Data backfill?}
    - Config: {New env vars? Feature flags?}
```

### 4B: Test Strategy

Go beyond listing test cases. Provide a test strategy that maps to acceptance criteria.

#### Test Case Format:

```
TC-{NUM} [{Type}] {Title}
  Maps to: AC-{N}
  Priority: {Critical / High / Medium / Low}
  Preconditions:
    - {Setup requirement}
  Steps:
    1. {Action step}
    2. {Action step}
  Input Data: {Specific test data to use}
  Expected Result: {Observable outcome}
  Automated: {Yes - unit/integration/e2e | No - manual only}
  Validation Command: {CLI command or test file to run}
```

#### Categories to cover (generate 10–18 test cases):

1. **Happy Path** (3-4 tests) — Standard successful flows, one per AC
2. **Negative / Error Handling** (2-3 tests) — Invalid inputs, auth failures, network errors
3. **Boundary / Edge Cases** (2-3 tests) — Limits, empty states, overflow
4. **Integration** (1-2 tests) — Cross-service, cross-module interactions
5. **Regression** (1-2 tests) — Ensure existing behavior is preserved
6. **Performance** (1 test, if relevant) — Response time, throughput targets
7. **Security** (1 test, if relevant) — Auth, injection, data exposure
8. **Accessibility** (1 test, if UI) — Keyboard nav, screen reader, contrast

#### Test Data Specifications:

For each test, specify exact test data so Claude CLI or a developer can run it immediately:

```
Test Data Set:
  Valid inputs:
    - {field}: {exact value} — {why this value}
  Invalid inputs:
    - {field}: {exact value} — {what error this should trigger}
  Boundary inputs:
    - {field}: {exact value} — {which boundary this tests}
```

### 4C: Boundary Conditions

Document every boundary that could cause issues. This is critical for Claude CLI to handle
edge cases during implementation.

```
BC-{NUM}: {Title}
  Boundary: {The exact condition}
  Test With: {Specific value to test}
  Expected: {What should happen}
  Risk: {What breaks if this is mishandled}
  Mitigation: {How to handle it in code}
```

Categories to think through:
- **Input**: max/min lengths, special chars, Unicode (emoji, RTL, CJK), null/undefined/empty, whitespace-only, SQL/XSS payloads
- **Numeric**: 0, -1, MAX_SAFE_INTEGER, floating point precision (0.1 + 0.2), NaN, Infinity
- **Date/Time**: timezone boundaries (UTC±12), DST transitions, leap seconds, far future/past, epoch
- **State**: empty collection, single item, max capacity, first/last item, concurrent modifications
- **Auth/Permission**: expired token, revoked role, mid-session role change, rate limit hit
- **System**: disk full, memory pressure, network timeout, partial response, connection reset

Generate **6–10 boundary conditions** per issue.

### 4D: Risk Assessment

| # | Risk | Likelihood | Impact | Mitigation | Owner |
|---|------|-----------|--------|------------|-------|
| R1 | {Description} | H/M/L | H/M/L | {How to prevent/handle} | {Team/person} |

Include at least:
- **Regression risk** — could this break existing functionality?
- **Data integrity risk** — could this corrupt or lose data?
- **Performance risk** — could this degrade response times?
- **Security risk** — does this change the attack surface?
- **Rollback risk** — can we revert safely if something goes wrong?

---

## Step 5: Generate Claude CLI Section

**This is the most critical section.** It transforms the Jira issue into an executable
specification that Claude CLI / Claude Code can use to autonomously implement the work.

When a developer copies this ticket into Claude CLI and says "implement this", the AI agent
should be able to work through it step by step — read the right files, implement changes,
run tests, verify ACs, and produce a ready-to-review PR — all without asking follow-up questions.

**Before writing this section, read the full structure in:**
```
Read references/templates-and-examples.md → Section 2: Claude CLI Section
```

### Required sub-sections (always include all of these):

1. **Context for AI Agent** — 2-3 sentence briefing (what, why, expected outcome)
2. **Codebase Orientation** — Numbered list of files to read FIRST, with reasons
3. **Implementation Steps** — Ordered, atomic steps. Each step has: What, Where (file path + function), How (approach), Pattern to follow (link to similar existing code), Watch out for (pitfalls), Verify (quick check command)
4. **Validation Checklist** — Exact bash commands for: tests, lint, typecheck, build, specific verification. ALL must pass.
5. **Acceptance Criteria Verification** — Table mapping each AC to a concrete command/check the agent can execute
6. **Done Signal** — Clear exit criteria (all commands pass, all ACs verified, coverage target met, no new warnings)
7. **Commit Message** — Conventional commit format pre-filled with type, scope, body
8. **PR Description** — Template pre-filled with What/Why/How/Testing/Rollback sections

### Key principles for this section:

- Write it as if the AI agent has **zero context** beyond this document and the codebase
- Every instruction should be **copy-pasteable** — exact file paths, exact commands
- Reference **existing patterns** in the codebase so the agent follows conventions
- Include **verification after each step**, not just at the end
- The "Done Signal" is the agent's exit condition — make it unambiguous

---

## Step 6: Assemble & Output

### Read the template before assembling

**Before generating the final document, read the full template and examples:**
```
Read references/templates-and-examples.md
```

This reference file contains:
- The exact Markdown template to use for the final document (section by section)
- The full Claude CLI section structure with all sub-sections
- Three worked examples (Bug, Story, Improvement) showing what good output looks like
- Commit message and PR description templates

### Document sections (in order)

1. Title with type prefix + Quick Summary bar
2. 📋 Issue Details table
3. 📖 User Story / Description (with current/expected behavior, repro steps for bugs)
4. ✅ Acceptance Criteria (all ACs in Given/When/Then)
5. ✅ Definition of Done (checkbox checklist)
6. 🏗️ Implementation Blueprint (from Step 4A)
7. 🧪 Test Strategy — Test Cases + Boundary Conditions + Test Data (from Steps 4B, 4C)
8. ⚠️ Risk Assessment (from Step 4D)
9. 🤖 Claude CLI Implementation Guide (from Step 5)
10. 🔗 Dependencies & Related Issues
11. ❓ Open Questions
12. 📝 Notes & References

### File Naming

- `JIRA-BUG-{short-slug}.md`
- `JIRA-STORY-{short-slug}.md`
- `JIRA-IMPROVEMENT-{short-slug}.md`
- `JIRA-TASK-{short-slug}.md`
- `JIRA-SPIKE-{short-slug}.md`

If the user provides a project key (e.g., "PROJ-"), prefix: `PROJ-STORY-dark-mode.md`

### Output Steps

1. Save to `/mnt/user-data/outputs/`
2. Present with `present_files` tool
3. Offer next steps:
   - "Want me to adjust story points, add more test cases, or modify any section?"
   - "This is ready to paste into Jira — it supports Markdown rendering."
   - "Want me to create a Slack summary to share with the team?"
   - "Should I break this into sub-tasks for the sprint?"
   - "Want me to send a summary to a Slack channel for team review?"

---

## Quality Checklist

Before presenting the output, verify:

- [ ] **User story** is in proper As a/I want/So that format (for Stories)
- [ ] **≥6 acceptance criteria** in Given/When/Then format
- [ ] **Definition of Done** checklist is present and complete
- [ ] **≥10 test cases** covering happy path, negative, edge, integration, regression
- [ ] **≥6 boundary conditions** relevant to the specific issue
- [ ] **Implementation blueprint** has specific file paths and function names
- [ ] **Risk assessment** has ≥3 identified risks
- [ ] **Story points estimate** with reasoning
- [ ] **Claude CLI section** is complete with:
  - [ ] Codebase orientation (files to read first)
  - [ ] Step-by-step implementation instructions
  - [ ] Validation commands (test, lint, typecheck)
  - [ ] AC verification mapping
  - [ ] Done signal (clear exit criteria)
  - [ ] Commit message and PR template
- [ ] All assumptions are tagged with ⚠️
- [ ] Open questions section exists (even if empty)

---

## Adapting to User Context

**Minimal info provided** — Generate best possible ticket. Mark gaps with ⚠️ Assumption.
A ticket with assumptions is better than no ticket.

**Quick/lightweight ticket requested** — Minimum viable: user story, 4+ ACs, DoD, basic
implementation guidance, and a slim Claude CLI section. These are non-negotiable.

**Codebase is accessible** — Read key files to make the blueprint hyper-specific: exact line
numbers, existing patterns to follow, test framework in use, linter config, etc.

**Sub-tasks requested** — Break the story into sub-tasks, each with its own mini-AC and
implementation steps. Parent story keeps the full test strategy and Claude CLI guide.

**Specific tech stack mentioned** — Adapt test commands (jest/pytest/go test), file
extensions, framework patterns, database syntax, etc.

**Sprint planning context** — Emphasize story points reasoning, blocking dependencies,
and whether the story needs decomposition to fit in one sprint.

**User wants to discuss first** — Walk through the analysis conversationally. Generate
the document only when the user says to proceed.
