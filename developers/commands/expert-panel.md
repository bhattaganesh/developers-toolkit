---
description: Universal development panel — 10 world-class expert subagents adapt to any SDLC stage. Interviews you, scans codebase, runs a two-round debate, and delivers a blueprint ready to execute. Works for new features, code review, bug fixes, refactoring, and architecture decisions.
---

# Expert Panel

Activates the `expert-panel` skill — a virtual team of 10 world-class expert subagents that you can call at any point in the development lifecycle.

## What It Does

The panel **auto-detects** what kind of help you need from your message:

| If you say... | The panel does... | Output |
|---|---|---|
| "I want to build X" | Interviews you → designs feature | Implementation blueprint |
| "Review this before PR" | Scans changed files → debates | Findings + merge verdict |
| "I have a bug in X" | Interviews you → diagnoses | Root cause + fix strategy |
| "I want to refactor X" | Interviews you → plans | Phased refactoring plan |
| "Should I use A or B?" | Interviews you → debates | Architecture decision |

## The Experts

*Panel-dedicated specialists:*
1. **Pragmatic Architect** — simplest correct approach, fights over-engineering
2. **Senior Engineer** — implementation craftsmanship, design patterns, testability
3. **UX Designer** — information architecture, user journeys, first-run experience
4. **UI Designer** — visual design, design system consistency, component hierarchy
5. **Security Analyst** — threat modeling, GDPR compliance, audit logging governance

*Standard agents that also participate:*
6. **Security Auditor** — offensive security review, exploit paths, built in from day one
7. **WordPress Reviewer** — exact WordPress APIs to use, ecosystem fit, WPCS
8. **Performance Analyzer** — performance design, what to cache/queue/paginate
9. **UX Auditor** — UX states, flows, microcopy, missing feedback states
10. **Test Critic** — edge cases, coverage gaps, acceptance criteria, testability

## How to Invoke

Natural language — just describe what you need:

```
"Expert panel — I want to build a bulk export feature for my plugin"
"Call the panel to review this before I raise a PR"
"Panel — I have a bug where users can't save settings on multisite"
"Expert panel — should I use custom tables or post meta for this?"
"Panel, help me refactor the AJAX handler class"
```

## Instructions

1. **Detect intent** from the user's message (FEATURE / REVIEW / BUG_FIX / REFACTOR / ARCHITECTURE)
2. If intent is clear → state it and proceed; if ambiguous → ask one question
3. **Run the appropriate interview** (all questions at once — user answers once)
4. **Scan existing codebase** for context (parallel — 5 areas simultaneously)
5. **Spawn all relevant expert agents in parallel** using the Task tool
6. **Run Round 2 debate** — each expert reads all others' Round 1 positions and challenges/accepts/revises
7. **Synthesize** — resolve conflicts using debate final positions, surface consensus, eliminate duplicates
8. **Deliver unified output** in the format for the detected mode
9. **Always end with:** "Ready to [build/fix/proceed]? Say 'yes' to start."
