# GitHub Wiki Workflow Reference

## Overview

GitHub Wiki is a built-in documentation system for every GitHub repository. Each repository's wiki is stored as a **separate Git repository** (`{repo_name}.wiki.git`), which means:

- Wiki content is versioned with Git (full history, diffs, blame)
- Wiki can be cloned, edited locally, and pushed back
- Wiki has its own commit history, independent from the main repo
- No pull request workflow — changes push directly to the wiki repo
- Wiki uses a **flat file structure** (no subdirectories are rendered)

The wiki-docs skill generates markdown pages locally and pushes them to this separate wiki repository.

---

## Wiki URL Derivation

The wiki repository URL is derived from the main repository URL by inserting `.wiki` before `.git`:

### SSH Format

```
Main repo:  git@github.com:{org}/{repo}.git
Wiki repo:  git@github.com:{org}/{repo}.wiki.git
```

### HTTPS Format

```
Main repo:  https://github.com/{org}/{repo}.git
Wiki repo:  https://github.com/{org}/{repo}.wiki.git
```

### Deriving from Remote

To get the wiki URL from an existing checkout:

```bash
# Get the main repo remote URL
git remote get-url origin
# Output: git@github.com:{org}/{repo}.git

# Derive wiki URL by replacing .git with .wiki.git
# SSH: git@github.com:{org}/{repo}.wiki.git
# HTTPS: https://github.com/{org}/{repo}.wiki.git
```

### No .git Suffix

If the remote URL does not end in `.git`:

```
Main repo:  git@github.com:{org}/{repo}
Wiki repo:  git@github.com:{org}/{repo}.wiki.git
```

Simply append `.wiki.git` to the URL.

---

## Prerequisites

Before cloning or pushing to a wiki:

1. **Wiki must be enabled** in the repository settings
   - Repository → Settings → Features → Wikis (checkbox must be checked)
   - Private repos on free plans may not have wiki access

2. **At least one page must exist** (for some configurations)
   - Some repos require creating an initial page via the GitHub UI before the wiki repo is clone-able
   - Navigate to `https://github.com/{org}/{repo}/wiki` and create the first page if needed

3. **Write access** to the repository
   - Pushing to the wiki requires write (push) access to the main repository
   - Read-only collaborators cannot push to the wiki

4. **Git authentication** configured
   - SSH key or HTTPS credentials must be set up for the GitHub account
   - Same authentication as the main repo

---

## Cloning the Wiki

### Standard Clone

```bash
git clone git@github.com:{org}/{repo}.wiki.git {local_wiki_directory}
cd {local_wiki_directory}
```

### Handling Empty Wiki

If the wiki has never been initialized:

```bash
git clone git@github.com:{org}/{repo}.wiki.git {local_wiki_directory}
# May fail with: "warning: You appear to have cloned an empty repository."
```

This is fine — the clone succeeds, you just need to create the first commit:

```bash
cd {local_wiki_directory}
# Create initial Home page
# (write Home.md content)
git add Home.md
git commit -m "Initialize wiki with Home page"
git push origin master
```

### Handling No Wiki Access

If wiki is not enabled or access is denied:

```
fatal: repository 'git@github.com:{org}/{repo}.wiki.git' not found
```

**Resolution:** Fall back to the `docs/wiki/` strategy (see Fallback section below).

### Clone Location

Clone the wiki to a sibling directory of the main project to keep things organized:

```
{parent_directory}/
  {repo}/                  # Main repository
  {repo}.wiki/             # Wiki repository (cloned here)
```

---

## GitHub Wiki Quirks

Understanding these quirks is critical for generating valid wiki content.

### 1. Default Branch is `master`

GitHub Wiki repositories use the `master` branch by default, **not `main`**. Always push to `master`:

```bash
git push origin master
```

If you accidentally create a `main` branch, the wiki will not display it.

### 2. Flat File Structure Only

The wiki renders files from the **root directory only**. Subdirectories are ignored by the wiki renderer:

