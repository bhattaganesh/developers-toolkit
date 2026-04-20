# block.json Complete Reference

Complete field reference for block.json (WordPress 6.9+). All fields are optional unless marked **Required**.

## Top-Level Fields

| Field | Type | Notes |
|---|---|---|
| `$schema` | string | Always include: `https://schemas.wp.org/trunk/block.json` |
| `apiVersion` | integer | **Required. Use 3.** v3 = iframe editor support (WP 6.0+). v2 = deprecated editor context. |
| `name` | string | **Required.** Format: `namespace/block-name`. Namespace = plugin slug. |
| `version` | string | Block version (semver). Used for cache busting. |
| `title` | string | **Required.** Human-readable name shown in block inserter. |
| `category` | string | Inserter category: `text`, `media`, `design`, `widgets`, `theme`, `embed`, `common` |
| `parent` | array | Restrict block to only appear inside specific parent blocks: `["my-plugin/container"]` |
| `ancestor` | array | Restrict to appear anywhere inside specific ancestor blocks (less strict than `parent`). |
| `allowedBlocks` | array | When this block is a container, restrict what inner blocks it accepts. |
| `icon` | string/object | Dashicons slug (`"star-filled"`) or SVG object. |
| `description` | string | Short description shown in block inserter tooltip. |
| `keywords` | array | Search keywords: `["accordion", "faq", "collapse"]` |
| `textdomain` | string | Translation text domain. |
| `attributes` | object | Block data definition — see Attributes section below. |
| `providesContext` | object | Values this block provides to child blocks via context. |
| `usesContext` | array | Context keys this block reads from parent: `["postId", "postType"]` |
| `selectors` | object | CSS selectors used for block style generation. |
| `supports` | object | Feature flags — see Supports section below. |
| `blockTemplates` | array | Default inner block template when block is inserted. |
| `transforms` | object | Transform rules to/from other blocks. Defined in JS, not block.json. |
| `variations` | array | Block variations (predefined attribute sets). |
| `styles` | array | Named style variations selectable in the block toolbar. |
| `example` | object | Preview data shown in block inserter. |
| `editorScript` | string/array | JS file(s) loaded in editor only: `"file:./index.js"` |
| `script` | string/array | JS file(s) loaded in both editor and frontend. |
| `viewScript` | string/array | JS file(s) loaded on frontend only (classic scripts, not modules). |
| `viewScriptModule` | string/array | ES module loaded on frontend — **use this for Interactivity API**. |
| `editorStyle` | string/array | CSS loaded in editor only: `"file:./index.css"` |
| `style` | string/array | CSS loaded in both editor and frontend: `"file:./style-index.css"` |
| `viewStyle` | string/array | CSS loaded on frontend only. |
| `render` | string | PHP file for dynamic blocks: `"file:./render.php"` |

## Attributes

Each attribute defines a piece of block data:

```json
"attributes": {
  "fieldName": {
    "type": "string",
    "default": "",
    "source": "html",
    "selector": "p",
    "attribute": "href"
  }
}
```

### Attribute Types

| Type | Use for |
|---|---|
| `string` | Text content |
| `number` | Numeric values |
| `boolean` | Toggles |
| `array` | Lists of items |
| `object` | Structured data |
| `null` | Explicitly nullable |

### Source Options

| Source | What it does |
|---|---|
| `"html"` | Reads inner HTML of `selector` element |
| `"text"` | Reads text content of `selector` (strips tags) |
| `"attribute"` | Reads a specific HTML attribute (`attribute` field required) |
| `"query"` | Reads an array of values from repeated elements |
| `"meta"` | Reads post meta (use carefully — not serialized in post content) |
| (none) | Attribute stored in block comment delimiter — default for most custom data |

## Supports

```json
"supports": {
  "html": false,
  "align": ["wide", "full"],
  "color": {
    "background": true,
    "text": true,
    "gradients": true
  },
  "spacing": {
    "margin": true,
    "padding": true,
    "blockGap": true
  },
  "typography": {
    "fontSize": true,
    "lineHeight": true
  },
  "layout": {
    "default": { "type": "flex" }
  },
  "interactivity": true
}
```

### Key Support Flags

| Flag | Effect |
|---|---|
| `"html": false` | Disables "Edit as HTML" in block toolbar — recommended for most blocks |
| `"align"` | Enables alignment toolbar. `true` = all alignments, or array of specific ones |
| `"color"` | Enables color settings in sidebar |
| `"spacing"` | Enables margin/padding/gap controls |
| `"typography"` | Enables font size and line height controls |
| `"interactivity": true` | Required when using the Interactivity API |
| `"multiple": false` | Prevent inserting more than one instance of this block per post |
| `"reusable": false` | Prevent saving as reusable block |
| `"lock": false` | Prevent locking/unlocking by users |

## Block Variations

Predefined configurations shown in the inserter as separate entries:

```json
"variations": [
  {
    "name": "my-plugin/my-block-alert",
    "title": "Alert",
    "description": "Alert style block",
    "attributes": { "className": "is-style-alert" },
    "isDefault": false,
    "scope": ["inserter", "transform"]
  }
]
```

## Named Styles

Selectable in the block toolbar under "Styles":

```json
"styles": [
  { "name": "default", "label": "Default", "isDefault": true },
  { "name": "outline", "label": "Outline" },
  { "name": "fill", "label": "Fill" }
]
```

CSS class added: `is-style-{name}`.

## WP 6.9+ Specific Notes

- **`apiVersion: 3` is mandatory** for iframe editor. Blocks with `apiVersion: 2` still work but show in legacy editor context.
- **`viewScriptModule`** (not `viewScript`) for Interactivity API — ES modules only.
- **`render`** field enables dynamic rendering without manual `render_callback` in PHP registration.
- **`"supports": { "interactivity": true }`** required to opt into Interactivity API processing.
- On-demand CSS: WP 6.9 loads block styles on-demand by default for classic themes. Test that `style` CSS loads when block is on the page.
