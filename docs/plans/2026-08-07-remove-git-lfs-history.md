# Remove Git LFS History Implementation Plan

> **For Claude:** REQUIRED SUB SKILL: Use `executing-plans` to implement this plan one task at a time.

**Goal:** Remove Git LFS tracking from every reachable branch and tag on all five repository hosts.

**Architecture:** Perform the destructive rewrite in a fresh external mirror created from an untouched backup mirror. Transform only historical `.gitattributes` blobs, verify the rewritten object graph, then force push branches and tags to each host and verify each advertised reference.

**Technology:** Git 2.55 or later, Git Filter Repo 2.47 or later, Git LFS 3.7 or later, Nix, and SSH.

## Task 1: Prepare the Rewrite Environment

### Files

1. Preserve without modification: `.beads/embeddeddolt/`
2. Create outside the workspace: `${TMPDIR}/nix-lfs-rewrite/backup.git`
3. Create outside the workspace: `${TMPDIR}/nix-lfs-rewrite/rewrite.git`
4. Create outside the workspace: `${TMPDIR}/nix-lfs-rewrite/original-refs.txt`

#### Step 1: Confirm the Workspace State

Run:

```shell
git status --short --branch
git worktree list --porcelain
```

Expected: `unstable` tracks `origin/unstable`, `.beads/embeddeddolt/` is untracked, and the Beads worktree is present.

#### Step 2: Confirm Git Filter Repo Availability through Nix

Run:

```shell
nix shell nixpkgs#git-filter-repo --command git-filter-repo --version
```

Expected: Git Filter Repo reports version 2.47.0 or later.

#### Step 3: Create the External Parent Directory

Run:

```shell
ls "${TMPDIR}"
mkdir --parents "${TMPDIR}/nix-lfs-rewrite"
```

Expected: the parent exists and the rewrite directory is created outside the workspace.

## Task 2: Build an Untouched Union Backup

### Files

1. Create: `${TMPDIR}/nix-lfs-rewrite/backup.git`
2. Create: `${TMPDIR}/nix-lfs-rewrite/original-refs.txt`

#### Step 1: Clone the GitHub Mirror

Run:

```shell
git clone --mirror git@github.com:sheeeng/nix.git "${TMPDIR}/nix-lfs-rewrite/backup.git"
```

Expected: the bare mirror clone completes successfully.

#### Step 2: Add the Remaining Hosts

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" remote add codeberg ssh://git@codeberg.org/sheeeng/nix.git
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" remote add gitea git@gitea.com:sheeeng/nix.git
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" remote add gitlab git@gitlab.com:sheeeng/nix.git
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" remote add sourcehut git@git.sr.ht:~sheeeng/nix
```

Expected: all remotes are added without changing remote repositories.

#### Step 3: Fetch the Branch and Tag Union

Run once for each added remote:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" fetch --force REMOTE '+refs/heads/*:refs/heads/*' '+refs/tags/*:refs/tags/*'
```

Replace `REMOTE` with `codeberg`, `gitea`, `gitlab`, and `sourcehut`.

Expected: all six known branches are available under `refs/heads/` and no tags are reported.

#### Step 4: Record the Original References

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" show-ref --heads --tags > "${TMPDIR}/nix-lfs-rewrite/original-refs.txt"
```

Expected: the manifest records every branch and tag with its original object identifier.

## Task 3: Rewrite Historical Attributes

### Files

1. Create: `${TMPDIR}/nix-lfs-rewrite/rewrite.git`
2. Modify through history: `.gitattributes`
3. Create: `${TMPDIR}/nix-lfs-rewrite/rewritten-refs.txt`

#### Step 1: Create a Fresh Rewrite Mirror from the Backup

Run:

```shell
git clone --mirror --no-local "${TMPDIR}/nix-lfs-rewrite/backup.git" "${TMPDIR}/nix-lfs-rewrite/rewrite.git"
```

Expected: the second mirror is independent from the backup object store.

#### Step 2: Remove the Git LFS Attribute from Every Reachable Revision

Run:

```shell
nix shell nixpkgs#git-filter-repo --command git -C "${TMPDIR}/nix-lfs-rewrite/rewrite.git" filter-repo --file-info-callback '
if filename != b".gitattributes":
    return filename, mode, blob_id

contents = value.get_contents_by_identifier(blob_id)
lfs_rule = b"*.png filter=lfs diff=lfs merge=lfs -text"
new_contents = b"".join(
    line for line in contents.splitlines(keepends=True)
    if line.rstrip(b"\r\n") != lfs_rule
)

if new_contents == contents:
    return filename, mode, blob_id

new_blob_id = value.insert_file_with_contents(new_contents)
return filename, mode, new_blob_id
'
```

Expected: Git Filter Repo rewrites affected commits and removes its source remote as a safety measure.

#### Step 3: Record the Rewritten References

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" show-ref --heads --tags > "${TMPDIR}/nix-lfs-rewrite/rewritten-refs.txt"
```

Expected: branch names match the original manifest, while affected object identifiers differ.

## Task 4: Verify the Rewritten Object Graph

### Files

1. Read: `${TMPDIR}/nix-lfs-rewrite/rewrite.git`
2. Read: `${TMPDIR}/nix-lfs-rewrite/original-refs.txt`
3. Read: `${TMPDIR}/nix-lfs-rewrite/rewritten-refs.txt`

