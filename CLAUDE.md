# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Claude Code plugin marketplace** and **skills repository** containing the `developers` plugin — a complete developer toolkit with 23 agents, 34 commands, 10 rules, 5 hooks, and 14 auto-activating skills for WordPress, React, and general web development.

**GitHub:** (configure your repository URL here)

## Quick Reference

| Task | Command/Location |
|------|-----------------|
| Install plugin | `/plugin marketplace add [your-repo]/developers` → `/plugin install developers` |
| Test changes locally | `ln -s $(pwd) ~/.claude/skills/developers-toolkit-dev` |
| Add new agent | Create `agents/name.md` → Add to `plugin.json` agents array |
| Add new command | Create `commands/name.md` → Add to `plugin.json` commands array |
| Add new skill | Create `skills/name/SKILL.md` with YAML frontmatter (auto-discovers) |
| Add new hook | Edit `hooks/hooks.json` |
| Validate JSON | `cat file.json \| jq .` |
| Run code review | `/developers:code-review` |
| Scaffold WP feature | `/developers:wp-new-feature` |
| Check git status | `git status` |
| Commit format | `feat:`, `fix:`, `docs:`, `chore:`, `refactor:` |

The repository is in **active development** with a focus on polished WordPress and React tooling.

## Tech Stack

- **Pure markdown and JSON** — No build tools, no compilation, no dependencies
- **Claude Code plugin system** — Native plugin format with marketplace discovery
- **Git** — Version control and distribution
- **File-based configuration** — Changes take effect on plugin reload (no restart needed)

## Commands

### Plugin Installation & Testing

```bash
# Add this repo as a marketplace (one-time setup)
/plugin marketplace add bhattaganesh/developers-toolkit

# Install the plugin
/plugin install developers --scope project  # or --scope user or --scope local

# Update plugin to latest version
/plugin marketplace update developers

# Remove plugin
/plugin remove developers

# List all installed plugins
/plugin list
```

### Local Development & Testing

```bash
# Symlink for local testing (test changes without pushing)
ln -s $(pwd) ~/.claude/skills/developers-toolkit-dev

# Test from local marketplace
/plugin marketplace add file://~/.claude/skills/developers-toolkit-dev
/plugin install developers --scope local
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feat/feature-name       # New feature
git checkout -b fix/issue-description   # Bug fix
git checkout -b skill/new-skill-name    # New skill
git checkout -b docs/update-readme      # Documentation

# Commit with conventional format
git add .
git commit -m "feat: add new wp-developer agent

- Writes WordPress plugin/theme code
- Follows WPCS standards
- Supports CPTs and REST endpoints
"

# Push and create PR
git push origin feat/feature-name

# Update from upstream
git pull origin main

# Check current changes
git status
git diff
```

### Useful Commands

```bash
# Find all agents
ls -la developers/agents/

# Find all commands
ls -la developers/commands/

# Find all skills
ls -la developers/skills/

# Validate JSON files
cat developers/.claude-plugin/plugin.json | jq .
cat .claude-plugin/marketplace.json | jq .
cat developers/hooks/hooks.json | jq .

# Search for patterns across skills
grep -r "trigger phrase" developers/skills/

# Count total lines in plugin
find developers -name "*.md" -o -name "*.json" | xargs wc -l
```

## Repository Structure

**Key Directories:**
- `developers/` — Main plugin directory containing all agents, commands, rules, hooks, and skills
  - `agents/` — 23 specialized agents
  - `commands/` — 34 slash commands for workflows
  - `rules/` — 10 coding standard files for WordPress, React, security, testing, etc.
  - `hooks/hooks.json` — 5 hooks for auto-linting and safety checks
  - `skills/` — 14 skills (context skills + workflow skills)
  - `templates/CLAUDE.md.template` — Template for project initialization
  - `.claude-plugin/plugin.json` — Plugin manifest with metadata and file references
- `.claude-plugin/marketplace.json` — Marketplace manifest for plugin discovery
- `docs/` — Repository documentation including skill development guide and installation guide

