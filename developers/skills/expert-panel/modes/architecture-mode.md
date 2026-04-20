# Expert Panel — ARCHITECTURE Mode

Use this file when mode = ARCHITECTURE (deciding between approaches).

---

## Phase 1: Architecture Interview

```
Expert Panel — Architecture Interview
=======================================
Help the panel understand the decision.

1. What decision do you need to make? (one sentence)

2. What options are you considering? (list them)

3. What constraints apply?
   (performance / team skill set / timeline / must integrate with X / backward compatibility)

4. What is the expected scale?
   (users, requests/sec, data volume — rough estimates are fine)

5. Have you already tried or ruled anything out? Why?
```

---

## Phase 3: Agent Selection & Prompts

**Always include:** Architect, Security Analyst
**Include if relevant:** Senior Engineer (implementation implications), Performance Analyzer, Security Auditor (security-sensitive decisions)

**Prompt template:**

```
MODE: ARCHITECTURE DECISION — deciding between approaches.

Decision: [Q1]  |  Options: [Q2]  |  Constraints: [Q3]
Scale: [Q4]  |  Already ruled out: [Q5]

Codebase context:
[compact summary from Phase 2]

As [Expert Name]:
1. Which option do you recommend from your perspective?
2. Why — what are the key factors from your lens?
3. What are the trade-offs of your recommendation?
4. What would make you change your recommendation?

Format:
[ARCHITECTURE — EXPERT NAME]
Recommendation:               [option name]
Primary reason:               [key argument]
Trade-offs:                   [what you're giving up]
Conditions to change stance:  [if X then reconsider]
```

---

## Phase 5: Architecture Output Template

```
╔══════════════════════════════════════════════════════════════════╗
║           EXPERT PANEL — ARCHITECTURE DECISION                   ║
╠══════════════════════════════════════════════════════════════════╣
║  Decision:       [one-line description]                          ║
║  Recommendation: [chosen option]                                 ║
║  Confidence:     [High / Medium — with conditions]               ║
╚══════════════════════════════════════════════════════════════════╝

━━━ RECOMMENDATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Go with: [Option Name]
Primary reason: [single most important factor]

━━━ WHY NOT THE ALTERNATIVES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- [Option B]: [why rejected]
- [Option C]: [why rejected]

━━━ TRADE-OFFS YOU ARE ACCEPTING ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By choosing [Option A], you accept:
  - [Trade-off 1]
  - [Trade-off 2]

━━━ CONDITIONS THAT WOULD CHANGE THIS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reconsider if:
  - [Condition that would make an alternative better]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Decision recorded. Say "yes" to start building with this approach.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
