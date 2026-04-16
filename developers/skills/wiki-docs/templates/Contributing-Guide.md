# Contributing Guide

> Git workflow, coding standards, PR process, and review guidelines for {project_name}.

## Getting Started

1. Read the [Getting Started](Getting-Started) guide to set up your development environment
2. Read the [Architecture Overview](Architecture-Overview) to understand the codebase
3. Check the issue tracker for available tasks

## Git Workflow

### Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feat/{description}` | `feat/user-dashboard` |
| Bug fix | `fix/{description}` | `fix/login-redirect` |
| Documentation | `docs/{description}` | `docs/api-reference` |
| Refactor | `refactor/{description}` | `refactor/auth-service` |
| Chore | `chore/{description}` | `chore/update-deps` |

### Commit Messages

**Format:** {commit_message_format}

<!-- Skill: Detect the commit convention from git log and document it. -->

**Examples:**

```
{example_commit_messages}
```

### Workflow Steps

1. Pull latest from `{base_branch}`:
   ```bash
   git checkout {base_branch} && git pull origin {base_branch}
   ```
2. Create a feature branch:
   ```bash
   git checkout -b feat/{your_feature}
   ```
3. Make changes following the coding standards below
4. Write or update tests (see [Testing Guide](Testing-Guide))
5. Run tests locally:
   ```bash
   {test_command}
   ```
6. Commit your changes with a descriptive message
7. Push and create a pull request:
   ```bash
   git push origin feat/{your_feature}
   ```

## Coding Standards

<!-- Skill: Repeat this subsection for each language/framework in the project. -->

### {language_or_framework} Standards

{coding_standards_summary}

Key rules:
- {standard_rule}
- {standard_rule}
- {standard_rule}

**Linting / Formatting:**

```bash
# Check code style
{lint_command}

# Auto-fix code style
{lint_fix_command}
```

<!-- Repeat for additional languages -->

## Pull Request Process

### Creating a PR

- Target branch: `{base_branch}`
- Title: {pr_title_convention}
- Description: Explain **what** changed and **why**

### PR Checklist

- [ ] Code follows project coding standards
- [ ] Tests added or updated for changes
- [ ] All tests pass locally (`{test_command}`)
- [ ] No secrets or credentials committed
- [ ] Documentation updated if needed
- [ ] PR description explains the "why" behind changes
- [ ] {additional_checklist_item}

### Review Process

<!-- Skill: Document the actual review process for this project. -->

- **Reviewers:** {who_reviews}
- **Turnaround:** {expected_review_turnaround}
- **Approvals needed:** {approvals_required}
- **CI must pass:** {yes_or_no}

### Merging

- **Strategy:** {merge_strategy}
- **Who merges:** {who_can_merge}
- **Branch cleanup:** {branch_deleted_after_merge}

## Code Review Guidelines

### For Reviewers

When reviewing a PR, check for:

- **Correctness** — Does the code do what it claims?
- **Security** — Are inputs validated? Are there injection risks?
- **Performance** — Any N+1 queries, unnecessary loops, or missing indexes?
- **Readability** — Is the code clear without excessive comments?
- **Tests** — Are edge cases covered?
- {additional_review_criterion}

### For Authors

- Respond to all review comments
- Explain your reasoning when you disagree
- Request re-review after making changes
- Keep PRs focused and reasonably sized

## Issue Tracking

<!-- Skill: Include only if there is a defined issue workflow. -->

- **Platform:** {issue_tracker}
- **Labels:** {label_conventions}
- **Assignment:** {how_issues_are_assigned}

## Related Pages

- [Getting Started](Getting-Started) — Development environment setup
- [Architecture Overview](Architecture-Overview) — System design and conventions
- [Testing Guide](Testing-Guide) — Test requirements and how to write tests
- [Deployment Guide](Deployment-Guide) — How changes reach production

---

*See also: [Getting Started](Getting-Started) | [Testing Guide](Testing-Guide)*
