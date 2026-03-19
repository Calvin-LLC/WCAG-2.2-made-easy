# Developer Accessibility Checklist

## Before Every Commit

Use this checklist before committing any user-facing code.

---

## HTML Structure

- [ ] **Page has `<html lang="en">`** (or appropriate language)
- [ ] **Page has unique, descriptive `<title>`**
- [ ] **Only ONE `<h1>` per page**
- [ ] **Headings are in order** (h1 → h2 → h3, never skip levels)
- [ ] **Semantic elements used** (header, nav, main, article, section, footer)
- [ ] **Skip link provided** (`<a href="#main">Skip to main content</a>`)

---

## Images & Media

- [ ] **All `<img>` have `alt` attribute**
- [ ] **Informative images have descriptive alt text**
- [ ] **Decorative images have `alt=""`**
- [ ] **Complex images have extended description** (aria-describedby)
- [ ] **No images of text** (except logos)
- [ ] **Video has captions**
- [ ] **Audio has transcript**
- [ ] **No auto-playing media** (or has controls)

---

## Forms

- [ ] **Every input has a `<label>`** with matching `for`/`id`
- [ ] **Required fields are indicated** (in label, not just asterisk)
- [ ] **Error messages are clear and specific**
- [ ] **Errors reference the field** (aria-describedby)
- [ ] **Invalid fields use `aria-invalid="true"`**
- [ ] **Form can be submitted with Enter key**
- [ ] **Placeholders don't replace labels**

---

## Keyboard Accessibility

- [ ] **All interactive elements reachable via Tab**
- [ ] **NO keyboard traps** (can always Tab away)
- [ ] **Focus order is logical** (matches visual order)
- [ ] **Custom controls have keyboard support** (Enter, Space, arrows)
- [ ] **Modals trap focus inside** (and return focus when closed)
- [ ] **Modals close with Escape key**

---

## Focus Indicators

- [ ] **Focus is always visible**
- [ ] **Never use `*:focus { outline: none; }`**
- [ ] **Custom focus styles are clear** (2px solid, good contrast)
- [ ] **Focus indicators have sufficient contrast** (3:1 minimum)

---

## Color & Contrast

- [ ] **Text contrast is 4.5:1 minimum** (normal text)
- [ ] **Large text contrast is 3:1 minimum** (≥18px or ≥14px bold)
- [ ] **UI component contrast is 3:1 minimum** (borders, icons)
- [ ] **Information not conveyed by color alone** (use icons, text, patterns)

---

## Touch & Mobile

- [ ] **Touch targets are 48x48px minimum**
- [ ] **8px minimum spacing between targets**
- [ ] **Don't assume input method from viewport size**
- [ ] **Use `pointer: coarse/fine` for input detection**

---

## Motion & Animation

- [ ] **Animations respect `prefers-reduced-motion`**
- [ ] **No content flashes more than 3 times/second**
- [ ] **Moving content has pause/stop controls**

---

## Units & Scaling

- [ ] **Use relative units** (rem, em, %, vh/vw)
- [ ] **Avoid fixed pixel heights** for containers
- [ ] **Text resizable to 200%** without loss of content
- [ ] **Layout doesn't break at 200% zoom**

---

## Links & Buttons

- [ ] **Link text is descriptive** (not "click here" or "read more")
- [ ] **Links indicate file type/size** if applicable (PDF, 2MB)
- [ ] **Buttons use `<button>` element** (not div/span)
- [ ] **Links use `<a>` element** (not div/span)

---

## ARIA (Use Sparingly)

- [ ] **Native HTML preferred over ARIA**
- [ ] **ARIA used correctly** (valid roles, states, properties)
- [ ] **Dynamic content announced** (aria-live regions)
- [ ] **Dialogs have proper ARIA** (role="dialog", aria-modal, aria-labelledby)

---

## WCAG 2.2 New Requirements

- [ ] **Input fields have `autocomplete` attribute** for personal data
- [ ] **Accessible name includes visible label text**
- [ ] **Single-char shortcuts are remappable/disableable**
- [ ] **Single-pointer alternatives** for multipoint/path gestures
- [ ] **Actions fire on pointer up** (click), not pointer down
- [ ] **Motion features have UI alternatives** and can be disabled
- [ ] **Content works in both orientations** (portrait and landscape)
- [ ] **Content reflows at 320px** without horizontal scrolling
- [ ] **Text containers don't clip** with adjusted spacing
- [ ] **Hover/focus content** is dismissible (Escape), hoverable, persistent
- [ ] **Focus not obscured** by sticky headers/footers/banners
- [ ] **Targets at least 24x24 CSS px** (48px recommended)
- [ ] **Drag operations have click alternatives**
- [ ] **Help mechanism in consistent location** across pages
- [ ] **Previously entered data auto-populated** in multi-step forms
- [ ] **No cognitive function tests for authentication**
- [ ] **Status messages use ARIA live regions** (role="status", role="alert")
- [ ] **Non-text elements have 3:1 contrast** (borders, icons, controls)

---

## Quick Tests

### Keyboard Test
1. Put mouse aside
2. Tab through entire page
3. Can you reach everything?
4. Can you see where focus is?
5. Can you escape from modals?

### Zoom Test
1. Zoom to 200%
2. Is all content still visible?
3. Is all functionality working?

### Screen Reader Test (5 minutes)
1. Turn on VoiceOver (Mac: Cmd+F5) or NVDA (Windows)
2. Navigate by headings (H key)
3. Navigate by landmarks (D key in NVDA)
4. Fill out a form
5. Check error messages are announced

---

## Common Mistakes to Avoid

1. **`<div onclick>`** → Use `<button>` instead
2. **`<span class="link">`** → Use `<a href>` instead
3. **Placeholder as label** → Use actual `<label>`
4. **Color-only errors** → Add icons and text
5. **Removing focus outline** → Replace, don't remove
6. **Small touch targets** → Minimum 48x48px
7. **Auto-playing video** → User must initiate
8. **`tabindex="5"`** → Use 0 or -1 only
9. **Fixed pixel heights** → Use relative units
10. **Assuming mobile = touch** → Use media queries
11. **Missing autocomplete** → Add autocomplete="name", "email", etc.
12. **Orientation lock** → Don't restrict to portrait/landscape
13. **Drag-only sorting** → Add up/down buttons as alternatives
14. **CAPTCHA text entry** → Use passkeys, email codes, or object recognition
