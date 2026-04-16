# WordPress Accessibility Patterns

WordPress-native accessible components and patterns for Classic Editor and Gutenberg.

## WordPress Core Accessible Components

### Gutenberg (Block Editor) Components

All located in `@wordpress/components`:

```jsx
import {
  Button,
  Modal,
  TextControl,
  SelectControl,
  CheckboxControl,
  RadioControl,
  ToggleControl,
  TabPanel,
  Dropdown,
  Popover,
  Notice,
  __experimentalVStack as VStack,
  __experimentalHStack as HStack,
} from '@wordpress/components';
```

**Button** - Accessible button with variants
```jsx
<Button variant="primary" onClick={handleSave}>
  Save Settings
</Button>
```

**Modal** - Focus-trapped modal dialog
```jsx
<Modal
  title="Export Settings"
  onRequestClose={onClose}
>
  <p>Modal content here</p>
  <Button isPrimary onClick={onExport}>Export</Button>
</Modal>
```

**TextControl** - Input with label
```jsx
<TextControl
  label="Email Address"
  value={email}
  onChange={setEmail}
  type="email"
  help="We'll never share your email"
/>
```

**SelectControl** - Dropdown select
```jsx
<SelectControl
  label="Country"
  value={country}
  options={[
    { label: 'Select Country', value: '' },
    { label: 'USA', value: 'us' },
    { label: 'Canada', value: 'ca' },
  ]}
  onChange={setCountry}
/>
```

**CheckboxControl** - Checkbox with label
```jsx
<CheckboxControl
  label="Enable notifications"
  checked={enabled}
  onChange={setEnabled}
/>
```

**RadioControl** - Radio group
```jsx
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

**TabPanel** - Accessible tabs
```jsx
<TabPanel
  tabs={[
    { name: 'general', title: 'General' },
    { name: 'advanced', title: 'Advanced' },
  ]}
>
  {(tab) => <div>{tab.name} content</div>}
</TabPanel>
```

### Classic Editor Patterns

**Settings API** - Accessible forms
```php
add_settings_section(
  'my_section',
  'Section Title',
  'my_section_callback',
  'my-plugin'
);

add_settings_field(
  'my_field',
  'Field Label',
  'my_field_callback',
  'my-plugin',
  'my_section'
);

function my_field_callback() {
  $value = get_option('my_field');
  echo '<input type="text" id="my_field" name="my_field" value="' . esc_attr($value) . '">';
}
```

**List Tables** - WP_List_Table
```php
class My_List_Table extends WP_List_Table {
  function get_columns() {
    return [
      'title' => 'Title',
      'author' => 'Author',
    ];
  }
}
```

### Screen Reader Announcements

**wp.a11y.speak()** - Announce messages
```javascript
import { speak } from '@wordpress/a11y';

// Polite announcement (default)
speak('Settings saved successfully');

// Urgent announcement
speak('Error: Please fix validation errors', 'assertive');
```

### Focus Management

**Focus utilities**
```javascript
import { focus } from '@wordpress/dom';

// Find focusable elements
const focusable = focus.focusable.find(containerElement);

// Find tabbable elements
const tabbable = focus.tabbable.find(containerElement);

// Focus first focusable element
focusable[0]?.focus();
```

### Keyboard Handling

**Keycodes**
```javascript
import { ESCAPE, ENTER, SPACE, TAB } from '@wordpress/keycodes';

function handleKeyDown(event) {
  if (event.keyCode === ESCAPE) {
    closeModal();
  }
}
```

## Best Practices

1. **Always use WordPress components** when available (don't reinvent)
2. **Use wp.a11y.speak()** for status announcements (not custom aria-live)
3. **Use Settings API** for admin forms (handles labels, structure)
4. **Test with WP admin color schemes** (contrast requirements)
5. **Follow WordPress Coding Standards** for accessibility

## Resources

- [WordPress Accessibility Handbook](https://make.wordpress.org/accessibility/handbook/)
- [Gutenberg Components](https://developer.wordpress.org/block-editor/components/)
- [WordPress ARIA Guidelines](https://make.wordpress.org/accessibility/handbook/markup/aria/)
