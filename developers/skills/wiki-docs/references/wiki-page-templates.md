# Wiki Page Templates Reference

## Template Principles

### Heading Structure
- `# Page Title` — one per page, matches the file name
- `## Major Section` — top-level content divisions
- `### Sub-section` — detailed breakdowns within sections
- `#### Detail Level` — rarely needed, used for deeply nested information

### Content Guidelines
- **Target word count:** 500-2000 words per page (shorter for reference pages, longer for architectural overviews)
- **Code examples:** Include at least one code example per major section where applicable
- **Cross-linking:** Use `[Display Text](Page-Name)` format (no `.md` extension)
- **Placeholder syntax:** All dynamic values use `{placeholder_name}` — never hardcode project-specific values
- **Tables:** Use for structured data (endpoints, config variables, commands)
- **ASCII diagrams:** Use for architecture and data flow visualization

### Placeholder Reference

Common placeholders used across templates:

| Placeholder | Description |
|-------------|-------------|
| `{project_name}` | Name of the project |
| `{project_description}` | Short description of the project |
| `{repo_url}` | GitHub repository URL |
| `{base_url}` | API or application base URL |
| `{primary_stack}` | Main tech stack (WordPress, React, etc.) |
| `{php_version}` | Required PHP version |
| `{node_version}` | Required Node.js version |
| `{package_manager}` | npm, yarn, or pnpm |
| `{db_type}` | Database engine (MySQL, PostgreSQL, SQLite) |
| `{auth_method}` | Authentication method (Sanctum, JWT, OAuth) |
| `{ci_platform}` | CI/CD platform (GitHub Actions, GitLab CI) |
| `{deploy_target}` | Deployment target (AWS, Vercel, etc.) |

---

## Common Pages (12 Templates)

These pages are generated for every project regardless of tech stack.

---

### Template: Home.md

```markdown
# {project_name}

> {project_description}

## Quick Links

| Resource | Link |
|----------|------|
| Getting Started | [Getting Started](Getting-Started) |
| Architecture | [Architecture Overview](Architecture-Overview) |
| API Reference | [API Overview](API-Overview-Authentication) |
| Contributing | [Contributing Guide](Contributing-Guide) |
| Changelog | [Changelog](Changelog) |

## Overview

{project_overview_paragraph}

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | {backend_stack} |
| Frontend | {frontend_stack} |
| Database | {db_type} |
| Testing | {test_framework} |
| CI/CD | {ci_platform} |

## Project Status

- **Version:** {current_version}
- **License:** {license_type}
- **Last Updated:** {last_update_date}

## Table of Contents

{auto_generated_table_of_contents_from_sidebar}
```

---

### Template: Getting-Started.md

```markdown
# Getting Started

## Prerequisites

| Requirement | Version | Check Command |
|-------------|---------|--------------|
| {prerequisite_name} | {required_version} | `{check_command}` |

## Installation

### 1. Clone the Repository

\`\`\`bash
git clone {repo_url}
cd {project_directory}
\`\`\`

### 2. Install Dependencies

\`\`\`bash
{install_command}
\`\`\`

### 3. Environment Setup

\`\`\`bash
{env_setup_command}
\`\`\`

Edit `{env_file}` and configure:

| Variable | Description | Example |
|----------|-------------|---------|
| `{env_var_name}` | {env_var_description} | `{env_var_example}` |

### 4. Database Setup

\`\`\`bash
{database_setup_command}
\`\`\`

### 5. Start Development Server

\`\`\`bash
{dev_server_command}
\`\`\`

The application should now be running at `{dev_url}`.

## Verification

To verify everything is working:

\`\`\`bash
{verification_command}
\`\`\`

## Next Steps

- Read the [Architecture Overview](Architecture-Overview) to understand the codebase
- Check the [Contributing Guide](Contributing-Guide) before making changes
- Review the [Environment Configuration](Environment-Configuration) for all available settings
```

---

### Template: Architecture-Overview.md

```markdown
# Architecture Overview

## High-Level Design

{architecture_description}

\`\`\`
{ascii_architecture_diagram}
\`\`\`

## Project Structure

\`\`\`
{directory_tree}
\`\`\`

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `{directory_path}` | {directory_description} |

## Core Components

### {component_name}

**Purpose:** {component_purpose}
**Location:** `{component_path}`

{component_description}

## Data Flow

\`\`\`
{ascii_data_flow_diagram}
\`\`\`

{data_flow_description}

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| {decision_description} | {decision_rationale} |

## Related Pages

- [Database Schema](Database-Schema)
- [Environment Configuration](Environment-Configuration)
- [{stack_specific_page}]({stack_specific_page_link})
```

---

### Template: Database-Schema.md

```markdown
# Database Schema

## Overview

{database_overview}

**Database Engine:** {db_type}
**ORM:** {orm_name}

## Entity Relationship Diagram

\`\`\`
{ascii_er_diagram}
\`\`\`

## Tables

### {table_name}

**Model:** `{model_class}` (`{model_file_path}`)

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `{column_name}` | {column_type} | {nullable} | {default_value} | {column_description} |

**Relationships:**

| Relationship | Type | Related Model | Foreign Key |
|-------------|------|---------------|-------------|
| `{relationship_name}` | {relationship_type} | `{related_model}` | `{foreign_key}` |

**Indexes:**

| Name | Columns | Type |
|------|---------|------|
| `{index_name}` | `{index_columns}` | {index_type} |

## Migrations

| Migration | Description | Date |
|-----------|-------------|------|
| `{migration_file}` | {migration_description} | {migration_date} |

## Notes

- {schema_note}
```

