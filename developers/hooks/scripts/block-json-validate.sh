#!/bin/bash
# Validate block.json after editing — check for apiVersion and required fields.

FILE_PATH="${FILE_PATH:-}"

# Only run on block.json files
[[ "$FILE_PATH" == *block.json ]] || exit 0

# Check if python3 is available for JSON parsing
command -v python3 >/dev/null 2>&1 || exit 0

python3 - "$FILE_PATH" <<'PYTHON'
import json, sys

file_path = sys.argv[1]

try:
    with open(file_path, 'r') as f:
        d = json.load(f)
except (json.JSONDecodeError, FileNotFoundError) as e:
    print(f"⚠ block.json: Invalid JSON — {e}")
    sys.exit(0)

warnings = []

# Check apiVersion
api_version = d.get('apiVersion', 0)
if api_version < 3:
    warnings.append(f"apiVersion is {api_version} — use 3 for WP 6.9+ iframe editor compatibility")

# Check required fields
for field in ['name', 'title']:
    if not d.get(field):
        warnings.append(f"missing required field: '{field}'")

# Check viewScript vs viewScriptModule for interactivity
if d.get('viewScript') and d.get('supports', {}).get('interactivity'):
    warnings.append("uses 'viewScript' with interactivity support — use 'viewScriptModule' instead (ES module required)")

# Check name format
name = d.get('name', '')
if name and '/' not in name:
    warnings.append(f"block name '{name}' should use namespace/block-name format (e.g., my-plugin/my-block)")

if warnings:
    print(f"⚠ block.json validation:")
    for w in warnings:
        print(f"  • {w}")

PYTHON

exit 0
