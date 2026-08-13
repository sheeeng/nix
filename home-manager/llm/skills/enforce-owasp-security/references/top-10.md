# OWASP Top 10:2025

Use the [OWASP Top 10:2025][owasp-top-ten] as an awareness document. Use ASVS for complete verification requirements.

## Reference Index

| ID | Name | Summary |
| ---- | ------ | ----------------- |
| A01 | Broken Access Control | Users act outside intended permissions; IDOR, missing authz checks |
| A02 | Security Misconfiguration | Insecure settings, excessive error details, default credentials, or unnecessary features expose the system |
| A03 | Software Supply Chain Failures | Compromised, vulnerable, obsolete, or untracked dependencies and build systems undermine software trust |
| A04 | Cryptographic Failures | Weak, absent, or incorrectly managed cryptography exposes sensitive data and keys |
| A05 | Injection | Untrusted data becomes part of a query, command, expression, or rendered document |
| A06 | Insecure Design | Missing or ineffective controls create architectural and business logic weaknesses |
| A07 | Authentication Failures | Weak credentials, recovery, multifactor authentication, or session handling permits impersonation |
| A08 | Software or Data Integrity Failures | Unverified code, updates, pipelines, or serialized data crosses a trust boundary |
| A09 | Security Logging and Alerting Failures | Missing logs, monitoring, integrity controls, or alerts prevent timely detection and response |
| A10 | Mishandling of Exceptional Conditions | Unexpected states, errors, resource failures, or missing parameters cause insecure behavior or failure |

## Verification Checklist

### A01:2025 Broken Access Control

- Every route/handler enforces authorization before processing.
- Object access by ID validates caller ownership (no IDOR).
- List endpoints filter to the caller's permitted objects.
- `CORS` is not `*` for credentialed requests.
- `JWT` signature, expiry, and audience are validated on every request.
- Privilege escalation paths do not exist (user cannot self-promote).
- Directory listing is disabled; sensitive files are not web-accessible.
- Server-side requests restrict destinations, protocols, redirects, and access to private networks.

### A02:2025 Security Misconfiguration

- Apply a repeatable hardening process to development, test, and production environments.
- Remove unnecessary features, services, accounts, documentation, and sample applications.
- Change or disable default accounts and credentials.
- Return generic client errors and handle detailed errors through a central server-side mechanism.
- Set secure permissions, security headers, cookie attributes, and cross-origin policies.
- Use short-lived platform identities instead of static credentials in source, configuration files, or pipelines.
- Verify security settings automatically in every environment.

### A03:2025 Software Supply Chain Failures

- Inventory direct and transitive dependencies, build tools, extensions, repositories, and deployment artifacts.
- Generate and maintain a software bill of materials for each release.
- Obtain components from trusted sources through secure links and verify signatures or checksums.
- Pin dependencies and continuous integration actions to reviewed versions or immutable revisions.
- Scan dependencies, artifacts, and build environments continuously for vulnerabilities and malicious changes.
- Remove unsupported components and apply security updates through a documented process.
- Protect source repositories, build pipelines, artifact stores, and release processes with least privilege and change review.

### A04:2025 Cryptographic Failures

- Sensitive data is encrypted at rest and in transit.
- Passwords use `Argon2id`, `bcrypt` with a factor of at least 12, or `scrypt`. Do not use `MD5` or `SHA-1`.
- `TLS 1.2+` enforced; `TLS 1.0`/`1.1` disabled.
- `HSTS` header set; HTTP redirects to HTTPS.
- Store keys and secrets in environment variables or a secrets manager. Do not store them in source files.
- Security-sensitive random values use a CSPRNG.
- Certificates, host names, and trust chains are validated for every encrypted connection.

### A05:2025 Injection

- All database queries use parameterized queries or prepared statements.
- No user input concatenated into SQL, shell commands, LDAP, or XPath.
- `eval`, `exec`, `spawn` do not receive user-controlled strings.
- Template engines do not render untrusted input as raw HTML.
- XML parsing disables external entities (`DOCTYPE`, `SYSTEM`, `PUBLIC`).
- Context specific output encoding protects browser, document, and interpreter sinks.

### A06:2025 Insecure Design

- Threat modelling performed for sensitive flows.
- Business logic enforces rate limits, quantity caps, and workflow ordering server-side.
- Sensitive operations (password reset, account deletion) require re-authentication.
- Account enumeration is not possible via timing or distinct error messages.
- Multi-step processes cannot be bypassed by skipping steps.
- File uploads, trust boundaries, resource limits, and exceptional states have explicit security controls.

### A07:2025 Authentication Failures

- Password minimum length ≥12; checked against known-breached lists.
- MFA available and enforced for privileged accounts.
- Session tokens invalidated on logout and after password change.
- Session IDs regenerated after successful authentication.
- Account lockout or exponential backoff on repeated failed logins.
- Password reset tokens are single-use, time-limited, sent to verified addresses only.
- Session identifiers never appear in URLs or other client accessible locations that expose them.

### A08:2025 Software or Data Integrity Failures

- CI/CD does not use unverified or unpinned external actions/scripts.
- Package lockfiles and integrity hashes used.
- Deserialization of untrusted data does not execute arbitrary code.
- Subresource Integrity (`SRI`) on externally loaded scripts and stylesheets.
- Auto-update mechanisms verify signed packages before installing.
- Continuous integration and deployment pipelines verify the origin and integrity of code and artifacts.

### A09:2025 Security Logging and Alerting Failures

- Authentication events (success, failure, lockout) logged with timestamp, user, IP.
- Logs do not contain passwords, tokens, full PAN/PII.
- High-value transactions and sensitive resource access audited.
- Logs stored separately from the application; tamper-evident.
- Alerts exist for repeated failures and anomalous access patterns.
- Dynamic security tests trigger monitored alerts and exercise the response process.

### A10:2025 Mishandling of Exceptional Conditions

- Validate required parameters, ranges, sizes, and resource limits before processing.
- Handle errors near their source and use consistent exception handling throughout the application.
- Fail closed when authorization, authentication, cryptography, or security checks cannot complete.
- Roll back partial transactions and preserve a known, consistent state after failures.
- Release memory, locks, files, connections, and other resources on every exit path.
- Return generic errors to users without stack traces, secrets, internal paths, or dependency details.
- Log exceptional security events with enough context for detection and investigation.
- Test missing input, boundary values, timeouts, dependency failures, race conditions, and exhausted resources.

[owasp-top-ten]: https://owasp.org/Top10/2025/
