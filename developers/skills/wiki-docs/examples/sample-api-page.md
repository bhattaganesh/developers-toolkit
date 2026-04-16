# Endpoint Reference

Complete reference for all TaskFlow API endpoints. All endpoints require authentication unless noted otherwise.

> **Base URL:** `https://api.taskflow.acme.com/api/v1`
> **Auth:** Bearer token via WordPress Sanctum (see [API Overview](API-Overview))

---

## Projects

Manage projects within a workspace. A project contains tasks, members, and milestones.

### Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/projects` | List all projects for the authenticated user |
| `POST` | `/projects` | Create a new project |
| `GET` | `/projects/{id}` | Get a single project by ID |
| `PUT` | `/projects/{id}` | Update a project |
| `DELETE` | `/projects/{id}` | Soft-delete a project |
| `POST` | `/projects/{id}/archive` | Archive a project |
| `POST` | `/projects/{id}/restore` | Restore an archived or deleted project |
| `GET` | `/projects/{id}/members` | List project members |
| `POST` | `/projects/{id}/members` | Add a member to a project |
| `DELETE` | `/projects/{id}/members/{userId}` | Remove a member from a project |

---

### List Projects

Retrieve a paginated list of projects the authenticated user has access to.

```
GET /api/v1/projects
```

**Query Parameters**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | `1` | Page number |
| `per_page` | integer | `15` | Items per page (max: 100) |
| `status` | string | `all` | Filter by status: `active`, `archived`, `all` |
| `search` | string | — | Search by project name or description |
| `sort` | string | `updated_at` | Sort field: `name`, `created_at`, `updated_at` |
| `direction` | string | `desc` | Sort direction: `asc`, `desc` |

**Example Request**

```bash
curl -X GET "https://api.taskflow.acme.com/api/v1/projects?status=active&per_page=10&search=redesign" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Accept: application/json"
```

**Example Response** `200 OK`

```json
{
  "data": [
    {
      "id": 42,
      "name": "Website Redesign",
      "description": "Complete overhaul of the marketing website with new brand guidelines.",
      "status": "active",
      "color": "#4F46E5",
      "owner": {
        "id": 7,
        "name": "Sarah Chen",
        "avatar_url": "https://cdn.taskflow.acme.com/avatars/7.jpg"
      },
      "members_count": 8,
      "tasks_count": 134,
      "completed_tasks_count": 89,
      "created_at": "2026-01-10T09:00:00Z",
      "updated_at": "2026-02-15T14:32:00Z"
    },
    {
      "id": 38,
      "name": "Mobile App Redesign",
      "description": "Redesign the iOS and Android apps to match the new design system.",
      "status": "active",
      "color": "#0891B2",
      "owner": {
        "id": 3,
        "name": "Marcus Johnson",
        "avatar_url": "https://cdn.taskflow.acme.com/avatars/3.jpg"
      },
      "members_count": 5,
      "tasks_count": 67,
      "completed_tasks_count": 22,
      "created_at": "2026-01-22T11:15:00Z",
      "updated_at": "2026-02-14T09:45:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 10,
    "total": 2
  },
  "links": {
    "first": "https://api.taskflow.acme.com/api/v1/projects?page=1",
    "last": "https://api.taskflow.acme.com/api/v1/projects?page=1",
    "prev": null,
    "next": null
  }
}
```

**Controller:** `app/Http/Controllers/Api/V1/ProjectController.php@index`
**Validation:** `app/Http/Requests/Api/V1/ListProjectsRequest.php`
**Resource:** `app/Http/Resources/Api/V1/ProjectResource.php`

---

### Create Project

Create a new project in the authenticated user's workspace. The creating user is automatically assigned as the project owner.

```
POST /api/v1/projects
```

**Request Body**

| Field | Type | Required | Rules | Description |
|-------|------|----------|-------|-------------|
| `name` | string | Yes | min:3, max:255 | Project name |
| `description` | string | No | max:2000 | Project description |
| `color` | string | No | hex_color | Hex color code for the project (default: randomly assigned) |
| `template_id` | integer | No | exists:project_templates,id | Clone structure from an existing template |
| `member_ids` | array | No | array of existing user IDs | Users to invite as members on creation |

**Example Request**

```bash
curl -X POST "https://api.taskflow.acme.com/api/v1/projects" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "name": "Q2 Marketing Campaign",
    "description": "Plan and execute the Q2 2026 multi-channel marketing campaign targeting enterprise customers.",
    "color": "#DC2626",
    "member_ids": [3, 12, 15]
  }'
```

**Example Response** `201 Created`

```json
{
  "data": {
    "id": 56,
    "name": "Q2 Marketing Campaign",
    "description": "Plan and execute the Q2 2026 multi-channel marketing campaign targeting enterprise customers.",
    "status": "active",
    "color": "#DC2626",
    "owner": {
      "id": 7,
      "name": "Sarah Chen",
      "avatar_url": "https://cdn.taskflow.acme.com/avatars/7.jpg"
    },
    "members_count": 4,
    "tasks_count": 0,
    "completed_tasks_count": 0,
    "created_at": "2026-02-17T10:30:00Z",
    "updated_at": "2026-02-17T10:30:00Z"
  }
}
```

