# Accessibility Audit Skill

Comprehensive WCAG 2.2 Level AA accessibility auditing for WordPress plugins, themes, and websites.

## Overview

This skill performs systematic accessibility audits with a focus on:
- **Minimal visual changes** - prefer CSS/attribute fixes over layout changes
- **Beginner-friendly** - educational explanations for every finding
- **WordPress-specific** - understands WP patterns (Classic Editor + Gutenberg/Block Editor)
- **Actionable** - GitHub-ready issues with testing checklists and remediation plans

**What makes this audit different:**
- Prioritizes fixes that don't change UI layout or visual design
- Provides beginner-friendly explanations (teaches accessibility while auditing)
- Uses WordPress-native accessible components
- Includes automated AND manual testing
- Multi-expert review (4 perspectives: accessibility, WordPress, frontend, design)

---

## Features

### 9-Category Audit Methodology

Every screen is audited against 9 comprehensive categories:

1. **Semantic HTML & Landmarks** - Structure, headings, landmark regions
2. **Keyboard Navigation** - Tab order, keyboard access, no traps
3. **Focus Management** - Visible focus indicators, focus trapping in modals
4. **Screen Reader Support** - Alt text, labels, ARIA, announcements
5. **Color & Contrast** - Text and UI component contrast ratios
6. **Forms & Input** - Labels, required fields, error messages, autocomplete
7. **Tables** - Proper headers, captions, scope attributes
8. **Interactive Components** - Modals, tabs, dropdowns, accordions
9. **Motion & Responsiveness** - Reduced motion, zoom, responsive design

### Multi-Expert Review

Findings reviewed through 4 expert perspectives:
- **Accessibility Specialist** - WCAG conformance, screen reader impact
- **WordPress Developer** - WP patterns, core component usage
- **Frontend Developer** - Implementation effort, risk assessment
- **UI/UX Designer** - Visual impact, brand consistency

### Automated + Manual Testing

**Automated tools:**
- axe DevTools (browser extension)
- Lighthouse (Chrome DevTools)
- WAVE (browser extension)
- axe-core CLI / pa11y CLI

**Manual testing:**
- Keyboard navigation (Tab through all screens)
- Screen reader testing (NVDA Windows / VoiceOver Mac)
- Contrast checking (DevTools color picker)
- Zoom testing (200% browser zoom)

### Remediation Planning

Issues prioritized into 4 tiers:
- **P0 (Blocking)** - WCAG Level A violations, blocks users completely
- **P1 (High)** - WCAG Level AA violations, major accessibility barriers
- **P2 (Medium)** - Best practices, moderate impact
- **P3 (Low)** - Enhancements beyond WCAG AA

Remediation plan organized by effort:
- **Quick Wins** - High impact, low effort (CSS + attributes, 15-60 min)
- **Low-Hanging Fruit** - Attribute additions (1-2 hours)
- **Structural Fixes** - Markup changes (4-6 hours, review recommended)
- **UI Changes** - Layout/visual changes (design review required)

### Optional PR (Low-Risk Fixes)

Can optionally implement quick wins:
- ✅ CSS fixes (focus indicators, reduced motion, contrast)
- ✅ Attribute additions (alt text, ARIA labels, autocomplete)
- ❌ NO markup changes (requires code review)
- ❌ NO layout changes (requires design review)

---

## When to Use

Use this skill when you need to:

- Audit WordPress plugin/theme for WCAG 2.2 Level AA compliance
- Prepare for accessibility review or certification
- Fix accessibility issues before launch
- Improve keyboard navigation and screen reader support
- Meet accessibility requirements (ADA, Section 508, AODA, EN 301 549)
- Create actionable GitHub issues for accessibility improvements
- Understand accessibility basics while fixing issues

**Perfect for:**
- WordPress plugin developers preparing for wp.org directory submission
- Agencies building accessible client sites
- Teams pursuing WCAG compliance certification
- Developers learning accessibility fundamentals
- Product teams improving existing WordPress products

---

## Activation Triggers

