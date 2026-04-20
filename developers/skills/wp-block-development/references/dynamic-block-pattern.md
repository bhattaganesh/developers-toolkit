# Dynamic Block Pattern

Dynamic blocks render via PHP on every page load. Use them when the block output depends on live data, auth context, or anything that can change independently of the saved post content.

## When to Use Dynamic Rendering

| Use dynamic when... | Example |
|---|---|
| Output includes post query results | Latest posts, related content |
| Output depends on user/auth state | Member-only content, personalization |
| Output includes current time/date | "Posted X ago", live counters |
| Output could become stale | Stock prices, weather, computed stats |
| Block needs live server-side data | Settings, options, computed values |

## Complete Dynamic Block Setup

### block.json

```json
{
  "$schema": "https://schemas.wp.org/trunk/block.json",
  "apiVersion": 3,
  "name": "my-plugin/recent-posts",
  "title": "Recent Posts",
  "category": "widgets",
  "description": "Display recent posts dynamically.",
  "attributes": {
    "postsCount": {
      "type": "number",
      "default": 5
    },
    "category": {
      "type": "number",
      "default": 0
    }
  },
  "supports": {
    "html": false
  },
  "editorScript": "file:./index.js",
  "style": "file:./style-index.css",
  "render": "file:./render.php"
}
```

Note: No `save.js` entry — `save()` returns `null` for dynamic blocks.

### index.js

```js
import { registerBlockType } from '@wordpress/blocks';
import Edit from './edit';
import metadata from './block.json';

registerBlockType( metadata.name, {
    edit: Edit,
    save: () => null, // Dynamic blocks always return null from save()
} );
```

### edit.js

Show a preview or placeholder in the editor. Use `ServerSideRender` when you want to show the actual PHP output inside the editor:

```js
import { useBlockProps, InspectorControls } from '@wordpress/block-editor';
import { PanelBody, RangeControl } from '@wordpress/components';
import ServerSideRender from '@wordpress/server-side-render';

export default function Edit( { attributes, setAttributes } ) {
    const { postsCount } = attributes;
    const blockProps = useBlockProps();

    return (
        <>
            <InspectorControls>
                <PanelBody title="Settings">
                    <RangeControl
                        label="Number of posts"
                        value={ postsCount }
                        onChange={ ( val ) => setAttributes( { postsCount: val } ) }
                        min={ 1 }
                        max={ 20 }
                    />
                </PanelBody>
            </InspectorControls>
            <div { ...blockProps }>
                <ServerSideRender
                    block="my-plugin/recent-posts"
                    attributes={ attributes }
                />
            </div>
        </>
    );
}
```

**Alternative to ServerSideRender:** Show a static placeholder in the editor (faster, no API call):

```js
export default function Edit( { attributes, setAttributes } ) {
    const { postsCount } = attributes;
    const blockProps = useBlockProps();

    return (
        <>
            { /* InspectorControls here */ }
            <div { ...blockProps }>
                <p>Showing { postsCount } recent posts (preview not available in editor)</p>
            </div>
        </>
    );
}
```

### render.php

```php
<?php
/**
 * Dynamic block render callback.
 *
 * @param array    $attributes Block attributes.
 * @param string   $content    Inner block content (empty for non-container blocks).
 * @param WP_Block $block      Block instance.
 */

$posts_count = isset( $attributes['postsCount'] ) ? absint( $attributes['postsCount'] ) : 5;
$category    = isset( $attributes['category'] ) ? absint( $attributes['category'] ) : 0;

$query_args = array(
    'post_type'      => 'post',
    'posts_per_page' => $posts_count,
    'post_status'    => 'publish',
);

if ( $category > 0 ) {
    $query_args['cat'] = $category;
}

$posts = get_posts( $query_args );

if ( empty( $posts ) ) {
    return '<p>' . esc_html__( 'No posts found.', 'my-plugin' ) . '</p>';
}

// Always use get_block_wrapper_attributes() — adds block class + custom className support
$wrapper_attributes = get_block_wrapper_attributes();
?>
<div <?php echo $wrapper_attributes; ?>>
    <ul>
        <?php foreach ( $posts as $post ) : ?>
            <li>
                <a href="<?php echo esc_url( get_permalink( $post->ID ) ); ?>">
                    <?php echo esc_html( $post->post_title ); ?>
                </a>
            </li>
        <?php endforeach; ?>
    </ul>
</div>
```

### PHP Registration

```php
function my_plugin_register_blocks() {
    register_block_type( __DIR__ . '/blocks/recent-posts/' );
    // Reads block.json automatically — render callback resolved via 'render' field
}
add_action( 'init', 'my_plugin_register_blocks' );
```

## Using Block Context in render.php

Dynamic blocks can read post/query context (set by parent blocks like Query Loop):

```json
// block.json
"usesContext": ["postId", "postType", "queryId"]
```

```php
// render.php — $block->context holds the values
$post_id   = $block->context['postId'] ?? get_the_ID();
$post_type = $block->context['postType'] ?? 'post';
```

## Security in render.php

Always sanitize and escape:

```php
// Input: sanitize attribute values before using them
$count = absint( $attributes['count'] ?? 5 );
$title = sanitize_text_field( $attributes['title'] ?? '' );

// Output: escape everything that hits HTML
echo esc_html( $title );
echo esc_url( get_permalink() );
echo wp_kses_post( $content ); // Only for trusted HTML (like post content)
```

## get_block_wrapper_attributes()

This function is **mandatory** for correct block behavior:
- Adds `wp-block-{namespace}-{name}` class
- Adds user's custom `className` (from supports)
- Adds `id` from anchor support
- Adds alignment class from `align` support

```php
// Merge with your own attributes:
$wrapper_attributes = get_block_wrapper_attributes( array(
    'class' => 'my-extra-class',
    'data-count' => $posts_count,
) );

echo '<div ' . $wrapper_attributes . '>';
```
