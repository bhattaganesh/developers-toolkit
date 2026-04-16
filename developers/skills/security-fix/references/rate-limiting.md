# Rate Limiting Patterns for WordPress

This guide provides rate limiting strategies to protect WordPress sites from brute force attacks, API abuse, and denial of service attempts.

---

## Overview

**Why Rate Limiting Matters:**
- Prevents brute force password attacks
- Stops API abuse and resource exhaustion
- Mitigates DoS/DDoS attempts
- Reduces server load
- Protects against automated abuse

**Common Targets:**
1. Login endpoints
2. REST API endpoints
3. AJAX handlers
4. Form submissions
5. Password reset requests
6. Search functionality

---

## 1. Login Rate Limiting

### Basic WordPress Login Rate Limiting

```php
/**
 * Rate limit login attempts by IP
 */
function myplugin_rate_limit_login( $user, $username, $password ) {
    $ip = $_SERVER['REMOTE_ADDR'];
    $transient_key = 'login_attempts_' . md5( $ip );

    // Get current attempt count
    $attempts = get_transient( $transient_key );

    if ( false === $attempts ) {
        $attempts = 0;
    }

    // Check if rate limit exceeded
    if ( $attempts >= 5 ) {
        $time_remaining = 3600 - ( time() - get_transient_timeout( $transient_key ) );

        return new WP_Error(
            'rate_limit_exceeded',
            sprintf(
                __( 'Too many login attempts. Please try again in %d minutes.', 'myplugin' ),
                ceil( $time_remaining / 60 )
            )
        );
    }

    // Increment attempt counter (expires in 1 hour)
    set_transient( $transient_key, $attempts + 1, HOUR_IN_SECONDS );

    return $user;
}
add_filter( 'authenticate', 'myplugin_rate_limit_login', 30, 3 );
```

### Reset on Successful Login

```php
function myplugin_reset_login_attempts( $user_login, $user ) {
    $ip = $_SERVER['REMOTE_ADDR'];
    $transient_key = 'login_attempts_' . md5( $ip );

    // Reset counter on successful login
    delete_transient( $transient_key );
}
add_action( 'wp_login', 'myplugin_reset_login_attempts', 10, 2 );
```

---

## 2. REST API Rate Limiting

### Per-User Rate Limiting

```php
/**
 * Rate limit REST API requests
 */
function myplugin_rest_api_rate_limit( $result, $server, $request ) {
    $user_id = get_current_user_id();

    if ( ! $user_id ) {
        return $result; // Don't rate limit unauthenticated (handled separately)
    }

    $transient_key = 'api_rate_limit_' . $user_id;
    $requests = get_transient( $transient_key );

    if ( false === $requests ) {
        $requests = array();
    }

    // Count requests in last minute
    $recent = array_filter( $requests, function( $timestamp ) {
        return $timestamp > ( time() - 60 );
    } );

    // Allow 60 requests per minute
    if ( count( $recent ) >= 60 ) {
        return new WP_Error(
            'rest_rate_limit',
            __( 'Rate limit exceeded. Maximum 60 requests per minute.', 'myplugin' ),
            array( 'status' => 429 )
        );
    }

    // Record this request
    $requests[] = time();

    // Keep only last 100 entries
    $requests = array_slice( $requests, -100 );

    set_transient( $transient_key, $requests, HOUR_IN_SECONDS );

    return $result;
}
add_filter( 'rest_pre_dispatch', 'myplugin_rest_api_rate_limit', 10, 3 );
```

### Per-IP Rate Limiting (Unauthenticated)

```php
function myplugin_rest_api_ip_rate_limit( $result, $server, $request ) {
    if ( get_current_user_id() ) {
        return $result; // Skip for authenticated users
    }

    $ip = $_SERVER['REMOTE_ADDR'];
    $transient_key = 'api_rate_limit_ip_' . md5( $ip );

    $count = get_transient( $transient_key );

    if ( false === $count ) {
        $count = 0;
    }

    // Allow 20 requests per minute for unauthenticated
    if ( $count >= 20 ) {
        return new WP_Error(
            'rest_rate_limit',
            __( 'Rate limit exceeded', 'myplugin' ),
            array( 'status' => 429 )
        );
    }

    set_transient( $transient_key, $count + 1, MINUTE_IN_SECONDS );

    return $result;
}
add_filter( 'rest_pre_dispatch', 'myplugin_rest_api_ip_rate_limit', 10, 3 );
```

