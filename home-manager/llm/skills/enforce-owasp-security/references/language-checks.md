# Language-Specific Quick Checks

## JavaScript / TypeScript

- Avoid `eval()`, `Function(string)`, `setTimeout(string)` with dynamic input.
- Use `helmet` for security headers in Express/Node.
- Sanitize HTML with `DOMPurify` before rendering user content.
- Set `httpOnly`, `secure`, `sameSite` on all cookies.
- Use `crypto.randomBytes` / `crypto.subtle`, not `Math.random`, for security values.

## Python

- Use parameterized queries with `psycopg2`, `SQLAlchemy`, or Django ORM; never `.format()` in SQL.
- Replace `yaml.load()` with `yaml.safe_load()`; avoid `pickle` for untrusted data.
- Never use `subprocess` with `shell=True` and user input.
- Use `secrets` module, not `random`, for tokens and nonces.

## Go

- Use `database/sql` with `?` placeholders; never string-concatenate user input into queries.
- Use `html/template` (not `text/template`) for HTML rendering — it auto-escapes.
- Set `Secure`, `HttpOnly`, `SameSite` on `http.Cookie`.
- Validate and restrict redirect targets in HTTP client usage.

## Nix / Shell

- Quote all variables: `"$var"` prevents word splitting and glob injection.
- Use `set -euo pipefail` at the top of every shell script.
- Avoid `eval` in shell; prefer explicit argument arrays.
- Validate inputs before constructing command arguments.
