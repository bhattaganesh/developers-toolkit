---
name: wp-playground
description: >
  This skill should be used when the user asks to "test this in WordPress Playground",
  "create a disposable WordPress environment", "run WordPress locally without Docker",
  "create a WordPress Blueprint", "share a WordPress demo link", "test on a specific WordPress version",
  "test this plugin quickly without installing WordPress", "generate a wp.new link",
  "spin up a quick WordPress test", or "create a reproducible WordPress environment".
version: 1.0.0
tools: Read, Write, Bash
---

# WordPress Playground

Disposable WordPress environments in seconds via Node.js. No Docker, no LAMP stack, no LocalWP. Requires Node.js ≥ 20.18.

## Quick Start (30 Seconds)

```bash
# Mounts current directory as a plugin automatically
npx @wp-playground/cli@latest server --auto-mount
```

Opens a browser tab with your plugin installed and active. Files sync in real time.

## Mount Your Plugin / Theme

```bash
# Mount plugin
npx @wp-playground/cli@latest server \
    --mount=./my-plugin:/wordpress/wp-content/plugins/my-plugin

# Mount theme
npx @wp-playground/cli@latest server \
    --mount=./my-theme:/wordpress/wp-content/themes/my-theme

# Mount both
npx @wp-playground/cli@latest server \
    --mount=./my-plugin:/wordpress/wp-content/plugins/my-plugin \
    --mount=./my-theme:/wordpress/wp-content/themes/my-theme
```

## Version Testing

```bash
# Test on specific WordPress + PHP version
npx @wp-playground/cli@latest server --wp=6.9 --php=8.2 --auto-mount

# Test on older version
npx @wp-playground/cli@latest server --wp=6.4 --php=8.1 --auto-mount

# Latest nightly
npx @wp-playground/cli@latest server --wp=nightly --auto-mount
```

## Run a Blueprint (Reproducible Environment)

```bash
# Run from a blueprint.json file
npx @wp-playground/cli@latest server --blueprint=blueprint.json

# Run a blueprint and keep it open
npx @wp-playground/cli@latest server --blueprint=blueprint.json --auto-open
```

## Blueprint JSON

`blueprint.json` at project root for declarative setup:

```json
{
  "$schema": "https://playground.wordpress.net/blueprint-schema.json",
  "preferredVersions": {
    "wp": "6.9",
    "php": "8.2"
  },
  "features": {
    "networking": true
  },
  "siteOptions": {
    "blogname": "My Plugin Test Site",
    "blogdescription": "Testing my plugin"
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
        "resource": "url",
        "url": "https://downloads.wordpress.org/plugin/woocommerce.latest-stable.zip"
      }
    },
    {
      "step": "activatePlugin",
      "pluginPath": "woocommerce/woocommerce.php"
    },
    {
      "step": "installPlugin",
      "pluginZipFile": {
        "resource": "vfs",
        "path": "/plugin"
      }
    },
    {
      "step": "runPHP",
      "code": "<?php update_option('my_plugin_setting', 'test-value'); ?>"
    },
    {
      "step": "setSiteOptions",
      "options": {
        "active_plugins": ["my-plugin/my-plugin.php"]
      }
    }
  ]
}
```

### Common Blueprint Steps

| Step | Purpose |
|---|---|
| `login` | Auto-log in as admin |
| `installPlugin` | Install plugin from URL, zip, or virtual filesystem |
| `activatePlugin` | Activate by path |
| `installTheme` | Install theme from URL or zip |
| `activateTheme` | Activate by slug |
| `runPHP` | Execute PHP code |
| `runPHPWithOptions` | Execute PHP with custom ini |
| `writeFile` | Write a file into the WP install |
| `setSiteOptions` | Set `wp_options` values |
| `defineWpConfigConsts` | Define wp-config.php constants |
| `importWxr` | Import WordPress export XML |
| `importSQLFile` | Import a SQL file |
| `enableMultisite` | Convert to Multisite |

### Resource Types for installPlugin / installTheme

```json
// From WordPress.org
{ "resource": "wordpress.org/plugins", "slug": "woocommerce" }

// From URL
{ "resource": "url", "url": "https://example.com/my-plugin.zip" }

// Local file (virtual filesystem — mount it first)
{ "resource": "vfs", "path": "/plugin" }

// Inline file content
{ "resource": "literal", "name": "file.txt", "contents": "Hello world" }
```

## Build a Shareable Snapshot

```bash
# Build a shareable snapshot ZIP
npx @wp-playground/cli@latest build-snapshot \
    --blueprint=blueprint.json \
    --output=my-site-snapshot.zip
```

Share the ZIP or host it — users run it with:
```bash
npx @wp-playground/cli@latest server --snapshot=my-site-snapshot.zip
```

## Debugging in Playground

```bash
# Enable Xdebug
npx @wp-playground/cli@latest server \
    --auto-mount \
    --php-extension=xdebug \
    --wp=6.9 \
    --php=8.2

# View PHP error log
# In browser console: window.playground.run({ code: "<?php echo file_get_contents(ini_get('error_log')); ?>" })
```

## Run Headless (CI/CD)

```bash
# Run blueprint and exit
npx @wp-playground/cli@latest run-blueprint \
    --blueprint=blueprint.json \
    --php-code="<?php echo 'Tests passed: ' . (1 + 1 === 2 ? 'yes' : 'no'); ?>"
```

## Generate blueprint.json from Current Project

When a user wants a blueprint for their existing plugin, generate it by:

1. Read main plugin file → extract plugin slug, file path
2. Read `composer.json` / `package.json` → detect dependencies
3. Read existing `blueprint.json` if present (update rather than overwrite)

Generated blueprint pattern:

```json
{
  "$schema": "https://playground.wordpress.net/blueprint-schema.json",
  "preferredVersions": { "wp": "6.9", "php": "8.2" },
  "steps": [
    { "step": "login" },
    {
      "step": "installPlugin",
      "pluginZipFile": { "resource": "vfs", "path": "/plugin" }
    },
    {
      "step": "activatePlugin",
      "pluginPath": "{plugin-slug}/{plugin-main-file}"
    }
  ]
}
```

Then tell the user to run:
```bash
npx @wp-playground/cli@latest server --blueprint=blueprint.json
```
