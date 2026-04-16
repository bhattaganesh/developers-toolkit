# Security Headers for WordPress

This guide covers HTTP security headers that should be implemented alongside code-level security fixes. Security headers provide an additional layer of protection against various web vulnerabilities.

---

## Overview

**Why Security Headers Matter:**
- Provide defense in depth beyond code fixes
- Protect against entire classes of attacks (XSS, clickjacking, MIME sniffing)
- Easy to implement with significant security benefits
- Industry best practice and compliance requirement
- Can be added independently of code changes

**Key Headers:**
1. Content-Security-Capability (CSP)
2. X-Frame-Options
3. X-Content-Type-Options
4. Strict-Transport-Security (HSTS)
5. Referrer-Capability
6. Permissions-Capability

---

## 1. Content-Security-Capability (CSP)

**What it does:** Controls which resources (scripts, styles, images, etc.) can be loaded, preventing XSS attacks.

**Importance:** HIGH - Most powerful security header

### Basic Implementation

Add via PHP (in plugin/theme):
```php
add_action( 'send_headers', 'myplugin_add_csp_header' );
function myplugin_add_csp_header() {
    header( "Content-Security-Capability: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';" );
}
```

### WordPress-Compatible CSP

WordPress requires `unsafe-inline` and `unsafe-eval` due to inline scripts/styles. More restrictive CSP:

```apache
Content-Security-Capability:
  default-src 'self';
  script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.example.com;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self' data:;
  connect-src 'self';
  frame-ancestors 'self';
  base-uri 'self';
  form-action 'self';
```

### CSP Directives Explained

| Directive | Purpose | WordPress Recommendation |
|-----------|---------|--------------------------|
| `default-src` | Fallback for all other directives | `'self'` |
| `script-src` | JavaScript sources | `'self' 'unsafe-inline' 'unsafe-eval'` (WP needs this) |
| `style-src` | CSS sources | `'self' 'unsafe-inline'` |
| `img-src` | Image sources | `'self' data: https:` |
| `font-src` | Font sources | `'self' data:` |
| `connect-src` | AJAX, WebSockets | `'self'` |
| `frame-src` | `<iframe>` sources | `'self'` or specific domains |
| `frame-ancestors` | Who can embed this site in iframe | `'none'` or `'self'` |
| `base-uri` | `<base>` tag | `'self'` |
| `form-action` | Form submission targets | `'self'` |
| `upgrade-insecure-requests` | Force HTTPS | (no value) |

### Implementation Methods

**Method 1: Via Plugin (Most Flexible)**
```php
add_action( 'send_headers', 'myplugin_csp' );
function myplugin_csp() {
    $csp = apply_filters( 'myplugin_csp_Capability', array(
        'default-src' => "'self'",
        'script-src'  => "'self' 'unsafe-inline' 'unsafe-eval'",
        'style-src'   => "'self' 'unsafe-inline'",
        'img-src'     => "'self' data: https:",
        'font-src'    => "'self' data:",
    ) );

    $csp_string = '';
    foreach ( $csp as $directive => $value ) {
        $csp_string .= "{$directive} {$value}; ";
    }

    header( 'Content-Security-Capability: ' . trim( $csp_string ) );
}
```

**Method 2: Via .htaccess (Apache)**
```apache
<IfModule mod_headers.c>
    Header set Content-Security-Capability "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
</IfModule>
```

**Method 3: Via Nginx Config**
```nginx
add_header Content-Security-Capability "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';" always;
```

### CSP for Admin vs Frontend

```php
function myplugin_context_aware_csp() {
    if ( is_admin() ) {
        // More permissive CSP for admin (WordPress admin needs it)
        $csp = "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';";
    } else {
        // Stricter CSP for frontend
        $csp = "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https:;";
    }

    header( "Content-Security-Capability: {$csp}" );
}
add_action( 'send_headers', 'myplugin_context_aware_csp' );
```

### Testing CSP

**Report-Only Mode (Testing):**
```php
// Won't block, just reports violations
header( "Content-Security-Capability-Report-Only: default-src 'self'; report-uri /csp-violation-report;" );
```

