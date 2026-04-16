# Accessibility Audit References - Index

Quick navigation to all reference materials for the WordPress accessibility audit skill.

## Core References

### [audit-categories.md](./audit-categories.md)
**Use when:** Performing the 9-category audit per screen
**Contains:**
- Detailed breakdown of all 9 audit categories
- WCAG criteria for each category
- Grep patterns for code inspection
- WordPress-specific guidance (Classic + Gutenberg)
- Code examples (vulnerable + fixed)
- Testing approaches

### [wordpress-a11y-patterns.md](./wordpress-a11y-patterns.md)
**Use when:** Looking for WordPress-native accessible solutions
**Contains:**
- WordPress core accessible components
- Classic Editor patterns (Settings API, List Tables)
- Gutenberg components (`wp.components.*`)
- Screen reader announcements (`wp.a11y.speak()`)
- Focus management utilities
- Code examples for all patterns

### [wcag-2.2-quick-reference.md](./wcag-2.2-quick-reference.md)
**Use when:** Need WCAG criteria details or links to Understanding WCAG
**Contains:**
- WCAG 2.2 principles (POUR)
- Level A and AA success criteria (48 total)
- Quick reference table organized by principle
- Links to Understanding WCAG documentation
- Level AAA criteria (reference only)

### [testing-checklist.md](./testing-checklist.md)
**Use when:** Planning testing approach or verifying fixes
**Contains:**
- Manual testing procedures (keyboard, screen reader, contrast, zoom)
- Automated testing commands (axe, Lighthouse, WAVE, pa11y)
- How to install and use testing tools
- Interpreting results and false positives
- Testing workflow recommendations

### [common-antipatterns.md](./common-antipatterns.md)
**Use when:** Identifying patterns of accessibility issues
**Contains:**
- Top 20 accessibility anti-patterns
- Real WordPress examples
- Why each is problematic
- How to fix (minimal change approach)
- WordPress alternatives

### [aria-patterns.md](./aria-patterns.md)
**Use when:** Deciding if/how to use ARIA
**Contains:**
- When to use ARIA (and when not to)
- First rule: No ARIA > Bad ARIA
- ARIA roles, states, and properties
- Common patterns (tabs, modals, accordions, dropdowns)
- Live regions (`aria-live`, `wp.a11y.speak()`)
- Pitfalls and mistakes to avoid

### [git-workflow.md](./git-workflow.md)
**Use when:** Creating PR with accessibility fixes
**Contains:**
- Parallel-safe git worktree setup
- Branch naming conventions
- Commit message guidelines
- PR best practices
- Safety rules (no force push, no skip hooks)

---

## Quick Lookup by Task

### "I'm auditing a screen"
→ Start with [audit-categories.md](./audit-categories.md) - complete 9-category methodology

### "I found an issue, what's the WordPress-native fix?"
→ [wordpress-a11y-patterns.md](./wordpress-a11y-patterns.md) - accessible components

### "Should I use ARIA here?"
→ [aria-patterns.md](./aria-patterns.md) - ARIA guidance (probably no!)

### "What WCAG criterion does this violate?"
→ [wcag-2.2-quick-reference.md](./wcag-2.2-quick-reference.md) - WCAG lookup

### "How do I test this?"
→ [testing-checklist.md](./testing-checklist.md) - manual + automated testing

### "I keep seeing this pattern"
→ [common-antipatterns.md](./common-antipatterns.md) - known issues + fixes

### "I'm ready to create a PR"
→ [git-workflow.md](./git-workflow.md) - git best practices

---

## Reference Sizes

- **audit-categories.md:** 350 lines - Detailed 9-category methodology
- **wordpress-a11y-patterns.md:** 300 lines - WP components and patterns
- **testing-checklist.md:** 250 lines - Manual + automated testing
- **common-antipatterns.md:** 250 lines - Top 20 anti-patterns
- **wcag-2.2-quick-reference.md:** 200 lines - WCAG criteria
- **aria-patterns.md:** 150 lines - ARIA guidance
- **git-workflow.md:** 150 lines - Git workflow
- **00-index.md:** 50 lines - This file

**Total:** ~1,700 lines of reference material

---

## Reading Order for Learning

If you're new to accessibility, read in this order:

1. **wcag-2.2-quick-reference.md** - Understand the standard
2. **audit-categories.md** - Learn the 9 categories
3. **common-antipatterns.md** - See real examples of issues
4. **wordpress-a11y-patterns.md** - Learn WordPress-specific solutions
5. **aria-patterns.md** - Understand ARIA (and when not to use it)
6. **testing-checklist.md** - Learn how to test
7. **git-workflow.md** - Prepare for implementation

---

## External Resources

**WordPress:**
- [WordPress Accessibility Handbook](https://make.wordpress.org/accessibility/handbook/)
- [WordPress Accessibility Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/accessibility/)
- [Gutenberg Accessibility](https://github.com/WordPress/gutenberg/blob/trunk/docs/contributors/accessibility.md)

**WCAG:**
- [WCAG 2.2 Guidelines](https://www.w3.org/WAI/WCAG22/quickref/)
- [Understanding WCAG 2.2](https://www.w3.org/WAI/WCAG22/Understanding/)
- [How to Meet WCAG (Quick Reference)](https://www.w3.org/WAI/WCAG22/quickref/)

**Testing:**
- [WebAIM Resources](https://webaim.org/resources/)
- [axe DevTools](https://www.deque.com/axe/devtools/)
- [NVDA Screen Reader](https://www.nvaccess.org/)

---

**Version:** 1.0.0
**Last Updated:** 2026-02-07
