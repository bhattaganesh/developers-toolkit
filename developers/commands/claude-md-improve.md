---
description: Run the Elite CLAUDE.md Synchronizer to audit and resolve documentation debt
---

# Improve CLAUDE.md

Execute a multi-phase audit and synchronization of your project documentation.

## User Instructions

Run this command to keep your `CLAUDE.md` in sync with your codebase.

```bash
/developers:claude-md-improve
```

## Internal Agent Instructions (Execution)

1.  **Activate Skill:** Utilize the `claude-md-improver` skill for logic.
2.  **Phase 1 (Audit):**
    - Run codebase discovery (scan scripts, configs, folders).
    - Score the existing `CLAUDE.md` against the `quality-criteria.md`.
    - Present the **Performance Report (0-100)** to the user.
3.  **Phase 2 (Synthesis):**
    - Generate a list of detected improvements (missing commands, architecture drift).
    - Map the `projectId` to the git remote origin hash if missing.
4.  **Phase 3 (Resolution):**
    - Present a code diff showing the suggested improvements to `CLAUDE.md`.
    - Apply the changes upon user confirmation.
5.  **Finalization:** Force-read the updated `CLAUDE.md` to ensure immediate context alignment for the current session.

## Performance Metrics (The 200x Standards)
- **Commands:** 100% coverage of Build/Test/Lint scripts.
- **Identity:** Valid `projectId` present.
- **Security:** Project-specific "Expert Gotchas" included.
- **Accuracy:** File/Folder hierarchy explicitly documented.
