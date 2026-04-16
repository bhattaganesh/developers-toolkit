---
name: expert-panel
description: >
  Universal development panel — 10 world-class expert subagents that activate at any SDLC stage.
  Auto-detects context (new feature, code review, bug fix, refactoring, architecture decision).
  Interviews you with targeted questions, scans the existing codebase for context, then runs a
  two-round debate: Round 1 each expert forms their independent position, Round 2 they read each
  other's positions and challenge, accept, or revise — producing hardened final positions.
  Synthesis works only from post-debate positions, marking what was unanimous, what was debated
  and resolved, and what changed during the debate. Delivers an output tailored to what you need:
  implementation blueprint, findings report, fix strategy, refactoring plan, or architecture
  recommendation — always ending with "Plan is ready. Say yes to start implementing."
  Triggers on: "expert panel", "panel", "plan this", "help me plan", "build new feature",
  "design this feature", "review before PR", "review this", "bug fix strategy",
  "help me fix this bug", "refactor this", "best approach", "should I use", "architecture decision",
  "which is better", "how should I build", "how should I fix", "expert advice",
  "get panel", "call the panel", "panel mode", "what's the best way to".
version: 4.0.0
tools: Read, Glob, Grep, Bash, Task
---

# Universal Expert Panel

A virtual team of 10 world-class experts you can call at any point in the software development life cycle. They interview you, study your codebase, deliberate on your behalf, resolve conflicts between their perspectives, and hand you a clear plan.

**The experts:**

*Panel-dedicated specialists (no standalone equivalent):*
- **Pragmatic Architect** — fights complexity, identifies the simplest correct approach
- **Senior Engineer** — 20+ years of implementation craftsmanship, design patterns, and testability
- **UX Designer** — information architecture, user journeys, and first-run experience design
- **UI Designer** — visual design, design system consistency, typography, and component hierarchy
- **Security Analyst** — threat modeling, data privacy, GDPR compliance, and audit logging governance

*Standard agents that also participate in the panel:*
- **Security Auditor** (`security-auditor`) — thinks like an attacker, finds vulnerabilities from day one
- **WordPress Reviewer** (`wp-reviewer`) — knows every WordPress API, ensures code fits the ecosystem
- **Performance Analyzer** (`perf-analyzer`) — designs for production reality, prevents bottlenecks
- **UX Auditor** (`ux-auditor`) — represents the end user, catches missing states and broken flows
- **Test Critic** (`test-critic`) — finds edge cases, coverage gaps, and acceptance criteria problems

**What they adapt to:**

| You say... | Panel mode | Output |
|---|---|---|
| "I want to build X" | Feature Design | Implementation blueprint + plan |
| "Review this before PR" | Code Review | Findings report + verdict |
| "I have a bug in X" | Bug Fix Strategy | Root cause + fix plan |
| "I want to refactor X" | Refactoring | Refactoring strategy + phased plan |
| "Should I use A or B?" | Architecture Decision | Decision document + recommendation |

---

## Phase 0: Context Detection

**Goal:** Understand what kind of help is needed before doing anything else.

Read the user's message and classify the intent:

| Signal words | Context | Mode |
|---|---|---|
| "build", "create", "add", "implement", "new feature", "design" | New feature | FEATURE |
| "review", "before PR", "check this", "audit", "what did I miss" | Pre-PR review | REVIEW |
| "bug", "broken", "error", "not working", "wrong", "fix this bug" | Bug fix | BUG_FIX |
| "refactor", "clean up", "restructure", "simplify", "reorganize" | Refactoring | REFACTOR |
| "should I", "which approach", "A or B", "best way", "architecture" | Architecture | ARCHITECTURE |

**If the context is clear:** State it and proceed to Phase 1.
**If ambiguous:** Ask one question: "Is this a new feature, a bug fix, a refactoring, a code review, or an architecture decision?"

Do not ask more than this. Context detection should be fast.

---

## Phase 1: The Interview

**Goal:** Gather everything the experts need to deliberate effectively. One structured interview — all questions at once — the user answers once.

Present the interview as a numbered list. User answers all questions in one reply.

### FEATURE Interview (7 questions max)

