# Design Accessibility Checklist

## During Design Phase

Use this checklist when creating mockups, wireframes, and design systems.

---

## Color & Contrast

### Text Contrast
- [ ] **Normal text (< 18px)**: 4.5:1 contrast ratio minimum
- [ ] **Large text (≥ 18px or ≥ 14px bold)**: 3:1 contrast ratio minimum
- [ ] **Test all text/background combinations**

### UI Contrast
- [ ] **Form field borders**: 3:1 against background
- [ ] **Button borders/backgrounds**: 3:1 against surrounding area
- [ ] **Icons**: 3:1 against background
- [ ] **Focus indicators**: 3:1 against background

### Tools
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Stark (Figma/Sketch plugin)](https://www.getstark.co/)
- [Colour Contrast Analyser](https://www.tpgi.com/color-contrast-checker/)

---

## Color Independence

- [ ] **Never use color as the only indicator**
- [ ] **Error states**: Red + icon + text
- [ ] **Success states**: Green + icon + text
- [ ] **Required fields**: Not just red asterisk
- [ ] **Links in text**: Underlined, not just colored
- [ ] **Charts/graphs**: Use patterns, not just colors

### Examples

```
WRONG:
[Red text] Error        [Green text] Success

CORRECT:
[ERROR] Invalid email  [OK] Success: Saved
```

---

## Typography

### Font Size
- [ ] **Base font size**: 16px minimum (1rem)
- [ ] **Body text**: 16-18px
- [ ] **Small text**: Avoid below 12px
- [ ] **Line height**: 1.5 for body text

### Readability
- [ ] **Line length**: 45-75 characters maximum
- [ ] **Paragraph spacing**: At least 1.5x font size
- [ ] **Letter spacing**: Normal or slightly increased
- [ ] **No justified text** (causes uneven spacing)

---

## Touch Targets

### Size Requirements
- [ ] **Minimum size**: 48x48px (approximately 9mm)
- [ ] **Comfortable size**: 44-48px for primary actions
- [ ] **Spacing between targets**: 8px minimum

### Considerations
- [ ] **Thumb-friendly zones** for mobile (bottom of screen)
- [ ] **Icon buttons have adequate padding**
- [ ] **Inline links have sufficient hit area**

---

## Visual Hierarchy

### Headings
- [ ] **Clear heading hierarchy** (H1 → H2 → H3)
- [ ] **Only one H1 per page**
- [ ] **Headings look like headings** (size, weight)

### Focus States
- [ ] **Design visible focus indicators**
- [ ] **Focus style is distinct** from hover
- [ ] **Focus visible on all backgrounds**
- [ ] **Focus outline**: 2px solid, offset 2px

---

## Motion & Animation

### Principles
- [ ] **Animations are optional** (not required to understand content)
- [ ] **Design reduced motion alternatives**
- [ ] **No flashing > 3 times/second**
- [ ] **Auto-playing content has pause control**

### What to Avoid
- Parallax scrolling (causes motion sickness)
- Background video without pause
- Infinite looping animations
- Sudden or jarring transitions

---

## Layout

### Responsive Design
- [ ] **Design mobile-first**
- [ ] **Content reflows** at different sizes
- [ ] **No horizontal scrolling** at common sizes
- [ ] **200% zoom doesn't break layout**

### Reading Order
- [ ] **Visual order matches reading order**
- [ ] **Don't rely on CSS to reorder content**
- [ ] **Consider how screen readers will read it**

---

## Forms

### Labels
- [ ] **Every field has a visible label**
- [ ] **Labels are above or beside inputs** (not inside)
- [ ] **Required fields clearly marked** (in label text)

### Error States
- [ ] **Design error message placement** (near the field)
- [ ] **Error messages are specific** (not just "Invalid")
- [ ] **Multiple errors listed** (not one at a time)

### Help Text
- [ ] **Instructions provided** where needed
- [ ] **Format hints** (e.g., "MM/DD/YYYY")
- [ ] **Character limits visible** if applicable

---

## Components

### Buttons
- [ ] **Primary action is obvious**
- [ ] **Destructive actions look different** (color, confirmation)
- [ ] **Disabled state is clear** but still visible

### Links
- [ ] **Links are underlined** (or otherwise obvious)
- [ ] **Visited link state** is different
- [ ] **Link text is descriptive**

### Modals
- [ ] **Close button is obvious**
- [ ] **Escape closes modal**
- [ ] **Focus trap designed** (can't tab outside)

---

## Content Considerations

### Images
- [ ] **Consider what alt text will say**
- [ ] **Informative images**: Describe content
- [ ] **Decorative images**: Will be hidden
- [ ] **Complex images**: Plan extended description

### Icons
- [ ] **Icons have text labels** (or aria-label planned)
- [ ] **Icons are not the only indicator**
- [ ] **Icon meaning is clear**

---

## WCAG 2.2 Design Considerations

### Orientation
- [ ] **Design works in portrait AND landscape**
- [ ] **No orientation lock** unless essential (e.g., piano app)

### Reflow
- [ ] **Design works at 320px width** (single column)
- [ ] **No horizontal scrolling** at 400% zoom
- [ ] **Data tables may scroll** (exception)

### Text Spacing
- [ ] **Text containers flexible height** (no clipping)
- [ ] **Design tolerates** 1.5x line height, 2x paragraph spacing
- [ ] **No fixed-height text boxes**

### Hover/Focus Content
- [ ] **Tooltips dismissible** (Escape key)
- [ ] **Tooltips stay visible** while hovering over them
- [ ] **Tooltips persist** until user dismisses or moves away

### Focus Visibility
- [ ] **Focused elements not hidden** behind sticky headers/footers/banners
- [ ] **Account for cookie banners, chat widgets, sticky navs**

### Target Size
- [ ] **Minimum target size: 24x24 CSS px** (WCAG 2.2 requirement)
- [ ] **Recommended: 44-48px** for comfortable interaction
- [ ] **Inline text links exempt** if spaced properly

### Drag Alternatives
- [ ] **Every drag operation has a tap/click alternative**
- [ ] **Sortable lists have up/down buttons**
- [ ] **Sliders use native range inputs**

### Authentication
- [ ] **No text-based CAPTCHAs**
- [ ] **Support password managers** (proper autocomplete)
- [ ] **Offer passkey/biometric options**
- [ ] **Magic link or email code as alternative**

### Consistent Help
- [ ] **Help mechanism in same position** on every page
- [ ] **Contact info, FAQ, chat** always findable

---

## Checklist for Design Handoff

Include in design documentation:
- [ ] Color contrast ratios for all text
- [ ] Focus state designs for all interactive elements
- [ ] Touch target sizes noted
- [ ] Error state designs
- [ ] Reduced motion alternatives
- [ ] Alt text suggestions for images
- [ ] Heading level hierarchy
- [ ] Reading order for complex layouts

---

## Quick Reference

| Element | Minimum | Recommended |
|---------|---------|-------------|
| Normal text contrast | 4.5:1 | 7:1 |
| Large text contrast | 3:1 | 4.5:1 |
| UI contrast | 3:1 | 4.5:1 |
| Target size (minimum) | 24x24px | 44-48px |
| Touch target (best practice) | 44px | 48px |
| Touch spacing | 8px | 8px |
| Base font size | 16px | 16-18px |
| Line height | 1.4 | 1.5 |
| Line length | - | 45-75 chars |
| Reflow width | 320px | - |
