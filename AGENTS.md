# wcag

Portable accessibility skill. Front door in `SKILL.md`. References hold the
rules. Scripts drive the Orca browser. Checklists live in one file.

## Layout

```
SKILL.md                 orchestrator: scope, verify, report
AGENTS.md                host instructions for this repo
references/wcag-core.md  always-loaded anti-patterns and thresholds
references/wcag-html.md  structure, forms, media, ARIA
references/wcag-css.md   focus, contrast, targets, reflow, motion
references/wcag-js.md    keyboard, focus management, live regions
references/patterns.md   copy-paste fixes
references/checklists.md dev, design, and QA lists
scripts/a11y-check.sh    Orca browser verification runbook
scripts/axe-core.min.js  vendored axe-core, optional, gitignored until added
```

One tree works on every host. There is no `.claude/` directory and no
`CLAUDE.md`. Do not reintroduce host-specific paths.

## Rules

- Keep `references/wcag-core.md` small. It loads on every run.
- One canonical location per pattern. Rules name what to enforce.
  `references/patterns.md` holds the copy-paste examples.
- Anti-pattern-first rules. Hosts already know accessible HTML. This skill
  blocks what fails and sets the numbers.
- Reports never claim conformance from source inspection alone.
- Fixes are a follow-up that names issue IDs. One fix per commit, each ends
  in a browser re-check.
