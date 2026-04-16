# Packaging Exclusions Reference

> Comprehensive guide to excluding internal docs from release artifacts
> For use with the dev-docs skill

## Why Exclusion Matters

**Internal docs must NEVER ship in production releases:**

- **Security:** May contain sensitive architecture details
- **Size:** Unnecessary bloat in production artifacts
- **Professionalism:** Users shouldn't see internal development docs
- **Compliance:** Some organizations require internal docs to remain internal

**Goal:** Ensure `internal-docs/` directory is excluded from all release mechanisms.

## Exclusion Methods

### Method 1: .distignore (WordPress.org)

**When to use:** Plugin distributed via WordPress.org

**Location:** Root directory of plugin

**Purpose:** Tells WP.org SVN what NOT to include in the plugin ZIP

**Format:** One pattern per line, similar to .gitignore

**Example .distignore:**

```
# Development files
.git
.github
node_modules
vendor
src
tests

# Build artifacts
*.log
.DS_Store
Thumbs.db

# Documentation
internal-docs/
docs-internal/
.claude/

# Config files
.editorconfig
.eslintrc.js
.prettierrc
phpcs.xml
phpunit.xml
webpack.config.js
composer.json
package.json
package-lock.json

# CI/CD
.github/
.travis.yml
.gitlab-ci.yml
```

**Add internal docs:**

```bash
# Check if .distignore exists
if [ -f .distignore ]; then
  # Add if not already present
  grep -q "internal-docs" .distignore || echo "internal-docs/" >> .distignore
else
  # Create with internal docs
  echo "internal-docs/" > .distignore
fi
```

**Verify:**

```bash
# Check what would be included (if using WP.org deploy tools)
grep "internal-docs" .distignore
```

**Common additions for internal docs:**

```
internal-docs/
docs-internal/
.claude/
scripts/update-internal-docs.sh
CLAUDE.md
AI-INSTRUCTIONS.md
```

---

### Method 2: .gitattributes (Git Archive)

**When to use:** Release created via `git archive` or GitHub releases

**Location:** Root directory of plugin

**Purpose:** Tells Git what to exclude when creating archives

**Format:** Path followed by `export-ignore` attribute

**Example .gitattributes:**

```
# Exclude from git archive / GitHub releases
/.github export-ignore
/.wordpress-org export-ignore
/tests export-ignore
/node_modules export-ignore
/src export-ignore

# Documentation
/internal-docs/ export-ignore
/docs-internal/ export-ignore

# Config files
/.editorconfig export-ignore
/.eslintrc.js export-ignore
/.prettierrc export-ignore
/phpcs.xml export-ignore
/phpunit.xml export-ignore
/webpack.config.js export-ignore
/composer.json export-ignore
/package.json export-ignore
/package-lock.json export-ignore
/composer.lock export-ignore

# CI/CD
/.travis.yml export-ignore
/.gitlab-ci.yml export-ignore

# Build scripts
/Gruntfile.js export-ignore
/gulpfile.js export-ignore
```

**Add internal docs:**

```bash
if [ -f .gitattributes ]; then
  grep -q "internal-docs" .gitattributes || echo "/internal-docs/ export-ignore" >> .gitattributes
else
  echo "/internal-docs/ export-ignore" > .gitattributes
fi
```

**Verify exclusion works:**

```bash
# Create archive
git archive --format=zip --output=/tmp/test.zip HEAD

# Check archive contents
unzip -l /tmp/test.zip | grep internal-docs
# Should return nothing

# Clean up
rm /tmp/test.zip
```

---

### Method 3: Grunt (Build Tool)

**When to use:** Plugin uses Grunt for building/releasing

**Location:** `Gruntfile.js`

**Common Grunt tasks for WordPress:** `grunt-wp-deploy`, `grunt-contrib-copy`, `grunt-contrib-compress`

#### grunt-wp-deploy

**Example configuration:**

```javascript
module.exports = function(grunt) {
  grunt.initConfig({
    wp_deploy: {
      deploy: {
        options: {
          plugin_slug: 'my-plugin',
          svn_user: 'username',
          build_dir: 'build',
          assets_dir: '.wordpress-org'
        }
      }
    },
    copy: {
      main: {
        src: [
          '**',
          '!node_modules/**',
          '!src/**',
          '!tests/**',
          '!internal-docs/**',  // Exclude internal docs
          '!.git/**',
          '!.github/**',
          '!Gruntfile.js',
          '!package.json',
          '!composer.json'
        ],
        dest: 'build/',
        expand: true
      }
    }
  });

  grunt.loadNpmTasks('grunt-wp-deploy');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.registerTask('build', ['copy']);
};
```

