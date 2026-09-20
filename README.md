# WCAG

An agent skill that makes web UI accessible and proves it in a real browser.
It owns fix-time rules for HTML, CSS, and JS, copy-paste patterns, dev and
design and QA checklists, and browser verification through the Orca embedded
browser. It reports. It never edits your code.

It covers WCAG 2.2 Level A and AA, 55 criteria out of 86 total. Static checks
are the floor. The browser is the proof. Nothing here claims conformance from
reading source alone.

## Layout

```
SKILL.md                 orchestrator: scope, verify, report
AGENTS.md                host instructions for this repo
references/wcag-core.md  always-loaded anti-patterns and thresholds
references/wcag-html.md  structure, forms, media, ARIA
references/wcag-css.md   focus, contrast, targets, reflow, motion
references/wcag-js.md    keyboard, focus management, live regions
references/patterns.md   copy-paste fixes for forms, modals, tabs, tooltips
references/checklists.md dev, design, and QA lists in one file
scripts/a11y-check.sh    Orca browser verification runbook, prints JSON
scripts/vendor/          vendored axe-core for manual console runs
```

One tree works on every host. References load only when the changed files
need them. The core file stays small because it loads on every run.

## Run it

```
wcag check <url>
wcag check <url> --profile mobile
wcag rules <path/to/file>
```

`wcag check` opens the URL in the Orca browser and runs
`scripts/a11y-check.sh`. The script snapshots the accessibility tree, walks
focus with the keyboard, measures computed contrast and target sizes, checks
reflow and zoom, and prints one JSON report. It exits 1 when it finds
violations and 0 when the page is clean.

```bash
scripts/a11y-check.sh https://your-site.com
A11Y_REFLOW_DEVICE="iPhone 12" scripts/a11y-check.sh https://your-site.com
```

The second form adds a narrow-viewport reflow check on a named Orca device
profile. `A11Y_PACE` sets seconds between Orca calls (default 2).
`ORCA_BIN` points at the CLI when it is not on PATH.

Screen reader passes and real-device touch testing stay manual. The report
lists them as follow-ups.

## What it will not do

- Claim conformance from source inspection alone
- Treat multiple `h1` elements or `px` font sizes as failures
- Invent contrast ratios or target sizes without measuring them
- Edit the target repo; fixes are a follow-up that names issue IDs

## Install

Point your Agent Skills host at a clone of this repo. Hosts look for
`SKILL.md`.

```bash
git clone https://github.com/Calvin-LLC/WCAG-2.2-made-easy.git
```

Then copy or symlink the checkout into your host's skills path, or load it
straight from the clone.

## References

- [WCAG 2.2 spec](https://www.w3.org/TR/WCAG22/)
- [WebAIM](https://webaim.org/)
- [A11Y Project](https://www.a11yproject.com/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)

## License

MIT