---

### Template: Environment-Configuration.md

```markdown
# Environment Configuration

## Overview

{env_overview}

## Required Variables

| Variable | Description | Example | Where Used |
|----------|-------------|---------|-----------|
| `{var_name}` | {var_description} | `{var_example}` | {var_usage_location} |

## Optional Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `{var_name}` | {var_description} | `{var_default}` | `{var_example}` |

## Configuration Files

| File | Purpose | Stack |
|------|---------|-------|
| `{config_file_path}` | {config_description} | {config_stack} |

## Per-Environment Settings

### Development

\`\`\`env
{dev_env_values}
\`\`\`

### Staging

\`\`\`env
{staging_env_values}
\`\`\`

### Production

\`\`\`env
{production_env_values}
\`\`\`

## Secrets Management

{secrets_management_description}

## Related Pages

- [Getting Started](Getting-Started) — initial setup
- [Deployment Guide](Deployment-Guide) — production configuration
```

---

### Template: Testing-Guide.md

```markdown
# Testing Guide

## Overview

{testing_overview}

**Test Framework:** {test_framework}
**Test Runner:** {test_runner}

## Running Tests

### All Tests

\`\`\`bash
{run_all_tests_command}
\`\`\`

### Specific Test Suites

\`\`\`bash
{run_unit_tests_command}
{run_feature_tests_command}
{run_integration_tests_command}
\`\`\`

### Single Test File

\`\`\`bash
{run_single_test_command}
\`\`\`

## Test Structure

\`\`\`
{test_directory_tree}
\`\`\`

| Directory | Test Type | Description |
|-----------|-----------|-------------|
| `{test_dir}` | {test_type} | {test_description} |

## Writing Tests

### Naming Conventions

- Test files: `{test_file_naming_pattern}`
- Test methods: `{test_method_naming_pattern}`
- Test classes: `{test_class_naming_pattern}`

### Example Test

\`\`\`{language}
{example_test_code}
\`\`\`

## Coverage

\`\`\`bash
{coverage_command}
\`\`\`

**Coverage target:** {coverage_target}

## CI Testing

Tests run automatically on {ci_trigger_events} via [{ci_platform}]({ci_workflow_link}).

## Related Pages

- [Contributing Guide](Contributing-Guide) — PR requirements include tests
```

---

### Template: Deployment-Guide.md

```markdown
# Deployment Guide

## Environments

| Environment | URL | Branch | Auto-Deploy |
|-------------|-----|--------|-------------|
| {env_name} | `{env_url}` | `{env_branch}` | {auto_deploy} |

## CI/CD Pipeline

**Platform:** {ci_platform}

### Pipeline Stages

\`\`\`
{ascii_pipeline_diagram}
\`\`\`

| Stage | Description | Trigger |
|-------|-------------|---------|
| {stage_name} | {stage_description} | {stage_trigger} |

## Deployment Process

### Automated Deployment

{auto_deploy_description}

### Manual Deployment

\`\`\`bash
{manual_deploy_steps}
\`\`\`

## Pre-Deployment Checklist

- [ ] All tests passing
- [ ] Database migrations reviewed
- [ ] Environment variables updated on target
- [ ] {custom_checklist_item}

## Rollback Procedure

\`\`\`bash
{rollback_command}
\`\`\`

## Monitoring

{monitoring_description}

## Related Pages

- [Environment Configuration](Environment-Configuration)
- [Testing Guide](Testing-Guide)
```

---

### Template: Contributing-Guide.md

```markdown
# Contributing Guide

## Getting Started

1. Fork the repository (or create a branch if you have write access)
2. Follow the [Getting Started](Getting-Started) guide for local setup
3. Create a feature branch from `{default_branch}`

## Git Workflow

### Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `{feature_branch_pattern}` | `{feature_branch_example}` |
| Bug Fix | `{bugfix_branch_pattern}` | `{bugfix_branch_example}` |
| Hotfix | `{hotfix_branch_pattern}` | `{hotfix_branch_example}` |

### Commit Messages

{commit_message_format_description}

\`\`\`
{commit_message_example}
\`\`\`

## Pull Request Process

1. {pr_step_1}
2. {pr_step_2}
3. {pr_step_3}

### PR Template

\`\`\`markdown
{pr_template}
\`\`\`

## Coding Standards

{coding_standards_summary}

See stack-specific standards:
- [{stack_name} Standards]({stack_standards_link})

## Code Review Checklist

- [ ] Code follows project conventions
- [ ] Tests added for new functionality
- [ ] Documentation updated if needed
- [ ] No debug code left behind
- [ ] {custom_review_item}
```

---

### Template: Troubleshooting-FAQ.md