## Development Workflows

### Testing Changes Locally

When modifying agents, commands, rules, skills, or hooks:

1. **Symlink the repository** to your Claude skills directory:
   ```bash
   ln -s $(pwd) ~/.claude/skills/developers-toolkit-dev
   ```

2. **Test plugin installation** from the local marketplace:
   ```bash
   /plugin marketplace add file://~/.claude/skills/developers-toolkit-dev
   /plugin install developers --scope local
   ```

3. **Test skills activation** by using trigger phrases in conversation

4. **Verify changes** in the appropriate context (WordPress files for wordpress-context, React files for react-context, etc.)

### Adding New Content

**New Agent:**
1. Create `developers/agents/agent-name.md` following the existing agent format
2. Add path to `agents` array in `developers/.claude-plugin/plugin.json`
3. Test via local symlink

**New Command:**
1. Create `developers/commands/command-name.md` with frontmatter including `description`
2. Add path to `commands` array in `developers/.claude-plugin/plugin.json`
3. Command becomes available as `/developers:command-name`

**New Rule:**
1. Create `developers/rules/rule-name.md` with coding standards
2. Rules are auto-loaded; no plugin.json update needed
3. Place in `rules/` directory alongside existing standards

**New Skill:**
1. Create directory `developers/skills/skill-name/`
2. Create `SKILL.md` with YAML frontmatter (name, description, version, tools)
3. Add supporting files in `references/`, `templates/`, or `examples/` subdirectories
4. Skills auto-discover from `skills/` directory via plugin.json

**New Hook:**
1. Edit `developers/hooks/hooks.json`
2. Add hook configuration with event type and shell command

### Git Workflow

**Commit Message Format:**
- Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`
- Examples from recent history:
  - `feat: consolidate agents into single developers plugin v2.0.0`
  - `fix: use array format for agents field in plugin.json`
  - `docs: update main README with plugin marketplace`

**Branching:**
- Feature branches: `feat/feature-name`
- Bug fixes: `fix/issue-description`
- Skills: `skill/new-skill-name`

## File Formats and Conventions

**Agent Files (`agents/*.md`):**
- YAML frontmatter with `description` field
- Clear role definition and scope
- Specify available tools (Read, Grep, Glob for read-only; add Edit, Write, Bash for builders)
- Include example usage and operating principles

**Command Files (`commands/*.md`):**
- YAML frontmatter with `description` field for `/plugin list` display
- Step-by-step instructions for Claude to execute
- Include verification steps

**Rule Files (`rules/*.md`):**
- Coding standards organized by topic (WordPress, React, Security, Testing, etc.)
- Include code examples showing correct vs incorrect patterns
- Referenced automatically when working on relevant file types

**Skill Files (`skills/*/SKILL.md`):**
- YAML frontmatter: `name`, `description` (trigger phrases), `version`, `tools`
- TL;DR section with workflow overview
- "When This Skill Applies" criteria
- Core workflow with phases, steps, and examples
- Reference materials embedded or in `references/` subdirectory

**Skill Directory Structure (example):**
```
developers/skills/security-fix/
├── SKILL.md                    # Main skill file with YAML frontmatter
├── README.md                   # Skill documentation
├── references/                 # Reference guides (optional)
│   ├── 00-index.md
│   ├── vulnerability-patterns.md
│   └── testing-guide.md
├── templates/                  # Output templates (optional)
│   ├── security-advisory.md
│   └── github-issue.md
└── examples/                   # Example walkthroughs (optional)
    └── sample-fix.md