```
# WORKS — rendered as wiki pages
Home.md
Getting-Started.md
Architecture-Overview.md

# DOES NOT WORK — files in subdirectories are NOT rendered
docs/Home.md
pages/Getting-Started.md
api/Endpoint-Reference.md
```

All wiki page files must be placed directly in the root of the wiki repository.

### 3. File Names Become Page Titles

The file name (without `.md`) becomes the page title. Hyphens are rendered as spaces in the wiki UI:

| File Name | Displayed Title |
|-----------|----------------|
| `Home.md` | Home |
| `Getting-Started.md` | Getting Started |
| `Architecture-Overview.md` | Architecture Overview |
| `API-Overview-Authentication.md` | API Overview Authentication |

**Naming Convention:** Use `Title-Case-With-Hyphens.md` for all page files.

### 4. Special Files

| File | Purpose | Behavior |
|------|---------|----------|
| `Home.md` | Landing page | Displayed when visiting the wiki root |
| `_Sidebar.md` | Navigation sidebar | Rendered on every page, left side |
| `_Footer.md` | Page footer | Rendered at the bottom of every page |

These files are **always visible** — `_Sidebar.md` and `_Footer.md` appear on every page without explicit inclusion.

### 5. Markdown Rendering

- Standard GitHub-Flavored Markdown (GFM) is supported
- Tables, code blocks, task lists, and emojis work
- Raw HTML is **not rendered** — only markdown syntax
- Mermaid diagrams are **not supported** in wiki pages (use ASCII diagrams instead)
- LaTeX/math is **not supported** in wiki pages

### 6. Images

Images in wiki pages can be handled two ways:

**Option A: Commit images to the wiki repo**

```markdown
![Diagram](architecture-diagram.png)
```

The image file must be in the root of the wiki repo (flat structure).

**Option B: Use external URLs**

```markdown
![Diagram](https://raw.githubusercontent.com/{org}/{repo}/main/docs/images/architecture-diagram.png)
```

Use raw GitHub URLs pointing to images in the main repository.

### 7. No Pull Request Workflow

Wiki changes push directly to `master` — there is no review process. This means:

- Changes are immediately visible after push
- No branch protection rules apply
- No CI/CD checks run on wiki pushes
- Be careful with what you push — it's live immediately

---

## Writing Wiki Pages

### File Naming Conventions

```
# Good — Title-Case-With-Hyphens
Home.md
Getting-Started.md
Architecture-Overview.md
Database-Schema.md
API-Overview-Authentication.md
_Sidebar.md
_Footer.md

# Bad — inconsistent naming
home.md
getting_started.md
architectureOverview.md
GETTING-STARTED.md
api overview.md
```

### Cross-Linking Between Pages

Link to other wiki pages using just the page name (no `.md` extension, no path):

```markdown
# Correct — page name only, no extension
See the [Getting Started](Getting-Started) guide.
Read about [Database Schema](Database-Schema).
Check the [API Reference](Endpoint-Reference).

# Incorrect — do NOT include .md extension
See the [Getting Started](Getting-Started.md)

# Incorrect — do NOT include path
See the [Getting Started](wiki/Getting-Started)
```

### Anchor Links Within a Page

Link to sections within the same page using lowercase, hyphen-separated anchors:

```markdown
## My Section Heading

... content ...

## Another Section

See [My Section Heading](#my-section-heading) above.
```

**Anchor rules:**
- Lowercase all characters
- Replace spaces with hyphens
- Remove special characters (periods, commas, colons, etc.)
- Example: `## API Overview & Authentication` -> `#api-overview--authentication`

### Cross-Page Anchor Links

Link to a specific section on another page:

```markdown
See the [authentication section](API-Overview-Authentication#authentication).
```

### Table of Contents

For long pages, include a manual table of contents:

```markdown
## Table of Contents

- [Section One](#section-one)
- [Section Two](#section-two)
  - [Sub Section](#sub-section)
- [Section Three](#section-three)
```

---

## Committing and Pushing

### Standard Workflow

```bash
cd {local_wiki_directory}

# Stage all changes
git add -A

# Commit with descriptive message
git commit -m "{commit_message}"

# Push to wiki
git push origin master
```

