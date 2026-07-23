---
name: fix-github-issue
description: Analyze and fix a GitHub issue in the current repository. Use whenever the user references a GitHub issue to resolve, including phrases like "fix issue #123", "work on this issue", or pasting an issue URL or number, to fetch the issue, analyze it, implement a fix, and suggest a conventional commit message.
license: Apache-2.0 OR MIT
---

# Fix GitHub Issue

## What This Skill Does

- Load the `apply-writing-style` skill for writing style guidelines before continuing.
- Skip execution if the given issue is not a GitHub issue.
- Fetch the issue details from GitHub using `gh issue view`.
- Analyze the issue description and any linked code.
- Propose a fix based on the issue context.
- Create or modify files to implement the fix.
- Suggest a commit message following conventional commits.

## Guidelines

- Read the issue thoroughly before making changes.
- Check for related issues or pull requests.
- Follow the repository's coding conventions.
- Write tests when applicable.
- Keep changes focused on the specific issue.