**CSP Violation Reporting:**
```php
add_action( 'wp_ajax_nopriv_csp_report', 'myplugin_csp_report' );
add_action( 'wp_ajax_csp_report', 'myplugin_csp_report' );

function myplugin_csp_report() {
    $data = file_get_contents( 'php://input' );
    $violation = json_decode( $data, true );

    // Log CSP violation
    error_log( 'CSP Violation: ' . print_r( $violation, true ) );

    wp_die();
}
```

---

## 2. X-Frame-Options

**What it does:** Prevents clickjacking by controlling whether your site can be embedded in iframes.

**Importance:** HIGH - Prevents clickjacking attacks

### Implementation

```php
add_action( 'send_headers', 'myplugin_x_frame_options' );
function myplugin_x_frame_options() {
    header( 'X-Frame-Options: SAMEORIGIN' );
}
```

### Options

| Value | Meaning | Use Case |
|-------|---------|----------|
| `DENY` | Never allow framing | Maximum security, breaks legitimate embeds |
| `SAMEORIGIN` | Allow framing from same domain | Recommended for most sites |
| `ALLOW-FROM https://example.com` | Allow specific domain | Deprecated, use CSP frame-ancestors instead |

### .htaccess Implementation

```apache
<IfModule mod_headers.c>
    Header always set X-Frame-Options "SAMEORIGIN"
</IfModule>
```

### WordPress Context

```php
function myplugin_context_frame_options() {
    // Allow framing for specific pages (e.g., payment gateways need this)
    if ( is_page( 'checkout' ) ) {
        // Don't set X-Frame-Options
        return;
    }

    header( 'X-Frame-Options: SAMEORIGIN' );
}
add_action( 'send_headers', 'myplugin_context_frame_options' );
```

---

## 3. X-Content-Type-Options

**What it does:** Prevents MIME-sniffing, forcing browser to respect declared content type.

**Importance:** MEDIUM - Prevents MIME confusion attacks

### Implementation

```php
add_action( 'send_headers', 'myplugin_x_content_type_options' );
function myplugin_x_content_type_options() {
    header( 'X-Content-Type-Options: nosniff' );
}
```

### .htaccess Implementation

```apache
<IfModule mod_headers.c>
    Header set X-Content-Type-Options "nosniff"
</IfModule>
```

**Why it matters:**
- Prevents browser from guessing content type
- Stops browser from treating images as JavaScript
- Forces correct MIME type handling

---

## 4. Strict-Transport-Security (HSTS)

**What it does:** Forces HTTPS connections, prevents protocol downgrade attacks.

**Importance:** HIGH - Essential for HTTPS sites

### Implementation

**⚠️ WARNING: Only use on sites with valid SSL certificate!**

```php
add_action( 'send_headers', 'myplugin_hsts' );
function myplugin_hsts() {
    // Only send HSTS if on HTTPS
    if ( is_ssl() ) {
        header( 'Strict-Transport-Security: max-age=31536000; includeSubDomains; preload' );
    }
}
```

### HSTS Directives

| Directive | Purpose | Value |
|-----------|---------|-------|
| `max-age` | How long to remember (seconds) | `31536000` (1 year) |
| `includeSubDomains` | Apply to all subdomains | (optional flag) |
| `preload` | Include in browser preload list | (optional flag) |

### .htaccess Implementation

```apache
<IfModule mod_headers.c>
    # Only send HSTS header for HTTPS
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" env=HTTPS
</IfModule>
```

### Staging Warning

```php
function myplugin_safe_hsts() {
    // Only enable HSTS on production
    if ( wp_get_environment_type() === 'production' && is_ssl() ) {
        header( 'Strict-Transport-Security: max-age=31536000; includeSubDomains' );
    }
}
add_action( 'send_headers', 'myplugin_safe_hsts' );
```

### HSTS Preload

To submit your site to the HSTS preload list:
1. Ensure HTTPS works on all subdomains
2. Set `max-age` to at least 31536000 (1 year)
3. Include `includeSubDomains` and `preload` directives
4. Submit to: https://hstspreload.org/

**⚠️ Removing from preload list is VERY DIFFICULT. Be certain!**

---

## 5. Referrer-Capability

