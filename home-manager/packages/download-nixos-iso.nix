{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "download-nixos-iso";

  runtimeInputs = with pkgs; [
    curl
    coreutils
  ];

  text = ''
    #!/usr/bin/env bash

    # https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
    set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
    set -o errexit  # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
    set -o nounset  # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
    # set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

    # https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
    # shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

    # Default values
    TYPE="minimal"
    ARCH="x86_64"
    VERSION="25.05"

    # Parse named parameters
    show_usage() {
      cat <<EOF
    Usage: download-nixos-iso [OPTIONS]

    Download and verify NixOS ISO images from channels.nixos.org

    Options:
      --type TYPE        ISO type: minimal or graphical (default: minimal)
      --arch ARCH        Architecture: x86_64 or aarch64 (default: x86_64)
      --version VERSION  NixOS version (default: 25.05)
      --help             Show this help message

    Examples:
      download-nixos-iso --type minimal --arch x86_64 --version 25.05
      download-nixos-iso --type graphical --arch aarch64
      download-nixos-iso --arch aarch64
    EOF
      exit 0
    }

    # Parse arguments
    while [[ $# -gt 0 ]]; do
      case $1 in
        --type)
          TYPE="$2"
          shift 2
          ;;
        --arch)
          ARCH="$2"
          shift 2
          ;;
        --version)
          VERSION="$2"
          shift 2
          ;;
        --help)
          show_usage
          ;;
        *)
          echo "Error: Unknown option: $1"
          echo "Use --help for usage information"
          exit 1
          ;;
      esac
    done

    # Validate TYPE
    if [[ "$TYPE" != "minimal" && "$TYPE" != "graphical" ]]; then
      echo "Error: TYPE must be 'minimal' or 'graphical' (got: $TYPE)"
      exit 1
    fi

    # Validate ARCH
    if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" ]]; then
      echo "Error: ARCH must be 'x86_64' or 'aarch64' (got: $ARCH)"
      exit 1
    fi

    # Validate VERSION exists on channels.nixos.org
    echo "Validating NixOS version ''${VERSION}..."
    CHANNEL_URL="https://channels.nixos.org/nixos-''${VERSION}"
    if ! curl --silent --fail --head "''${CHANNEL_URL}" >/dev/null 2>&1; then
      echo "Error: NixOS version ''${VERSION} not found at https://channels.nixos.org/"
      echo "Available channels can be found at: https://channels.nixos.org/"
      exit 1
    fi

    BASE_URL="https://channels.nixos.org/nixos-''${VERSION}"
    ISO_NAME="latest-nixos-''${TYPE}-''${ARCH}-linux.iso"
    ISO_URL="''${BASE_URL}/''${ISO_NAME}"
    SHA_URL="''${ISO_URL}.sha256"

    echo "Downloading NixOS ''${VERSION} ''${TYPE} ISO (''${ARCH})..."
    curl --location --remote-name "''${ISO_URL}" || {
      echo "Error: ISO download failed"
      exit 1
    }

    curl --location --remote-name "''${SHA_URL}" || {
      echo "Error: SHA256 download failed"
      exit 1
    }

    echo "Verifying checksum..."
    DOWNLOADED_ISO=$(find . -maxdepth 1 -name "nixos-''${TYPE}-*-''${ARCH}-linux.iso" -type f -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -1)
    DOWNLOADED_SHA=$(find . -maxdepth 1 -name "nixos-''${TYPE}-*-''${ARCH}-linux.iso.sha256" -type f -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -1)

    if [[ -z "$DOWNLOADED_ISO" ]] || [[ -z "$DOWNLOADED_SHA" ]]; then
      echo "Error: Could not find downloaded files"
      echo "Looking for: nixos-''${TYPE}-*-''${ARCH}-linux.iso"
      ls -la nixos-* 2>/dev/null || echo "No nixos-* files found"
      exit 1
    fi

    if command -v sha256sum >/dev/null 2>&1; then
      sha256sum --check "$DOWNLOADED_SHA" || {
        echo "Error: Checksum verification failed"
        exit 1
      }
    elif command -v shasum >/dev/null 2>&1; then
      shasum --algorithm 256 --check "$DOWNLOADED_SHA" || {
        echo "Error: Checksum verification failed"
        exit 1
      }
    else
      echo "Warning: No checksum tool found (sha256sum or shasum)"
      echo "Please verify manually:"
      cat "$DOWNLOADED_SHA"
      exit 0
    fi

    echo "✓ Download and verification complete: $DOWNLOADED_ISO"
  '';

  meta = {
    description = "Download and verify NixOS ISO images";
    maintainers = [ ];
  };
}
