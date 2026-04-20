# CLAUDE.md Quality Criteria

Use these criteria to score and improve `CLAUDE.md` files. A perfect score is 100/100.

## 1. Automated Workflows (25 Points)
- [ ] **Build:** Commands for building production and dev assets are present.
- [ ] **Test:** Commands for running full test suites and single tests are present.
- [ ] **Lint/Format:** Commands for checking and fixing style issues are present.
- [ ] **Deploy:** (If applicable) Commands for staging/production deployment are documented.

## 2. Technical Context & Stack (20 Points)
- [ ] **Languages:** Explicitly states primary and secondary languages (e.g., PHP 8.2, TS 5.x).
- [ ] **Frameworks:** Names specific framework versions (e.g., WordPress 6.x, React 18).
- [ ] **State of UI:** Mentions UI libraries or custom CSS solutions (Tailwind, Vanilla, etc.).

## 3. Architecture & Standards (20 Points)
- [ ] **Entry Points:** Key files for logic initialization are named.
- [ ] **Structure:** Explains the core directory hierarchy (e.g., `/src` vs `/dist`).
- [ ] **Naming:** Defines naming conventions for files/classes/functions.

## 4. Expert "Gotchas" (25 Points)
- [ ] **Environment:** Mentions specific `.env` requirements or local setup quirks.
- [ ] **Security:** Explicit "Don't" rules (e.g., "NEVER use raw SQL", "ALWAYS escape Late").
- [ ] **Production Traps:** Notes on common build failures or runtime edge cases.

## 5. Metadata & Identity (10 Points)
- [ ] **Project ID:** A unique `projectId` is present for cross-session context.
- [ ] **Clarity:** The document is concise, well-formatted, and uses standard headers.

## Scoring Scale
- **90-100:** Elite. The AI can work autonomously without clarification.
- **70-89:** Professional. Accurate but may lack edge-case coverage.
- **50-69:** At-Risk. AI might introduce regressions due to missing context.
- **<50:** Invalid. Critical documentation debt.
