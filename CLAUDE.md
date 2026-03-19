# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

A portable WCAG 2.2 accessibility toolkit for Claude Code. Users copy the `.claude/` folder into their web projects to get automatic Level A + AA enforcement. This is not a web application -- it is a Claude Code configuration package.

## Architecture

The toolkit uses a **token-optimized, path-scoped** architecture:

- **`rules/wcag-core.md`** (no paths frontmatter) -- always loaded. Contains anti-patterns to block, key thresholds (contrast ratios, target sizes), and the full criteria reference list. Keep this minimal since it loads into every conversation.
- **`rules/wcag-html.md`**, **`wcag-css.md`**, **`wcag-js.md`** -- path-scoped rules that only load when Claude opens matching file types (e.g., HTML rules don't load when editing CSS). This is the primary token savings mechanism.
- **`hooks/wcag-check.sh`** -- PostToolUse hook that runs after every Edit/Write. Validates the written file with grep-based checks and returns `{"decision":"block"}` JSON to Claude on violations. Uses `$CLAUDE_PROJECT_DIR` for path traversal protection.
- **`skills/accessibility-patterns/`** -- on-demand patterns (zero baseline cost). Only loaded when the skill is invoked.
- **`agents/accessibility-reviewer.md`** -- WCAG 2.2 review agent with POUR workflow checklist. Contains no code examples (those are in rules and skills).
- **`checklists/`** -- developer, design, and QA references. Static content, not loaded as rules.

## Key Design Decisions

- **One canonical location per pattern**: each code pattern exists in exactly one file. The rules reference what to enforce; the skill contains the copy-paste examples.
- **Anti-pattern-first rules**: Claude already knows accessible HTML/CSS/JS. Rules focus on what to BLOCK and what THRESHOLDS to enforce, not tutorials.
- **WCAG 2.2 only**: the Parsing criterion (4.1.1) was removed in WCAG 2.2. Do not reference it anywhere. 55 criteria total (31 A + 24 AA).

## Testing

```bash
# Run automated accessibility tests against a URL (requires Node.js)
cd .claude/tests && npm install && node accessibility-tests.js http://your-site.com

# Validate hook script syntax
bash -n .claude/hooks/wcag-check.sh

# Test the hook manually with a violating file
echo '<html><body><img src="x.png"></body></html>' > /tmp/test.html
echo '{"file_path":"/tmp/test.html"}' | bash .claude/hooks/wcag-check.sh
# Expected: JSON with decision:"block" for missing lang and alt
```

## When Modifying This Toolkit

- Adding a new rule to `wcag-core.md` increases baseline token cost for ALL conversations. Prefer adding to the path-scoped files instead.
- The hook script (`wcag-check.sh`) must use POSIX-compatible grep (no `grep -P`). It runs on Windows (Git Bash), macOS, and Linux.
- The hook reads `$CLAUDE_PROJECT_DIR` to restrict file access to the project root. If this env var is unset, the path check is skipped.
- `settings.json` configures the PostToolUse hook. The `matcher: "Edit|Write"` means it runs after both Edit and Write tool calls.
- Keep the criteria reference lists in `wcag-core.md` in sync when modifying coverage. Run: `grep -r "CRITERION_NUMBER" .claude/rules/` to verify coverage.
