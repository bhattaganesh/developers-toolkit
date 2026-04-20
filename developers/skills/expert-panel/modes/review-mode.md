# Expert Panel — REVIEW Mode

Use this file when mode = REVIEW (pre-PR code review).

---

## Phase 1: Auto-detect scope (no interview)

```bash
git diff main...HEAD --name-only 2>/dev/null || \
git diff origin/main...HEAD --name-only 2>/dev/null || \
git diff HEAD~1 --name-only 2>/dev/null
```

Present the file list to the user for confirmation. Proceed immediately — no questions.

---

## Phase 3: Agent Selection & Prompts

**Always include all 10 experts for REVIEW mode.**

**Prompt template:**

```
MODE: CODE REVIEW — review changed files before this PR is merged.

Files changed: [list from git diff]
Project root:  [current directory]
Stack:         [detected stack]

Apply your specialized lens. Find what the developer may have missed.
Use your standard review output format:
  Severity | What | Why | Where (file:line) | How to fix
```

---

## Phase 5: Review Output Template

```
╔══════════════════════════════════════════════════════════════════╗
║              EXPERT PANEL — CODE REVIEW                          ║
╠══════════════════════════════════════════════════════════════════╣
║  Files reviewed: [N]                                             ║
║  Findings: [X total — Y critical, Z high, W medium, V low]       ║
╠══════════════════════════════════════════════════════════════════╣
║  VERDICT: [HOLD] / [APPROVE WITH N CHANGES] / [APPROVE]         ║
╚══════════════════════════════════════════════════════════════════╝

━━━ CRITICAL — Fix Before Merge ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[C1] [Title]
  Found by: [Expert]
  What:     [description]
  Why:      [impact]
  Where:    [file:line]
  How:      [exact fix]

━━━ HIGH — Should Fix Before Merge ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[H1] ...

━━━ MEDIUM — Fix in Follow-up ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[M1] ...

━━━ DEBATE OUTCOME ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Survived debate unchallenged: [count] — certain
Revised after debate:         [count] — [brief note]
Dropped as false positives:   [count]

Good work: [what the panel unanimously acknowledged]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Address critical/high items, then say "done" to re-review.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
