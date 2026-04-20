# Templates and Patterns Guide

## Template Hierarchy

WordPress resolves which template to use using this priority order (highest wins):

| Template file | Used for |
|---|---|
| `embed.html` | Embedded posts |
| `404.html` | Not found page |
| `search.html` | Search results |
| `home.html` | Blog home page (if using a static front page) |
| `privacy-policy.html` | Privacy policy page |
| `singular.html` | Single post OR single page fallback |
| `single-{post-type}-{slug}.html` | Single post of type with specific slug |
| `single-{post-type}.html` | Single post of custom post type |
| `single.html` | Any single post |
| `page-{slug}.html` | Specific page by slug |
| `page-{id}.html` | Specific page by ID |
| `page.html` | Any static page |
| `archive-{post-type}.html` | Archive for custom post type |
| `archive.html` | Any archive |
| `author-{nicename}.html` | Author archive by username |
| `author-{id}.html` | Author archive by ID |
| `author.html` | Any author archive |
| `category-{slug}.html` | Category by slug |
| `category-{id}.html` | Category by ID |
| `category.html` | Any category archive |
| `tag-{slug}.html` | Tag by slug |
| `tag.html` | Any tag archive |
| `taxonomy-{tax}-{term}.html` | Custom taxonomy + term |
| `taxonomy-{tax}.html` | Custom taxonomy |
| `taxonomy.html` | Any taxonomy |
| `index.html` | **Required fallback** — everything not matched above |

## Template Block Markup Patterns

### Minimal index.html

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->

<!-- wp:group {"tagName":"main","layout":{"type":"constrained"}} -->
<main class="wp-block-group">
    <!-- wp:post-content /-->
</main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

### Single Post Template (single.html)

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->

<!-- wp:group {"tagName":"main","layout":{"type":"constrained"}} -->
<main class="wp-block-group">
    <!-- wp:post-featured-image {"isLink":false,"align":"full"} /-->

    <!-- wp:group {"style":{"spacing":{"padding":{"top":"var:preset|spacing|60","bottom":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
    <div class="wp-block-group">
        <!-- wp:post-title {"level":1} /-->
        <!-- wp:post-meta /-->
        <!-- wp:post-content /-->

        <!-- wp:separator {"opacity":"css","className":"is-style-wide"} -->
        <hr class="wp-block-separator has-css-opacity is-style-wide" />
        <!-- /wp:separator -->

        <!-- wp:post-navigation-link {"type":"previous"} /-->
        <!-- wp:post-navigation-link {"type":"next"} /-->

        <!-- wp:post-comments-form /-->
    </div>
    <!-- /wp:group -->
</main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

### Archive Template (archive.html)

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->

<!-- wp:group {"tagName":"main","layout":{"type":"constrained"}} -->
<main class="wp-block-group">
    <!-- wp:query-title {"type":"archive"} /-->
    <!-- wp:term-description /-->

    <!-- wp:query {"queryId":1,"query":{"perPage":10,"sticky":""},"layout":{"type":"default"}} -->
    <div class="wp-block-query">
        <!-- wp:post-template -->
            <!-- wp:post-featured-image {"isLink":true} /-->
            <!-- wp:post-title {"isLink":true} /-->
            <!-- wp:post-excerpt /-->
        <!-- /wp:post-template -->

        <!-- wp:query-pagination -->
            <!-- wp:query-pagination-previous /-->
            <!-- wp:query-pagination-numbers /-->
            <!-- wp:query-pagination-next /-->
        <!-- /wp:query-pagination -->

        <!-- wp:query-no-results -->
            <!-- wp:paragraph -->
            <p>No posts found.</p>
            <!-- /wp:paragraph -->
        <!-- /wp:query-no-results -->
    </div>
    <!-- /wp:query -->
</main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

---

## Template Parts

### Rules

1. **No nesting** — template parts cannot include other template parts
2. **Semantic HTML** — use `tagName` to set the wrapping element (`header`, `footer`, `main`, `aside`, `section`)
3. **Register in theme.json** — use `templateParts` array
4. **Area** determines where in the Site Editor they appear

### header.html

```html
<!-- wp:group {"tagName":"header","style":{"position":{"type":"sticky","top":"0px"}},"layout":{"type":"flex","flexWrap":"nowrap","justifyContent":"space-between"}} -->
<header class="wp-block-group">
    <!-- wp:site-title /-->

    <!-- wp:navigation {"overlayMenu":"mobile"} /-->
</header>
<!-- /wp:group -->
```

### footer.html

```html
<!-- wp:group {"tagName":"footer","style":{"spacing":{"padding":{"top":"var:preset|spacing|60","bottom":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
<footer class="wp-block-group">
    <!-- wp:columns -->
    <div class="wp-block-columns">
        <!-- wp:column -->
        <div class="wp-block-column">
            <!-- wp:site-title {"level":0} /-->
            <!-- wp:site-tagline /-->
        </div>
        <!-- /wp:column -->

        <!-- wp:column -->
        <div class="wp-block-column">
            <!-- wp:navigation {"ref":2} /-->
        </div>
        <!-- /wp:column -->
    </div>
    <!-- /wp:columns -->

    <!-- wp:paragraph {"align":"center","style":{"typography":{"fontSize":"var:preset|font-size|small"}}} -->
    <p class="has-text-align-center">© <?php echo date('Y'); ?> My Site</p>
    <!-- /wp:paragraph -->
</footer>
<!-- /wp:group -->
```

---

## Patterns

### PHP File Header (Required Fields)

```php
<?php
/**
 * Title: Pattern display name in inserter
 * Slug: my-theme/pattern-slug
 * Categories: featured, my-theme
 * Description: Optional longer description.
 * Keywords: keyword1, keyword2
 * Block Types: core/cover, core/group   (optional — restricts where pattern appears)
 * Post Types: post, page                 (optional — limits to specific post types)
 * Template Types: single, archive        (optional — limits to specific templates)
 * Viewport Width: 1200                   (optional — preview viewport width)
 * Inserter: true                         (optional — false hides from inserter, for synced patterns)
 */
?>
<!-- Block markup here -->
```

### Pattern Categories

Built-in categories: `banner`, `buttons`, `columns`, `featured`, `footer`, `gallery`, `header`, `media`, `portfolio`, `posts`, `text`

Register custom category in `functions.php`:

```php
function my_theme_register_pattern_categories() {
    register_block_pattern_category(
        'my-theme',
        array( 'label' => __( 'My Theme', 'my-theme' ) )
    );
}
add_action( 'init', 'my_theme_register_pattern_categories' );
```

### Generating Block Markup for Patterns

The easiest way to create pattern markup:
1. Build the layout in the Site Editor
2. Switch to Code Editor (⌘⇧M or Ctrl+Shift+Alt+M)
3. Copy the block markup
4. Paste into the pattern PHP file docblock

---

## Synced Patterns (Reusable Blocks)

Synced patterns (formerly "reusable blocks") are stored in the database, not files. They have a post ID and are shared across the site.

To create programmatically:
```php
function my_theme_create_synced_pattern() {
    if ( get_option( 'my_theme_patterns_created' ) ) {
        return;
    }

    wp_insert_post( array(
        'post_type'    => 'wp_block',
        'post_title'   => 'My Synced Pattern',
        'post_content' => '<!-- wp:paragraph --><p>Shared content</p><!-- /wp:paragraph -->',
        'post_status'  => 'publish',
    ) );

    update_option( 'my_theme_patterns_created', true );
}
add_action( 'after_setup_theme', 'my_theme_create_synced_pattern' );
```

Reference in templates by ID:
```html
<!-- wp:block {"ref":42} /-->
```
