# Gutenberg Block Security Reference

This guide covers security best practices for WordPress Gutenberg blocks (WordPress 5.0+). Blocks are the foundation of the modern WordPress editor and require special security considerations.

---

## Overview

Gutenberg blocks can be vulnerable to:
- XSS via block attributes
- Stored XSS in block content
- Server-side rendering (SSR) vulnerabilities
- Block pattern injection
- Malicious block registration

**Key Principle:** Always sanitize block attributes and escape block output, both in JavaScript (editor) and PHP (frontend).

---

## Block Attribute Security

### Defining Secure Block Attributes

When registering blocks, define attribute types and sanitization:

```javascript
// block.json
{
  "apiVersion": 2,
  "name": "myplugin/my-block",
  "title": "My Block",
  "attributes": {
    "content": {
      "type": "string",
      "source": "html",
      "selector": "p"
    },
    "url": {
      "type": "string",
      "source": "attribute",
      "selector": "a",
      "attribute": "href"
    },
    "count": {
      "type": "number",
      "default": 0
    }
  }
}
```

### Server-Side Attribute Sanitization

**CRITICAL:** Always sanitize attributes in `render_callback`:

```php
register_block_type( 'myplugin/my-block', array(
    'attributes' => array(
        'content' => array(
            'type' => 'string',
            // IMPORTANT: Sanitize callback for user-editable content
            'sanitize_callback' => 'wp_kses_post',
        ),
        'url' => array(
            'type' => 'string',
            'sanitize_callback' => 'esc_url_raw',
        ),
        'title' => array(
            'type' => 'string',
            'sanitize_callback' => 'sanitize_text_field',
        ),
        'count' => array(
            'type' => 'number',
            'sanitize_callback' => 'absint',
        ),
    ),
    'render_callback' => 'myplugin_render_my_block',
) );

function myplugin_render_my_block( $attributes, $content ) {
    // Attributes are already sanitized via sanitize_callback
    // But ALWAYS escape on output (defense in depth)

    $safe_content = wp_kses_post( $attributes['content'] ?? '' );
    $safe_url = esc_url( $attributes['url'] ?? '' );
    $safe_title = esc_html( $attributes['title'] ?? '' );
    $safe_count = absint( $attributes['count'] ?? 0 );

    return sprintf(
        '<div class="my-block"><h3>%s</h3><p>%s</p><a href="%s">Link</a><span>Count: %d</span></div>',
        $safe_title,
        $safe_content,
        $safe_url,
        $safe_count
    );
}
```

---

## Dynamic Block Security (Server-Side Rendering)

### Secure Dynamic Block Pattern

```php
register_block_type( 'myplugin/dynamic-block', array(
    'attributes' => array(
        'postId' => array(
            'type' => 'number',
            'default' => 0,
        ),
    ),
    'render_callback' => 'myplugin_render_dynamic_block',
) );

function myplugin_render_dynamic_block( $attributes, $content, $block ) {
    // 1. Sanitize attribute
    $post_id = absint( $attributes['postId'] ?? 0 );

    // 2. Validate
    if ( ! $post_id ) {
        return '<p>Invalid post ID</p>';
    }

    // 3. Authorization check
    $post = get_post( $post_id );
    if ( ! $post || ! is_post_publicly_viewable( $post ) ) {
        return '<p>Post not found</p>';
    }

    // 4. Escape output
    return sprintf(
        '<div class="dynamic-block"><h2>%s</h2><div>%s</div></div>',
        esc_html( get_the_title( $post ) ),
        wp_kses_post( apply_filters( 'the_content', $post->post_content ) )
    );
}
```

### Common Dynamic Block Vulnerabilities

**❌ VULNERABLE:**
```php
function bad_render_callback( $attributes ) {
    // NO sanitization!
    $post_id = $attributes['postId'];

    // NO authorization check!
    $post = get_post( $post_id );

    // NO output escaping!
    return '<div>' . $post->post_title . '</div>'; // XSS!
}
```

