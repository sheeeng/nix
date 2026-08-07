---
name: upsert-github-release
description: Draft tagged releases and changelogs from merged pull requests and propose a version bump. Use whenever the user is preparing a release, cutting a tag, writing release notes, or updating a changelog, including phrases like "cut a release", "draft release notes", or "bump the version", to produce a copy-pasteable gh release create command.
license: Apache-2.0 OR MIT
---

# Upsert GitHub Release

## What This Skill Does

- Load the `enforce-writing-style` skill for writing style guidelines before continuing.
- Draft release notes from merged PRs.
- Propose a version bump.
- Provide a copy-pasteable `gh release create` command.
- Ask clarifying questions if the target versioning scheme is unclear.