**Add exclusion:**

```javascript
// In the copy task's src array, add:
'!internal-docs/**',
'!docs-internal/**',
'!.claude/**'
```

#### grunt-contrib-compress

**Example configuration:**

```javascript
compress: {
  main: {
    options: {
      archive: 'releases/my-plugin.zip'
    },
    files: [
      {
        src: [
          '**',
          '!node_modules/**',
          '!src/**',
          '!tests/**',
          '!internal-docs/**',  // Exclude internal docs
          '!.git/**',
          '!build/**',
          '!releases/**'
        ],
        dest: 'my-plugin/',
        expand: true
      }
    ]
  }
}
```

**Verify:**

```bash
# Build release
grunt compress

# Check ZIP contents
unzip -l releases/my-plugin.zip | grep internal-docs
# Should return nothing
```

---

### Method 4: Gulp (Build Tool)

**When to use:** Plugin uses Gulp for building

**Location:** `gulpfile.js`

**Example configuration:**

```javascript
const gulp = require('gulp');
const zip = require('gulp-zip');
const del = require('del');

// Clean build directory
gulp.task('clean', function() {
  return del(['build/**']);
});

// Copy files to build directory
gulp.task('copy', function() {
  return gulp.src([
    '**/*',
    '!node_modules/**',
    '!src/**',
    '!tests/**',
    '!internal-docs/**',  // Exclude internal docs
    '!docs-internal/**',
    '!.git/**',
    '!.github/**',
    '!build/**',
    '!gulpfile.js',
    '!package.json',
    '!composer.json'
  ])
  .pipe(gulp.dest('build/'));
});

// Create ZIP
gulp.task('zip', function() {
  return gulp.src('build/**/*')
    .pipe(zip('my-plugin.zip'))
    .pipe(gulp.dest('releases/'));
});

// Build task
gulp.task('build', gulp.series('clean', 'copy', 'zip'));
```

**Add exclusion:**

```javascript
// In gulp.src array:
'!internal-docs/**',
'!docs-internal/**',
'!.claude/**'
```

**Verify:**

```bash
gulp build
unzip -l releases/my-plugin.zip | grep internal-docs
```

---

### Method 5: npm Scripts (Custom Build)

**When to use:** Plugin uses custom npm scripts for building

**Location:** `package.json`

**Example configuration:**

```json
{
  "scripts": {
    "build": "npm run build:js && npm run build:css",
    "build:js": "webpack --mode production",
    "build:css": "sass src/scss:assets/css --style compressed",
    "package": "bash scripts/package.sh"
  }
}
```

**Create scripts/package.sh:**

```bash
#!/usr/bin/env bash
# Package plugin for release

set -e

PLUGIN_SLUG="my-plugin"
BUILD_DIR="build"
RELEASE_DIR="releases"

echo "Building release package..."

# Clean build directory
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/$PLUGIN_SLUG

# Copy files (excluding internal docs)
rsync -av \
  --exclude='node_modules' \
  --exclude='src' \
  --exclude='tests' \
  --exclude='internal-docs' \
  --exclude='docs-internal' \
  --exclude='.claude' \
  --exclude='.git' \
  --exclude='.github' \
  --exclude='build' \
  --exclude='releases' \
  --exclude='package.json' \
  --exclude='composer.json' \
  --exclude='webpack.config.js' \
  ./ $BUILD_DIR/$PLUGIN_SLUG/

# Create ZIP
mkdir -p $RELEASE_DIR
cd $BUILD_DIR
zip -r ../$RELEASE_DIR/$PLUGIN_SLUG.zip $PLUGIN_SLUG
cd ..

echo "✓ Package created: $RELEASE_DIR/$PLUGIN_SLUG.zip"

# Verify internal docs are excluded
echo "Verifying internal docs are excluded..."
if unzip -l $RELEASE_DIR/$PLUGIN_SLUG.zip | grep -q "internal-docs"; then
  echo "❌ ERROR: internal-docs found in package!"
  exit 1
else
  echo "✓ Confirmed: internal-docs excluded"
fi
```

**Make executable:**

```bash
chmod +x scripts/package.sh
```

**Verify:**

