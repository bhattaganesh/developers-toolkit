# Security Fix Skill

**Version:** 2.0.0
**Status:** Stable
**Author:** Open Source Contributors

---

## Overview

The Security Fix Skill provides a comprehensive 10-phase workflow for handling WordPress security vulnerabilities in a systematic, backwards-compatible manner.

**Perfect for:**
- Handling bug bounty reports (HackerOne, Bugcrowd)
- Responding to security audits (Wordfence, Patchstack, WPScan)
- Fixing CVEs and security disclosures
- Implementing security patches in WordPress plugins/themes

---

## Features

### 🎯 Core Workflow (10 Phases)

1. **Initial Request** - Gather security report details
2. **Triage & Understanding** - Map vulnerability scope
3. **Evidence-Driven Scan** - Locate all affected code paths
4. **Solution Options** - Propose multiple approaches with tradeoffs
5. **Simulated Peer Review** - Multi-perspective validation
6. **Implementation** - Conservative, minimal-scope fix
7. **Deliverables** - Complete documentation package
8. **Post-Deployment Review** - Effectiveness validation

### ✨ Advanced Features

- **CVSS v3.1 Scoring** - Automated risk assessment
- **Defense in Depth** - 7-layer security model
- **Quality Gates** - Mandatory checkpoints at 3 phases
- **Decision Matrix** - Weighted approach selection
- **Process Metrics** - Track time, scope, quality
- **Professional Templates** - 4 deliverable templates

### 📚 Comprehensive References

- **14 Reference Guides** (216KB)
  - CVSS Scoring, Defense in Depth, Security Testing
  - WordPress Patterns, Gutenberg Security, Multisite Security
  - Security Headers, Rate Limiting, Security Logging
  - WordPress.org Compliance, Common Vulnerabilities

- **4 Professional Templates** (32KB)
  - Security Fix Summary
  - Security Validation Steps
  - Regression Test Checklist
  - Security Advisory

---

## Installation

```bash
# Clone the entire skills repository
cd ~/.claude/skills/
git clone https://github.com/bhattaganesh/developers-toolkit.git

# The security-fix skill will be at:
# ~/.claude/skills/developers-toolkit/developers/skills/security-fix/SKILL.md
```

Claude Code will automatically discover and load the skill.

---

## Usage

### Activation Triggers

The skill activates when you mention:
- "fix a security issue/vulnerability/bug"
- "handle a security report"
- "address this CVE"
- "security audit findings"
- "authentication bypass"
- "XSS", "SQL injection", "CSRF", "RCE", "IDOR"
- "nonce verification", "capability check"
- "sanitize inputs", "escape outputs"

### Example Conversations

**Basic Usage:**
```
You: "I need to fix this security report: [URL]"
Claude: [Loads security-fix skill and starts Phase 1]
```

**With Context:**
```
You: "We got a bug bounty report about IDOR in the REST API endpoint.
Can you help fix it?"
Claude: [Loads security-fix skill, requests report details]
```

---

## What You Get

### Phase 0.5: CVSS Risk Assessment
- Complete CVSS v3.1 base metrics evaluation
- Severity classification (Critical/High/Medium/Low)
- Response timeline determination

### Phase 3: Comprehensive Scan
Finds ALL instances of:
- Authentication gaps (`is_user_logged_in()`, nonce checks)
- Authorization missing (`current_user_can()`)
- Unsanitized inputs (`sanitize_*` functions)
- Unescaped outputs (`esc_html()`, `esc_attr()`, etc.)
- SQL injection risks (`$wpdb->prepare()`)
- REST API vulnerabilities
- AJAX handler security issues

### Phase 4: Decision Matrix
Weighted scoring across 4 dimensions:
- Security effectiveness (2x weight)
- Backwards compatibility (1x)
- Code maintainability (1x)
- Implementation simplicity (1x)

Automatic recommendation based on scoring.

### Phase 7: Professional Deliverables
1. **Security Fix Summary** - Complete documentation
2. **Security Validation Steps** - Testing procedures
3. **Regression Test Checklist** - Functional testing
4. **Security Advisory** - Public disclosure template

### Phase 8: Post-Deployment Review
- Effectiveness check (7 days after deployment)
- Metrics review and analysis
- Process reflection and improvements

---

## Operating Principles

1. **Backwards Compatibility First** - Only break if security requires it
2. **WordPress Native Patterns** - Use WP APIs, not custom solutions
3. **Conservative Scope** - Fix vulnerability only, avoid scope creep
4. **Defense in Depth** - Never rely on single security control
5. **Thoroughly Tested** - Unit tests + manual verification
6. **Well Documented** - Especially if behavior changes

---

## File Structure

```
security-fix/
├── SKILL.md                    # Main skill file (1,118 lines)
├── README.md                   # This file
├── references/                 # 14 reference guides (216KB)
│   ├── cvss-scoring.md
│   ├── defense-in-depth.md
│   ├── security-testing.md
│   ├── process-metrics.md
│   ├── wordpress-org-compliance.md
│   ├── security-headers.md
│   ├── rate-limiting.md
│   ├── security-logging.md
│   ├── wordpress-patterns.md
│   ├── gutenberg-security.md
│   ├── multisite-security.md
│   ├── common-vulnerabilities.md
│   ├── surerank-patterns.md
│   └── wp-security-checklist.md
├── templates/                  # 4 deliverable templates (32KB)
│   ├── security-fix-summary.md
│   ├── security-validation-steps.md
│   ├── regression-test-checklist.md
│   └── security-advisory.md
└── examples/
    └── sample-security-fix.md
```

---

## Version History

| Version | Date | Features |
|---------|------|----------|
| 1.0.0 | 2026-02-06 | Initial 7-phase workflow |
| 1.1.0 | 2026-02-06 | Quality gates, modern WP patterns |
| 1.2.0 | 2026-02-07 | CVSS scoring, defense in depth |
| 1.3.0 | 2026-02-07 | Process excellence, templates |
| 2.0.0 | 2026-02-07 | Advanced features, Phase 8 |

See [CHANGELOG.md](../../CHANGELOG.md) for detailed changes.

---

## Requirements

- **Claude Code** - Latest version
- **WordPress** - 5.0+ (patterns work with older versions too)
- **PHP** - 7.0+ (examples use modern syntax)

---

## Contributing

Found a bug or want to add patterns?

1. See main [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines
2. Submit PRs to the main repository
3. Add new vulnerability patterns to `references/common-vulnerabilities.md`
4. Share your security fix experiences!

---

## Support

- **Issues:** [GitHub Issues](https://github.com/bhattaganesh/developers-toolkit/issues)
- **Documentation:** [Skill Development Guide](../../docs/skill-development-guide.md)

---

## License

MIT License - See [LICENSE](../../LICENSE) for details.

---

**Made with 🔒 by Ganesh Bhatta**
