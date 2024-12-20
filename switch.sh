#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
set -o errexit  # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
set -o nounset  # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
# set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

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
date --universal +"%Y%m%dT%H%M%SZ"

# Check if the script is running as root.
if [ ${EUID:-0} -eq 0 ] || [ "$(id --user)" -eq 0 ]; then
  echo "This script requires non-root access."
  exit 42
fi

# https://github.com/zmrocze/dotfiles/blob/829310f0de69a652b57691482d25e26170fc9ce9/apply-home.sh

pushd "${HOME}/github/sheeeng/nix/nix-darwin" || exit

if command -v nix 1> /dev/null 2>&1; then
  nix flake update
  nix flake check
else
  echo "Nix is not installed!"
  exit 42
fi

if ! command -v darwin-rebuild 1> /dev/null 2>&1; then
  echo "darwin-rebuild is not installed."
  # nix run .#homeConfigurations."$(stat --format "%U" "$(tty)")@$(hostname)".activationPackage
  nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ~/github/sheeeng/nix/nix-darwin
fi

# home-manager switch --flake .#"$(stat --format "%U" "$(tty)")@$(hostname)"

# darwin-rebuild changelog --flake ~/github/sheeeng/nix/nix-darwin

darwin-rebuild check --flake ~/github/sheeeng/nix/nix-darwin

darwin-rebuild build --print-build-logs --flake ~/github/sheeeng/nix/nix-darwin
darwin-rebuild activate --flake ~/github/sheeeng/nix/nix-darwin

# darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix/nix-darwin

popd || exit