#!/usr/bin/env bash
# WCAG 2.2 automated check -- runs after Edit/Write via PostToolUse hook.
# Reads tool_input from stdin (JSON with file_path and content fields).
# Exits 0 with JSON output. decision: "block" if violations found.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# If no file_path in input, try tool_input.file_path format
if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"tool_input".*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
fi

# Exit silently if we can't determine the file
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Security: validate file path stays within the project directory
if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
    REAL_FILE=$(realpath "$FILE_PATH" 2>/dev/null) || exit 0
    REAL_PROJ=$(realpath "$CLAUDE_PROJECT_DIR" 2>/dev/null) || exit 0
    case "$REAL_FILE" in
        "$REAL_PROJ"/*) ;;  # OK -- inside project
        *) exit 0 ;;       # Outside project root -- refuse
    esac
fi

# Read actual file content if it exists
if [ -f "$FILE_PATH" ]; then
    FILE_CONTENT=$(cat "$FILE_PATH")
else
    exit 0
fi

VIOLATIONS=""
EXT="${FILE_PATH##*.}"

check_html() {
    # Missing lang on <html>
    if echo "$FILE_CONTENT" | grep -qi '<html' && ! echo "$FILE_CONTENT" | grep -qi '<html[^>]*lang='; then
        VIOLATIONS="${VIOLATIONS}Missing lang attribute on <html> (WCAG 3.1.1). "
    fi

    # <img> without alt -- match complete single-line img tags missing alt=
    if echo "$FILE_CONTENT" | grep -i '<img[^>]*>' | grep -qiv 'alt='; then
        VIOLATIONS="${VIOLATIONS}Found <img> without alt attribute (WCAG 1.1.1). "
    fi

    # Missing <title>
    if echo "$FILE_CONTENT" | grep -qi '<head' && ! echo "$FILE_CONTENT" | grep -qi '<title>'; then
        VIOLATIONS="${VIOLATIONS}Missing <title> element (WCAG 2.4.2). "
    fi

    # <div onclick> or <span onclick>
    if echo "$FILE_CONTENT" | grep -qi '<div[^>]*onclick\|<span[^>]*onclick'; then
        VIOLATIONS="${VIOLATIONS}Found div/span with onclick -- use button instead (WCAG 2.1.1). "
    fi

    # Inline outline:none
    if echo "$FILE_CONTENT" | grep -qi 'style="[^"]*outline:[[:space:]]*none'; then
        VIOLATIONS="${VIOLATIONS}Found inline outline:none -- focus must be visible (WCAG 2.4.7). "
    fi
}

check_css() {
    # outline: none/0/0px/0em/0rem without focus-visible replacement
    if echo "$FILE_CONTENT" | grep -qiE 'outline:\s*(none|0([^.0-9]|$))' && ! echo "$FILE_CONTENT" | grep -qi ':focus-visible'; then
        VIOLATIONS="${VIOLATIONS}Found outline:none/0 without :focus-visible replacement (WCAG 2.4.7). "
    fi

    # Fixed px on font-size
    if echo "$FILE_CONTENT" | grep -qi 'font-size:[[:space:]]*[0-9][0-9]*px'; then
        VIOLATIONS="${VIOLATIONS}Found font-size in px -- use rem/em instead (WCAG 1.4.4). "
    fi
}

check_js() {
    # pointerdown for actions
    if echo "$FILE_CONTENT" | grep -qi "addEventListener.*pointerdown"; then
        VIOLATIONS="${VIOLATIONS}Found pointerdown event listener -- use click/pointerup (WCAG 2.5.2). "
    fi
}

case "$EXT" in
    html|htm|php|erb|hbs|ejs|njk)
        check_html
        ;;
    jsx|tsx|vue|svelte|astro)
        check_html
        ;;
    css|scss|less|sass)
        check_css
        ;;
    js|mjs|cjs|ts)
        check_js
        ;;
esac

if [ -n "$VIOLATIONS" ]; then
    # Escape double quotes in violations to produce valid JSON
    SAFE_VIOLATIONS=$(echo "$VIOLATIONS" | sed 's/"/\\"/g')
    printf '{"decision":"block","reason":"WCAG violations detected","additionalContext":"%s"}\n' "$SAFE_VIOLATIONS"
    exit 0
fi

exit 0
