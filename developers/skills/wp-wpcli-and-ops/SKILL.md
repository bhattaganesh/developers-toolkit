---
name: wp-wpcli-and-ops
description: >
  This skill should be used when the user asks to "run WP-CLI", "do a WordPress database migration",
  "search and replace URLs in WordPress", "export or import the WordPress database", "manage WordPress
  cron jobs", "bulk update plugins via command line", "manage WordPress multisite via CLI", "reset a
  WordPress install", "flush WordPress cache", "regenerate thumbnails", or needs to perform any
  WordPress operational task using wp-cli commands.
version: 1.0.0
tools: Read, Bash, Glob, Grep
---

# WordPress WP-CLI Operations

WP-CLI commands for WordPress operational tasks. High-stakes — one wrong flag can destroy data. This skill enforces mandatory safety checks before any destructive operation.

## Mandatory Safety Protocol

Run these 3 checks before ANY destructive command (search-replace, db import, reset, flush):

### Check 1 — Confirm Environment

```bash
wp config get DB_NAME        # Is this the right database?
wp config get DB_HOST        # Is this local, staging, or production?
wp option get siteurl        # Is this the right site?
```

**Stop if uncertain.** Ask the user to confirm.

### Check 2 — Create Backup

```bash
wp db export backup-$(date +%Y%m%d-%H%M%S).sql
```

Store backup outside the web root or confirm user has a recent backup before proceeding.

### Check 3 — Dry Run First

Always use `--dry-run` when the command supports it. Review output before removing the flag.

---

## Common Operations

### Search and Replace (Domain Migration)

```bash
# Step 1: Dry run (shows what would change)
wp search-replace 'https://old-domain.com' 'https://new-domain.com' \
    --dry-run \
    --report-changed-only \
    --precise

# Step 2: Review the output — expected tables: wp_options, wp_posts, wp_postmeta

# Step 3: If output looks correct, run for real
wp search-replace 'https://old-domain.com' 'https://new-domain.com' \
    --report-changed-only \
    --precise

# Step 4: Flush rewrite rules and caches
wp rewrite flush
wp cache flush
```

**`--precise`** uses PHP serialization-aware replacement — handles serialized data in `wp_options`. Always use it.

**Multisite:** Add `--url=https://subsite.example.com` to target a specific subsite, or `--network` to apply to all sites.

### Database Export / Import

```bash
# Export
wp db export production-backup-$(date +%Y%m%d).sql

# Export with compression
wp db export - | gzip > backup.sql.gz

# Import
wp db import backup.sql

# Check DB size
wp db size

# Repair tables
wp db repair

# Optimize tables
wp db optimize
```

### WordPress Core

```bash
# Check version
wp core version

# Download and install
wp core download --version=6.9
wp core install \
    --url=https://example.com \
    --title="My Site" \
    --admin_user=admin \
    --admin_email=admin@example.com \
    --admin_password=STRONG_PASSWORD

# Update
wp core update
wp core update-db

# Check for updates
wp core check-update
```

### Plugins

```bash
# List all plugins with status
wp plugin list

# Install and activate
wp plugin install woocommerce --activate

# Deactivate and delete
wp plugin deactivate my-plugin
wp plugin delete my-plugin

# Update all plugins
wp plugin update --all

# Check for updates
wp plugin list --update=available

# Activate all
wp plugin activate --all
```

### Themes

```bash
wp theme list
wp theme install twentytwentyfive --activate
wp theme activate my-theme
wp theme delete old-theme
wp theme update --all
```

### Users

```bash
# List users
wp user list --fields=ID,user_login,user_email,roles

# Create user
wp user create john john@example.com \
    --role=editor \
    --user_pass=STRONG_PASSWORD

# Update user role
wp user set-role 5 administrator

# Reset password
wp user update 5 --user_pass=NEW_PASSWORD

# Delete user (reassign posts to user ID 1)
wp user delete 5 --reassign=1
```

### Cache

```bash
# Flush object cache
wp cache flush

# Transients
wp transient delete --all
wp transient delete my_specific_transient

# Rewrite rules
wp rewrite flush
wp rewrite list
```

### Posts and Content

```bash
# Generate test content
wp post generate --count=50 --post_type=post

# Delete all posts of a type
wp post delete $(wp post list --post_type=page --format=ids) --force

# Regenerate thumbnails
wp media regenerate --yes

# Import media
wp media import /path/to/image.jpg --title="Image Title"
```

### Options

```bash
# Get/set options
wp option get siteurl
wp option update blogname "My New Site Name"
wp option delete my_plugin_setting

# List all autoloaded options (watch for bloat)
wp option list --autoload=yes --format=table | head -50

# Check autoloaded option size
wp option list --autoload=yes --fields=option_name,option_value | \
    awk '{sum += length($2)} END {print sum/1024 " KB autoloaded"}'
```

### Cron

```bash
# List all scheduled events
wp cron event list

# Run a specific cron event manually
wp cron event run my_custom_cron_hook

# Delete a scheduled event
wp cron event delete my_custom_cron_hook

# List schedules
wp cron schedule list

# Test cron (runs due events)
wp cron test
```

### Multisite Operations

**Always specify `--url=` for site-specific operations:**

```bash
# List all sites in network
wp site list

# Run command on specific subsite
wp option get siteurl --url=https://subsite.example.com
wp plugin activate my-plugin --url=https://subsite.example.com

# Activate plugin network-wide
wp plugin activate my-plugin --network

# Run command on all network sites
wp site list --field=url | xargs -I {} wp cron event run my_hook --url={}

# Create new subsite
wp site create --slug=newsite --title="New Site" --email=admin@example.com
```

### wp-cli.yml (Project Defaults)

Create `wp-cli.yml` in project root to avoid repetitive flags:

```yaml
path: /var/www/html/wordpress
url: https://example.com
require:
  - vendor/autoload.php
apache_modules:
  - mod_rewrite

# Aliases for different environments
@staging:
  path: /var/www/staging/wordpress
  url: https://staging.example.com

@production:
  ssh: deploy@prod-server.com/var/www/html/wordpress
  url: https://example.com
```

Use alias: `wp @staging option get siteurl`

## Error Recovery

```bash
# Plugin causing white screen — deactivate all via CLI
wp plugin deactivate --all

# Theme error — switch to default
wp theme activate twentytwentyfive

# Admin password locked out
wp user update 1 --user_pass=RECOVERY_PASSWORD

# Fix file permissions
find . -type f -name "*.php" -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
wp-content/uploads/ must be writable: chmod 755 wp-content/uploads
```
