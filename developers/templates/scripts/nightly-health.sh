#!/bin/bash
# Nightly health check — security + coverage gaps + tech debt
# Usage: ./nightly-health.sh [directory]
# Recommended: Run via cron at midnight
# Example cron: 0 0 * * * cd /path/to/project && ./nightly-health.sh

set -euo pipefail

PROJECT_DIR="${1:-.}"
MAX_BUDGET="${HEALTH_BUDGET:-5.00}"
MODEL="${HEALTH_MODEL:-haiku}"
OUTPUT_DIR="${HEALTH_OUTPUT_DIR:-/tmp/health-$(date +%Y%m%d)}"

mkdir -p "$OUTPUT_DIR"

echo "=== Nightly Health Check ==="
echo "Project: $PROJECT_DIR"
echo "Date: $(date)"
echo "Model: $MODEL | Budget: \$$MAX_BUDGET"
echo "Output: $OUTPUT_DIR"
echo ""

# --- Step 1: Security Scan ---
echo "[1/3] Security scan..."
claude -p "Run a security audit on this codebase. Check for:
- SQL injection, XSS, CSRF vulnerabilities
- Hardcoded secrets or API keys
- Missing auth middleware on routes
- Unsanitized user input
- Missing nonce verification (WordPress)
- Missing capability checks (WordPress)

Output a concise report to: $OUTPUT_DIR/security.md" \
    --model "$MODEL" \
    --max-budget-usd "$MAX_BUDGET" \
    --allowedTools Read,Glob,Grep,Write \
    --output-format text 2>&1 || echo "Security scan failed"

# --- Step 2: Test Coverage Gaps ---
echo "[2/3] Test coverage gaps..."
claude -p "Find test coverage gaps in this project. For each controller, service, and model:
- Check if a corresponding test file exists
- Check if tests cover success, error, and edge cases
- Flag untested public methods

Output a concise report to: $OUTPUT_DIR/coverage-gaps.md" \
    --model "$MODEL" \
    --max-budget-usd "$MAX_BUDGET" \
    --allowedTools Read,Glob,Grep,Write \
    --output-format text 2>&1 || echo "Coverage gap scan failed"

# --- Step 3: Tech Debt ---
echo "[3/3] Tech debt scan..."
claude -p "Find tech debt in this codebase:
- TODO/FIXME/HACK comments
- Duplicated code patterns
- Files over 500 lines
- Dead code (unused functions/imports)

Output a concise report to: $OUTPUT_DIR/techdebt.md" \
    --model "$MODEL" \
    --max-budget-usd "$MAX_BUDGET" \
    --allowedTools Read,Glob,Grep,Write \
    --output-format text 2>&1 || echo "Tech debt scan failed"

# --- Summary ---
echo ""
echo "=== Health Check Complete ==="
echo "Reports saved to: $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR"/*.md 2>/dev/null || echo "No reports generated"
