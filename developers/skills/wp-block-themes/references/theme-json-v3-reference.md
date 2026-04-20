# theme.json v3 — Complete Reference

WordPress 6.9+ theme.json v3 field reference.

## Top-Level Structure

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": { },
  "styles": { },
  "customTemplates": [ ],
  "templateParts": [ ],
  "patterns": [ ]
}
```

---

## settings

Controls what features are available in the Site Editor and what CSS is generated.

### settings.appearanceTools

```json
"appearanceTools": true
```

Master switch. Enables: border, color, spacing, typography, and shadow controls. Individual sections can still be disabled if needed.

### settings.color

```json
"color": {
  "background": true,         // Background color picker
  "text": true,               // Text color picker
  "link": true,               // Link color picker
  "heading": true,            // Heading color picker
  "button": true,             // Button color picker
  "caption": true,            // Caption color picker
  "custom": true,             // Allow custom hex colors
  "customDuotone": true,      // Allow custom duotone
  "customGradient": true,     // Allow custom gradients
  "defaultDuotone": true,     // Show core duotone presets
  "defaultGradients": true,   // Show core gradient presets
  "defaultPalette": true,     // Show core color palette
  "duotone": [ ],             // Custom duotone presets
  "gradients": [ ],           // Custom gradient presets
  "palette": [ ]              // Custom color palette
}
```

Color palette entry:
```json
{ "slug": "primary", "color": "#1e40af", "name": "Primary Blue" }
```

CSS generated: `--wp--preset--color--primary: #1e40af`

### settings.typography

```json
"typography": {
  "customFontSize": true,
  "dropCap": true,
  "fluid": true,              // Enable fluid (clamp) font sizes
  "fontFamilies": [ ],
  "fontSizes": [ ],
  "fontStyle": true,
  "fontWeight": true,
  "letterSpacing": true,
  "lineHeight": true,
  "textColumns": true,
  "textDecoration": true,
  "textTransform": true,
  "writingMode": true
}
```

Font family entry:
```json
{
  "fontFamily": "Inter, system-ui, sans-serif",
  "slug": "body",
  "name": "Body",
  "fontFace": [
    {
      "fontFamily": "Inter",
      "fontWeight": "100 900",
      "fontStyle": "normal",
      "fontDisplay": "swap",
      "src": [ "file:./assets/fonts/Inter.woff2" ]
    }
  ]
}
```

Font size entry (with fluid):
```json
{
  "slug": "large",
  "name": "Large",
  "size": "1.25rem",
  "fluid": { "min": "1rem", "max": "1.5rem" }
}
```

CSS generated: `--wp--preset--font-family--body`, `--wp--preset--font-size--large`

### settings.spacing

```json
"spacing": {
  "blockGap": true,
  "margin": true,
  "padding": true,
  "units": ["px", "%", "em", "rem", "vw", "vh"],
  "spacingSizes": [ ],
  "spacingScale": { }
}
```

Spacing size entry:
```json
{ "slug": "40", "size": "1rem", "name": "S" }
```

CSS generated: `--wp--preset--spacing--40: 1rem`

### settings.layout

```json
"layout": {
  "contentSize": "800px",     // Default content width
  "wideSize": "1200px",       // Wide alignment width
  "allowEditing": true        // Users can change layout in editor
}
```

### settings.border

```json
"border": {
  "color": true,
  "radius": true,
  "style": true,
  "width": true
}
```

### settings.shadow

```json
"shadow": {
  "defaultPresets": true,
  "presets": [
    { "slug": "natural", "shadow": "6px 6px 9px rgba(0,0,0,0.2)", "name": "Natural" },
    { "slug": "deep",    "shadow": "12px 12px 50px rgba(0,0,0,0.4)", "name": "Deep" }
  ]
}
```

CSS generated: `--wp--preset--shadow--natural`

### settings.custom

Define arbitrary CSS custom properties:

```json
"custom": {
  "spacing": {
    "small": "1rem",
    "medium": "2rem",
    "large": "4rem"
  },
  "line-height": {
    "body": 1.6,
    "heading": 1.2
  },
  "transition": "all 0.2s ease"
}
```

CSS generated: 
- `--wp--custom--spacing--small: 1rem`
- `--wp--custom--line-height--body: 1.6`
- `--wp--custom--transition: all 0.2s ease`

### settings.blocks

Override settings per block type:

```json
"blocks": {
  "core/button": {
    "border": { "radius": true }
  },
  "core/pullquote": {
    "border": { "color": true, "width": true }
  }
}
```

---

## styles

Applies CSS to the document and blocks.

### Global Styles

```json
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
  "spacing": {
    "blockGap": "var(--wp--preset--spacing--50)"
  }
}
```

### Element Styles

```json
"styles": {
  "elements": {
    "h1": {
      "typography": {
        "fontSize": "var(--wp--preset--font-size--huge)",
        "fontFamily": "var(--wp--preset--font-family--heading)",
        "lineHeight": "1.2"
      }
    },
    "h2": { "typography": { "fontSize": "var(--wp--preset--font-size--x-large)" } },
    "h3": { "typography": { "fontSize": "var(--wp--preset--font-size--large)" } },
    "button": {
      "color": {
        "background": "var(--wp--preset--color--primary)",
        "text": "#ffffff"
      },
      "border": { "radius": "4px" },
      ":hover": {
        "color": { "background": "var(--wp--preset--color--accent)" }
      }
    },
    "link": {
      "color": { "text": "var(--wp--preset--color--primary)" },
      "typography": { "textDecoration": "underline" },
      ":hover": {
        "color": { "text": "var(--wp--preset--color--secondary)" },
        "typography": { "textDecoration": "none" }
      }
    }
  }
}
```

Supported elements: `button`, `caption`, `cite`, `code`, `heading`, `h1`–`h6`, `link`, `ol`, `ul`, `label`

### Block-Level Styles

```json
"styles": {
  "blocks": {
    "core/navigation": {
      "typography": { "fontSize": "var(--wp--preset--font-size--small)" }
    },
    "core/site-title": {
      "typography": { "fontFamily": "var(--wp--preset--font-family--heading)" }
    },
    "core/group": {
      "spacing": { "padding": { "top": "4rem", "bottom": "4rem" } }
    }
  }
}
```

---

## customTemplates

Register custom page templates:

```json
"customTemplates": [
  {
    "name": "blank",
    "title": "Blank",
    "postTypes": ["page"]
  },
  {
    "name": "full-width",
    "title": "Full Width",
    "postTypes": ["page", "post"]
  }
]
```

Template file: `templates/blank.html`, `templates/full-width.html`

---

## templateParts

Register available template parts:

```json
"templateParts": [
  { "name": "header",  "title": "Header",  "area": "header" },
  { "name": "footer",  "title": "Footer",  "area": "footer" },
  { "name": "sidebar", "title": "Sidebar", "area": "uncategorized" }
]
```

`area` values: `header`, `footer`, `sidebar`, `uncategorized`

---

## patterns

Reference patterns from the WordPress.org pattern directory by slug:

```json
"patterns": ["my-theme/hero-section", "my-theme/cta-block"]
```

Local patterns in `patterns/` directory are auto-registered by slug from the PHP file header.

---

## Version History

| Version | WordPress | Changes |
|---|---|---|
| v3 | 6.6+ | Current. Added shadow presets, writing mode, improved fluid type |
| v2 | 5.8–6.5 | Added patterns, customTemplates, templateParts |
| v1 | 5.8 | Initial release |

Always use `"version": 3` for new themes. WP 6.9 is fully compatible with v3.
