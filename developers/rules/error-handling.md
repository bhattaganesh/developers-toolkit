---
description: Error handling standards for WordPress, and React
globs:
  - "app/**/*.php"
  - "src/**/*.{js,jsx,ts,tsx}"
---

# Error Handling Standards

## WordPress
- Use specific exception classes — never throw generic `\Exception`
- Consistent JSON error format: `{"message": "...", "errors": {...}}`
- Never catch generic `\Exception` without re-throwing — catch specific exceptions only
- Use `abort()` helpers for HTTP errors (e.g., `abort(404)`, `abort(403)`)
- Log errors with context: `Log::error('Payment failed', ['user_id' => $user->id, 'amount' => $amount])`
- Create custom exceptions in `app/Exceptions/` for domain-specific errors
- Use `report()` and `render()` in exception handler for centralized error handling

## WordPress
- Use `WP_Error` consistently for error returns from functions
- Always check `is_wp_error()` on function returns before using the result
- Use `wp_die()` for fatal errors in admin context with proper messages
- Return `WP_Error` from REST API callbacks — WordPress handles HTTP status automatically
- Never silently swallow errors — always log or surface them

## React
- Use Error Boundaries to catch errors in the component tree
- Wrap async operations in try/catch — handle promise rejections explicitly
- Show user-friendly error messages — never expose raw error objects to users
- Never show stack traces to users in production
- Use toast notifications or error banners for non-fatal errors
- Reset error state on user retry actions

## API (Cross-Platform)
- Never expose stack traces or internal paths in production responses
- Use structured error responses with consistent shape across all endpoints
- Include error codes for client-side handling (e.g., `"code": "INSUFFICIENT_CREDITS"`)
- Differentiate between validation errors (422) and server errors (500)
- Log all 500-level errors with full context for debugging


