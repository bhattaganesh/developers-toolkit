# CLAUDE.md Update Guidelines

Follow these rules when resolving gaps in a `CLAUDE.md` file.

## 1. Tooling Synchronization
- **Source of Truth:** Use `package.json`, `composer.json`, `pnpm-lock.yaml`, and `tsconfig.json`.
- **Logic:** If a tool is installed but the command is missing in CLAUDE.md, ADD IT.
- **Deduplication:** Remove commands that no longer exist in the config files.

## 2. Tech Stack Precision
- **Specificity:** Replace generic terms ("React") with specific ones ("React 18 with Tanstack Query").
- **WordPress Specifics:** Always mention the presence of Gutenberg, Interactivity API, or FSE if detected.

## 3. Extracting "Expert Gotchas"
- **Error Patterns:** If the developer encountered a specific build error recently, document the fix as a "Gotcha."
- **Security Gates:** Add project-specific security rules (e.g., "Always use `wp_kses` for user-generated HTML").

## 4. Structural Integrity
- Keep the `### Build Commands` and `### Test Commands` headers consistent.
- Ensure the `## Tech Stack` section is always above the workflows.
- Metadata (like `projectId`) should always be at the very top or in a hidden comment if required by the system.

## 5. Collaborative Approval
- **Always** present the "New Resulting CLAUDE.md" as a diff.
- **Explain** *why* specific changes were made (e.g., "Standardized test commands to match Vitest config").
