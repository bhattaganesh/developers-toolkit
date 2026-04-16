---
description: Environment variable validation — ensure all referenced env vars exist in .env.example
globs:
  - "app/**/*.php"
  - "config/**/*.php"
  - "resources/js/**/*.{js,ts}"
---

# Environment Variable Validation

## Core Rules
- Every `env()` call, `config()` reference, or `process.env.` usage must have a corresponding entry in `.env.example`
- Flag any env variables referenced in code but missing from `.env.example`
- Flag any env variables in `.env.example` that are not referenced anywhere in the codebase

## WordPress Specific
- Never use `env()` outside of `config/` files — use `config()` in application code instead
- `env()` values are not cached after `php wp config:cache` — this breaks production
- All env vars should have sensible defaults in config files: `'key' => env('API_KEY', 'default-value')`
- Use `config('services.stripe.key')` not `env('STRIPE_KEY')` in service classes

## JavaScript / React
- Access env vars through the framework's env system (e.g., `NEXT_PUBLIC_` prefix for Next.js, `VITE_` prefix for Vite)
- Never access `process.env` directly in client-side code without the framework prefix
- Create a typed config module that reads env vars in one place

## Documentation
- Mark required vs optional env vars with comments in `.env.example`
- Group related env vars with section headers in `.env.example`
- Include example values that make the format clear (e.g., `DATABASE_URL=mysql://user:pass@localhost:3306/dbname`)
- Document which env vars are required for the app to boot vs which enable optional features

