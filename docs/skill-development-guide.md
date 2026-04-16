# Skill Development Guide

This guide explains how to create effective Claude Code skills that enhance Claude's capabilities for specific tasks.

---

## 📖 What is a Claude Code Skill?

A **Claude Code Skill** is a markdown file with YAML frontmatter that:
- Provides domain-specific expertise
- Defines systematic workflows for complex tasks
- Includes reference materials and code examples
- Auto-activates based on conversation context

Skills augment Claude's base capabilities without requiring retraining.

---

## 🎯 Anatomy of a Good Skill

### 1. YAML Frontmatter

Every skill must start with YAML frontmatter:

```yaml
---
name: skill-name
description: Trigger phrases describing when to use this skill...
version: 1.0.0
tools: Read, Glob, Grep, Bash, Edit, Write
---
```

**Fields:**
- **name** (required) - Kebab-case identifier (e.g., `security-fix`, `api-design`)
- **description** (required) - Trigger phrases for activation (critical!)
- **version** (required) - Semantic version (major.minor.patch)
- **tools** (optional) - Pre-approved tools to reduce permission prompts

### 2. Quick Reference Section

Start with a TL;DR overview:

```markdown
# Skill Name

## TL;DR - Quick Reference

**What:** Brief description of what this skill does
**When:** When to use this skill
**Output:** What deliverables the skill produces

### Workflow
1. Phase 1 name
2. Phase 2 name
3. Phase 3 name
...
```

This helps Claude quickly understand the skill's purpose.

### 3. Activation Criteria

Explicitly state when the skill applies:

```markdown
## When This Skill Applies

Use this skill when the user:
- Says specific phrase 1
- Mentions keyword A or keyword B
- Asks about topic X
- Needs to accomplish task Y

Do NOT use when:
- Scenario A (use other-skill instead)
- Scenario B (not applicable)
```

### 4. Core Workflow

The heart of your skill - actionable steps:

```markdown
## Core Workflow

### Phase 1: Phase Name

**Goal:** Clear objective for this phase

**Steps:**
1. Do specific action A
2. Execute specific command B
3. Analyze result C

**Example:**
[Code or command example]

**Exit Criteria:**
- [ ] Criterion 1 met
- [ ] Criterion 2 met
```

**Key principles:**
- Tell Claude what to **DO**, not just what to **know**
- Be specific and actionable
- Include examples
- Define exit criteria

### 5. Reference Materials

Provide supporting information:

```markdown
## Reference: Common Patterns

### Pattern Name

**Description:** What this pattern solves

**Example (Vulnerable):**
```code
// Show the problem
```

**Example (Fixed):**
```code
// Show the solution
```

**When to use:** Guidelines
```

### 6. Operating Principles

Define guiding rules:

```markdown
## Operating Principles

1. **Principle Name** - Explanation
2. **Another Principle** - Why it matters
3. **Third Principle** - How to apply
```

---

## 🔑 Writing Effective Descriptions

The `description` field is **CRITICAL** - it determines when your skill activates.

### ✅ Good Descriptions

```yaml
description: Use when the user asks to "fix a security issue", "handle a security report", "address a vulnerability", "patch CVE", mentions "security audit", "bug bounty", "XSS", "SQL injection", "CSRF", or needs to implement a security patch in WordPress code.
```

**Why it works:**
- Lists specific phrases users actually say
- Includes domain terminology
- Covers variations and synonyms
- Clear scope boundaries

### ❌ Bad Descriptions

```yaml
description: Security stuff
```

**Problems:**
- Too vague
- No trigger phrases
- Won't activate reliably

### Tips for Great Descriptions

1. **Use actual user phrases** - "fix a bug", not "bug fixing"
2. **Include domain keywords** - Technical terms users will mention
3. **Add variations** - "fix/handle/address/patch"
4. **Be specific** - "WordPress security" not just "security"
5. **Test it** - Try saying the phrases to Claude

---

## 🏗️ Skill Structure Patterns

### Pattern 1: Workflow Skill

