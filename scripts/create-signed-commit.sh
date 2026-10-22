#!/usr/bin/env bash
# Create a verified signed commit on a GitHub branch.
#
# Uses the GitHub GraphQL createCommitOnBranch mutation. GitHub signs
# commits created through this API automatically, so they show as
# Verified on GitHub. A GitHub App cannot own a GPG or SSH key, so
# this mutation is the only way to produce verified commits from a bot.
#
# Usage:
#   create-signed-commit.sh \
#     --token TOKEN \
#     --repository OWNER/REPO \
#     --branch BRANCH \
#     --base-ref BASE_REF \
#     --message MESSAGE \
#     -- FILE [FILE ...]
#
# Arguments:
#   --token        GitHub App installation token with contents:write.
#   --repository   Repository in OWNER/REPO format.
#   --branch       Target branch to create or update.
#   --base-ref     Branch whose HEAD becomes the parent commit.
#   --message      Commit headline (subject line).
#   FILE           Paths to files to include, relative to the working
#                  directory. All listed files are added or replaced.
#
# The script commits only the listed files via the GraphQL API. It does
# not run git commit or git push. The signed commit is created on a
# staging branch first; the destination branch is updated only after
# the signing succeeds, so a signing failure leaves any pre-existing
# update on the destination branch intact.

set -o errexit
set -o nounset
set -o pipefail

usage() {
  printf 'Usage: %s --token TOKEN --repository OWNER/REPO\n' "${BASH_SOURCE[0]}" >&2
  printf '       %*s --branch BRANCH --base-ref BASE_REF\n' "${#BASH_SOURCE[0]}" "" >&2
  printf '       %*s --message MESSAGE -- FILE [FILE ...]\n' "${#BASH_SOURCE[0]}" "" >&2
  exit 1
}

token=""
repository=""
branch=""
base_ref=""
message=""
files=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  --token)
    token="$2"
    shift 2
    ;;
  --repository)
    repository="$2"
    shift 2
    ;;
  --branch)
    branch="$2"
    shift 2
    ;;
  --base-ref)
    base_ref="$2"
    shift 2
    ;;
  --message)
    message="$2"
    shift 2
    ;;
  --)
    shift
    files+=("$@")
    break
    ;;
  *)
    printf 'Unknown argument: %s\n' "$1" >&2
    usage
    ;;
  esac
done

if [[ -z ${token} || -z ${repository} || -z ${branch} ||
  -z ${base_ref} || -z ${message} || ${#files[@]} -eq 0 ]]; then
  usage
fi

# Resolve the HEAD OID of the base branch from GitHub.
parent_oid="$(
  GH_TOKEN="${token}" gh api \
    "repos/${repository}/git/ref/heads/${base_ref}" \
    --jq '.object.sha'
)"
printf 'Parent OID: %s (%s)\n' "${parent_oid}" "${base_ref}"

# Observe the current destination branch tip before making any changes.
# This OID is used for the lease check at publish time so that a
# concurrent update to the destination branch is detected and reported.
existing_tip="$(
  GH_TOKEN="${token}" gh api \
    "repos/${repository}/git/ref/heads/${branch}" \
    --jq '.object.sha' 2> /dev/null || true
)"
if [[ -n ${existing_tip} ]]; then
  printf 'Existing branch tip: %s (%s)\n' "${existing_tip}" "${branch}"
fi

# Create or force-reset a staging branch to the parent OID.
# The signed commit is created here first so that the destination branch
# is not modified until signing succeeds. A failed signing request leaves
# any pre-existing update on the destination branch intact.
staging_branch="${branch}-staging"
if ! GH_TOKEN="${token}" gh api \
  --method PATCH \
  "repos/${repository}/git/refs/heads/${staging_branch}" \
  --field sha="${parent_oid}" \
  --field force=true \
  > /dev/null 2>&1; then
  GH_TOKEN="${token}" gh api \
    --method POST \
    "repos/${repository}/git/refs" \
    --field "ref=refs/heads/${staging_branch}" \
    --field "sha=${parent_oid}" \
    > /dev/null
fi
printf 'Staging branch %s set to %s.\n' "${staging_branch}" "${parent_oid}"

# Build the additions array from the listed files.
additions="[]"
for file_path in "${files[@]}"; do
  contents="$(base64 --wrap=0 "${file_path}")"
  additions="$(
    jq \
      --null-input \
      --argjson arr "${additions}" \
      --arg path "${file_path}" \
      --arg contents "${contents}" \
      '$arr + [{ path: $path, contents: $contents }]'
  )"
done

# Commit the files via the createCommitOnBranch GraphQL mutation on the
# staging branch. GitHub signs commits created through this mutation.
commit_oid="$(
  jq \
    --null-input \
    --arg repository "${repository}" \
    --arg branch "${staging_branch}" \
    --arg parent_oid "${parent_oid}" \
    --arg message "${message}" \
    --argjson additions "${additions}" \
    '{
      query: "mutation($input: CreateCommitOnBranchInput!) { createCommitOnBranch(input: $input) { commit { oid } } }",
      variables: {
        input: {
          branch: {
            repositoryNameWithOwner: $repository,
            branchName: $branch
          },
          message: { headline: $message },
          fileChanges: { additions: $additions },
          expectedHeadOid: $parent_oid
        }
      }
    }' \
    | GH_TOKEN="${token}" gh api graphql \
      --input - \
      --jq '.data.createCommitOnBranch.commit.oid'
)"
printf 'Signed commit %s on staging branch %s.\n' "${commit_oid}" "${staging_branch}"

# Re-read the destination branch tip and verify it has not changed since
# the initial observation. This soft lease check detects concurrent
# updates to the destination branch made during the staging commit.
current_tip="$(
  GH_TOKEN="${token}" gh api \
    "repos/${repository}/git/ref/heads/${branch}" \
    --jq '.object.sha' 2> /dev/null || true
)"
if [[ ${current_tip} != "${existing_tip}" ]]; then
  printf 'Error: branch %s changed from %s to %s during staging commit.\n' \
    "${branch}" "${existing_tip:-<none>}" "${current_tip:-<none>}" >&2
  exit 1
fi

# Publish the signed commit to the destination branch.
if [[ -n ${existing_tip} ]]; then
  GH_TOKEN="${token}" gh api \
    --method PATCH \
    "repos/${repository}/git/refs/heads/${branch}" \
    --field sha="${commit_oid}" \
    --field force=true \
    > /dev/null
else
  GH_TOKEN="${token}" gh api \
    --method POST \
    "repos/${repository}/git/refs" \
    --field "ref=refs/heads/${branch}" \
    --field "sha=${commit_oid}" \
    > /dev/null
fi
printf 'Branch %s published at %s.\n' "${branch}" "${commit_oid}"

# Delete the staging branch.
GH_TOKEN="${token}" gh api \
  --method DELETE \
  "repos/${repository}/git/refs/heads/${staging_branch}" \
  > /dev/null 2>&1 || true
printf 'Staging branch %s deleted.\n' "${staging_branch}"
