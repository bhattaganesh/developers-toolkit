---
description: Generate API documentation from WordPress routes, controllers, and Validations
---

# API Docs

Generate API documentation from existing WordPress routes, controllers, and Validations.

## Instructions

1. **Scan routes** — Read `routes/api.php` (and any route files loaded by RouteServiceProvider) to identify all API endpoints.

2. **For each endpoint, extract**:
   - HTTP method and URI
   - Controller and method
   - Middleware (auth, throttle, etc.)
   - Validation validation rules (if any)
   - Response structure from API Resources (if any)
   - Route parameters and their types

3. **Generate documentation** in markdown format:

```markdown
## POST /api/credits

**Description:** Create a new credit entry.

**Auth:** Required (Bearer token)

**Request Body:**
| Field | Type | Required | Rules |
|-------|------|----------|-------|
| amount | number | yes | numeric, min:0.01 |
| description | string | no | max:255 |
| user_id | integer | yes | exists:users,id |

**Success Response (201):**
```json
{
  "data": {
    "id": 1,
    "amount": 50.00,
    "description": "Initial credit",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

**Error Responses:**
- 401 Unauthorized — Missing or invalid token
- 422 Validation Error — Invalid request body
- 403 Forbidden — User not authorized
```

4. **Output options** — Ask the user where to save:
   - `docs/api.md` — Markdown file in the repo
   - Inline in conversation — for quick reference

5. **Verify accuracy** — Cross-reference generated docs with actual controller code to ensure response shapes match.

## Rules

- Document what EXISTS — don't invent endpoints
- Include both success and error response examples
- Note deprecated endpoints if found
- Group endpoints by resource (e.g., Credits, Users, Auth)