Best for: Multi-step processes, systematic approaches

```
skill-name/
├── SKILL.md           # Main workflow (phases, steps, examples)
├── README.md          # Usage documentation
├── references/        # Detailed reference materials
│   ├── patterns.md
│   └── checklist.md
├── templates/         # Output templates
│   └── summary.md
└── examples/          # Walkthroughs
    └── example.md
```

**Example:** security-fix skill

### Pattern 2: Pattern Library Skill

Best for: Collections of code patterns, recipes

```
skill-name/
├── SKILL.md           # Overview and pattern index
├── README.md          # Usage guide
└── patterns/          # Individual patterns
    ├── pattern-1.md
    ├── pattern-2.md
    └── pattern-3.md
```

**Example:** react-security-patterns

### Pattern 3: Decision Framework Skill

Best for: Helping make architectural decisions

```
skill-name/
├── SKILL.md           # Decision framework
├── README.md          # Usage guide
├── criteria/          # Decision criteria
│   ├── performance.md
│   └── security.md
└── options/           # Available options
    ├── option-a.md
    └── option-b.md
```

**Example:** api-architecture-decisions

---

## 📏 Skill Size Guidelines

### Main SKILL.md

**Target:** 500-1,200 lines
- **Too small (<300 lines):** Probably not enough structure
- **Too large (>2,000 lines):** Hard to parse, split into references

### Reference Files

**Target:** 50-300 lines each
- Keep focused on one topic
- Link from main SKILL.md
- Multiple small files > one large file

### Total Skill Size

**Target:** 50KB - 500KB
- **Small (<50KB):** Simple workflow, few examples
- **Medium (50-200KB):** Comprehensive workflow with references
- **Large (200-500KB):** Complex domain with many patterns
- **Too large (>500KB):** Consider splitting into multiple skills

---

## ✨ Skill Quality Checklist

Before submitting your skill, verify:

### Content Quality
- [ ] Clear, actionable workflow (not just information)
- [ ] Specific trigger phrases in description
- [ ] Real code examples (not pseudocode)
- [ ] All examples tested and working
- [ ] Exit criteria defined for phases
- [ ] Error handling included
- [ ] Edge cases considered

### Documentation
- [ ] README.md explains skill purpose and usage
- [ ] Examples show real-world scenarios
- [ ] All links work (internal and external)
- [ ] Markdown renders correctly
- [ ] Code blocks have language tags

### Structure
- [ ] Valid YAML frontmatter
- [ ] Logical heading hierarchy (h1 > h2 > h3)
- [ ] Consistent formatting throughout
- [ ] References in separate files (not cluttering main)
- [ ] Templates provided where applicable

### Testing
- [ ] Skill activates with trigger phrases
- [ ] Claude follows workflow correctly
- [ ] Produces expected deliverables
- [ ] Works with real code/projects
- [ ] No permission prompt storms

---

## 🎓 Learning from Examples

### Study Existing Skills

1. **security-fix** - Comprehensive workflow skill
   - 10 phases with clear steps
   - Quality gates and checkpoints
   - Extensive references (14 guides)
   - Professional templates

2. **security-audit** - Investigation skill
   - Evidence-driven scanning
   - Issue classification
   - GitHub integration

### Common Patterns to Use

**Quality Gates:**
```markdown
### Phase X: Phase Name

[Phase content]

**Quality Gate: Before proceeding to Phase Y**

Ask the user to confirm:
- [ ] Understanding is correct
- [ ] Approach makes sense
- [ ] Ready to proceed
```

**Decision Matrices:**
```markdown
| Option | Security | Performance | Complexity | Score |
|--------|----------|-------------|------------|-------|
| A      | High (2x)| Medium      | Low        | 7/10  |
| B      | Medium   | High        | Medium     | 6/10  |
```

**Progressive Disclosure:**
- Overview in SKILL.md
- Details in references/
- Deep examples in examples/

---

## 🚫 Common Mistakes

### 1. Information Overload

