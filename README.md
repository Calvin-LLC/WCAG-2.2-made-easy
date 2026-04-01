# WCAG 2.2 Made Easy

Drop the `.claude` folder into any web project. Claude Code handles the rest, catching accessibility issues as you write code across all 55 WCAG 2.2 Level A and AA criteria.

Inspired by Derek Featherstone's "Accessibility for Web Design" course and [everything-claude-code](https://github.com/affaan-m/everything-claude-code) by Affaan Mustafa.

## Setup

```bash
cp -r WCAG-2.2-made-easy/.claude your-project/
```

## What you get

Rules only load when relevant. Edit a CSS file, you get CSS rules. Edit HTML, you get HTML rules. A hook runs after every write and flags things like missing `alt` attributes or `outline: none` without a replacement.

You also get an accessibility reviewer agent, copy-paste code patterns (forms, modals, tabs, tooltips, drag-and-drop), and checklists for dev, design, and QA.

## Testing

```bash
cd .claude/tests
npm install
node accessibility-tests.js http://your-site.com
```

For a quick manual check, unplug your mouse and Tab through the page. If you can't reach something, see focus, or get stuck, there's a problem.

## References

- [WCAG 2.2 spec](https://www.w3.org/TR/WCAG22/)
- [WebAIM](https://webaim.org/)
- [A11Y Project](https://www.a11yproject.com/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)

## License

MIT
