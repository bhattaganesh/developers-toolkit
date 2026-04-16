---
description: Create a comprehensive, AI-executable Jira issue — user story, acceptance criteria, technical analysis, and implementation blueprint
---

# Jira Issue

Create structured, Agile-ready Jira issues using the `jira-issue-creator` skill — designed for both sprint planning and autonomous AI implementation.

## Instructions

1. **Describe the work** — Tell the skill what to create:
   - A **bug** — Describe the unexpected behavior and expected behavior
   - A **feature** — Describe the user need and desired outcome
   - A **spike** — Research question or technical investigation
   - An **improvement** — Enhancement to existing functionality
   - A **task** — Non-user-facing work item

2. **Activate the skill** — Trigger the `jira-issue-creator` skill by describing the work:
   > "Create a Jira issue for [description]"
   > "Write a ticket for [feature/bug]"
   > "File a bug for [problem description]"
   > "Backlog this: [description]"
   > "Spec out [feature] for the sprint"

3. **Review the generated issue** — The skill produces a complete Jira-ready document with:
   - **User story** — "As a [role], I want to [goal] so that [benefit]"
   - **Acceptance criteria** — Testable, unambiguous conditions for done
   - **Technical analysis** — Architecture impact, affected files, risk assessment
   - **Test strategy** — Unit, integration, E2E test scenarios with boundary conditions
   - **Implementation blueprint** — File-level guidance, step-by-step approach
   - **Claude CLI prompt** — Structured section enabling AI-autonomous implementation
   - **Story point guidance** — Complexity estimate with rationale

4. **Copy to Jira** — Paste the generated content into your Jira project.

## Dual-Audience Design

Every issue this skill creates serves two audiences:
- **Dev team** — Clean Agile artifacts for sprint planning and estimation
- **AI agents** — Machine-readable specification for autonomous implementation via Claude CLI

The implementation blueprint section includes exact file paths, validation commands, and done-verification steps that allow an AI agent to pick up the ticket and execute it end-to-end.

## Issue Types Supported

- **Story** — User-facing feature with acceptance criteria
- **Bug** — Defect with steps to reproduce, expected vs actual
- **Spike** — Time-boxed research with specific questions to answer
- **Task** — Non-user-facing technical work
- **Improvement** — Enhancement to existing functionality

## Dependencies

This command activates the **jira-issue-creator** skill bundled with the developers plugin.
