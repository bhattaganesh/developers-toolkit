---
name: accessibility-audit
description: Use this skill when the user asks to "audit accessibility", "check WCAG compliance", "review accessibility", "a11y audit", "check screen reader support", "audit keyboard navigation", or mentions accessibility testing for WordPress plugins, themes, or websites. Performs comprehensive WCAG 2.2 Level AA compliance audits with beginner-friendly explanations and minimal-change remediation plans.
version: 2.0.0
tools: Read, Glob, Grep, Write, Bash, Task
context: fork
---

# Accessibility Audit Skill

Comprehensive WCAG 2.2 Level AA audits for WordPress plugins/themes/websites.

## Quick Reference

**Workflow:** 7 phases with approval gates
**Standard:** WCAG 2.2 Level AA (48 criteria)
**Deliverables:** Findings report, GitHub issues, testing guide, optional PR
**Principle:** Minimal visual change (CSS → attributes → markup → UI)

---

## When to Use

- WCAG 2.2 Level AA compliance audit
- Prepare for accessibility review/certification
- Fix keyboard navigation or screen reader issues
- Meet accessibility requirements (ADA, Section 508)

---

## Operating Principles

**1. Minimal Visual Change (CRITICAL):**
- CSS fixes > Attributes > Markup changes > UI redesign
- Never redesign unless accessibility requires it

**2. WCAG 2.2 Level AA:**
- 48 success criteria
- Levels: A (must have), AA (should have), AAA (nice to have)
- Focus: A + AA only

**3. WordPress Native:**
- Use `wp.components.*` (Gutenberg)
- Use Settings API (Classic)
- Use `wp.a11y.speak()` for announcements

**4. Evidence-Based:**
- Test with real tools (screen readers, keyboard)
- Code-based findings only
- Never guess

**5. Beginner-Friendly:**
- Explain "What, Why, Who, How" for each finding
- Plain language (no jargon)
- Educational context

**6. Test with Real Tools:**
- Automated: axe DevTools, Lighthouse, WAVE
- Manual: NVDA/VoiceOver, keyboard navigation

**7. Git Safety:**
- Use worktree (isolate work)
- Never destructive commands
- Small commits per phase

**ASSUMPTION:** Production code - impacts real users.

See `references/00-index.md` for detailed references.

---

## Phase 0: Gather Inputs

**Goal:** Get required information

**Q:** Repository?
- GitHub URL
- Base branch (default: `master` or `dev`)

**Q:** Local environment?
- How to run locally
- Access URL
- Build commands (if any)

**Q:** Scope?
- Full audit
- Specific screens/components
- Admin only or frontend too

**Q:** Key screens to prioritize?
- Settings pages
- Admin dashboards
- Frontend UI
- Modals/dialogs

**STOP if:** Cannot run locally or access code

**Wait for all inputs before proceeding.**

---

## Phase 1: Component Inventory

**Goal:** Discover all components/screens

**Parallel discovery:**

**Group 1 - Admin screens:**
- Grep `add_menu_page`
- Grep `add_submenu_page`
- Grep `add_meta_box`

**Group 2 - Frontend:**
- Grep `add_shortcode`
- Grep `register_widget`
- Grep `register_block_type`

**Group 3 - Interactive:**
- Grep `role="dialog"`
- Grep `role="tab"`
- Grep `showModal`
- Grep `<form`

**Inventory format:**

| ID | Name | Type | File | Priority |
|----|------|------|------|----------|
| admin-settings | Settings Page | Admin | `inc/settings.php` | High |
| frontend-form | Contact Form | Frontend | `widgets/form.php` | High |

**Priority:**
- High: User-facing, interactive, forms
- Medium: Admin UI, dashboards
- Low: Hidden/advanced features

**Present inventory and wait for approval.**

---

## Phase 2: 9-Category Audit

**Goal:** Audit each screen across 9 categories

**For each high-priority screen:**

**1. Semantic HTML & Landmarks**
- Proper heading hierarchy (h1 → h2 → h3)
- Landmark regions (`<header>`, `<nav>`, `<main>`, `<footer>`)
- Semantic elements (`<button>`, not `<div onclick>`)

**2. Keyboard Navigation**
- All interactive elements reachable via Tab
- Logical tab order
- No keyboard traps
- Enter/Space activates, Escape closes

**3. Focus Management**
- Visible focus indicators
- No `outline: none` without alternative
- Focus trapped in modals
- Focus returns after close

**4. Screen Reader Support**
- Images have `alt` text
- Form inputs have labels
- Icon buttons have `aria-label`
- Status messages use `aria-live` or `wp.a11y.speak()`
- Error messages use `aria-describedby`

**5. Color & Contrast**
- Text: 4.5:1 (normal), 3:1 (large 18px+)
- UI components: 3:1 against background
- Color not sole indicator

**6. Forms & Input**
- All inputs have associated labels
- Required fields marked
- Error messages inline + associated
- Autocomplete attributes

**7. Tables**
- Use `<table>` for data (not layout)
- `<th>` headers with `scope`
- `<caption>` describes table