**✅ SECURE:**
```php
function secure_render_callback( $attributes ) {
    // Sanitize
    $post_id = absint( $attributes['postId'] ?? 0 );

    // Validate
    if ( ! $post_id ) {
        return '';
    }

    // Authorization
    if ( ! current_user_can( 'read_post', $post_id ) ) {
        return '';
    }

    $post = get_post( $post_id );
    if ( ! $post ) {
        return '';
    }

    // Escape output
    return '<div>' . esc_html( $post->post_title ) . '</div>';
}
```

---

## Block Editor (JavaScript) Security

### RichText Component XSS Prevention

The `RichText` component can be vulnerable to XSS. Always specify allowed formats:

```javascript
import { RichText } from '@wordpress/block-editor';

// ❌ VULNERABLE - Allows all HTML
<RichText
    value={ attributes.content }
    onChange={ ( content ) => setAttributes( { content } ) }
/>

// ✅ SECURE - Limited formats only
<RichText
    value={ attributes.content }
    onChange={ ( content ) => setAttributes( { content } ) }
    tagName="p"
    allowedFormats={ [ 'core/bold', 'core/italic', 'core/link' ] }
/>

// ✅ MOST SECURE - Plain text only
<RichText
    value={ attributes.content }
    onChange={ ( content ) => setAttributes( { content } ) }
    tagName="p"
    allowedFormats={ [] } // No formatting
    disableLineBreaks={ true } // No line breaks
/>
```

### URL Input Sanitization

```javascript
import { URLInput } from '@wordpress/block-editor';
import { isURL } from '@wordpress/url';

function Edit( { attributes, setAttributes } ) {
    const onChangeURL = ( url ) => {
        // Validate URL on change
        if ( url && ! isURL( url ) ) {
            // Invalid URL - could set error state
            return;
        }
        setAttributes( { url } );
    };

    return (
        <URLInput
            value={ attributes.url }
            onChange={ onChangeURL }
        />
    );
}
```

### Preventing Script Injection in InnerBlocks

```javascript
import { InnerBlocks } from '@wordpress/block-editor';

// ❌ VULNERABLE - No restrictions
<InnerBlocks />

// ✅ SECURE - Whitelist allowed blocks
<InnerBlocks
    allowedBlocks={ [
        'core/paragraph',
        'core/heading',
        'core/image',
        'core/list',
    ] }
/>

// ✅ MOST SECURE - Template with locked blocks
<InnerBlocks
    template={ [
        [ 'core/heading', { placeholder: 'Title...' } ],
        [ 'core/paragraph', { placeholder: 'Content...' } ],
    ] }
    templateLock="all" // Can't add/remove/move blocks
/>
```

---

## Block Patterns Security

Block patterns can inject malicious code. Validate pattern registration:

```php
// Registering a block pattern
function myplugin_register_block_patterns() {
    // ❌ VULNERABLE - User-supplied content without validation
    register_block_pattern(
        'myplugin/my-pattern',
        array(
            'title'   => $_POST['title'], // NO SANITIZATION!
            'content' => $_POST['content'], // XSS RISK!
        )
    );
}

// ✅ SECURE - Sanitized and validated
function myplugin_register_block_patterns() {
    // Only allow admins to register patterns
    if ( ! current_user_can( 'manage_options' ) ) {
        return;
    }

    $title = sanitize_text_field( wp_unslash( $_POST['title'] ?? '' ) );
    $content = wp_kses_post( wp_unslash( $_POST['content'] ?? '' ) );

    if ( ! $title || ! $content ) {
        return;
    }

    register_block_pattern(
        'myplugin/my-pattern',
        array(
            'title'       => $title,
            'description' => sanitize_text_field( wp_unslash( $_POST['description'] ?? '' ) ),
            'content'     => $content,
            'categories'  => array( 'text' ),
        )
    );
}
add_action( 'init', 'myplugin_register_block_patterns' );
```

---

## Block Variations Security

Block variations extend existing blocks. Ensure they don't introduce vulnerabilities:

```javascript
// Registering block variation
wp.blocks.registerBlockVariation( 'core/button', {
    name: 'my-button',
    title: 'My Button',
    attributes: {
        // ❌ VULNERABLE - Unsanitized URL
        url: userProvidedUrl,

        // ✅ SECURE - Validated and sanitized
        url: isURL( userProvidedUrl ) ? userProvidedUrl : '',
    },
} );
```

---

## Block Context Security

Block context shares data between blocks. Prevent information leakage:

```php
// Parent block provides context
register_block_type( 'myplugin/parent', array(
    'provides_context' => array(
        'myplugin/userId' => 'userId',
    ),
    'render_callback' => 'myplugin_render_parent',
) );

function myplugin_render_parent( $attributes, $content ) {
    $user_id = get_current_user_id();

    // ⚠️ SECURITY: Only share userId if user is authenticated
    if ( ! $user_id ) {
        return $content; // No context provided
    }

    // ⚠️ SECURITY: Ensure child blocks validate they can access this user's data
    return $content;
}

// Child block uses context
register_block_type( 'myplugin/child', array(
    'uses_context' => array( 'myplugin/userId' ),
    'render_callback' => 'myplugin_render_child',
) );

function myplugin_render_child( $attributes, $content, $block ) {
    $user_id_from_context = $block->context['myplugin/userId'] ?? 0;

    // ✅ IMPORTANT: Validate authorization
    if ( ! $user_id_from_context || ! current_user_can( 'edit_user', $user_id_from_context ) ) {
        return '<p>Unauthorized</p>';
    }

    $user = get_userdata( $user_id_from_context );
    return '<p>User: ' . esc_html( $user->display_name ) . '</p>';
}
```

---

## Block Bindings API (WordPress 6.5+)

The Block Bindings API allows dynamic content binding. Secure it properly:

```php
// Register custom block binding source
function myplugin_register_block_bindings() {
    register_block_bindings_source( 'myplugin/user-meta', array(
        'label' => __( 'User Meta', 'myplugin' ),
        'get_value_callback' => 'myplugin_get_user_meta_value',
    ) );
}
add_action( 'init', 'myplugin_register_block_bindings' );

function myplugin_get_user_meta_value( $source_args, $block_instance ) {
    // 1. Validate source arguments
    $meta_key = sanitize_key( $source_args['key'] ?? '' );
    if ( ! $meta_key ) {
        return '';
    }

    // 2. Get current user
    $user_id = get_current_user_id();
    if ( ! $user_id ) {
        return '';
    }

    // 3. Authorization check
    // Only allow specific meta keys to prevent information disclosure
    $allowed_keys = array( 'bio', 'website', 'twitter' );
    if ( ! in_array( $meta_key, $allowed_keys, true ) ) {
        return '';
    }

    // 4. Get and sanitize meta value
    $value = get_user_meta( $user_id, $meta_key, true );

    // 5. Escape for display context
    return esc_html( $value );
}
```

---

## Common Gutenberg Vulnerabilities

### 1. Unsanitized Block Attributes (Stored XSS)

**Vulnerable:**
```php
register_block_type( 'myplugin/block', array(
    'attributes' => array(
        'html' => array( 'type' => 'string' ), // No sanitization!
    ),
    'render_callback' => function( $attributes ) {
        return '<div>' . $attributes['html'] . '</div>'; // XSS!
    },
) );
```

**Fixed:**
```php
register_block_type( 'myplugin/block', array(
    'attributes' => array(
        'html' => array(
            'type' => 'string',
            'sanitize_callback' => 'wp_kses_post', // Sanitize on save
        ),
    ),
    'render_callback' => function( $attributes ) {
        return '<div>' . wp_kses_post( $attributes['html'] ?? '' ) . '</div>'; // Escape on output
    },
) );
```

### 2. Missing Authorization in Dynamic Blocks