```markdown
# Troubleshooting & FAQ

## Common Issues

### {issue_title}

**Symptoms:** {issue_symptoms}

**Cause:** {issue_cause}

**Solution:**

\`\`\`bash
{issue_solution}
\`\`\`

---

## Frequently Asked Questions

### {faq_question}

{faq_answer}

---

## Getting Help

- Check existing [GitHub Issues]({repo_url}/issues)
- Review the [Architecture Overview](Architecture-Overview) for system understanding
- Search the wiki using the sidebar navigation

## Error Reference

| Error Code/Message | Meaning | Resolution |
|---------------------|---------|------------|
| `{error_message}` | {error_meaning} | {error_resolution} |
```

---

### Template: Changelog.md

```markdown
# Changelog

All notable changes to {project_name} are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/).

## [{version}] - {release_date}

### Added
- {added_item}

### Changed
- {changed_item}

### Fixed
- {fixed_item}

### Deprecated
- {deprecated_item}

### Removed
- {removed_item}

### Security
- {security_item}

---

{repeat_for_each_version}
```

---

### Template: _Sidebar.md

```markdown
**[{project_name} Wiki](Home)**

---

**Getting Started**
- [Getting Started](Getting-Started)
- [Architecture Overview](Architecture-Overview)
- [Environment Configuration](Environment-Configuration)

**{backend_stack_section_name}**
- [{backend_page_title}]({backend_page_link})

**{frontend_stack_section_name}**
- [{frontend_page_title}]({frontend_page_link})

**API Reference**
- [API Overview & Authentication](API-Overview-Authentication)
- [Endpoint Reference](Endpoint-Reference)
- [Request & Response Formats](Request-Response-Formats)
- [Error Handling & Status Codes](Error-Handling-Status-Codes)
- [Rate Limiting & Pagination](Rate-Limiting-Pagination)

**Database**
- [Database Schema](Database-Schema)

**Development**
- [Testing Guide](Testing-Guide)
- [Contributing Guide](Contributing-Guide)
- [Deployment Guide](Deployment-Guide)

**Reference**
- [Troubleshooting & FAQ](Troubleshooting-FAQ)
- [Changelog](Changelog)
```

---

### Template: _Footer.md

```markdown
---

[{project_name}]({repo_url}) | [Report Issue]({repo_url}/issues/new) | Generated from source code analysis

Last updated: {generation_date}
```

---

## WordPress Pages (7 Templates)

---

### Template: Service-Layer-Architecture.md

```markdown
# Service Layer Architecture

## Overview

{service_layer_overview}

## Pattern

\`\`\`
Controller -> FormRequest -> Service -> Model -> Response
\`\`\`

{pattern_description}

## Service Classes

| Service | Purpose | Location |
|---------|---------|----------|
| `{service_class}` | {service_purpose} | `{service_path}` |

### {service_class_name}

**File:** `{service_file_path}`

**Methods:**

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `{method_name}` | `{method_params}` | `{return_type}` | {method_description} |

**Example Usage:**

\`\`\`php
{service_usage_example}
\`\`\`

## Dependency Injection

{dependency_injection_description}

\`\`\`php
{di_example}
\`\`\`

## Related Pages

- [Controllers & Request Lifecycle](Controllers-Request-Lifecycle)
- [Models & Relationships](Models-Relationships)
```

---

### Template: Controllers-Request-Lifecycle.md

```markdown
# Controllers & Request Lifecycle

## Request Lifecycle

\`\`\`
{ascii_request_lifecycle_diagram}
\`\`\`

{lifecycle_description}

## Controllers

| Controller | Resource | Methods | Route Prefix |
|-----------|----------|---------|-------------|
| `{controller_name}` | {resource_name} | {http_methods} | `{route_prefix}` |

### {controller_name}

**File:** `{controller_file_path}`

| Action | Route | Middleware | Description |
|--------|-------|-----------|-------------|
| `{action_name}` | `{route_method} {route_path}` | {middleware_list} | {action_description} |

## Validations

| Request Class | Controller Action | Validation Rules |
|--------------|-------------------|-----------------|
| `{request_class}` | `{controller_action}` | {rules_summary} |

### Example Validation

\`\`\`php
{form_request_example}
\`\`\`

## API Resources

| Resource | Model | Fields |
|----------|-------|--------|
| `{resource_class}` | `{model_class}` | {fields_list} |

## Response Patterns

{response_pattern_description}

\`\`\`php
{response_example}
\`\`\`
```

---

### Template: Models-Relationships.md

```markdown
# Models & Relationships

## Overview

{models_overview}

## Relationship Diagram

\`\`\`
{ascii_relationship_diagram}
\`\`\`

## Models

### {model_name}

**File:** `{model_file_path}`
**Table:** `{table_name}`

**Fillable:**
\`\`\`php
{fillable_array}
\`\`\`

**Relationships:**

| Method | Type | Related Model | Description |
|--------|------|---------------|-------------|
| `{relationship_method}` | {relationship_type} | `{related_model}` | {relationship_description} |

**Scopes:**

| Scope | Parameters | Description |
|-------|-----------|-------------|
| `{scope_name}` | `{scope_params}` | {scope_description} |

**Accessors & Mutators:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `{attribute_name}` | {accessor_or_mutator} | {attribute_description} |

**Casts:**

\`\`\`php
{casts_array}
\`\`\`

## Related Pages

- [Database Schema](Database-Schema) — table definitions and migrations
- [Service Layer Architecture](Service-Layer-Architecture) — how services use models
```

---