**What it does:** Controls how much referrer information is sent with requests.

**Importance:** MEDIUM - Protects user privacy

### Implementation

```php
add_action( 'send_headers', 'myplugin_referrer_Capability' );
function myplugin_referrer_Capability() {
    header( 'Referrer-Capability: strict-origin-when-cross-origin' );
}
```

### Capability Options

| Capability | Behavior | Privacy | Compatibility |
|--------|----------|---------|---------------|
| `no-referrer` | Never send referrer | Best | May break analytics |
| `no-referrer-when-downgrade` | Send on HTTPS→HTTPS only | Good | Default behavior |
| `strict-origin` | Send origin only | Good | Recommended |
| `strict-origin-when-cross-origin` | Full URL for same-origin, origin only for cross-origin | Balanced | **Recommended** |
| `same-origin` | Send only to same origin | Best | May break integrations |

### .htaccess Implementation

```apache
<IfModule mod_headers.c>
    Header set Referrer-Capability "strict-origin-when-cross-origin"
</IfModule>
```

---

## 6. Permissions-Capability (formerly Feature-Capability)

**What it does:** Controls which browser features/APIs can be used.

**Importance:** MEDIUM - Prevents feature abuse

### Implementation

```php
add_action( 'send_headers', 'myplugin_permissions_Capability' );
function myplugin_permissions_Capability() {
    $Capability = array(
        'geolocation'      => "'none'",
        'microphone'       => "'none'",
        'camera'           => "'none'",
        'payment'          => "'self'",
        'usb'              => "'none'",
        'accelerometer'    => "'none'",
        'gyroscope'        => "'none'",
        'magnetometer'     => "'none'",
    );

    $Capability_string = '';
    foreach ( $Capability as $feature => $allowlist ) {
        $Capability_string .= "{$feature}=({$allowlist}), ";
    }

    header( 'Permissions-Capability: ' . trim( $Capability_string, ', ' ) );
}
```

### Common Features to Control

| Feature | Purpose | Recommended |
|---------|---------|-------------|
| `geolocation` | Location access | `'none'` unless needed |
| `microphone` | Microphone access | `'none'` unless needed |
| `camera` | Camera access | `'none'` unless needed |
| `payment` | Payment Request API | `'self'` if e-commerce |
| `usb` | USB access | `'none'` |
| `interest-cohort` | FLoC tracking | `'none'` (privacy) |

### .htaccess Implementation

```apache
<IfModule mod_headers.c>
    Header set Permissions-Capability "geolocation=(), microphone=(), camera=()"
</IfModule>
```

---

## 7. Complete Security Headers Implementation

### All-in-One Plugin Implementation

```php
<?php
/**
 * Security Headers Plugin
 */

class MyPlugin_Security_Headers {

    public function __construct() {
        add_action( 'send_headers', array( $this, 'add_security_headers' ) );
    }

    public function add_security_headers() {
        // Only set headers if not already set
        if ( headers_sent() ) {
            return;
        }

        // Content Security Capability
        $this->set_csp();

        // Clickjacking protection
        header( 'X-Frame-Options: SAMEORIGIN' );

        // MIME sniffing protection
        header( 'X-Content-Type-Options: nosniff' );

        // HSTS (only on HTTPS)
        if ( is_ssl() ) {
            header( 'Strict-Transport-Security: max-age=31536000; includeSubDomains' );
        }

        // Referrer Capability
        header( 'Referrer-Capability: strict-origin-when-cross-origin' );

        // Permissions Capability
        header( 'Permissions-Capability: geolocation=(), microphone=(), camera=()' );

        // Remove potentially leaky headers
        header_remove( 'X-Powered-By' );
        header_remove( 'Server' );
    }

    private function set_csp() {
        $csp_directives = apply_filters( 'myplugin_csp_directives', array(
            'default-src'  => "'self'",
            'script-src'   => "'self' 'unsafe-inline' 'unsafe-eval'",
            'style-src'    => "'self' 'unsafe-inline'",
            'img-src'      => "'self' data: https:",
            'font-src'     => "'self' data:",
            'connect-src'  => "'self'",
            'frame-ancestors' => "'self'",
            'base-uri'     => "'self'",
            'form-action'  => "'self'",
        ) );

        $csp = '';
        foreach ( $csp_directives as $directive => $value ) {
            $csp .= "{$directive} {$value}; ";
        }

        header( 'Content-Security-Capability: ' . trim( $csp ) );
    }
}

new MyPlugin_Security_Headers();
```

