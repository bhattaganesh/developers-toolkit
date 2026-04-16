# Internationalization (i18n) Requirements

WordPress.org requires all user-facing strings to be translatable. The Plugin Check tool specifically flags i18n violations.

---

## The Rules at a Glance

1. **Text domain must be a string literal** — never a variable
2. **Text domain must match the plugin slug** exactly
3. **Every user-facing string must use a translation function**
4. **Use escape-aware variants** (`esc_html__()`) — not raw `__()` + separate escaping
5. **Use `_n()` for plural strings** — not two separate `__()` calls
6. **Use `printf()`/`sprintf()` for variables** — never embed PHP variables in strings
7. **Add translator comments** for strings with abbreviations, placeholders, or context

---

## Text Domain Rules

```php
// ✅ Correct — string literal matches slug
__( 'Save Settings', 'my-plugin' )

// ❌ Wrong — variable text domain (static analysis tools cannot verify)
$domain = 'my-plugin';
__( 'Save Settings', $domain )

// ❌ Wrong — text domain doesn't match plugin slug
// Plugin slug: my-awesome-plugin
__( 'Save Settings', 'myawesomeplugin' )  // missing hyphens

// ❌ Wrong — missing text domain entirely
__( 'Save Settings' )
```

---

## Complete Translation Function Reference

### Basic Retrieval
| Function | Use | Escaping |
|---|---|---|
| `__( $text, $domain )` | Retrieve translation | None — must escape separately |
| `_e( $text, $domain )` | Echo translation | None — must escape separately |
| `_x( $text, $context, $domain )` | Retrieve with context | None |
| `_ex( $text, $context, $domain )` | Echo with context | None |

### Escape-Aware Variants (Preferred)
| Function | Use | Escaping |
|---|---|---|
| `esc_html__( $text, $domain )` | HTML content | `esc_html()` |
| `esc_html_e( $text, $domain )` | Echo HTML content | `esc_html()` |
| `esc_html_x( $text, $context, $domain )` | HTML with context | `esc_html()` |
| `esc_attr__( $text, $domain )` | HTML attribute | `esc_attr()` |
| `esc_attr_e( $text, $domain )` | Echo HTML attribute | `esc_attr()` |
| `esc_attr_x( $text, $context, $domain )` | Attribute with context | `esc_attr()` |

### Plural Forms
| Function | Use |
|---|---|
| `_n( $single, $plural, $number, $domain )` | Singular/plural |
| `_nx( $single, $plural, $number, $context, $domain )` | Plural with context |

### Localization Utilities
| Function | Use |
|---|---|
| `number_format_i18n( $number, $decimals )` | Locale-aware number formatting |
| `date_i18n( $format, $timestamp )` | Locale-aware date formatting |

---

## Preferred Pattern: Escape-Aware Functions

The Plugin Check tool and reviewers prefer escape-aware translation functions to eliminate a class of potential XSS bugs:

```php
// ❌ Not preferred — two separate calls, easy to forget escaping
echo esc_html( __( 'Settings', 'my-plugin' ) );

// ✅ Preferred — single call, cannot forget to escape
echo esc_html__( 'Settings', 'my-plugin' );

// ❌ _e() outputs without escaping — XSS risk
_e( 'Delete this item', 'my-plugin' );

// ✅ Use esc_html_e() instead
esc_html_e( 'Delete this item', 'my-plugin' );

// ❌ _ex() outputs without escaping
_ex( 'Draft', 'Post status', 'my-plugin' );

// ✅ Use esc_html_x() instead
echo esc_html_x( 'Draft', 'Post status', 'my-plugin' );
```

---

## Variables in Strings

Never embed PHP variables directly in translatable strings. Use `printf()` or `sprintf()`:

```php
// ❌ Wrong — variable inside string, translator sees $name literally
_e( "Hello $name!", 'my-plugin' );

// ❌ Wrong — concatenation breaks translation context
echo __( 'Hello', 'my-plugin' ) . ' ' . $name;

// ✅ Correct — use printf with placeholder
printf(
    /* translators: %s: user display name */
    esc_html__( 'Hello, %s!', 'my-plugin' ),
    esc_html( $name )
);

// ✅ Correct — multiple variables with numbered placeholders
printf(
    /* translators: 1: post title, 2: author name */
    esc_html__( 'The post "%1$s" was written by %2$s.', 'my-plugin' ),
    esc_html( $post->post_title ),
    esc_html( $author->display_name )
);
```

**Why numbered placeholders?** In some languages, word order is different. `%1$s` and `%2$s` allow translators to reorder the arguments.

---

## Plural Forms

