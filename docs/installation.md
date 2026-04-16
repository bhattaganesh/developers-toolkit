# Installation Guide

This guide provides detailed instructions for installing and using the Developers Plugin.

---

## 📋 Prerequisites

### Required
- **Claude Code** - Latest version installed
- **Git** - For cloning and updating

### Recommended
- **VS Code** or similar editor (for viewing/editing skills)
- **Terminal** - Command line access

---

## 🚀 Quick Install (Recommended)

### Step 1: Clone Repository

```bash
cd ~/.claude/skills/
git clone https://github.com/bhattaganesh/developers-toolkit.git
```

### Step 2: Verify Installation

```bash
# Check that skills directory exists
ls ~/.claude/skills/developers-toolkit/skills/

# Should show:
# security-fix/
# security-audit/
# (and other skills)
```

### Step 3: Test Activation

Start Claude Code and say:
```
"I need to fix a security vulnerability"
```

Claude should automatically load the security-fix skill.

---

## 🔧 Advanced Installation

### Install Specific Skill Only

If you only want one skill (not the whole repository):

```bash
cd ~/.claude/skills/
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/bhattaganesh/developers-toolkit.git
cd developers-toolkit
git sparse-checkout set developers/skills/security-fix
```

This downloads only the security-fix skill.



### Development Installation

For skill development and contributions:

```bash
# Fork repository on GitHub first, then:
cd ~/.claude/skills/
git clone https://github.com/YOUR-USERNAME/developers-toolkit.git developers-toolkit-dev

# Add upstream remote
cd developers-toolkit-dev
git remote add upstream https://github.com/bhattaganesh/developers-toolkit.git

# Create feature branch
git checkout -b skill/my-new-skill
```

---

## 🔄 Updating

### Update All Skills

```bash
cd ~/.claude/skills/developers-toolkit/
git pull origin main
```

### Update Specific Skill

If you used sparse checkout:

```bash
cd ~/.claude/skills/developers-toolkit/
git pull origin main
```

Git will only update the skills you've checked out.

### Auto-Update (Optional)

Create a cron job or scheduled task:

```bash
# Add to crontab (run daily at 9 AM)
0 9 * * * cd ~/.claude/skills/developers-toolkit && git pull origin main > /dev/null 2>&1
```

---

## 🎯 Using Skills

### Automatic Activation

Skills activate automatically when you mention trigger phrases:

| Skill | Trigger Phrases |
|-------|-----------------|
| security-fix | "fix security issue", "vulnerability", "CVE", "XSS", "SQL injection" |
| security-audit | "security audit", "scan for vulnerabilities", "security review" |

Just have a normal conversation with Claude - skills load as needed.

### Manual Activation (Rarely Needed)

You can explicitly request a skill:

```
"Use the security-fix skill to help me with this issue"
```

### Checking Active Skills

Claude will mention when a skill is loaded:

```
Claude: [Loaded security-fix skill]

I'll help you fix this security vulnerability using our 10-phase
systematic approach...
```

---

## 📁 Directory Structure

After installation, your directory structure:

```
~/.claude/skills/
└── developers-toolkit/              # This repository
    ├── README.md               # Repository overview
    ├── CONTRIBUTING.md         # How to contribute
    ├── CHANGELOG.md            # Version history
    ├── LICENSE                 # MIT License
    ├── skills/                 # All skills
    │   ├── security-fix/       # Security fix skill
    │   │   ├── SKILL.md        # Main skill file
    │   │   ├── README.md       # Skill documentation
    │   │   ├── references/     # Reference guides (14 files)
    │   │   ├── templates/      # Templates (4 files)
    │   │   └── examples/       # Examples
    │   └── security-audit/     # Security audit skill
    │       └── ...
    └── docs/                   # Documentation
        ├── skill-development-guide.md
        ├── installation.md     # This file
        └── best-practices.md
```

---

## 🔍 Verifying Skills

### Check Skill Files

```bash
# Verify main skill file exists
cat ~/.claude/skills/developers-toolkit/skills/security-fix/SKILL.md | head -20

# Should show YAML frontmatter and skill content
```

### Check YAML Frontmatter

