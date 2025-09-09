# Copilot Instructions

## Journals

- Use proper grammar and punctuations in the journals.
- Use ISO8601 universal timestamp taken from terminal for the journals.
- Read [copilot-journals.md](./copilot-journals.md) to understand history.
- Save every summary in [copilot-journals.md](./copilot-journals.md).
- Organized the journal entries are chronologically, including `1970-01-01T01:00:00Z`.

## Commands

Use explicit arguments/options over abbreviated arguments/options. Example:

Use `date --universal +"%Y-%m-%dT%H:%M:%SZ"` over `date -u +"%Y-%m-%dT%H:%M:%SZ"` in terminal commands.
Use `set -o errexit` over `set -e` in shell scripts.

Save suggested nix commands in [copilot-commands.md](./copilot-commands.md) for future reference.

## Markdown

Use [reference-style links](https://www.markdownguide.org/basic-syntax/#reference-style-links). Example:

```text
See [hobbit hole][hobbit-hole].

## References

[hobbit-hole]: https://hobbit.hole
```

## Nix

Do not use Homebrew packages on macOS system.
Search Nix store paths for dependencies.
Setup identical shell from `nix develop` (via `flake.nix`) and nix-shell (via `shell.nix`) development environment.
Use [Nix manual][nix-manual] and [Noogle][noogle] that provides searchable documentation for explaining Nix built-in functions and `nixpkgs` library functions.
Use `nix-prefetch-git` command to get `sha256` value in `fetchFromGitHub` or related functions. Otherwise, use `lib.fakeSha256` as placeholder.
Use `nixos-unstable` branch.
Use Nix to install dependencies and packages.

## Instructions

Use home-manager for managing user configuration whenever available instead of Nix's packages. Example: Use [home-manager options][home-manager-options] instead of installing it from [nixpkgs packages][nixpkgs-packages] directly.

Add development information and instructions to this file accordingly.

Avoid unnecessary comments whenever possible.

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

Use explicit arguments/options over abbreviated arguments/options. Example:
`date --universal +"%Y-%m-%dT%H:%M:%SZ"` or `date --utc +"%Y-%m-%dT%H:%M:%SZ"`
over `date -u +"%Y-%m-%dT%H:%M:%SZ"`.

Discard all empty trailing whitespace from every file.

<!-- Both nix develop (flakes) or nix-shell (traditional) should have consistent and identical development environment. -->

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

[home-manager-options]: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable
[nix-manual]: https://nix.dev/manual/nix/latest
[nixpkgs-packages]: https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-code
[noogle]: https://noogle.dev/
