# Expert Panel — FEATURE Mode

Use this file when mode = FEATURE (building something new).

---

## Phase 1: Feature Interview

Present all questions at once. User answers in one reply.

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

5. Roughly how many users or records at steady state?
   (e.g., "10 admins", "all site users ~5,000", "one record per order")

6. Does this integrate with anything that already exists?
   (existing plugin code, admin pages, post types, APIs, or third-party services)

7. What does success look like from the user's perspective?
   (what does the user do, see, and now accomplish?)
```

---

## Phase 3: Agent Selection & Prompts

**Always include:** Architect, Security Auditor, UX Auditor, Senior Engineer, Test Critic, Security Analyst
**Include if relevant:** WordPress Reviewer (WordPress project), Performance Analyzer (data/scale), UX Designer (new screen), UI Designer (new UI components)

**Prompt template for each agent:**

```
MODE: FEATURE PLANNING — designing a new feature, NOT reviewing existing code for bugs.

Feature: [Q1]  |  Users: [Q2]  |  Location: [Q3]
Data: [Q4]  |  Scale: [Q5]  |  Integrations: [Q6]
Success: [Q7]

Codebase context:
[compact summary from Phase 2]

As [Expert Name]:
1. What is your recommended approach from your specialized perspective?
2. What specific [patterns / APIs / security measures / performance design / UX states] MUST be included?
3. What should be explicitly avoided, and why?
4. From your lens, what is the implementation order?

Format:
[PLAN — EXPERT NAME]
Recommended approach: [decision]

Must include:
- [item 1]
...

Must avoid:
- [anti-pattern and why]
...

Implementation notes:
- [order dependency, gotcha, or constraint]
...
```

---

## Phase 5: Feature Output Template

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — FEATURE BLUEPRINT                       ║
╠══════════════════════════════════════════════════════════════════╣
║  Feature:    [name]                                              ║
║  Complexity: [Low / Medium / High / Very High]                   ║
║  Panel:      [experts who participated]                          ║
╚══════════════════════════════════════════════════════════════════╝

━━━ RECOMMENDED APPROACH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Clear description of the recommended architecture]

━━━ ALTERNATIVES CONSIDERED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- [Option A]: rejected because [reason]

━━━ ARCHITECTURE (Pragmatic Architect) ━━━━━━━━━━━━━━━━━━━━━━━━━━━
Files to create:
  - [path/file.php] — [purpose]
Files to modify:
  - [existing-file.php] — [what changes and why]
Pattern to follow:
  - [reference to existing similar file in codebase]

━━━ WORDPRESS APIs (WordPress Reviewer) ━━━━━━━━━━━━━━━━━━━━━━━━━━
Data storage:  [get_option / get_post_meta / custom table — justification]
Admin page:    [add_menu_page / add_submenu_page / hook]
Data save:     [wp_ajax_ / register_rest_route — justification]
Enqueue:       [wp_enqueue_script hook and condition]

━━━ SECURITY — MUST IMPLEMENT FROM DAY ONE (Security Auditor) ━━━━
□ Capability check:  current_user_can('[capability]') before every state change
□ Nonce create:      wp_nonce_field('[action]', '[field]') in every form
□ Nonce verify:      check_ajax_referer('[action]', '[field]') in every handler
□ Sanitize inputs:   [specific function per input]
□ Escape outputs:    [specific function per output]

━━━ PERFORMANCE DESIGN (Performance Analyzer) ━━━━━━━━━━━━━━━━━━━━
Cache:   [transient key / expiration — or "no caching needed for this scale"]
Queue:   [what must be async — or "all operations fast enough inline"]
Indexes: [for custom tables — or "using existing indexed columns"]
Limits:  [pagination, LIMIT clauses]

━━━ UX SPECIFICATION (UX Auditor) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
States:
  Loading: [what the user sees while loading]
  Success: [what confirms the action worked]
  Error:   [what the user sees and can do when it fails]
  Empty:   [what new users see before data exists]
Confirmations: [destructive actions that need confirmation dialogs]
Microcopy:     [key labels, button text, error messages in plain language]

━━━ IMPLEMENTATION DESIGN (Senior Engineer) ━━━━━━━━━━━━━━━━━━━━━━
Design pattern: [which pattern and why it fits]
Testability:    [injection points, seams for unit testing]
API contract:   [method signatures, public interface]
Error handling: [what to throw, what to catch, meaningful messages]

━━━ QUALITY STRATEGY (Test Critic) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Acceptance criteria:
  □ [Verifiable criterion 1]
  □ [Error/failure criterion]
  □ [Empty state criterion]
Edge cases: [boundary conditions, concurrent ops, dependency failures]
Regression risk: [existing tests that may need updating]

━━━ UX DESIGN (UX Designer) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Entry point:     [how users discover this feature]
User journey:    [before → during → after for primary use case]
First-run:       [what guides a new user to first success]
IA:              [where this lives in navigation and why]

━━━ UI DESIGN (UI Designer) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Visual hierarchy:  [what is most prominent and how]
Design system:     [existing components, tokens, patterns to use]
Component states:  [default, hover, focus, active, disabled, loading, error, empty]
Responsive:        [mobile behavior and breakpoints]

━━━ SECURITY ARCHITECTURE (Security Analyst) ━━━━━━━━━━━━━━━━━━━━━
Data classification:    [PII / sensitive / standard]
Compliance:             [GDPR / PCI / WordPress.org guidelines]
Audit logging:          [what actions to log, what fields per entry]
Threat model:           [top 2-3 STRIDE risks and mitigations]
Retention & deletion:   [how long data kept, how deleted on request]

━━━ PANEL DEBATE SUMMARY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Panel Unanimous:         [points no expert challenged]
Debated and resolved:    [Expert A vs Expert B → final: X]
Positions revised:       [Expert changed on topic after challenge]

━━━ IMPLEMENTATION ORDER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. [First step and why — e.g., "Database migration — must exist before anything reads data"]
2. [Second step]
3. [Third step]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Plan is ready. Say "yes" to start implementing.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
