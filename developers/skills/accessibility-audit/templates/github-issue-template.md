# GitHub Issue Template

Template for individual accessibility issues.

```markdown
---
Title: [Accessibility] {Issue Title}
Labels: accessibility, a11y, {P0|P1|P2|P3}, {keyboard|screen-reader|contrast|forms|...}
---

## Summary

{1-2 sentence description}

**Severity:** {P0 Blocking | P1 High | P2 Medium | P3 Low}
**WCAG:** {Criterion number and name, e.g., 2.4.7 Focus Visible}
**Screens:** {Affected screens list}

## What's the Issue?

{Beginner-friendly explanation in plain language}

## Why This Matters

**Who is affected:** {User groups - keyboard users, blind users, etc.}
**What breaks:** {What they can't do}
**Impact:** {Business/user impact}

## User Impact Example

> "{Quote from affected user perspective}"

Example: "As a keyboard user, I can't see where my focus is, so I have to click randomly to find buttons."

## How to Reproduce

1. {Step 1}
2. {Step 2}
3. {Step 3}
4. **Expected:** {What should happen}
5. **Actual:** {What actually happens}

**Evidence:**
- File: `{file path}`:{line number}
- Screenshot: {if applicable}

## Root Cause

{Technical explanation of the underlying issue}

**Code snippet:**
\`\`\`{language}
{problematic code}
\`\`\`

## Suggested Fix

**Approach:** {CSS-only | Attributes | Markup change | UI change}
**Effort:** {5 min | 1 hour | 4 hours}
**Risk:** {Low | Medium | High}

**Recommended solution:**
\`\`\`{language}
{fixed code}
\`\`\`

**Why this fix:**
- {Reason 1}
- {Reason 2}

**Alternative approaches:**
- Option 2: {Alternative}
- Option 3: {Alternative}

## Design Considerations

**Visual impact:** {None | Minimal | Moderate}
**Layout changes:** {None | Minor adjustments | Significant}
**Brand consistency:** {How to maintain visual identity}

## Testing Checklist

Test this fix with:
- [ ] Keyboard navigation (Tab, Shift+Tab)
- [ ] Screen reader (NVDA or VoiceOver)
- [ ] {Specific test for this issue}
- [ ] Automated scan (axe DevTools)
- [ ] Visual regression (screenshots)
- [ ] Multiple browsers (Chrome, Firefox, Safari)

## Acceptance Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] Passes automated scans
- [ ] Works with keyboard
- [ ] Works with screen reader

## Learn More

**Resources:**
- [WCAG {criterion}]({link})
- [WordPress Accessibility Handbook](https://make.wordpress.org/accessibility/handbook/)
- [MDN: {topic}]({link})

**Related issues:**
- #{issue} - {related issue}

---
**Audit Date:** {YYYY-MM-DD}
**Auditor:** Claude Code accessibility-audit skill
```
