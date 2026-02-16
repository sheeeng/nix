---
name: git-commit
description: Create conventional commit messages.
license: MIT
compatibility: opencode
metadata:
    audience: developers
    workflow: github
---

# Git Commit

## What I Do

- Analyze staged changes to generate commit messages.
- Follow the Conventional Commits specification (https://www.conventionalcommits.org/).
- Suggest appropriate commit type and scope.

## Commit Format

```text
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types

- `feat`: A new feature.
- `fix`: A bug fix.
- `docs`: Documentation-only changes.
- `style`: Changes that do not affect the meaning of the code.
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `perf`: A code change that improves performance.
- `test`: Adding missing tests or correcting existing tests.
- `build`: Changes that affect the build system or external dependencies.
- `ci`: Changes to CI configuration files and scripts.
- `chore`: Other changes that do not modify src or test files.
- `revert`: Reverts a previous commit.

## Guidelines

### Title (First Line)

- Use imperative mood in the description ("add" not "added").
- Keep the description entirely lowercase, including product names.
- Do not capitalize any words in the description.
- Do not end the description with a period.
- Limit the description to 50 characters maximum.

### Body (Optional Multi-Line Description)

- Use proper grammar and punctuation following Chicago Manual of Style.
- Start sentences with capital letters.
- End sentences with proper punctuation (periods, question marks, exclamation points).
- Wrap lines at 72 characters maximum per line.
- Use the body to explain what and why, not how.
- Write in complete sentences with correct punctuation.

### Footer

- Add `BREAKING CHANGE:` footer for breaking changes.

## Examples

**Good commit titles:**

- `feat: add user authentication`
- `fix: resolve memory leak in parser`
- `docs: update nix installation guide`
- `refactor: simplify opentofu configuration`
- `fix: replace terraform with opentofu`

**Bad commit titles:**

- `feat: Add user authentication` (incorrect: capitalized)
- `fix: Resolve memory leak in parser` (incorrect: capitalized)
- `docs: Update Nix installation guide` (incorrect: capitalized)
- `docs: Update installation guide.` (incorrect: ends with period)
- `feat: This adds a new feature for user authentication` (incorrect: too long, not imperative)

**Good commit with body (proper punctuation and grammar):**

```
feat(home-manager): configure browsers using programs options

Enable Firefox via programs.firefox for Linux systems. Add Chromium
configuration via programs.chromium. Configure LibreWolf and
Qutebrowser using their respective home-manager program options.

All browsers are configured for Linux only using pkgs.stdenv.isLinux.
Browsers without full home-manager support remain as packages.
```

**Bad commit body (missing punctuation):**

```
feat(home-manager): configure browsers using programs options

Enable Firefox via programs.firefox for Linux systems
Add Chromium configuration via programs.chromium
Configure LibreWolf and Qutebrowser
```

(incorrect: missing periods, not complete sentences)

## When to Use Me

Use this when you need help writing a commit message.
Run `git diff --staged` first to see what will be committed.