```
Expert Panel — Feature Interview
==================================
Before the experts deliberate, I need to understand the feature.
Please answer all of these:

1. What are you building? Describe it in 2-3 sentences. What problem does it solve?

2. Who will use it?
   (a) End users on the front-end
   (b) Site admins in the WordPress admin
   (c) Both
   (d) Other: ___

3. Where does it live?
   (a) New admin page
   (b) Added to an existing page/section
   (c) Front-end widget or shortcode or block
   (d) Background process (no visible UI)
   (e) REST API endpoint only

4. Does it need to store data? If yes — what kind?
   (user preferences / per-post data / site-wide settings / custom records / logs)

5. Roughly how many users or records will this involve at steady state?
   (e.g., "10 admins", "all site users ~5,000", "one record per order")

6. Does this integrate with anything that already exists?
   (describe any existing plugin code, admin pages, post types, APIs, or third-party services)

7. What does success look like from the user's perspective?
   (what does the user do, what do they see, what can they now accomplish?)
```

### BUG_FIX Interview (6 questions)

```
Expert Panel — Bug Fix Interview
==================================
Tell the panel about the bug so they can recommend the right fix strategy.

1. What is the bug? Describe what happens vs. what should happen.

2. When does it occur?
   (a) Always, every time
   (b) Only under specific conditions — describe them
   (c) Intermittently / random

3. Who is affected?
   (a) All users
   (b) Specific roles only — which ones?
   (c) Only when specific data exists

4. What is the business impact?
   (a) Blocking — users cannot complete a core task
   (b) Significant — degraded experience for many users
   (c) Minor — rare edge case, workaround exists

5. Is there an error message, log entry, or console output? Paste it if so.

6. Have you tried anything to fix it? What happened?
```

### REFACTOR Interview (6 questions)

```
Expert Panel — Refactoring Interview
======================================
Help the panel understand what you're refactoring and why.

1. What code are you refactoring? (File name, class, or describe the area)

2. Why does it need refactoring? What's wrong with it?
   (too complex / duplicate logic / too slow / hard to test / bad naming / wrong architecture)

3. What is the desired end state? What should it look like after?

4. Are there tests covering this code? (Yes — unit/integration / No / Partial)

5. How many places call or depend on this code?
   (isolated / used in a few places / used everywhere)

6. Are there any hard constraints?
   (must not change the public API / must remain backward-compatible / must stay in one PR)
```

### REVIEW Interview (0 questions — auto-detect)

Skip interview. Detect scope via `git diff`:
```bash
git diff main...HEAD --name-only 2>/dev/null || git diff origin/main...HEAD --name-only 2>/dev/null || git diff HEAD~1 --name-only 2>/dev/null
```
Present the file list to the user for confirmation. Proceed immediately.

### ARCHITECTURE Interview (5 questions)

```
Expert Panel — Architecture Interview
=======================================
Help the panel understand the decision.

1. What decision do you need to make? (one sentence)

2. What options are you considering? (list them)

3. What constraints apply?
   (performance requirements / team skill set / timeline / must integrate with X / backward compatibility)

4. What is the expected scale?
   (users, requests per second, data volume — rough estimates are fine)

5. Have you already tried or ruled anything out? Why?
```

---

## Phase 2: Codebase Context Scan

**Goal:** Before the experts deliberate, they need to understand the existing codebase. Run this for ALL modes except REVIEW (which has its own code-reading phase).

**Run these 5 scans in parallel:**

**Scan 1 — Project structure:**
```
Glob: {project_root}/**/*.php (limit to main plugin file and key class files)
Read: {project_root}/package.json
Read: {project_root}/composer.json
Read: main plugin file (grep for "Plugin Name:")
```

**Scan 2 — Existing patterns similar to what's being built/fixed:**
- For FEATURE: Glob for similar feature files (similar admin pages, similar post type registrations, similar AJAX handlers)
- For BUG_FIX: Read the files mentioned in the bug description
- For REFACTOR: Read the files being refactored
- For ARCHITECTURE: Read the existing implementation of each option being considered

**Scan 3 — Data storage patterns:**
```
Grep: "get_option|update_option|add_option" (how options are used)
Grep: "get_post_meta|update_post_meta" (how post meta is used)
Grep: "get_user_meta|update_user_meta" (how user meta is used)
Grep: "CREATE TABLE|\$wpdb->prefix" (custom tables)
```

**Scan 4 — Security patterns in use:**
```
Grep: "wp_verify_nonce|check_ajax_referer" (existing nonce patterns)
Grep: "current_user_can" (existing capability checks)
Grep: "sanitize_text_field|absint|sanitize_email" (existing sanitization)
Grep: "esc_html|esc_attr|esc_url" (existing escaping)
```

**Scan 5 — UI/UX patterns:**
```
Glob: {project_root}/includes/admin/views/*.php (existing admin page templates)
Glob: {project_root}/src/components/*.jsx (existing React components)
Grep: "add_menu_page|add_submenu_page" (existing admin menus)
```

Summarize the context scan findings as a compact "codebase context" block that will be passed to all agents.

---

## Phase 3 — Round 1: Initial Expert Positions (Parallel)

