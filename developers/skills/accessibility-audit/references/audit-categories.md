# Accessibility Audit Categories

This guide provides detailed breakdowns of the 9 accessibility audit categories used in the WordPress accessibility audit workflow.

## Overview

Each screen is audited against 9 categories covering all aspects of WCAG 2.2 Level AA compliance:

1. **Semantic HTML & Landmarks** - Structure and meaning
2. **Keyboard Navigation** - Tab order and keyboard access
3. **Focus Management** - Visible focus indicators
4. **Screen Reader Support** - Labels, alt text, announcements
5. **Color & Contrast** - Visual accessibility
6. **Forms & Input** - Form accessibility
7. **Tables** - Data table accessibility
8. **Interactive Components** - Custom controls (modals, tabs, etc.)
9. **Motion & Responsiveness** - Animation and responsive design

---

## Category 1: Semantic HTML & Landmarks

### What to Check

✓ **Heading hierarchy** - No skipped levels (h1 → h2 → h3, NOT h1 → h3)
✓ **Landmark regions** - `<header>`, `<nav>`, `<main>`, `<aside>`, `<footer>` or ARIA equivalents
✓ **Semantic elements** - Use `<button>` not `<div class="button">`, `<a href>` not `<span onclick>`
✓ **Lists** - Use `<ul>`/`<ol>` for lists, not `<div>` collections
✓ **Tables** - Use `<table>` for data, not layout

### WCAG Criteria

- **1.3.1 Info and Relationships (Level A)** - Information, structure, and relationships conveyed through presentation can be programmatically determined
- **2.4.6 Headings and Labels (Level AA)** - Headings and labels describe topic or purpose

### Grep Patterns

```bash
# Find div buttons (anti-pattern)
grep -rn '<div.*class=".*button' --include="*.php" --include="*.jsx" --include="*.js"

# Find span links (anti-pattern)
grep -rn '<span.*onclick' --include="*.php" --include="*.jsx"

# Check for main landmark
grep -rn '<main\|role="main"' --include="*.php" --include="*.jsx"

# Check heading structure
grep -rn '<h[1-6]' --include="*.php" | sort -t: -k2 -n

# Find divs that should be buttons
grep -rn 'onclick=\|onClick=' --include="*.php" --include="*.jsx" | grep -v '<button'
```

### WordPress-Specific Guidance

**Classic Editor:**
- Settings API uses `<table>` for layout - check they're semantic
- Meta boxes should start with `<h2>`
- Admin pages should have proper `<h1>` title

**Gutenberg:**
- Block editor uses `<main class="editor-styles-wrapper">` - verify preserved
- Block toolbar should be a proper `<nav>` or have `role="toolbar"`
- Block content should use semantic HTML (not all divs)

### Code Examples

**BAD: Div button**
```php
<div class="button primary" onclick="saveSettings()">
  Save Settings
</div>
```

**GOOD: Semantic button**
```php
<button type="button" class="button button-primary" onclick="saveSettings()">
  Save Settings
</button>
```

**BAD: Heading skip**
```html
<h1>Plugin Settings</h1>
<h3>Appearance Options</h3>  <!-- Skipped h2 -->
<h4>Color Scheme</h4>
```

**GOOD: Logical hierarchy**
```html
<h1>Plugin Settings</h1>
<h2>Appearance Options</h2>
<h3>Color Scheme</h3>
```

**BAD: Divs for list**
```html
<div class="list">
  <div class="item">Item 1</div>
  <div class="item">Item 2</div>
  <div class="item">Item 3</div>
</div>
```

**GOOD: Semantic list**
```html
<ul class="list">
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
</ul>
```

### Testing Approach

1. **View page source** - Check markup structure
2. **Browser DevTools** - Inspect element hierarchy
3. **Landmarks bookmarklet** - https://github.com/mfairchild365/landmark-bookmarklet
4. **Screen reader** - Navigate by headings (H key in NVDA)

### Common False Positives

