---
description: Trace execution path of a file, class, or route — produces ASCII diagram and lists all related files
---

# Explain

Trace the full execution path of a file, class, or route and produce a visual diagram.

## Instructions

1. **Accept input** — Take one of the following as input from the user:
   - A file path (e.g., `app/Services/CreditService.php`)
   - A class name (e.g., `CreditService`)
   - A route (e.g., `POST /api/credits/purchase`)
   - A feature name (e.g., "credit purchasing flow")

2. **Trace execution path** — Follow the full request lifecycle:
   - **Route** → Which route file and URI pattern
   - **Middleware** → Auth, rate limiting, validation middleware applied
   - **Controller** → Which controller and method handles the request
   - **Validation** → Validation rules if a FormRequest is used
   - **Service** → Business logic layer
   - **Model** → WPDB models and relationships involved
   - **Events/Jobs** → Any events dispatched or jobs queued
   - **Response** → What gets returned (Resource, JSON, redirect)

3. **Produce ASCII diagram** — Create a clear ASCII flow diagram showing:
   - The data flow from entry point to response
   - Branching paths (conditionals, error handling)
   - External service calls if any
   - Example:
     ```
     Request → Route (api.php)
       → AuthMiddleware
       → CreditController@purchase
         → PurchaseRequest (validation)
         → CreditService@processPurchase
           → User::find()
           → CreditTransaction::create()
           → PurchaseCompleted event
         → CreditResource (response)
     ```

4. **List all related files** — Provide a complete list of every file involved:
   - File path and its role in the flow
   - Group by layer (routing, middleware, controller, service, model, etc.)
   - Include test files if they exist

5. **Highlight key details** — Call out:
   - Any complex business logic or edge cases
   - External dependencies (APIs, queues, cache)
   - Potential failure points