---

## 3. AJAX Handler Rate Limiting

```php
/**
 * Rate limit AJAX requests
 */
function myplugin_ajax_rate_limit() {
    $user_id = get_current_user_id();
    $transient_key = 'ajax_rate_limit_' . ( $user_id ?: md5( $_SERVER['REMOTE_ADDR'] ) );

    $count = get_transient( $transient_key );

    if ( false === $count ) {
        $count = 0;
    }

    // Allow 30 requests per minute
    if ( $count >= 30 ) {
        wp_send_json_error(
            array(
                'message' => __( 'Too many requests. Please slow down.', 'myplugin' ),
            ),
            429
        );
    }

    set_transient( $transient_key, $count + 1, MINUTE_IN_SECONDS );
}

// Apply to specific AJAX actions
add_action( 'wp_ajax_my_action', 'myplugin_ajax_rate_limit', 1 );
add_action( 'wp_ajax_nopriv_my_action', 'myplugin_ajax_rate_limit', 1 );
```

---

## 4. Form Submission Rate Limiting

```php
/**
 * Rate limit form submissions
 */
function myplugin_form_rate_limit() {
    $ip = $_SERVER['REMOTE_ADDR'];
    $transient_key = 'form_submit_' . md5( $ip );

    $count = get_transient( $transient_key );

    if ( false === $count ) {
        $count = 0;
    }

    // Allow 5 submissions per hour
    if ( $count >= 5 ) {
        wp_die(
            __( 'Too many form submissions. Please try again later.', 'myplugin' ),
            __( 'Rate Limit Exceeded', 'myplugin' ),
            array( 'response' => 429 )
        );
    }

    set_transient( $transient_key, $count + 1, HOUR_IN_SECONDS );
}
```

---

## 5. Password Reset Rate Limiting

```php
/**
 * Rate limit password reset requests
 */
function myplugin_password_reset_rate_limit( $errors, $user_data ) {
    $ip = $_SERVER['REMOTE_ADDR'];
    $transient_key = 'password_reset_' . md5( $ip );

    $count = get_transient( $transient_key );

    if ( false === $count ) {
        $count = 0;
    }

    // Allow 3 password reset requests per hour
    if ( $count >= 3 ) {
        $errors->add(
            'too_many_resets',
            __( 'Too many password reset attempts. Please try again later.', 'myplugin' )
        );
        return $errors;
    }

    set_transient( $transient_key, $count + 1, HOUR_IN_SECONDS );

    return $errors;
}
add_filter( 'lostpassword_post', 'myplugin_password_reset_rate_limit', 10, 2 );
```

---

## 6. Advanced: Token Bucket Algorithm

