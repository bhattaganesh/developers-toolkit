#!/bin/bash
# Stop hook: Auto-detect and run project's test suite
# Runs when Claude finishes responding — provides automatic verification
# Install: Copy to project, configure in .claude/settings.json

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR"

# Detect and run the appropriate test suite
if [ -f "vendor/bin/phpunit" ]; then
    echo "Running PHPUnit tests..."
    ./vendor/bin/phpunit --stop-on-failure 2>&1 || true

elif [ -f "vendor/bin/pest" ]; then
    echo "Running Pest tests..."
    ./vendor/bin/pest --stop-on-failure 2>&1 || true

elif [ -f "node_modules/.bin/jest" ]; then
    echo "Running Jest tests..."
    npx jest --bail 2>&1 || true

elif [ -f "node_modules/.bin/vitest" ]; then
    echo "Running Vitest tests..."
    npx vitest run 2>&1 || true

elif [ -f "package.json" ] && grep -q '"test"' package.json; then
    echo "Running npm test..."
    npm test -- --bail 2>&1 || true

else
    echo "No test runner detected, skipping."
fi
