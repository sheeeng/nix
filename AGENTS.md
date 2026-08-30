# AGENTS

## Project Overview

This repository contains Nix flake configuration for NixOS systems and macOS
hosts. The primary tools are:

- **Nix flakes** with `nixpkgs-unstable` channel
- **Home Manager** for user-level program configuration
- **nix-darwin** for macOS system configuration
- **SOPS** for secrets management
- **pre-commit** with treefmt for formatting and linting
- **just** for task automation

## Project Structure

- `flake.nix`: Defines flake inputs, outputs, and host configurations
- `home-manager/`: Contains Home Manager module and program configurations
- `hosts/`: Contains per-host NixOS and nix-darwin system configurations
- `modules/`: Provides reusable NixOS, Home Manager, and nix-darwin modules
- `overlays/`: Extends nixpkgs with custom overlays
- `pkgs/`: Defines custom packages
- `scripts/`: Contains shell utility scripts
- `docs/`: Contains documentation, command references, and journals

## Commands

Validate the flake and run all pre-commit hooks before committing:

```shell
nix flake check
pre-commit run --all-files
```

Apply a NixOS configuration (also activates the embedded Home Manager):

```shell
sudo nixos-rebuild switch --flake .
```

Apply a nix-darwin configuration (also activates the embedded Home Manager):

```shell
sudo darwin-rebuild switch --flake .
```

Obtain a source hash for a new dependency:

```shell
nix-prefetch-git <url>
```

Additional command rules:

- Use GNU-style long options where available.
- Use the development shells from `nix develop` and `nix-shell` consistently.
- Search the Nix store for dependencies before adding new ones.
- Use `lib.fakeSha256` only as a temporary placeholder for source hashes.
- Save reusable command instructions in [Commands Document][docs-commands].
- Run read-only inspection commands without approval. Request approval before
  commands that modify files, commit, push, or contact external services.

## Code Style

Use alphanumerically sorted attribute sets. Annotate each Home Manager option
with its Home Manager options URL. Use `pkgs.lib.getExe` instead of hardcoded
paths for executable references.

```nix
# Good: sorted, annotated, uses lib.getExe
{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.enable
    package = pkgs.alacritty; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.package
    settings = {
      terminal.shell = {
        args = [ "--login" "-c" "exec ${pkgs.lib.getExe pkgs.nushell}" ];
        program = "${pkgs.lib.getExe pkgs.zsh}";
      };
    };
  };
}

# Bad: unsorted, no annotations, hardcoded path
{ pkgs, ... }:
{
  programs.alacritty = {
    package = pkgs.alacritty;
    enable = true;
    settings.terminal.shell.program = "/run/current-system/sw/bin/zsh";
  };
}
```

## Boundaries

- ✅ **Always do:** Run `nix flake check` and `pre-commit run --all-files`
  before committing. Use Home Manager options when they exist. Sort attribute
  sets alphanumerically. Use `nixpkgs-unstable` except for the intentional
  `nixpkgs-26.05-darwin` pin that preserves x86_64 Darwin compatibility.
  Annotate Home Manager options with their documentation URLs.
- ⚠️ **Ask first:** Add new flake inputs, modify SOPS-encrypted secrets in
  the `nix-secrets` flake input, change host hardware configurations, push
  to the remote, or create pull requests.
- 🚫 **Never do:** Hardcode API keys, passwords, tokens, or other secrets.
  Alias core commands in Nix configuration without explicit approval. Commit
  directly to a default or protected branch. Use Homebrew on macOS.

## Working Rules

- Preserve the user's intent, existing changes, and technical constraints.
- Prefer concise, maintainable, reusable solutions. Avoid speculative
  abstractions and unnecessary comments.
- Use Chicago Manual of Style. Use title case for headings and sentence case
  for explanatory text. Capitalize proper nouns.
- Use complete terms such as "configuration," "utility," and "function."
  Avoid slang and abbreviations such as "config," "util," and "func."
- Use active voice and imperative instructions. Use clear nouns and pronouns.
- Use standard English punctuation. Do not use decorative dashes or
  parenthetical asides in prose.

## Markdown

- Remove trailing whitespace. End every Markdown file with one newline.
- Write links as `[Title Case Text][kebab-case-label]`.
- Define each label once as `[kebab-case-label]: target` after the document
  body.
