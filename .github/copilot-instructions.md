# Copilot Instructions

## Journals

- Use proper grammar and punctuation in journals.
- Use ISO8601 timestamps from terminal.
- Read [copilot-journals.md](./copilot-journals.md) for history.
- Save summaries in [copilot-journals.md](./copilot-journals.md).
- Organize entries chronologically, newest first.
- Do not use fully qualified paths in journals. Example: Use `~` or `${HOME}` instead of `/home/username`.
- Do not include any PII or sensitive information in journals. Example: Do not include usernames, email addresses, IP addresses, or any other information that could be used to identify an individual.

## Commands

Use GNU-style explicit arguments over abbreviated ones. Example: Use `date --universal +"%Y-%m-%dT%H:%M:%SZ"` over `date -u +"%Y-%m-%dT%H:%M:%SZ"`. Use `set -o errexit` over `set -e` in shell scripts.

Save suggested nix commands in [copilot-commands.md](./copilot-commands.md).

## Markdown

Use [reference-style links][reference-style-links].

## Nix

- Use Nix packages, not Homebrew on macOS.
- Install GNU tools when available.
- Search Nix store paths for dependencies.
- Use identical shells from `nix develop` and `nix-shell`.
- Reference [Nix manual][nix-manual] and [Noogle].
- Use `nix-prefetch-git` for `sha256` or `lib.fakeSha256` placeholder.
- Install from `nixpkgs-unstable`.

## Secure Development

- Use official documentation for security best practices.

  - [Azure Security Best Practices And Patterns][azure-security-best-practices]
  - [CIS Benchmarks][cis-benchmarks]
  - [GitHub Actions Secure Use Reference][github-actions-secure-use-reference]
  - [OWASP Cheat Sheet Series][owasp-cheat-sheet]
  - [OWASP Top Ten][owasp-top-ten]

- Avoid hardcoding sensitive information like API keys, passwords, or secrets in the codebase. Use environment variables or secure vaults instead.

- Regularly update dependencies to patch known vulnerabilities. Use tools like Dependabot or Renovate to automate this process.

## Instructions

Use home-manager for managing user configuration whenever available instead of Nix's packages. Example: Use [home-manager options][home-manager-options] instead of installing it from [nixpkgs packages][nixpkgs-packages] directly.

Add development information and instructions to this file accordingly.

Avoid unnecessary comments whenever possible. Use correct punctuations for comments.

Do not use slang shorthand words like "config", "util", "func", etc. Example:

- Avoid `CONFIG_DIR`, use `CONFIGURATION_DIRECTORY`
- Avoid `customConfigContent`, use `customConfigurationContent`.

Suggest concise, "Don't Repeat Yourself" (DRY), short, maintainable solutions.
Suggest modifications to lists that are alphanumerically sorted in ascending
order.

Do not automatically run commands in the terminal without explicit approval,
except for read-only commands like `nix eval`, `nix search`, `nix flake show`,
`git status`, `ls`, etc. Do not automatically commit changes to files without
explicit approval. Do not automatically push changes to remote repositories
without explicit approval. Do not automatically create pull requests to remote
repositories without explicit approval.

Keep comments if links are provided.

Use GNU-style explicit arguments over abbreviated ones. Example: Use `date --universal +"%Y-%m-%dT%H:%M:%SZ"` over `date -u +"%Y-%m-%dT%H:%M:%SZ"`. Use `set -o errexit` over `set -e` in shell scripts.

Discard all empty trailing whitespace from every file, except Markdown files.

Please follow these guidelines when contributing:

## Code Standards

### Required Before Each Commit

- Run `nix fmt` before committing any changes to ensure proper code formatting.

<!--
### Development Flow

- Build: `make build`
- Test: `make test`
- Full CI check: `make ci` (includes build, fmt, lint, test)

## Repository Structure

- `admin/`: Admin interface components
- `cmd/`: Main service entry points and executables
- `config/`: Configuration files and templates
- `docs/`: Documentation
- `internal/`: Logic related to interactions with other GitHub services
- `lib/`: Core Go packages for billing logic
- `proto/`: Protocol buffer definitions. Run `make proto` after making updates here.
- `ruby/`: Ruby implementation components. Updates to this folder should include incrementing this version file using semantic versioning: `ruby/lib/billing-platform/version.rb`
- `testing/`: Test helpers and fixtures

## Key Guidelines

1. Follow Go best practices and idiomatic patterns
2. Maintain existing code structure and organization
3. Use dependency injection patterns where appropriate
4. Write unit tests for new functionality. Use table-driven unit tests when possible.
5. Document public APIs and complex logic. Suggest changes to the `docs/` folder when appropriate
-->

[azure-security-best-practices]: https://learn.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns
[cis-benchmarks]: https://www.cisecurity.org/cis-benchmarks/
[github-actions-secure-use-reference]: https://docs.github.com/en/actions/reference/security/secure-use
[home-manager-options]: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable
[nix-manual]: https://nix.dev/manual/nix/latest
[nixpkgs-packages]: https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-code
[noogle]: https://noogle.dev/
[owasp-cheat-sheet]: https://cheatsheetseries.owasp.org/
[owasp-top-ten]: https://owasp.org/www-project-top-ten/
[reference-style-links]: https://www.markdownguide.org/basic-syntax#reference-style-links
