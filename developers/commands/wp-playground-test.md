---
description: Generate a WordPress Playground test environment for this plugin/theme — quick launch command or full blueprint.json
---

# WordPress Playground Test

Generate a ready-to-use WordPress Playground environment for the current project — either a one-line launch command for immediate testing or a full `blueprint.json` for reproducible, shareable environments.

## Instructions

1. **Detect the project** — Run triage:
   ```
   Grep: "Plugin Name:" in *.php      ← Plugin detection
   Read: style.css                     ← Theme detection
   Read: package.json                  ← JS tooling
   Glob: **/block.json                 ← Has blocks?
   Read: blueprint.json                ← Already has blueprint?
   ```

2. **Ask the user what they need**:
   - **Quick test** — just a launch command (fastest)
   - **Blueprint** — `blueprint.json` for reproducible setup with specific WP/PHP version, extra plugins, data
   - **Shareable** — blueprint + snapshot for sharing with team or clients

3. **Generate the appropriate output**:

### Option A — Quick Launch Command

For a plugin:
```bash
npx @wp-playground/cli@latest server \
    --mount=./{plugin-slug}:/wordpress/wp-content/plugins/{plugin-slug} \
    --wp=6.9 \
    --php=8.2
```

For a theme:
```bash
npx @wp-playground/cli@latest server \
    --mount=./{theme-slug}:/wordpress/wp-content/themes/{theme-slug} \
    --wp=6.9 \
    --php=8.2
```

For auto-mount (current directory is the plugin):
```bash
npx @wp-playground/cli@latest server --auto-mount --wp=6.9 --php=8.2
```

### Option B — Generate blueprint.json

Read the project and generate a `blueprint.json`:

```json
{
  "$schema": "https://playground.wordpress.net/blueprint-schema.json",
  "preferredVersions": {
    "wp": "6.9",
    "php": "8.2"
  },
  "siteOptions": {
    "blogname": "{Plugin/Theme Name} — Test Site"
  },
  "steps": [
    {
      "step": "login",
      "username": "admin",
      "password": "password"
    },
    {
      "step": "installPlugin",
      "pluginZipFile": {
        "resource": "vfs",
        "path": "/{plugin-slug}"
      },
      "options": { "activate": true }
    }
  ]
}
```

Write this to `blueprint.json` in the project root and tell the user:
```bash
npx @wp-playground/cli@latest server --blueprint=blueprint.json
```

4. **If project has WooCommerce, ACF, or other dependencies** — add `installPlugin` steps:
   ```json
   {
     "step": "installPlugin",
     "pluginZipFile": {
       "resource": "wordpress.org/plugins",
       "slug": "woocommerce"
     }
   }
   ```

5. **Version testing** — if user wants to test on multiple WordPress versions:
   ```bash
   # WP 6.9
   npx @wp-playground/cli@latest server --auto-mount --wp=6.9
   # WP 6.4
   npx @wp-playground/cli@latest server --auto-mount --wp=6.4
   ```

6. **Output clearly**:
   - The launch command the user should run
   - What the generated `blueprint.json` contains
   - Any detected dependencies that were included

## Notes

- WordPress Playground requires Node.js ≥ 20.18. Check with `node --version`.
- Files in `--mount` paths sync in real time — no restart needed when you edit code.
- Default credentials: `admin` / `password`
- The admin URL is shown in the terminal when the server starts.
