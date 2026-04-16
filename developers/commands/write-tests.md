---
description: Generate tests for a controller, component, or service using TDD patterns
---

# Write Tests

Generate tests for a controller, component, or service following test-driven development patterns.

## Instructions

1. **Identify target** — Ask what to test:
   - A specific controller, service, or component
   - A recent feature or PR (use `git diff` to find changed files)
   - Gaps found by `/commands:test-gaps`

2. **Analyze the target** — Read the source file and understand:
   - Public methods and their signatures
   - Dependencies (injected services, models, external APIs)
   - Validation rules (Validations, Zod schemas)
   - Authorization checks (Policies, middleware)
   - Edge cases (nullable fields, empty arrays, boundary values)

3. **Generate tests by stack**:

### WordPress / PHPUnit
- Create test file in `tests/Feature/` (API endpoints) or `tests/Unit/` (services)
- Use `RefreshDatabase` trait
- Use factories for test data — never hardcode IDs
- Use `actingAs($user)` for authenticated requests
- Cover per endpoint:
  - Success case with valid data
  - 401 for unauthenticated request
  - 403 for unauthorized user
  - 422 for each validation rule
  - 404 for non-existent resource
  - Edge cases specific to the endpoint
- Name tests descriptively: `test_user_can_create_credit_with_valid_data`

### React / Jest
- Create test file next to component: `ComponentName.test.jsx`
- Use `@testing-library/react` and `userEvent`
- Mock API calls with `jest.mock` or MSW
- Cover:
  - Renders without crashing
  - Renders correct content based on props
  - User interactions (click, submit, type)
  - Loading, success, and error states
  - Conditional rendering

4. **Write the tests** — Generate complete, runnable test files. Follow existing test patterns in the project if they exist.

5. **Verify** — Run the tests to confirm they pass:
   - WordPress: `php wp test --filter=TestClassName`
   - React: `npm test -- --testPathPattern=ComponentName`

## Rules

- Follow existing test patterns in the project (check `tests/` directory first)
- One test method per behavior — not one giant test
- Tests must be deterministic — no random data, timestamps, or external calls
- Mock external dependencies — never hit real APIs or databases in unit tests
- Assert specific values — not just "no error"