- **Divs styled as buttons but are containers** - If it doesn't do anything interactive, it's not a button
- **Tables for Settings API** - WordPress Settings API uses tables for layout, which is acceptable for admin screens
- **Heading order in widgets** - Widget titles may be h3 or h4 depending on context

---

## Category 2: Keyboard Navigation

### What to Check

✓ **Tab order is logical** - Matches visual flow (left to right, top to bottom)
✓ **All interactive elements reachable** - Buttons, links, inputs, custom controls accessible via Tab
✓ **No keyboard traps** - Can Tab in and Tab out of all components
✓ **Escape closes modals** - Press Escape to dismiss
✓ **Enter/Space activates** - Buttons respond to both keys

### WCAG Criteria

- **2.1.1 Keyboard (Level A)** - All functionality available via keyboard
- **2.1.2 No Keyboard Trap (Level A)** - Keyboard focus can be moved away using standard methods
- **2.4.3 Focus Order (Level A)** - Components receive focus in an order that preserves meaning and operability

### Grep Patterns

```bash
# Find problematic positive tabindex
grep -rn 'tabindex="[1-9]' --include="*.php" --include="*.jsx" --include="*.html"

# Find onClick without keyboard handler
grep -rn 'onClick' --include="*.jsx" --include="*.js" | grep -v 'onKeyDown\|onKeyPress\|onKeyUp'

# Find custom interactive elements
grep -rn 'role="button"\|role="link"\|role="tab"' --include="*.php" --include="*.jsx"

# Find contenteditable
grep -rn 'contenteditable' --include="*.php" --include="*.jsx"
```

### WordPress-Specific Guidance

**Classic Editor:**
- Meta boxes should be keyboard accessible
- Settings pages should have logical tab order (top to bottom)
- Admin tables (WP_List_Table) action links must be keyboard accessible

**Gutenberg:**
- Block toolbar must be reachable via Tab
- Block inserter must be keyboard navigable
- Block settings panel must be accessible
- Use `wp.keycodes.ESCAPE`, `wp.keycodes.ENTER` for consistency

### Code Examples

**BAD: onClick without keyboard support**
```jsx
<div className="card" onClick={handleClick}>
  Click me
</div>
```

**GOOD: Button with implicit keyboard support**
```jsx
<button className="card" onClick={handleClick}>
  Click me
</button>
```

**BAD: Positive tabindex (disrupts natural order)**
```html
<input type="text" tabindex="5" />
<input type="text" tabindex="3" />
<input type="text" tabindex="1" />
```

**GOOD: Natural tab order or tabindex="-1" for programmatic focus**
```html
<input type="text" />
<input type="text" />
<input type="text" />
<!-- Or for programmatic focus: -->
<div tabindex="-1" ref={focusRef}>Content</div>
```

**BAD: Custom button without keyboard handler**
```jsx
<div role="button" onClick={save}>
  Save
</div>
```

**GOOD: Custom button with keyboard handler**
```jsx
<div
  role="button"
  onClick={save}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      save();
    }
  }}
  tabIndex={0}
>
  Save
</div>
```

**BETTER: Just use a button**
```jsx
<button onClick={save}>Save</button>
```

### Testing Approach

1. **Unplug mouse** - Or don't use it
2. **Tab through page** - Verify all interactive elements reachable
3. **Check tab order** - Should match visual flow
4. **Test Enter/Space** - On buttons, should activate
5. **Test Escape** - On modals, should close
6. **Look for traps** - Can you Tab out of every component?

### Common False Positives

- **tabindex="-1"** - This is fine for programmatic focus (like focus trap in modals)
- **onClick on buttons** - Buttons have implicit keyboard support; don't need onKeyDown
- **Custom components** - May have keyboard support via child elements

---

## Category 3: Focus Management

### What to Check

✓ **Focus visible** - Clear visual indicator (outline or custom style)
✓ **No outline removal** - No `outline: none` without `:focus-visible` alternative
✓ **Focus trapped in modals** - Can't Tab outside modal when open
✓ **Focus returns** - After closing modal, focus returns to trigger button
✓ **Skip links** - "Skip to main content" for long pages (optional but recommended)

