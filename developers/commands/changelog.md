---
description: Generate formatted changelog from git history — groups by commit prefix, creates versioned entry
---

# Changelog

Generate a formatted changelog entry from git commit history.

## Instructions

1. **Determine range** — Identify the commit range to include:
   - Default: from the last git tag to HEAD (`git describe --tags --abbrev=0` to find the last tag)
   - If the user specifies a range, use that (e.g., `v1.2.0..HEAD`, or `--since="2 weeks ago"`)
   - If no tags exist, ask the user for a starting point or use the last 50 commits

2. **Read commit log** — Run `git log --oneline` for the determined range and parse each commit message.

3. **Group by prefix** — Categorize commits by their conventional commit prefix:
   - **Features** (`feat:`) — New functionality
   - **Bug Fixes** (`fix:`) — Bug fixes
   - **Performance** (`perf:`) — Performance improvements
   - **Refactoring** (`refactor:`) — Code restructuring without behavior change
   - **Chores** (`chore:`) — Maintenance, dependencies, tooling
   - **Documentation** (`docs:`) — Documentation updates
   - **Other** — Commits without a recognized prefix

4. **Format changelog entry** — Generate a clean, readable entry:
   ```markdown
   ## [version] - YYYY-MM-DD

   ### Features
   - Description of feature (commit hash)

   ### Bug Fixes
   - Description of fix (commit hash)

   ### Performance
   - Description of improvement (commit hash)

   ### Refactoring
   - Description of refactor (commit hash)

   ### Chores
   - Description of chore (commit hash)
   ```
   - Strip the prefix from each message (e.g., `feat: add login` becomes `Add login`)
   - Capitalize the first letter of each entry
   - Include short commit hash for reference
   - Omit empty sections

5. **Output or append** — Present the changelog entry to the user. If the user requests it, append the entry to the project's `CHANGELOG.md` file (prepend after the title, before existing entries).