### Template: Middleware-Guards.md

```markdown
# Middleware & Guards

## Middleware Stack

### Global Middleware

| Middleware | Purpose |
|-----------|---------|
| `{middleware_class}` | {middleware_purpose} |

### Route Middleware

| Alias | Middleware Class | Purpose |
|-------|-----------------|---------|
| `{middleware_alias}` | `{middleware_class}` | {middleware_purpose} |

### Middleware Groups

| Group | Middleware |
|-------|-----------|
| `{group_name}` | {middleware_list} |

## Authentication

**Driver:** {auth_driver}
**Guard:** {auth_guard}

{authentication_description}

### Auth Flow

\`\`\`
{ascii_auth_flow_diagram}
\`\`\`

## Authorization

### Policies

| Capability | Model | Abilities |
|--------|-------|-----------|
| `{Capability_class}` | `{model_class}` | {abilities_list} |

### Gates

| Gate | Description |
|------|-------------|
| `{gate_name}` | {gate_description} |

## Custom Middleware

### {custom_middleware_name}

**File:** `{middleware_file_path}`
**Purpose:** {middleware_purpose}

\`\`\`php
{middleware_example}
\`\`\`
```

---

### Template: Jobs-Events-Listeners.md

```markdown
# Jobs, Events & Listeners

## Jobs

| Job Class | Queue | Description |
|-----------|-------|-------------|
| `{job_class}` | `{queue_name}` | {job_description} |

### {job_class_name}

**File:** `{job_file_path}`
**Queue:** `{queue_name}`
**Retries:** {max_tries}

{job_description}

**Dispatched From:**
- `{dispatch_location}`

## Events

| Event | Listeners | Description |
|-------|-----------|-------------|
| `{event_class}` | {listener_count} listener(s) | {event_description} |

### {event_class_name}

**File:** `{event_file_path}`
**Payload:** {event_payload_description}

**Listeners:**

| Listener | Action |
|----------|--------|
| `{listener_class}` | {listener_action} |

## Observers

| Observer | Model | Events |
|----------|-------|--------|
| `{observer_class}` | `{model_class}` | {observed_events} |

## Event Flow Diagram

\`\`\`
{ascii_event_flow_diagram}
\`\`\`
```

---

### Template: Queues-Scheduling.md

```markdown
# Queues & Scheduling

## Queue Configuration

**Driver:** {queue_driver}
**Connection:** {queue_connection}

| Queue | Purpose | Workers |
|-------|---------|---------|
| `{queue_name}` | {queue_purpose} | {worker_count} |

## Running Workers

\`\`\`bash
{worker_start_command}
\`\`\`

### Worker Options

| Option | Value | Description |
|--------|-------|-------------|
| `{option_name}` | `{option_value}` | {option_description} |

## Failed Jobs

{failed_job_handling_description}

\`\`\`bash
{retry_failed_command}
\`\`\`

## Scheduled Tasks

| Task | Schedule | Description |
|------|----------|-------------|
| `{task_command}` | {cron_expression} ({human_readable}) | {task_description} |

### Running the Scheduler

\`\`\`bash
{scheduler_command}
\`\`\`

**Production setup:** {scheduler_cron_setup}

## Monitoring

{queue_monitoring_description}
```

---

### Template: Caching-Strategy.md

```markdown
# Caching Strategy

## Configuration

**Driver:** {cache_driver}
**Default TTL:** {default_ttl}

## Cache Usage

| Key Pattern | TTL | Purpose | Invalidation Trigger |
|------------|-----|---------|---------------------|
| `{cache_key_pattern}` | {ttl} | {cache_purpose} | {invalidation_trigger} |

## Cache Patterns

### {pattern_name}

\`\`\`php
{cache_pattern_example}
\`\`\`

## Cache Invalidation

{invalidation_strategy_description}

### Invalidation Points

| Event | Cache Keys Cleared | Method |
|-------|-------------------|--------|
| {trigger_event} | `{cache_keys}` | {invalidation_method} |

## Cache Commands

\`\`\`bash
{cache_clear_command}
{cache_warm_command}
\`\`\`

## Related Pages

- [Environment Configuration](Environment-Configuration) — cache driver settings
```

---

## WordPress Pages (6 Templates)

---

### Template: Plugin-Theme-Architecture.md

```markdown
# {plugin_or_theme_type} Architecture

## Overview

**Type:** {plugin_or_theme}
**{type_header}:** {plugin_or_theme_name}
**Version:** {version}

{architecture_description}

## File Structure

\`\`\`
{directory_tree}
\`\`\`

### Key Files

| File | Purpose |
|------|---------|
| `{file_path}` | {file_purpose} |

## Initialization Flow

\`\`\`
{ascii_init_flow_diagram}
\`\`\`

{init_flow_description}

## Hook Registration

| Hook | Type | Callback | Priority |
|------|------|----------|----------|
| `{hook_name}` | {action_or_filter} | `{callback_function}` | {priority} |

## Class Structure

| Class | File | Responsibility |
|-------|------|---------------|
| `{class_name}` | `{class_file}` | {class_responsibility} |

## Dependencies

{dependency_description}

## Related Pages

- [Hooks & Filters Reference](Hooks-Filters-Reference)
- [Admin Pages & Settings](Admin-Pages-Settings)
```

