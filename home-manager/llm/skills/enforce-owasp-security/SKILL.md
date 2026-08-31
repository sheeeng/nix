---
name: enforce-owasp-security
description: Enforce OWASP application security guidance, including ASVS, the Web Security Testing Guide, Cheat Sheets, Proactive Controls, the Top 10:2025, and the API Security Top 10:2023. Use when designing, writing, reviewing, testing, or hardening authentication, authorization, user input, database queries, cryptography, sessions, file handling, exceptional conditions, software supply chains, web applications, or APIs. Also use for vulnerability and OWASP compliance work.
license: Apache-2.0 OR MIT
---

# Enforce OWASP Security


## Before Starting

Load the `enforce-writing-style` skill before continuing. Its required
chain is `enforce-asd-ste100`, followed by `forbid-llm-slop`. Apply
writing style rules to all output produced by this skill.

## Apply OWASP Guidance

1. Identify the assets, actors, entry points, trust boundaries, and possible impacts.
2. Select every applicable OWASP source from the routing table.
3. Inspect the design, implementation, configuration, dependencies, and tests.
4. Record evidence for each finding and each applicable requirement.
5. Correct findings when the task authorizes changes.
6. Verify corrections with tests at the affected trust boundary.
7. Report unresolved risks and assumptions.

## Select the Applicable Area

Read the context and load the relevant reference file(s). Multiple files may apply. Read only the files relevant to the current task.

| Context | Reference |
| --------- | ----------- |
| Web application risk identification | [references/top-10.md](references/top-10.md) |
| REST, GraphQL, gRPC, or WebSocket risk identification | [references/api-security.md](references/api-security.md) |
| Secure implementation and design | [references/proactive-controls.md](references/proactive-controls.md) |
| Formal verification or compliance review | [references/asvs.md](references/asvs.md) |
| Defense implementation | [references/cheat-sheets.md](references/cheat-sheets.md) |
| Language specific review | [references/language-checks.md](references/language-checks.md) |

Use the Top Ten documents to identify common risks. Use ASVS to define verifiable requirements. Use Cheat Sheets and Proactive Controls to implement defenses. Use the Web Security Testing Guide to design security tests.

## Reporting Format

For each finding, include:

1. **Standard:** Identify the OWASP standard and item, such as A05:2025 Injection, API1 BOLA, C3 Validate Input, or ASVS V5.
2. **Location:** Give the file and line number.
3. **Description:** Explain the vulnerability and its possible exploitation.
4. **Remediation:** Give a specific correction with a code example.
5. **Relevant Cheat Sheet:** Name the most applicable OWASP cheat sheet.
6. **Severity:** Assign Critical, High, Medium, or Low severity.

## References

| Standard | URL |
| ---------- | ----- |
| [OWASP Top 10:2025][owasp-top-ten] | Current web application risk awareness document |
| [OWASP API Security Top 10:2023][owasp-api-security] | Current API risk awareness document |
| [OWASP Proactive Controls][owasp-proactive-controls] | Secure development controls |
| [OWASP ASVS][owasp-asvs] | Application security verification requirements |
| [OWASP Cheat Sheet Series][owasp-cheat-sheets] | Defense implementation guidance |
| [OWASP Web Security Testing Guide][owasp-testing-guide] | Web application security test guidance |

[owasp-api-security]: https://owasp.org/www-project-api-security/
[owasp-asvs]: https://owasp.org/www-project-application-security-verification-standard/
[owasp-cheat-sheets]: https://cheatsheetseries.owasp.org/
[owasp-proactive-controls]: https://owasp.org/www-project-proactive-controls/
[owasp-testing-guide]: https://owasp.org/www-project-web-security-testing-guide/
[owasp-top-ten]: https://owasp.org/Top10/2025/
