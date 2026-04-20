#!/bin/bash
# Run WordPress Coding Standards check after editing PHP files.
# Requires phpcs with WordPress standard: composer global require wp-coding-standards/wpcs && phpcs --config-set installed_paths ~/.composer/vendor/wp-coding-standards/wpcs

FILE_PATH="${FILE_PATH:-}"

# Only run on PHP files
[[ "$FILE_PATH" == *.php ]] || exit 0

# Only run if phpcs is available
command -v phpcs >/dev/null 2>&1 || exit 0

# Run PHPCS with WordPress standard, limit to summary (first 20 lines to avoid flooding)
RESULT=$(phpcs --standard=WordPress --report=summary "$FILE_PATH" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "⚠ WPCS: $FILE_PATH"
    echo "$RESULT" | head -20
fi

exit 0