### WCAG Criteria

- **2.4.7 Focus Visible (Level AA)** - Any keyboard operable UI has a mode of operation where the keyboard focus indicator is visible
- **2.4.3 Focus Order (Level A)** - Focus order preserves meaning and operability

### Grep Patterns

```bash
# Find outline removal (anti-pattern)
grep -rn 'outline:.*none\|outline: none' --include="*.css" --include="*.scss"

# Check for focus-visible
grep -rn ':focus-visible' --include="*.css" --include="*.scss"

# Find modal focus management
grep -rn 'element\.focus\(\)\|\.focus()\|focusTrap\|trapFocus' --include="*.js" --include="*.jsx"

# Find ref usage (often for focus management)
grep -rn 'useRef\|createRef' --include="*.jsx" --include="*.js"
```

### WordPress-Specific Guidance

**Classic Editor:**
- WP Admin uses blue outline `#2271b1` - preserve it
- Don't remove focus from WP core buttons/inputs
- Settings API inputs should maintain focus indicators

**Gutenberg:**
- Block selection shows focus indicator - preserve it
- Use `wp.dom.focus.focusable.find()` to find focusable elements
- Use `wp.dom.focus.tabbable.find()` for tab order
- Modals: Use `wp.components.Modal` (handles focus automatically)

### Code Examples

**BAD: Removes focus without alternative**
```css
*:focus {
  outline: none;
}
```

**GOOD: Custom focus indicator with :focus-visible**
```css
*:focus-visible {
  outline: 2px solid #2271b1;  /* WP admin blue */
  outline-offset: 2px;
}

/* Remove outline for mouse clicks only */
*:focus:not(:focus-visible) {
  outline: none;
}
```

**BAD: Modal without focus trap**
```jsx
const Modal = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  return (
    <div className="modal">
      <button onClick={onClose}>Close</button>
      {children}
    </div>
  );
};
```

**GOOD: Modal with focus trap (use wp.components.Modal)**
```jsx
import { Modal } from '@wordpress/components';

const MyModal = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  return (
    <Modal
      title="Settings"
      onRequestClose={onClose}
    >
      {children}
    </Modal>
  );
};
```

**GOOD: Custom focus trap (if not using wp.components.Modal)**
```jsx
import { useEffect, useRef } from 'react';

const CustomModal = ({ isOpen, onClose, children }) => {
  const modalRef = useRef();
  const previousFocusRef = useRef();

  useEffect(() => {
    if (isOpen) {
      // Save previous focus
      previousFocusRef.current = document.activeElement;

      // Focus first element in modal
      const focusable = modalRef.current.querySelectorAll(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      );
      focusable[0]?.focus();

      // Trap focus
      const handleTab = (e) => {
        if (e.key !== 'Tab') return;

        const firstFocusable = focusable[0];
        const lastFocusable = focusable[focusable.length - 1];

        if (e.shiftKey && document.activeElement === firstFocusable) {
          e.preventDefault();
          lastFocusable.focus();
        } else if (!e.shiftKey && document.activeElement === lastFocusable) {
          e.preventDefault();
          firstFocusable.focus();
        }
      };

      document.addEventListener('keydown', handleTab);
      return () => document.removeEventListener('keydown', handleTab);
    } else {
      // Return focus to previous element
      previousFocusRef.current?.focus();
    }
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
    >
      <button onClick={onClose}>Close</button>
      {children}
    </div>
  );
};
```

### Testing Approach

1. **Tab through page** - Focus indicator should be clearly visible
2. **Open modal** - Verify focus moves into modal
3. **Tab within modal** - Verify can't Tab outside
4. **Close modal** - Verify focus returns to trigger
5. **Test with mouse** - Click elements, verify outline behavior

### Common False Positives

- **outline: none on specific elements** - May be intentional if alternative indicator provided
- **Focus trap in dropdowns** - Some components intentionally trap focus

