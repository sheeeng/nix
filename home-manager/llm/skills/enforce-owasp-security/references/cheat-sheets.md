# OWASP Cheat Sheet Series

> Source: <https://cheatsheetseries.owasp.org/>

Use this index to identify the canonical cheat sheet for a specific defense pattern. Each entry links to the cheat sheet by name; look it up at `https://cheatsheetseries.owasp.org/cheatsheets/<Name>_Cheat_Sheet.html`.

## Authentication and Session Management

- Authentication Cheat Sheet — password policies, credential handling, MFA flows
- Authorization Cheat Sheet — RBAC, ABAC, centralized enforcement
- Session Management Cheat Sheet — token generation, binding, expiry, revocation
- Password Storage Cheat Sheet — adaptive hashing, salting, work factors
- Credential Stuffing Prevention Cheat Sheet — rate limiting, MFA, breach detection
- Multi-Factor Authentication (MFA) Cheat Sheet — TOTP, FIDO2, SMS tradeoffs
- Forgot Password Cheat Sheet — secure reset token flows

## Input Validation and Output Encoding

- Input Validation Cheat Sheet — allowlisting, type/length/range checks
- Cross Site Scripting Prevention Cheat Sheet — output encoding contexts
- DOM-based XSS Prevention Cheat Sheet — safe sink usage in JS
- Output Encoding Cheat Sheet — HTML, URL, JS, CSS encoding rules
- HTML5 Security Cheat Sheet — postMessage, web storage, sandboxing

## Injection Prevention

- SQL Injection Prevention Cheat Sheet — parameterized queries, ORMs
- NoSQL Injection Prevention Cheat Sheet — MongoDB, Redis operator injection
- OS Command Injection Defense Cheat Sheet — safe `exec` patterns
- LDAP Injection Prevention Cheat Sheet — escaping, parameterized APIs
- XML External Entity (XXE) Prevention Cheat Sheet — disabling external entity processing

## Cryptography and Secrets

- Cryptographic Storage Cheat Sheet — algorithm selection, key storage
- Secrets Management Cheat Sheet — vaults, rotation, access scoping
- Encryption Cheat Sheet — symmetric and asymmetric use cases
- TLS Cipher String Cheat Sheet — recommended cipher suites by profile

## Cross-Site and Request Security

- Cross-Site Request Forgery (CSRF) Prevention Cheat Sheet — tokens, SameSite, double-submit
- Clickjacking Defense Cheat Sheet — `X-Frame-Options`, CSP `frame-ancestors`
- Cross-Origin Resource Sharing (CORS) Cheat Sheet — allowlists, credentialed requests

## Web Security Headers and Protocols

- HTTP Security Response Headers Cheat Sheet — full header reference
- Content Security Policy (CSP) Cheat Sheet — policy directives and common profiles
- HTTPS Cheat Sheet — TLS configuration, HSTS, cert pinning
- Cookie Security Cheat Sheet — `HttpOnly`, `Secure`, `SameSite`, `__Host-` prefix

## API and Web Services

- REST Security Cheat Sheet — authentication, input validation, response headers
- GraphQL Cheat Sheet — depth/complexity limits, introspection, field-level authz
- Web Service Security Cheat Sheet — SOAP, XML security
- API Security Cheat Sheet — rate limiting, versioning, BOLA/BOPLA

## File and Resource Handling

- File Upload Cheat Sheet — type validation, size limits, storage isolation
- Path Traversal Cheat Sheet — canonicalization, allowlisting base paths
- Insecure Direct Object References (IDOR) Prevention Cheat Sheet — indirect references, authz checks

## Logging, Error Handling and Monitoring

- Logging Cheat Sheet — what to log, structured format, retention
- Error Handling Cheat Sheet — safe error messages, exception boundaries
- Attack Surface Analysis Cheat Sheet — entry points, trust levels

## Infrastructure and Deployment

- Docker Security Cheat Sheet — rootless containers, image scanning, capabilities
- Kubernetes Security Cheat Sheet — RBAC, network policies, pod security
- CI/CD Security Cheat Sheet — pipeline hardening, secret injection, OIDC
- Deserialization Cheat Sheet — safe patterns, integrity checks

## Language and Framework Specifics

- Node.js Security Cheat Sheet
- Python Security Cheat Sheet
- Java Security Cheat Sheet
- DotNet Security Cheat Sheet
- Django Security Cheat Sheet
- Ruby on Rails Security Cheat Sheet
- PHP Configuration Cheat Sheet
