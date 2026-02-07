# Nixpkgs PR Branch Tracker: CLI Guide

This guide provides CLI steps to check whether a NixOS/nixpkgs PR merge commit has propagated to various NixOS branches.

See [staging](https://github.com/NixOS/nixpkgs/blob/ec80ea750adcfbd3a20e9fa623096135b3f5194e/CONTRIBUTING.md#staging) documentation.

## Overview

When a PR is merged into NixOS/nixpkgs, it first lands in `master`. From there, it propagates to other branches/channels:

| Branch                 | Description                                                             |
| ---------------------- | ----------------------------------------------------------------------- |
| `master`               | Main development branch where PRs are merged first                      |
| `staging`              | Target branch for PRs causing large rebuilds (501+ packages)            |
| `staging-next`         | Staging area for large rebuilds before merging to master                |
| `nixpkgs-unstable`     | Continuously updated from master after CI passes (for general packages) |
| `nixos-unstable`       | Like nixpkgs-unstable but includes NixOS tests                          |
| `nixos-unstable-small` | Fast-track channel for small, critical updates                          |

## Example: PR #484788

We will use [PR #484788](https://github.com/NixOS/nixpkgs/pull/484788) (`_3cpio: 0.13.0 -> 0.13.1`) as an example.

---

## Step 1: Get the Merge Commit SHA

### Option A: Using GitHub CLI (`gh`)

```bash
# Get PR details including merge commit SHA
gh pr view 484788 --repo NixOS/nixpkgs --json mergeCommit,merged,state

# Extract just the merge commit SHA
MERGE_COMMIT=$(gh pr view 484788 --repo NixOS/nixpkgs --json mergeCommit --jq '.mergeCommit.oid')
echo "Merge commit: $MERGE_COMMIT"
```

### Option B: Using `curl` with GitHub API

```bash
# Without authentication (limited to 60 requests/hour)
curl -s https://api.github.com/repos/NixOS/nixpkgs/pulls/484788 | jq -r '.merge_commit_sha'

# With authentication (5000 requests/hour)
curl -s -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/NixOS/nixpkgs/pulls/484788 | jq -r '.merge_commit_sha'
```

### Option C: Using `git` directly

```bash
# If you have the nixpkgs repo cloned
cd /path/to/nixpkgs
git fetch origin pull/484788/head:pr-484788
git log pr-484788 -1 --format="%H"
```

For PR #484788, the merge commit is: `3f96296da66f5ecf3d8106c61281b823949a56c0`

---

## Step 2: Check if the Commit Exists in Each Branch

### Option A: Using GitHub API Compare Endpoint

The GitHub API's compare endpoint returns a `status` field indicating the relationship:

- `ahead` or `identical`: The branch contains the commit
- `behind` or `diverged`: The branch does not contain the commit

```bash
# Set variables
MERGE_COMMIT="3f96296da66f5ecf3d8106c61281b823949a56c0"
REPO="NixOS/nixpkgs"

# Define branches to check
BRANCHES=("master" "staging" "staging-next" "nixos-unstable-small" "nixos-unstable" "nixpkgs-unstable")

# Check each branch
for BRANCH in "${BRANCHES[@]}"; do
  STATUS=$(curl -s "https://api.github.com/repos/${REPO}/compare/${MERGE_COMMIT}...${BRANCH}" | jq -r '.status')

  if [[ "$STATUS" == "ahead" || "$STATUS" == "identical" ]]; then
    echo "✅ $BRANCH: commit is present"
  else
    echo "⚠️  $BRANCH: commit NOT present (status: $STATUS)"
  fi
done
```

### Option B: Using `gh api` (GitHub CLI)

```bash
MERGE_COMMIT="3f96296da66f5ecf3d8106c61281b823949a56c0"
REPO="NixOS/nixpkgs"

for BRANCH in master staging staging-next nixos-unstable-small nixos-unstable nixpkgs-unstable; do
  STATUS=$(gh api "repos/${REPO}/compare/${MERGE_COMMIT}...${BRANCH}" --jq '.status')

  if [[ "$STATUS" == "ahead" || "$STATUS" == "identical" ]]; then
    echo "✅ $BRANCH"
  else
    echo "⚠️  $BRANCH (status: $STATUS)"
  fi
done
```

### Option C: Using Local Git Repository

If you have nixpkgs cloned locally:

```bash
cd /path/to/nixpkgs
MERGE_COMMIT="3f96296da66f5ecf3d8106c61281b823949a56c0"

# Fetch all remote branches
git fetch origin

for BRANCH in master staging staging-next nixos-unstable-small nixos-unstable nixpkgs-unstable; do
  if git merge-base --is-ancestor "$MERGE_COMMIT" "origin/$BRANCH" 2>/dev/null; then
    echo "✅ $BRANCH: commit is present"
  else
    echo "⚠️  $BRANCH: commit NOT present"
  fi
done
```

---

## Complete Script

Here is a complete bash script that combines all steps:

```bash
#!/usr/bin/env bash
# nixpkgs-branch-tracker.sh
# Usage: ./nixpkgs-branch-tracker.sh <PR_NUMBER>

set -euo pipefail

PR_NUMBER="${1:-}"
REPO="NixOS/nixpkgs"

if [[ -z "$PR_NUMBER" ]]; then
  echo "Usage: $0 <PR_NUMBER>"
  echo "Example: $0 484788"
  exit 1
fi

echo "Checking PR #${PR_NUMBER} in ${REPO}..."
echo

# Get PR details
PR_DATA=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json mergeCommit,merged,state,title 2>/dev/null)

MERGED=$(echo "$PR_DATA" | jq -r '.merged')
STATE=$(echo "$PR_DATA" | jq -r '.state')
TITLE=$(echo "$PR_DATA" | jq -r '.title')
MERGE_COMMIT=$(echo "$PR_DATA" | jq -r '.mergeCommit.oid')

echo "Title: $TITLE"
echo "State: $STATE"
echo "Merged: $MERGED"
echo "Merge Commit: $MERGE_COMMIT"
echo

if [[ "$MERGED" != "true" ]]; then
  echo "PR is not merged yet. Cannot check branch propagation."
  exit 0
fi

echo "Checking branch propagation..."
echo "────────────────────────────────────────"

BRANCHES=("master" "staging" "staging-next" "nixos-unstable-small" "nixos-unstable" "nixpkgs-unstable")

for BRANCH in "${BRANCHES[@]}"; do
  STATUS=$(gh api "repos/${REPO}/compare/${MERGE_COMMIT}...${BRANCH}" --jq '.status' 2>/dev/null || echo "error")

  case "$STATUS" in
    ahead|identical)
      printf "✅ %-20s (commit present)\n" "$BRANCH"
      ;;
    behind)
      printf "⚠️  %-20s (not yet propagated)\n" "$BRANCH"
      ;;
    diverged)
      printf "⚠️  %-20s (diverged)\n" "$BRANCH"
      ;;
    *)
      printf "❓ %-20s (status: %s)\n" "$BRANCH" "$STATUS"
      ;;
  esac
done

echo "────────────────────────────────────────"
echo
echo "View comparisons on GitHub:"
for BRANCH in "${BRANCHES[@]}"; do
  echo "  $BRANCH: https://github.com/${REPO}/compare/${MERGE_COMMIT}...${BRANCH}"
done
```

### Usage

```bash
# Make the script executable
chmod +x nixpkgs-branch-tracker.sh

# Run with a PR number
./nixpkgs-branch-tracker.sh 484788
```

### Example Output

Output as of January 28, 2026 (results will vary based on when you run the command):

```text
Checking PR #484788 in NixOS/nixpkgs...

Title: _3cpio: 0.13.0 -> 0.13.1
State: MERGED
Merged: true
Merge Commit: 3f96296da66f5ecf3d8106c61281b823949a56c0

Checking branch propagation...
────────────────────────────────────────
✅ master               (commit present)
⚠️  staging              (not yet propagated)
✅ staging-next         (commit present)
⚠️  nixos-unstable-small (not yet propagated)
⚠️  nixos-unstable       (not yet propagated)
⚠️  nixpkgs-unstable     (not yet propagated)
────────────────────────────────────────

View comparisons on GitHub:
  master: https://github.com/NixOS/nixpkgs/compare/3f96296...master
  nixos-unstable-small: https://github.com/NixOS/nixpkgs/compare/3f96296...nixos-unstable-small
  ...
```

> **Note:** Branch propagation status changes over time as commits flow from `master` to other branches/channels. The output above reflects the state at the time of writing.

---

## Prerequisites

- **GitHub CLI (`gh`)**: Install from [cli.github.com](https://cli.github.com/) and authenticate with `gh auth login`
- **jq**: JSON processor, install via your package manager
- **curl**: Usually pre-installed on most systems

### Installation on NixOS/Nix

```bash
nix-shell -p gh jq curl
# or
nix shell nixpkgs#gh nixpkgs#jq nixpkgs#curl
```

---

## Understanding the Compare API Response

The GitHub Compare API (`/repos/{owner}/{repo}/compare/{base}...{head}`) returns:

| Status      | Meaning                                                          |
| ----------- | ---------------------------------------------------------------- |
| `ahead`     | Head branch is ahead of base (contains base's commits plus more) |
| `behind`    | Head branch is behind base (base has commits not in head)        |
| `identical` | Both refs point to the same commit                               |
| `diverged`  | Branches have diverged (each has unique commits)                 |

When checking if a merge commit is in a branch:

- We compare `{merge_commit}...{branch}`
- If status is `ahead` or `identical`, the branch contains the commit
- If status is `behind`, the commit has not propagated to that branch yet

---

## Example: PR #480465 (Staging Branch)

PR [#480465][pr-480465] (`go_1_25: 1.25.5 -> 1.25.6`) was merged into the `staging` branch rather than `master`, because Go rebuilds 501+ packages. This demonstrates the staging workflow for large-rebuild PRs.

Merge commit: `291061e90921577ecabcd323f78de4996820d2a1`

```bash
./nixpkgs-branch-tracker.sh 480465
```

Since this PR targets `staging`, the propagation path differs:

1. The commit first appears in `staging`.
2. It moves to `staging-next` when staging is merged.
3. From `staging-next`, it reaches `master`.
4. Finally, it propagates to the channel branches (`nixpkgs-unstable`, `nixos-unstable`, `nixos-unstable-small`).

---

## Related Resources

- [NixOS Channel Status][nixos-channel-status] - Official channel status page
- [Nixpkgs Manual: Channels][nixpkgs-manual-channels]

[nixos-channel-status]: https://status.nixos.org/
[nixpkgs-manual-channels]: https://nixos.org/manual/nixpkgs/stable/#sec-channel-branches
[pr-480465]: https://github.com/NixOS/nixpkgs/pull/480465
