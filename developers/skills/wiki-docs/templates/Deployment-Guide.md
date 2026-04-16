# Deployment Guide

> CI/CD pipeline, deployment process, environments, and release management for {project_name}.

## Environments

| Environment | URL | Branch | Auto-Deploy | Notes |
|-------------|-----|--------|-------------|-------|
| {env_name} | {env_url} | `{branch}` | {yes_or_no} | {notes} |

## CI/CD Pipeline

### Pipeline Overview

```
{ascii_pipeline_diagram}
```

<!-- Skill: Generate an ASCII diagram showing pipeline stages:
     [Push] -> [Build] -> [Test] -> [Deploy Staging] -> [Approve] -> [Deploy Prod]
-->

### Pipeline Configuration

- **Platform:** {ci_platform}
- **Config file:** `{ci_config_file_path}`
- **Triggers:** {pipeline_triggers}
- **Timeout:** {pipeline_timeout}

### Pipeline Stages

<!-- Skill: Repeat for each stage in the pipeline. -->

**1. {stage_name}**

- **Purpose:** {what_this_stage_does}
- **Duration:** {approximate_duration}
- **Steps:**
  - {step_description}

<!-- Repeat for each stage -->

## Deployment Process

### Automated Deployment

<!-- Skill: Describe the standard automated deploy flow. -->

{automated_deployment_description}

1. {auto_deploy_step_1}
2. {auto_deploy_step_2}
3. {auto_deploy_step_3}

### Manual Deployment

<!-- Skill: Include only if manual deployment is sometimes needed. -->

```bash
{manual_deployment_commands}
```

**When to deploy manually:**
- {manual_deploy_scenario}

## Release Process

### Versioning

- **Scheme:** {versioning_scheme}
- **Current version:** {current_version}
- **Where tracked:** `{version_file_path}`

### Creating a Release

1. {release_step_1}
2. {release_step_2}
3. {release_step_3}
4. {release_step_4}

### Changelog

{how_changelog_is_managed}

## Pre-Deployment Checklist

- [ ] All tests pass on the target branch
- [ ] {checklist_item}
- [ ] {checklist_item}
- [ ] {checklist_item}
- [ ] Database migrations reviewed (if any)
- [ ] Environment variables confirmed for target environment

## Rollback

### How to Rollback

<!-- Skill: Document the actual rollback procedure for this project. -->

```bash
{rollback_commands}
```

{rollback_description}

### When to Rollback

- {rollback_criterion}
- {rollback_criterion}

### Rollback vs. Hotfix

| Situation | Action |
|-----------|--------|
| {situation_requiring_rollback} | Rollback |
| {situation_requiring_hotfix} | Hotfix |

## Post-Deployment

### Monitoring

{monitoring_description}

- **Health check:** `{health_check_url_or_command}`
- **Logs:** {where_to_find_logs}
- **Alerts:** {alerting_setup}

### Smoke Tests

{post_deploy_verification_steps}

```bash
# Verify deployment
{smoke_test_command}
```

## Infrastructure

<!-- Skill: Include only if infrastructure details are relevant. -->

| Component | Service | Notes |
|-----------|---------|-------|
| {component_name} | {service_or_provider} | {notes} |

## Related Pages

- [Environment Configuration](Environment-Configuration) — Environment-specific settings
- [Testing Guide](Testing-Guide) — Tests in the pipeline
- [Contributing Guide](Contributing-Guide) — Branch and merge workflow
- [Troubleshooting & FAQ](Troubleshooting-FAQ) — Deployment issues

---

*See also: [Environment Configuration](Environment-Configuration) | [Testing Guide](Testing-Guide)*