---

### Template: Hooks-Filters-Reference.md

```markdown
# Hooks & Filters Reference

## Overview

{hooks_overview}

## Actions

| Hook | File | Callback | Priority | Description |
|------|------|----------|----------|-------------|
| `{action_name}` | `{file_path}` | `{callback}` | {priority} | {description} |

## Filters

| Hook | File | Callback | Priority | Description |
|------|------|----------|----------|-------------|
| `{filter_name}` | `{file_path}` | `{callback}` | {priority} | {description} |

## Custom Hooks

These hooks are defined by the {plugin_or_theme_name} for extensibility:

### Actions

| Hook | Parameters | Description | Example |
|------|-----------|-------------|---------|
| `{custom_action}` | `{parameters}` | {description} | {usage_example} |

### Filters

| Hook | Parameters | Default | Description | Example |
|------|-----------|---------|-------------|---------|
| `{custom_filter}` | `{parameters}` | {default_value} | {description} | {usage_example} |

## Hook Execution Order

\`\`\`
{ascii_hook_execution_order}
\`\`\`
```

---

### Template: Custom-Post-Types-Taxonomies.md

```markdown
# Custom Post Types & Taxonomies

## Custom Post Types

### {cpt_name}

**Slug:** `{cpt_slug}`
**File:** `{registration_file}`

| Property | Value |
|----------|-------|
| Public | {is_public} |
| Has Archive | {has_archive} |
| Supports | {supports_list} |
| Menu Icon | {menu_icon} |
| REST API | {show_in_rest} |

**Meta Fields:**

| Meta Key | Type | Description |
|----------|------|-------------|
| `{meta_key}` | {meta_type} | {meta_description} |

## Taxonomies

### {taxonomy_name}

**Slug:** `{taxonomy_slug}`
**Associated Post Types:** {associated_post_types}
**Hierarchical:** {is_hierarchical}

## Relationships

\`\`\`
{ascii_cpt_taxonomy_diagram}
\`\`\`

## Querying

### Example Queries

\`\`\`php
{query_examples}
\`\`\`

## Related Pages

- [Database Schema](Database-Schema) — custom table structure
- [Hooks & Filters Reference](Hooks-Filters-Reference) — CPT-related hooks
```

---

### Template: Admin-Pages-Settings.md

```markdown
# Admin Pages & Settings

## Admin Menu Structure

\`\`\`
{ascii_menu_tree}
\`\`\`

## Pages

### {admin_page_name}

**Menu Slug:** `{menu_slug}`
**Capability:** `{required_capability}`
**File:** `{admin_page_file}`

{page_description}

## Settings

### Settings Sections

| Section | Page | Description |
|---------|------|-------------|
| `{section_id}` | `{page_slug}` | {section_description} |

### Settings Fields

| Field | Section | Type | Default | Description |
|-------|---------|------|---------|-------------|
| `{field_name}` | `{section_id}` | {field_type} | `{default_value}` | {field_description} |

## Options

| Option Name | Type | Default | Description |
|-------------|------|---------|-------------|
| `{option_name}` | {option_type} | `{default}` | {option_description} |

### Reading Options

\`\`\`php
{option_read_example}
\`\`\`

## Related Pages

- [Plugin/Theme Architecture](Plugin-Theme-Architecture) — initialization flow
```

---

### Template: Gutenberg-Blocks.md

```markdown
# Gutenberg Blocks

## Overview

{blocks_overview}

## Registered Blocks

| Block | Name | Category | Description |
|-------|------|----------|-------------|
| {block_title} | `{block_name}` | {block_category} | {block_description} |

### {block_title}

**Name:** `{block_namespace}/{block_slug}`
**File:** `{block_json_path}`

**Attributes:**

| Attribute | Type | Default | Description |
|-----------|------|---------|-------------|
| `{attr_name}` | {attr_type} | `{attr_default}` | {attr_description} |

**Supports:**

| Feature | Enabled |
|---------|---------|
| {support_feature} | {enabled} |

**Edit Component:** `{edit_component_path}`
**Save/Render:** {save_method_description}

## Block Assets

| Asset | File | Loaded On |
|-------|------|----------|
| Editor Script | `{editor_script_path}` | Block Editor |
| Editor Style | `{editor_style_path}` | Block Editor |
| Frontend Style | `{frontend_style_path}` | Frontend |
| View Script | `{view_script_path}` | Frontend (when block visible) |

## Development

### Building Blocks

\`\`\`bash
{block_build_command}
\`\`\`

### Development Mode

\`\`\`bash
{block_dev_command}
\`\`\`

## Related Pages

- [Component Architecture](Component-Architecture) — React component patterns
- [Plugin/Theme Architecture](Plugin-Theme-Architecture) — block registration
```

---

### Template: WP-CLI-Commands.md

```markdown
# WP-CLI Commands

## Overview

{cli_overview}

## Available Commands

| Command | Description |
|---------|-------------|
| `wp {command_namespace} {subcommand}` | {command_description} |

### wp {command_namespace} {subcommand}

**Description:** {detailed_description}

**Usage:**

\`\`\`bash
wp {command_namespace} {subcommand} {arguments}
\`\`\`

**Arguments:**

| Argument | Required | Description |
|----------|----------|-------------|
| `{arg_name}` | {required} | {arg_description} |

**Options:**

| Option | Default | Description |
|--------|---------|-------------|
| `--{option_name}` | `{default}` | {option_description} |

**Examples:**

\`\`\`bash
{command_example_1}
{command_example_2}
\`\`\`

## Related Pages

- [Getting Started](Getting-Started) — CLI setup
- [Troubleshooting & FAQ](Troubleshooting-FAQ) — common CLI issues
```