```

**Skills in This Repository:**
- **Context skills:** wordpress-context, react-context, testing-context, rules
  - Auto-activate when editing matching file types
  - Provide architecture guidance and coding standards
- **Workflow skills:** security-fix, chrome-debug, accessibility-audit, wiki-docs, ux-reviewer, modular-security-audit
  - Trigger on user phrases in description field
  - Execute multi-phase workflows with deliverables

**Hooks Configuration (`developers/hooks/hooks.json`):**

The plugin includes 5 hooks that run automatically in target projects:

**PostToolUse Hooks (run after Write/Edit):**
1. **PHP Syntax Check** — `php -l "$FILE_PATH"` on `.php` files
2. **ESLint Fix** — `npx eslint --fix "$FILE_PATH"` on JS/TS files
3. **Prettier Format** — `npx prettier --write "$FILE_PATH"` on CSS/SCSS files
4. **Stack Detection** — Automated stack detection on session start

**PreToolUse Hooks (run before Bash):**
5. **Block Destructive Commands** — Blocks `rm -rf`, `DROP TABLE`, `--force`

All hooks include `|| true` to fail gracefully if tools don't exist in target project.

**Plugin Manifest (`developers/.claude-plugin/plugin.json`):**
- JSON format with metadata (name, version, description, author, license)
- File path arrays for `agents`, `commands` (relative to plugin directory)
- Path to `hooks` JSON file
- Path to `skills` directory
- Update version following semantic versioning when making changes

## Architecture Patterns

**Plugin System:**
- Single consolidated plugin (`developers`) contains all functionality
- Marketplace manifest (`.claude-plugin/marketplace.json`) registers available plugins
- Plugin manifest (`developers/.claude-plugin/plugin.json`) defines plugin contents
- File-based configuration — no build step required
- All paths in plugin.json are relative to plugin directory
- Plugins can include: agents, commands, rules, hooks, skills

**Skill Activation:**
- **Context skills** (react-context, wordpress-context, testing-context) auto-activate based on file patterns
  - User doesn't invoke — skill silently augments Claude's knowledge
- **Workflow skills** (security-fix, chrome-debug, accessibility-audit, dev-docs, ux-reviewer, rules) trigger on user phrases
  - Example: User says "fix a security vulnerability" → security-fix skill loads
  - Description field in YAML must match natural user language
- Skills include embedded references to reduce context loading
- Skills use `tools` frontmatter to pre-approve tool usage and reduce permission prompts

**Agent Specialization:**
- **Review agents** (11 total) are read-only — only have `Read`, `Grep`, `Glob` tools
  - Never modify files, only analyze and report findings
  - Examples: security-auditor, php-reviewer, wp-reviewer, test-critic
- **Builder agents** have full toolset — `Read`, `Write`, `Edit`, `Glob`, `Grep`, `Bash`
  - Generate and modify code based on specifications
  - Examples: wp-developer, frontend-developer, dba
- Each agent has a single, focused responsibility
- Agents include operating principles and constraints in their definition

**Hook System:**
- Hooks execute shell commands on specific tool events
- **PostToolUse hooks** — Run after Write/Edit (linting, syntax checks, suggestions)
  - Example: `php -l "$FILE_PATH"` after editing PHP files
  - Example: `npx eslint --fix "$FILE_PATH"` after editing JS files
- **PreToolUse hooks** — Run before Bash (block dangerous commands)
  - Example: Block `wp db reset`, `wp db drop`, `rm -rf`, `.env` commits
- Hooks run in target project context, not this repository
- All hooks include `|| true` to fail gracefully if tools don't exist

- Rules provide inline guidance without needing to search docs

## Available Plugin Commands

All commands require the `developers:` prefix:

### Code Quality & Review
- `/developers:code-review` — Multi-agent code review (auto-detects stack, runs reviewers in parallel)
- `/developers:security-scan` — Security audit using security-auditor agent
- `/developers:test-gaps` — Find missing test coverage using test-critic agent
- `/developers:pre-pr` — Pre-PR checklist (debug artifacts, auth, migrations, tests, PR description)

### Code Generation & Scaffolding
- `/developers:new-component` — Create React/NextJS component (responsive, accessible)
- `/developers:wp-new-feature` — Scaffold new WordPress plugin feature
- `/developers:write-tests` — Generate tests for controllers/components/services
- `/developers:claude-code-setup` — Initialize project with CLAUDE.md and .claude/ settings

### Development Workflows
- `/developers:debug` — Systematic debugging with structured root cause analysis
- `/developers:refactor` — Guided refactoring (identifies type, updates references, verifies tests)
- `/developers:fix-tests` — Diagnose and fix failing tests
- `/developers:explain` — Trace execution path (produces ASCII diagram)

### Documentation & Analysis
- `/developers:api-docs` — Generate API docs from routes/controllers
- `/developers:changelog` — Generate formatted changelog from git history
- `/developers:deploy-check` — Pre-deployment checklist
- `/developers:profile` — Performance profiling plan with tools and targets

## Common Tasks

### Update Plugin Version (for releases)

```bash
# 1. Increment version in plugin manifest
# Edit developers/.claude-plugin/plugin.json
"version": "2.1.0"  # Update this

