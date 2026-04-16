# Security Logging for WordPress

A guide for implementing secure,compliant, and useful security logging in WordPress plugins and themes.

---

## What to Log

**✅ Always Log:**
- Failed login attempts (username, IP, timestamp)
- Privilege escalation attempts
- Unauthorized access attempts
- Security check failures (nonce, capability)
- Configuration changes (by whom, when)
- File modifications in sensitive areas
- Database schema changes
- Password reset requests
- User account creation/deletion
- Failed authorization checks

**❌ Never Log:**
- Passwords (plain or hashed)
- API keys or secrets
- Credit card numbers
- Social Security numbers
- Personal health information
- Session tokens
- Nonces (can be replayed)
- Full $_POST/$_GET data (may contain secrets)

---

## Basic Security Logging

```php
/**
 * Log security event
 */
function myplugin_log_security_event( $event_type, $message, $context = array() ) {
    $log_entry = array(
        'timestamp' => current_time( 'mysql' ),
        'event_type' => sanitize_key( $event_type ),
        'message' => sanitize_text_field( $message ),
        'user_id' => get_current_user_id(),
        'ip_address' => $_SERVER['REMOTE_ADDR'],
        'user_agent' => substr( $_SERVER['HTTP_USER_AGENT'], 0, 255 ),
        'context' => wp_json_encode( $context ),
    );

    // Log to custom table
    global $wpdb;
    $table = $wpdb->prefix . 'myplugin_security_log';

    $wpdb->insert( $table, $log_entry );

    // Also log critical events to error_log
    if ( in_array( $event_type, array( 'privilege_escalation', 'unauthorized_access' ) ) ) {
        error_log( sprintf(
            '[SECURITY] %s: %s (User: %d, IP: %s)',
            $event_type,
            $message,
            $log_entry['user_id'],
            $log_entry['ip_address']
        ) );
    }
}

// Usage
myplugin_log_security_event(
    'failed_login',
    'Failed login attempt for admin',
    array( 'username' => 'admin' )
);
```

---

## Log Rotation and Cleanup

```php
/**
 * Clean up old log entries (run daily)
 */
function myplugin_cleanup_security_logs() {
    global $wpdb;
    $table = $wpdb->prefix . 'myplugin_security_log';

    // Delete logs older than 90 days
    $wpdb->query( $wpdb->prepare(
        "DELETE FROM {$table} WHERE timestamp < %s",
        date( 'Y-m-d H:i:s', strtotime( '-90 days' ) )
    ) );
}
add_action( 'myplugin_daily_cleanup', 'myplugin_cleanup_security_logs' );
```

---

## GDPR Compliance

**Requirements:**
- Anonymize IP addresses (GDPR Article 32)
- Limit retention period (90 days recommended)
- Provide data export for users
- Allow users to request log deletion

```php
/**
 * Anonymize IP address (GDPR-compliant)
 */
function myplugin_anonymize_ip( $ip ) {
    return wp_privacy_anonymize_ip( $ip );
}

/**
 * Export user's security logs (GDPR data portability)
 */
function myplugin_export_user_security_logs( $email ) {
    $user = get_user_by( 'email', $email );

    if ( ! $user ) {
        return;
    }

    global $wpdb;
    $table = $wpdb->prefix . 'myplugin_security_log';

    $logs = $wpdb->get_results( $wpdb->prepare(
        "SELECT timestamp, event_type, message FROM {$table} WHERE user_id = %d ORDER BY timestamp DESC",
        $user->ID
    ), ARRAY_A );

    return array(
        'group_id' => 'myplugin_security_logs',
        'group_label' => __( 'Security Logs', 'myplugin' ),
        'item_id' => 'security-logs',
        'data' => $logs,
    );
}
add_filter( 'wp_privacy_personal_data_exporters', function( $exporters ) {
    $exporters['myplugin'] = array(
        'exporter_friendly_name' => __( 'Plugin Security Logs', 'myplugin' ),
        'callback' => 'myplugin_export_user_security_logs',
    );
    return $exporters;
} );
```

---

## Monitoring and Alerts

```php
/**
 * Send alert for critical security events
 */
function myplugin_alert_on_critical_event( $event_type, $message ) {
    $critical_events = array(
        'privilege_escalation',
        'unauthorized_database_access',
        'file_modification',
        'suspicious_activity',
    );

    if ( ! in_array( $event_type, $critical_events ) ) {
        return;
    }

    // Email admin
    $admin_email = get_option( 'admin_email' );
    $subject = sprintf( __( '[SECURITY ALERT] %s', 'myplugin' ), $event_type );
    $body = sprintf(
        __( 'A critical security event was detected:\n\nType: %s\nMessage: %s\nTime: %s\nIP: %s', 'myplugin' ),
        $event_type,
        $message,
        current_time( 'mysql' ),
        $_SERVER['REMOTE_ADDR']
    );

    wp_mail( $admin_email, $subject, $body );
}
```

---

## Best Practices

**Performance:**
- Use async logging (wp_schedule_single_event)
- Batch log writes
- Index database columns properly
- Rotate logs regularly

**Security:**
- Sanitize all logged data
- Never log passwords/secrets
- Anonymize IP addresses
- Encrypt sensitive context data
- Restrict log access to admins only

**Compliance:**
- Document retention period
- Implement data export
- Allow user log deletion
- Follow GDPR/CCPA requirements

---

## Additional Resources

- [OWASP Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)
- [WordPress Privacy API](https://developer.wordpress.org/plugins/privacy/)
- [GDPR Compliance](https://gdpr.eu/)