---

## React / NextJS Pages (7 Templates)

---

### Template: Component-Architecture.md

```markdown
# Component Architecture

## Overview

{component_architecture_overview}

## Component Hierarchy

\`\`\`
{ascii_component_tree}
\`\`\`

## Patterns

### {pattern_name} Pattern

{pattern_description}

\`\`\`{language}
{pattern_example}
\`\`\`

## Component Catalog

### Shared Components

| Component | File | Props | Description |
|-----------|------|-------|-------------|
| `{component_name}` | `{component_path}` | {props_summary} | {component_description} |

### Page Components

| Component | Route | Description |
|-----------|-------|-------------|
| `{page_component}` | `{route_path}` | {page_description} |

### Layout Components

| Component | Used By | Description |
|-----------|---------|-------------|
| `{layout_component}` | {used_by_pages} | {layout_description} |

## Props Conventions

{props_conventions_description}

## File Organization

| Pattern | Convention | Example |
|---------|-----------|---------|
| {organization_pattern} | {convention_description} | `{example_path}` |

## Related Pages

- [State Management](State-Management) — data flow into components
- [Custom Hooks](Custom-Hooks) — shared logic extraction
- [Styling & Theming](Styling-Theming) — component styling
```

---

### Template: State-Management.md

```markdown
# State Management

## Overview

**Library:** {state_library}
**Pattern:** {state_pattern}

{state_management_overview}

## Architecture

\`\`\`
{ascii_state_architecture}
\`\`\`

## Store Structure

### {store_name}

**File:** `{store_file_path}`

**State Shape:**

\`\`\`{language}
{state_shape}
\`\`\`

**Actions / Methods:**

| Action | Parameters | Description |
|--------|-----------|-------------|
| `{action_name}` | `{action_params}` | {action_description} |

**Selectors / Computed:**

| Selector | Returns | Description |
|----------|---------|-------------|
| `{selector_name}` | `{return_type}` | {selector_description} |

## Data Flow

\`\`\`
{ascii_data_flow}
\`\`\`

{data_flow_description}

## Usage Example

\`\`\`{language}
{usage_example}
\`\`\`

## Server State

{server_state_description}

| Query Key | Endpoint | Stale Time | Description |
|-----------|----------|-----------|-------------|
| `{query_key}` | `{endpoint}` | {stale_time} | {query_description} |

## Related Pages

- [Component Architecture](Component-Architecture) — how components consume state
- [Custom Hooks](Custom-Hooks) — hooks that interact with state
```

---

### Template: Routing-Navigation.md

```markdown
# Routing & Navigation

## Overview

**Router:** {router_library}
**Pattern:** {routing_pattern}

{routing_overview}

## Route Map

| Path | Component | Auth Required | Description |
|------|-----------|--------------|-------------|
| `{route_path}` | `{component_name}` | {auth_required} | {route_description} |

## Route Structure

\`\`\`
{ascii_route_tree}
\`\`\`

## Dynamic Routes

| Pattern | Example | Parameters |
|---------|---------|-----------|
| `{dynamic_pattern}` | `{dynamic_example}` | {param_descriptions} |

## Route Guards / Protection

{route_protection_description}

\`\`\`{language}
{route_guard_example}
\`\`\`

## Navigation Patterns

### Programmatic Navigation

\`\`\`{language}
{programmatic_nav_example}
\`\`\`

### Link Components

\`\`\`{language}
{link_component_example}
\`\`\`

## Layouts

| Layout | Applied To | Description |
|--------|-----------|-------------|
| `{layout_name}` | {applied_routes} | {layout_description} |

## Loading & Error States

{loading_error_description}

## Related Pages

- [Component Architecture](Component-Architecture) — page components
- [Middleware & Guards](Middleware-Guards) — server-side auth (if applicable)
```

---

### Template: Styling-Theming.md

```markdown
# Styling & Theming

## Overview

**Approach:** {styling_approach}
**Libraries:** {styling_libraries}

{styling_overview}

## Theme Configuration

**File:** `{theme_config_path}`

### Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `{token_name}` | `{token_value}` | {token_usage} |

### Color Palette

| Name | Light | Dark | CSS Variable |
|------|-------|------|-------------|
| {color_name} | `{light_value}` | `{dark_value}` | `{css_variable}` |

### Typography

| Scale | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| {scale_name} | {font_size} | {font_weight} | {line_height} | {typography_usage} |

### Spacing

| Scale | Value | Usage |
|-------|-------|-------|
| {spacing_name} | {spacing_value} | {spacing_usage} |

### Breakpoints

| Name | Min Width | Description |
|------|-----------|-------------|
| {breakpoint_name} | `{min_width}` | {breakpoint_description} |

## Styling Patterns

### {styling_pattern_name}

\`\`\`{language}
{styling_pattern_example}
\`\`\`

## Dark Mode

{dark_mode_description}

## Related Pages

- [Component Architecture](Component-Architecture) — component styling conventions
```

