---
description: Trace all usages of a file, method, class, or database column to understand the blast radius before making changes
---

# Impact Analysis

Identify everything that would break if you change a specific piece of code using the `impact-analyzer` agent.

## Instructions

1. **Identify the target** — Ask the user what they plan to change:
   - A file (e.g., `app/Services/CreditService.php`)
   - A method or function (e.g., `CreditService::processPurchase()`)
   - A class or interface (e.g., `PaymentGatewayInterface`)
   - A database column (e.g., `users.plan_id`)
   - A hook or filter (e.g., `myplugin_after_save`)
   - A React component or hook (e.g., `useAuth`)

2. **Launch impact-analyzer** — Use the Task tool to spawn the **impact-analyzer** agent with the target.

3. **Present findings** — Show all usages grouped by type:
   - **Direct callers** — Files that call the method/class directly
   - **Tests** — Existing tests that would break or need updating
   - **API contracts** — REST endpoints or event payloads that rely on the changed structure
   - **Database** — Queries, migrations, or WPDB relationships using the column
   - **Frontend** — Components consuming the changed API response field
   - **Config / env** — Config keys that reference the changed code

4. **Risk summary** — Classify the blast radius:
   - 🔴 High — Core path, many callers, tests would fail
   - 🟡 Medium — Isolated module, few callers
   - 🟢 Low — Single file, well-contained change

5. **Recommended approach** — Suggest a safe migration strategy:
   - Deprecation + adapter pattern
   - Feature flag rollout
   - Parallel run (old + new)
   - Single atomic change

## Dependencies

This command uses the **impact-analyzer** agent bundled with the developers plugin.
Run this BEFORE refactoring, renaming, or removing any method, column, or class.

