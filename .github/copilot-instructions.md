We use Nix for managing our system. Always give me instructions and code samples that use Nix / NixOS features.

Always use home-manager for managing user configuration whenever available from https://nix-community.github.io/home-manager/options.xhtml options. When you provide code samples, please ensure they are compatible with Nix's home-manager module.

We use GitHub Issues for tracking items of work.

Please follow these guidelines when contributing:

## Code Standards

### Required Before Each Commit

- Run `nixfmt` before committing any changes to ensure proper code formatting.
- This will run `nixfmt` on all Nix files to maintain consistent style.

<!--
### Development Flow

- Build: `make build`
- Test: `make test`
- Full CI check: `make ci` (includes build, fmt, lint, test)

## Repository Structure

- `cmd/`: Main service entry points and executables
- `internal/`: Logic related to interactions with other GitHub services
- `lib/`: Core Go packages for billing logic
- `admin/`: Admin interface components
- `config/`: Configuration files and templates
- `docs/`: Documentation
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
