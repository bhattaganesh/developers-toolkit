# Environment Configuration

> Environment variables, configuration files, and per-environment settings for {project_name}.

## Overview

<!-- Skill: Briefly describe how configuration is managed in this project. -->

{configuration_overview}

- **Config format:** {config_format}
- **Environment file:** `{env_file_path}`
- **Example template:** `{env_example_file_path}`

## Environment Variables

### Required Variables

<!-- Skill: List variables that must be set for the application to run. -->

| Variable | Description | Example | Where to Get |
|----------|-------------|---------|--------------|
| {VAR_NAME} | {what_it_controls} | `{example_value}` | {instructions_to_obtain} |

### Optional Variables

<!-- Skill: List variables with sensible defaults that can be overridden. -->

| Variable | Description | Default | Notes |
|----------|-------------|---------|-------|
| {VAR_NAME} | {what_it_controls} | `{default_value}` | {notes} |

## Configuration Files

<!-- Skill: Repeat this subsection for each significant config file. -->

### `{config_file_path}`

**Purpose:** {what_this_config_controls}

Key settings:

| Setting | Description | Default |
|---------|-------------|---------|
| {setting_key} | {what_it_does} | `{default}` |

<!-- Repeat for each config file -->

## Per-Environment Settings

<!-- Skill: Show how settings differ across environments. -->

| Setting | Development | Staging | Production |
|---------|-------------|---------|------------|
| {setting_name} | {dev_value} | {staging_value} | {prod_value} |

## Secrets Management

<!-- Skill: Describe how secrets are stored and accessed. -->

{secrets_management_approach}

### What to Never Commit

- `.env` files (use `{env_example_file_path}` as template)
- API keys or tokens
- Database credentials
- Private keys or certificates
- OAuth client secrets

### Rotating Secrets

{how_to_rotate_secrets}

## Feature Flags

<!-- Skill: Include only if the project uses feature flags. Remove if not applicable. -->

{feature_flag_system_description}

| Flag | Description | Default | Environments |
|------|-------------|---------|-------------|
| {flag_name} | {what_it_toggles} | {default_state} | {where_enabled} |

## Local Development Overrides

<!-- Skill: Describe any local-only config files or overrides. -->

{local_override_description}

```bash
# Set up local environment
{local_setup_command}
```

## Related Pages

- [Getting Started](Getting-Started) — Initial setup using these variables
- [Deployment Guide](Deployment-Guide) — Production configuration
- [Architecture Overview](Architecture-Overview) — System design
- [Database Schema](Database-Schema) — Database connection settings

---

*See also: [Getting Started](Getting-Started) | [Deployment Guide](Deployment-Guide)*