**Goal:** Every relevant expert independently forms their position based solely on the interview answers and codebase context — before seeing what anyone else thinks. This is the unfiltered expert view.

**MANDATORY PARALLEL EXECUTION:** Spawn all relevant agents in a single batch. Never sequential.
**Do NOT share any expert's output with any other expert during this round.**

### Agent selection by mode

| Mode | Always include | Include if relevant |
|---|---|---|
| FEATURE | Architect, Security Auditor, UX Auditor, Senior Engineer, Test Critic, Security Analyst | WordPress Reviewer (if WordPress), Performance Analyzer (if data/scale involved), UX Designer (if new screen/page), UI Designer (if new UI components) |
| REVIEW | All 10 | — |
| BUG_FIX | Architect, Security Auditor, Senior Engineer, Test Critic | Performance Analyzer (perf bugs), WordPress Reviewer (WP API bugs), UX Auditor (UX bugs) |
| REFACTOR | Architect, WordPress Reviewer, Senior Engineer, Test Critic | Performance Analyzer, Security Auditor |
| ARCHITECTURE | Architect, Security Analyst | Senior Engineer (implementation implications), Performance Analyzer, Security Auditor (if security-sensitive decision) |

### Prompt sent to each agent (FEATURE mode)

```
MODE: FEATURE PLANNING — You are designing a new feature, NOT reviewing existing code for bugs.

Feature description: [from interview Q1]
Users: [from interview Q2]
Location: [from interview Q3]
Data: [from interview Q4]
Scale: [from interview Q5]
Integrations: [from interview Q6]
Success definition: [from interview Q7]

Codebase context:
[compact summary from Phase 2 scan]

Your task as [Expert Name]:
1. From your specialized perspective, what is your recommended approach for this feature?
2. What specific [patterns / WordPress APIs / security measures / performance design / UX states]
   MUST be included? Be specific — name the exact functions, hooks, patterns, or UI states.
3. What should be explicitly avoided, and why?
4. From your lens, what is the implementation order?

Use this output format exactly:

[PLAN — EXPERT NAME]
Recommended approach: [your recommended design decision]

Must include:
- [specific item 1]
- [specific item 2]
...

Must avoid:
- [anti-pattern 1 and why]
...

Implementation notes:
- [order dependency, gotcha, or constraint from your lens]
...
```

### Prompt sent to each agent (BUG_FIX mode)

```
MODE: BUG FIX — You are diagnosing and recommending a fix strategy, NOT reviewing for style.

Bug description: [from interview Q1]
When it occurs: [from interview Q2]
Affected users: [from interview Q3]
Business impact: [from interview Q4]
Error output: [from interview Q5]
Attempted fixes: [from interview Q6]

Codebase context:
[compact summary from Phase 2 scan — focused on the bug area]

Your task as [Expert Name]:
1. From your specialized perspective, what is the likely root cause?
2. What is the recommended fix approach?
3. What must be tested after the fix?
4. How do we prevent this class of bug from recurring?

Use this output format:

[BUG — EXPERT NAME]
Suspected root cause: [your diagnosis from your lens]
Recommended fix: [specific approach]
Must test: [what to verify after fix]
Prevention: [how to prevent recurrence]
```

### Prompt sent to each agent (REFACTOR mode)

```
MODE: REFACTORING — You are designing a refactoring strategy, NOT adding new features.

What's being refactored: [from interview Q1]
Why: [from interview Q2]
Target state: [from interview Q3]
Test coverage: [from interview Q4]
Dependency count: [from interview Q5]
Constraints: [from interview Q6]

Codebase context:
[compact summary from Phase 2 scan — the code being refactored]

Your task as [Expert Name]:
1. Do you agree with the refactoring goal? If not, say why.
2. What approach do you recommend for this refactoring?
3. What is the risk, and how do we manage it?
4. What order should the changes happen?

Use this output format:

[REFACTOR — EXPERT NAME]
Agrees with goal: [Yes / Partially — because... / No — because...]
Recommended approach: [your strategy]
Risk assessment: [what could break and how to mitigate]
Order: [your recommended sequence]
```

### Prompt sent to each agent (REVIEW mode)

```
MODE: CODE REVIEW — Review the changed files for problems before this PR is merged.

Files changed: [list from git diff]
Project root: [current directory]
Stack: [detected stack]

Apply your specialized lens. Find what the developer may have missed.
Use your standard review output format (severity / what / why / where / how).
```

### Prompt sent to each agent (ARCHITECTURE mode)

