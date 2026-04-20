---
name: wp-project-triage
description: >
  This skill should be used when the user asks to "analyze this WordPress project",
  "what type of WordPress project is this", "triage this repo", "classify this codebase",
  "detect my WordPress project type", or as the automatic first step before any major
  WordPress workflow when the project type is unknown.
version: 1.0.0
tools: Read, Glob, Grep
---

# WordPress Project Triage

Deterministic classification of a WordPress repository — plugin, theme, block theme, or Gutenberg block plugin. Run this first before any multi-step WordPress workflow so downstream decisions are grounded in reality, not guesses.

## Detection Order

Run these checks in sequence. Stop at the first match.

### Step 1 — Detect Plugin

```
Grep: "Plugin Name:" in *.php (root level)
```

If found: **type = plugin**. Read the plugin header to extract:
- `Plugin Name`, `Version`, `Requires at least`, `Tested up to`, `Requires PHP`, `Text Domain`

### Step 2 — Detect Theme

```
Read: style.css (root level)
Grep: "Theme Name:" in style.css
```

If found: **type = classic-theme or block-theme** (check Step 2b below).

**Step 2b — Block Theme vs Classic Theme:**
```
Glob: theme.json (root level)
Glob: templates/ (directory exists)
```
- Both exist → **type = block-theme (FSE)**
- Only `style.css` with `Theme Name:` → **type = classic-theme**

### Step 3 — Detect Block Plugin

```
Glob: **/block.json
Glob: src/block.json, blocks/*/block.json
```

If `block.json` found alongside a plugin header → **type = block-plugin** (plugin that registers blocks).

### Step 4 — Detect Tooling

Run in parallel:

```
Read: composer.json          → PHP dependency management
Read: package.json           → JS build tooling
Read: wp-env.json            → Local dev environment config
Grep: "@wordpress/scripts"   → Block build toolchain
Grep: "wp-scripts"           → Confirms @wordpress/scripts usage
```

### Step 5 — Output Summary

Always end with this structured block:

```
━━━ WordPress Project Triage ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project type:  [plugin | classic-theme | block-theme | block-plugin | hybrid]
Has blocks:    [yes — found in: path/to/blocks/ | no]
Has FSE:       [yes (theme.json + templates/) | no]
PHP tooling:   [Composer (composer.json found) | none]
JS tooling:    [@wordpress/scripts | custom webpack | none]
Local env:     [wp-env (wp-env.json found) | none detected]
WP tested:     [6.x from plugin header or readme.txt | unknown]
PHP required:  [8.x from plugin header | unknown]

Next recommended skill:
  → [wp-block-development | wp-block-themes | wp-wpcli-and-ops | wp-developer agent]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Routing Guide

| Project type | Recommended next skill/agent |
|---|---|
| plugin (no blocks) | `wp-developer` agent |
| block-plugin | `wp-block-development` skill |
| block-theme (FSE) | `wp-block-themes` skill |
| classic-theme | `wp-developer` agent (theme functions) |
| Any + WP-CLI ops needed | `wp-wpcli-and-ops` skill |
| Any + Interactivity API | `wp-interactivity-api` skill |

## Notes

- If the project root is not the WordPress project root (e.g., running from a monorepo), check for `wp-content/` parent directories or ask the user to confirm the correct path.
- A project can be both a plugin AND have blocks (`block-plugin`). A block-theme is a theme that uses FSE.
- `wp-env.json` presence means the team uses `@wordpress/env` for local development — always check before recommending Docker or LAMP stack alternatives.
