---
name: pull-request
description: Create or update pull request with proper message.
agent: builder
---

# Create or Update Pull Request

Load the `pull-request` skill first. Then, create a pull request title and description.

## Usage

/pull-request

## What This Command Does

- Loads the `pull-request` skill for pull request conventions.
- Skips execution if the current branch is the default branch.
- Analyzes all existing commits in the feature branch.
- Detects repository type for nixpkgs versus other repositories.
- Follows Conventional Commits for most repositories.
- Follows nixpkgs commit conventions for nixpkgs forks.
- Groups logical changes from feature branch commits.
- Generates a pull request title and description draft.
- Shows a preview of the pull request title and description.
- Asks for explicit confirmation before running any pull request command.
- Runs `gh pr create` if no pull request exists for the branch.
- Runs `gh pr edit` to update title and description if a pull request already exists.