**Vulnerable:**
```php
function render_user_profile( $attributes ) {
    $user_id = $attributes['userId'];
    $user = get_userdata( $user_id );
    return '<div>' . $user->user_email . '</div>'; // Leaks email!
}
```

**Fixed:**
```php
function render_user_profile( $attributes ) {
    $user_id = absint( $attributes['userId'] ?? 0 );

    // Check if current user can view this user's profile
    if ( ! $user_id || ! current_user_can( 'list_users' ) ) {
        return '';
    }

    $user = get_userdata( $user_id );
    if ( ! $user ) {
        return '';
    }

    // Only show public information
    return '<div>' . esc_html( $user->display_name ) . '</div>';
}
```

### 3. InnerBlocks Script Injection

**Vulnerable:**
```javascript
// Allows ANY block, including script blocks
<InnerBlocks />
```

**Fixed:**
```javascript
// Whitelist safe blocks only
<InnerBlocks
    allowedBlocks={ [
        'core/paragraph',
        'core/heading',
        'core/list',
        'core/image',
    ] }
/>
```

---

## Block Deprecation Security

When deprecating blocks, ensure old versions don't introduce vulnerabilities:

```javascript
const deprecated = [
    {
        attributes: {
            content: {
                type: 'string',
            },
        },
        save( { attributes } ) {
            // ❌ OLD VERSION - No escaping!
            return <div>{ attributes.content }</div>;
        },
        migrate( attributes ) {
            // ✅ Sanitize when migrating from old version
            return {
                content: wp.sanitize.stripTags( attributes.content ),
            };
        },
    },
];
```

---

## Block Validation & Parsing

WordPress validates blocks on save. Failed validation can corrupt content:

```php
// Server-side block validation
function myplugin_validate_block_content( $block_content, $block ) {
    if ( 'myplugin/my-block' !== $block['blockName'] ) {
        return $block_content;
    }

    // Validate block attributes match expected schema
    $allowed_keys = array( 'title', 'content', 'url' );
    $block_attrs = array_intersect_key(
        $block['attrs'] ?? array(),
        array_flip( $allowed_keys )
    );

    // Re-render block with validated attributes
    return render_block( array_merge( $block, array( 'attrs' => $block_attrs ) ) );
}
add_filter( 'render_block', 'myplugin_validate_block_content', 10, 2 );
```

---

## Security Checklist for Gutenberg Blocks

Use this checklist when creating or auditing Gutenberg blocks:

### Block Registration
- [ ] All attributes have explicit `type` definition
- [ ] User-editable attributes have `sanitize_callback`
- [ ] `render_callback` escapes ALL output
- [ ] Block only registered for users with appropriate capabilities

### Dynamic Blocks (Server-Side Rendering)
- [ ] Attributes sanitized in render callback (defense in depth)
- [ ] Authorization checks before displaying sensitive data
- [ ] Post/user existence validated before use
- [ ] Error messages don't leak sensitive information

### Block Editor (JavaScript)
- [ ] RichText has `allowedFormats` specified
- [ ] URLInput validates with `isURL()`
- [ ] InnerBlocks has `allowedBlocks` whitelist
- [ ] User input validated before setState

### Block Patterns
- [ ] Pattern registration restricted to admins
- [ ] Pattern content sanitized with `wp_kses_post()`
- [ ] Pattern title/description sanitized

### Block Context
- [ ] Context only shares non-sensitive data
- [ ] Child blocks validate authorization to access context
- [ ] Context doesn't leak user IDs, emails, or private data

### Block Bindings (6.5+)
- [ ] Binding sources validate source arguments
- [ ] Authorization check before returning data
- [ ] Whitelist of allowed meta keys/sources
- [ ] Values escaped for display context

---

## Additional Resources

- [WordPress Block Editor Handbook](https://developer.wordpress.org/block-editor/)
- [Block API Reference](https://developer.wordpress.org/block-editor/reference-guides/block-api/)
- [WordPress Security Patterns](wordpress-patterns.md)
- [WordPress Security Checklist](wp-security-checklist.md)
