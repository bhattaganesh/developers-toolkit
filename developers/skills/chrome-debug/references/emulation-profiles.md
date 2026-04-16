# Device Emulation Profiles

Common device configurations for responsive testing.

---

## Mobile Devices

### iPhone SE (2nd gen)
```javascript
emulate({
  viewport: {
    width: 375,
    height: 667,
    deviceScaleFactor: 2,
    hasTouch: true,
    isMobile: true
  },
  userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15"
});
```

### iPhone 12/13/14
```javascript
emulate({
  viewport: {
    width: 390,
    height: 844,
    deviceScaleFactor: 3,
    hasTouch: true,
    isMobile: true
  }
});
```

### iPhone 12 Pro Max
```javascript
emulate({
  viewport: {
    width: 428,
    height: 926,
    deviceScaleFactor: 3,
    hasTouch: true,
    isMobile: true
  }
});
```

---

## Tablets

### iPad (9th gen)
```javascript
emulate({
  viewport: {
    width: 768,
    height: 1024,
    deviceScaleFactor: 2,
    hasTouch: true,
    isMobile: false
  }
});
```

### iPad Pro 11"
```javascript
emulate({
  viewport: {
    width: 834,
    height: 1194,
    deviceScaleFactor: 2,
    hasTouch: true,
    isMobile: false
  }
});
```

---

## Desktop

### Laptop (1366x768)
```javascript
emulate({
  viewport: {
    width: 1366,
    height: 768,
    deviceScaleFactor: 1,
    hasTouch: false,
    isMobile: false
  }
});
```

### Desktop (1920x1080)
```javascript
emulate({
  viewport: {
    width: 1920,
    height: 1080,
    deviceScaleFactor: 1,
    hasTouch: false,
    isMobile: false
  }
});
```

---

## Network Throttling

### Slow 3G
```javascript
emulate({
  networkConditions: "Slow 3G"  # ~400kbps
});
```

### Fast 3G
```javascript
emulate({
  networkConditions: "Fast 3G"  # ~1.6Mbps
});
```

### Slow 4G
```javascript
emulate({
  networkConditions: "Slow 4G"  # ~4Mbps
});
```

### Offline
```javascript
emulate({
  networkConditions: "Offline"
});
```

---

## Other Emulations

### Dark Mode
```javascript
emulate({
  colorScheme: "dark"
});
```

### Light Mode
```javascript
emulate({
  colorScheme: "light"
});
```

### Geolocation
```javascript
emulate({
  geolocation: {
    latitude: 37.7749,   # San Francisco
    longitude: -122.4194
  }
});
```

### CPU Throttling
```javascript
emulate({
  cpuThrottlingRate: 4  # 4x slowdown
});
```

---

## Combined Profiles

### Mobile Slow Connection
```javascript
emulate({
  viewport: {
    width: 375,
    height: 667,
    deviceScaleFactor: 2,
    hasTouch: true,
    isMobile: true
  },
  networkConditions: "Slow 3G",
  cpuThrottlingRate: 4
});
```

### Desktop High-DPI
```javascript
emulate({
  viewport: {
    width: 1920,
    height: 1080,
    deviceScaleFactor: 2,  # Retina display
    hasTouch: false,
    isMobile: false
  }
});
```

---

## See Also

- [decision-trees.md](./decision-trees.md) - When to use emulation
- [chrome-devtools-api.md](./chrome-devtools-api.md) - Emulate tool reference
