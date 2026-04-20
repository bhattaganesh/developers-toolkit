---
name: claude-md-improver
description: >
  Elite synchronization skill for CLAUDE.md files. Performs a deep-codebase audit, 
  scoring documentation against an expert rubric, and resolving gaps.
version: 1.1.0
tools: Glob, Read, Grep, Bash, Task
---

# CLAUDE.md Improver (Expert Workflow)

This skill follows the official Anthropic "Management" patterns to ensure `CLAUDE.md` is an accurate, high-performance bridge between the developer and the AI.

## Workflow Phases

### Phase 1: Deep Discovery
1.  **File Scan:** Find all `CLAUDE.md` files (root and sub-packages).
2.  **Asset Audit:** Identify `package.json`, `composer.json`, `tsconfig.json`, `Makefile`, and `docker-compose.yml`.
3.  **Command Extraction:** Parse scripts from manifest files (e.g., `npm scripts`).

### Phase 2: Quality Audit (The 100-Point Audit)
Evaluate the existing `CLAUDE.md` using the [Quality Criteria](./references/quality-criteria.md).
- **Goal:** Identify the delta between the "Actual Codebase" and "Documented State."
- **Output:** Generate a summary report with the current score and a list of specific documentation debt items.

### Phase 3: Expert Synthesis
For each identified gap, use the [Update Guidelines](./references/update-guidelines.md) to generate fixes.
- **Commands:** Sync missing `build`, `test`, `lint`, and `profile` commands.
- **Identity:** Verify or generate a consistent `projectId`.
- **Expertise:** Inject security "Gotchas" and architecture clarifications specific to the detected framework (WP/React).

### Phase 4: Resolution (The Improvement)
1.  **Diff Generation:** Propose the updated `CLAUDE.md` content.
2.  **Context Refresh:** After modification, the AI agent should "read" the new `CLAUDE.md` to refresh its own working memory.

## Guidelines for Improvement
- **Brevity is King:** Don't bloat the file. Keep instructions atomic.
- **Explicit over Implicit:** Document commands exactly as they need to be run (e.g., `npx jest --watch` not just `jest`).
- **Standard Header Hierarchy:**
    1. Metadata (Internal)
    2. Project Overview
    3. Tech Stack
    4. Build/Test/Lint Workflows
    5. Standards/Gotchas
