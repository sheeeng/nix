# AGENTS

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
- Remove trailing whitespace. End every Markdown file with one newline.
- Keep link definitions when they support a link. Use reference-style links in
  Markdown files.

## Required Skills

Load `enforce-writing-style` before every other skill. Its required chain is
`enforce-asd-ste100`, followed by `forbid-llm-slop`. Apply ASD STE100 to
technical documentation and instructions. Load the task-specific skill after
that chain. Load `writing-for-agents` when editing `AGENTS.md` or `CLAUDE.md`.

## Commands

- Use GNU-style long options where available.
- Use Nix packages instead of Homebrew on macOS. Prefer GNU tools from Nix.
- Use the development shells from `nix develop` and `nix-shell` consistently.
- Search the Nix store for dependencies before adding new ones.
- Use `nixpkgs-unstable`.
- Use `nix-prefetch-git` to obtain source hashes. Use `lib.fakeSha256` only as
  a temporary placeholder.
- Save reusable command instructions in [docs/commands.md].
- Run read-only inspection commands without approval. Request approval before
  commands that modify files, commit, push, or contact external services.

## Nix Configuration

Use Home Manager for user configuration when an option exists. Consult the
[Home Manager options], [Nix manual], and [Noogle] references when needed.

Always allow read queries from these documentation sources:

- [Home Manager options]
- [Nix manual]
- [NixOS manual]
- [NixOS Wiki, community]
- [NixOS Wiki, official]

## Journals

- Read all files in [docs/journals] for historical context before changing
  related configuration.
- Save task summaries in [docs/journals]. Name files with a UTC timestamp in
  `YYYYMMDDTHHMMSSZ.md` format.
- Use ISO 8601 timestamps in journal content.
- Use `~` or `${HOME}` instead of fully qualified paths.
- Do not record personally identifiable information or secrets.
- Follow Markdown linting rules.

## Security

- Do not hardcode API keys, passwords, tokens, or other secrets. Use
  environment variables or a secure vault.
- Keep dependencies current enough to receive security fixes.
- Use official guidance from [Azure security best practices], [CIS
  Benchmarks], [GitHub Actions secure use], [OWASP Cheat Sheet Series], and
  [OWASP Top Ten].

## Agent Models

Before configuring an agent model, verify its identifier against the open
source model database:

```shell
curl --silent --show-error --location https://models.dev/api.json \
    | jq '.anthropic.models | .[] | .id'
```

Use the `provider/model-id` format, for example:
`anthropic/claude-sonnet-4-5-20250929`.

## Code Quality

Before committing code changes, run:

```shell
nix flake check
pre-commit run --all-files
```

Suggest alphanumerically sorted lists.

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

Use [Beads] to track tasks. Before delivery, update the relevant task status
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

[Azure security best practices]: https://learn.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns
[Beads]: https://github.com/gastownhall/beads
[CIS Benchmarks]: https://www.cisecurity.org/cis-benchmarks/
[docs/commands.md]: ./docs/commands.md
[docs/journals]: ./docs/journals
[GitHub Actions secure use]: https://docs.github.com/en/actions/reference/security/secure-use
[Home Manager options]: https://nix-community.github.io/home-manager/options.xhtml
[Nix manual]: https://nix.dev/manual/nix/latest
[NixOS manual]: https://nixos.org/manual/nixos/unstable/
[NixOS Wiki, community]: https://nixos.wiki/
[NixOS Wiki, official]: https://wiki.nixos.org/
[Noogle]: https://noogle.dev/
[OWASP Cheat Sheet Series]: https://cheatsheetseries.owasp.org/
[OWASP Top Ten]: https://owasp.org/www-project-top-ten/