**Controller:** `app/Http/Controllers/Api/V1/ProjectController.php@store`
**Validation:** `app/Http/Requests/Api/V1/StoreProjectRequest.php`
**Capability:** `app/Policies/ProjectCapability.php@create`

---

### Update Project

Update an existing project. Supports partial updates -- only include the fields you want to change. Requires `manage` permission on the project (owner or admin role).

```
PUT /api/v1/projects/{id}
```

**Path Parameters**

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | integer | The project ID |

**Request Body**

| Field | Type | Required | Rules | Description |
|-------|------|----------|-------|-------------|
| `name` | string | No | min:3, max:255 | Updated project name |
| `description` | string | No | max:2000 | Updated description (send `null` to clear) |
| `color` | string | No | hex_color | Updated hex color code |
| `status` | string | No | in:active,on_hold | Change project status |

**Example Request**

```bash
curl -X PUT "https://api.taskflow.acme.com/api/v1/projects/42" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "name": "Website Redesign v2",
    "status": "on_hold"
  }'
```

**Example Response** `200 OK`

```json
{
  "data": {
    "id": 42,
    "name": "Website Redesign v2",
    "description": "Complete overhaul of the marketing website with new brand guidelines.",
    "status": "on_hold",
    "color": "#4F46E5",
    "owner": {
      "id": 7,
      "name": "Sarah Chen",
      "avatar_url": "https://cdn.taskflow.acme.com/avatars/7.jpg"
    },
    "members_count": 8,
    "tasks_count": 134,
    "completed_tasks_count": 89,
    "created_at": "2026-01-10T09:00:00Z",
    "updated_at": "2026-02-17T11:00:00Z"
  }
}
```

**Controller:** `app/Http/Controllers/Api/V1/ProjectController.php@update`
**Validation:** `app/Http/Requests/Api/V1/UpdateProjectRequest.php`
**Capability:** `app/Policies/ProjectCapability.php@update`

---

### Delete Project

Soft-delete a project. The project and its tasks are hidden from listings but remain in the database for 30 days. Use the [restore endpoint](#restore-project) to recover a deleted project. Requires `owner` role on the project.

```
DELETE /api/v1/projects/{id}
```

**Path Parameters**

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | integer | The project ID |

**Example Request**

```bash
curl -X DELETE "https://api.taskflow.acme.com/api/v1/projects/42" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Accept: application/json"
```

**Example Response** `200 OK`

```json
{
  "message": "Project has been deleted. It can be restored within 30 days.",
  "data": {
    "id": 42,
    "deleted_at": "2026-02-17T11:15:00Z",
    "restore_deadline": "2026-03-19T11:15:00Z"
  }
}
```

> **Note:** Permanently deleting a project requires a separate admin action and is not available via the API. After 30 days, a scheduled job (`app/Jobs/PurgeDeletedProjects.php`) permanently removes the project and all associated data.

**Controller:** `app/Http/Controllers/Api/V1/ProjectController.php@destroy`
**Capability:** `app/Policies/ProjectCapability.php@delete`

---

## Authentication

All endpoints require a valid Bearer token in the `Authorization` header. Tokens are issued via WordPress Sanctum.

```
Authorization: Bearer YOUR_API_TOKEN
```

Tokens can be generated through:
- **Login endpoint:** `POST /api/v1/auth/login` returns a token on successful authentication
- **User settings:** Users can create personal access tokens from the Settings > API Tokens page

See [API Overview](API-Overview) for complete authentication documentation.

---

## Error Responses

All errors follow a consistent structure. See [Error Handling](API-Error-Handling) for the complete reference.

### Validation Error `422 Unprocessable Entity`

Returned when request data fails validation rules.

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "name": [
      "The name field is required.",
      "The name must be at least 3 characters."
    ],
    "color": [
      "The color must be a valid hex color code."
    ]
  }
}
```

### Not Found `404 Not Found`

Returned when the requested resource does not exist or the user does not have access.

```json
{
  "message": "Project not found.",
  "error_code": "RESOURCE_NOT_FOUND"
}
```

### Unauthorized `401 Unauthorized`

Returned when the request is missing a valid authentication token.

```json
{
  "message": "Unauthenticated.",
  "error_code": "UNAUTHENTICATED"
}
```

### Forbidden `403 Forbidden`

Returned when the authenticated user lacks permission for the requested action.

```json
{
  "message": "You do not have permission to update this project.",
  "error_code": "FORBIDDEN"
}
```

### Rate Limited `429 Too Many Requests`

Returned when the client exceeds the rate limit. See [Rate Limiting](Rate-Limiting) for tier details.

```json
{
  "message": "Too many requests. Please try again in 30 seconds.",
  "error_code": "RATE_LIMITED",
  "retry_after": 30
}
```

---

## Related Pages

- [API Overview & Authentication](API-Overview) -- Base URL, versioning, token management
- [Request & Response Formats](Request-and-Response-Formats) -- Pagination, includes, sparse fieldsets
- [Error Handling](API-Error-Handling) -- Complete error code reference
- [Rate Limiting](Rate-Limiting) -- Rate limit tiers, headers, best practices

---

<sub>Last updated: 2026-02-17 | Generated by [wiki-docs skill](https://github.com/bhattaganesh/developers-toolkit)</sub>