- Follow Markdown linting rules.

## Required Skills

Load `enforce-writing-style` before every other skill. Its required chain is
`enforce-asd-ste100`, followed by `forbid-llm-slop`. Apply ASD STE100 to
technical documentation and instructions. Load the task-specific skill after
that chain. Load `writing-for-agents` when editing `AGENTS.md` or `CLAUDE.md`.

## Journals

- Read all files in [Journals Directory][docs-journals] for historical context before changing
  related configuration.
- Save task summaries in [Journals Directory][docs-journals]. Name files with a UTC timestamp in
  `YYYYMMDDTHHMMSSZ.md` format.
- Use ISO 8601 timestamps in journal content.
- Use `~` or `${HOME}` instead of fully qualified paths.
- Do not record personally identifiable information or secrets.

## Security

- Do not hardcode API keys, passwords, tokens, or other secrets. Use
  environment variables or a secure vault.
- Keep dependencies current enough to receive security fixes.
- Use official guidance from [Azure Security Best Practices][azure-security-best-practices],
  [CIS Benchmarks][cis-benchmarks], [GitHub Actions Secure Use][github-actions-secure-use],
  [OWASP Cheat Sheet Series][owasp-cheat-sheet-series], and [OWASP Top Ten][owasp-top-ten].

## GitHub Actions

- Use a GitHub App token for repository automation that needs write access.
- Use empty top-level workflow permissions. Declare explicit permissions in
  each job.
- Push generated changes to an automation branch with lease protection.
- Create or update a pull request against `${GITHUB_REF_NAME}`.
- Keep generated commits out of the default or protected branch.

## Agent Models

Before configuring an agent model, verify its identifier against the open
source model database:

```shell
curl --silent --show-error --location https://models.dev/api.json \
    | jq '.anthropic.models | .[] | .id'
```

Use the `provider/model-id` format, for example:
`anthropic/claude-sonnet-4-5-20250929`.

## Commits

Use the `commit` skill before creating a commit. Use Conventional Commits:
`<type>(<scope>): <description>`.

- Keep the title at 50 characters or fewer.
- Use imperative mood and lowercase text in the description.
- Do not end the description with a period.
- Wrap body lines at 72 characters.
- Verify the title length before committing:
  `echo --no-newline "title" | wc --chars`.

## Task Tracking and Delivery

Use [Beads][beads] to track tasks. Before delivery, update the relevant task status
and create follow-up issues for unfinished work.

When the user authorizes synchronization and delivery, use this sequence:

```shell
git fetch --all --prune --prune-tags --tags
git pull --ff-only --rebase
bd dolt pull
bd dolt push
git push
git status
```

Confirm that the work tree is clean and the branch is up to date with its
remote. Do not commit, push, or create pull requests without user approval.

## Nix Configuration

Use Home Manager for user configuration when an option exists. Consult the
[Home Manager Options][home-manager-options], [Nix Manual][nix-manual], and
[Noogle][noogle] references when needed.

Always allow read queries from these documentation sources:

- [Home Manager Options][home-manager-options]
- [Nix Manual][nix-manual]
- [NixOS Manual][nixos-manual]
- [NixOS Wiki, Community][nixos-wiki-community]
- [NixOS Wiki, Official][nixos-wiki-official]

[azure-security-best-practices]: https://learn.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns
[beads]: https://github.com/gastownhall/beads
[cis-benchmarks]: https://www.cisecurity.org/cis-benchmarks/
[docs-commands]: ./docs/commands.md
[docs-journals]: ./docs/journals
[github-actions-secure-use]: https://docs.github.com/en/actions/reference/security/secure-use
[home-manager-options]: https://nix-community.github.io/home-manager/options.xhtml
[nix-manual]: https://nix.dev/manual/nix/latest
[nixos-manual]: https://nixos.org/manual/nixos/unstable/
[nixos-wiki-community]: https://nixos.wiki/
[nixos-wiki-official]: https://wiki.nixos.org/
[noogle]: https://noogle.dev/
[owasp-cheat-sheet-series]: https://cheatsheetseries.owasp.org/
[owasp-top-ten]: https://owasp.org/www-project-top-ten/