```php
// ❌ Wrong — two separate strings, no plural logic
if ( $count === 1 ) {
    _e( 'One item', 'my-plugin' );
} else {
    _e( 'Multiple items', 'my-plugin' );
}

// ✅ Correct — use _n() for plural forms
printf(
    /* translators: %d: number of items */
    esc_html( _n( '%d item', '%d items', $count, 'my-plugin' ) ),
    $count
);
```

---

## Translator Comments

Add `/* translators: */` comments directly above any string with placeholders, abbreviations, or ambiguous context. These appear to translators in GlotPress and Poedit:

```php
/* translators: %s: post title */
printf( esc_html__( 'Post "%s" saved.', 'my-plugin' ), $title );

/* translators: 1: username, 2: post count */
printf( esc_html__( '%1$s has published %2$d posts.', 'my-plugin' ), $user, $count );

/* translators: Abbreviation for "Application Programming Interface" */
echo esc_html__( 'API Key', 'my-plugin' );

/* translators: Button label for dismissing the admin notice */
echo esc_html__( 'Dismiss', 'my-plugin' );
```

---

## Loading the Text Domain

### For WordPress.org Plugins (4.6+)

WordPress.org-hosted plugins have their translations managed by GlotPress (translate.wordpress.org). WordPress 4.6+ **automatically loads** the text domain — you do NOT need to call `load_plugin_textdomain()` for plugins in the official directory.

If you still want to include bundled translation files:

```php
add_action( 'init', 'myplugin_load_textdomain' );

function myplugin_load_textdomain() {
    load_plugin_textdomain(
        'my-plugin',
        false,
        dirname( plugin_basename( __FILE__ ) ) . '/languages/'
    );
}
```

### Translation File Structure

```
my-plugin/
└── languages/
    ├── my-plugin.pot          ← Template (source of truth for translators)
    ├── my-plugin-fr_FR.po     ← French translation (editable)
    ├── my-plugin-fr_FR.mo     ← French translation (compiled, used by WordPress)
    ├── my-plugin-de_DE.po
    └── my-plugin-de_DE.mo
```

---

## Generating the .pot File

```bash
# Using WP-CLI (recommended)
wp i18n make-pot /path/to/plugin /path/to/plugin/languages/my-plugin.pot

# The .pot file is the translation template
# Translators use it to create .po files for their language
# .mo files are compiled from .po files: msgfmt my-plugin-fr_FR.po -o my-plugin-fr_FR.mo
```

---

## Common i18n Mistakes That Cause Review Flags

| Mistake | Wrong | Correct |
|---|---|---|
| Variable text domain | `__( 'text', $domain )` | `__( 'text', 'my-plugin' )` |
| Missing text domain | `__( 'Save' )` | `__( 'Save', 'my-plugin' )` |
| Wrong text domain | `__( 'Save', 'my_plugin' )` | `__( 'Save', 'my-plugin' )` |
| _e() without escape | `_e( 'Delete', 'my-plugin' )` | `esc_html_e( 'Delete', 'my-plugin' )` |
| Variable in string | `__( "Hello $name" )` | `printf( __( 'Hello %s', 'my-plugin' ), $name )` |
| Separate plural strings | Two `__()` calls | `_n( 'item', 'items', $count, 'my-plugin' )` |
| Missing translator comment | No comment on `%s` placeholder | `/* translators: %s: post title */` |
| Empty string translated | `__( '', 'my-plugin' )` | Never translate empty strings |
| URL translated | `__( 'https://example.com' )` | Only translate locale-specific URLs |
| Concatenated strings | `__( 'Hello' ) . ' ' . __( 'World' )` | Single string: `__( 'Hello World' )` |

---

## Grep Commands for i18n Audit

```bash
PLUGIN_DIR="/path/to/plugin"

# Strings with missing text domain
grep -rn "__(\|_e(\|_n(\|_x(\|esc_html__(\|esc_attr__(\|esc_html_e(\|esc_attr_e(" --include="*.php" "$PLUGIN_DIR" | grep -v "'my-plugin'\|\"my-plugin\""

# Variable text domain (prohibited)
grep -rn "__(\|_e(\|esc_html__(" --include="*.php" "$PLUGIN_DIR" | grep "\$[a-z_]*[,)]"

# _e() usage (should be esc_html_e)
grep -rn "\b_e(\|_ex(" --include="*.php" "$PLUGIN_DIR"

# Direct variable in translatable string (prohibited)
grep -rn '__(.*\$\|_e(.*\$' --include="*.php" "$PLUGIN_DIR"

# Check for .pot file
ls "$PLUGIN_DIR/languages/"*.pot 2>/dev/null || echo "No .pot file found"
```
