---
name: commit
agent: builder
---

# Commit

Load the `git-commit` skill first, then create a git commit with proper message formatting.

Use the `git-commit` skill to analyze staged changes and generate proper commit messages following Conventional Commits or nixpkgs conventions as appropriate.

## Usage

/commit

## What This Command Does

- Loads the `git-commit` skill for commit message conventions.
- Analyzes staged changes in the git repository.
- Detects repository type for nixpkgs versus other repositories.
- Follows Conventional Commits for most repositories.
- Follows nixpkgs commit conventions for nixpkgs forks.
- Generates appropriate commit type and scope.
- Ensures proper formatting and message structure.
