---
name: fix
description: "Apply a Copilot or GitHub pull request review: fetch each unresolved comment, implement the change, and resolve the thread."
agent: builder
---

# Fix

Apply every unresolved comment from a Copilot or GitHub pull request review.

## Usage

```
/fix <pull-request-review-url>
```

## What This Command Does

1. Extract the repository owner, repository name, and pull request number from
   the URL.
2. Fetch all unresolved review comment threads using the GitHub CLI:

   ```shell
   gh api repos/{owner}/{repo}/pulls/{number}/comments
   ```

3. For each unresolved thread, in order of file path and line number:
   a. Read the comment to understand what change is requested.
   b. Open the file at the referenced line.
   c. Apply the minimum change that satisfies the comment.
   d. Run type checking and any relevant tests for the changed file.
   e. Resolve the thread:

      ```shell
      gh api --method PATCH \
        repos/{owner}/{repo}/pulls/comments/{comment-id} \
        --field body="Resolved."
      ```

4. After all threads are addressed, run the full test suite.
5. Use /commit to commit the changes.

## Rules

- Resolve every thread you address. Note any partial fix in the resolution message.
- Do not skip a thread. If a change conflicts with another, address the
  conflict explicitly and note it in the resolution.
- Do not resolve a thread you did not act on.
