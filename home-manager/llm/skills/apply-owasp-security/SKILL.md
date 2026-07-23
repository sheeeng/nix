---
name: apply-owasp-security
description: Verify code against OWASP security standards, including the Top 10, API Security Top 10, ASVS, Proactive Controls, and Cheat Sheets. Use whenever writing, reviewing, or designing code that handles authentication, authorization, user input, database queries, cryptography, sessions, file uploads, or HTTP and API endpoints, and whenever the user mentions security, vulnerabilities, OWASP, hardening, or a security review, even when not explicitly requested. Selects the relevant OWASP area automatically based on context.
license: Apache-2.0 OR MIT
---

# OWASP Security

## What This Skill Does

- Apply OWASP security standards to any code change, review, or design decision.
- Select the relevant OWASP area automatically based on context (see below).
- Provide actionable, code-level findings with remediations and severity ratings.
- Reference both embedded checklists and canonical OWASP sources.

## Context Detection — Which Area to Apply

Read the context and load the relevant reference file(s). Multiple files may apply. Read only the files relevant to the current task.

| Context | Reference |
| --------- | ----------- |
| Web app routes, templates, forms, sessions, auth | [references/top-10.md](references/top-10.md) |
| REST, GraphQL, gRPC, WebSocket endpoints | [references/api-security.md](references/api-security.md) |
| Any implementation task (crypto, input, logging) | [references/proactive-controls.md](references/proactive-controls.md) |
| Formal verification or compliance review | [references/asvs.md](references/asvs.md) |
| Looking up a specific defense pattern | [references/cheat-sheets.md](references/cheat-sheets.md) |
| Language-specific quick checks | [references/language-checks.md](references/language-checks.md) |

## Reporting Format

For each finding, include:

1. **Standard** — Which OWASP standard and item applies (e.g., A03:2021 Injection, API1 BOLA, C3 Validate Input, ASVS V5).
2. **Location** — File and line number.
3. **Description** — What the vulnerability is and how it can be exploited.
4. **Remediation** — Specific fix with a code example.
5. **Relevant Cheat Sheet** — The most applicable OWASP cheat sheet by name.
6. **Severity** — Critical / High / Medium / Low.

## References

| Standard | URL |
| ---------- | ----- |
| OWASP Top 10 (2021) | <https://owasp.org/Top10/> |
| OWASP API Security Top 10 (2023) | <https://owasp.org/www-project-api-security/> |
| OWASP Proactive Controls (2024) | <https://owasp.org/www-project-proactive-controls/> |
| OWASP ASVS v4 | <https://owasp.org/www-project-application-security-verification-standard/> |
| OWASP Cheat Sheet Series | <https://cheatsheetseries.owasp.org/> |
| OWASP Testing Guide | <https://owasp.org/www-project-web-security-testing-guide/> |
