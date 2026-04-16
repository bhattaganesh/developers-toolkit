---
name: testing-context
description: "Auto-activates when working on test files. Use this skill when editing files in tests/ directory or files ending in Test.php, .test.js, .test.tsx, .spec.js, .spec.tsx. Provides test quality guidelines and assertion best practices."
version: 1.0.0
---

# Testing Context

## Core Principles
- **Test behavior, not implementation** — tests should verify what the code does, not how it does it internally
- **One assertion concept per test** — each test method should verify one logical behavior. Multiple related `assert` calls are fine if they test the same concept.
- **Descriptive test names** — test names should read as specifications: `it_returns_404_when_credit_not_found`, `should render error message when API fails`
- **Arrange-Act-Assert** — structure every test with clear setup, action, and verification sections
- **Tests are documentation** — someone reading only the tests should understand the feature's behavior

## Test Data
- Use factories for creating test data — never hardcode IDs or rely on database state
- Use minimal data — only set attributes relevant to the test being written
- Use `faker` for realistic but random data
- Reset state between tests — each test should be independent and isolated

## What to Test
- **Success path** — the happy path works as expected
- **Validation errors** — invalid input is rejected with proper messages
- **Authorization** — unauthenticated and unauthorized access is blocked
- **Edge cases** — empty inputs, boundary values, null values, duplicate data
- **Error handling** — external service failures, database errors, timeout scenarios

## WordPress (PHPUnit/Pest)
- Feature tests for every API endpoint — test the full HTTP lifecycle
- Use `actingAs($user)` for authenticated requests
- Assert response status codes, JSON structure, and database state
- Use `assertDatabaseHas()` / `assertDatabaseMissing()` to verify side effects
- Use `RefreshDatabase` trait for clean state between tests
- Mock external services — never make real API calls in tests

## React (Jest/Vitest + Testing Library)
- Use `@testing-library/react` — test components as users interact with them
- Query by role, label, or text — never query by CSS class or test ID unless necessary
- Use `userEvent` over `fireEvent` for realistic user interactions
- Test loading states, error states, and empty states
- Mock API calls at the network level (MSW) or module level
- Avoid testing implementation details like state values or component internals

## Coverage Targets
- Aim for meaningful coverage, not 100% line coverage
- Critical paths (auth, payments, data mutations) should have thorough coverage
- Utility functions should have unit tests covering edge cases
- UI components should have integration tests covering user flows
- Don't test framework code or third-party library internals

