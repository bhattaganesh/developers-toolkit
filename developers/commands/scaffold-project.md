---
description: Initialize a new project with org-standard CLAUDE.md and settings
---

# Scaffold Project

Set up a new or existing project with organizational standards.

## Instructions

1. **Detect project type** — Look at the project root to identify:
   - `wp-content/` or `wp-config.php` → WordPress project
   - `package.json` with `next` → NextJS project
   - `package.json` with `react` → React project
   - Multiple indicators → mixed stack (WordPress + React)

2. **Create CLAUDE.md** — Generate a project-specific `CLAUDE.md` at the project root:
   - For WordPress: use `developers/templates/CLAUDE.md.wordpress.template`
   - For React/NextJS: use the React baseline (if available)
   - Fill in the project name from directory name or package.json
   - Customize the tech stack section based on detected project type
   - Customize the commands section based on available scripts
   - Add project-specific gotchas if discoverable (e.g., required env vars, WP version requirements)

3. **Set up .claude/ directory** — Create the Claude Code configuration:
   - For WordPress: copy `developers/templates/settings.wordpress.json` to `.claude/settings.json`
   - For React: copy `developers/templates/settings.json` to `.claude/settings.json`
   - Both include `autoCompactThreshold: 50` and recommended permissions for the detected stack
   - `.claude/settings.local.json` — Create empty file for developer-specific overrides
   - `.claude/mcp.json` — (Optional, WordPress) Copy from `developers/templates/mcp.wordpress.json` if using GitHub + Playwright MCP

4. **Set up .claudeignore file** — Improve token efficiency by excluding unnecessary files:
   - For WordPress: copy `developers/templates/.claudeignore.wordpress` to `.claudeignore`
   - Excludes vendor/, node_modules/, build artifacts, and other non-source files
   - Customize for project-specific needs (e.g., add plugin directories for other plugins)

5. **Verify** — List what was created and what the developer should customize:
   - CLAUDE.md sections to update (Current Focus, Gotchas)
   - Settings to review (ensure lint/test commands match project)
   - Remind to add `.claude/settings.local.json` to `.gitignore`
   - Review `.claudeignore` and customize for project-specific ignored paths

6. **Do NOT overwrite** — If any file already exists, show a diff of what would change and ask before overwriting.
