---
name: wp-block-themes
description: >
  This skill should be used when the user asks to "create a block theme", "build an FSE theme",
  "edit theme.json", "add a block template", "create template parts", "add a pattern to a theme",
  "create style variations", "customize the site editor", "add a style preset", "configure typography
  in theme.json", "add color palette to theme", or when editing files in a theme's templates/,
  parts/, patterns/, or styles/ directories.
version: 1.0.0
tools: Read, Write, Edit, Glob, Grep
---

# WordPress Block Themes (FSE)

Full Site Editing (FSE) block theme development — `theme.json`, templates, template parts, patterns, and style variations. Block themes replace the classic `functions.php` + PHP template hierarchy with block markup and declarative JSON configuration.

## Quick Triage

Before doing anything, check:
```
Glob: theme.json (root)
Glob: templates/ (directory)
Glob: parts/ (directory)
```

If `theme.json` + `templates/` exist → it's a block theme. If only `style.css` with `Theme Name:` → it's a classic theme (different approach).

## theme.json — The Central Config

Every block theme has `theme.json` at the root. This is the single source of truth for design tokens, block defaults, and editor settings.

### Minimum Valid theme.json

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": {
    "appearanceTools": true
  }
}
```

`"appearanceTools": true` enables color, typography, spacing, border, and shadow controls in the Site Editor with one flag.

### Full settings Structure

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": {
    "appearanceTools": true,
    "color": {
      "palette": [
        { "slug": "primary",    "color": "#1e40af", "name": "Primary" },
        { "slug": "secondary",  "color": "#64748b", "name": "Secondary" },
        { "slug": "accent",     "color": "#f59e0b", "name": "Accent" },
        { "slug": "base",       "color": "#ffffff", "name": "Background" },
        { "slug": "contrast",   "color": "#0f172a", "name": "Foreground" }
      ],
      "gradients": [
        { "slug": "hero", "gradient": "linear-gradient(135deg, #1e40af, #7c3aed)", "name": "Hero" }
      ],
      "custom": true,
      "customDuotone": false
    },
    "typography": {
      "fontFamilies": [
        {
          "fontFamily": "Inter, sans-serif",
          "slug": "body",
          "name": "Body"
        },
        {
          "fontFamily": "Georgia, serif",
          "slug": "heading",
          "name": "Heading"
        }
      ],
      "fontSizes": [
        { "slug": "small",   "size": "0.875rem", "name": "Small" },
        { "slug": "medium",  "size": "1rem",     "name": "Medium" },
        { "slug": "large",   "size": "1.25rem",  "name": "Large" },
        { "slug": "x-large", "size": "1.5rem",   "name": "Extra Large" },
        { "slug": "huge",    "size": "2.25rem",  "name": "Huge" }
      ],
      "fluid": true
    },
    "spacing": {
      "spacingScale": {
        "operator": "*",
        "increment": 1.5,
        "steps": 7,
        "mediumStep": 1.5,
        "unit": "rem"
      },
      "spacingSizes": [
        { "slug": "20", "size": "0.44rem",  "name": "2XS" },
        { "slug": "30", "size": "0.67rem",  "name": "XS" },
        { "slug": "40", "size": "1rem",     "name": "S" },
        { "slug": "50", "size": "1.5rem",   "name": "M" },
        { "slug": "60", "size": "2.25rem",  "name": "L" },
        { "slug": "70", "size": "3.38rem",  "name": "XL" },
        { "slug": "80", "size": "5.06rem",  "name": "2XL" }
      ],
      "padding": true,
      "margin": true,
      "units": ["px", "%", "em", "rem", "vw", "vh"]
    },
    "layout": {
      "contentSize": "800px",
      "wideSize": "1200px"
    }
  },
  "styles": {
    "color": {
      "background": "var(--wp--preset--color--base)",
      "text": "var(--wp--preset--color--contrast)"
    },
    "typography": {
      "fontFamily": "var(--wp--preset--font-family--body)",
      "fontSize": "var(--wp--preset--font-size--medium)",
      "lineHeight": "1.6"
    },
    "elements": {
      "h1": { "typography": { "fontSize": "var(--wp--preset--font-size--huge)" } },
      "h2": { "typography": { "fontSize": "var(--wp--preset--font-size--x-large)" } },
      "link": {
        "color": { "text": "var(--wp--preset--color--primary)" },
        ":hover": { "color": { "text": "var(--wp--preset--color--accent)" } }
      }
    }
  }
}
```

### Design Token Auto-Generation

WordPress auto-generates CSS custom properties from theme.json presets:

