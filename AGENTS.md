# AGENTS

## Project Overview

This repository contains Nix flake configuration for NixOS systems and macOS
hosts. The primary tools are:

- **Nix flakes**: Manages packages and configurations with `nixpkgs-unstable`.
- **Home Manager**: Configures user-level programs and dotfiles.
- **nix-darwin**: Configures macOS system settings.
- **SOPS**: Encrypts and manages secrets via the `nix-secrets` flake input.
- **pre-commit**: Runs linting hooks before each commit.
- **treefmt**: Formats code, wired to `nix fmt` and `nix flake check`.
- **just**: Automates common development tasks.

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

Run the flake checks (includes treefmt via `nix fmt`):

```shell
nix flake check
```

Run all pre-commit hooks:

```shell
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
nix-prefetch-git https://github.com/owner/repo
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
    settings = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.settings
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

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:970c3bf2 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   bd dolt push
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->

<!-- BEGIN BEADS CODEX SETUP: generated by bd setup codex -->
## Beads Issue Tracker

Use Beads (`bd`) for durable task tracking in repositories that include it. Use the `beads` skill at `.agents/skills/beads/SKILL.md` (project install) or `~/.agents/skills/beads/SKILL.md` (global install) for Beads workflow guidance, then use the `bd` CLI for issue operations.

### Quick Reference

```bash
bd ready                # Find available work
bd show <id>            # View issue details
bd update <id> --claim  # Claim work
bd close <id>           # Complete work
bd prime                # Refresh Beads context
```

### Rules

- Use `bd` for all task tracking; do not create markdown TODO lists.
- Run `bd prime` when Beads context is missing or stale. Codex 0.129.0+ can load Beads context automatically through native hooks; use `/hooks` to inspect or toggle them.
- Keep persistent project memory in Beads via `bd remember`; do not create ad hoc memory files.

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.
<!-- END BEADS CODEX SETUP -->