---

### Template: Custom-Hooks.md

```markdown
# Custom Hooks

## Overview

{hooks_overview}

## Hooks Reference

### {hook_name}

**File:** `{hook_file_path}`
**Category:** {hook_category}

**Signature:**

\`\`\`{language}
{hook_signature}
\`\`\`

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `{param_name}` | `{param_type}` | `{param_default}` | {param_description} |

**Returns:**

| Property | Type | Description |
|----------|------|-------------|
| `{return_prop}` | `{return_type}` | {return_description} |

**Example:**

\`\`\`{language}
{hook_usage_example}
\`\`\`

---

## Hooks by Category

### Data Fetching Hooks

| Hook | Purpose |
|------|---------|
| `{hook_name}` | {hook_purpose} |

### UI Hooks

| Hook | Purpose |
|------|---------|
| `{hook_name}` | {hook_purpose} |

### Form Hooks

| Hook | Purpose |
|------|---------|
| `{hook_name}` | {hook_purpose} |

### Utility Hooks

| Hook | Purpose |
|------|---------|
| `{hook_name}` | {hook_purpose} |

## Related Pages

- [Component Architecture](Component-Architecture) — hooks used in components
- [State Management](State-Management) — hooks that interact with stores
```

---

### Template: Form-Handling-Validation.md

```markdown
# Form Handling & Validation

## Overview

**Library:** {form_library}

{form_overview}

## Form Architecture

\`\`\`
{ascii_form_architecture}
\`\`\`

## Forms

### {form_name}

**Component:** `{form_component_path}`
**Endpoint:** `{form_submit_endpoint}`

**Fields:**

| Field | Type | Validation | Required |
|-------|------|-----------|----------|
| `{field_name}` | {field_type} | {validation_rules} | {required} |

## Validation Rules

| Rule | Description | Example |
|------|-------------|---------|
| `{rule_name}` | {rule_description} | `{rule_example}` |

## Error Display

{error_display_pattern}

\`\`\`{language}
{error_display_example}
\`\`\`

## Submission Pattern

\`\`\`{language}
{form_submission_example}
\`\`\`

## Reusable Form Components

| Component | Purpose | Props |
|-----------|---------|-------|
| `{form_component}` | {component_purpose} | {component_props} |

## Related Pages

- [Component Architecture](Component-Architecture) — form component patterns
- [API Overview](API-Overview-Authentication) — form submission endpoints
- [Error Handling](Error-Handling-Boundaries) — form error handling
```

---

### Template: Error-Handling-Boundaries.md

```markdown
# Error Handling & Error Boundaries

## Overview

{error_handling_overview}

## Error Boundary Structure

\`\`\`
{ascii_error_boundary_tree}
\`\`\`

## Error Boundaries

### {boundary_name}

**File:** `{boundary_file_path}`
**Scope:** {boundary_scope}
**Fallback:** {fallback_description}

\`\`\`{language}
{boundary_example}
\`\`\`

## Error Types

| Error Type | Source | Handling Strategy |
|-----------|--------|-------------------|
| {error_type} | {error_source} | {handling_strategy} |

## API Error Handling

{api_error_handling_description}

\`\`\`{language}
{api_error_example}
\`\`\`

## Error Reporting

{error_reporting_description}

## Fallback UI Components

| Component | Used For | Description |
|-----------|----------|-------------|
| `{fallback_component}` | {used_for} | {fallback_description} |

## Related Pages

- [Component Architecture](Component-Architecture) — boundary placement
- [API Overview](API-Overview-Authentication) — API error formats
- [Troubleshooting & FAQ](Troubleshooting-FAQ) — common error resolutions
```

---

## API Pages (6 Templates)

---

### Template: API-Overview-Authentication.md

```markdown
# API Overview & Authentication

## Base URL

| Environment | Base URL |
|-------------|---------|
| {env_name} | `{base_url}` |

## Authentication

**Method:** {auth_method}

{auth_description}

### Obtaining Credentials

{credential_instructions}

### Making Authenticated Requests

\`\`\`bash
{auth_request_example}
\`\`\`

### Token Refresh

{token_refresh_description}

## Request Headers

| Header | Required | Description |
|--------|----------|-------------|
| `{header_name}` | {required} | {header_description} |

## API Versioning

{versioning_strategy}

## Quick Start

\`\`\`bash
{quick_start_curl_example}
\`\`\`

## Related Pages

- [Endpoint Reference](Endpoint-Reference) — all available endpoints
- [Request & Response Formats](Request-Response-Formats) — data formats
- [Error Handling](Error-Handling-Status-Codes) — error responses
```

---

### Template: Endpoint-Reference.md

```markdown
# Endpoint Reference

## {endpoint_group_name}

### {endpoint_method} {endpoint_path}

**Description:** {endpoint_description}
**Auth Required:** {auth_required}
**Middleware:** {middleware_list}

**Parameters:**

| Parameter | In | Type | Required | Description |
|-----------|-----|------|----------|-------------|
| `{param_name}` | {param_location} | {param_type} | {required} | {param_description} |

**Request Body:**

\`\`\`json
{request_body_example}
\`\`\`

**Response (200):**

\`\`\`json
{success_response_example}
\`\`\`

**Error Responses:**

| Status | Description |
|--------|-------------|
| {error_status} | {error_description} |

---

{repeat_for_each_endpoint}

## Related Pages

- [API Overview & Authentication](API-Overview-Authentication)
- [Request & Response Formats](Request-Response-Formats)
```

