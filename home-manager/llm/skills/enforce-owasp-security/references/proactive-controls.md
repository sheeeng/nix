# OWASP Proactive Controls (2024)

> Source: <https://owasp.org/www-project-proactive-controls/>

## Reference Index

| ID | Name | One-line summary |
| ---- | ------ | ----------------- |
| C1 | Implement Access Control | Centralized, deny-by-default, server-side authorization |
| C2 | Use Cryptography the Right Way | Vetted libraries, authenticated encryption, CSPRNG, adaptive password hashing |
| C3 | Validate All Input | Allowlist validation at every trust boundary; context-specific output encoding |
| C4 | Address Security from the Start | Threat modelling, least privilege, design for failure |
| C5 | Secure by Default Configurations | No debug in prod, secrets out of source, framework security features enabled |
| C6 | Keep Security Simple | Standard primitives over custom implementations; isolate security-critical code |
| C7 | Identify and Fix Security Issues | SAST + dependency scanning in CI; Critical/High findings block merges |
| C8 | Implement Digital Identity | Proven auth libraries, strong sessions, MFA for privileged accounts |
| C9 | Implement Logging and Monitoring | Structured security event logs; never log secrets; alert on anomalies |
| C10 | Stop External Systems Compromising Your App | Treat external data as untrusted; enforce timeouts; validate TLS |

## Verification Checklist

### C1 — Access Control

- Policy defined centrally, not scattered; default deny.
- Authorization re-validated on every state-changing operation.
- All access control failures logged.
- Enforcement is server-side only.

### C2 — Cryptography

- No custom crypto; use `libsodium`, `Bouncy Castle`, `cryptography.io`, or equivalent.
- Authenticated encryption (`AES-GCM`, `ChaCha20-Poly1305`) for confidentiality + integrity.
- CSPRNG for all security-sensitive random values.
- Passwords hashed with `Argon2id` (preferred), `bcrypt` (factor ≥12), or `scrypt`.
- Key rotation strategy defined and implemented.

### C3 — Input Validation

- Allowlist (expected characters/formats) not denylist.
- Validate type, length, format, range at the trust boundary.
- Reject and log malformed input; do not silently coerce.
- Output encoded for context: HTML, URL, SQL parameterization.

### C4 — Security from the Start

- Threat model exists for new features handling sensitive data.
- Trust boundaries identified and documented.
- Principle of least privilege applied.

### C5 — Secure Defaults

- Debug/verbose modes disabled in production.
- Required security config validated at startup; fail fast on missing values.
- Secrets in env vars or secrets manager (`Vault`, `AWS SSM`, `SOPS`).
- Framework security features (CSRF, XSS filtering) not overridden.

### C6 — Simplicity

- Standard library/framework primitives used (prepared statements, ORM parameterization).
- Security-critical code isolated; failures contained.

### C7 — Find and Fix Issues

- SAST (`Semgrep`, `CodeQL`, `Bandit`, `Brakeman`) runs in CI.
- Dependency scanning (`npm audit`, `pip-audit`, `Trivy`, `Grype`) runs in CI.
- Critical and High findings block merges.
- Fixes verified with a test that reproduces the original issue.

### C8 — Digital Identity

- Proven identity library/provider used; no hand-rolled authentication.
- Session IDs cryptographically random (≥128 bits); regenerated after login; expire on inactivity.
- MFA enforced for privileged and sensitive-data accounts.
- Account recovery flows use time-limited, single-use, verified-channel tokens.

### C9 — Logging and Monitoring

- Security events logged (auth attempts, authz failures, input rejections, privilege changes).
- Structured logs (JSON) with UTC timestamp, user/session ID, IP, action, outcome.
- No sensitive data in logs (passwords, tokens, PAN, PII).
- Append-only log storage separate from app data.
- Alerting thresholds defined for brute force, mass access, and privilege escalation.

### C10 — External Systems

- All external data treated as untrusted input; validated and sanitized.
- Least privilege for service accounts and database users.
- Timeouts and circuit breakers on all external calls.
- TLS certificates validated on all outbound connections.
