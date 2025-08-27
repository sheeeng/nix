# GitHub Copilot Instructions

We use Nix for managing our system. Always give me instructions and code samples
that use Nix / NixOS features.

Use home-manager for managing user configuration whenever available
instead of Nix's packages. Example: Use <https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable> options instead of installing it # <https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-code> directly.

For Nix function explanations and documentation, refer <https://nix.dev/manual/nix/latest> and <https://noogle.dev/> which provides searchable documentation for Nix built-in functions and nixpkgs library functions.

## Instructions

Add development information and instructions to this file accordingly.

Avoid unnecessary comments whenever possible.

Suggest concise, "Don't Repeat Yourself" (DRY), short, maintainable solutions.
Suggest modifications to lists that are alphanumerically sorted in ascending order.

Do not automatically run commands in the terminal without explicit approval, except for read-only commands like `nix eval`, `nix search`, `nix flake show`, `git status`, `ls`, etc.
Do not automatically commit changes to files without explicit approval.
Do not automatically push changes to remote repositories without explicit approval.
Do not automatically create pull requests to remote repositories without explicit approval.

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