# 2. Update marketplace version
# Edit .claude-plugin/marketplace.json
"version": "2.1.0"  # Update this

# 3. Document changes
# Edit CHANGELOG.md - add entry under ## [2.1.0] - YYYY-MM-DD

# 4. Commit and tag
git add .
git commit -m "chore: bump version to 2.1.0"
git tag v2.1.0
git push origin main --tags
```

### Add New Agent

```bash
# 1. Create agent file
touch developers/agents/my-agent.md

# 2. Add YAML frontmatter and agent definition
cat > developers/agents/my-agent.md << 'EOF'
---
name: my-agent
description: What this agent does and when to use it
tools:
  - Read
  - Grep
  - Glob
---

# My Agent

You are a specialized agent that...
EOF

# 3. Register in plugin.json
# Edit developers/.claude-plugin/plugin.json
# Add "./agents/my-agent.md" to the "agents" array

# 4. Test locally
ln -s $(pwd) ~/.claude/skills/developers-toolkit-dev
/plugin marketplace add file://~/.claude/skills/developers-toolkit-dev
/plugin install developers --scope local

# 5. Verify agent is available
/plugin list  # Should show my-agent in developers

# 6. Commit
git add .
git commit -m "feat: add my-agent for [purpose]"
```

### Add New Command

```bash
# 1. Create command file
touch developers/commands/my-command.md

# 2. Add command definition
cat > developers/commands/my-command.md << 'EOF'
---
description: What this command does
---

# My Command

Brief description of command purpose.

## Instructions

1. **Step 1** — What to do first
2. **Step 2** — What to do next
3. **Verify** — How to confirm success
EOF

# 3. Register in plugin.json
# Edit developers/.claude-plugin/plugin.json
# Add "./commands/my-command.md" to the "commands" array

# 4. Test command
/developers:my-command

# 5. Commit
git add .
git commit -m "feat: add my-command for [purpose]"
```

### Add New Skill

```bash
# 1. Create skill directory structure
mkdir -p developers/skills/my-skill/{references,templates,examples}

# 2. Create SKILL.md
cat > developers/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: "Trigger phrases that activate this skill. Use this skill when..."
version: 1.0.0
tools: Read, Glob, Grep, Bash
---

# My Skill

## TL;DR - Quick Reference
[Brief overview]

## When This Skill Applies
[Activation criteria]

## Core Workflow
[Phases and steps]
EOF

# 3. Create README
touch developers/skills/my-skill/README.md

# 4. Skills auto-discover from skills/ directory - no plugin.json edit needed

# 5. Test skill activation
# Say trigger phrase from description field in conversation

# 6. Commit
git add .
git commit -m "feat: add my-skill for [purpose]"
```

### Add Pattern to Existing Skill

```bash
# 1. Navigate to skill references
cd developers/skills/security-fix/references/

# 2. Edit appropriate reference file
# Add: vulnerability description, vulnerable code, fixed code, testing steps

# 3. Test skill with new pattern
# Trigger skill and verify new pattern is included

# 4. Commit
git add .
git commit -m "feat(security-fix): add pattern for [vulnerability type]"
```

### Add New Hook

```bash
# 1. Edit hooks.json
# Edit developers/hooks/hooks.json