```
MODE: ARCHITECTURE DECISION — Help decide between approaches.

Decision: [from interview Q1]
Options: [from interview Q2]
Constraints: [from interview Q3]
Scale: [from interview Q4]
Already ruled out: [from interview Q5]

Codebase context:
[compact summary from Phase 2 scan]

Your task as [Expert Name]:
1. Which option do you recommend from your perspective?
2. Why — what are the key factors from your lens?
3. What are the trade-offs of your recommendation?
4. What would make you change your recommendation?

Use this output format:

[ARCHITECTURE — EXPERT NAME]
Recommendation: [option name]
Primary reason: [your key argument]
Trade-offs: [what you're giving up]
Conditions that would change this: [if X then reconsider]
```

---

## Phase 3.5 — Round 2: The Debate (Parallel)

**Goal:** Each expert reads ALL other experts' Round 1 positions, challenges what they disagree with, accepts what strengthens their own view, and produces a final hardened position. This is where weak arguments collapse and strong ones get amplified.

**MANDATORY PARALLEL EXECUTION:** Spawn all agents again simultaneously, each receiving the full set of all Round 1 outputs.

**This round applies to ALL modes — FEATURE, REVIEW, BUG_FIX, REFACTOR, ARCHITECTURE.**

### What to send each agent in Round 2

Construct a debate brief for each agent containing:
1. A reminder of their own Round 1 output
2. Every other expert's Round 1 output in full
3. The debate prompt below

```
ROUND 2 — THE DEBATE

You are the [Expert Name]. You have already submitted your Round 1 position.
Now read what the other experts said and engage with their positions.

YOUR ROUND 1 POSITION:
[paste this agent's exact Round 1 output]

WHAT THE OTHER EXPERTS SAID:

--- PRAGMATIC ARCHITECT (Round 1) ---
[architect Round 1 output — omit this section if this IS the Architect]

--- SECURITY AUDITOR (Round 1) ---
[security-auditor Round 1 output — omit if this IS the Security Auditor; omit if not participating in this mode]

--- WORDPRESS REVIEWER (Round 1) ---
[wp-reviewer Round 1 output — omit if this IS the WordPress Reviewer; omit if not participating in this mode]

--- PERFORMANCE ANALYZER (Round 1) ---
[perf-analyzer Round 1 output — omit if this IS the Performance Analyzer; omit if not participating in this mode]

--- UX AUDITOR (Round 1) ---
[ux-auditor Round 1 output — omit if this IS the UX Auditor; omit if not participating in this mode]

--- TEST CRITIC (Round 1) ---
[test-critic Round 1 output — omit if this IS the Test Critic; omit if not participating in this mode]

--- SENIOR ENGINEER (Round 1) ---
[senior-engineer Round 1 output — omit if this IS the Senior Engineer; omit if not participating in this mode]

--- UX DESIGNER (Round 1) ---
[ux-designer Round 1 output — omit if this IS the UX Designer; omit if not participating in this mode]

--- UI DESIGNER (Round 1) ---
[ui-designer Round 1 output — omit if this IS the UI Designer; omit if not participating in this mode]

--- SECURITY ANALYST (Round 1) ---
[security-analyst Round 1 output — omit if this IS the Security Analyst; omit if not participating in this mode]

YOUR DEBATE TASK:
Read every other expert's position carefully. Then respond:

1. CHALLENGE — What are you pushing back on? Be specific and technical.
   For each point you challenge: name the expert, state their position, explain why
   it is wrong or incomplete from your perspective, and state what should replace it.

2. ACCEPT — What from other experts do you agree with or want to incorporate?
   For each point you accept: name the expert and briefly explain why it is correct.

3. REVISE OR DEFEND — Update your Round 1 position based on the debate.
   - If another expert changed your mind: say so, and state your revised position.
   - If you are standing firm: explain why — address the challenges directly.

4. FINAL POSITION — Your settled recommendation after the debate.
   This is what goes into the plan. Be concrete and specific.

Use this output format exactly:

[DEBATE ROUND 2 — EXPERT NAME]

CHALLENGE:
- [Expert challenged]: "[their position]"
  Why wrong/incomplete: [your technical reasoning]
  What instead: [your alternative or correction]

- [Expert challenged]: "[their position]"
  Why wrong/incomplete: [your technical reasoning]
  What instead: [your alternative or correction]

ACCEPT:
- [Expert accepted]: "[their position]" — correct because [brief reason]
- [Expert accepted]: "[their position]" — correct because [brief reason]

POSITION CHANGE:
[Yes — revised to: [new position]] / [No — standing firm because: [direct response to challenges]]

FINAL POSITION:
[Your complete, settled recommendation after the debate — written as if the debate is closed.
This is concrete, specific, and actionable. No hedging.]
```