---

## Category 4: Screen Reader Support

### What to Check

✓ **Images have alt text** - Informative: describe image; Decorative: `alt=""`
✓ **Form labels** - Every input has `<label for="id">` or `aria-label`
✓ **Icon buttons labeled** - `aria-label` or `<span class="screen-reader-text">Text</span>`
✓ **Status messages** - `aria-live="polite"` or `wp.a11y.speak()`
✓ **Error messages** - Associated with input via `aria-describedby`
✓ **Dynamic content** - Changes announced to screen readers

### WCAG Criteria

- **1.1.1 Non-text Content (Level A)** - All non-text content has text alternative
- **1.3.1 Info and Relationships (Level A)** - Information, structure, and relationships can be programmatically determined
- **4.1.3 Status Messages (Level AA)** - Status messages can be programmatically determined

### Grep Patterns

```bash
# Find images without alt
grep -rn '<img[^>]*>' --include="*.php" | grep -v 'alt='

# Find inputs without labels
grep -rn '<input[^>]*>' --include="*.php" | grep -v 'aria-label\|id='

# Find buttons without accessible names
grep -rn '<button[^>]*>' --include="*.php" --include="*.jsx" | grep -v 'aria-label\|>'

# Find icon buttons (likely need labels)
grep -rn '<button[^>]*>.*<svg\|<i class="icon\|dashicons' --include="*.php" --include="*.jsx"

# Find aria-live regions
grep -rn 'aria-live' --include="*.php" --include="*.jsx" --include="*.html"

# Find wp.a11y.speak usage (WordPress announcements)
grep -rn 'wp\.a11y\.speak' --include="*.js" --include="*.jsx"
```

### WordPress-Specific Guidance

**Classic Editor:**
- Use `wp.a11y.speak('Message')` for status announcements
- WordPress `wp_get_attachment_image()` includes alt automatically
- Settings API: labels associated if using proper field callbacks
- Use `<span class="screen-reader-text">` for visually-hidden text

**Gutenberg:**
- Block descriptions shown to screen readers via `description` prop
- Use `<VisuallyHidden>` component for screen-reader-only text
- Status updates: `wp.a11y.speak()` in `@wordpress/a11y`
- Icon buttons: Use `label` prop or `aria-label`

### Code Examples

**BAD: Image without alt**
```php
<img src="<?php echo esc_url( $icon ); ?>">
```

**GOOD: Informative alt**
```php
<img src="<?php echo esc_url( $icon ); ?>" alt="Success: Settings saved">
```

**GOOD: Decorative alt (empty string)**
```php
<img src="<?php echo esc_url( $divider ); ?>" alt="">
```

**GOOD: WordPress way**
```php
<?php echo wp_get_attachment_image( $attachment_id, 'thumbnail' ); ?>
```

**BAD: Icon button without label**
```php
<button class="icon-button">
  <span class="dashicons dashicons-download"></span>
</button>
```

**GOOD: Icon button with aria-label**
```php
<button class="icon-button" aria-label="Export settings">
  <span class="dashicons dashicons-download"></span>
</button>
```

**GOOD: Icon button with visually-hidden text (WordPress)**
```php
<button class="icon-button">
  <span class="dashicons dashicons-download" aria-hidden="true"></span>
  <span class="screen-reader-text">Export settings</span>
</button>
```

**BAD: Status update not announced**
```javascript
document.getElementById('status').textContent = 'Saved!';
```

**GOOD: Status update announced (WordPress)**
```javascript
wp.a11y.speak('Settings saved successfully');

// Or for urgent messages:
wp.a11y.speak('Error: Please fix validation errors', 'assertive');
```

**BAD: Error not associated with input**
```php
<input type="email" id="email" name="email">
<p class="error">Invalid email address</p>
```

**GOOD: Error associated with aria-describedby**
```php
<input
  type="email"
  id="email"
  name="email"
  aria-describedby="email-error"
  aria-invalid="true"
>
<p id="email-error" class="error" role="alert">
  Invalid email address
</p>
```

