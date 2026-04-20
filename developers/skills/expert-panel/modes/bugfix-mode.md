# Expert Panel — BUG_FIX Mode

Use this file when mode = BUG_FIX.

---

## Phase 1: Bug Fix Interview

```
Expert Panel — Bug Fix Interview
==================================
Tell the panel about the bug so they can recommend the right fix strategy.

1. What is the bug? What happens vs. what should happen?

2. When does it occur?
   (a) Always, every time
   (b) Only under specific conditions — describe them
   (c) Intermittently / random

3. Who is affected?
   (a) All users
   (b) Specific roles — which?
   (c) Only when specific data exists

4. What is the business impact?
   (a) Blocking — users cannot complete a core task
   (b) Significant — degraded experience for many users
   (c) Minor — rare edge case, workaround exists

5. Error message, log entry, or console output? Paste it.

6. Have you tried anything? What happened?
```

---

## Phase 3: Agent Selection & Prompts

**Always include:** Architect, Security Auditor, Senior Engineer, Test Critic
**Include if relevant:** Performance Analyzer (perf bugs), WordPress Reviewer (WP API bugs), UX Auditor (UX bugs)

**Prompt template:**

```
MODE: BUG FIX — diagnose and recommend a fix strategy, NOT reviewing for style.

Bug: [Q1]  |  When: [Q2]  |  Affected: [Q3]
Impact: [Q4]  |  Error output: [Q5]  |  Attempted: [Q6]

Codebase context:
[compact summary from Phase 2 — focused on the bug area]

As [Expert Name]:
1. What is the likely root cause from your lens?
2. What is the recommended fix approach?
3. What must be tested after the fix?
4. How do we prevent this class of bug recurring?

Format:
[BUG — EXPERT NAME]
Root cause:       [your diagnosis]
Recommended fix:  [specific approach]
Must test:        [verification steps]
Prevention:       [pattern to adopt or test to add]
```

---

## Phase 5: Bug Fix Output Template

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — BUG FIX STRATEGY                        ║
╠══════════════════════════════════════════════════════════════════╣
║  Bug:    [one-line description]                                   ║
║  Impact: [Blocking / Significant / Minor]                         ║
║  Panel:  [experts who participated]                               ║
╚══════════════════════════════════════════════════════════════════╝

━━━ ROOT CAUSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Why the bug happens — underlying cause, not just symptoms]
Likely location: [file:line if determinable]

━━━ RECOMMENDED FIX ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Fix approach]
Files to change:
  - [file] — [what changes]
What NOT to do:
  - [common wrong approach and why]

━━━ VERIFICATION CHECKLIST ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ [Original bug no longer reproduces]
□ [Related functionality still works]
□ [Edge case verified]

━━━ PREVENTION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- [Pattern to adopt]
- [Test to add]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to fix? Say "yes" and I will implement.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