# 2. Add new hook to appropriate event (PreToolUse or PostToolUse)
{
  "matcher": "Write|Edit",
  "pattern": "\\.ts$",
  "hooks": [
    {
      "type": "command",
      "command": "npx tsc --noEmit \"$FILE_PATH\" 2>&1 || true"
    }
  ]
}

# 3. Test hook
# Edit a .ts file and verify hook runs

# 4. Commit
git add .
git commit -m "feat: add TypeScript type check hook"
```

### Update Documentation

```bash
# For repository-wide changes
# Edit README.md

# For plugin-specific changes
# Edit developers/README.md

# For contribution workflow changes
# Edit CONTRIBUTING.md

# Always update CHANGELOG.md
# Add entry under ## [Unreleased]

git add .
git commit -m "docs: update [what was changed]"
```

## Gotchas

### Plugin System Gotchas

**1. Plugin Manifest JSON Structure**
- `agents` field must be an **array** of file paths, not an object
- **Wrong:** `"agents": { "security-auditor": "./agents/security-auditor.md" }`
- **Right:** `"agents": ["./agents/security-auditor.md"]`
- All paths in plugin.json are **relative to the plugin directory** (developers/)

**2. Marketplace vs Plugin Manifests**
- `.claude-plugin/marketplace.json` — Lists available plugins for discovery
- `developers/.claude-plugin/plugin.json` — Defines one plugin's contents
- These are **different files** with different structures — don't confuse them

**3. Skill Auto-Discovery**
- Skills auto-discover from `skills/` directory via `"skills": "./skills/"` in plugin.json
- Skills must have `SKILL.md` file with valid YAML frontmatter
- Subdirectories like `references/`, `templates/`, `examples/` are optional

**4. No Build Process**
- Changes to `.md` and `.json` files take effect on **plugin reload**
- No compilation, no bundling, no dependencies to install
- To test changes: edit file → reload plugin (or restart Claude Code)

### Skill Development Gotchas

**5. Skill Description is CRITICAL**
- **Context skills** (react-context, wordpress-context, testing-context) load based on file globs
- No user invocation required — they activate when editing matching files 
- User won't see skill load — it just augments Claude's knowledge

**7. Tool Permissions in Skills**
- `tools` frontmatter pre-approves tools to reduce permission prompts
- **Read-only skills:** `tools: Read, Glob, Grep`
- **Code-modifying skills:** `tools: Read, Write, Edit, Glob, Grep, Bash`
- If skill uses a tool not listed, user will be prompted

### Hooks Gotchas

**8. Hook Regex Patterns Need Escaped Backslashes**
- JSON strings need double-escaping: `\\.js$` not `\.js$`
- File pattern: `"pattern": "\\.js$"` matches `.js` extension
- Command pattern: `"pattern": "rm -rf| DROP TABLE"` blocks destructive commands

**9. Hooks Run in Target Project Context**
- Hooks reference tools like `wp-cli`, `npx eslint`, `npx prettier`
- These commands run in the **user's project**, not this repository
- Hooks fail gracefully if tools don't exist (`|| true` prevents errors)

**10. PreToolUse vs PostToolUse**
- `PreToolUse` — Runs **before** tool executes (use for blocking dangerous commands)
- `PostToolUse` — Runs **after** tool executes (use for linting, syntax checks, suggestions)

### Agent & Command Gotchas

**11. Agent Tool Restrictions**
- **Review agents** (security-auditor, php-reviewer, etc.) are **read-only** — only `Read`, `Grep`, `Glob`
- **Builder agents** (wp-developer, frontend-developer, etc.) have full tools — `Read`, `Write`, `Edit`, `Bash`
- If agent tries to use tool it doesn't have, user sees permission error

**12. Command Invocation Format**
- Commands use **plugin prefix**: `/developers:command-name`
- **Wrong:** `/code-review` or `/claude-code-setup`
- **Right:** `/developers:code-review` or `/developers:claude-code-setup`
- Slash commands are listed with `/plugin list`

### Git Workflow Gotchas

**13. Worktree Pattern for Parallel Development**
- Skills use git worktrees to isolate changes: `../<repo-name>-<task-name>`
- Main working directory remains untouched during skill execution
- Cleanup preserves worktrees — don't auto-delete them

**14. Commit Message Format is Enforced**
- Must use conventional format: `prefix: description`
- Valid prefixes: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `perf:`
- **Wrong:** "Added new feature" or "fix security bug"
- **Right:** `feat: add endpoint-scaffolder agent` or `fix: resolve auth token expiry`

### Testing Gotchas

**15. Local Testing Requires Symlink**
- Can't test by editing files in `~/.claude/plugins/` — that's readonly
- Must symlink to dev directory: `ln -s $(pwd) ~/.claude/skills/developers-toolkit-dev`
- Reload plugin after changes: restart Claude Code or re-install plugin

**16. Skills Don't Auto-Reload**
- After editing a skill, must **reload** to see changes
- Either restart Claude Code or uninstall/reinstall plugin
- Markdown rendering errors fail silently — validate manually

**17. Broken Internal References Fail Silently**
- Skills can reference files like `@references/patterns.md`
- If file doesn't exist, skill loads but references are empty
- Always verify file paths after creating new reference files

### Version & Distribution Gotchas

**18. Semantic Versioning is Required**
- Update version in **both** `plugin.json` and `marketplace.json` when releasing
- Version format: `major.minor.patch` (e.g., `2.0.0`, `1.3.1`)
- Skills have independent versions in their YAML frontmatter

**19. Scope Matters for Team Distribution**
- **project** scope → `.claude/settings.json` (committed, shared with team)
- **user** scope → `~/.claude/settings.json` (personal, all projects)
- **local** scope → `.claude/settings.local.json` (gitignored, this project only)
- Use **project** scope for team plugins, **local** scope for testing

**20. Marketplace Updates Don't Auto-Pull**
- `/plugin marketplace update` re-reads local marketplace files
- For git-based marketplaces, must `git pull` first to get latest changes
- Workflow: `cd ~/.claude/skills/developers-toolkit/ && git pull && /plugin marketplace update`

## Testing Checklist

Before submitting changes:
- [ ] Test locally via symlink to ~/.claude/skills/
- [ ] Verify all markdown files render correctly
- [ ] Check all internal file references are valid
- [ ] Test skill activation with trigger phrases
- [ ] Validate JSON files with `cat file.json | jq .`
- [ ] Update CHANGELOG.md with changes
- [ ] Follow commit message conventions (`feat:`, `fix:`, etc.)
- [ ] Verify no sensitive data in commits
- [ ] Update version in plugin.json if releasing
- [ ] Test on fresh install (not just symlink)

## Enterprise Deployment (Managed Settings)

This plugin can be deployed **organization-wide** using Claude Code's **Managed Settings** system.

### What are Managed Settings?

**Managed Settings** are IT-deployed, system-level configurations that:
- Have **highest precedence** — cannot be overridden by users
- Enforce security, compliance, and tooling standards
- Control which plugins, MCP servers, and commands are allowed
- Display company announcements to all users

### Deployment Locations

| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Linux/WSL | `/etc/claude-code/managed-settings.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-settings.json` |

### Documentation

- **Full Guide:** [docs/MANAGED-SETTINGS-GUIDE.md](docs/MANAGED-SETTINGS-GUIDE.md)
- **Template:** [developers/templates/managed-settings.json](developers/templates/managed-settings.json)
- **Official Docs:** https://code.claude.com/docs/en/settings

## Special Notes

- This repository has **no build process** — changes to .md and .json files take effect immediately when plugin reloads.
- The `developers` plugin is designed as a **baseline** — projects customize on top via project-specific CLAUDE.md and .claude/rules/.
- Hooks run automatically on events (file save, pre-commit, etc.) when plugin is installed in target projects.
- Auto-activating context skills load based on file type patterns — no user invocation needed.
- Review agents are read-only and never modify files; builder agents have full tool access.