```bash
npm run package
unzip -l releases/my-plugin.zip | grep internal-docs
```

---

### Method 6: Webpack / Rspack (Frontend Build)

**When to use:** Plugin uses webpack for frontend builds

**Location:** `webpack.config.js`

**Note:** Webpack typically only handles JS/CSS compilation, not plugin packaging. But if webpack is involved in copying files:

**Example with CopyWebpackPlugin:**

```javascript
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  // ... other config
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        {
          from: '**/*',
          to: 'build/',
          globOptions: {
            ignore: [
              '**/node_modules/**',
              '**/src/**',
              '**/tests/**',
              '**/internal-docs/**',  // Exclude internal docs
              '**/docs-internal/**',
              '**/.git/**',
              '**/webpack.config.js'
            ]
          }
        }
      ]
    })
  ]
};
```

---

### Method 7: Composer (PHP Dependencies)

**When to use:** Plugin distributed via Composer/Packagist

**Location:** `composer.json`

**Configuration:**

```json
{
  "name": "vendor/plugin-name",
  "archive": {
    "exclude": [
      "/tests",
      "/internal-docs",
      "/docs-internal",
      "/.claude",
      "/.github",
      "/node_modules",
      "/src",
      "phpunit.xml",
      "phpcs.xml",
      ".gitignore",
      ".gitattributes"
    ]
  }
}
```

**Verify:**

```bash
# Create archive
composer archive --format=zip --dir=releases

# Check contents
unzip -l releases/vendor-plugin-name-version.zip | grep internal-docs
```

---

### Method 8: GitHub Actions (CI/CD)

**When to use:** Automated releases via GitHub Actions

**Location:** `.github/workflows/release.yml`

**Example workflow:**

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Build assets
        run: |
          npm install
          npm run build

      - name: Create release package
        run: |
          mkdir -p build/my-plugin

          # Copy files excluding internal docs
          rsync -av \
            --exclude='node_modules' \
            --exclude='src' \
            --exclude='tests' \
            --exclude='internal-docs' \
            --exclude='docs-internal' \
            --exclude='.claude' \
            --exclude='.git' \
            --exclude='.github' \
            --exclude='build' \
            ./ build/my-plugin/

          # Create ZIP
          cd build
          zip -r ../my-plugin.zip my-plugin

      - name: Verify exclusion
        run: |
          if unzip -l my-plugin.zip | grep -q "internal-docs"; then
            echo "ERROR: internal-docs found in package!"
            exit 1
          fi

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          files: my-plugin.zip
```

---

### Method 9: GitLab CI/CD

**Location:** `.gitlab-ci.yml`

**Example configuration:**

```yaml
stages:
  - build
  - release

build:
  stage: build
  script:
    - npm install
    - npm run build
    - mkdir -p dist/my-plugin
    - rsync -av \
        --exclude='node_modules' \
        --exclude='src' \
        --exclude='tests' \
        --exclude='internal-docs' \
        --exclude='docs-internal' \
        --exclude='.claude' \
        ./ dist/my-plugin/
    - cd dist && zip -r ../my-plugin.zip my-plugin
  artifacts:
    paths:
      - my-plugin.zip

verify-exclusion:
  stage: release
  script:
    - |
      if unzip -l my-plugin.zip | grep -q "internal-docs"; then
        echo "ERROR: internal-docs found in package!"
        exit 1
      fi
  dependencies:
    - build
```

---

### Method 10: WP-CLI wp dist-archive

**When to use:** Using WP-CLI to create plugin archives

**Command:**

```bash
wp dist-archive /path/to/plugin /path/to/output
```

**Uses .distignore automatically** if present in plugin root.

**Verify .distignore includes:**

```
internal-docs/
docs-internal/
.claude/
```

**Run:**

```bash
wp dist-archive . ./releases/
unzip -l releases/plugin-name.zip | grep internal-docs
```

---

## Verification Checklist

After adding exclusions, verify they work:

### 1. Local Build Test

```bash
# Trigger your build/package process
npm run package
# or
grunt build
# or
gulp build
# or
composer archive
```

### 2. Inspect Archive

```bash
# List contents of ZIP
unzip -l path/to/plugin.zip

# Search for internal docs
unzip -l path/to/plugin.zip | grep internal-docs

# Should return nothing
```

### 3. Extract and Check

```bash
# Extract to temp location
unzip path/to/plugin.zip -d /tmp/plugin-test

