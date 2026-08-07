# Remove Git LFS History Design

## Goal

Remove Git LFS tracking from every reachable branch and tag, update all five repository hosts, and prevent the local repository from invoking Git LFS during future pushes.

## Findings

The reachable history contains no Git LFS pointer files. `git lfs fsck --pointers --objects` succeeds, `git lfs ls-files --all --long` returns no files, and `git lfs migrate info --everything` reports no reachable Git LFS objects. The remaining repository integration is the `*.png` Git LFS rule in `.gitattributes`.

The remote repositories collectively contain these branches:

1. `beads-sync`
2. `chore/ephmeral-x86_64-darwin`
3. `renovate/pre-commit-hooks`
4. `stable`
5. `unstable`
6. `update/unstable`

No remote tags are currently present.

## Approach

Create an external mirror backup, then create a second fresh mirror from that backup. Fetch the union of branches and tags from SourceHut, Gitea, GitHub, GitLab, and Codeberg into the backup before the rewrite.

Run `git filter-repo` in the fresh rewrite mirror with a file information callback. The callback changes only `.gitattributes` blobs and removes the exact `*.png filter=lfs diff=lfs merge=lfs -text` line. Other attributes and file contents remain unchanged.

Force push the rewritten branch and tag namespace to every host. This makes the same branch and tag set available from every host and replaces references that retain the old `.gitattributes` history.

## Safety and Recovery

The backup mirror remains outside the workspace and is not modified. Record every original and rewritten reference before any push. If verification fails before a push, discard the rewrite mirror and leave all remotes unchanged. If a remote update fails, retain the rewrite mirror, correct that host's branch protection or permissions, and retry the same push.

Do not use the current working repository as the rewrite source. It contains untracked Beads state, a linked Beads worktree, local branches, and stashes. After every remote passes verification, preserve required untracked state and replace existing clones with fresh clones. This prevents stale references from restoring the old history.

## Verification

Verification must establish all of the following results:

1. No reachable blob begins with the Git LFS pointer signature.
2. No reachable `.gitattributes` blob contains `filter=lfs`, `diff=lfs`, or `merge=lfs`.
3. Every host advertises the expected rewritten branch and tag references.
4. A fresh clone reports no Git LFS tracked files.
5. A normal push does not invoke the repository's Git LFS hook.

## Consequences

Commit identifiers from the first affected `.gitattributes` commit onward will change. Existing pull requests, commit links, signatures, and local references can become stale. Every other clone must be deleted and cloned again.

Remote Git LFS object retention is controlled by each hosting provider. This repository has no reachable Git LFS objects to export or delete, so the rewrite addresses the remaining Git history and hook integration.

## References

1. [Git Filter Repo documentation][git-filter-repo]
2. [Git LFS migration documentation][git-lfs-migrate]

[git-filter-repo]: https://github.com/newren/git-filter-repo/blob/main/Documentation/git-filter-repo.txt
[git-lfs-migrate]: https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-migrate.adoc
