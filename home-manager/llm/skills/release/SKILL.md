---
name: release
description: Draft tagged releases and changelogs from merged pull requests and propose a version bump. Use whenever the user is preparing a release, cutting a tag, writing release notes, or updating a changelog, including phrases like "cut a release", "draft release notes", or "bump the version", to produce a copy-pasteable gh release create command.
license: Apache-2.0 OR MIT
---

# Prepare a GitHub Release

## Repository Validation

1. Run `git rev-parse --is-inside-work-tree` before all other Git commands.
2. Continue only when the command returns `true`.
3. Run `gh repo view --json nameWithOwner,url` to resolve the current repository.
4. Continue only when GitHub resolves the repository.
5. If a check fails, stop and tell the user which repository requirement failed.

## What This Skill Does

- Load the `enforce-writing-style` skill for writing style guidelines before continuing.
- Confirm that the current directory is in a Git work tree.
- Confirm that GitHub resolves the current repository.
- Draft release notes from merged PRs.
- Propose a version bump.
- Provide a copy-pasteable `gh release create` command.
- Ask clarifying questions if the target versioning scheme is unclear.
