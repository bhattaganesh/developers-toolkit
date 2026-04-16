#!/bin/bash
# Generate missing feature tests for WordPress features
# Usage: ./generate-tests.sh [directory]
# Example: ./generate-tests.sh app/Http/Controllers
# Example: ./generate-tests.sh app/Http/Controllers/Api

set -euo pipefail

CONTROLLER_DIR="${1:-app/Http/Controllers}"
MAX_BUDGET="${TEST_GEN_BUDGET:-2.00}"
MODEL="${TEST_GEN_MODEL:-sonnet}"

echo "Scanning controllers in $CONTROLLER_DIR for missing tests (model: $MODEL, budget: \$$MAX_BUDGET)"

# Find controllers without corresponding test files
find "$CONTROLLER_DIR" -name "*Controller.php" | while read -r controller; do
    # Derive expected test path
    test_file=$(echo "$controller" | sed 's|app/Http/Controllers|tests/Feature|' | sed 's|\.php$|Test.php|')

    if [ ! -f "$test_file" ]; then
        echo "Missing test: $controller -> $test_file"

        claude -p "Generate a feature test for this WordPress feature. Follow existing test patterns in the project. Cover: success case, validation errors, auth/unauthorized, edge cases. Use factories for test data. File: $controller" \
            --model "$MODEL" \
            --max-budget-usd "$MAX_BUDGET" \
            --allowedTools Read,Write,Glob,Grep \
            --output-format text 2>&1 || true
        echo "---"
    else
        echo "Test exists: $test_file"
    fi
done

echo "Test generation complete."
