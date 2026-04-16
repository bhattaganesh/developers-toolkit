---
description: Review API endpoints for consistent naming, response format, error handling, and versioning patterns across the codebase
---

# API Consistency

Audit all API endpoints for inconsistencies in conventions, response format, error handling, and documentation.

## Instructions

1. **Identify scope** — Determine which API endpoints to audit:
   - If the user specifies a module or set of routes, use those
   - If no scope given, scan all route files: `routes/api.php`, REST route registrations, `register_rest_route()` calls

2. **Launch api-consistency** — Use the Task tool to spawn the **api-consistency** agent with the identified route scope.

3. **Present findings** — Group inconsistencies by category:
   - **URL patterns** — Mixed conventions (e.g., `/api/getUsers` vs `/api/users`)
   - **HTTP methods** — Wrong verbs for operations (GET for mutations, etc.)
   - **Response format** — Inconsistent envelope structure, missing `data`, `error`, `meta` fields
   - **Error responses** — Inconsistent HTTP status codes or error message formats
   - **Auth patterns** — Some routes authenticated, equivalent routes not
   - **Versioning** — Routes without version prefix where others have it
   - **Naming** — Plural vs singular, camelCase vs snake_case in URLs

4. **Highlight blast radius** — Flag inconsistencies that affect the most endpoints first.

5. **Summary** — End with: endpoints reviewed, inconsistencies by category, a single recommended convention standard for the team to adopt.

## Dependencies

This command uses the **api-consistency** agent bundled with the developers plugin.