The skill auto-activates when users say:

- "audit accessibility"
- "check WCAG compliance"
- "review accessibility"
- "a11y audit"
- "check screen reader support"
- "audit keyboard navigation"
- "WCAG 2.2 audit"
- "accessibility testing"

Or invoke directly:
```
/accessibility-audit
```

---

## Workflow (7 Phases)

### Phase 0: Gather Inputs
**Goal:** Collect repository info, local setup, key screens

**Asks for:**
- GitHub repository URL and base branch
- How to run locally (wp-env, Local, Docker, etc.)
- Local URL (e.g., http://localhost:8080)
- Optional: specific screens to prioritize

**Critical:** Requires running WordPress site for manual testing

---

### Phase 1: Screen Inventory → Approval Gate
**Goal:** Discover all user-facing screens

**Discovers:**
- Admin pages (`add_menu_page`, `add_submenu_page`, `add_meta_box`)
- Frontend UI (`add_shortcode`, `register_widget`, `register_block_type`)
- Modals and dialogs (React modals, custom modals)
- Forms (AJAX handlers, REST endpoints)

**Output:** Inventory table with screen ID, name, type, file path, priority

**Approval Gate:** Presents inventory, asks user to confirm scope

---

### Phase 2: 9-Category Audit
**Goal:** Systematically audit each screen

**For each screen:**
- Audit against all 9 categories
- Document findings with file paths and line numbers
- Cite WCAG criteria violated
- Suggest minimal-change fixes
- Test with keyboard, screen reader, automated tools

**Output:** Findings by screen with category checklist (✅ pass / ❌ fail)

---

### Phase 3: Group & Remediation → Approval Gate
**Goal:** Group issues into patterns and plan fixes

**Actions:**
- Group repeating issues (e.g., "Missing focus indicators - 8 occurrences")
- Assign severity (P0/P1/P2/P3)
- Determine fix approach (CSS → attributes → markup → UI)
- Create remediation plan (quick wins → structural)

**Approval Gate:** Presents grouped findings and remediation plan

---

### Phase 4: Multi-Expert Review
**Goal:** Review findings through 4 perspectives

**Perspectives:**
1. Accessibility Specialist - WCAG conformance, severity
2. WordPress Developer - WP patterns, component recommendations
3. Frontend Developer - Effort, risk, testing needs
4. UI/UX Designer - Visual impact, alternatives

**Output:** Reconciled recommendations with agreement/disagreement notes

---

### Phase 5: Educational Explanations
**Goal:** Add beginner-friendly explanations

**For each finding:**
- What the issue is (plain language)
- Why it matters (user impact)
- Who is affected (user groups)
- How to fix (code examples)
- How to test (practical steps)
- Resources to learn more

---

### Phase 6: GitHub Issues
**Goal:** Create GitHub-ready issues

**Asks:** Create directly or generate drafts?

**Creates:**
- Individual issues for each finding/pattern
- Master tracking issue with all findings
- Issues include:
  - Beginner explanation
  - Reproduction steps
  - Code fix with examples
  - Testing checklist
  - Acceptance criteria

---

### Phase 7: Optional PR → Approval Gate
**Goal:** Implement low-risk quick wins

**Scope (if user approves):**
- ✅ CSS fixes (focus, contrast, reduced motion)
- ✅ Attribute additions (alt, aria-label, autocomplete)
- ❌ NO markup changes
- ❌ NO layout changes

**Creates:**
- Git worktree in sibling directory
- Branch: `chore/accessibility-audit`
- Focused commits with detailed messages
- PR with verification steps and testing checklist

**Approval Gate:** Only creates PR if user explicitly approves

---

## Deliverables

### 1. Findings Report
**File:** `accessibility-audit-findings-YYYY-MM-DD.md`

**Contains:**
- Executive summary (X screens, Y findings, Z patterns)
- Scope and methodology
- Screen inventory table
- Findings by screen (all 9 categories)
- Findings grouped by pattern
- Remediation plan (quick wins → structural → UI)
- Educational explanations for each issue type
- Testing procedures

### 2. GitHub Issues
**Either:**
- Direct issues created in GitHub (if permissions available)
- Issue drafts ready to paste manually
- Master tracking issue with all findings linked

**Each issue includes:**
- Summary with severity and WCAG criterion
- Beginner-friendly explanation ("What's the issue?")
- User impact ("Why this matters")
- Reproduction steps
- Root cause analysis
- Suggested fix (code examples)
- Testing checklist
- Acceptance criteria
- Resources to learn more

### 3. Testing Guide
**File:** `accessibility-testing-guide.md`

**Contains:**
- Manual testing procedures (keyboard, screen reader, zoom)
- Automated testing commands (axe, pa11y, Lighthouse)
- How to install and use tools
- How to interpret results
- Common false positives
- Ongoing testing recommendations

### 4. Remediation PR (Optional)
**If implemented:**
- PR with low-risk quick wins (CSS + attributes)
- Before/after screenshots
- Testing checklist completed
- Verification steps for reviewers

---

## Example Conversation

```
User: Audit my WordPress plugin for accessibility

Skill:
I'll perform a comprehensive WCAG 2.2 Level AA audit.

First, I need a few inputs:
1. GitHub repository URL and base branch (dev or main)?
2. How do I run the plugin locally?
3. What's the local URL? (e.g., http://localhost:8080)
4. Any specific screens to focus on?

User: https://github.com/example/my-plugin, dev branch
      Run: wp-env start, then go to http://localhost:8080

Skill:
Perfect! Starting audit...

[Phase 1: Screen Inventory]
Found 8 screens:
- 3 admin pages (Settings, Meta Box, Dashboard Widget)
- 2 frontend UI (Contact Form shortcode, Recent Posts widget)
- 2 modals (Export Settings, Import Wizard)
- 1 Gutenberg block (Testimonial Block)

Proceed with full audit? (yes/no)

User: yes

Skill:
[Phase 2: 9-Category Audit]
[Performs systematic audit...]

[Phase 3: Grouped Findings]
Audit complete! Found 34 issues across 8 screens.

Grouped into 8 patterns:
1. Missing focus indicators (8 occurrences)
2. Icon buttons without labels (5 occurrences)
3. Images without alt text (12 occurrences)
...

Prioritization:
- P0 (Blocking): 2 issues
- P1 (High): 12 issues
- P2 (Medium): 15 issues
- P3 (Low): 5 issues

Quick wins available:
- Fix focus indicators → 8 issues (1 CSS change, 5 min)
- Add alt text → 12 images (attributes only, 30 min)
- Add aria-label → 5 buttons (attributes only, 10 min)

Total: 25 issues fixed in ~45 minutes (Low risk)

Proceed to multi-expert review? (yes/no)

User: yes

[Phases 4-6 complete]

Skill:
Created deliverables:
1. Findings report: accessibility-audit-findings-2026-02-07.md
2. GitHub issues: #122 (master), #123-#145 (individual)
3. Testing guide: accessibility-testing-guide.md

Want me to implement the quick wins? (25 issues, ~45 min, low risk)
- CSS fixes (focus indicators, reduced motion)
- Attribute additions (alt text, ARIA labels)
- NO markup or layout changes

(yes/no)

User: yes

Skill:
[Creates PR with quick wins]

Done! Created PR #146:
- Fixed 25 issues (74% of P1 findings)
- CSS + attributes only (no markup changes)
- All tests passing (keyboard, screen reader, axe)
- Ready for review

Remaining 9 issues require:
- 3 issues: markup changes (convert div buttons)
- 6 issues: design review (visible required indicators)

See tracking issue #122 for details.
```

---

## Requirements

### Local Environment
**CRITICAL:** Must be able to run WordPress site locally to test keyboard navigation, focus management, and screen reader support.

**Common setups:**
- **wp-env:** `wp-env start` → http://localhost:8080
- **Local (Flywheel):** Local app → custom domain
- **Docker:** `docker-compose up` → custom port
- **MAMP/XAMPP:** Local Apache/MySQL → http://localhost

### Tools (Optional but Recommended)

**Manual testing:**
- **NVDA** (Windows) - Free screen reader: https://www.nvaccess.org/
- **VoiceOver** (Mac) - Built-in screen reader: Cmd+F5
- **Browser DevTools** - For contrast checking (built-in)

**Automated testing:**
- **axe DevTools** - Browser extension: https://www.deque.com/axe/devtools/
- **Lighthouse** - Built into Chrome DevTools
- **WAVE** - Browser extension: https://wave.webaim.org/extension/
- **axe-core CLI** - `npm install -g @axe-core/cli`
- **pa11y CLI** - `npm install -g pa11y`

### Access
- **Read access** to codebase (required)
- **Write access** for PR creation (optional, for Phase 7)
- **GitHub token** for issue creation (optional, can generate drafts instead)

---

## File Structure

```
~/.claude/skills/accessibility-audit/
├── SKILL.md                           # Main workflow (1,400 lines)
├── README.md                          # This file (350 lines)
├── references/                        # 8 reference guides
│   ├── 00-index.md                    # Reference index
│   ├── wcag-2.2-quick-reference.md    # WCAG criteria
│   ├── wordpress-a11y-patterns.md     # WP components
│   ├── audit-categories.md            # 9 categories detailed
│   ├── common-antipatterns.md         # Top 20 mistakes
│   ├── testing-checklist.md           # Testing procedures
│   ├── aria-patterns.md               # ARIA guidance
│   └── git-workflow.md                # Git best practices
├── templates/                         # 3 output templates
│   ├── github-issue-template.md       # Individual issue format
│   ├── findings-report-template.md    # Report structure
│   └── master-tracking-issue.md       # Tracking issue format
└── examples/                          # 2 examples
    ├── sample-findings-report.md      # Complete audit example
    └── sample-github-issue.md         # Sample issue

Total: ~4,500 lines across 17 files
```

---

## Contributing

To improve this skill:

1. Fork the Claude Code skills repository
2. Make changes to `accessibility-audit/`
3. Test with real WordPress plugins/themes
4. Submit PR with:
   - Description of improvement
   - Example use case
   - Testing performed

**Areas for contribution:**
- Additional WordPress patterns
- More code examples
- Additional anti-patterns
- Improved testing procedures
- Better educational explanations

---

## Support

**Issues:** https://github.com/anthropics/claude-code/issues
**Documentation:** See `references/` directory for detailed guides
**Examples:** See `examples/` directory for sample outputs

**Common questions:**
- "Can I skip manual testing?" - No, automated tools miss ~30% of issues (keyboard traps, focus management, screen reader experience)
- "Do I need NVDA/VoiceOver?" - Highly recommended for accurate audit
- "Can this audit non-WordPress sites?" - Yes, but WordPress-specific features won't apply
- "What if I can't run the site locally?" - Some issues can be found via code inspection, but manual testing is critical

---

## Version History

**Current:** 1.0.0

### Changelog

**1.0.0** (2026-02-07) - Initial release
- 9-category audit methodology
- Multi-expert review (4 perspectives)
- WordPress Classic Editor + Gutenberg support
- Automated testing integration (axe, Lighthouse, WAVE, pa11y)
- Minimal-change remediation approach
- Beginner-friendly explanations
- Optional PR with quick wins
- 7-phase approval-gated workflow
- WCAG 2.2 Level AA compliance
- Educational explanations for all findings

---

## License

This skill is part of the Claude Code project. See LICENSE in the Claude Code repository.

---

**Remember:** Accessibility is not a checklist to complete once. It's an ongoing commitment to ensuring all users can access and use your WordPress plugin/theme effectively. Test with real assistive technologies and, when possible, with real users who rely on them.

> "The power of the Web is in its universality. Access by everyone regardless of disability is an essential aspect." - Tim Berners-Lee, W3C Director and inventor of the World Wide Web
