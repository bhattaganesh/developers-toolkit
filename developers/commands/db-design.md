---
description: Get database schema design, query optimization, and indexing strategy advice from a DBA perspective
---

# DB Design

Get expert database design and optimization guidance using the `dba` agent — schema review, query tuning, and indexing strategy.

## Instructions

1. **Identify the task** — Ask the user what they need:
   - **Schema design** — Design a new table or set of tables for a feature
   - **Query optimization** — A slow query that needs improving
   - **Indexing review** — Find missing or redundant indexes
   - **Data modeling** — Decide between normalization strategies
   - **Migration planning** — Safe approach for large-table schema changes

2. **Gather context** — Collect the relevant information:
   - Existing schema files (`database/migrations/`, `schema.sql`)
   - The slow query or `EXPLAIN` output (for optimization tasks)
   - Approximate table row counts (for index decisions)
   - Database type: MySQL or PostgreSQL

3. **Launch dba** — Use the Task tool to spawn the **dba** agent with the full context.

4. **Present recommendations** — The agent will provide:
   - Schema design with column types, nullability, defaults, and constraints
   - Index recommendations with rationale (why this index improves this query)
   - Query rewrites with `EXPLAIN` output comparison
   - Migration safety notes for large tables

5. **Apply changes** — If the user wants to implement, generate the corresponding WordPress migration or raw SQL.

## What the Agent Covers

- 3NF normalization and when to denormalize with justification
- Foreign key constraints and cascade behavior
- Index types: B-tree, composite, partial, full-text, covering indexes
- `EXPLAIN` / `EXPLAIN ANALYZE` interpretation
- Avoiding N+1 at the schema level (eager loading hints)
- Partitioning strategy for large tables
- MySQL vs PostgreSQL dialect differences

## Dependencies

This command uses the **dba** agent bundled with the developers plugin.

