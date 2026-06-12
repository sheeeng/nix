---
name: commit
description: Commit changes with proper message.
agent: builder
---

# Commit

Load the `upsert-git-commit` skill first, then create a git commit with proper message formatting.

Use the `upsert-git-commit` skill to analyze staged changes and generate proper commit messages following Conventional Commits or nixpkgs conventions as appropriate.

## Usage

/commit

## What This Command Does

- Loads the `upsert-git-commit` skill for commit message conventions.
- Analyzes staged changes in the git repository.
- Detects repository type for nixpkgs versus other repositories.
- Follows Conventional Commits for most repositories.
- Follows nixpkgs commit conventions for nixpkgs forks.
- Generates appropriate commit type and scope.
- Ensures proper formatting and message structure.

## Important: Pre-commit Cache

Do NOT set or override `PRE_COMMIT_HOME` when running `git commit`. Always
run `git commit` without any `PRE_COMMIT_HOME` override so that pre-commit
uses the existing environment cache at `~/.cache/pre-commit/`. Setting
`PRE_COMMIT_HOME` to a temporary directory causes pre-commit to attempt
fresh environment installation, which requires network access unavailable
in the sandbox.