**8. Interactive Components**
- Modals: `role="dialog"`, `aria-modal="true"`, focus trap
- Tabs: proper ARIA roles, keyboard arrows
- Dropdowns: `<select>` or proper ARIA
- Tooltips: triggered by focus (not hover-only)

**9. Motion & Responsiveness**
- Respect `prefers-reduced-motion`
- Works at 200% zoom
- Touch targets 44x44px minimum

**Output:** Findings by screen, organized by category

See `references/audit-categories.md` for detailed methodology.

---

## Phase 3: Group & Prioritize

**Goal:** Group patterns and create remediation plan

**Group by pattern:**
- "Missing focus indicators" - 8 occurrences
- "Icon buttons without labels" - 12 occurrences
- "No prefers-reduced-motion support" - 30+ animations

**Prioritize:**
- **P0 (Blocking):** Level A violations, breaks core functionality
- **P1 (High):** Level AA violations, major barrier
- **P2 (Medium):** Best practices, moderate barrier
- **P3 (Low):** Nice to have, minor improvements

**Remediation plan:**
1. **Quick Wins** (CSS + attributes, low risk)
2. **Low-Hanging Fruit** (simple markup changes)
3. **Structural** (complex changes, high impact)

**Present grouped findings and wait for approval.**

---

## Phase 4: Multi-Expert Review

**Goal:** Validate findings

**Review as 4 experts:**

1. **Accessibility Specialist:** WCAG conformance, severity correct?
2. **WordPress Expert:** WP patterns available? Native alternatives?
3. **Frontend Developer:** Effort estimates reasonable? Implementation feasible?
4. **UI Designer:** Visual impact? Alternatives that preserve design?

**Reconcile:** Agreements (confidence), disagreements (revise), final recommendations

**Output:** Validated findings with expert insights

---

## Phase 5: Educational Explanations

**Goal:** Add beginner-friendly context

**For each finding:**
- **What:** Issue description (plain language)
- **Why:** Why it matters (user impact)
- **Who:** Affected users (blind, low vision, keyboard, etc.)
- **How:** Fix steps (code example)
- **Testing:** How to verify fix
- **Resources:** Links to learn more

**Example:**
```markdown
### Finding: Icon buttons missing accessible names

**What:** Buttons with only icons have no text label for screen readers.

**Why:** Screen reader users hear "button" with no context about what it does.

**Who:** Blind users (screen readers), voice control users

**How:** Add aria-label:
`<button aria-label="Close dialog"><svg>...</svg></button>`

**Testing:** Use NVDA/VoiceOver, hear "Close dialog button"

**Resources:** [ARIA Button Pattern](...)
```

---

## Phase 6: Create GitHub Issues

**Goal:** Generate actionable issues

**Q:** Create directly or generate drafts?

**Master tracking issue:**
- Summary stats (P0/P1/P2/P3 counts)
- Findings by category
- Quick wins list
- Remediation timeline

**Individual issues (for each finding):**
```markdown
---
Title: [Accessibility] [Issue title]
Labels: accessibility, a11y, [P0|P1|P2|P3]
---

## Summary
[1-2 sentence description]

**Severity:** P[0-3]
**WCAG:** [Criterion]
**Screens:** [List]

## What's the Issue?
[Beginner explanation]

## Why This Matters
**Who:** [User groups]
**Impact:** [What breaks]

## How to Fix
**Approach:** [CSS|Attributes|Markup|UI]
**Complexity:** [Low|Medium|High]

[Code example]

## Testing Checklist
- [ ] Keyboard navigation
- [ ] Screen reader (NVDA/VoiceOver)
- [ ] Automated scan (axe DevTools)

## Resources
- [WCAG link]
- [ARIA patterns]
```

**Use GitHub CLI:**
```bash
gh issue create --title "[Accessibility] Issue title" --body-file /tmp/issue.md
```

See `templates/github-issue-template.md` for complete template.

---

## Phase 7: Optional Quick Wins PR

**Goal:** Implement low-risk fixes

**Q:** Implement Quick Wins? (CSS + attributes only, no markup changes)

**Wait for explicit approval.**

**Scope (Quick Wins only):**
- CSS fixes (focus indicators, prefers-reduced-motion)
- Attribute additions (aria-label, aria-invalid, aria-busy, alt text)
- NO markup changes
- NO layout changes
- NO visual changes

**Worktree setup:**
```bash
git fetch origin
REPO=$(basename $(git rev-parse --show-toplevel))
git worktree add ../${REPO}-accessibility-quick-wins -b chore/accessibility-quick-wins
cd ../${REPO}-accessibility-quick-wins
```

**Implementation:**
1. CSS fixes first
2. Attribute additions second
3. Per-file commits (small, logical)

**Per-file commits:**
```bash
git add src/components/button.tsx
git commit -m "a11y: add aria-busy to button loading state

- Screen readers now announce 'busy' during loading
- Fixes #123 (P1 - Button loading states)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

**Testing:**
- Manual keyboard navigation
- Screen reader testing (NVDA/VoiceOver)
- Automated scan (axe DevTools)
- Visual regression check

**Create PR:**
```bash
git push -u origin chore/accessibility-quick-wins

