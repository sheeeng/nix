---
name: fix-issue
description: Fix Issue
agent: builder
---

# Fix Issue

Detect the issue tracker from the issue number or URL, load the appropriate skill, then analyze and fix the issue.

## Usage

/fix-issue [issue-number/issue-url-link]

## What This Command Does

- Detects the issue tracker from the issue number or URL.
- Loads the appropriate issue-fixing skill for the detected tracker. For example, load the `fix-github-issue` skill for GitHub issues.
- Analyzes the issue description and any linked code.
- Proposes a fix based on the issue context.
- Creates or modifies files to implement the fix.
- Suggests a commit message following conventional commits.
