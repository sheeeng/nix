# AGENTS

## Writing Style

- Ensure adherence to Chicago Manual of Style by maintaining correct grammar and using proper punctuation in all comments and documentation.
- Follow Chicago Manual of Style capitalization conventions.
    - Use title case, or headline style, for headings, titles, and section names.
    - Use sentence case, or sentence style, for regular comments, descriptions, and explanatory text.
    - Always capitalize proper nouns regardless of context.
- Apply accurate grammar and proper punctuation throughout code documentation.
- For title case, apply these Chicago Manual of Style rules.
    - Always capitalize the first and last words.
    - Capitalize all nouns, pronouns, verbs, adjectives, and adverbs.
    - Lowercase articles such as a, an, the.
    - Lowercase coordinating conjunctions such as and, but, or, for, nor, so, yet.
    - Lowercase prepositions such as at, by, for, from, in, into, of, on, to, with, between, through.
    - Lowercase "to" in infinitives such as to run, to see, to build.
    - Exception: Capitalize prepositions when used adverbially or adjectivally, such as "Look Up" and "Turn Down," or in verb phrases.
    - Do not use normal dashes `-` or em dashes `—`.
    - Do not use parentheses `()` to phrase terms.
    - Do not use abbreviated or slang terms; use full terms. Example:
        - Do not use `can't`; use `cannot`.
        - Do not use `config`; use `configuration`.
        - Do not use `docs`; use `documents`.
        - Do not use `info`; use `information`.
- Use indicative or imperative verbs. Example:
    - Indicative: "This function installs the package.", "The script configures the settings.", "The process runs the command."
    - Imperative: "Install the package.", "Configure the settings.", "Run the command."
    - Prefer imperative for instructions and documentation.
    - Prefer indicative for comments that explain what code does.

## Commands

- Use GNU-style explicit long options over abbreviated ones. Examples:
    - Use `date --universal +"%Y-%m-%dT%H:%M:%SZ"` over `date -u +"%Y-%m-%dT%H:%M:%SZ"`.
    - Use `ls --all --list --numeric-uid-gid` over `ls -sln`.
    - Use `set -o errexit` over `set -e` in shell scripts.
    - Use `git commit --message` over `git commit -m`.
- Save suggested commands in [docs/commands.md](./docs/commands.md).

## Journals

- Use ISO8601 timestamps in journals. Example: `2024-01-31T13:45:00Z`.
- Use 20240131T134500Z-style timestamps as name for the journal files. Example: `20240131T134500Z.md`.
- Read all journals inside [docs/journals](docs/journals) directory for historical context.
- Save summaries in [docs/journals](docs/journals) directory.
- Conform to Markdown linting rules in journals.
- Do not use fully qualified paths in journals. Example: Use `~` or `${HOME}` instead of hardcoded `/home/USERNAME`.
- Do not include any Personally Identifiable Information (PII) or sensitive information in journals. Example: Do not include usernames, email addresses, IP addresses, or any other information that could be used to identify individuals.

## Markdown

- Use [reference-style links][reference-style-links].

## Nix

- Use Nix packages, not Homebrew on macOS.
- Install GNU tools when available.
- Search Nix store paths for dependencies.
- Use identical shells from `nix develop` and `nix-shell`.
- Reference [Nix manual][nix-manual] and [Noogle].
- Use `nix-prefetch-git` for `sha256` or `lib.fakeSha256` placeholder.
- Install from `nixpkgs-unstable`.

## Allowed Documentation Sources

Always allow read queries from the following documentation URLs:

- [Home Manager Options][home-manager-options]
- [Nix Manual][nix-manual]
- [NixOS Manual][nixos-manual]
- [NixOS Wiki (Community)][nixos-wiki-community]
- [NixOS Wiki (Official)][nixos-wiki-official]

## Secure Development

- Use official documentation for security best practices.
    - [Azure Security Best Practices And Patterns][azure-security-best-practices]
    - [CIS Benchmarks][cis-benchmarks]
    - [GitHub Actions Secure Use Reference][github-actions-secure-use-reference]
    - [OWASP Cheat Sheet Series][owasp-cheat-sheet]
    - [OWASP Top Ten][owasp-top-ten]
- Forbid hardcoding sensitive information like API keys, passwords, or secrets in the codebase. Use environment variables or secure vaults instead.
- Regularly update dependencies to patch known vulnerabilities. Use tools like Dependabot or Renovate to automate this process.

