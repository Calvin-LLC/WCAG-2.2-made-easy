---
paths:
  - "**/*.html"
  - "**/*.htm"
  - "**/*.jsx"
  - "**/*.tsx"
  - "**/*.vue"
  - "**/*.svelte"
  - "**/*.astro"
  - "**/*.php"
  - "**/*.erb"
  - "**/*.hbs"
  - "**/*.ejs"
  - "**/*.njk"
---

# WCAG 2.2 HTML Rules

## Page Structure

- `<html lang="...">` required (3.1.1)
- `<title>` must be unique and descriptive: "[Page] - [Site]" (2.4.2)
- One `<h1>` per page, headings in logical order (1.3.1)
- Skip link as first focusable element targeting `<main>` (2.4.1)
- Use semantic elements: `<header>`, `<nav>`, `<main>`, `<footer>`, `<article>`, `<section>` (1.3.1)
- DOM order must match visual reading order (1.3.2)
- Don't reference content by position/shape/color alone (1.3.3)

## Images

- Every `<img>` needs `alt`. Informative: describe content. Decorative: `alt=""`. Complex: use `<figure>` + `<figcaption>` (1.1.1)
- `<input type="image">` needs `alt` (1.1.1)
- Never use `alt="image"` or `alt="photo"` -- describe purpose

## Forms

- Every `<input>` must have `<label for="id">` or `aria-label`/`aria-labelledby` (3.3.2)
- Errors: use `aria-invalid="true"` + `aria-describedby` pointing to error `<p>` with `role="alert"` (3.3.1)
- Suggest corrections when possible (3.3.3)
- Group related inputs with `<fieldset>` + `<legend>` (1.3.1)
- Never use `placeholder` as the only label
- Pre-populate previously entered data in multi-step forms (3.3.7)
- Confirm/review for legal, financial, or data-deletion actions (3.3.4)

### Autocomplete Values (1.3.5)

Use `autocomplete` on any input collecting personal data:

| Value | Purpose |
|-------|---------|
| `name` / `given-name` / `family-name` | Name fields |
| `email` | Email |
| `tel` | Phone |
| `street-address` / `postal-code` / `country-name` | Address |
| `cc-number` / `cc-exp` / `cc-csc` | Payment |
| `username` / `current-password` / `new-password` | Auth |

## Links and Buttons

- Links must have descriptive text. Never "click here" or "read more" (2.4.4)
- Interactive elements must be `<button>` or `<a>`, not `<div onclick>` (2.1.1)
- Icon buttons need `aria-label` with SVG `aria-hidden="true"` (1.1.1)
- Accessible name must contain visible label text (2.5.3)

## Media (1.2.1-1.2.5)

- **Audio-only** (prerecorded): provide text transcript (1.2.1)
- **Video-only** (prerecorded): provide text transcript or audio description (1.2.1)
- **Video with audio** (prerecorded): provide synchronized captions via `<track kind="captions">` (1.2.2)
- **Video with audio** (prerecorded): provide audio description via `<track kind="descriptions">` or media alternative (1.2.3, 1.2.5)
- **Live audio**: provide real-time captions (1.2.4)
- All `<audio>`/`<video>` with `autoplay` must have `controls` (1.4.2)

## ARIA

- Prefer native HTML over ARIA. Use ARIA only when no native element exists
- Custom components must expose name, role, value (4.1.2)
- Modals: `role="dialog"`, `aria-modal="true"`, `aria-labelledby`, close on Escape, trap focus
- Status messages: `role="status"` + `aria-live="polite"` or `role="alert"` + `aria-live="assertive"` (4.1.3)
- Toggle states: `aria-expanded`, `aria-pressed`, `aria-checked`

## Help and Navigation

- Help mechanism (link, chat, phone) in same relative position on every page (3.2.6)
- Provide multiple ways to find pages: nav + search or sitemap (2.4.5)
- Navigation order consistent across pages (3.2.3)
- Same-function components labeled consistently (3.2.4)
- Mark language changes: `<span lang="fr">` (3.1.2)

## Authentication (3.3.8)

- Use `autocomplete="username"` and `autocomplete="current-password"`
- Allow paste in password fields
- No text CAPTCHAs. Object recognition or audio alternatives OK
- Provide passkey/biometric/magic-link alternatives when possible

## Timing and Interaction

- No unexpected context changes on focus (3.2.1) or input (3.2.2)
- Time limits must be adjustable/extendable (2.2.1)
- Auto-updating content must have pause/stop controls (2.2.2)
