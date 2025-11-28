#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
set -o errexit  # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
set -o nounset  # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
# set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

show_usage() {
  cat <<EOF
Usage: $(basename "$0") [COMMAND] [VOLUME]

Commands:
  toggle              Toggle mute on/off (default if no arguments)
  set VOLUME          Set volume to VOLUME (0-100)
  mute                Mute volume
  unmute              Unmute volume
  get                 Get current volume settings

Examples:
  $(basename "$0")              # Toggle mute
  $(basename "$0") toggle       # Toggle mute
  $(basename "$0") set 50       # Set volume to 50%
  $(basename "$0") mute         # Mute volume
  $(basename "$0") unmute       # Unmute volume
  $(basename "$0") get          # Show current volume settings
EOF
}

# Default action is toggle if no arguments provided
ACTION="${1:-toggle}"

case "${ACTION}" in
toggle)
  if [ "$(osascript -e "output muted of (get volume settings)")" = "true" ]; then
    osascript -e "set volume without output muted"
  else
    osascript -e "set volume with output muted"
  fi
  osascript -e "get volume settings"
  ;;
set)
  if [ $# -lt 2 ]; then
    echo "Error: Volume level required for 'set' command" >&2
    show_usage
    exit 1
  fi
  VOLUME="$2"
  if ! [[ ${VOLUME} =~ ^[0-9]+$ ]] || [ "${VOLUME}" -lt 0 ] || [ "${VOLUME}" -gt 100 ]; then
    echo "Error: Volume must be a number between 0 and 100." >&2
    exit 1
  fi
  osascript -e "set volume output volume ${VOLUME}"
  osascript -e "get volume settings"
  ;;
mute)
  osascript -e "set volume with output muted"
  osascript -e "get volume settings"
  ;;
unmute)
  osascript -e "set volume without output muted"
  osascript -e "get volume settings"
  ;;
get)
  osascript -e "get volume settings"
  ;;
--help | -h | help)
  show_usage
  exit 0
  ;;
*)
  echo "Error: Unknown command '${ACTION}'" >&2
  show_usage
  exit 1
  ;;
esac