### Round 2 — Debate Rules for Each Expert

**Pragmatic Architect debates:**
- Challenge: if Performance Analyzer recommends caching infrastructure that adds complexity without real performance benefit at the stated scale
- Challenge: if Security Auditor recommends abstraction layers purely for security that add maintenance cost disproportionate to risk
- Accept: if WordPress Reviewer points to a built-in WordPress API that eliminates a custom implementation the Architect recommended
- Accept: if Performance Analyzer's data on query volume justifies a caching layer the Architect initially resisted

**Security Auditor debates:**
- Challenge: if any expert recommends storing or passing data in ways that create injection, CSRF, or privilege escalation vectors
- Challenge: if Architect's "simplicity" removes a security boundary that is genuinely protecting data
- Accept: if Architect's simpler approach achieves the same security level with less surface area
- Accept: if WordPress Reviewer's chosen API has built-in nonce/capability handling that eliminates a manual check

**WordPress Reviewer debates:**
- Challenge: if Architect recommends a custom approach when a WordPress API handles it natively and correctly
- Challenge: if Performance Analyzer recommends raw `$wpdb` for a query that `WP_Query` could handle safely
- Accept: if Architect correctly identifies that a proposed WordPress hook system is over-engineered for internal-only code
- Accept: if Performance Analyzer's scale data genuinely justifies a direct `$wpdb` approach

**Performance Analyzer debates:**
- Challenge: if Architect calls caching "premature" when the interview stated high user volume or heavy query load
- Challenge: if WordPress Reviewer recommends `get_option` with autoload for data not needed on every page load
- Accept: if Architect's simpler approach demonstrably eliminates a performance problem at the source rather than masking it
- Accept: if Security Auditor's abstraction layer adds no meaningful query overhead

**UX Auditor debates:**
- Challenge: if Architect removes feedback states (loading, success, error) under the banner of simplicity
- Challenge: if any expert's approach leaves the user with no way to recover from an error condition
- Accept: if Performance Analyzer's async approach actually improves perceived performance for the user
- Accept: if Architect's simpler flow genuinely reduces interaction steps for the user

**Test Critic debates:**
- Challenge: if Senior Engineer's recommended design still contains untestable seams (static calls, no DI for external dependencies)
- Challenge: if any expert proposes a solution with no stated verification plan — how do we know it works in production?
- Challenge: if Security Auditor's fix introduces new conditional paths with no corresponding test scenario
- Accept: if Senior Engineer's testability improvements align with and enable the test coverage goals
- Accept: if Architect's simpler design has fewer code paths and is therefore easier to test exhaustively

**Senior Engineer debates:**
- Challenge: if Architect's "simple" approach introduces untestable code (static calls, mixed HTTP/business logic, no injection points)
- Challenge: if Performance Analyzer's caching recommendation creates hidden state that makes code hard to reason about
- Challenge: if WordPress Reviewer recommends a WordPress API that produces an anemic design with no domain logic
- Accept: if Architect correctly identifies that an abstraction layer doesn't improve testability and only adds indirection
- Accept: if Test Critic's flagging of untestable code aligns with their own assessment

**UX Designer debates:**
- Challenge: if Architect's simplification removes a necessary navigation step and leaves users without a clear path to the feature
- Challenge: if UX Auditor's implementation-level fix conflicts with the higher-level IA structure (UX Designer escalates to: "where does this feature live?"; UX Auditor stays at: "are the states correct?")
- Challenge: if Performance Analyzer's async approach eliminates real-time feedback in a way that creates a confusing or broken user journey
- Accept: if UX Auditor's implementation-level fixes align with and reinforce the information architecture decisions
- Accept: if Architect's simpler page structure actually improves findability and navigation

**UI Designer debates:**
- Challenge: if Senior Engineer's recommended component structure makes it architecturally difficult to maintain visual consistency (styles scattered across ad-hoc files rather than in a design system component)
- Challenge: if UX Auditor's loading/error states are specified without considering how they integrate with the existing visual design system
- Accept: if Architect's component structure makes it easier to enforce design system tokens and visual patterns
- Accept: if UX Designer's information architecture naturally produces a visual hierarchy that aligns with established component patterns

**Security Analyst debates:**
- Challenge: if Security Auditor's finding is tactical (specific exploit) but the deeper architectural issue (data governance, audit logging, retention Capability) is not addressed — the Analyst escalates to governance level
- Challenge: if any expert's recommendation involves storing sensitive data (PII, tokens, keys) without addressing governance and compliance implications
- Challenge: if Architect's simplification removes a security boundary that serves a compliance purpose, not just a security purpose
- Accept: if Security Auditor's exploit-level findings align with the threat model — both are seeing the same risk from different angles
- Accept: if WordPress Reviewer's recommended APIs have built-in data handling that satisfies compliance requirements