### Commit Message Guidelines

Use descriptive commit messages that indicate what was documented:

```
# Good commit messages
docs: generate initial wiki from codebase analysis
docs: update API endpoint reference
docs: add database schema documentation
docs: refresh wiki after v{version} release

# Bad commit messages
update
changes
wiki update
```

### Verifying the Push

After pushing, verify the wiki is live:

```
https://github.com/{org}/{repo}/wiki
```

Check:
- Home page renders correctly
- Sidebar navigation is visible
- Cross-links between pages work
- Code blocks render with syntax highlighting
- Tables are formatted correctly

---

## Fallback: When Wiki is Not Accessible

If the wiki repository cannot be cloned (wiki disabled, no write access, empty wiki that cannot be initialized), fall back to generating pages in the main repository.

### Fallback Strategy

1. Create a `docs/wiki/` directory in the main repository
2. Generate all wiki pages there
3. Create a PR with the generated documentation
4. Include instructions for the user to publish to the wiki manually

### Generating in docs/wiki/

```bash
mkdir -p {project_root}/docs/wiki
# Write all wiki page files to {project_root}/docs/wiki/
# e.g., {project_root}/docs/wiki/Home.md
# e.g., {project_root}/docs/wiki/Getting-Started.md
```

### PR Description Template

```markdown
## Wiki Documentation Generated

This PR contains auto-generated wiki documentation in `docs/wiki/`.

### To publish to the GitHub Wiki:

1. Enable the wiki: Repository → Settings → Features → Wikis
2. Create an initial page via the GitHub UI (if not yet done)
3. Clone the wiki repo:
   \`\`\`bash
   git clone git@github.com:{org}/{repo}.wiki.git
   \`\`\`
4. Copy the generated pages:
   \`\`\`bash
   cp docs/wiki/*.md {path_to_wiki_clone}/
   \`\`\`
5. Push to the wiki:
   \`\`\`bash
   cd {path_to_wiki_clone}
   git add -A
   git commit -m "docs: publish generated wiki documentation"
   git push origin master
   \`\`\`

### Generated Pages

{list_of_generated_pages}
```

### Alternative: Keep docs/wiki/ as Primary

Some teams prefer keeping documentation in the main repo for review via PRs. In this case:

- `docs/wiki/` becomes the canonical documentation location
- No wiki repo interaction needed
- Documentation changes go through normal PR review
- GitHub Pages can optionally serve the docs

---

## Updating Existing Wiki

When regenerating or updating wiki documentation for a project that already has a wiki:

### 1. Pull Latest

Always pull the latest wiki content before making changes:

```bash
cd {local_wiki_directory}
git pull origin master
```

### 2. Diff Before Overwriting

Before overwriting existing pages, compare with what is already there:

```bash
# Compare a specific file
diff {local_wiki_directory}/{page_name}.md {new_generated_page_path}

# List files that would change
# (compare directory listings)
```

### 3. User Approval

**Never overwrite existing wiki pages without explicit user approval.** Present the user with:

- List of pages that will be **added** (new files)
- List of pages that will be **modified** (existing files with changes)
- List of pages that will be **unchanged** (existing files with no changes)
- List of pages that exist in wiki but were **not regenerated** (will be preserved)

### 4. Preserve User Edits

If a page exists in the wiki but was not generated by the skill, **do not delete it**. Only add new pages and update pages that were originally generated.

### 5. Commit Updated Pages

```bash
cd {local_wiki_directory}
git add -A
git commit -m "docs: update wiki documentation for v{version}"
git push origin master
```

---

## Troubleshooting

### "Repository not found"

```
fatal: repository 'git@github.com:{org}/{repo}.wiki.git' not found
```

**Causes:**
- Wiki is not enabled in repository settings
- Repository does not exist or you do not have access
- Repository is private and SSH key/token lacks access

**Resolution:**
1. Check if wiki is enabled: Repository → Settings → Features → Wikis
2. Verify you have write access to the repository
3. Check SSH key: `ssh -T git@github.com`
4. Fall back to `docs/wiki/` strategy if wiki cannot be accessed

