# OWASP Application Security Verification Standard (ASVS v4)

> Source: <https://owasp.org/www-project-application-security-verification-standard/>

ASVS defines three assurance levels (L1 = minimum, L2 = standard, L3 = advanced). Use this index to locate the relevant chapter, then apply its requirements during formal review.

## Chapter Index

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

## Assurance Level Guide

- **L1** — All software; minimum acceptable controls. Verifiable by automated scanning and manual review of code samples.
- **L2** — Applications handling sensitive data (finance, health, PII). Requires penetration testing.
- **L3** — Critical infrastructure, high-value transactions. Requires architecture review, code review, and independent security assessment.