# Check for internal docs
ls /tmp/plugin-test/my-plugin/internal-docs

# Should not exist
```

### 4. Automated Verification

**Add to build script:**

```bash
#!/bin/bash
# After creating package

PACKAGE="releases/my-plugin.zip"

if unzip -l "$PACKAGE" | grep -q "internal-docs"; then
  echo "❌ ERROR: internal-docs found in $PACKAGE"
  echo "Package contents:"
  unzip -l "$PACKAGE" | grep "internal-docs"
  exit 1
else
  echo "✓ Verified: internal-docs excluded from $PACKAGE"
fi
```

---

## Common Pitfalls

### 1. Forgetting Multiple Release Paths

**Problem:** Excluded from WordPress.org but not GitHub releases

**Solution:** Add exclusions to ALL release mechanisms:
- .distignore (WP.org)
- .gitattributes (Git archives)
- Build scripts (Grunt/Gulp/npm)
- CI/CD workflows (GitHub Actions/GitLab CI)

### 2. Wrong Path Syntax

**Problem:** Exclusion pattern doesn't match

**Examples:**

```bash
# .distignore
internal-docs/      # ✅ Correct
internal-docs       # ✅ Also works
/internal-docs/     # ✅ Also works
internal-docs/**    # ❌ Wrong syntax for .distignore

# .gitattributes
/internal-docs/ export-ignore    # ✅ Correct
internal-docs/ export-ignore     # ✅ Also works
internal-docs export-ignore      # ⚠️ Works but less specific

# Grunt/Gulp
'!internal-docs/**'   # ✅ Correct (negation + glob)
'internal-docs/**'    # ❌ Wrong (would include, not exclude)
```

### 3. Not Testing Exclusion

**Problem:** Assume exclusion works without verifying

**Solution:** Always build and check the artifact locally before releasing

### 4. Partial Exclusion

**Problem:** Exclude `internal-docs/` but not related files

**Solution:** Exclude all internal documentation:
- `internal-docs/`
- `docs-internal/`
- `.claude/`
- `CLAUDE.md`
- `AI-INSTRUCTIONS.md`
- `scripts/update-internal-docs.sh`

### 5. Case Sensitivity

**Problem:** Excluded `Internal-Docs/` but folder is `internal-docs/`

**Solution:** Match exact case of directory names

---

## Quick Reference

### Common Exclusion Patterns

**For .distignore:**
```
internal-docs/
docs-internal/
.claude/
CLAUDE.md
```

**For .gitattributes:**
```
/internal-docs/ export-ignore
/docs-internal/ export-ignore
/.claude/ export-ignore
/CLAUDE.md export-ignore
```

**For Grunt/Gulp:**
```javascript
'!internal-docs/**',
'!docs-internal/**',
'!.claude/**'
```

**For rsync:**
```bash
--exclude='internal-docs' \
--exclude='docs-internal' \
--exclude='.claude'
```

**For ZIP with shell:**
```bash
zip -r package.zip . \
  -x "internal-docs/*" \
  -x "docs-internal/*" \
  -x ".claude/*"
```

---

## Testing Commands

```bash
# Test .distignore (if using wp dist-archive)
wp dist-archive . ./test-release/
unzip -l test-release/*.zip | grep internal-docs

# Test .gitattributes
git archive --format=zip --output=/tmp/test.zip HEAD
unzip -l /tmp/test.zip | grep internal-docs
rm /tmp/test.zip

# Test Grunt
grunt build
unzip -l build/*.zip | grep internal-docs

# Test npm script
npm run package
unzip -l releases/*.zip | grep internal-docs
```

---

## Summary

**Exclusion methods by release type:**

| Release Method | Exclusion File/Config | Verify Command |
|----------------|----------------------|----------------|
| WordPress.org | `.distignore` | `wp dist-archive` |
| GitHub Releases | `.gitattributes` | `git archive` |
| Grunt build | `Gruntfile.js` | `grunt build` |
| Gulp build | `gulpfile.js` | `gulp build` |
| npm script | `package.json` + script | `npm run package` |
| Composer | `composer.json` | `composer archive` |
| GitHub Actions | `.github/workflows/*.yml` | CI run |
| GitLab CI | `.gitlab-ci.yml` | Pipeline run |

**Critical:** Always verify exclusion works by building locally and inspecting the artifact.

**Golden rule:** If you can see it in the final ZIP/package, users will too. Test before releasing!
