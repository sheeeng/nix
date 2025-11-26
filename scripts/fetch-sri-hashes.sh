#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
set -e # set -o errexit # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
set -u # set -o nounset # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
# set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

if [ -d ".git" ] || git rev-parse --git-dir >/dev/null 2>&1; then
  GIT_ROOT_DIRECTORY=$(git rev-parse --show-toplevel)
  echo "\${GIT_ROOT_DIRECTORY}: ${GIT_ROOT_DIRECTORY}"
fi

SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo "\${SCRIPT_DIRECTORY}: ${SCRIPT_DIRECTORY}"

# ----------------------------------------------------------------------

# https://stackoverflow.com/a/31397073
# mktemp --directory "${TMPDIR:-/tmp}/zombie.XXXXXXXXX".
TEMPORARY_DIRECTORY="$(mktemp --directory --tmpdir="${PWD}")"
echo "\${TEMPORARY_DIRECTORY}: ${TEMPORARY_DIRECTORY}"

function cleanUp {
  rm \
    -r \
    -v \
    "${TEMPORARY_DIRECTORY}"
}
trap cleanUp EXIT

# ----------------------------------------------------------------------

pushd "${GIT_ROOT_DIRECTORY}"
date -u +"%Y%m%dT%H%M%SZ"

# Process each .nix file.
fd '\.nix$' --exclude flake.nix --type f --print0 | while IFS= read -r -d '' FILE; do
  # Check if file has fetchFromGitHub or fetchurl.
  if ! grep --quiet --extended-regexp 'fetchFromGitHub|fetchurl' "${FILE}"; then
    continue
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Processing: ${FILE}"

  # Process fetchFromGitHub blocks - extract fields with grep (skip commented lines).
  OWNER=$(grep --invert-match '^[[:space:]]*#' "${FILE}" | grep --only-matching 'owner = "[^"]*"' | head -1 | cut -d'"' -f2)
  REPO=$(grep --invert-match '^[[:space:]]*#' "${FILE}" | grep --only-matching 'repo = "[^"]*"' | head -1 | cut -d'"' -f2)
  REV=$(grep --invert-match '^[[:space:]]*#' "${FILE}" | grep --only-matching 'rev = "[^"]*"' | head -1 | cut -d'"' -f2)
  OLD_SHA=$(grep --invert-match '^[[:space:]]*#' "${FILE}" | grep --extended-regexp --only-matching '(sha256|hash) = "[^"]*"' | head -1 | cut -d'"' -f2)

  if [ -n "${OWNER}" ] && [ -n "${REPO}" ] && [ -n "${REV}" ]; then
      echo "  Found fetchFromGitHub block:"
      echo "    Owner: ${OWNER}"
      echo "    Repository: ${REPO}"
      echo "    Revision: ${REV}"
      echo "    Old sha256: ${OLD_SHA}"

      echo "  Fetching latest commit from default branch..."
      LATEST_COMMIT=$(curl --silent --show-error --location --header "Authorization: Bearer ${GITHUB_TOKEN_NIX}" "https://api.github.com/repos/${OWNER}/${REPO}/commits/HEAD" | jq --raw-output '.sha // empty')

      if [ -z "${LATEST_COMMIT}" ]; then
        echo "  ✗ Failed to fetch latest commit."
        continue
      fi

      echo "    Latest commit: ${LATEST_COMMIT}"

      # Fetch new hash using nix-prefetch-github with latest commit.
      echo "  Fetching new hash..."
      NEW_SHA=$(nix-prefetch-github "${OWNER}" "${REPO}" --rev "${LATEST_COMMIT}" --nix 2>&1 | grep -E 'hash = ' | sed 's/.*hash = "\([^"]*\)".*/\1/')

      if [ -n "${NEW_SHA}" ]; then
        echo "    New hash: ${NEW_SHA}"

        if [ "${OLD_SHA}" = "${NEW_SHA}" ]; then
          echo "  ✓ Hash is already up to date."
        else
          # Update the file. Escape special characters for sed command.
          ESCAPED_OLD=$(printf '%s\n' "${OLD_SHA}" | sed 's/[[\.*^$()+?{|]/\\&/g')
          ESCAPED_NEW=$(printf '%s\n' "${NEW_SHA}" | sed 's/[[\.*^$()+?{|]/\\&/g')

          # Update the file in-place (handle both sha256 and hash).
          sed --in-place "s|\(sha256\|hash\) = \"${ESCAPED_OLD}\"|\1 = \"${ESCAPED_NEW}\"|" "${FILE}"

          echo "  ✓ Updated hash in ${FILE}."
        fi
      else
        echo "  ✗ Failed to fetch new hash."
      fi
  fi

  # Process fetchurl blocks - extract fields with grep (skip commented lines).
  URL=$(grep --invert-match '^[[:space:]]*#' "${FILE}" | grep --only-matching 'url = "[^"]*"' | head -1 | cut -d'"' -f2)
  FETCHURL_SHA=$(grep --invert-match '^[[:space:]]*#' "${FILE}" | grep 'fetchurl' -A 5 | grep --extended-regexp --only-matching '(sha256|hash) = "[^"]*"' | head -1 | cut -d'"' -f2)

  if [ -n "${URL}" ] && [ -n "${FETCHURL_SHA}" ]; then
      echo "  Found fetchurl block:"
      echo "    URL: ${URL}"
      echo "    Old sha256: ${FETCHURL_SHA}"

      echo "  Fetching new hash..."
      BASE32_HASH=$(nix-prefetch-url "${URL}" 2>&1 | tail -n 1)

      if [ -n "${BASE32_HASH}" ]; then
        # warning: The old format conversion subcommands of `nix hash` were deprecated in favor of `nix hash convert`.
        # # Convert base32 to SRI format using nix hash to-sri.
        # NEW_SHA=$(nix hash to-sri sha256:"${BASE32_HASH}")

        # Convert base32 to SRI format using nix hash convert.
        NEW_SHA=$(nix hash convert --from nix32 --to sri "sha256:${BASE32_HASH}" 2>/dev/null || nix hash to-sri "sha256:${BASE32_HASH}")
      fi

      if [ -n "${NEW_SHA}" ]; then
        echo "    New hash: ${NEW_SHA}"

        if [ "${FETCHURL_SHA}" = "${NEW_SHA}" ]; then
          echo "  ✓ Hash is already up to date."
        else
          # Update the file. Escape special characters for sed command.
          ESCAPED_OLD=$(printf '%s\n' "${FETCHURL_SHA}" | sed 's/[[\.*^$()+?{|]/\\&/g')
          ESCAPED_NEW=$(printf '%s\n' "${NEW_SHA}" | sed 's/[[\.*^$()+?{|]/\\&/g')

          # Update the file in-place (handle both sha256 and hash).
          sed --in-place "s|\(sha256\|hash\) = \"${ESCAPED_OLD}\"|\1 = \"${ESCAPED_NEW}\"|" "${FILE}"

          echo "  ✓ Updated hash in ${FILE}."
        fi
      else
        echo "  ✗ Failed to fetch new hash."
      fi
  fi
done
