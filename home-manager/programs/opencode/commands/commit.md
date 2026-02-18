---
name: commit
agent: git-commit
---

# Commit

Create a git commit with proper message formatting following Conventional Commits or nixpkgs conventions as appropriate.

Use the `git-commit` skill to analyze staged changes and generate proper commit messages.

## Usage

/commit

## What This Does

- Analyzes staged changes in the git repository.
- Detects repository type (nixpkgs vs. other).
- Follows Conventional Commits for most repos.
- Follows nixpkgs commit conventions for nixpkgs forks.
- Generates appropriate commit type and scope.
- Ensures proper formatting and message structure.
