---
name: expert-panel
description: >
  This skill should be used when the user asks for "expert panel", "plan this", "help me plan",
  "build new feature", "design this feature", "review before PR", "bug fix strategy",
  "help me fix this bug", "refactor this", "best approach", "should I use", "architecture decision",
  "which is better", "how should I build", "how should I fix", "expert advice", "panel mode",
  or "what's the best way to". Universal development panel — 10 world-class expert subagents
  that activate at any SDLC stage. Interviews you, scans codebase, runs a two-round debate,
  and delivers a hardened implementation blueprint, review, fix strategy, or architecture decision.
version: 4.1.0
tools: Read, Glob, Grep, Bash, Task
---

# Universal Expert Panel

A virtual team of 10 world-class experts you can call at any point in the software development life cycle. They interview you, study your codebase, deliberate on your behalf, resolve conflicts between their perspectives, and hand you a clear plan.

**The experts:**

*Panel-dedicated specialists:*
- **Pragmatic Architect** — fights complexity, identifies the simplest correct approach
- **Senior Engineer** — 20+ years of implementation craftsmanship, design patterns, and testability
- **UX Designer** — information architecture, user journeys, and first-run experience design
- **UI Designer** — visual design, design system consistency, typography, and component hierarchy
- **Security Analyst** — threat modeling, data privacy, GDPR compliance, and audit logging governance

*Standard agents that also participate:*
- **Security Auditor** (`security-auditor`) — offensive security review, exploit paths
- **WordPress Reviewer** (`wp-reviewer`) — API correctness, WPCS, ecosystem fit
- **Performance Analyzer** (`perf-analyzer`) — N+1 queries, caching, scale bottlenecks
- **UX Auditor** (`ux-auditor`) — missing states, broken flows, usability
- **Test Critic** (`test-critic`) — coverage gaps, edge cases, untestable code

| You say... | Mode | Load |
|---|---|---|
| "I want to build X" | FEATURE | `modes/feature-mode.md` |
| "Review this before PR" | REVIEW | `modes/review-mode.md` |
| "I have a bug in X" | BUG_FIX | `modes/bugfix-mode.md` |
| "I want to refactor X" | REFACTOR | `modes/refactor-mode.md` |
| "Should I use A or B?" | ARCHITECTURE | `modes/architecture-mode.md` |

---

## Phase 0: Context Detection

Read the user's message and classify:

| Signal words | Mode |
|---|---|
| "build", "create", "add", "implement", "new feature", "design" | FEATURE |
| "review", "before PR", "check this", "audit", "what did I miss" | REVIEW |
| "bug", "broken", "error", "not working", "wrong", "fix this bug" | BUG_FIX |
| "refactor", "clean up", "restructure", "simplify", "reorganize" | REFACTOR |
| "should I", "which approach", "A or B", "best way", "architecture" | ARCHITECTURE |

**If clear:** State the mode, load the corresponding `modes/*.md` file, proceed.
**If ambiguous:** Ask one question: "Is this a new feature, a bug fix, a refactoring, a code review, or an architecture decision?"

Load only the mode file you need. Do not load all five.

---

## Phase 2: Codebase Context Scan

Run these 5 scans in parallel **before** any agent deliberation (skip for REVIEW mode — it has its own scan):

**Scan 1 — Project structure:**
```
Glob: {project_root}/**/*.php (main plugin file + key class files)
Read: package.json, composer.json, main plugin file
```

**Scan 2 — Existing patterns** (adapt to mode):
- FEATURE: similar admin pages, post types, AJAX handlers
- BUG_FIX / REFACTOR: files mentioned in interview answers
- ARCHITECTURE: existing implementation of each option being compared

**Scan 3 — Data storage patterns:**
```
Grep: get_option|update_option|add_option
Grep: get_post_meta|update_post_meta
Grep: CREATE TABLE|\$wpdb->prefix
```

**Scan 4 — Security patterns in use:**
```
Grep: wp_verify_nonce|check_ajax_referer
Grep: current_user_can
Grep: sanitize_text_field|absint|sanitize_email
Grep: esc_html|esc_attr|esc_url
```

**Scan 5 — UI/UX patterns:**
```
Glob: includes/admin/views/*.php
Glob: src/components/*.jsx
Grep: add_menu_page|add_submenu_page
```

Summarize results as a compact "codebase context" block for all agents.

---

## Phase 3.5 — Round 2: The Debate

**MANDATORY PARALLEL EXECUTION.** Each expert reads all Round 1 positions, then challenges or accepts them.

Send each agent:
1. Their own Round 1 output
2. Every other participating expert's Round 1 output
3. This debate prompt:

```
ROUND 2 — THE DEBATE

You are the [Expert Name]. Read what the other experts said and engage.

[paste all Round 1 outputs — omit this expert's own section]

YOUR DEBATE TASK:

1. CHALLENGE — Push back on specific positions. Name the expert, state their position,
   explain why it is wrong or incomplete, state what should replace it.

2. ACCEPT — What from other experts do you agree with? Name the expert and why.

3. REVISE OR DEFEND — Update your Round 1 position or stand firm with direct rebuttal.

4. FINAL POSITION — Your settled recommendation after debate. Concrete, specific, no hedging.

Format:
[DEBATE ROUND 2 — EXPERT NAME]

CHALLENGE:
- [Expert]: "[position]" — wrong because: [reason] — instead: [alternative]

ACCEPT:
- [Expert]: "[position]" — correct because: [reason]

POSITION CHANGE: [Yes — revised to: X] / [No — standing firm because: Y]

FINAL POSITION: [complete settled recommendation]
```

Per-expert debate rules: see `experts/debate-rules.md`.

---

## Phase 4: Final Synthesis

Use ONLY the FINAL POSITION from each expert's Round 2 output.

1. **Map agreements** — points where multiple Final Positions now align → "Panel Unanimous"
2. **Resolve remaining conflicts** using this hierarchy:

| Conflict | Resolution |
|---|---|
| Architect vs. Security Auditor | Security Auditor wins — complexity is a justified security boundary |
| Architect vs. WordPress Reviewer | WordPress Reviewer wins if the API genuinely fits |
| Architect vs. Performance Analyzer | Performance Analyzer wins if interview confirms real scale risk |
| Any expert vs. UX Auditor (user states/flows) | UX Auditor wins |
| Two valid approaches | Present both, state recommended default and switch condition |

3. For every resolved conflict: name both experts, state each position, state which won and why.
4. Mark recommendations that evolved during debate: "(Architect revised after Performance Analyzer debate)"
5. Produce unified output using the template in the active mode file.

---

## Quality Rules (All Modes)

- Every recommendation must trace to interview answers or actual codebase content
- Every output must end with a "ready to proceed?" prompt
- Conflicts must be resolved — never "it depends" without a recommendation
- If genuinely uncertain: "we recommend X but verify Y before starting"
- Never repeat the same finding from multiple experts — synthesis combines them

## Safety Rules

- **NEVER modify files** — planning and review tool only
- **NEVER run destructive commands** — only Read, Glob, Grep, Bash for git diff
- If intent is ambiguous: ask ONE clarifying question, then proceed
- If a finding is uncertain: mark it "(to verify)" not as definitive