## Instructions

Use home-manager for managing user configuration whenever available instead of Nix's packages. Example: Use [home-manager options][home-manager-options] instead of installing it from [nixpkgs packages][nixpkgs-packages] directly.

Add development information and instructions to this file accordingly.

Avoid unnecessary comments whenever possible. Use correct punctuation for comments.

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

Discard all empty trailing whitespace from every file, except Markdown files.

Please follow these guidelines when contributing:

## Code Standards

### Required Before Each Commit

- Run the following tools before committing any changes to ensure proper code formatting.
    - `nix flake check`
    - `pre-commit run --all-files`

## AI Model Verification

Always verify AI model names against the open-source database of AI models before configuring agents. Use the following API to check valid model identifiers.

```shell
curl --silent https://models.dev/api.json \
    | jq '.anthropic.models | .[] | .id'
```

Model names follow the `provider/model-id` format. For example, `anthropic/claude-sonnet-4-5-20250929`.

## Git Commits

**ALWAYS use Conventional Commits specification for ALL commit messages.**

- **MANDATORY**: Every commit message MUST follow the Conventional Commits format: `<type>(<scope>): <description>`.
- **MANDATORY**: Load the `git-commit` skill before creating any commit.
- **CRITICAL 50/72 Rule**: Title must be 50 characters or fewer. Body lines must wrap at 72 characters maximum.
- Always verify character count before committing with `echo --no-newline "title" | wc --chars` command.
- Use imperative mood in the description ("add" not "added").
- Keep the description entirely lowercase, including product names.
- Do not capitalize any words in the description.
- Do not end the description with a period.
- Limit the description to 50 characters maximum.
- Use proper grammar and punctuation in the commit body following Chicago Manual of Style.

Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

Example:

```text
fix(packages): add libnotify for zsh-auto-notify on Linux hosts

The zsh-auto-notify plugin requires notify-send (provided by libnotify)
to display desktop notifications on Linux. This adds libnotify to the
Linux-specific package list to satisfy this dependency.
```

## Tracking Tasks

Use [bd](https://github.com/steveyegge/beads) for tracking tasks.

## Landing the Plane (Session Completion)

When ending a work session, you must complete all the following mandatory steps. Work is not complete until `git push` succeeds.

- Clean up stale references first. Prevent accidental merge commits via `--ff-only` option. Maintain a linear history via `--rebase` option. Fail explicitly if conflicts would occur, rather than creating unexpected merges

    ```shell
    git fetch --all --prune --prune-tags --tags \
        && git pull --ff-only --rebase
    ```

- File issues for remaining work—create issues for anything that needs follow-up.
- Run quality gates if code changed. Run tests, linters, builds.
- Update issue status—close finished work, update in-progress items.
- Mandatory push to remote repository.

    ```shell
    git pull --rebase
    bd sync
    git push
    git status  # Must show "up to date with origin".
    ```

- Clean up by clearing stashes, prune remote branches.
- Verify that all changes committed and pushed.
- Hand off by providing context for next session.

Ensure the following non-negotiable critical steps are done successfully.

- Work is not complete until `git push` succeeds.
- Never stop before pushing because it leaves work stranded locally.
- Never say "ready to push when you are", the local commits must be pushed to remote repositories successfully.
- If push fails, resolve and retry until it succeeds.

---

[azure-security-best-practices]: https://learn.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns
[cis-benchmarks]: https://www.cisecurity.org/cis-benchmarks/
[github-actions-secure-use-reference]: https://docs.github.com/en/actions/reference/security/secure-use
[home-manager-options]: https://nix-community.github.io/home-manager/options.xhtml
[nix-manual]: https://nix.dev/manual/nix/latest
[nixos-manual]: https://nixos.org/manual/nixos/unstable/
[nixos-wiki-community]: https://nixos.wiki/
[nixos-wiki-official]: https://wiki.nixos.org/
[nixpkgs-packages]: https://search.nixos.org/packages?channel=unstable&type=packages
[noogle]: https://noogle.dev/
[owasp-cheat-sheet]: https://cheatsheetseries.owasp.org/
[owasp-top-ten]: https://owasp.org/www-project-top-ten/
[reference-style-links]: https://www.markdownguide.org/basic-syntax#reference-style-links