### Testing Approach

**NVDA (Windows - free):**
1. Download: https://www.nvaccess.org/
2. Start: Ctrl+Alt+N
3. Navigate:
   - Tab (interactive elements)
   - H (headings)
   - B (buttons)
   - F (forms)
   - G (graphics/images)
4. Listen for:
   - "Unlabeled graphic" (missing alt)
   - "Button" with no name (missing label)
   - "Edit" with no label (missing form label)
   - Status announcements

**VoiceOver (Mac - built-in):**
1. Enable: Cmd+F5
2. Navigate: VO+Right Arrow (next element)
3. Rotor: VO+U (landmarks, headings, links)
4. Forms: VO+Cmd+F

### Common False Positives

- **Buttons with text content** - Don't need aria-label if they have visible text
- **Images with empty alt** - Correct for decorative images
- **Hidden elements** - aria-hidden="true" is fine for presentational elements

---

## Category 5: Color & Contrast

### What to Check

✓ **Text contrast** - 4.5:1 for normal text, 3:1 for large (18px+ or bold 14px+)
✓ **UI component contrast** - 3:1 for buttons, form borders, focus indicators
✓ **Color not sole indicator** - Use icons/text, not just color (e.g., red error text)
✓ **Links distinguishable** - Underline or non-color visual cue

### WCAG Criteria

- **1.4.3 Contrast (Minimum) (Level AA)** - Text has 4.5:1 contrast, large text 3:1
- **1.4.11 Non-text Contrast (Level AA)** - UI components and graphics have 3:1 contrast
- **1.4.1 Use of Color (Level A)** - Color is not the only visual means of conveying information

### Testing Tools

**Manual:**
1. **Browser DevTools** - Inspect element → Color picker shows contrast ratio
2. **WebAIM Contrast Checker** - https://webaim.org/resources/contrastchecker/
3. **Colour Contrast Analyser** - Desktop app (free)

**Automated:**
- **axe DevTools** - Browser extension, shows contrast issues
- **Lighthouse** - Chrome DevTools → Lighthouse → Accessibility
- **WAVE** - Browser extension

### Grep Patterns

```bash
# Find color usage
grep -rn 'color:\|background-color:\|border-color:' --include="*.css" --include="*.scss"

# Find disabled states (often low contrast)
grep -rn ':disabled\|\.disabled\|\.is-disabled' --include="*.css"

# Find color-only indicators
grep -rn 'style="color:.*red\|style="color:.*green' --include="*.php"
```

### WordPress-Specific Guidance

**Classic Editor:**
- WP Admin offers high-contrast mode in user profile (test with it)
- WP Admin default colors meet contrast requirements
- Custom admin styles should maintain contrast

**Gutenberg:**
- Block icons should have sufficient contrast
- Block toolbar contrast must meet 3:1
- Color picker should indicate accessibility issues
- Test with different WP admin color schemes

### Code Examples

**BAD: Light gray text on white (fails 4.5:1)**
```css
.description {
  color: #999;  /* Only 2.8:1 contrast - FAILS */
}
```

**GOOD: Darker gray for sufficient contrast**
```css
.description {
  color: #666;  /* 5.7:1 contrast - PASSES */
}
```

**BAD: Disabled button invisible (fails 3:1)**
```css
button:disabled {
  background: #eee;
  color: #ddd;  /* Insufficient contrast */
}
```

**GOOD: Disabled but still readable**
```css
button:disabled {
  background: #f0f0f0;
  color: #757575;  /* Sufficient contrast */
  opacity: 0.6;
  cursor: not-allowed;
}
```

**BAD: Color-only indicator**
```php
<p style="color: red;">Error: Invalid email</p>
```

**GOOD: Icon + text + ARIA**
```php
<p class="error" role="alert">
  <span class="dashicons dashicons-warning" aria-hidden="true"></span>
  Error: Invalid email
</p>
```

