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
#   --branch       Target branch to create or reset.
#   --base-ref     Branch whose HEAD becomes the parent commit.
#   --message      Commit headline (subject line).
#   FILE           Paths to files to include, relative to the working
#                  directory. All listed files are added or replaced.
#
# The script creates or force-resets the target branch to the HEAD of
# base-ref on GitHub, then commits only the listed files via the
# GraphQL API. It does not run git commit or git push.

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

# Create or force-reset the target branch to the parent OID.
if ! GH_TOKEN="${token}" gh api \
  --method PATCH \
  "repos/${repository}/git/refs/heads/${branch}" \
  --field sha="${parent_oid}" \
  --field force=true \
  > /dev/null 2>&1; then
  GH_TOKEN="${token}" gh api \
    --method POST \
    "repos/${repository}/git/refs" \
    --field "ref=refs/heads/${branch}" \
    --field "sha=${parent_oid}" \
    > /dev/null
fi
printf 'Branch %s set to %s.\n' "${branch}" "${parent_oid}"

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

# Commit the files via the createCommitOnBranch GraphQL mutation.
# GitHub signs commits created through this mutation.
commit_oid="$(
  jq \
    --null-input \
    --arg repository "${repository}" \
    --arg branch "${branch}" \
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

printf 'Signed commit %s on branch %s.\n' "${commit_oid}" "${branch}"