### "Permission denied"

```
ERROR: Permission to {org}/{repo}.wiki.git denied to {username}.
fatal: Could not read from remote repository.
```

**Causes:**
- User does not have write access to the repository
- SSH key is not associated with the correct GitHub account
- Deploy key does not have write access

**Resolution:**
1. Verify repository write access on GitHub
2. Check SSH key: `ssh -T git@github.com`
3. For deploy keys, ensure "Allow write access" is checked
4. Fall back to `docs/wiki/` strategy

### "Updates were rejected"

```
! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'git@github.com:{org}/{repo}.wiki.git'
```

**Causes:**
- Someone else pushed to the wiki since you cloned/pulled
- Wiki was edited via the GitHub UI while you worked locally

**Resolution:**
```bash
git pull origin master
# Resolve any merge conflicts
git push origin master
```

### Empty Wiki Cannot Be Cloned

Some repository configurations require at least one page to exist before the wiki repo can be cloned.

**Resolution:**
1. Navigate to `https://github.com/{org}/{repo}/wiki`
2. Click "Create the first page"
3. Add a placeholder title and content
4. Click "Save Page"
5. Now clone the wiki repo — the initial page will be there
6. Overwrite it with generated content

### Wiki Pages Not Rendering

**Symptoms:** Pushed files but pages do not appear in the wiki.

**Causes:**
- Files are in subdirectories (wiki only renders root-level files)
- File extension is not `.md` (wiki only renders markdown)
- Pushed to wrong branch (must be `master`)
- File names contain characters that GitHub cannot render

**Resolution:**
1. Verify all `.md` files are in the root directory
2. Check branch: `git branch` should show `master`
3. Verify file names use only alphanumeric characters and hyphens
4. Check for BOM characters or encoding issues in files

### Sidebar Not Showing

**Symptoms:** `_Sidebar.md` was committed but sidebar does not appear.

**Causes:**
- File name is incorrect (must be exactly `_Sidebar.md`, case-sensitive)
- File is in a subdirectory
- File has syntax errors in markdown

**Resolution:**
1. Verify file name: `ls -la _Sidebar.md`
2. Verify file is in root: `pwd` should be the wiki repo root
3. Check markdown syntax — broken links or tables can prevent rendering
4. Push again: sometimes a re-push resolves rendering cache issues

### Cross-Links Not Working

**Symptoms:** Clicking a link shows "Page not found" error.

**Causes:**
- Link includes `.md` extension: `[Link](Page-Name.md)` (wrong)
- Link includes path: `[Link](docs/Page-Name)` (wrong)
- Target page does not exist
- Page name has different casing than the link

**Resolution:**
- Use page name only: `[Link](Page-Name)` (correct)
- Verify the target page file exists in the wiki repo
- Match casing exactly between file name and link

---

## Complete Workflow Summary

The end-to-end workflow for the wiki-docs skill:

```
1. Detect remote URL from the project's git config
2. Derive wiki URL ({repo_url} -> {wiki_url})
3. Attempt to clone wiki repo to sibling directory
4. If clone fails:
   a. Fall back to docs/wiki/ in main repo
   b. Generate pages there
   c. Create PR with publishing instructions
   d. Stop here
5. If clone succeeds:
   a. If wiki already has content, pull latest
   b. Compare existing pages with what will be generated
   c. Present diff summary to user for approval
   d. Write generated pages to wiki directory
   e. Stage, commit, and push to master
   f. Verify wiki is accessible at GitHub URL
   g. Report success with link to wiki
```

### Key Commands Summary

| Action | Command |
|--------|---------|
| Get remote URL | `git remote get-url origin` |
| Clone wiki | `git clone {wiki_url} {wiki_dir}` |
| Pull latest | `cd {wiki_dir} && git pull origin master` |
| Stage all | `cd {wiki_dir} && git add -A` |
| Commit | `cd {wiki_dir} && git commit -m "{message}"` |
| Push | `cd {wiki_dir} && git push origin master` |
| Verify | Open `https://github.com/{org}/{repo}/wiki` |
