# QA Accessibility Testing Checklist

## Manual Testing Procedures

Use this checklist for accessibility QA testing.

---

## 1. Keyboard Navigation Test

### Setup
- Unplug mouse or disable trackpad
- Use only Tab, Shift+Tab, Enter, Space, Arrow keys, Escape

### Test Procedure
- [ ] **Can Tab to all interactive elements** (links, buttons, inputs)
- [ ] **Focus indicator is always visible**
- [ ] **Focus order is logical** (left-to-right, top-to-bottom)
- [ ] **No keyboard traps** (can Tab away from all elements)
- [ ] **Can activate buttons** with Enter or Space
- [ ] **Can follow links** with Enter
- [ ] **Dropdowns work** with Arrow keys
- [ ] **Modals trap focus** (can't Tab outside)
- [ ] **Modals close** with Escape key
- [ ] **Focus returns** to trigger after modal closes

### Common Issues
- Custom dropdowns not keyboard accessible
- Modal doesn't trap focus
- Focus lost after dynamic content change
- Can't close modal with Escape
- Skip link doesn't work

---

## 2. Screen Reader Test

### Setup
- **Windows**: NVDA (free) or JAWS
- **Mac**: VoiceOver (Cmd + F5)
- **iOS**: VoiceOver (Settings > Accessibility)
- **Android**: TalkBack (Settings > Accessibility)

### Basic Navigation Test
- [ ] **Page title announced** on load
- [ ] **Headings navigable** (H key in NVDA/JAWS)
- [ ] **Heading hierarchy is logical** (H1, H2, H3...)
- [ ] **Landmarks navigable** (D key in NVDA)
- [ ] **Skip link works** and is announced

### Content Test
- [ ] **Images have alt text** read aloud
- [ ] **Decorative images are silent** (empty alt)
- [ ] **Link text is descriptive** (not "click here")
- [ ] **Buttons have accessible names**
- [ ] **Tables have headers** announced

### Form Test
- [ ] **Form fields have labels** announced
- [ ] **Required fields indicated**
- [ ] **Error messages announced** immediately
- [ ] **Error messages reference field**
- [ ] **Help text announced** with field

### Dynamic Content Test
- [ ] **Alerts announced** automatically
- [ ] **Loading states announced**
- [ ] **Content updates announced** appropriately

---

## 3. Visual Test

### Zoom Test
- [ ] **Zoom to 200%** in browser
- [ ] **All content still visible**
- [ ] **No horizontal scrolling** (or minimal)
- [ ] **Text doesn't overlap**
- [ ] **All functionality works**

### Color Contrast Test
Use browser extension (axe, WAVE) or contrast checker

- [ ] **Normal text**: 4.5:1 minimum
- [ ] **Large text**: 3:1 minimum
- [ ] **UI components**: 3:1 minimum
- [ ] **Focus indicators**: 3:1 minimum

### Color Independence Test
- [ ] **View in grayscale** (browser extension or OS setting)
- [ ] **Can distinguish all information**
- [ ] **Error messages have icons/text**, not just red
- [ ] **Links distinguishable** without color
- [ ] **Required fields clear** without color

### Focus Visibility Test
- [ ] **Tab through page** watching for focus
- [ ] **Focus visible on every element**
- [ ] **Focus stands out** from background
- [ ] **No invisible focus** (outline: none without replacement)

---

## 4. Motion Test

### Reduced Motion Test
- [ ] Enable "Reduce motion" in OS settings
  - Mac: System Preferences > Accessibility > Display > Reduce motion
  - Windows: Settings > Ease of Access > Display > Show animations
  - iOS: Settings > Accessibility > Motion > Reduce Motion
- [ ] **Animations are reduced or removed**
- [ ] **Content still functions** without animation
- [ ] **Page is still usable**

### Flashing Content Test
- [ ] **No content flashes > 3 times/second**
- [ ] **Moving content has pause button**
- [ ] **Auto-playing content can be stopped**

---

## 5. Touch/Mobile Test

### Touch Target Test
- [ ] **All touch targets are at least 48x48px**
- [ ] **At least 8px spacing** between targets
- [ ] **Can tap accurately** without mis-tapping adjacent elements

### Responsive Test
- [ ] **Content works at mobile sizes**
- [ ] **No functionality lost on mobile**
- [ ] **Touch gestures are not required** (have alternatives)
- [ ] **Hover-only content is accessible**

---

## 6. Automated Testing

### Browser Extensions
Run these on each page:

- [ ] **axe DevTools** - Run full scan
- [ ] **WAVE** - Check errors and alerts
- [ ] **Lighthouse** - Run accessibility audit

### Command Line
```bash
# Using axe-core
npx @axe-core/cli https://your-site.com

# Using pa11y
npx pa11y https://your-site.com
```

### Record Results
- Number of errors
- Error types
- Pages affected
- Severity (Critical, Serious, Moderate, Minor)

---

## 7. Page-by-Page Checklist

For each page, verify:

### Structure
- [ ] Unique, descriptive `<title>`
- [ ] One `<h1>` that describes page
- [ ] Heading hierarchy in order
- [ ] Language declared (`<html lang="en">`)
- [ ] Skip link present and working

### Images
- [ ] All images have alt text
- [ ] Alt text is appropriate for context
- [ ] Decorative images have empty alt

### Forms
- [ ] All inputs have labels
- [ ] Required fields marked
- [ ] Error messages are clear
- [ ] Form is keyboard accessible

### Interactive Elements
- [ ] All buttons/links keyboard accessible
- [ ] Focus indicators visible
- [ ] Modals work properly

---

## 8. WCAG 2.2 Specific Tests

### Orientation Test
- [ ] **Rotate device/resize browser** to landscape
- [ ] **All content visible** in both orientations
- [ ] **No forced orientation** (check for orientation meta tag)

### Reflow Test (320px)
- [ ] **Set browser to 320px width** (or zoom to 400%)
- [ ] **No horizontal scrollbar** (except data tables, maps)
- [ ] **All content readable** in single column
- [ ] **No text truncation**

### Text Spacing Test
Apply these CSS overrides and verify no content is clipped:
```css
* { line-height: 1.5em !important; letter-spacing: 0.12em !important; word-spacing: 0.16em !important; }
p { margin-bottom: 2em !important; }
```
- [ ] **No text overlapping**
- [ ] **No text clipped** or hidden
- [ ] **All functionality still works**

### Pointer/Gesture Test
- [ ] **All gestures have single-pointer alternatives**
- [ ] **Pinch-to-zoom has buttons** (+ / -)
- [ ] **Swipe has next/prev buttons**
- [ ] **No path-based gesture required**

### Drag Operation Test
- [ ] **All drag operations have click alternatives**
- [ ] **Sortable lists have move up/down buttons**
- [ ] **Sliders use native inputs**

### Target Size Test
- [ ] **Interactive targets at least 24x24 CSS px**
- [ ] **Inline links properly spaced**
- [ ] **Small targets have 24px spacing to neighbors**

### Authentication Test
- [ ] **Login works with password manager**
- [ ] **No text CAPTCHA without alternative**
- [ ] **autocomplete attributes present** on login fields

### Focus Obscured Test
- [ ] **Tab through page with sticky header**
- [ ] **Focused element never fully hidden** behind sticky/fixed elements
- [ ] **Check with cookie banners active**

### Hover/Focus Content Test
- [ ] **Tooltips dismissible with Escape**
- [ ] **Can hover over tooltip content**
- [ ] **Tooltip stays visible** until dismissed
- [ ] **Focus-triggered content behaves same way**

### Consistent Help Test
- [ ] **Help link/contact in same location** on every page
- [ ] **Check 3+ pages** for consistency

### Status Message Test
- [ ] **Search results count announced** by screen reader
- [ ] **Form success/error announced** without focus change
- [ ] **Cart updates announced**
- [ ] **Check role="status" and aria-live** attributes

### Character Shortcut Test
- [ ] **Single-key shortcuts can be disabled**
- [ ] **Shortcuts can be remapped**
- [ ] **Shortcuts don't fire in text inputs**

### Redundant Entry Test
- [ ] **Multi-step forms pre-fill** repeated information
- [ ] **"Same as billing" option** for shipping address
- [ ] **Previously entered data selectable**

---

## Bug Report Template

When filing accessibility bugs, include:

```
**Issue**: [Brief description]
**WCAG Criterion**: [e.g., 2.4.7 Focus Visible]
**Severity**: Critical / Serious / Moderate / Minor
**Page/URL**: [Where the issue occurs]
**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Behavior**: [What should happen]
**Actual Behavior**: [What actually happens]
**Assistive Technology**: [Screen reader, keyboard, etc.]
**Browser/OS**: [Chrome/Windows, Safari/Mac, etc.]
**Screenshot/Video**: [If applicable]
```

---

## Severity Definitions

### Critical
- Content completely inaccessible to some users
- Keyboard trap
- No alt text on important images
- No form labels

### Serious
- Major barriers but workarounds exist
- Poor color contrast
- Focus not visible
- Missing headings

### Moderate
- Some difficulty but content accessible
- Minor contrast issues
- Missing skip link
- Generic link text

### Minor
- Best practice issues
- Redundant alt text
- Minor heading order issues

---

## Testing Schedule

| Test Type | Frequency | Performed By |
|-----------|-----------|--------------|
| Automated scan | Every build | CI/CD |
| Keyboard test | Every feature | Developer |
| Screen reader | Every sprint | QA |
| Full audit | Quarterly | Accessibility specialist |
