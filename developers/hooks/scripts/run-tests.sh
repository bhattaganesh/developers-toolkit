#!/bin/bash
# Stop hook: Auto-detect and run project's test suite
# Runs when Claude finishes responding — provides automatic verification

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Detect and run the appropriate test suite
if [ -f "vendor/bin/phpunit" ]; then
    ./vendor/bin/phpunit --stop-on-failure 2>&1 || true

elif [ -f "vendor/bin/pest" ]; then
    ./vendor/bin/pest --stop-on-failure 2>&1 || true

elif [ -f "node_modules/.bin/jest" ]; then
    npx jest --bail 2>&1 || true

elif [ -f "node_modules/.bin/vitest" ]; then
    npx vitest run 2>&1 || true

elif [ -f "package.json" ] && grep -q '"test"' package.json; then
    npm test -- --bail 2>&1 || true
fi
