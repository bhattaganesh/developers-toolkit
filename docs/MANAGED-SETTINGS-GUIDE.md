

# Managed Settings Guide (Centralized Deployment)

This guide explains how to deploy the Developers plugin using **Claude Code Managed Settings** to enforce project-wide policies across multiple machines or environments.

---

## What are Managed Settings?

**Managed Settings** are system-level configurations that:
- Have **highest precedence** — cannot be overridden by users or projects
- Are deployed to protected system directories
- Enforce project-wide standards across all Claude Code sessions
- Control which plugins, MCP servers, and commands are allowed

---

## Quick Start

### 1. Copy the Template

```bash
# Copy the managed settings template
cp developers/templates/managed-settings.json /tmp/managed-settings.json

# Customize for your setup
# Edit /tmp/managed-settings.json
```

### 2. Deploy to System Directory

**macOS:**
```bash
sudo mkdir -p "/Library/Application Support/ClaudeCode"
sudo cp /tmp/managed-settings.json "/Library/Application Support/ClaudeCode/managed-settings.json"
sudo chmod 644 "/Library/Application Support/ClaudeCode/managed-settings.json"
```

**Linux/WSL:**
```bash
sudo mkdir -p /etc/claude-code
sudo cp /tmp/managed-settings.json /etc/claude-code/managed-settings.json
sudo chmod 644 /etc/claude-code/managed-settings.json
```

**Windows (PowerShell as Administrator):**
```powershell
New-Item -Path "C:\Program Files\ClaudeCode" -ItemType Directory -Force
Copy-Item -Path "C:\temp\managed-settings.json" -Destination "C:\Program Files\ClaudeCode\managed-settings.json"
```

### 3. Verify Deployment

Users should see:
- Developers marketplace available
- Announcements displayed in Claude Code
- Permission rules enforced (e.g., `.env` files blocked)

---

## Configuration Levels

### Level 1: Recommended Marketplace Only

**Use Case:** Allow Developers plugin but permit other marketplaces

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "bhattaganesh/developers-toolkit",
      "ref": "main"
    }
  ],
  "allowManagedPermissionRulesOnly": false
}
```

### Level 2: Mandatory Marketplace (Lockdown)

**Use Case:** Only allow Developers marketplace, block all others

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "bhattaganesh/developers-toolkit",
      "ref": "main"
    }
  ],
  "allowManagedPermissionRulesOnly": true,
  "allowManagedHooksOnly": true
}
```

### Level 3: Complete Lockdown

**Use Case:** Enforce everything, disable bypass mode, strict permissions

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "bhattaganesh/developers-toolkit",
      "ref": "main"
    }
  ],
  "allowManagedPermissionRulesOnly": true,
  "allowManagedHooksOnly": true,
  "disableBypassPermissionsMode": "disable",
  "permissions": {
    "deny": [
      "Read(./.env*)",
      "Read(./secrets/**)",
      "Bash(rm -rf *)",
      "Bash(curl *)",
      "Bash(wp db reset)"
    ]
  }
}
```

### Level 4: Custom Internal Marketplace

**Use Case:** Fork the plugin, host internally, enforce internal version

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "your-username/developers-toolkit-custom",
      "ref": "v2.0-internal"
    }
  ]
}
```

---

## Security Policies