---

### Template: Request-Response-Formats.md

```markdown
# Request & Response Formats

## Request Format

### Content Types

| Content Type | When Used |
|-------------|-----------|
| `{content_type}` | {content_type_usage} |

### Request Body Conventions

{request_body_conventions}

\`\`\`json
{request_body_example}
\`\`\`

## Response Envelope

{response_envelope_description}

### Success Response

\`\`\`json
{success_envelope_example}
\`\`\`

### Error Response

\`\`\`json
{error_envelope_example}
\`\`\`

## Pagination

**Style:** {pagination_style}

### Paginated Response

\`\`\`json
{paginated_response_example}
\`\`\`

### Pagination Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `{param_name}` | `{default_value}` | {param_description} |

## Filtering & Sorting

| Parameter | Description | Example |
|-----------|-------------|---------|
| `{filter_param}` | {filter_description} | `{filter_example}` |

## Data Types

| Type | Format | Example |
|------|--------|---------|
| Date/Time | {datetime_format} | `{datetime_example}` |
| ID | {id_format} | `{id_example}` |
| Boolean | {boolean_format} | `{boolean_example}` |
| Currency | {currency_format} | `{currency_example}` |

## Related Pages

- [Endpoint Reference](Endpoint-Reference) — endpoint-specific formats
- [Error Handling](Error-Handling-Status-Codes) — error response details
```

---

### Template: Error-Handling-Status-Codes.md

```markdown
# Error Handling & Status Codes

## Status Code Reference

### Success Codes

| Code | Meaning | When Used |
|------|---------|-----------|
| {success_code} | {success_meaning} | {success_usage} |

### Client Error Codes

| Code | Meaning | Common Cause |
|------|---------|-------------|
| {client_error_code} | {client_error_meaning} | {client_error_cause} |

### Server Error Codes

| Code | Meaning | Action |
|------|---------|--------|
| {server_error_code} | {server_error_meaning} | {server_error_action} |

## Error Response Format

\`\`\`json
{error_response_format}
\`\`\`

### Field-Level Errors (Validation)

\`\`\`json
{validation_error_example}
\`\`\`

## Common Error Scenarios

### {error_scenario_name}

**Status:** {error_status_code}
**Response:**

\`\`\`json
{error_scenario_response}
\`\`\`

**Resolution:** {error_resolution}

## Retry Strategy

{retry_strategy_description}

| Status Code | Retryable | Recommended Delay |
|-------------|-----------|-------------------|
| {status_code} | {retryable} | {delay} |

## Related Pages

- [API Overview & Authentication](API-Overview-Authentication)
- [Troubleshooting & FAQ](Troubleshooting-FAQ) — general troubleshooting
```

---

### Template: Rate-Limiting-Pagination.md

```markdown
# Rate Limiting & Pagination

## Rate Limiting

{rate_limiting_overview}

### Limits

| Scope | Limit | Window | Header |
|-------|-------|--------|--------|
| {rate_scope} | {rate_limit} | {rate_window} | `{rate_header}` |

### Rate Limit Headers

| Header | Description |
|--------|-------------|
| `{limit_header}` | {header_description} |

### Handling Rate Limits

{rate_limit_handling_description}

\`\`\`{language}
{rate_limit_handling_example}
\`\`\`

## Pagination

### {pagination_style} Pagination

{pagination_description}

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `{param_name}` | {param_type} | `{default}` | {param_description} |

**Response Meta:**

\`\`\`json
{pagination_meta_example}
\`\`\`

### Navigating Pages

\`\`\`{language}
{pagination_navigation_example}
\`\`\`

## Best Practices

- {pagination_best_practice}

## Related Pages

- [Request & Response Formats](Request-Response-Formats) — response envelope structure
- [Endpoint Reference](Endpoint-Reference) — per-endpoint pagination details
```

---

### Template: Webhooks.md

```markdown
# Webhooks

## Overview

{webhooks_overview}

## Available Events

| Event | Trigger | Payload |
|-------|---------|---------|
| `{event_name}` | {event_trigger} | [View payload](#event_name) |

## Webhook Configuration

{webhook_config_description}

### Registering a Webhook

\`\`\`{language}
{webhook_registration_example}
\`\`\`

## Payload Format

### Common Fields

| Field | Type | Description |
|-------|------|-------------|
| `{field_name}` | {field_type} | {field_description} |

### {event_name} Payload

\`\`\`json
{event_payload_example}
\`\`\`

## Verification

{webhook_verification_description}

\`\`\`{language}
{verification_example}
\`\`\`

## Retry Capability

| Attempt | Delay | Timeout |
|---------|-------|---------|
| {attempt_number} | {retry_delay} | {request_timeout} |

{retry_description}

## Best Practices

- {webhook_best_practice}

## Related Pages

- [API Overview & Authentication](API-Overview-Authentication) — webhook authentication
- [Error Handling](Error-Handling-Status-Codes) — webhook error responses
```

