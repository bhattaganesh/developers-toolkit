# readme.txt Requirements

The `readme.txt` file tells WordPress.org everything about your plugin for the directory listing.

## Full Template

```
=== Plugin Name ===
Contributors: wpusername1, wpusername2
Donate link: https://example.com/donate
Tags: tag1, tag2, tag3
Requires at least: 6.0
Tested up to: 6.7
Stable tag: 1.0.0
Requires PHP: 7.4
License: GPL-2.0-or-later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Short description — max 150 characters. No markup. This appears in search results.

== Description ==

Full description of your plugin. Markdown-like formatting supported:
* Bullet points
* **Bold text**
* `code`

Link to external service: [Service Name](https://example.com).
[Terms of Service](https://example.com/tos) | [Privacy Capability](https://example.com/privacy)

== Installation ==

1. Upload the plugin files to the `/wp-content/plugins/plugin-name` directory, or install the plugin through the WordPress plugins screen directly.
2. Activate the plugin through the 'Plugins' screen in WordPress.
3. Use the Settings->Plugin Name screen to configure the plugin.

== Frequently Asked Questions ==

= A question that someone might have =

The answer to the question.

= Does this plugin send data to external services? =

This plugin connects to example.com to [explain what data is sent].
[Terms of Service](https://example.com/tos) | [Privacy Capability](https://example.com/privacy)

== Screenshots ==

1. This screen shot description corresponds to screenshot-1.(png|jpg|jpeg|gif).
2. This is the second screen shot.

== Changelog ==

= 1.0.0 =
* Initial release
* Feature A
* Feature B

== Upgrade Notice ==

= 1.0.0 =
Initial release.
```

## Field Rules

### Header Fields

| Field | Required | Rule |
|---|---|---|
| `Plugin Name` (in `=== ===`) | ✅ | Must match the Plugin Name in the main PHP file header |
| `Contributors` | ✅ | Lowercase WordPress.org usernames, comma-separated. If organization submitted, use org account |
| `Tags` | ✅ | **Maximum 5 tags**; no competitor names; no keyword stuffing; use real descriptive terms |
| `Requires at least` | ✅ | Minimum WP version; must match plugin header |
| `Tested up to` | ✅ | Latest WP major version tested (e.g., `6.7`); do NOT put a future version |
| `Stable tag` | ✅ | **Must be a version number — NEVER `trunk`**; must match `Version` in plugin header |
| `License` | ✅ | GPL-compatible license identifier |
| `Short Description` | ✅ (after headers) | Max 150 characters; no HTML; appears in search results |
| `Requires PHP` | ⚠️ Recommended | Minimum PHP version (e.g., `7.4`) |
| `Donate link` | Optional | URL to donation page |

### Sections

| Section | Required | Notes |
|---|---|---|
| `== Description ==` | ✅ | Full plugin description |
| `== Installation ==` | If non-standard setup | Only needed if setup isn't the standard activate-and-go |
| `== Changelog ==` | ✅ | At minimum one entry for current version |
| `== Frequently Asked Questions ==` | Optional | Useful for reducing support requests |
| `== Screenshots ==` | Optional | Filenames: `screenshot-1.png`, `screenshot-2.jpg` in plugin root |
| `== Upgrade Notice ==` | Optional | Short note for users upgrading from older versions |

## Critical Rules (Rejection Causes)

### 1. Stable tag must NEVER be `trunk`
```
Stable tag: trunk    ← ❌ REJECTED for new plugins
Stable tag: 1.0.0    ← ✅ Correct
```

### 2. Version mismatch = auto-rejection
```
# readme.txt
Stable tag: 1.0.0

# main-plugin.php
Version: 1.1.0      ← ❌ Mismatch — will be flagged
```

### 3. Tags — maximum 5, no keyword stuffing
```
Tags: keyword stuffing, seo, best plugin, number one, free plugin, wordpress plugin, amazing   ← ❌ Too many + spam
Tags: contact form, form builder, email, captcha, spam    ← ✅ 5 relevant tags
```

### 4. Tested up to — do not use future versions
```
Tested up to: 7.0   ← ❌ WP 7.0 doesn't exist yet
Tested up to: 6.7   ← ✅ Latest stable version
```

### 5. Short description — max 150 characters
```
Short description: This is the best plugin ever created for WordPress that does everything you need and more — buy premium! ← ❌ Too long + promotional
Short description: Easily create beautiful contact forms with drag-and-drop, email notifications, and spam protection.    ← ✅ Concise and descriptive
```

### 6. External service disclosure (required if applicable)
If your plugin connects to an external service, the Description section MUST include:
- What data is sent to the service
- A link to the service's Terms of Service
- A link to the service's Privacy Capability

### 7. File size
- Keep readme.txt under 10KB
- Archive old changelog entries to a separate file if the changelog grows large

## Readme Validator

Before submitting, validate your readme.txt at:
https://wordpress.org/plugins/developers/readme-validator/

## Tags Reference

Good tag examples:
- `contact form`, `form builder`, `email`, `captcha`, `spam protection`
- `ecommerce`, `shop`, `cart`, `checkout`, `payment`
- `seo`, `sitemap`, `schema`, `meta tags`, `open graph`
- `backup`, `migration`, `import`, `export`, `database`
- `security`, `firewall`, `login`, `two factor`, `spam`

