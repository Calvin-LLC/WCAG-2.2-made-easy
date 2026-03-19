---
paths:
  - "**/*.css"
  - "**/*.scss"
  - "**/*.less"
  - "**/*.sass"
---

# WCAG 2.2 CSS Rules

## Focus Styles (2.4.7)

- REQUIRE `:focus-visible` with visible outline on all interactive elements
- BLOCK `outline: none` or `outline: 0` without a `:focus-visible` replacement
- Minimum: `outline: 2px solid [color]; outline-offset: 2px`
- Focus indicator must have 3:1 contrast against adjacent colors (1.4.11)

## Contrast (1.4.3, 1.4.11)

| Content | Minimum Ratio | Example Pass | Example Fail |
|---------|---------------|-------------|-------------|
| Normal text | 4.5:1 | #595959 on #fff (7:1) | #999 on #fff (2.8:1) |
| Large text (>=18px / >=14px bold) | 3:1 | #767676 on #fff (4.5:1) | #aaa on #fff (2.3:1) |
| UI components, borders, icons | 3:1 | #767676 on #fff | #ccc on #fff (1.6:1) |

- Color must never be the sole indicator of state. Combine with text, icons, or borders (1.4.1)

## Target Sizes (2.5.8)

```css
/* WCAG 2.2 minimum: 24x24 CSS px */
button, a, [role="button"] { min-width: 24px; min-height: 24px; }

/* Recommended: 44-48px */
button, a, [role="button"] { min-width: 48px; min-height: 48px; }

/* Minimum spacing between targets: 8px */
```

Exceptions: inline text links, user-agent-controlled elements, essential small sizing.

## Reflow (1.4.10)

- Content must work at 320 CSS px width without horizontal scroll
- Use `max-width: 100%`, responsive grids, `overflow-wrap: break-word`
- No fixed-width layouts. Use `minmax()` or `auto-fit`/`auto-fill`
- Exception: data tables, maps, toolbars may use 2D scrolling

## Text Sizing and Spacing (1.4.4, 1.4.12)

- Use `rem`/`em` for font-size, not `px`. `html { font-size: 100%; }` as base
- Use `rem` for layout spacing and container widths
- No fixed `height` with `overflow: hidden` on text containers (clips with adjusted spacing)
- Use `min-height: auto; overflow: visible` on text containers

## Orientation (1.3.4)

- Never lock orientation via CSS or meta tag
- Adapt layout per orientation, don't hide content
- Exception: essential orientation (piano app, check deposit)

## Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        transition-duration: 0.01ms !important;
    }
}
```

- No animation that flashes more than 3 times per second (2.3.1)

## Focus Not Obscured (2.4.11)

```css
a:focus, button:focus, input:focus, [tabindex]:focus {
    scroll-margin-top: 5rem;   /* account for sticky headers */
    scroll-margin-bottom: 5rem;
}
```

## Pointer Queries

```css
@media (hover: hover) and (pointer: fine) { /* mouse/trackpad */ }
@media (hover: none) and (pointer: coarse) { /* touch */ }
```

Don't assume input type from viewport width.

## Images of Text (1.4.5)

- Use styled text, not images of text. Exception: logos

## Dynamic Numbers

- Use `font-variant-numeric: tabular-nums` on any number that updates dynamically
