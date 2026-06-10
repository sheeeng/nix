---
name: owasp-security
description: Verify code against OWASP recommendations. Covers Top 10, API Security Top 10, ASVS, Cheat Sheets, and Proactive Controls. Applies the relevant areas based on context.
license: MIT
compatibility: opencode
metadata:
    audience: developers
    workflow: security
---

# OWASP Security

## What This Skill Does

- Apply OWASP security standards to any code change, review, or design decision.
- Select the relevant OWASP area automatically based on context (see below).
- Provide actionable, code-level findings with remediations and severity ratings.
- Reference both embedded checklists and canonical OWASP sources.

## Context Detection — Which Area to Apply

Read the context and activate the relevant section(s). Multiple sections may apply.

| Context | Apply |
| --------- | ------- |
| Web app routes, templates, forms, sessions, auth | [OWASP Top 10 (2021)](#owasp-top-10-2021) |
| REST, GraphQL, gRPC, WebSocket endpoints | [OWASP API Security Top 10 (2023)](#owasp-api-security-top-10-2023) |
| Any implementation task (crypto, input, logging) | [OWASP Proactive Controls (2024)](#owasp-proactive-controls-2024) |
| Formal verification or compliance review | [OWASP ASVS (v4)](#owasp-application-security-verification-standard-asvs-v4) |
| Looking up a specific defense pattern | [OWASP Cheat Sheet Series](#owasp-cheat-sheet-series) |

---

## OWASP Top 10 (2021)

> Source: <https://owasp.org/Top10/>

### Reference Index

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

### Verification Checklist

#### A01 — Broken Access Control

- Every route/handler enforces authorization before processing.
- Object access by ID validates caller ownership (no IDOR).
- List endpoints filter to the caller's permitted objects.
- `CORS` is not `*` for credentialed requests.
- `JWT` signature, expiry, and audience are validated on every request.
- Privilege escalation paths do not exist (user cannot self-promote).
- Directory listing is disabled; sensitive files are not web-accessible.

#### A02 — Cryptographic Failures

- Sensitive data is encrypted at rest and in transit.
- Passwords use `Argon2id`, `bcrypt` (factor ≥12), or `scrypt` — never `MD5`/`SHA-1`.
- `TLS 1.2+` enforced; `TLS 1.0`/`1.1` disabled.
- `HSTS` header set; HTTP redirects to HTTPS.
- Keys and secrets stored in env vars or a secrets manager — not in source.
- Security-sensitive random values use a CSPRNG.

#### A03 — Injection

- All database queries use parameterized queries or prepared statements.
- No user input concatenated into SQL, shell commands, LDAP, or XPath.
- `eval`, `exec`, `spawn` do not receive user-controlled strings.
- Template engines do not render untrusted input as raw HTML.
- XML parsing disables external entities (`DOCTYPE`, `SYSTEM`, `PUBLIC`).

#### A04 — Insecure Design

- Threat modelling performed for sensitive flows.
- Business logic enforces rate limits, quantity caps, and workflow ordering server-side.
- Sensitive operations (password reset, account deletion) require re-authentication.
- Account enumeration is not possible via timing or distinct error messages.
- Multi-step processes cannot be bypassed by skipping steps.

#### A05 — Security Misconfiguration

- Security headers set: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`.
- Debug modes and stack traces disabled in production.
- Default credentials changed; unused features disabled.
- Cookie flags set: `HttpOnly`, `Secure`, `SameSite`.
- Cloud storage not publicly writable or listable.
- Dependencies pinned with lockfiles committed.

#### A06 — Vulnerable and Outdated Components

- All dependencies up to date; no packages with known CVEs.
- `npm audit`, `pip audit`, `cargo audit`, or equivalent runs in CI.
- Unused dependencies removed.
- Container base images pinned to specific digests (not `latest`).
- Abandoned packages (no releases in 2+ years with open security issues) replaced.

#### A07 — Identification and Authentication Failures

- Password minimum length ≥12; checked against known-breached lists.
- MFA available and enforced for privileged accounts.
- Session tokens invalidated on logout and after password change.
- Session IDs regenerated after successful authentication.
- Account lockout or exponential backoff on repeated failed logins.
- Password reset tokens are single-use, time-limited, sent to verified addresses only.

#### A08 — Software and Data Integrity Failures

- CI/CD does not use unverified or unpinned external actions/scripts.
- Package lockfiles and integrity hashes used.
- Deserialization of untrusted data does not execute arbitrary code.
- Subresource Integrity (`SRI`) on externally loaded scripts and stylesheets.
- Auto-update mechanisms verify signed packages before installing.

#### A09 — Security Logging and Monitoring Failures

- Authentication events (success, failure, lockout) logged with timestamp, user, IP.
- Logs do not contain passwords, tokens, full PAN/PII.
- High-value transactions and sensitive resource access audited.
- Logs stored separately from the application; tamper-evident.
- Alerts exist for repeated failures and anomalous access patterns.

#### A10 — Server-Side Request Forgery (SSRF)

- Server-side URL fetching validated against an allowlist of permitted hosts.
- Internal metadata endpoints (`169.254.169.254`, `fd00:ec2::254`) blocked.
- Redirect-following in HTTP clients does not allow redirects to private addresses.
- `file://`, `gopher://`, `dict://` schemes rejected.
- DNS rebinding protections in place.

---

## OWASP API Security Top 10 (2023)

> Source: <https://owasp.org/www-project-api-security/>

### Reference Index

| ID | Name | One-line summary |
| ---- | ------ | ----------------- |
| API1 | Broken Object Level Authorization | Missing per-object authz check; attacker reads/writes other users' data |
| API2 | Broken Authentication | Weak token validation; tokens in URLs; missing expiry checks |
| API3 | Broken Object Property Level Authorization | Response over-exposes fields; mass assignment writes unauthorized properties |
| API4 | Unrestricted Resource Consumption | No rate limiting, pagination caps, or upload size limits |
| API5 | Broken Function Level Authorization | Admin/privileged functions reachable by unprivileged callers |
| API6 | Unrestricted Access to Sensitive Business Flows | Checkout, referral, reset flows abusable by bots or automation |
| API7 | Server Side Request Forgery | Same as A10 above, applied to API-specific fetch patterns |
| API8 | Security Misconfiguration | CORS `*`, exposed Swagger/GraphQL Playground, TLS not enforced |
| API9 | Improper Inventory Management | Old/beta API versions still live; undocumented shadow endpoints |
| API10 | Unsafe Consumption of APIs | Third-party API responses not validated; TLS cert checking disabled |

### Verification Checklist

#### API1 — Broken Object Level Authorization (BOLA)

- Every endpoint accessing an object by ID validates caller ownership.
- Bulk/list endpoints filter to caller's permitted objects only.
- Nested resources (e.g., `/users/{id}/orders/{orderId}`) validate ownership at every level.
- Authorization re-checked on update and delete, not just read.

#### API2 — Broken Authentication

- Tokens validated on every request: signature, expiry, issuer, audience.
- Tokens transmitted over HTTPS only; never in URL query parameters.
- Refresh tokens rotated on use and invalidated on logout.
- `JWT` algorithms explicitly allowlisted; `alg: none` rejected.
- API keys not logged, exposed in errors, or leaked in headers.

#### API3 — Broken Object Property Level Authorization (BOPLA)

- Responses expose only fields the caller is authorized to see.
- Mass assignment prevented: only allowlisted fields bound from request body.
- Write endpoints reject fields the caller cannot modify (`role`, `isAdmin`, `balance`).
- GraphQL resolvers enforce field-level authorization.

#### API4 — Unrestricted Resource Consumption

- Rate limiting applied to all public and authenticated endpoints.
- Pagination enforced with a maximum page size on all list endpoints.
- File upload endpoints enforce size and type restrictions.
- GraphQL depth and complexity limits configured.

#### API5 — Broken Function Level Authorization

- Admin and privileged functions accessible only to authorized roles.
- HTTP methods restricted per endpoint; unauthorized methods return 405.
- Internal endpoints not accessible from external networks.
- Action endpoints (e.g., `/promote`, `/refund`) enforce role checks.

#### API6 — Unrestricted Access to Sensitive Business Flows

- Rate limiting on high-value flows: checkout, account creation, password reset.
- Bot-detection applied to abuse-prone flows.
- Quantity and frequency limits exist for business operations.
- Multi-step flows enforce state machine ordering server-side.

#### API7 — Server Side Request Forgery

- Same checks as A10 above, applied to API fetch and webhook patterns.
- Webhook/callback URL registration validates target before first request.

#### API8 — Security Misconfiguration

- CORS not `*` for credentialed requests; explicit origin allowlist used.
- Error responses do not expose stack traces or dependency versions.
- API documentation endpoints (Swagger UI, GraphQL Playground) disabled or access-controlled in production.
- Unused API versions, methods, and endpoints disabled.

#### API9 — Improper Inventory Management

- All deployed API versions documented, monitored, and sunset on schedule.
- Staging/test endpoints not accessible with production credentials.
- Third-party integrations inventoried and reviewed.
- Shadow APIs exposed by frameworks audited.

#### API10 — Unsafe Consumption of APIs

- Data from third-party APIs validated and sanitized before internal use.
- Third-party responses not trusted to inject SQL, HTML, or commands.
- TLS certificates of third-party APIs validated; certificate verification never disabled.
- Third-party API keys scoped to minimum permissions and rotated.

---

## OWASP Proactive Controls (2024)

> Source: <https://owasp.org/www-project-proactive-controls/>

### Reference Index

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

### Verification Checklist

#### C1 — Access Control

- Policy defined centrally, not scattered; default deny.
- Authorization re-validated on every state-changing operation.
- All access control failures logged.
- Enforcement is server-side only.

#### C2 — Cryptography

- No custom crypto; use `libsodium`, `Bouncy Castle`, `cryptography.io`, or equivalent.
- Authenticated encryption (`AES-GCM`, `ChaCha20-Poly1305`) for confidentiality + integrity.
- CSPRNG for all security-sensitive random values.
- Passwords hashed with `Argon2id` (preferred), `bcrypt` (factor ≥12), or `scrypt`.
- Key rotation strategy defined and implemented.

#### C3 — Input Validation

- Allowlist (expected characters/formats) not denylist.
- Validate type, length, format, range at the trust boundary.
- Reject and log malformed input; do not silently coerce.
- Output encoded for context: HTML, URL, SQL parameterization.

#### C4 — Security from the Start

- Threat model exists for new features handling sensitive data.
- Trust boundaries identified and documented.
- Principle of least privilege applied.

#### C5 — Secure Defaults

- Debug/verbose modes disabled in production.
- Required security config validated at startup; fail fast on missing values.
- Secrets in env vars or secrets manager (`Vault`, `AWS SSM`, `SOPS`).
- Framework security features (CSRF, XSS filtering) not overridden.

#### C6 — Simplicity

- Standard library/framework primitives used (prepared statements, ORM parameterization).
- Security-critical code isolated; failures contained.

#### C7 — Find and Fix Issues

- SAST (`Semgrep`, `CodeQL`, `Bandit`, `Brakeman`) runs in CI.
- Dependency scanning (`npm audit`, `pip-audit`, `Trivy`, `Grype`) runs in CI.
- Critical and High findings block merges.
- Fixes verified with a test that reproduces the original issue.

#### C8 — Digital Identity

- Proven identity library/provider used; no hand-rolled authentication.
- Session IDs cryptographically random (≥128 bits); regenerated after login; expire on inactivity.
- MFA enforced for privileged and sensitive-data accounts.
- Account recovery flows use time-limited, single-use, verified-channel tokens.

#### C9 — Logging and Monitoring

- Security events logged (auth attempts, authz failures, input rejections, privilege changes).
- Structured logs (JSON) with UTC timestamp, user/session ID, IP, action, outcome.
- No sensitive data in logs (passwords, tokens, PAN, PII).
- Append-only log storage separate from app data.
- Alerting thresholds defined for brute force, mass access, and privilege escalation.

#### C10 — External Systems

- All external data treated as untrusted input; validated and sanitized.
- Least privilege for service accounts and database users.
- Timeouts and circuit breakers on all external calls.
- TLS certificates validated on all outbound connections.

---

## OWASP Application Security Verification Standard (ASVS v4)

> Source: <https://owasp.org/www-project-application-security-verification-standard/>

ASVS defines three assurance levels (L1 = minimum, L2 = standard, L3 = advanced). Use this index to locate the relevant chapter, then apply its requirements during formal review.

### Chapter Index

| Chapter | Name | One-line summary |
| --------- | ------ | ----------------- |
| V1 | Architecture, Design and Threat Modelling | Secure design principles, threat modelling, and security architecture |
| V2 | Authentication | Password policies, credential storage, MFA, lookup secrets |
| V3 | Session Management | Session token generation, renewal, expiry, and binding |
| V4 | Access Control | Least privilege, RBAC/ABAC, trusted enforcement points |
| V5 | Validation, Sanitization and Encoding | Input validation, output encoding, injection prevention |
| V6 | Stored Cryptography | Encryption at rest, key management, approved algorithms |
| V7 | Error Handling and Logging | Secure exceptions, security event logging, log integrity |
| V8 | Data Protection | Sensitive data lifecycle, transmission, and memory handling |
| V9 | Communications | TLS configuration, certificate validation, encrypted channels |
| V10 | Malicious Code | Code injection prevention, untrusted code, dependency safety |
| V11 | Business Logic | Transaction integrity, workflow ordering, anti-automation |
| V12 | File and Resources | File uploads, downloads, path traversal, permissions |
| V13 | API and Web Service | API authentication, validation, request limits, service security |
| V14 | Configuration | Secure defaults, credential management, deployment hardening |

### Assurance Level Guide

- **L1** — All software; minimum acceptable controls. Verifiable by automated scanning and manual review of code samples.
- **L2** — Applications handling sensitive data (finance, health, PII). Requires penetration testing.
- **L3** — Critical infrastructure, high-value transactions. Requires architecture review, code review, and independent security assessment.

---

## OWASP Cheat Sheet Series

> Source: <https://cheatsheetseries.owasp.org/>

Use this index to identify the canonical cheat sheet for a specific defense pattern. Each entry links to the cheat sheet by name; look it up at `https://cheatsheetseries.owasp.org/cheatsheets/<Name>_Cheat_Sheet.html`.

### Authentication and Session Management

- Authentication Cheat Sheet — password policies, credential handling, MFA flows
- Authorization Cheat Sheet — RBAC, ABAC, centralized enforcement
- Session Management Cheat Sheet — token generation, binding, expiry, revocation
- Password Storage Cheat Sheet — adaptive hashing, salting, work factors
- Credential Stuffing Prevention Cheat Sheet — rate limiting, MFA, breach detection
- Multi-Factor Authentication (MFA) Cheat Sheet — TOTP, FIDO2, SMS tradeoffs
- Forgot Password Cheat Sheet — secure reset token flows

### Input Validation and Output Encoding

- Input Validation Cheat Sheet — allowlisting, type/length/range checks
- Cross Site Scripting Prevention Cheat Sheet — output encoding contexts
- DOM-based XSS Prevention Cheat Sheet — safe sink usage in JS
- Output Encoding Cheat Sheet — HTML, URL, JS, CSS encoding rules
- HTML5 Security Cheat Sheet — postMessage, web storage, sandboxing

### Injection Prevention

- SQL Injection Prevention Cheat Sheet — parameterized queries, ORMs
- NoSQL Injection Prevention Cheat Sheet — MongoDB, Redis operator injection
- OS Command Injection Defense Cheat Sheet — safe `exec` patterns
- LDAP Injection Prevention Cheat Sheet — escaping, parameterized APIs
- XML External Entity (XXE) Prevention Cheat Sheet — disabling external entity processing

### Cryptography and Secrets

- Cryptographic Storage Cheat Sheet — algorithm selection, key storage
- Secrets Management Cheat Sheet — vaults, rotation, access scoping
- Encryption Cheat Sheet — symmetric and asymmetric use cases
- TLS Cipher String Cheat Sheet — recommended cipher suites by profile

### Cross-Site and Request Security

- Cross-Site Request Forgery (CSRF) Prevention Cheat Sheet — tokens, SameSite, double-submit
- Clickjacking Defense Cheat Sheet — `X-Frame-Options`, CSP `frame-ancestors`
- Cross-Origin Resource Sharing (CORS) Cheat Sheet — allowlists, credentialed requests

### Web Security Headers and Protocols

- HTTP Security Response Headers Cheat Sheet — full header reference
- Content Security Policy (CSP) Cheat Sheet — policy directives and common profiles
- HTTPS Cheat Sheet — TLS configuration, HSTS, cert pinning
- Cookie Security Cheat Sheet — `HttpOnly`, `Secure`, `SameSite`, `__Host-` prefix

### API and Web Services

- REST Security Cheat Sheet — authentication, input validation, response headers
- GraphQL Cheat Sheet — depth/complexity limits, introspection, field-level authz
- Web Service Security Cheat Sheet — SOAP, XML security
- API Security Cheat Sheet — rate limiting, versioning, BOLA/BOPLA

### File and Resource Handling

- File Upload Cheat Sheet — type validation, size limits, storage isolation
- Path Traversal Cheat Sheet — canonicalization, allowlisting base paths
- Insecure Direct Object References (IDOR) Prevention Cheat Sheet — indirect references, authz checks

### Logging, Error Handling and Monitoring

- Logging Cheat Sheet — what to log, structured format, retention
- Error Handling Cheat Sheet — safe error messages, exception boundaries
- Attack Surface Analysis Cheat Sheet — entry points, trust levels

### Infrastructure and Deployment

- Docker Security Cheat Sheet — rootless containers, image scanning, capabilities
- Kubernetes Security Cheat Sheet — RBAC, network policies, pod security
- CI/CD Security Cheat Sheet — pipeline hardening, secret injection, OIDC
- Deserialization Cheat Sheet — safe patterns, integrity checks

### Language and Framework Specifics

- Node.js Security Cheat Sheet
- Python Security Cheat Sheet
- Java Security Cheat Sheet
- DotNet Security Cheat Sheet
- Django Security Cheat Sheet
- Ruby on Rails Security Cheat Sheet
- PHP Configuration Cheat Sheet

---

## Language-Specific Quick Checks

### JavaScript / TypeScript

- Avoid `eval()`, `Function(string)`, `setTimeout(string)` with dynamic input.
- Use `helmet` for security headers in Express/Node.
- Sanitize HTML with `DOMPurify` before rendering user content.
- Set `httpOnly`, `secure`, `sameSite` on all cookies.
- Use `crypto.randomBytes` / `crypto.subtle`, not `Math.random`, for security values.

### Python

- Use parameterized queries with `psycopg2`, `SQLAlchemy`, or Django ORM; never `.format()` in SQL.
- Replace `yaml.load()` with `yaml.safe_load()`; avoid `pickle` for untrusted data.
- Never use `subprocess` with `shell=True` and user input.
- Use `secrets` module, not `random`, for tokens and nonces.

### Go

- Use `database/sql` with `?` placeholders; never string-concatenate user input into queries.
- Use `html/template` (not `text/template`) for HTML rendering — it auto-escapes.
- Set `Secure`, `HttpOnly`, `SameSite` on `http.Cookie`.
- Validate and restrict redirect targets in HTTP client usage.

### Nix / Shell

- Quote all variables: `"$var"` prevents word splitting and glob injection.
- Use `set -euo pipefail` at the top of every shell script.
- Avoid `eval` in shell; prefer explicit argument arrays.
- Validate inputs before constructing command arguments.

---

## Reporting Format

For each finding, include:

1. **Standard** — Which OWASP standard and item applies (e.g., A03:2021 Injection, API1 BOLA, C3 Validate Input, ASVS V5).
2. **Location** — File and line number.
3. **Description** — What the vulnerability is and how it can be exploited.
4. **Remediation** — Specific fix with a code example.
5. **Relevant Cheat Sheet** — The most applicable OWASP cheat sheet by name.
6. **Severity** — Critical / High / Medium / Low.

---

## References

| Standard | URL |
| ---------- | ----- |
| OWASP Top 10 (2021) | <https://owasp.org/Top10/> |
| OWASP API Security Top 10 (2023) | <https://owasp.org/www-project-api-security/> |
| OWASP Proactive Controls (2024) | <https://owasp.org/www-project-proactive-controls/> |
| OWASP ASVS v4 | <https://owasp.org/www-project-application-security-verification-standard/> |
| OWASP Cheat Sheet Series | <https://cheatsheetseries.owasp.org/> |
| OWASP Testing Guide | <https://owasp.org/www-project-web-security-testing-guide/> |
