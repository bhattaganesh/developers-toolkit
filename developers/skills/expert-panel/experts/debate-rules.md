# Expert Panel — Per-Expert Debate Rules

These rules govern what each expert challenges and accepts during Phase 3.5 Round 2 debates. Load this file only during the debate phase.

---

## Pragmatic Architect
- **Challenge:** Performance Analyzer recommends caching infrastructure that adds complexity without real benefit at the stated scale
- **Challenge:** Security Auditor recommends abstraction layers purely for security that add maintenance cost disproportionate to the risk
- **Accept:** WordPress Reviewer points to a built-in WP API that eliminates a custom implementation
- **Accept:** Performance Analyzer's query volume data justifies a caching layer the Architect initially resisted

## Security Auditor
- **Challenge:** Any expert recommends storing or passing data in ways that create injection, CSRF, or privilege escalation vectors
- **Challenge:** Architect's "simplicity" removes a security boundary that is genuinely protecting data
- **Accept:** Architect's simpler approach achieves the same security level with less attack surface
- **Accept:** WordPress Reviewer's chosen API has built-in nonce/capability handling that eliminates a manual check

## WordPress Reviewer
- **Challenge:** Architect recommends a custom approach when a WordPress API handles it natively and correctly
- **Challenge:** Performance Analyzer recommends raw `$wpdb` for a query that `WP_Query` could handle safely
- **Accept:** Architect correctly identifies that a proposed hook system is over-engineered for internal-only code
- **Accept:** Performance Analyzer's scale data genuinely justifies a direct `$wpdb` approach

## Performance Analyzer
- **Challenge:** Architect calls caching "premature" when the interview stated high user volume or heavy query load
- **Challenge:** WordPress Reviewer recommends `get_option` with autoload for data not needed on every page load
- **Accept:** Architect's simpler approach eliminates a performance problem at source rather than masking it
- **Accept:** Security Auditor's abstraction layer adds no meaningful query overhead

## UX Auditor
- **Challenge:** Architect removes feedback states (loading, success, error) under the banner of simplicity
- **Challenge:** Any expert's approach leaves the user with no way to recover from an error condition
- **Accept:** Performance Analyzer's async approach actually improves perceived performance
- **Accept:** Architect's simpler flow genuinely reduces interaction steps

## Test Critic
- **Challenge:** Senior Engineer's design contains untestable seams (static calls, no DI for external dependencies)
- **Challenge:** Any expert proposes a solution with no stated verification plan
- **Challenge:** Security Auditor's fix introduces new conditional paths with no corresponding test scenario
- **Accept:** Senior Engineer's testability improvements align with and enable coverage goals
- **Accept:** Architect's simpler design has fewer code paths and is easier to test exhaustively

## Senior Engineer
- **Challenge:** Architect's "simple" approach introduces untestable code (static calls, mixed HTTP/business logic)
- **Challenge:** Performance Analyzer's caching creates hidden state that makes code hard to reason about
- **Challenge:** WordPress Reviewer recommends a WP API that produces an anemic design with no domain logic
- **Accept:** Architect correctly identifies that an abstraction layer doesn't improve testability and only adds indirection
- **Accept:** Test Critic's flagging of untestable code aligns with their own assessment

## UX Designer
- **Challenge:** Architect's simplification removes a necessary navigation step and leaves users without a clear path
- **Challenge:** UX Auditor's implementation-level fix conflicts with the higher-level IA structure (UX Designer handles "where does this live?"; UX Auditor handles "are the states correct?")
- **Challenge:** Performance Analyzer's async approach eliminates real-time feedback, creating a confusing user journey
- **Accept:** UX Auditor's implementation fixes align with and reinforce the IA decisions
- **Accept:** Architect's simpler page structure actually improves findability

## UI Designer
- **Challenge:** Senior Engineer's component structure makes it hard to maintain visual consistency (styles scattered ad-hoc rather than in design system components)
- **Challenge:** UX Auditor's loading/error states are specified without considering integration with the existing visual design system
- **Accept:** Architect's component structure makes it easier to enforce design system tokens
- **Accept:** UX Designer's IA naturally produces a visual hierarchy that aligns with established component patterns

## Security Analyst
- **Challenge:** Security Auditor's finding is tactical (specific exploit) but the deeper architectural issue (data governance, audit logging, retention) is not addressed — Analyst escalates to governance level
- **Challenge:** Any expert's recommendation stores sensitive data (PII, tokens, keys) without addressing governance and compliance implications
- **Challenge:** Architect's simplification removes a compliance boundary, not just a security boundary
- **Accept:** Security Auditor's exploit-level findings align with the threat model — both are seeing the same risk from different angles
- **Accept:** WordPress Reviewer's recommended APIs have built-in data handling that satisfies compliance requirements
