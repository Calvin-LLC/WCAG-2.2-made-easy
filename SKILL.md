---
name: wcag
description: >
  Fix and verify web accessibility against WCAG 2.2 Level A and AA.
  Owns fix-time rules for HTML, CSS, and JS, copy-paste patterns, checklists,
  and real browser verification through the Orca embedded browser (accessibility
  tree, keyboard walk, computed contrast, targets, reflow). Use when writing or
  reviewing user-facing code, or when asked to check accessibility. Reports only.
  Never claims conformance from source inspection alone.
license: MIT
metadata:
  version: "2.0.0"
---

# WCAG

You make user-facing code accessible. You check real rendered pages in a real
browser. You never claim conformance from reading source alone.

Read `AGENTS.md` first. It names the references, the scripts, and the rules
that keep this skill small. Load a reference only when the task needs it.

## What this skill covers

Fix-time accessibility for web UI. HTML structure, CSS presentation, JS
interaction, plus checklists for dev, design, and QA. Browser verification
runs through the Orca embedded browser. Static checks are the floor, the
browser is the proof.

This skill does not do security, supply chain, reliability, or test audits.
That is the harden skill. If a `harden` report hands you an a11y finding,
start from its file and line evidence and verify in the browser.

## Facts that stay true

WCAG 2.2 has 86 success criteria. Level A plus AA is 55. Parsing (4.1.1) was
removed in 2.2, so never reference it.

Contrast minimums: 4.5 to 1 for normal text, 3 to 1 for large text (18px or
14px bold and up) and for UI components. Targets are 24 by 24 CSS px minimum.

`px` for font size is fine. Browsers zoom `px`. Clipping at zoom is the real
failure. Multiple `h1` elements are fine. These two are not findings.

## Run it

```
wcag check <url>
wcag check <url> --profile mobile
wcag rules <path/to/file>
```

`wcag check` opens the URL in the Orca browser and runs the verification
runbook in `scripts/a11y-check.sh`. `wcag rules` prints the fix-time rules
for one file type without opening a browser.

## Pipeline

```
scope -> static rules -> browser verification -> report
```

### 1. Static rules

Pick the references the changed files need. Nothing else loads.

| Changed files | Reference |
|---------------|-----------|
| HTML, JSX, TSX, Vue, Svelte, templates | `references/wcag-html.md` |
| CSS, SCSS, Less | `references/wcag-css.md` |
| JS, TS, components with behavior | `references/wcag-js.md` |
| Need a fix example | `references/patterns.md` |
| Pre-commit, design review, QA signoff | `references/checklists.md` |

`references/wcag-core.md` always loads. It holds the anti-patterns to block
and the thresholds. Keep additions to the file-type references instead, so
the baseline stays small.

### 2. Browser verification

Run `scripts/a11y-check.sh <url>`. It drives the Orca browser: snapshot the
accessibility tree, walk focus with the keyboard, measure computed contrast
and target sizes, check reflow and zoom. It prints JSON and exits non-zero
on violations.

The runbook paces Orca calls with short sleeps and one retry. The runtime
drops connections under rapid calls and recovers on its own.

Segment results by check:

- **tree:** roles and accessible names from the snapshot. Every interactive
  node needs a name. Flag nameless controls with their ref and snippet.
- **keyboard:** Tab order recorded through focus. Flag traps, skipped
  controls, and focus that is not visible.
- **contrast:** computed ratios from rendered styles, not source guesses.
  Flag text below 4.5 to 1 (3 to 1 large) and components below 3 to 1.
- **targets:** measured boxes. Flag interactive targets below 24 by 24 CSS
  px, noting the documented exceptions for inline links.
- **reflow:** 320 CSS px width and 200 percent zoom. Flag horizontal scroll
  and clipped content.
- **axe:** only if `scripts/axe-core.min.js` is present. Axe is one layer,
  not the verdict. Manual eval checks above it stand on their own.

Mark each result `browser-verified` or `needs-manual`. Screen reader passes
and real-device touch testing stay manual. Say so in the report.

### 3. Report

```markdown
# Accessibility report: [URL or path]

## Result
[pass | issues found | needs-manual]

## Browser checks
| Check | Result | Evidence |
|-------|--------|----------|
| tree | | |
| keyboard | | |
| contrast | | |
| targets | | |
| reflow | | |
| axe | | skipped or version |

## Issues
Ordered by severity. Each one: criterion, file or node, what fails,
smallest fix, and the pattern reference.

## Manual follow-ups
[screen reader pass, device touch, anything the browser could not settle]
```

Static assessment plus this report is still not a conformance claim. Say
that on web projects: manual conformance verification remains required.

## Fixes (not part of this run)

This skill reports. It does not edit the target repo. A follow-up that names
issue IDs may apply one fix per commit, each ending in a browser re-check.
