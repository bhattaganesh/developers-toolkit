# Plugin Header Requirements

The plugin header is a comment block at the top of the main plugin PHP file. WordPress uses it to register the plugin.

## Complete Header Example

```php
<?php
/**
 * Plugin Name:       My Plugin
 * Plugin URI:        https://example.com/my-plugin
 * Description:       A brief description of the plugin — max 150 characters. No HTML.
 * Version:           1.0.0
 * Author:            Author Name
 * Author URI:        https://example.com
 * License:           GPL-2.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       my-plugin
 * Domain Path:       /languages
 * Requires at least: 6.0
 * Requires PHP:      7.4
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
```

## Field Reference

### Required Fields

| Field | Description | Rules |
|---|---|---|
| `Plugin Name` | Display name in the plugin list | Human readable; can contain spaces and capitalization |
| `Description` | Short plugin description | Max 150 characters; no HTML |
| `Version` | Current version number | Must use SemVer (e.g., `1.0.0`); must match `Stable tag` in readme.txt |
| `Author` | Developer name | Real name or organization name |
| `License` | License identifier | Must be GPL v2+, GPLv3, MIT, Apache 2.0, or another GPL-compatible license |
| `License URI` | Full URL to license text | Must be a working URL |
| `Text Domain` | i18n text domain | **Must exactly match the plugin slug** (the directory name / WordPress.org URL slug) |
| `Requires at least` | Minimum WordPress version | Numbers only (e.g., `6.0`); no "WordPress" prefix |

### Recommended Fields

| Field | Description | Notes |
|---|---|---|
| `Plugin URI` | Plugin homepage URL | Can be GitHub, a product page, or the WordPress.org page |
| `Author URI` | Author website URL | Developer or company homepage |
| `Requires PHP` | Minimum PHP version | Strongly recommended; numbers only (e.g., `7.4`, `8.0`) |
| `Domain Path` | Path to translation files | Required only if plugin includes a `/languages` directory |

## Common Header Mistakes

### ❌ Wrong: Version mismatch
```
Version: 1.0.0      ← plugin header
Stable tag: 1.1.0   ← readme.txt
```
These must be identical.

### ❌ Wrong: Text Domain doesn't match slug
```
Plugin slug (directory): my-awesome-plugin
Text Domain: myawesomeplugin     ← missing hyphens
```
Text Domain must be: `my-awesome-plugin`

### ❌ Wrong: Non-GPL-compatible license
```
License: Proprietary
License: CC BY-NC 4.0   ← non-commercial = not GPL-compatible
```

### ✅ Correct: GPL-compatible licenses
```
License: GPL-2.0-or-later
License: GPL-3.0-or-later
License: MIT
License: Apache-2.0
License: BSD-2-Clause
```

## Trademark / Naming Rules

- Plugin name must NOT start with a trademarked product name (e.g., ❌ "WooCommerce Payments" — use ✅ "Payments for WooCommerce")
- Plugin name must NOT be identical to an existing WordPress.org plugin
- Plugin name must NOT include competitor plugin names
- Plugin URL slug is permanent and cannot be changed after submission