#### Step 1: Verify Repository Integrity

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" fsck --full
```

Expected: no missing or corrupt reachable objects.

#### Step 2: Verify That Git LFS Attributes Are Absent

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" log --all --oneline -S'filter=lfs' -- .gitattributes
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" log --all --oneline -S'diff=lfs' -- .gitattributes
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" log --all --oneline -S'merge=lfs' -- .gitattributes
```

Expected: all three commands return no commits.

#### Step 3: Verify That Git LFS Pointers Are Absent

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" log --all --oneline -S'version https://git-lfs.github.com/spec/v1'
```

Expected: the command returns no commits.

#### Step 4: Compare Branch and Tag Names

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/backup.git" for-each-ref --format='%(refname)' refs/heads refs/tags
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" for-each-ref --format='%(refname)' refs/heads refs/tags
```

Expected: both commands print the same sorted reference names.

## Task 5: Update Every Repository Host

### Files

1. Read: `${TMPDIR}/nix-lfs-rewrite/rewrite.git`
2. Update remote branches and tags on five hosts.

#### Step 1: Force Push Branches and Tags to SourceHut

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" push --force git@git.sr.ht:~sheeeng/nix 'refs/heads/*:refs/heads/*' 'refs/tags/*:refs/tags/*'
```

Expected: all rewritten branches and tags are accepted.

#### Step 2: Force Push Branches and Tags to Gitea

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" push --force git@gitea.com:sheeeng/nix.git 'refs/heads/*:refs/heads/*' 'refs/tags/*:refs/tags/*'
```

Expected: all rewritten branches and tags are accepted.

#### Step 3: Force Push Branches and Tags to GitHub

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" push --force git@github.com:sheeeng/nix.git 'refs/heads/*:refs/heads/*' 'refs/tags/*:refs/tags/*'
```

Expected: all rewritten branches and tags are accepted.

#### Step 4: Force Push Branches and Tags to GitLab

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" push --force git@gitlab.com:sheeeng/nix.git 'refs/heads/*:refs/heads/*' 'refs/tags/*:refs/tags/*'
```

Expected: all rewritten branches and tags are accepted.

#### Step 5: Force Push Branches and Tags to Codeberg

Run:

```shell
git --git-dir="${TMPDIR}/nix-lfs-rewrite/rewrite.git" push --force ssh://git@codeberg.org/sheeeng/nix.git 'refs/heads/*:refs/heads/*' 'refs/tags/*:refs/tags/*'
```

Expected: all rewritten branches and tags are accepted without a Git LFS locking message.

## Task 6: Verify Every Host and Fresh Clone

### Files

1. Create outside the workspace: `${TMPDIR}/nix-lfs-rewrite/verification/`

#### Step 1: Compare Every Advertised Remote Reference

Run `git ls-remote --heads --tags URL` for each host URL from Task 5.

Expected: every host advertises the same branch and tag object identifiers as `${TMPDIR}/nix-lfs-rewrite/rewritten-refs.txt`.

#### Step 2: Create a Fresh Verification Clone

Run:

```shell
git clone --no-local git@github.com:sheeeng/nix.git "${TMPDIR}/nix-lfs-rewrite/verification"
```

Expected: the clone completes without requiring Git LFS objects.

#### Step 3: Verify the Fresh Clone

Run:

```shell
git -C "${TMPDIR}/nix-lfs-rewrite/verification" lfs ls-files --all --long
git -C "${TMPDIR}/nix-lfs-rewrite/verification" log --all --oneline -S'filter=lfs' -- .gitattributes
git -C "${TMPDIR}/nix-lfs-rewrite/verification" fsck --full
```

Expected: both Git LFS searches return no output and the integrity check succeeds.

## Task 7: Retire Stale Local History

### Files

1. Preserve as required: `.beads/embeddeddolt/`
2. Replace: the current repository clone and linked worktrees.

#### Step 1: Preserve Required Untracked Beads State outside the Repository

Copy `.beads/embeddeddolt/` to an approved external recovery location before removing the old clone.

Expected: the preserved copy exists outside every repository worktree.

#### Step 2: Remove Git LFS Integration from Future Local Clones

Run `git lfs uninstall --local` in any clone that will remain temporarily.

Expected: the repository Git LFS hooks are removed without changing global Git LFS availability.

#### Step 3: Replace Stale Clones

Delete every clone and worktree containing original references, then clone the rewritten repository again. Restore only required untracked Beads state. Do not copy `.git`, old branches, tags, stashes, reflogs, or worktree metadata.

Expected: no local reference can restore the old history.

#### Step 4: Run Final Verification

Run:

```shell
git status --short --branch
git lfs ls-files --all --long
git log --all --oneline -S'filter=lfs' -- .gitattributes
git fsck --full
```

Expected: the branch tracks the rewritten remote, both Git LFS searches return no output, and repository integrity succeeds.

## Recovery Procedure

If any rewrite verification fails before remote updates, remove only `${TMPDIR}/nix-lfs-rewrite/rewrite.git` and repeat from the untouched backup.

If remote updates partially succeed, do not make new commits or accept collaborator pushes. Retry the exact Task 5 command for every failed host. Use `${TMPDIR}/nix-lfs-rewrite/rewritten-refs.txt` as the authoritative reference manifest.

Restore old history only when explicitly required by pushing `${TMPDIR}/nix-lfs-rewrite/backup.git` branches and tags back to every host. This recovery reverses the removal and must not occur after collaborators begin using the rewritten history.

## Commit Policy

Do not create a normal commit for this operation. The rewrite itself replaces historical commits, and the design and implementation plan become part of the rewritten history only if they are committed before the rewrite. Obtain explicit approval before creating such a commit.
