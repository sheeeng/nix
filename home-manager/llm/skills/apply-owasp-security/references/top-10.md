# OWASP Top 10 (2021)

> Source: <https://owasp.org/Top10/>

## Reference Index

| ID | Name | One-line summary |
| ---- | ------ | ----------------- |
| A01 | Broken Access Control | Users act outside intended permissions; IDOR, missing authz checks |
| A02 | Cryptographic Failures | Sensitive data exposed due to weak or absent encryption |
| A03 | Injection | Untrusted data interpreted as code or commands (SQL, OS, LDAP, XSS) |
| A04 | Insecure Design | Missing threat modelling; security not built into the design |
| A05 | Security Misconfiguration | Insecure defaults, open cloud storage, verbose errors, missing headers |
| A06 | Vulnerable and Outdated Components | Libraries/frameworks with known CVEs still in use |
| A07 | Identification and Authentication Failures | Weak passwords, missing MFA, bad session management |
| A08 | Software and Data Integrity Failures | Unverified updates, unsafe deserialization, missing SRI |
| A09 | Security Logging and Monitoring Failures | Attacks not detected because events are not logged or alerted |
| A10 | Server-Side Request Forgery (SSRF) | Server fetches attacker-controlled URLs reaching internal systems |

## Verification Checklist

### A01 — Broken Access Control

- Every route/handler enforces authorization before processing.
- Object access by ID validates caller ownership (no IDOR).
- List endpoints filter to the caller's permitted objects.
- `CORS` is not `*` for credentialed requests.
- `JWT` signature, expiry, and audience are validated on every request.
- Privilege escalation paths do not exist (user cannot self-promote).
- Directory listing is disabled; sensitive files are not web-accessible.

### A02 — Cryptographic Failures

- Sensitive data is encrypted at rest and in transit.
- Passwords use `Argon2id`, `bcrypt` (factor ≥12), or `scrypt` — never `MD5`/`SHA-1`.
- `TLS 1.2+` enforced; `TLS 1.0`/`1.1` disabled.
- `HSTS` header set; HTTP redirects to HTTPS.
- Keys and secrets stored in env vars or a secrets manager — not in source.
- Security-sensitive random values use a CSPRNG.

### A03 — Injection

- All database queries use parameterized queries or prepared statements.
- No user input concatenated into SQL, shell commands, LDAP, or XPath.
- `eval`, `exec`, `spawn` do not receive user-controlled strings.
- Template engines do not render untrusted input as raw HTML.
- XML parsing disables external entities (`DOCTYPE`, `SYSTEM`, `PUBLIC`).

### A04 — Insecure Design

- Threat modelling performed for sensitive flows.
- Business logic enforces rate limits, quantity caps, and workflow ordering server-side.
- Sensitive operations (password reset, account deletion) require re-authentication.
- Account enumeration is not possible via timing or distinct error messages.
- Multi-step processes cannot be bypassed by skipping steps.

### A05 — Security Misconfiguration

- Security headers set: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`.
- Debug modes and stack traces disabled in production.
- Default credentials changed; unused features disabled.
- Cookie flags set: `HttpOnly`, `Secure`, `SameSite`.
- Cloud storage not publicly writable or listable.
- Dependencies pinned with lockfiles committed.

### A06 — Vulnerable and Outdated Components

- All dependencies up to date; no packages with known CVEs.
- `npm audit`, `pip audit`, `cargo audit`, or equivalent runs in CI.
- Unused dependencies removed.
- Container base images pinned to specific digests (not `latest`).
- Abandoned packages (no releases in 2+ years with open security issues) replaced.

### A07 — Identification and Authentication Failures

- Password minimum length ≥12; checked against known-breached lists.
- MFA available and enforced for privileged accounts.
- Session tokens invalidated on logout and after password change.
- Session IDs regenerated after successful authentication.
- Account lockout or exponential backoff on repeated failed logins.
- Password reset tokens are single-use, time-limited, sent to verified addresses only.

### A08 — Software and Data Integrity Failures

- CI/CD does not use unverified or unpinned external actions/scripts.
- Package lockfiles and integrity hashes used.
- Deserialization of untrusted data does not execute arbitrary code.
- Subresource Integrity (`SRI`) on externally loaded scripts and stylesheets.
- Auto-update mechanisms verify signed packages before installing.

### A09 — Security Logging and Monitoring Failures

- Authentication events (success, failure, lockout) logged with timestamp, user, IP.
- Logs do not contain passwords, tokens, full PAN/PII.
- High-value transactions and sensitive resource access audited.
- Logs stored separately from the application; tamper-evident.
- Alerts exist for repeated failures and anomalous access patterns.

### A10 — Server-Side Request Forgery (SSRF)

- Server-side URL fetching validated against an allowlist of permitted hosts.
- Internal metadata endpoints (`169.254.169.254`, `fd00:ec2::254`) blocked.
- Redirect-following in HTTP clients does not allow redirects to private addresses.
- `file://`, `gopher://`, `dict://` schemes rejected.
- DNS rebinding protections in place.
