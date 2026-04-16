# Chrome Debug Mode Setup Guide

Complete guide to launching Chrome with remote debugging enabled.

---

## Quick Start

### macOS
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --headless
```

### Windows
```cmd
"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --headless
```

### Linux
```bash
google-chrome --remote-debugging-port=9222 --headless
```

---

## Command Options

### Required

**`--remote-debugging-port=9222`**
- Enables Chrome DevTools Protocol (CDP) on port 9222
- Required for MCP tools to connect
- Can use different port (e.g., 9223) if 9222 in use

### Optional

**`--headless`**
- Run Chrome without visible UI
- Faster, uses less resources
- Remove to see browser window (helpful for debugging)

**`--disable-gpu`**
- Disable GPU hardware acceleration
- Helpful on systems with GPU issues
- Required on some Linux systems without GPU

**`--no-sandbox`**
- Disable Chrome sandbox
- **Security risk** - only use in trusted environments
- Sometimes needed in Docker containers

**`--user-data-dir=/path/to/profile`**
- Use specific Chrome profile
- Isolate debugging session from main profile
- Keeps cookies/auth separate

**`--window-size=1920,1080`**
- Set initial window size
- Useful for consistent screenshots
- Only applies in non-headless mode

---

## Examples

### Development (with visible browser)
```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug

# Windows
chrome.exe --remote-debugging-port=9222 --user-data-dir=C:\Temp\chrome-debug

# Linux
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

### CI/CD (headless, isolated)
```bash
# macOS/Linux
google-chrome \
  --remote-debugging-port=9222 \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --user-data-dir=/tmp/chrome-ci

# Windows
chrome.exe --remote-debugging-port=9222 --headless --disable-gpu --no-sandbox --user-data-dir=C:\Temp\chrome-ci
```

### Docker Container
```bash
google-chrome \
  --remote-debugging-port=9222 \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --disable-dev-shm-usage
```

---

## Troubleshooting

### Cannot Connect to Chrome

**Symptom:** MCP tools fail with "Cannot connect to Chrome"

**Solutions:**
1. Check Chrome is running:
   ```bash
   # macOS/Linux
   lsof -i :9222

   # Windows
   netstat -ano | findstr :9222
   ```

2. Check correct port (default: 9222)

3. Try non-headless mode to see errors

4. Check firewall not blocking port 9222

### Port Already in Use

**Symptom:** Error "Address already in use"

**Solutions:**
1. Kill existing Chrome process:
   ```bash
   # macOS/Linux
   lsof -ti:9222 | xargs kill -9

   # Windows
   taskkill /F /PID <pid from netstat>
   ```

2. Use different port:
   ```bash
   --remote-debugging-port=9223
   ```

### Chrome Won't Start Headless

**Symptom:** Chrome fails in headless mode

**Solutions:**
1. Try with `--disable-gpu`:
   ```bash
   --headless --disable-gpu
   ```

2. Update Chrome to latest version

3. Check system requirements (headless needs modern OS)

### Page Won't Load

**Symptom:** `navigate_page` fails with timeout

**Solutions:**
1. Check URL correct (include `http://` or `https://`)

2. Verify network connectivity

3. Check for HTTPS certificate errors

4. Increase timeout in tool call

### Authentication Issues

**Symptom:** Page requires login but shows login screen

**Solutions:**
1. Use `--user-data-dir` with existing profile:
   ```bash
   --user-data-dir=~/.config/google-chrome/Default
   ```

2. Handle authentication dialog:
   ```
   handle_dialog with credentials
   ```

3. Set cookies before navigation

---

## Verifying Connection

### Check Chrome Responding
```bash
# Test connection
curl http://localhost:9222/json

# Expected output:
[
  {
    "description": "",
    "devtoolsFrontendUrl": "/devtools/inspector.html?ws=localhost:9222/...",
    "id": "...",
    "title": "New Tab",
    "type": "page",
    "url": "chrome://newtab/",
    "webSocketDebuggerUrl": "ws://localhost:9222/..."
  }
]
```

### Check in Claude Code
```
1. Launch Chrome with debug mode
2. In Claude Code: "Can you list Chrome pages?"
3. Should see list of open pages
```

---

## Platform-Specific Notes

### macOS

**Chrome Location:**
```
/Applications/Google Chrome.app/Contents/MacOS/Google Chrome
```

**Profile Location:**
```
~/Library/Application Support/Google/Chrome/Default
```

**Launch from Terminal:**
- Use escaped spaces: `Google\ Chrome`
- Or quote entire path: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"`

### Windows

**Chrome Location:**
```
C:\Program Files\Google\Chrome\Application\chrome.exe
```

**Profile Location:**
```
C:\Users\<username>\AppData\Local\Google\Chrome\User Data\Default
```

**Launch from Command Prompt:**
- Quote path if spaces: `"C:\Program Files\Google\Chrome\Application\chrome.exe"`

### Linux

**Chrome Locations:**
```
/usr/bin/google-chrome
/usr/bin/chromium-browser
```

**Profile Location:**
```
~/.config/google-chrome/Default
```

**Headless Requirements:**
- May need `--disable-gpu --no-sandbox`
- Update Chrome to latest version

---

## Security Considerations

### Sandbox Disabled

**Risk:** `--no-sandbox` disables Chrome's security sandbox

**When to use:**
- Docker containers (often required)
- CI/CD environments (trusted code)
- Local development (trusted sites)

**When NOT to use:**
- Browsing untrusted sites
- Production environments
- Shared systems

### Remote Debugging Port

**Risk:** Port 9222 exposes Chrome internals

**Mitigations:**
1. Bind to localhost only (default)
2. Use firewall to block external access
3. Don't expose on public networks
4. Use authentication if exposing remotely

### User Data Directory

**Risk:** Using main profile exposes cookies/auth

**Best Practice:**
- Use isolated profile: `--user-data-dir=/tmp/chrome-debug`
- Delete after debugging: `rm -rf /tmp/chrome-debug`
- Never commit profile to version control

---

## Advanced Configuration

### Custom Chrome Flags

```bash
# Disable web security (CORS) - testing only!
--disable-web-security

# Disable extensions
--disable-extensions

# Start maximized
--start-maximized

# Incognito mode
--incognito

# Proxy
--proxy-server="localhost:8080"

# User agent
--user-agent="Custom User Agent"
```

**Warning:** Many flags have security implications. Only use in trusted environments.

### Multiple Chrome Instances

```bash
# Instance 1 - Port 9222
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-1 &

# Instance 2 - Port 9223
google-chrome --remote-debugging-port=9223 --user-data-dir=/tmp/chrome-2 &
```

### Persistent Session

```bash
# Start Chrome
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug &

# Keep running in background
# Claude Code can connect/disconnect as needed
# Kill when done: killall chrome
```

---

## Quick Reference

| Flag | Purpose | Security Impact |
|------|---------|-----------------|
| `--remote-debugging-port=9222` | Enable CDP | Exposes Chrome internals |
| `--headless` | No UI | None |
| `--disable-gpu` | Disable GPU | None |
| `--no-sandbox` | Disable sandbox | **HIGH RISK** |
| `--user-data-dir` | Isolated profile | None |
| `--disable-web-security` | Disable CORS | **HIGH RISK** |
| `--incognito` | Private browsing | None |

---

## See Also

- [chrome-devtools-api.md](./chrome-devtools-api.md) - MCP tool catalog
- [decision-trees.md](./decision-trees.md) - Debugging workflows
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) - Official CDP docs
