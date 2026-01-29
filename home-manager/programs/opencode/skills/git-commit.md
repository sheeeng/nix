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

- Use imperative mood in the description ("add" not "added").
- Do not capitalize the first letter of the description.
- Do not end the description with a period.
- Limit the description to 50 characters.
- Wrap the body at 72 characters.
- Use the body to explain what and why, not how.
- Add `BREAKING CHANGE:` footer for breaking changes.

## When to Use Me

Use this when you need help writing a commit message.
Run `git diff --staged` first to see what will be committed.
