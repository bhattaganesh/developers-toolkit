# Testing Guide

> How to run, write, and maintain tests for {project_name}.

## Quick Start

```bash
# Run all tests
{run_all_tests_command}

# Run a specific test file
{run_single_test_command}

# Run tests with coverage report
{run_coverage_command}
```

## Test Structure

```
{test_directory_tree}
```

<!-- Skill: Show the actual test directory layout from the project. -->

## Test Types

### Unit Tests

- **Location:** `{unit_test_path}/`
- **Framework:** {unit_test_framework}
- **Run:** `{unit_test_command}`

{unit_test_description}

### Integration Tests

<!-- Skill: Include only if integration tests exist in the project. -->

- **Location:** `{integration_test_path}/`
- **Framework:** {integration_test_framework}
- **Run:** `{integration_test_command}`

{integration_test_description}

### End-to-End Tests

<!-- Skill: Include only if E2E tests exist in the project. -->

- **Location:** `{e2e_test_path}/`
- **Framework:** {e2e_test_framework}
- **Run:** `{e2e_test_command}`

{e2e_test_description}

### Other Test Types

<!-- Skill: Include any additional test types found — API tests, browser tests,
     snapshot tests, visual regression, etc. Remove if not applicable. -->

- **{test_type_name}**
  - **Location:** `{test_path}/`
  - **Run:** `{test_command}`
  - {test_type_description}

## Writing Tests

### Naming Conventions

{test_naming_conventions}

| Element | Convention | Example |
|---------|-----------|---------|
| Test files | {file_naming_pattern} | {file_example} |
| Test methods | {method_naming_pattern} | {method_example} |
| Test classes | {class_naming_pattern} | {class_example} |

### Common Patterns

<!-- Skill: Document patterns actually used in the codebase. -->

{common_test_patterns}

- **{pattern_name}:** {pattern_description}

### Example Test

```{language}
{example_test_code}
```

<!-- Skill: Use a real, representative test from the project codebase. -->

## Test Helpers & Utilities

<!-- Skill: Document any shared test utilities, base classes, or helpers. -->

| Helper | Location | Purpose |
|--------|----------|---------|
| {helper_name} | `{helper_path}` | {what_it_does} |

## Test Configuration

- **Config file:** `{test_config_file_path}`
- **Test database:** {test_database_setup}
- **Environment:** {test_environment_details}

```bash
# Set up test environment
{test_setup_command}
```

## CI/CD Integration

<!-- Skill: Describe how tests fit into the CI/CD pipeline. -->

- **Platform:** {ci_platform}
- **Trigger:** {when_tests_run}
- **Required to merge:** {yes_or_no}

{ci_test_details}

## Coverage

- **Current coverage:** {coverage_percentage}
- **Minimum required:** {minimum_coverage_threshold}
- **Report format:** {coverage_report_format}

```bash
# Generate coverage report
{generate_coverage_command}

# View coverage report
{view_coverage_command}
```

## Troubleshooting Tests

<!-- Skill: Include common test issues found in the project. -->

| Issue | Cause | Fix |
|-------|-------|-----|
| {issue_description} | {cause} | {fix} |

## Related Pages

- [Contributing Guide](Contributing-Guide) — PR requirements including tests
- [Deployment Guide](Deployment-Guide) — Tests in the deployment pipeline
- [Architecture Overview](Architecture-Overview) — What to test and system boundaries
- [Getting Started](Getting-Started) — Setting up your test environment

---

*See also: [Contributing Guide](Contributing-Guide) | [Deployment Guide](Deployment-Guide)*
