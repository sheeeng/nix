# Rules

## Skill Enforcement

Load `enforce-writing-style` before every other skill. Its required chain is
`enforce-asd-ste100` and `forbid-llm-slop`. Complete that chain before loading
the requested skill.

## Writing Style

Use Chicago Manual of Style conventions in all tasks. Use title case for
headings and sentence case for explanatory text. Capitalize proper nouns.
Use correct grammar and punctuation. Avoid decorative dashes and unnecessary
hyphenated compounds. In diagrams, end every imperative label with a period
and every question label with a question mark. Apply this without being asked.
Apply ASD STE100 Simplified Technical English Issue 9 to technical
documentation, procedures, safety instructions, and operational information.

Use full terms such as "configuration," "utility," and "function." Do not
use abbreviated variable names.

## Technical Documentation

Apply ASD STE100 Simplified Technical English Issue 9 to technical
documentation, procedures, safety instructions, and operational information.

## Commands

Use GNU style long options in shell commands. Do not alias core commands in
Nix configuration without explicit approval. Use `git commit --message`,
`git pull --ff-only --rebase`, and `git fetch --all --prune --prune-tags --tags`.

## Markdown

Use reference style links in Markdown files. End files with one newline and
remove trailing whitespace.

## Branches and Worktrees

Name Git branches and worktrees with the [Conventional Branch][conventional-branch]
specification. Use a purpose prefix such as `feat/`, `fix/`, `hotfix/`,
`release/`, or `chore/`. Never use `ai/`, `claude/`, `copilot/`, `cursor/`, or
a similar LLM prefix. If a session starts on a `claude/` branch, rename it before
the first commit.

## Commits and Pull Requests

In commit messages and pull request descriptions, reference issues only as
`Fix <full issue URL>.`, for example
`Fix https://github.com/NixOS/nixpkgs/issues/3142`. Never use
`Closes #<number>.` or other short issue references.

## Code Quality

Prefer concise, maintainable, and reusable solutions. Avoid unnecessary
comments. Suggest alphanumerically sorted lists.

[conventional-branch]: https://conventionalbranch.org/