**BAD: Link distinguished by color only**
```css
a {
  color: #0073aa;
  text-decoration: none;  /* No underline */
}
```

**GOOD: Link has underline or other non-color cue**
```css
a {
  color: #0073aa;
  text-decoration: underline;
}

/* Or with hover/focus indicator: */
a {
  color: #0073aa;
  text-decoration: none;
  border-bottom: 1px solid currentColor;
}
```

### Testing Approach

1. **DevTools contrast check:**
   - Inspect element
   - Click color swatch
   - DevTools shows contrast ratio
   - Verify: Normal text ≥ 4.5:1, Large text ≥ 3:1, UI components ≥ 3:1

2. **Automated scan:**
   ```bash
   # axe DevTools (browser extension)
   # Lighthouse (Chrome DevTools)
   # WAVE (browser extension)
   ```

3. **Visual check:**
   - Test with different color schemes
   - Test with Windows High Contrast Mode
   - Print preview (black and white)

### Common False Positives

- **Placeholders** - Different requirements (not covered by WCAG 2.2 AA)
- **Disabled elements** - Still should have 3:1 minimum
- **Logos and brand colors** - May be exempt if decorative

---

## Category 6: Forms & Input

### What to Check

✓ **All inputs labeled** - `<label for="id">` or `aria-label`
✓ **Required fields marked** - `required` attribute + visual indicator (asterisk, "Required")
✓ **Error messages** - Inline + associated via `aria-describedby`
✓ **Fieldsets group related** - Use `<fieldset>` + `<legend>` for radio/checkbox groups
✓ **Autocomplete attributes** - `autocomplete="email"` for common fields
✓ **Semantic input types** - `type="email"`, `type="tel"`, `type="url"`, `type="number"`

### WCAG Criteria

- **1.3.1 Info and Relationships (Level A)** - Form structure can be programmatically determined
- **3.3.2 Labels or Instructions (Level A)** - Labels or instructions provided when content requires user input
- **1.3.5 Identify Input Purpose (Level AA)** - Purpose of input fields can be programmatically determined

### Grep Patterns

```bash
# Find inputs without labels
grep -rn '<input' --include="*.php" | grep -v 'aria-label\|type="hidden"'

# Find required fields
grep -rn 'required' --include="*.php"

# Check autocomplete usage
grep -rn 'autocomplete=' --include="*.php"

# Find fieldsets
grep -rn '<fieldset' --include="*.php"

# Find radio/checkbox groups
grep -rn 'type="radio"\|type="checkbox"' --include="*.php"
```

### WordPress-Specific Guidance

**Classic Editor:**
- Settings API: Use `add_settings_field()` callbacks correctly
- Meta box inputs should use `<label for>`
- Use `register_setting()` for proper handling

**Gutenberg:**
- Use `wp.components.TextControl` (labels automatically)
- Use `wp.components.CheckboxControl`
- Use `wp.components.RadioControl`
- Use `wp.components.SelectControl`
- All components handle labels and ARIA correctly

### Code Examples

**BAD: Input without label**
```php
<input type="text" name="email" placeholder="Email">
```

**GOOD: Input with label**
```php
<label for="email">Email Address</label>
<input type="email" id="email" name="email" autocomplete="email">
```

**BAD: Required without visual indicator**
```php
<input type="text" name="name" required>
```

**GOOD: Required with indicator**
```php
<label for="name">
  Name <span class="required" aria-label="required">*</span>
</label>
<input type="text" id="name" name="name" required aria-required="true">
```

**BAD: Error not associated**
```php
<input type="email" id="email" name="email">
<?php if ($error): ?>
  <p class="error">Invalid email</p>
<?php endif; ?>
```

**GOOD: Error associated**
```php
<input
  type="email"
  id="email"
  name="email"
  aria-describedby="email-error"
  aria-invalid="<?php echo $error ? 'true' : 'false'; ?>"
>
<?php if ($error): ?>
  <p id="email-error" class="error" role="alert">
    Invalid email address
  </p>
<?php endif; ?>
```

