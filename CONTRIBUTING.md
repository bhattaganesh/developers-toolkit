# Contributing to Developers Toolkit

We're excited that you're interested in contributing! This toolkit is designed to help WordPress and React developers work more effectively with Claude Code.

## How to Contribute

### 1. Adding New Agents, Commands, or Rules
All standard tools live inside the `developers/` directory.
1. **Fork** the repository.
2. **Add** your file to the appropriate subdirectory:
   - `developers/agents/` for markdown-based agents.
   - `developers/commands/` for command definitions.
   - `developers/rules/` for coding standards.
3. **Update Manifest**: Add your new file path to the `agents` or `commands` array in `developers/.claude-plugin/plugin.json`.
4. **Submit PR**: Open a pull request against the `main` branch.

### 2. Adding New Skills
Skills are more complex, multi-phase workflows.
1. Create a new directory in `developers/skills/`.
2. Include a `SKILL.md` file with valid YAML frontmatter.
3. Check our [Skill Development Guide](docs/skill-development-guide.md) for detailed instructions.

## Coding Standards
- Use **WordPress Coding Standards** (WPCS) for PHP.
- Use **React/Next.js/Tailwind** best practices for frontend.
- Ensure all markdown documentation is clear and follows the existing hierarchy.

## PR Checklist
- [ ] Version number remains unchanged (maintainers will update).
- [ ] All new files are correctly registered in `plugin.json`.
- [ ] No debug artifacts (`error_log`, `console.log`).
- [ ] All internal links in documentation work.

Thank you for helping improve the toolkit! 🚀
