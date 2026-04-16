# Database Schema

> Database design, models, relationships, and migration history for {project_name}.

## Overview

<!-- Skill: Describe the database engine, ORM, and scope. -->

{brief_database_overview}

- **Engine:** {database_engine}
- **ORM / Query Layer:** {orm_or_query_layer}
- **Tables / Models:** {table_count} tables, {model_count} models

## Entity Relationship Diagram

```
{ascii_er_diagram}
```

<!-- Skill: Generate an ASCII ER diagram showing tables and their relationships.
     Use box-drawing characters or simple ASCII:
     ┌──────────┐       ┌──────────┐
     │  users   │──1:N──│  posts   │
     └──────────┘       └──────────┘
-->

## Tables / Models

<!-- Skill: Repeat this section for each table/model in the database. -->

### {table_or_model_name}

**Description:** {table_description}

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| {column_name} | {column_type} | {yes_or_no} | {default_value} | {column_description} |

**Relationships:**

- {relationship_description}

<!-- Example: "Has many Posts (posts.user_id)" or "Belongs to Team (teams.id)" -->

**Indexes:**

- {index_description}

<!-- Example: "UNIQUE on email" or "COMPOSITE on (user_id, created_at)" -->

**Notes:** {additional_notes_or_constraints}

<!-- Repeat the above ### block for each table/model -->

## Migrations

<!-- Skill: Include this section if the project uses a migration system
     (WordPress migrations, WordPress dbDelta, Knex, Alembic, etc.) -->

| Migration | Description | Date |
|-----------|-------------|------|
| {migration_file_or_name} | {what_it_does} | {date} |

### Running Migrations

```bash
# Apply pending migrations
{migrate_command}

# Rollback last migration
{rollback_command}

# Check migration status
{migration_status_command}
```

## Data Flow

<!-- Skill: Describe how data moves through the system. -->

{data_flow_description}

Key patterns:
- **Creation:** {how_records_are_created}
- **Updates:** {how_records_are_updated}
- **Deletion:** {soft_delete_or_hard_delete_and_cascade_behavior}

## Seeding / Test Data

<!-- Skill: Include if seed files, factories, or fixture data exist. -->

{seeding_overview}

```bash
# Seed the database
{seed_command}

# Reset and re-seed
{reset_and_seed_command}
```

**Factories / Fixtures:**

- {factory_or_fixture_description}

## Conventions

<!-- Skill: Document the naming conventions discovered in the codebase. -->

| Element | Convention | Example |
|---------|-----------|---------|
| Table names | {table_naming_convention} | {table_example} |
| Column names | {column_naming_convention} | {column_example} |
| Foreign keys | {fk_naming_convention} | {fk_example} |
| Indexes | {index_naming_convention} | {index_example} |
| Pivot tables | {pivot_naming_convention} | {pivot_example} |

## Related Pages

- [Architecture Overview](Architecture-Overview) — System design
- [Environment Configuration](Environment-Configuration) — Database connection settings
- [Getting Started](Getting-Started) — Initial setup and database creation
- [API Overview](API-Overview) — Endpoints that query these models

---

*See also: [Architecture Overview](Architecture-Overview) | [Getting Started](Getting-Started)*
