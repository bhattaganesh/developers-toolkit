---
name: wp-modernize
description: Refactor legacy PHP/JS into modern, secure WordPress standards
---

# Modernize Legacy Code

Surgically updates legacy codebases to modern full-stack standards without breaking backward compatibility.

## Usage

```bash
/developers:wp-modernize [file_or_directory]
```

## Refactoring Targets

1.  **PHP Logic:**
    - Raw SQL → `$wpdb->prepare` or `WP_Query`.
    - Procedural hooks → Class-based or anonymous function wrappers.
    - Legacy Arrays → Modern PHP 8.x syntax.
    - Security → Adding missing nonces and capability checks.

2.  **JavaScript Layer:**
    - jQuery/Vanilla JS → React or Interactivity API blocks.
    - Global variables → Encapsulated modules or Block attributes.
    - Obsolete APIs → Modern `@wordpress/packages` equivalents.

3.  **Performance:**
    - Optimizing redundant transients.
    - Converting synchronous calls to REST-based async operations.

## Safety Check

Always creates a backup or uses a temporary `git worktree` before performing major refactors.