---

## Phase 4: Final Synthesis — Post-Debate Convergence

**Goal:** Use ONLY the FINAL POSITION from each expert's Round 2 output. Ignore Round 1 positions — they have been superseded by the debate. Build the unified deliverable from hardened, post-debate expert positions.

**What to look for in the debate outputs before synthesizing:**
- Points where MULTIPLE experts' Final Positions now agree → these become the highest-confidence recommendations
- Points where one expert's Final Position explicitly revised due to another → note the evolution ("Architect revised after Performance Analyzer demonstrated the query volume")
- Points where an expert stood firm under challenge → these are the non-negotiables from that expert's lens
- Points where no expert challenged something → unchallenged recommendations go in without debate annotation

### For ALL modes (FEATURE / REVIEW / BUG_FIX / REFACTOR / ARCHITECTURE):

**Step 1 — Extract only FINAL POSITION sections from Round 2**
Do not use Round 1 outputs. Every expert either revised their position or defended it in Round 2. The Final Position is the only thing that matters for synthesis.

**Step 2 — Map agreements that emerged from the debate**
These are points where:
- Expert A's Final Position now aligns with Expert B's after the debate
- An expert explicitly accepted another's point in their ACCEPT section
- No expert challenged a point — meaning it was unopposed

These unanimously agreed points become the **highest-confidence section** of the output.
Label them: "Panel Unanimous" — the plan must include these, no question.

**Step 3 — Resolve any remaining conflicts**
If two experts still hold conflicting Final Positions after debating, apply the resolution hierarchy:

| Remaining conflict | Resolution |
|---|---|
| Architect vs. Security Auditor | Security Auditor wins — document that the complexity is a justified security boundary |
| Architect vs. WordPress Reviewer | WordPress Reviewer wins if the API genuinely fits the use case |
| Architect vs. Performance Analyzer | Performance Analyzer wins if interview answers confirm real scale risk |
| Any expert vs. UX Auditor (on user states/flows) | UX Auditor wins — user protection and clarity are non-negotiable |
| Two valid approaches with real trade-offs | Present both with trade-offs, state the recommended default and the condition to switch |

For every resolved conflict: name both experts, state each position, state which won and why. Never silently pick one.

**Step 4 — Note where debate changed positions**
In the final output, mark any recommendation that evolved during the debate with: "(Architect revised after Performance Analyzer debate)" — this shows the plan is battle-tested, not just an initial draft.

**Step 5 — Produce unified output**

---

## Phase 5: Unified Output

### FEATURE Output

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — FEATURE BLUEPRINT                       ║
╠══════════════════════════════════════════════════════════════════╣
║  Feature:     [name]                                             ║
║  Complexity:  [Low / Medium / High / Very High]                  ║
║  Panel:       Architect · Security Auditor · WP Reviewer · Perf · UX Auditor ║
║               Sr. Engineer · Test Critic · UX Designer · UI Designer · Sec Analyst ║
╚══════════════════════════════════════════════════════════════════╝

━━━ RECOMMENDED APPROACH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Clear description of the recommended architecture — what gets built and how it fits together]

━━━ ALTERNATIVES CONSIDERED (and why rejected) ━━━━━━━━━━━━━━━━━━━

- [Option A]: rejected because [reason]
- [Option B]: rejected because [reason]

━━━ ARCHITECTURE (Pragmatic Architect) ━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files to create:
  - [path/filename.php] — [purpose]
  - [path/filename.jsx] — [purpose]

Files to modify:
  - [existing-file.php] — [what changes and why]

Pattern to follow:
  - [reference to existing similar file in codebase, e.g., "Follow the pattern in includes/class-settings.php"]

━━━ WORDPRESS APIs TO USE (WordPress Reviewer) ━━━━━━━━━━━━━━━━━━━━

Data storage:  [get_option / get_post_meta / custom table — with justification]
Admin page:    [add_menu_page / add_submenu_page / hook name]
Data save:     [wp_ajax_ / REST register_rest_route — with justification]
Enqueue:       [wp_enqueue_script / wp_enqueue_style — hook and condition]
[Any other specific WordPress functions the feature should use]

━━━ SECURITY — MUST IMPLEMENT FROM DAY ONE (Security Auditor) ━━━━