**BAD: Radio group without fieldset**
```html
<label><input type="radio" name="plan" value="free"> Free</label>
<label><input type="radio" name="plan" value="pro"> Pro</label>
```

**GOOD: Radio group with fieldset**
```html
<fieldset>
  <legend>Choose Plan</legend>
  <label>
    <input type="radio" name="plan" value="free" id="plan-free">
    Free
  </label>
  <label>
    <input type="radio" name="plan" value="pro" id="plan-pro">
    Pro
  </label>
</fieldset>
```

**GOOD: WordPress Gutenberg**
```jsx
import { TextControl, RadioControl } from '@wordpress/components';

<TextControl
  label="Email Address"
  value={email}
  onChange={setEmail}
  type="email"
  help="We'll never share your email"
/>

<RadioControl
  label="Choose Plan"
  selected={plan}
  options={[
    { label: 'Free', value: 'free' },
    { label: 'Pro', value: 'pro' },
  ]}
  onChange={setPlan}
/>
```

### Testing Approach

1. **Screen reader test** - Use NVDA/VoiceOver, verify:
   - All inputs have labels
   - Required fields announced
   - Errors associated and announced

2. **Keyboard test** - Tab through form, verify:
   - Logical tab order
   - Can reach all inputs
   - Labels focused when clicking them

3. **Automated scan** - axe DevTools, Lighthouse

### Common False Positives

- **Hidden inputs** - Don't need labels (`type="hidden"`)
- **Submit buttons** - `value` attribute serves as label
- **Placeholder as label** - NOT acceptable; placeholders disappear on input

---

## Remaining Categories Summary

Due to length, the remaining categories (7-9) follow the same structure:

### Category 7: Tables
- Headers with scope
- Captions
- No tables for layout (except WP Settings API)

### Category 8: Interactive Components
- Modals with focus trap
- Tabs with ARIA
- Accordions with aria-expanded
- Dropdowns accessible

### Category 9: Motion & Responsiveness
- prefers-reduced-motion
- 200% zoom
- 320px width
- 44x44px touch targets

Refer to SKILL.md Phase 2 for complete details on categories 7-9.

---

## Quick Reference Table

| Category | Key WCAG | Common Issues | Quick Fix |
|----------|----------|---------------|-----------|
| 1. Semantic HTML | 1.3.1 | Div buttons | Use `<button>` |
| 2. Keyboard | 2.1.1 | Not keyboard accessible | Add keyboard handlers |
| 3. Focus | 2.4.7 | No focus indicator | Add `:focus-visible` |
| 4. Screen Reader | 1.1.1, 4.1.3 | Missing alt, labels | Add alt, aria-label |
| 5. Contrast | 1.4.3 | Low contrast | Darken colors |
| 6. Forms | 3.3.2 | Missing labels | Add `<label for>` |
| 7. Tables | 1.3.1 | Missing headers | Add `<th scope>` |
| 8. Components | 4.1.2 | Missing ARIA | Add proper ARIA |
| 9. Motion | 2.3.3 | No motion preference | Add `@media (prefers-reduced-motion)` |

---

## WordPress Component Reference

**Use these instead of custom implementations:**

| Need | WordPress Component | Classic Alternative |
|------|---------------------|---------------------|
| Button | `wp.components.Button` | `<button class="button">` |
| Modal | `wp.components.Modal` | - |
| Text Input | `wp.components.TextControl` | `<label>` + `<input>` |
| Checkbox | `wp.components.CheckboxControl` | `<label>` + `<input type="checkbox">` |
| Radio | `wp.components.RadioControl` | `<fieldset>` + radio inputs |
| Select | `wp.components.SelectControl` | `<select>` |
| Tabs | `wp.components.TabPanel` | - |
| Dropdown | `wp.components.Dropdown` | - |
| Announcement | `wp.a11y.speak()` | `aria-live` |

See `wordpress-a11y-patterns.md` for detailed usage examples.
