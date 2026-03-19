---
paths:
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.vue"
  - "**/*.svelte"
  - "**/*.mjs"
  - "**/*.cjs"
---

# WCAG 2.2 JavaScript Rules

## Keyboard Support (2.1.1)

- Custom interactive elements must handle `Enter` and `Space` via `keydown`
- Call `e.preventDefault()` on Space to prevent page scroll
- All functionality available via keyboard. No mouse-only interactions
- No keyboard traps: user must always be able to Tab away (2.1.2)

## Focus Management

- After DOM insertion (modal open, dynamic content): focus the new content
- After removal (modal close, item delete): return focus to the trigger element
- Modal focus trap: Tab cycles through modal, Shift+Tab wraps backward
- After route change in SPAs: focus the main heading or announce the new page

## ARIA State Updates

- Update `aria-expanded` on disclosure/accordion/menu toggles
- Update `aria-pressed` on toggle buttons
- Update `aria-checked` on custom checkboxes/radios
- Set `aria-busy="true"` during async loading, remove when done
- Set `aria-invalid="true"` on fields with validation errors

## Live Regions (4.1.3)

- Use `role="status"` + `aria-live="polite"` for non-urgent updates (search results count, save confirmation)
- Use `role="alert"` + `aria-live="assertive"` for errors and urgent messages
- Insert text content into an existing live region; don't create and populate in same tick

## Pointer Cancellation (2.5.2)

- BLOCK: `pointerdown` or `mousedown` for triggering actions
- Use `click` (fires on pointerup) for all actions
- Native click allows abort by moving pointer off target before release

## Pointer Gestures (2.5.1)

- Multipoint gestures (pinch, multi-finger swipe) must have single-pointer alternatives
- Provide button controls (zoom in/out, next/prev) alongside gesture-based interactions

## Escape to Dismiss (1.4.13)

- Tooltips, popovers, and hover/focus content must close on Escape
- Content must be hoverable (user can move pointer to it) and persistent (stays until dismissed)

## Character Key Shortcuts (2.1.4)

- Single-character shortcuts must be remappable or disableable
- Don't fire single-key shortcuts when focus is in `input`, `textarea`, `select`, or `[contenteditable]`
- Provide a settings UI to remap or disable shortcuts

## Motion Actuation (2.5.4)

- Device-motion-triggered features (shake to undo) must have a UI alternative (button)
- Provide a setting to disable motion responses
- Exception: motion essential to function (pedometer)

## Dragging (2.5.7)

- Drag operations must have single-pointer click alternatives (up/down buttons, click-to-place)
- Announce reorder changes via live region

## Context Changes (3.2.1, 3.2.2)

- No navigation or popups on focus
- No auto-submit on select change; use explicit submit button
- No unexpected context changes on input

## Timing (2.2.1, 2.2.2)

- Warn before session timeout, allow extension
- Auto-updating content (feeds, tickers) must have pause/stop controls
