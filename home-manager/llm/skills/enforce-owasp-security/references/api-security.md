# OWASP API Security Top 10 (2023)

> Source: <https://owasp.org/www-project-api-security/>

## Reference Index

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

## Verification Checklist

### API1 — Broken Object Level Authorization (BOLA)

- Every endpoint accessing an object by ID validates caller ownership.
- Bulk/list endpoints filter to caller's permitted objects only.
- Nested resources (e.g., `/users/{id}/orders/{orderId}`) validate ownership at every level.
- Authorization re-checked on update and delete, not just read.

### API2 — Broken Authentication

- Tokens validated on every request: signature, expiry, issuer, audience.
- Tokens transmitted over HTTPS only; never in URL query parameters.
- Refresh tokens rotated on use and invalidated on logout.
- `JWT` algorithms explicitly allowlisted; `alg: none` rejected.
- API keys not logged, exposed in errors, or leaked in headers.

### API3 — Broken Object Property Level Authorization (BOPLA)

- Responses expose only fields the caller is authorized to see.
- Mass assignment prevented: only allowlisted fields bound from request body.
- Write endpoints reject fields the caller cannot modify (`role`, `isAdmin`, `balance`).
- GraphQL resolvers enforce field-level authorization.

### API4 — Unrestricted Resource Consumption

- Rate limiting applied to all public and authenticated endpoints.
- Pagination enforced with a maximum page size on all list endpoints.
- File upload endpoints enforce size and type restrictions.
- GraphQL depth and complexity limits configured.

### API5 — Broken Function Level Authorization

- Admin and privileged functions accessible only to authorized roles.
- HTTP methods restricted per endpoint; unauthorized methods return 405.
- Internal endpoints not accessible from external networks.
- Action endpoints (e.g., `/promote`, `/refund`) enforce role checks.

### API6 — Unrestricted Access to Sensitive Business Flows

- Rate limiting on high-value flows: checkout, account creation, password reset.
- Bot-detection applied to abuse-prone flows.
- Quantity and frequency limits exist for business operations.
- Multi-step flows enforce state machine ordering server-side.

### API7 — Server Side Request Forgery

- Same checks as A10 above, applied to API fetch and webhook patterns.
- Webhook/callback URL registration validates target before first request.

### API8 — Security Misconfiguration

- CORS not `*` for credentialed requests; explicit origin allowlist used.
- Error responses do not expose stack traces or dependency versions.
- API documentation endpoints (Swagger UI, GraphQL Playground) disabled or access-controlled in production.
- Unused API versions, methods, and endpoints disabled.

### API9 — Improper Inventory Management

- All deployed API versions documented, monitored, and sunset on schedule.
- Staging/test endpoints not accessible with production credentials.
- Third-party integrations inventoried and reviewed.
- Shadow APIs exposed by frameworks audited.

### API10 — Unsafe Consumption of APIs

- Data from third-party APIs validated and sanitized before internal use.
- Third-party responses not trusted to inject SQL, HTML, or commands.
- TLS certificates of third-party APIs validated; certificate verification never disabled.
- Third-party API keys scoped to minimum permissions and rotated.
