# Expert Panel — REFACTOR Mode

Use this file when mode = REFACTOR.

---

## Phase 1: Refactoring Interview

```
Expert Panel — Refactoring Interview
======================================
Help the panel understand what you're refactoring and why.

1. What code are you refactoring? (File name, class, or area)

2. Why does it need refactoring?
   (too complex / duplicate logic / too slow / hard to test / bad naming / wrong architecture)

3. What is the desired end state? What should it look like after?

4. Are there tests covering this code?
   (Yes — unit/integration / No / Partial)

5. How many places call or depend on this code?
   (isolated / used in a few places / used everywhere)

6. Hard constraints?
   (must not change public API / must stay backward-compatible / must fit in one PR)
```

---

## Phase 3: Agent Selection & Prompts

**Always include:** Architect, WordPress Reviewer, Senior Engineer, Test Critic
**Include if relevant:** Performance Analyzer, Security Auditor

**Prompt template:**

```
MODE: REFACTORING — designing a refactoring strategy, NOT adding new features.

What: [Q1]  |  Why: [Q2]  |  Target: [Q3]
Tests: [Q4]  |  Dependencies: [Q5]  |  Constraints: [Q6]

Codebase context:
[compact summary from Phase 2 — the code being refactored]

As [Expert Name]:
1. Do you agree with the refactoring goal? If not, why?
2. What approach do you recommend?
3. What is the risk, and how do we manage it?
4. What order should the changes happen?

Format:
[REFACTOR — EXPERT NAME]
Agrees with goal:     [Yes / Partially — because... / No — because...]
Recommended approach: [strategy]
Risk assessment:      [what could break and how to mitigate]
Order:                [recommended sequence]
```

---

## Phase 5: Refactoring Output Template

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — REFACTORING PLAN                        ║
╠══════════════════════════════════════════════════════════════════╣
║  Target: [what's being refactored]                               ║
║  Goal:   [why — one line]                                        ║
║  Risk:   [Low / Medium / High]                                   ║
╚══════════════════════════════════════════════════════════════════╝

━━━ PANEL VERDICT ON THE GOAL ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Do experts agree this is worthwhile? Any pushback?]

━━━ RECOMMENDED APPROACH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Strategy — e.g., "Extract service class in 3 phases"]

━━━ PHASES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1 — [Name]: [what changes — can be reviewed independently]
Phase 2 — [Name]: [what changes — depends on Phase 1]
Phase 3 — [Name]: [final cleanup]

━━━ RISK MITIGATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ [Check before starting]
□ [Backward compatibility concern]
□ [Verify after each phase]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to start? Say "yes" and I will begin Phase 1.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
