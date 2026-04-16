# SVN Repository Structure & Plugin Assets

After your plugin is approved, WordPress.org gives you an SVN repository to deploy your plugin. This is the only way to get your plugin listed and updated on WordPress.org.

---

## SVN Directory Structure

WordPress.org creates three top-level directories in every plugin's SVN repository:

```
your-plugin-slug/
├── trunk/          ← Development / latest code
├── tags/           ← Versioned releases
│   ├── 1.0.0/
│   ├── 1.0.1/
│   └── 1.1.0/
└── assets/         ← Screenshots, banners, icons (NOT inside trunk)
    ├── banner-772x250.png
    ├── icon-128x128.png
    └── screenshot-1.png
```

### /trunk/
- Contains the **latest working code** of your plugin
- The main plugin file must be **directly in trunk/** — do NOT nest it in a subfolder:
  - ✅ `trunk/my-plugin.php`
  - ❌ `trunk/my-plugin/my-plugin.php` — breaks downloads

### /tags/
- Contains **numbered release snapshots** (immutable versions)
- Tag names must be **version numbers** matching SemVer:
  - ✅ `tags/1.0.0`, `tags/2.1.3`
  - ❌ `tags/stable`, `tags/latest`, `tags/cool-hotness-release`
- Always create tags by **copying from trunk** (not manually creating):
  ```bash
  svn cp https://plugins.svn.wordpress.org/my-plugin/trunk \
         https://plugins.svn.wordpress.org/my-plugin/tags/1.0.0 \
         -m "Tagging version 1.0.0"
  ```
- The `Stable tag` in `trunk/readme.txt` must point to an existing tag

### /assets/
- Contains **visual assets only** — screenshots, banners, icons
- Assets live here at the **top level** (not inside trunk or any tag):
  - ✅ `assets/screenshot-1.png`
  - ❌ `trunk/assets/screenshot-1.png`
  - ❌ `tags/1.0.0/assets/screenshot-1.png`
- Keeping assets outside trunk keeps **plugin download size small** (users don't need screenshots)

---

## First-Time SVN Deployment Steps

```bash
# 1. Check out your repository (given after approval email)
svn co https://plugins.svn.wordpress.org/your-plugin-slug/ /local/path/

# 2. Copy your plugin files into trunk
cp -r /your-plugin/* /local/path/trunk/

# 3. Stage new files
cd /local/path/
svn add trunk/*

# 4. Set MIME types for images (prevents browser downloading instead of displaying)
svn propset svn:mime-type image/png assets/icon-128x128.png
svn propset svn:mime-type image/png assets/banner-772x250.png
svn propset svn:mime-type image/png assets/screenshot-1.png

# 5. Commit trunk
svn ci trunk/ assets/ -m "Initial release of My Plugin 1.0.0"

# 6. Create a version tag (copy from trunk)
svn cp https://plugins.svn.wordpress.org/your-plugin-slug/trunk \
       https://plugins.svn.wordpress.org/your-plugin-slug/tags/1.0.0 \
       -m "Tagging version 1.0.0"

# 7. Update Stable tag in trunk/readme.txt to match your tag
# Edit: Stable tag: 1.0.0
svn ci trunk/readme.txt -m "Update Stable tag to 1.0.0"
```

**Note:** SVN commits can take **up to 6 hours** to rebuild zip files. Plan releases accordingly.

---

## Plugin Assets Requirements

### Banner Images

Shown at the top of the plugin's directory page.

| Type | Dimensions | Format | Max Size |
|---|---|---|---|
| Standard | 772 × 250 px | JPG or PNG | 4 MB |
| Retina (2x) | 1544 × 500 px | JPG or PNG | 4 MB |

**Filenames:**
- `banner-772x250.png` or `banner-772x250.jpg`
- `banner-1544x500.png` or `banner-1544x500.jpg` (retina)
- `banner-772x250-rtl.png` (RTL language variant)

---

### Plugin Icons

Shown in WordPress admin plugin lists and search results.

| Type | Dimensions | Format | Max Size |
|---|---|---|---|
| Standard | 128 × 128 px | PNG, JPG, or GIF | 1 MB |
| Retina (2x) | 256 × 256 px | PNG, JPG, or GIF | 1 MB |
| Vector | Any | SVG | 1 MB |

**Filenames:**
- `icon-128x128.png` (standard)
- `icon-256x256.png` (retina)
- `icon.svg` (vector — must also have a PNG fallback)

**Rules:**
- If using SVG, include a PNG fallback (`icon-128x128.png`) — required
- An auto-generated icon appears if none is provided

---

### Screenshots

Shown in the plugin's "Screenshots" tab on WordPress.org.

| Rule | Requirement |
|---|---|
| Format | JPG or PNG only |
| Max file size | 10 MB per screenshot |
| Naming | Numbered sequentially: `screenshot-1.png`, `screenshot-2.png` |
| Case | All filenames must be lowercase |
| Caption | Each screenshot maps to one line in readme.txt `== Screenshots ==` section |
| Quantity | One image per line in Screenshots section |

**Localized screenshots:** `screenshot-1-de.png` overrides the English version for German locale.

**readme.txt Screenshots section:**
```
== Screenshots ==

1. The main settings page
2. The widget configuration panel
3. Front-end output example
```

---

## Common SVN Mistakes

| Mistake | Why It's a Problem | Fix |
|---|---|---|
| Screenshots in `/trunk/` | Increases download size for all users | Move to `/assets/` |
| Tag names are non-numeric | WordPress.org can't parse version | Use `1.0.0`, `2.1.3` etc. |
| Main file nested in subfolder | Breaks plugin downloads | Put `plugin-name.php` directly in `trunk/` |
| Uploading a .zip file | SVN doesn't handle archives | Copy individual files to trunk/ |
| `Stable tag: trunk` | Not allowed for new plugins | Use actual version: `Stable tag: 1.0.0` |
| Forgetting to tag after committing trunk | Users don't get the new version | Always create a tag after every release |
| Committing node_modules, vendor | Bloats repository and download | Exclude build/dev directories |
| Images without MIME types | Browser downloads instead of displaying | Set `svn:mime-type` on all images |
| Rapid small commits | Each commit rebuilds all zips, strains infrastructure | Batch changes into meaningful commits |

---

## What to Exclude from SVN (and Submission Zip)

These must NOT be committed to SVN or included in the submission zip:

```
.git/
.gitignore
.gitattributes
.DS_Store
node_modules/
vendor/ (full Composer vendor dir)
src/ (if compiled assets exist)
tests/
phpunit.xml
phpunit.xml.dist
.phpcs.xml
.eslintrc
.eslintrc.js
.eslintrc.json
webpack.config.js
Gruntfile.js
gulpfile.js
package.json
package-lock.json
yarn.lock
composer.lock (optional — include if you vendor selectively)
*.log
.env
.env.example
README.md (use readme.txt instead — README.md is not parsed by WordPress.org)
Makefile
```

**Check your zip size:**
```bash
# Create a clean zip excluding dev files
zip -r my-plugin.zip my-plugin/ \
  --exclude "*/.git/*" \
  --exclude "*/node_modules/*" \
  --exclude "*/vendor/*" \
  --exclude "*/.DS_Store" \
  --exclude "*/tests/*" \
  --exclude "*/phpunit*" \
  --exclude "*/package*.json" \
  --exclude "*/.phpcs.xml" \
  --exclude "*/webpack.config.js"

# Check size — must be under 10MB for first submission
du -sh my-plugin.zip
```

---

## SVN vs Git Workflow

Many teams develop in Git and deploy to SVN. Recommended workflow:

```bash
# After merging to main/master in Git:

# 1. Pull latest
git pull origin main

# 2. Export to SVN trunk (sync files)
rsync -av --delete \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='vendor' \
  --exclude='tests' \
  /git/my-plugin/ /svn/my-plugin/trunk/

# 3. Add any new files
cd /svn/my-plugin/
svn status | grep "^?" | awk '{print $2}' | xargs svn add

# 4. Remove deleted files
svn status | grep "^!" | awk '{print $2}' | xargs svn rm

# 5. Commit
svn ci trunk/ -m "Release 1.2.0: add feature X, fix bug Y"

# 6. Tag the release
svn cp trunk tags/1.2.0 -m "Tagging 1.2.0"
```

---

## References

- [Using Subversion](https://developer.wordpress.org/plugins/wordpress-org/how-to-use-subversion/)
- [How Plugin Assets Work](https://developer.wordpress.org/plugins/wordpress-org/plugin-assets/)
- [Plugin Readme.txt](https://developer.wordpress.org/plugins/wordpress-org/how-your-readme-txt-works/)