❌ **Problem:** Including everything in SKILL.md
✅ **Solution:** Move details to references/, keep main workflow focused

### 2. Vague Instructions

❌ **Problem:** "Be careful with security"
✅ **Solution:** "Verify nonce with `wp_verify_nonce( $_POST['nonce'], 'action' )`"

### 3. No Examples

❌ **Problem:** Theory only, no code
✅ **Solution:** Show vulnerable code AND fixed code for every pattern

### 4. Poor Activation

❌ **Problem:** Description too generic or technical
✅ **Solution:** Use phrases users actually say

### 5. Too Broad

❌ **Problem:** "Full stack development skill"
✅ **Solution:** "React component security patterns"

---

## 🧪 Testing Your Skill

### 1. Installation Test

```bash
# Symlink your development skill
ln -s /path/to/your/skill ~/.claude/skills/skill-name-dev

# Verify Claude can see it
echo "Test activation phrase" | claude
```

### 2. Activation Test

Try various trigger phrases:
- Exact phrases from description
- Variations and synonyms
- Related terms
- Edge cases

Verify skill loads when expected.

### 3. Workflow Test

Run through complete workflow:
- Does each phase make sense?
- Are steps actionable?
- Do examples work?
- Are deliverables complete?

### 4. Real-World Test

Use the skill on actual projects:
- Does it handle real complexity?
- Are edge cases covered?
- Is output quality high?

---

## 📦 Publishing Your Skill

### 1. Prepare for Submission

```bash
# Ensure all files are complete
ls skill-name/

# Check YAML frontmatter
head -10 skill-name/SKILL.md

# Verify all links work
grep -r "]()" skill-name/

# Test one more time
```

### 2. Create Pull Request

```bash
# Create branch
git checkout -b skill/your-skill-name

# Add files
git add skills/your-skill-name/
git commit -m "Add: Your Skill Name

- Brief description
- Key features
- Target use cases
"

# Push and create PR
git push origin skill/your-skill-name
```

### 3. PR Description

```markdown
## New Skill: Your Skill Name

**Purpose:** What this skill does
**Target users:** Who will use it
**Size:** XXX lines, YY KB

### Features
- Feature 1
- Feature 2

### Testing
- Tested with [scenario 1]
- Verified [aspect 2]

### Checklist
- [x] YAML frontmatter valid
- [x] All examples tested
- [x] Documentation complete
- [x] Links verified
```

---

## 💡 Skill Ideas

### High-Priority Needs

- **API Design** - REST API security and best practices
- **Performance Optimization** - WordPress performance patterns
- **Database Migrations** - Safe schema change workflows
- **Testing Strategy** - Unit/integration/E2E test generation
- **Accessibility Audit** - WCAG compliance checking

### Domain-Specific

- **WooCommerce Security** - E-commerce specific patterns
- **Multisite Management** - Network-level operations
- **Gutenberg Development** - Block development workflow
- **REST API Design** - Endpoint security and structure
- **React Security** - Frontend security patterns

### Process-Oriented

- **Code Review** - Systematic code review process
- **Release Management** - Deploy and release workflows
- **Documentation** - Auto-generate documentation
- **Refactoring** - Safe refactoring procedures
- **Debugging** - Systematic debugging approach

---

## 📚 Resources

### WordPress
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [WordPress Security Handbook](https://developer.wordpress.org/advanced-administration/security/)
- [Plugin Handbook](https://developer.wordpress.org/plugins/)

### Security
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- [WordPress Security White Paper](https://wordpress.org/about/security/)

### Claude Code
- [Claude Code Documentation](https://github.com/anthropics/claude-code)
- [Claude Agent SDK](https://github.com/anthropics/claude-agent-sdk)

---

## ❓ Questions?

- **General questions:** Open a GitHub Issue
- **Skill review:** Open a draft PR and ask for feedback
- **Technical issues:** [GitHub Issues](https://github.com/bhattaganesh/developers-toolkit/issues)

---

**Ready to create your first skill? Start with a simple workflow and iterate!** 🚀