```php
/**
 * Token bucket rate limiter (more sophisticated)
 */
class MyPlugin_Token_Bucket_Rate_Limiter {
    private $capacity;      // Maximum tokens
    private $refill_rate;   // Tokens added per second
    private $identifier;    // User/IP identifier

    public function __construct( $identifier, $capacity = 60, $refill_rate = 1 ) {
        $this->identifier = $identifier;
        $this->capacity = $capacity;
        $this->refill_rate = $refill_rate;
    }

    public function allow_request() {
        $transient_key = 'rate_limit_bucket_' . md5( $this->identifier );
        $bucket = get_transient( $transient_key );

        $now = microtime( true );

        if ( false === $bucket ) {
            // Initialize bucket
            $bucket = array(
                'tokens' => $this->capacity,
                'last_refill' => $now,
            );
        } else {
            // Refill tokens based on time passed
            $time_passed = $now - $bucket['last_refill'];
            $new_tokens = $time_passed * $this->refill_rate;

            $bucket['tokens'] = min(
                $this->capacity,
                $bucket['tokens'] + $new_tokens
            );
            $bucket['last_refill'] = $now;
        }

        // Check if request can proceed
        if ( $bucket['tokens'] >= 1 ) {
            $bucket['tokens'] -= 1;
            set_transient( $transient_key, $bucket, HOUR_IN_SECONDS );
            return true;
        }

        // Rate limit exceeded
        set_transient( $transient_key, $bucket, HOUR_IN_SECONDS );
        return false;
    }

    public function get_wait_time() {
        $transient_key = 'rate_limit_bucket_' . md5( $this->identifier );
        $bucket = get_transient( $transient_key );

        if ( false === $bucket || $bucket['tokens'] >= 1 ) {
            return 0;
        }

        // Time until next token available
        return ceil( ( 1 - $bucket['tokens'] ) / $this->refill_rate );
    }
}

// Usage
$user_id = get_current_user_id();
$limiter = new MyPlugin_Token_Bucket_Rate_Limiter( "user_{$user_id}", 60, 1 );

if ( ! $limiter->allow_request() ) {
    wp_send_json_error(
        array(
            'message' => sprintf(
                __( 'Rate limit exceeded. Please wait %d seconds.', 'myplugin' ),
                $limiter->get_wait_time()
            ),
        ),
        429
    );
}
```

---

## 7. Rate Limiting Best Practices

**Configuration:**
- [ ] Use transients for WordPress native caching
- [ ] Set appropriate timeout values (1 minute, 1 hour, etc.)
- [ ] Provide clear error messages with retry timeframe
- [ ] Return HTTP 429 (Too Many Requests) status code
- [ ] Include `Retry-After` header if possible

**User Experience:**
- [ ] Don't rate limit too aggressively (allow legitimate use)
- [ ] Differentiate between authenticated and unauthenticated users
- [ ] Allow admins to bypass rate limits (where appropriate)
- [ ] Provide CAPTCHA as alternative to hard blocking

**Security:**
- [ ] Use IP + User ID combination where possible
- [ ] Hash identifiers before storing
- [ ] Clean up expired transients
- [ ] Log rate limit violations for monitoring

**Performance:**
- [ ] Use transients (cached in object cache if available)
- [ ] Avoid database hits on every request
- [ ] Consider server-level rate limiting for high traffic

---

## 8. Rate Limiting Response Headers

```php
/**
 * Add rate limit headers to response
 */
function myplugin_rate_limit_headers( $response, $server, $request ) {
    $user_id = get_current_user_id();
    $transient_key = 'api_rate_limit_' . $user_id;
    $requests = get_transient( $transient_key );

    if ( is_array( $requests ) ) {
        $recent = array_filter( $requests, function( $timestamp ) {
            return $timestamp > ( time() - 60 );
        } );

        $remaining = max( 0, 60 - count( $recent ) );

        $response->header( 'X-RateLimit-Limit', 60 );
        $response->header( 'X-RateLimit-Remaining', $remaining );
        $response->header( 'X-RateLimit-Reset', time() + 60 );
    }

    return $response;
}
add_filter( 'rest_post_dispatch', 'myplugin_rate_limit_headers', 10, 3 );
```

---

## 9. Testing Rate Limits

```bash
# Test with cURL (should fail after X attempts)
for i in {1..10}; do
  curl -X POST https://example.test/wp-json/myplugin/v1/endpoint \
    -H "Content-Type: application/json" \
    -d '{"data": "test"}' \
    -w "\nStatus: %{http_code}\n"
  sleep 1
done

# Test login rate limiting
for i in {1..10}; do
  curl -X POST https://example.test/wp-login.php \
    -d "log=testuser&pwd=wrong" \
    -w "\nAttempt $i: %{http_code}\n"
done
```

---

## 10. Additional Resources

- [OWASP Rate Limiting](https://cheatsheetseries.owasp.org/cheatsheets/Denial_of_Service_Cheat_Sheet.html#rate-limiting)
- [Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket)
- [HTTP 429 Status Code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/429)
- [WordPress Transients API](https://developer.wordpress.org/apis/transients/)