### Block Sensitive File Access

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.aws/**)",
      "Read(~/.ssh/id_*)",
      "Read(.envrc)"
    ]
  }
}
```

### Block Destructive Commands

```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf *)",
      "Bash(wp db reset)",
      "Bash(wp db drop)",
      "Bash(DROP TABLE *)",
      "Bash(drop database *)",
      "Bash(git push * --force)",
      "Bash(curl *)",
      "Bash(wget *)"
    ]
  }
}
```

### Prompt for Risky Operations

```json
{
  "permissions": {
    "ask": [
      "Bash(git push *)",
      "Bash(npm publish)",
      "Bash(docker *)",
      "Write(.github/workflows/*)"
    ]
  }
}
```

### Allow Safe Development Commands

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint*)",
      "Bash(npm run test*)",
      "Bash(composer test)",
      "Bash(./vendor/bin/phpunit*)",
      "Bash(php wp-cli test*)",
      "Bash(git status)",
      "Bash(git diff *)"
    ]
  }
}
```

---

## MCP Server Control

### Allow Only Approved MCP Servers

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverName": "git" },
    { "serverName": "brave-search" },
    { "serverName": "memory" }
  ],
  "deniedMcpServers": [
    { "serverName": "filesystem" }
  ]
}
```

---

## Model Restrictions

### Enforce Specific Models

```json
{
  "model": "claude-sonnet-4-5-20250929",
  "availableModels": ["sonnet", "haiku"]
}
```

**Effect:** Users can only use Sonnet 4.5 or Haiku, Opus disabled

---

## User Announcements

Display messages to all sessions when Claude Code starts:

```json
{
  "companyAnnouncements": [
    "Developers plugin installed - use /developers:code-review before PRs",
    "Security reminder: Run /developers:security-check on user input handlers",
    "New standard: All API endpoints require feature tests"
  ]
}
```

---

## Deployment Strategies

### Strategy 1: Configuration Management

Deploy via:
- **Jamf Pro** (macOS)
- **Intune** (Windows)
- **Ansible/Chef/Puppet** (Linux)
- **Group Capability** (Windows AD)

**Example Ansible Playbook:**
```yaml
- name: Deploy Developers Managed Settings
  hosts: all_developers
  become: yes
  tasks:
    - name: Create Claude Code config directory
      file:
        path: /etc/claude-code
        state: directory
        mode: '0755'

    - name: Deploy managed settings
      copy:
        src: files/managed-settings.json
        dest: /etc/claude-code/managed-settings.json
        mode: '0644'
```

### Strategy 2: Git Repository Distribution

1. Fork bhattaganesh/developers-toolkit
2. Customize for your needs
3. Deploy managed-settings.json pointing to your fork
4. Control updates via git tags

### Strategy 3: Shared Network Drive

For teams with shared network storage:

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "file",
      "path": "/mnt/shared/claude/marketplace.json"
    }
  ]
}
```

---

## Testing Deployment

### Verify Managed Settings Loaded

1. Users open Claude Code
2. Check for announcements in UI
3. Try blocked command: `curl https://example.com`
   - Should be denied
4. Try reading `.env` file
   - Should be denied
5. Check available marketplaces
   - Should only show Developers

### User Cannot Override

Users should NOT be able to:
- Bypass permission rules (even with `--dangerously-skip-permissions`)
- Add unapproved marketplaces
- Install plugins outside approved marketplace
- Disable managed hooks

---

## Maintenance

### Updating Policies

```bash
# Edit managed settings
sudo vim /etc/claude-code/managed-settings.json

# No restart needed - changes apply on next Claude Code session
```

### Updating Plugin Version

```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "bhattaganesh/developers-toolkit",
      "ref": "v2.1.0"  // Pin to specific version
    }
  ]
}
```

### Monitoring Compliance

Check if users have managed settings:

```bash
# macOS
ls -la "/Library/Application Support/ClaudeCode/managed-settings.json"

# Linux
ls -la /etc/claude-code/managed-settings.json

# Windows (PowerShell)
Get-Item "C:\Program Files\ClaudeCode\managed-settings.json"
```

---

## Troubleshooting

### Settings Not Applied

**Check file permissions:**
```bash
# Should be readable by all users
sudo chmod 644 /etc/claude-code/managed-settings.json
```

**Validate JSON syntax:**
```bash
cat /etc/claude-code/managed-settings.json | jq .
```

### Users Report "Permission Denied"

**Expected behavior** if:
- They try to read `.env` files
- They try to run blocked commands (curl, rm -rf, etc.)
- They try to add unapproved marketplaces

**Verify it's working correctly** by checking managed settings.

### Marketplace Not Showing

**Check:**
1. JSON syntax is valid
2. GitHub repo is accessible
3. `ref` (branch/tag) exists
4. Path is correct (if using subdirectory)

---

## Best Practices

### ✅ Do:
- Pin plugin to specific version tag (e.g., `ref: "v1.0.0"`)
- Test managed settings locally first
- Document custom policies for yourself or your team
- Review and update policies periodically
- Include contact info in announcements if applicable

### ❌ Don't:
- Deploy without testing locally
- Block all commands (will prevent development)
- Use `"strictKnownMarketplaces": []` without planning (complete lockdown)
- Forget to communicate changes to other users if sharing the machine
- Deploy during active work hours (may interrupt sessions)

---

## Migration from User Installation

If developers already have the plugin installed at **user** or **project** scope:

**Managed settings take precedence** — no migration needed. Their existing installations continue working, managed policies layer on top.

**Optional cleanup:**
```bash
# Users can remove redundant user-scope installation
# (managed version will be used instead)
/plugin remove developers --scope user
```

---

## Support

**For Administrators:**
- Review [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings)
- Check `managed-settings.json` template in `developers/templates/`
- Contact: developers@bhattaganesh.com

**For Developers:**
- Ask about managed policies on your system
- Announcements shown in Claude Code contain specific guidance
- Cannot override managed settings (working as designed)

---

## Example: Full Enterprise Configuration

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "bhattaganesh/developers-toolkit",
      "ref": "main"
    }
  ],

  "permissions": {
    "allow": [
      "Bash(npm run lint*)",
      "Bash(npm run test*)",
      "Bash(composer test)",
      "Bash(./vendor/bin/phpunit*)",
      "Bash(php wp-cli test*)",
      "Bash(git status)",
      "Bash(git diff *)"
    ],
    "deny": [
      "Read(./.env*)",
      "Read(./secrets/**)",
      "Bash(rm -rf *)",
      "Bash(git push * --force)"
    ]
  },

  "companyAnnouncements": [
    "Developers plugin installed - use /developers:code-review before PRs",
    "Questions? Open an issue on GitHub"
  ],

  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1"
  }
}
```

---

**Next Steps:**
1. Copy and customize `developers/templates/managed-settings.json`
2. Test locally
3. Deploy to production machines
4. Monitor adoption and gather feedback
5. Iterate on policies based on project needs