| theme.json | CSS Custom Property |
|---|---|
| color slug `primary` | `--wp--preset--color--primary` |
| font size slug `large` | `--wp--preset--font-size--large` |
| font family slug `body` | `--wp--preset--font-family--body` |
| spacing slug `50` | `--wp--preset--spacing--50` |
| Custom `spacing.large` | `--wp--custom--spacing--large` |

Use these in CSS and in theme.json styles — never hardcode hex values.

See `references/theme-json-v3-reference.md` for complete field reference.

## Style Hierarchy

Understanding this prevents cascade fights:

```
WP Core defaults
    ↓
theme.json (settings + styles)
    ↓
Child theme's theme.json
    ↓
User customizations (Site Editor → Styles)
```

**Rule:** Work with the cascade, not against it. If you can set it in theme.json, do it there — don't override via CSS class hacks.

## Templates (`templates/`)

Each `.html` file is a page template using block markup.

### Required Template

```
templates/index.html    ← Required — fallback for all content types
```

### Common Templates

```
templates/
├── index.html          ← Required fallback
├── home.html           ← Blog home (if different from index)
├── single.html         ← Single post
├── page.html           ← Static page
├── archive.html        ← Archive/taxonomy
├── search.html         ← Search results
├── 404.html            ← Not found
└── single-{post-type}.html  ← Custom post type single view
```

### Template Block Markup

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->

<!-- wp:group {"tagName":"main","layout":{"type":"constrained"}} -->
<main class="wp-block-group">
    <!-- wp:post-content /-->
</main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

## Template Parts (`parts/`)

Reusable regions included in templates. **No nesting** — template parts cannot include other template parts.

```
parts/
├── header.html         ← Site header
├── footer.html         ← Site footer
└── sidebar.html        ← Sidebar (optional)
```

Register template parts in theme.json:

```json
"templateParts": [
  { "name": "header", "title": "Header", "area": "header" },
  { "name": "footer", "title": "Footer", "area": "footer" },
  { "name": "sidebar", "title": "Sidebar", "area": "uncategorized" }
]
```

## Patterns (`patterns/`)

PHP files with block markup. Appear in the block inserter's Patterns tab.

```php
<?php
/**
 * Title: Hero Section
 * Slug: my-theme/hero-section
 * Categories: featured, my-theme
 * Description: Full-width hero with heading and CTA button.
 * Keywords: hero, banner, cta
 * Block Types: core/cover
 */
?>
<!-- wp:cover {"overlayColor":"primary","isDark":true,"align":"full"} -->
<div class="wp-block-cover alignfull is-dark has-primary-background-color">
    <div class="wp-block-cover__inner-container">
        <!-- wp:heading {"textAlign":"center","level":1} -->
        <h1 class="wp-block-heading has-text-align-center">Welcome to our site</h1>
        <!-- /wp:heading -->

        <!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
        <div class="wp-block-buttons">
            <!-- wp:button {"backgroundColor":"accent"} -->
            <div class="wp-block-button"><a class="wp-block-button__link has-accent-background-color wp-element-button">Get Started</a></div>
            <!-- /wp:button -->
        </div>
        <!-- /wp:buttons -->
    </div>
</div>
<!-- /wp:cover -->
```

## Style Variations (`styles/`)

Each JSON file provides an alternate visual style selectable in Appearance → Editor → Styles.

```json
// styles/dark.json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "title": "Dark",
  "styles": {
    "color": {
      "background": "#0f172a",
      "text": "#f8fafc"
    },
    "elements": {
      "link": {
        "color": { "text": "#93c5fd" }
      }
    }
  }
}
```

## Required theme.json in child themes

Child block themes must also have `theme.json`. Use `$schema` and `version: 3`:

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": {
    "color": {
      "palette": [
        { "slug": "primary", "color": "#new-color", "name": "Primary" }
      ]
    }
  }
}
```

Child theme's theme.json merges with parent's — only override what you need to change.

## Quality Checklist

- [ ] `theme.json` has `"$schema"` and `"version": 3`
- [ ] `templates/index.html` exists (required fallback)
- [ ] Template parts registered in `theme.json templateParts`
- [ ] Design tokens use `--wp--preset--*` (not hardcoded hex)
- [ ] Patterns have correct PHP file headers (Title, Slug, Categories)
- [ ] Style variations in `styles/` directory have `"title"` field
- [ ] Test in Site Editor (Appearance → Editor) — not just frontend

## References

- [theme.json v3 complete reference](references/theme-json-v3-reference.md)
- [Templates and patterns guide](references/templates-and-patterns-guide.md)
