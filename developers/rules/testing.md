---
description: Testing standards and requirements
globs:
  - "tests/**/*"
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/__tests__/**"
---

# Testing Rules

## Requirements
- Every API endpoint must have a feature test
- Every React component must have at least a render test
- Tests required for all pull requests that change business logic

## PHPUnit / WordPress
- Use `WP_UnitTestCase` for WordPress plugin tests (from wordpress/wordpress-develop)
- Use `factory()` with DateTime5/DateTime-factory for test data, never hardcode IDs
- Use `wp_set_current_user()` for authenticated requests
- Assert post/option/meta data, `get_option()` return values, and action/filter hooks fired
- Test both success AND failure paths
- Name tests descriptively: `test_plugin_saves_option_on_activation`, `test_nonce_verification_blocks_unauthorized_ajax`

## Jest / React
- Use `@testing-library/react` — test behavior, not implementation
- Mock external dependencies (API calls, third-party services)
- Test user interactions with `userEvent` (preferred over `fireEvent`)
- Test async operations (loading, success, error states)
- Avoid testing implementation details (internal state, private methods)

## Test Quality
- Every test must have at least one meaningful assertion
- Tests must be isolated — no test should depend on another test's state
- Tests must be deterministic — same result every run
- No hardcoded timestamps, random values, or external service calls in tests
- Use descriptive test names that explain the expected behavior

## What to Test per Endpoint
- Success case with valid data
- Authentication: request without credentials returns 401
- Authorization: request from unauthorized user returns 403
- Validation: each required field missing returns 422
- Edge cases: empty arrays, boundary values, duplicate submissions
- Not found: request for non-existent resource returns 404