□ Capability check:  current_user_can('[capability]') before every state change
□ Nonce create:      wp_nonce_field('[action-name]', '[field-name]') in every form
□ Nonce verify:      check_ajax_referer('[action-name]', '[field-name]') in every handler
□ Sanitize inputs:   [specific function for each input — e.g., absint($id), sanitize_text_field($title)]
□ Escape outputs:    [specific function for each output — e.g., esc_html($name), esc_url($link)]
□ [Any additional security requirement specific to this feature]

━━━ PERFORMANCE DESIGN (Performance Analyzer) ━━━━━━━━━━━━━━━━━━━━

Cache:    [what to cache / transient key / expiration — or "no caching needed for this scale"]
Queue:    [what operations must be async — or "all operations are fast enough to be inline"]
Indexes:  [what indexes to add if custom table — or "using existing indexed columns"]
Limits:   [pagination, max records, LIMIT clauses to add]

━━━ UX SPECIFICATION (UX Auditor) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

States to implement:
  Loading:  [what the user sees while data loads]
  Success:  [what confirms the action worked]
  Error:    [what the user sees and can do when it fails]
  Empty:    [what new users see before any data exists]

Confirmations required:
  - [list any destructive or irreversible actions that need a confirmation dialog]

Microcopy:
  - [key labels, button text, error messages — written for non-technical users]

━━━ IMPLEMENTATION DESIGN (Senior Engineer) ━━━━━━━━━━━━━━━━━━━━━━

Design pattern: [which pattern to use, and why it fits this specific problem]
Testability: [how to structure the code so it can be unit tested — injection points, seams]
API contract: [method signatures, what the public interface should look like]
Error handling: [what exceptions to throw, what to catch, meaningful error messages]

━━━ QUALITY STRATEGY (Test Critic) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Acceptance criteria:
  □ [Verifiable criterion 1 — testable in automated tests]
  □ [Verifiable criterion 2]
  □ [Error/failure criterion — what must happen when it fails]
  □ [Empty state criterion — what the user sees with no data]

Edge cases to test:
  - [Edge case 1 — boundary condition or unexpected input]
  - [Edge case 2 — concurrent operation or race condition]
  - [Edge case 3 — external dependency failure]

Regression risk: [what existing tests may need updating]

━━━ UX DESIGN (UX Designer) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Entry point: [how users discover and navigate to this feature]
User journey: [before → during → after — full flow for the primary use case]
First-run experience: [what a brand new user sees and what guides them to first success]
Information architecture: [where this feature lives in the navigation and why]
Terminology: [what to call things — aligned with user vocabulary]

━━━ UI DESIGN (UI Designer) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visual hierarchy: [what should be most prominent, and how to achieve it]
Design system: [which existing components, tokens, and patterns to use]
Component states: [all visual states — default, hover, focus, active, disabled, loading, error, empty]
Responsive: [mobile behavior and breakpoints to consider]

━━━ SECURITY ARCHITECTURE (Security Analyst) ━━━━━━━━━━━━━━━━━━━━━

Data classification: [what data types are stored — PII / sensitive / standard]
Compliance requirements: [GDPR / PCI / WordPress.org guidelines that apply]
Audit logging: [what actions must be logged, what fields each entry must contain]
Threat model summary: [top 2-3 STRIDE risks and mitigations]
Retention & deletion: [how long data is kept, how it's deleted on user request]

━━━ PANEL DEBATE SUMMARY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unanimous (no expert challenged):
  - [Point that passed through the debate unchallenged]

Debated and resolved:
  - [Expert A challenged Expert B on X → Expert B revised / Expert A conceded — final: Y]
  - [Expert C challenged Expert D on Z → stood firm because: reason — final: Z]

Positions revised during debate:
  - [Expert name] changed their position on [topic] after [Expert name]'s challenge

━━━ IMPLEMENTATION ORDER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. [First step and why it comes first — e.g., "Database migration — must exist before anything reads/writes data"]
2. [Second step]
3. [Third step]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Plan is ready. Say "yes" to start implementing.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### BUG_FIX Output

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — BUG FIX STRATEGY                        ║
╠══════════════════════════════════════════════════════════════════╣
║  Bug:      [one-line description]                                ║
║  Impact:   [Blocking / Significant / Minor]                      ║
║  Panel:    [experts who participated]                            ║
╚══════════════════════════════════════════════════════════════════╝

━━━ ROOT CAUSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Clear explanation of WHY the bug happens — not what happens, but the underlying cause]

Likely location: [file:line if determinable, or "needs investigation in: file"]

━━━ RECOMMENDED FIX ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Description of the fix approach]

Files to change:
  - [file] — [what changes]

What NOT to do:
  - [common wrong approach and why it would make things worse]

━━━ VERIFICATION CHECKLIST ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After fixing, verify:
  □ [Test scenario 1 — the original bug no longer reproduces]
  □ [Test scenario 2 — related functionality still works]
  □ [Edge case to check]