gh pr create \
  --base master \
  --title "Accessibility: Quick wins (CSS + attributes)" \
  --body "$(cat <<'EOF'
## Summary

Low-risk accessibility fixes (CSS + attributes only).

## Changes

- [List changes]

## Testing

- ✅ Keyboard navigation works
- ✅ Screen reader tested (NVDA/VoiceOver)
- ✅ axe DevTools passes
- ✅ No visual regressions

## Impact

Fixes [N] P0/P1 accessibility issues.

Generated with accessibility-audit skill v2.0.0
EOF
)"
```

**STOP if:** User hasn't approved or changes exceed Quick Wins scope

---

## Deliverables

**1. Findings Report** (`accessibility-audit-findings-[date].md`)
- Component inventory
- Findings by screen (9 categories)
- Findings by pattern
- Prioritization (P0/P1/P2/P3)
- Remediation roadmap

**2. GitHub Issues**
- Master tracking issue
- Individual issues (beginner-friendly)
- Testing checklists
- Code examples

**3. Testing Guide** (`accessibility-testing-guide.md`)
- Manual testing procedures
- Automated tool commands
- Screen reader basics
- Verification steps

**4. Optional PR** (Quick Wins only)
- CSS + attribute fixes
- Testing checklist
- No visual changes

---

## Testing Tools

**Automated:**
- **Storybook a11y addon:** Real-time scanning
- **axe DevTools:** Browser extension
- **Lighthouse:** Chrome DevTools
- **axe CLI:** `npm install -g @axe-core/cli`
- **pa11y CLI:** `npm install -g pa11y`

**Manual:**
- **Keyboard:** Tab, Shift+Tab, Enter, Space, Escape
- **NVDA (Windows):** Free screen reader
- **VoiceOver (Mac):** Built-in (Cmd+F5)
- **Zoom:** 200% browser zoom
- **Motion:** Enable "Reduce Motion" in OS settings

**Commands:**
```bash
# axe CLI scan
axe http://localhost:6006/?path=/story/button--primary

# pa11y scan
pa11y --standard WCAG2AA http://localhost:6006

# Lighthouse
lighthouse --only-categories=accessibility http://localhost:6006
```

See `references/testing-checklist.md` for complete procedures.

---

## Quality Checklist

Before marking complete:

- [ ] All high-priority screens audited
- [ ] 9 categories checked per screen
- [ ] Findings grouped by pattern
- [ ] Prioritization (P0/P1/P2/P3) complete
- [ ] Educational explanations added
- [ ] GitHub issues created
- [ ] Testing guide provided
- [ ] Optional PR tested (if created)
- [ ] No visual regressions
- [ ] Minimal-change principle followed

---

## WCAG 2.2 Quick Reference

**Level A (Must Have) - 30 criteria**
**Level AA (Should Have) - 18 criteria**
**Level AAA (Nice to Have) - 28 criteria**

**Focus:** A + AA = 48 criteria

**Common violations:**
- Missing alt text (1.1.1 Non-text Content)
- Poor heading structure (1.3.1 Info and Relationships)
- Color-only indicators (1.4.1 Use of Color)
- Insufficient contrast (1.4.3 Contrast Minimum)
- No keyboard access (2.1.1 Keyboard)
- No focus indicators (2.4.7 Focus Visible)
- Missing form labels (3.3.2 Labels or Instructions)
- No error identification (3.3.1 Error Identification)

See `references/wcag-2.2-quick-reference.md` for complete list.

---

## WordPress Patterns

**Gutenberg Components (accessible by default):**
- `wp.components.Button`
- `wp.components.Modal`
- `wp.components.TextControl`
- `wp.components.SelectControl`
- `wp.components.TabPanel`

**Screen Reader Announcements:**
```js
wp.a11y.speak('Settings saved'); // Polite
wp.a11y.speak('Error occurred', 'assertive'); // Urgent
```

**Focus Management:**
```js
wp.dom.focus.focusable.find(container); // Find focusable elements
```

See `references/wordpress-a11y-patterns.md` for complete patterns.

---

## References

Detailed guidance (keep extended content here):
- `references/00-index.md` - Navigation index
- `references/wcag-2.2-quick-reference.md` - All 48 criteria
- `references/audit-categories.md` - 9-category methodology
- `references/common-antipatterns.md` - Top 20 mistakes
- `references/testing-checklist.md` - Testing procedures
- `references/wordpress-a11y-patterns.md` - WP components
- `references/aria-patterns.md` - ARIA guidance
- `references/git-workflow.md` - Git best practices
- `templates/github-issue-template.md` - Issue format
- `templates/findings-report-template.md` - Report structure
- `templates/master-tracking-issue.md` - Tracking issue
- `examples/sample-findings-report.md` - Complete example
- `examples/sample-github-issue.md` - Sample issue

---

## Notes

- Minimal visual change (CSS → attributes → markup → UI)
- WCAG 2.2 Level AA only (48 criteria)
- WordPress native patterns preferred
- Evidence-based (test with real tools)
- Beginner-friendly explanations
- Small commits per phase
- Wait for approval at gates
- Write for long-term maintenance
