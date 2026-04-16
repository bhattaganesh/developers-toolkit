# Common Accessibility Anti-Patterns

Top 20 accessibility mistakes in WordPress with fixes.

## 1. Div Button
**Bad:**
```html
<div class="button" onclick="save()">Save</div>
```
**Fix:** Use `<button>` - Free keyboard support, ARIA
```html
<button onclick="save()">Save</button>
```

## 2. Missing Focus Indicator
**Bad:**
```css
*:focus { outline: none; }
```
**Fix:** Use :focus-visible
```css
*:focus-visible { outline: 2px solid #2271b1; }
```

## 3. Icon Button Without Label
**Bad:**
```html
<button><i class="dashicons dashicons-download"></i></button>
```
**Fix:** Add aria-label
```html
<button aria-label="Download"><i class="dashicons dashicons-download"></i></button>
```

## 4. Image Without Alt
**Bad:**
```html
<img src="icon.png">
```
**Fix:** Add alt (or empty for decorative)
```html
<img src="icon.png" alt="Success">
<!-- Or: -->
<img src="divider.png" alt="">
```

## 5. Input Without Label
**Bad:**
```html
<input type="text" placeholder="Email">
```
**Fix:** Use label element
```html
<label for="email">Email</label>
<input type="email" id="email">
```

## 6-20: See full antipatterns in audit-categories.md

Resources:
- [WebAIM Articles](https://webaim.org/articles/)
- [WordPress Accessibility](https://make.wordpress.org/accessibility/)