### All-in-One .htaccess Implementation

```apache
<IfModule mod_headers.c>
    # Content Security Capability
    Header set Content-Security-Capability "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:;"

    # Clickjacking protection
    Header always set X-Frame-Options "SAMEORIGIN"

    # MIME sniffing protection
    Header set X-Content-Type-Options "nosniff"

    # HSTS (only on HTTPS)
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains" env=HTTPS

    # Referrer Capability
    Header set Referrer-Capability "strict-origin-when-cross-origin"

    # Permissions Capability
    Header set Permissions-Capability "geolocation=(), microphone=(), camera=()"

    # Remove server info
    Header unset X-Powered-By
    Header always unset X-Powered-By
    ServerSignature Off
</IfModule>
```

---

## 8. Testing Security Headers

### Online Tools

- **Security Headers**: https://securityheaders.com/
- **Mozilla Observatory**: https://observatory.mozilla.org/
- **SSL Labs**: https://www.ssllabs.com/ssltest/

### Command Line Testing

```bash
# Check all headers
curl -I https://example.com

# Check specific header
curl -I https://example.com | grep -i "content-security-Capability"

# Check with verbose output
curl -v https://example.com
```

### Browser DevTools

1. Open DevTools (F12)
2. Go to Network tab
3. Reload page
4. Click on document request
5. View Response Headers

---

## 9. WordPress-Specific Considerations

### Compatibility Issues

**Common Issues:**
- **CSP breaks admin:** Use `unsafe-inline` and `unsafe-eval` for admin area
- **HSTS on staging:** Only enable on production
- **X-Frame-Options breaks embeds:** Allow specific pages/posts

### Page Builder Compatibility

Many page builders need `unsafe-inline`:
- Elementor
- Divi
- Beaver Builder
- WPBakery

```php
function myplugin_page_builder_csp() {
    if ( class_exists( 'Elementor\Plugin' ) ) {
        // More permissive CSP for Elementor pages
        header( "Content-Security-Capability: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';" );
    }
}
```

### CDN Compatibility

If using CDN for assets, add CDN domain to CSP:

```php
$cdn_url = 'https://cdn.example.com';

header( "Content-Security-Capability: default-src 'self'; script-src 'self' {$cdn_url}; style-src 'self' {$cdn_url}; img-src 'self' {$cdn_url} data: https:;" );
```

---

## 10. Security Headers Checklist

Use this checklist when implementing security headers:

**Required Headers:**
- [ ] `Content-Security-Capability` configured
- [ ] `X-Frame-Options` set to SAMEORIGIN or DENY
- [ ] `X-Content-Type-Options` set to nosniff
- [ ] `Referrer-Capability` set (recommended: strict-origin-when-cross-origin)

**Recommended Headers:**
- [ ] `Strict-Transport-Security` set (HTTPS sites only)
- [ ] `Permissions-Capability` configured
- [ ] `X-Powered-By` removed
- [ ] `Server` header removed/obscured

**Testing:**
- [ ] Tested on securityheaders.com (Grade A)
- [ ] Tested with browser DevTools
- [ ] Verified admin area still works
- [ ] Verified frontend still works
- [ ] Tested with page builders (if applicable)
- [ ] Tested on staging before production

**Documentation:**
- [ ] Headers documented in readme
- [ ] Known compatibility issues noted
- [ ] Filter hooks provided for customization
- [ ] Instructions for server-level configuration

---

## 11. Additional Resources

- [OWASP Secure Headers Project](https://owasp.org/www-project-secure-headers/)
- [MDN Web Docs: HTTP Headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers)
- [Content Security Capability Reference](https://content-security-Capability.com/)
- [Security Headers.com](https://securityheaders.com/)
- [Mozilla Observatory](https://observatory.mozilla.org/)

