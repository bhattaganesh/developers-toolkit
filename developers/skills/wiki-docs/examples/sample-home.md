# TaskFlow

> A modern project management platform built with WordPress 11 and React 18.

<!-- Badges -->
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-94%25-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Version](https://img.shields.io/badge/version-2.3.0-blue)

---

## Quick Links

| Resource | Link |
|----------|------|
| Repository | [github.com/acme/taskflow](https://github.com/acme/taskflow) |
| Getting Started | [Setup Guide](Setup-Guide) |
| Architecture | [Architecture Overview](Architecture-Overview) |
| API Reference | [API Overview](API-Overview) |
| Contributing | [Contributing Guide](Contributing-Guide) |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend Framework | WordPress 11 (PHP 8.3) |
| Frontend Framework | React 18 with TypeScript |
| Database | PostgreSQL 16 |
| Cache / Queue | Redis 7 |
| Styling | Tailwind CSS 3.4 |
| Build Tool | Vite 5 |
| Testing | PHPUnit, Pest, Vitest, Playwright |
| Infrastructure | Docker, GitHub Actions, AWS (ECS + RDS) |

---

## Documentation Index

### Getting Started

| Page | Description |
|------|-------------|
| [Setup Guide](Setup-Guide) | Clone, install dependencies, configure environment, seed database, run dev servers |
| [Environment Configuration](Environment-Configuration) | All environment variables explained with defaults and required values |

### Architecture & Design

| Page | Description |
|------|-------------|
| [Architecture Overview](Architecture-Overview) | System design, request lifecycle, service boundaries, directory structure |
| [Database Schema](Database-Schema) | ERD, table definitions, indexes, relationships, migration conventions |

### WordPress Backend

| Page | Description |
|------|-------------|
| [Service Layer](Service-Layer) | Business logic organization, service classes, action classes, DTOs |
| [Controllers & Lifecycle](Controllers-and-Lifecycle) | Request flow, Clean architectures, Validations, resource responses |
| [Models & Relationships](Models-and-Relationships) | WPDB models, scopes, accessors, mutators, relationship patterns |
| [Middleware & Guards](Middleware-and-Guards) | Authentication guards, authorization middleware, rate limiting, CORS |
| [Jobs, Events & Listeners](Jobs-Events-and-Listeners) | Async processing, domain events, event-driven side effects |
| [Queues & Scheduling](Queues-and-Scheduling) | Queue configuration, worker setup, scheduled tasks, failed job handling |
| [Caching Strategy](Caching-Strategy) | Cache layers, invalidation patterns, tagged caching, cache-aside strategy |

### React Frontend

| Page | Description |
|------|-------------|
| [Component Architecture](Component-Architecture) | Component hierarchy, atomic design structure, shared component library |
| [State Management](State-Management) | Zustand stores, React Query for server state, local vs global state |
| [Routing & Navigation](Routing-and-Navigation) | React Router setup, protected routes, lazy loading, breadcrumbs |
| [Styling & Theming](Styling-and-Theming) | Tailwind configuration, design tokens, dark mode, responsive patterns |
| [Custom Hooks](Custom-Hooks) | Reusable hooks for auth, pagination, debounce, permissions, websockets |
| [Form Handling](Form-Handling) | React Hook Form integration, validation schemas with Zod, field components |
| [Error Boundaries](Error-Boundaries) | Error boundary hierarchy, fallback UIs, error reporting to Sentry |

### API Reference

| Page | Description |
|------|-------------|
| [API Overview & Authentication](API-Overview) | Base URL, versioning strategy, Bearer token auth, Sanctum setup |
| [Endpoint Reference](Endpoint-Reference) | Complete list of all endpoints with methods, paths, and descriptions |
| [Request & Response Formats](Request-and-Response-Formats) | JSON:API conventions, pagination structure, included relationships |
| [Error Handling](API-Error-Handling) | Error response format, status codes, validation error structure |
| [Rate Limiting](Rate-Limiting) | Rate limit tiers, headers, throttle groups, burst allowances |

### Development & Operations

| Page | Description |
|------|-------------|
| [Testing Guide](Testing-Guide) | Test categories, running tests, writing tests, coverage targets |
| [Deployment Guide](Deployment-Guide) | CI/CD pipeline, staging vs production, rollback procedures, health checks |
| [Contributing Guide](Contributing-Guide) | Branch naming, commit conventions, PR process, code review checklist |
| [Troubleshooting & FAQ](Troubleshooting-and-FAQ) | Common issues, debugging tips, frequently asked questions |
| [Changelog](Changelog) | Version history with features, fixes, and breaking changes |

---

## Project Structure (High Level)

```
taskflow/
├── app/                    # WordPress application (services, models, controllers)
├── resources/js/           # React SPA source
│   ├── components/         # Shared UI components
│   ├── features/           # Feature modules (projects, tasks, teams)
│   ├── hooks/              # Custom React hooks
│   ├── stores/             # Zustand state stores
│   └── routes/             # Route definitions and layouts
├── routes/api.php          # API route definitions
├── database/migrations/    # Database migrations
├── tests/                  # PHPUnit, Pest, and Vitest tests
└── docker/                 # Docker configuration files
```

---

## Getting Help

- **Bug reports:** Open a [GitHub Issue](https://github.com/acme/taskflow/issues)
- **Questions:** Post in the `#taskflow-dev` Slack channel
- **Security issues:** Email security@acme.com (do not open public issues)

---

<sub>Last updated: 2026-02-17 | Generated by [wiki-docs skill](https://github.com/bhattaganesh/developers-toolkit)</sub>