━━━ PREVENTION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

How to prevent this class of bug in future:
  - [Pattern to adopt]
  - [Test to add]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to fix? Say "yes" and I will implement the fix.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### REFACTOR Output

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — REFACTORING PLAN                        ║
╠══════════════════════════════════════════════════════════════════╣
║  Target:   [what's being refactored]                             ║
║  Goal:     [why — one line]                                      ║
║  Risk:     [Low / Medium / High]                                 ║
╚══════════════════════════════════════════════════════════════════╝

━━━ PANEL VERDICT ON THE GOAL ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Do the experts agree this refactoring is worthwhile? Any pushback?]

━━━ RECOMMENDED APPROACH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[The strategy — e.g., "Extract service class in 3 phases", "Split into two smaller classes", etc.]

━━━ PHASES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase 1 — [Name]: [what changes, can be done and reviewed independently]
Phase 2 — [Name]: [what changes, depends on Phase 1]
Phase 3 — [Name]: [final cleanup]

(Phased approach reduces risk — each phase can be a separate PR)

━━━ RISK MITIGATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  □ [Check or test before starting]
  □ [Backward compatibility concern to handle]
  □ [Verify after each phase]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to start? Say "yes" and I will begin Phase 1.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### ARCHITECTURE Output

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — ARCHITECTURE DECISION                   ║
╠══════════════════════════════════════════════════════════════════╣
║  Decision:      [one-line description]                           ║
║  Recommendation: [chosen option]                                 ║
║  Confidence:     [High / Medium — with conditions]               ║
╚══════════════════════════════════════════════════════════════════╝

━━━ RECOMMENDATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Go with: [Option Name]

Primary reason: [the single most important factor that drove this decision]

━━━ WHY NOT THE ALTERNATIVES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- [Option B]: [why the panel rejected it]
- [Option C]: [why the panel rejected it]

━━━ TRADE-OFFS YOU ARE ACCEPTING ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

By choosing [Option A], you accept:
  - [Trade-off 1]
  - [Trade-off 2]

━━━ CONDITIONS THAT WOULD CHANGE THIS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Reconsider if:
  - [Condition that would make Option B better]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Decision recorded. Say "yes" to start building with this approach.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### REVIEW Output

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
...

━━━ MEDIUM — Fix in Follow-up ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
...

━━━ DEBATE OUTCOME ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Findings that survived debate unchallenged: [count] — these are certain
Findings revised after debate: [count] — [brief note on what changed]
Findings dropped as false positives after debate: [count]

Good work: [what the panel unanimously acknowledged]
```

---

## Quality Rules (All Modes)

- **Every recommendation must trace to the interview answers or actual codebase content** — never invent problems or recommend solutions to problems that don't exist in this specific project
- **Every output must have a "ready to build/fix/proceed?" prompt** — the panel is always leading toward action
- **Conflicts must be resolved, never left as "it depends"** — the panel makes a call and explains why
- **If there is genuine uncertainty**, say "we recommend X but verify Y before starting"
- **Keep the interview short** — the user answers once, not in multiple back-and-forth rounds
- **Never repeat the same finding from multiple experts** — synthesis combines them

---

## Safety Rules

- **NEVER modify files** — this is a planning and review tool
- **NEVER run destructive commands** — only read, glob, grep, bash for git diff
- **If the user's intent is ambiguous**, ask ONE clarifying question, then proceed
- **If an expert's finding is uncertain**, mark it "(to verify)" not as a definitive problem

---

## References

- Panel-dedicated agents (no standalone equivalent):
  - `developers:architect` — Pragmatic Architect (simplicity, anti-over-engineering)
  - `developers:senior-engineer` — Senior Software Engineer (implementation craftsmanship, testability)
  - `developers:ux-designer` — Expert UX Designer (information architecture, user journeys)
  - `developers:ui-designer` — Expert UI Designer (visual design, design system consistency)
  - `developers:security-analyst` — Expert Security Analyst (threat modeling, GDPR, audit logging)

- Standard agents reused in the panel (same agent, panel prompt overrides output format):
  - `developers:security-auditor` — Security Auditor (offensive security review, exploit paths)
  - `developers:wp-reviewer` — WordPress Reviewer (API correctness, WPCS, ecosystem fit)
  - `developers:perf-analyzer` — Performance Analyzer (N+1 queries, caching, scale bottlenecks)
  - `developers:ux-auditor` — UX Auditor (missing states, broken flows, usability)
  - `developers:test-critic` — Test Critic (coverage gaps, edge cases, untestable code)

