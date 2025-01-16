#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
set -e # set -o errexit # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
set -u # set -o nounset # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
# set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
  GIT_ROOT_DIRECTORY=$(git rev-parse --show-toplevel)
  echo "\${GIT_ROOT_DIRECTORY}: ${GIT_ROOT_DIRECTORY}"
fi

SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
echo "\${SCRIPT_DIRECTORY}: ${SCRIPT_DIRECTORY}"

# ----------------------------------------------------------------------

# https://stackoverflow.com/a/31397073
# mktemp --directory "${TMPDIR:-/tmp}/zombie.XXXXXXXXX"
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

pushd "${SCRIPT_DIRECTORY}"
date -u +"%Y%m%dT%H%M%SZ"

# Check if the script is running as root.
if [ ${EUID:-0} -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root access."
  exit 42
fi

# Grep if "experimental-features = nix-command flakes" is already in the file.
if grep --quiet "experimental-features =" /etc/nix/nix.conf; then
  echo "The 'experimental-features =' option already set in the file."
else
  echo "The 'experimental-features =' option not set in the file."

  cat << EOF >> /etc/nix/nix.conf

# https://nixos.wiki/wiki/flakes
experimental-features = nix-command flakes
EOF
fi