```bash
# Verify YAML is valid
head -10 ~/.claude/skills/developers-toolkit/skills/security-fix/SKILL.md

# Should show:
# ---
# name: security-fix
# description: ...
# version: 1.0.0
# tools: ...
# ---
```

### Test Skill Activation

In Claude Code:
```
You: "Test: trigger security fix skill"
Claude: [Should load skill automatically]
```

---

## 🛠️ Troubleshooting

### Skill Not Activating

**Problem:** Claude doesn't load the skill when you mention trigger phrases

**Solutions:**
1. **Check file location:**
   ```bash
   ls ~/.claude/skills/developers-toolkit/skills/security-fix/SKILL.md
   ```
   File must exist at this path.

2. **Verify YAML frontmatter:**
   ```bash
   head -10 ~/.claude/skills/developers-toolkit/skills/security-fix/SKILL.md
   ```
   Must have valid YAML with `name`, `description`, `version`.

3. **Check Claude Code version:**
   ```bash
   claude --version
   ```
   Ensure you have latest version.

4. **Restart Claude Code:**
   Sometimes needed to pick up new skills.

5. **Try explicit activation:**
   ```
   "Load the security-fix skill"
   ```

### Git Clone Fails

**Problem:** Permission denied or authentication failure

**Solutions:**

1. **Use HTTPS instead of SSH:**
   ```bash
   git clone https://github.com/bhattaganesh/developers-toolkit.git
   ```

2. **Check GitHub access:**
   - If repository is private, ensure you have access
   - Configure GitHub authentication

3. **Check network/proxy:**
   - Verify internet connection
   - Check proxy settings if behind firewall

### Permission Issues

**Problem:** Can't write to `~/.claude/skills/`

**Solutions:**

1. **Check directory permissions:**
   ```bash
   ls -la ~/.claude/
   ```

2. **Create directory if missing:**
   ```bash
   mkdir -p ~/.claude/skills/
   ```

3. **Fix ownership:**
   ```bash
   chown -R $USER:$USER ~/.claude/
   ```

### Skills Directory Not Found

**Problem:** `~/.claude/skills/` doesn't exist

**Solution:**

```bash
# Create the directory
mkdir -p ~/.claude/skills/

# Clone repository
cd ~/.claude/skills/
git clone https://github.com/bhattaganesh/developers-toolkit.git
```

---

## 🔐 Private/Custom Skills

### Alongside Public Skills

You can mix public and private skills:

```
~/.claude/skills/
├── developers-toolkit/              # Public skills (this repo)
│   └── skills/
│       ├── security-fix/
│       └── security-audit/
└── my-company-skills/          # Your private skills
    ├── internal-api-skill/
    └── company-workflow-skill/
```

All skills in `~/.claude/skills/` are available to Claude.

### Private Repository

Fork this repository as private if you need to keep your customizations confidential.
1. Go to repository settings on GitHub
2. Change visibility to Private
3. Clone with authentication

---

## 📊 Installation Verification Checklist

After installation, verify:

- [ ] Repository cloned to `~/.claude/skills/developers-toolkit/`
- [ ] SKILL.md files exist for each skill
- [ ] YAML frontmatter is valid in SKILL.md files
- [ ] Claude Code recognizes skills (test activation)
- [ ] Skills load automatically with trigger phrases
- [ ] Reference files are accessible
- [ ] No permission errors

If all checkmarks pass, you're ready to use the skills! ✅

---

## 📞 Getting Help

### Documentation
- [Skill Development Guide](skill-development-guide.md)
- [Best Practices](best-practices.md)
- [Repository README](../README.md)

### Community
- [GitHub Issues](https://github.com/bhattaganesh/developers-toolkit/issues) - Questions and Bug reports
- [Contributing Guide](../CONTRIBUTING.md) - How to contribute

---

## 🎓 Next Steps

1. **Try the skills** - Fix a security issue or run an audit
2. **Read skill documentation** - Each skill has a README
3. **Customize if needed** - Fork and modify for your needs
4. **Contribute** - Share improvements back to the community
5. **Stay updated** - `git pull` regularly for new skills

---

**Happy coding! 🚀**
