---
description: REST API design principles and patterns
globs:
  - "routes/api.php"
  - "app/Http/Controllers/Api/**/*.php"
  - "app/Http/Resources/**/*.php"
  - "app/Http/Requests/**/*.php"
---

# API Design Rules

## URL Structure
- Use nouns, not verbs: `/api/credits` not `/api/getCredits`
- Plural resource names: `/api/users` not `/api/user`
- Nested resources for relationships: `/api/users/{id}/credits`
- Max 2 levels of nesting — flatten beyond that
- Use kebab-case for multi-word resources: `/api/credit-transactions`
- Version prefix when needed: `/api/v1/credits`

## HTTP Methods
- `GET` — Read (never mutate state)
- `POST` — Create new resource
- `PUT` — Full replacement of resource
- `PATCH` — Partial update of resource
- `DELETE` — Remove resource

## Status Codes
- `200` — Success (GET, PUT, PATCH, DELETE)
- `201` — Created (POST)
- `204` — No Content (DELETE with no response body)
- `400` — Bad Request (malformed syntax)
- `401` — Unauthorized (missing or invalid auth)
- `403` — Forbidden (authenticated but not permitted)
- `404` — Not Found
- `422` — Validation Error (valid syntax, invalid data)
- `429` — Too Many Requests (rate limited)
- `500` — Server Error (never expose internals)

## Response Format
- Consistent envelope: `{ "data": {...} }` for single, `{ "data": [...], "meta": {...} }` for lists
- Error format: `{ "message": "Human-readable", "errors": { "field": ["rule"] } }`
- Pagination meta: `{ "meta": { "current_page": 1, "total": 50, "per_page": 15 } }`
- Include `links` for pagination: `{ "links": { "next": "...", "prev": "..." } }`
- Timestamps in ISO 8601: `2024-01-15T10:30:00Z`
- Use API Resources for all response transformation — never return raw models

## Authentication & Security
- Bearer token authentication for API endpoints
- Rate limiting on all endpoints (`throttle` middleware)
- CORS configured for allowed origins only
- Never expose internal IDs unnecessarily — consider UUIDs for public-facing APIs
- Validate Content-Type header on POST/PUT/PATCH
- Log failed authentication attempts

## Filtering, Sorting, Pagination
- Filter via query params: `?status=active&type=credit`
- Sort via query param: `?sort=created_at&order=desc`
- Paginate all list endpoints — never return unbounded results
- Default pagination: 15 items per page
- Allow `?per_page=` with max limit (e.g., 100)

## Versioning
- When needed, use URL prefix: `/api/v1/`, `/api/v2/`
- Never break existing clients — add new fields, don't remove or rename
- Deprecation: add `Sunset` header before removing endpoints
