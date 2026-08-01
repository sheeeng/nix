# Configuration

SOPS_FILE := "../nix-secrets/.sops.yaml"
NIX_FLAGS := "--experimental-features 'nix-command flakes'"
NIX_FLAGS_NO_TESTS := "--experimental-features 'nix-command flakes' --option check false --option pure-eval false"
HOSTNAME := `hostname`

# =============================================================================
# Helper Functions
# =============================================================================

# Ensure we're not running as root (but allow sudo usage within commands)
_check-non-root:
    #!/usr/bin/env bash
    if [ ${EUID:-0} -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
      echo "❌ This script requires non-root access (but may use sudo internally)."
      exit 42
    fi

# Ensure we're running as root
_check-must-be-root:
    #!/usr/bin/env bash
    if [ ${EUID:-0} -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
      echo "❌ This script requires root access."
      exit 42
    fi

# Check if Nix is installed
_check-nix:
    #!/usr/bin/env bash
    if ! command -v nix 1>/dev/null 2>&1; then
      echo "❌ Nix is not installed!"
      exit 42
    fi

# Ensure darwin-rebuild is available
_ensure-darwin-rebuild:
    #!/usr/bin/env bash
    if ! command -v darwin-rebuild 1>/dev/null 2>&1; then
      echo "📦 darwin-rebuild is not installed, installing..."
      sudo nix run nix-darwin {{ NIX_FLAGS }} -- switch --flake ".#{{ HOSTNAME }}"
    fi

# Conditionally use nom for better output formatting
_nom CMD:
    #!/usr/bin/env bash
    if command -v nom 1>/dev/null 2>&1; then
      set -o pipefail
      {{ CMD }} |& nom --json
    else
      {{ CMD }}
    fi

# Execute command with optional file logging
_nom-with-log CMD LOGFILE="":
    #!/usr/bin/env bash
    if [ -n "{{ LOGFILE }}" ]; then
      echo "📝 Saving logs to: {{ LOGFILE }}"
      if command -v nom 1>/dev/null 2>&1; then
        set -o pipefail
        # Use process substitution to save raw output to file while showing nom output
        {{ CMD }} 2>&1 | tee "{{ LOGFILE }}" | nom --json
      else
        {{ CMD }} 2>&1 | tee "{{ LOGFILE }}"
      fi
    else
      just _nom "{{ CMD }}"
    fi

# Print a section separator
_separator:
    @echo "# ======================================================================="

# Execute nix flake commands with optional nom support and logging
_nix-flake SUBCOMMAND USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    if [ "{{ USE_NOM }}" = "nom" ]; then
      CMD="nix {{ NIX_FLAGS }} flake {{ SUBCOMMAND }} --log-format internal-json --verbose --print-build-logs"
      if [ -n "{{ LOGFILE }}" ]; then
        just _nom-with-log "$CMD" "{{ LOGFILE }}"
      else
        just _nom "$CMD"
      fi
    else
      CMD="nix {{ NIX_FLAGS }} flake {{ SUBCOMMAND }} --print-build-logs"
      if [ -n "{{ LOGFILE }}" ]; then
        echo "📝 Saving logs to: {{ LOGFILE }}"
        eval "$CMD" 2>&1 | tee "{{ LOGFILE }}"
      else
        eval "$CMD"
      fi
    fi

# Execute nh darwin commands with optional logging
_nh-darwin SUBCOMMAND USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    echo "🔨 Using nh for darwin {{ SUBCOMMAND }}..."
    if [ "{{ USE_NOM }}" = "nom" ]; then
      CMD="nh darwin {{ SUBCOMMAND }} --hostname '{{ HOSTNAME }}' . --log-format internal-json --verbose"
    else
      CMD="nh darwin {{ SUBCOMMAND }} --hostname '{{ HOSTNAME }}' ."
    fi

    if [ -n "{{ LOGFILE }}" ]; then
      if [ "{{ USE_NOM }}" = "nom" ]; then
        just _nom-with-log "$CMD" "{{ LOGFILE }}"
      else
        echo "📝 Saving logs to: {{ LOGFILE }}"
        eval "$CMD" 2>&1 | tee "{{ LOGFILE }}"
      fi
    else
      if [ "{{ USE_NOM }}" = "nom" ]; then
        just _nom "$CMD"
      else
        eval "$CMD"
      fi
    fi

# Execute darwin-rebuild commands with optional logging
_darwin-rebuild SUBCOMMAND USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    echo "🔨 Using darwin-rebuild for {{ SUBCOMMAND }}..."
    if [ "{{ SUBCOMMAND }}" = "switch" ]; then
      CMD="sudo darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}'"
    else
      CMD="darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}'"
    fi

    if [ -n "{{ LOGFILE }}" ]; then
      if [ "{{ USE_NOM }}" = "nom" ]; then
        just _nom-with-log "$CMD" "{{ LOGFILE }}"
      else
        echo "📝 Saving logs to: {{ LOGFILE }}"
        eval "$CMD" 2>&1 | tee "{{ LOGFILE }}"
      fi
    else
      if [ "{{ USE_NOM }}" = "nom" ]; then
        just _nom "$CMD"
      else
        eval "$CMD"
      fi
    fi

# Perform full system switch workflow with optional logging (uses darwin-rebuild)
_switch-workflow USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake..."
    just _nix-flake "check" "{{ USE_NOM }}" "{{ LOGFILE }}"

    just _separator
    just _ensure-darwin-rebuild

    # just _separator
    # echo "✅ Checking darwin configuration..."
    # if [ -n "{{ LOGFILE }}" ]; then
    #   sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace 2>&1 | tee -a "{{ LOGFILE }}"
    # else
    #   sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace
    # fi

    just _separator
    echo "🚀 Switching system configuration..."
    just _darwin-rebuild "switch" "{{ USE_NOM }}" "{{ LOGFILE }}"

    just _separator
    echo "✅ System switch completed!"

# Perform full system switch workflow using nh with optional logging
_switch-nh-workflow USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake..."
    just _nix-flake "check" "{{ USE_NOM }}" "{{ LOGFILE }}"

    just _separator
    echo "🚀 Switching system configuration with nh..."
    just _nh-darwin "switch" "{{ USE_NOM }}" "{{ LOGFILE }}"

    just _separator
    echo "✅ NH switch completed!"

# =============================================================================
# Main Commands
# =============================================================================

default:
    @just --list

[doc('Show current staged and unstaged changes')]
diff:
    git diff ':!flake.lock'

[doc('Format Nix files in the workspace')]
format FORMATTER="auto":
    #!/usr/bin/env bash
    case "{{ FORMATTER }}" in
      "auto"|"nix")
        echo "🎨 Formatting Nix files with nix fmt..."
        nix {{ NIX_FLAGS }} fmt
        ;;
      "nix-fmt")
        echo "🎨 Formatting Nix files with nix-fmt..."
        nix-shell --packages nix-fmt --run 'find . -name "*.nix" -not -path "./result*" -exec nix-fmt {} +'
        ;;
      "nixfmt-rfc-style")
        echo "🎨 Formatting Nix files with nixfmt-rfc-style..."
        nix-shell --packages nixfmt-rfc-style --run 'find . -name "*.nix" -not -path "./result*" -exec nixfmt-rfc-style {} +'
        ;;
      "nixpkgs-fmt")
        echo "🎨 Formatting Nix files with nixpkgs-fmt..."
        nix-shell --packages nixpkgs-fmt --run 'find . -name "*.nix" -not -path "./result*" -exec nixpkgs-fmt {} +'
        ;;
      "alejandra")
        echo "🎨 Formatting Nix files with alejandra..."
        nix-shell --packages alejandra --run 'alejandra .'
        ;;
      "nixfmt")
        echo "🎨 Formatting Nix files with nixfmt..."
        nix-shell --packages nixfmt --run 'find . -name "*.nix" -not -path "./result*" -exec nixfmt {} +'
        ;;
      *)
        echo "❌ Unknown formatter: {{ FORMATTER }}."
        echo "Available formatters:"
        echo "   auto (default)   - Use nix fmt"
        echo "   nix              - Use nix fmt explicitly"
        echo "   nix-fmt          - Use nix-fmt tool"
        echo "   nixfmt-rfc-style - RFC-style formatter"
        echo "   nixpkgs-fmt      - Official Nixpkgs formatter"
        echo "   alejandra        - Modern, opinionated formatter"
        echo "   nixfmt           - Classic formatter"
        exit 1
        ;;
    esac
    echo "✅ Formatting completed!"

[doc('Check if sops-nix activated successfully')]
check-sops:
    scripts/check-sops.sh

[doc('Update nix-secrets repository')]
update-nix-secrets:
    @(cd ../nix-secrets && git fetch && git rebase > /dev/null) || true
    nix flake update nix-secrets --timeout 5

[doc('Update flake.lock file')]
update:
    just _nix-flake "update --refresh" ""

[doc('Update flake.lock file with nom output')]
update-nom:
    just _nix-flake "update --refresh" "nom"

[doc('Update flake.lock file and save logs to specified file')]
update-to-file LOGFILE:
    #!/usr/bin/env bash
    echo "📝 Saving update logs to: {{ LOGFILE }}"
    just _nix-flake "update --refresh" "" 2>&1 | tee "{{ LOGFILE }}"
    echo "✅ Update completed. Logs saved to: {{ LOGFILE }}"

[doc('Update flake.lock file and save logs with timestamp')]
update-log:
    #!/usr/bin/env bash
    LOGFILE="update-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving update logs to: $LOGFILE"
    just _nix-flake "update --refresh" "" 2>&1 | tee "$LOGFILE"
    echo "✅ Update completed. Logs saved to: $LOGFILE"

[doc('Commit updated flake.lock file')]
commit:
    # Equivalent to: nix --experimental-features 'nix-command flakes' flake update --commit-lock-file |& nom
    just _nix-flake "update --commit-lock-file" ""

[doc('Rebuild opencode node_modules and update the Darwin outputHash in overlays/default.nix')]
bump-opencode-hash: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    OVERLAY_FILE="overlays/default.nix"
    ATTRIBUTE=".#darwinConfigurations.{{ HOSTNAME }}.pkgs.opencode.node_modules"

    echo "🔨 Building opencode node_modules to learn its content hash..."
    echo "   This builds from source and can take around twenty minutes."

    if BUILD_OUTPUT="$(nix {{ NIX_FLAGS }} build "$ATTRIBUTE" --no-link --print-build-logs 2>&1)"; then
      echo "✅ Hash is already correct. No change needed."
      exit 0
    fi

    GOT_HASH="$(printf '%s\n' "$BUILD_OUTPUT" \
      | grep --extended-regexp --only-matching 'got:[[:space:]]+sha256-[A-Za-z0-9+/=]+' \
      | grep --extended-regexp --only-matching 'sha256-[A-Za-z0-9+/=]+' \
      | head --lines 1)"

    if [ -z "$GOT_HASH" ]; then
      echo "❌ Build failed for a reason other than a hash mismatch."
      printf '%s\n' "$BUILD_OUTPUT" | tail --lines 30
      exit 1
    fi

    echo "🔧 Updating outputHash to: $GOT_HASH"
    nix-shell --packages gnused --run \
      "sed --in-place --regexp-extended 's|outputHash = \"sha256-[^\"]*\";|outputHash = \"$GOT_HASH\";|' '$OVERLAY_FILE'"

    echo "✅ Rebuilding to verify..."
    nix {{ NIX_FLAGS }} build "$ATTRIBUTE" --no-link --print-build-logs
    echo "✅ opencode node_modules hash bumped and verified."

[doc('Check flake for errors')]
check:
    just _nix-flake "check"

[doc('Check flake for errors with nom output')]
check-nom:
    just _nix-flake "check" "nom"

[doc('Check flake for errors and save logs to specified file')]
check-to-file LOGFILE:
    #!/usr/bin/env bash
    echo "📝 Saving check logs to: {{ LOGFILE }}"
    just _nix-flake "check" "" 2>&1 | tee "{{ LOGFILE }}"
    echo "✅ Check completed. Logs saved to: {{ LOGFILE }}"

[doc('Check flake for errors and save logs with timestamp')]
check-log:
    #!/usr/bin/env bash
    LOGFILE="check-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving check logs to: $LOGFILE"
    just _nix-flake "check" "" 2>&1 | tee "$LOGFILE"
    echo "✅ Check completed. Logs saved to: $LOGFILE"

[doc('Build darwin configuration without switching')]
build: _check-non-root _check-nix
    just _darwin-rebuild "build"

[doc('Build darwin configuration with nom output')]
build-nom: _check-non-root _check-nix
    just _darwin-rebuild "build" "nom"

[doc('Build darwin configuration and save logs to specified file')]
build-to-file LOGFILE: _check-non-root _check-nix
    #!/usr/bin/env bash
    echo "📝 Saving build logs to: {{ LOGFILE }}"
    just _darwin-rebuild "build" "" 2>&1 | tee "{{ LOGFILE }}"
    echo "✅ Build completed. Logs saved to: {{ LOGFILE }}"

[doc('Build darwin configuration and save logs with timestamp')]
build-log: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="build-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving build logs to: $LOGFILE"
    just _darwin-rebuild "build" "" 2>&1 | tee "$LOGFILE"
    echo "✅ Build completed. Logs saved to: $LOGFILE"

[doc('Build darwin configuration and show diff with nvd')]
build-diff: _check-non-root _check-nix
    #!/usr/bin/env bash
    echo "🔨 Building darwin configuration..."
    darwin-rebuild build --print-build-logs --flake '.#{{ HOSTNAME }}'

    if [ -e /run/current-system ]; then
      echo ""
      echo "📊 Comparing package versions..."
      nvd --nix-bin-dir="$(dirname "$(command -v nix)")" --color=always diff /run/current-system result
    else
      echo "⚠️  No current system found (initial installation?)"
    fi

[doc('Build darwin configuration and show diff with nvd (using nom)')]
build-diff-nom: _check-non-root _check-nix
    #!/usr/bin/env bash
    echo "🔨 Building darwin configuration..."
    darwin-rebuild build --print-build-logs --flake '.#{{ HOSTNAME }}' |& nom

    if [ -e /run/current-system ]; then
      echo ""
      echo "📊 Comparing package versions..."
      nvd --nix-bin-dir="$(dirname "$(command -v nix)")" --color=always diff /run/current-system result
    else
      echo "⚠️  No current system found (initial installation?)"
    fi

[doc('Check darwin-rebuild configuration')]
check-darwin: _check-non-root
    #!/usr/bin/env bash
    echo "✅ Checking darwin configuration..."
    sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace

[doc('Switch system configuration (recommended)')]
switch: _check-non-root _check-nix
    just _switch-workflow

[doc('Switch system configuration without running tests (faster)')]
switch-fast: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake (without tests)..."
    nix {{ NIX_FLAGS_NO_TESTS }} flake check --print-build-logs

    just _separator
    just _ensure-darwin-rebuild

    just _separator
    echo "🚀 Switching system configuration (skipping tests)..."
    sudo darwin-rebuild switch --print-build-logs --flake '.#{{ HOSTNAME }}' --option check false

    just _separator
    echo "✅ Fast system switch completed!"

[doc('Switch system configuration without running tests with nom output (faster)')]
switch-fast-nom: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake (without tests)..."
    nix {{ NIX_FLAGS_NO_TESTS }} flake check --log-format internal-json --verbose --print-build-logs | nom --json

    just _separator
    just _ensure-darwin-rebuild

    just _separator
    echo "🚀 Switching system configuration (skipping tests)..."
    sudo darwin-rebuild switch --print-build-logs --flake '.#{{ HOSTNAME }}' --option check false | nom

    just _separator
    echo "✅ Fast system switch with nom completed!"

[doc('Switch system configuration with nom output')]
switch-nom: _check-non-root _check-nix
    just _switch-workflow "nom"

[doc('Switch system configuration and save logs to specified file')]
switch-to-file LOGFILE: _check-non-root _check-nix
    #!/usr/bin/env bash
    echo "📝 Saving switch logs to: {{ LOGFILE }}"
    just _switch-workflow "" 2>&1 | tee "{{ LOGFILE }}"
    echo "✅ Switch completed. Logs saved to: {{ LOGFILE }}"

[doc('Switch system configuration and save logs with timestamp')]
switch-log: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="switch-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving switch logs to: $LOGFILE"
    just _switch-workflow "" 2>&1 | tee "$LOGFILE"
    echo "✅ Switch completed. Logs saved to: $LOGFILE"

# =============================================================================
# NH-specific Commands
# =============================================================================

[doc('Build darwin configuration using nh')]
build-nh: _check-non-root _check-nix
    just _nh-darwin "build"

[doc('Build darwin configuration using nh with nom output')]
build-nh-nom: _check-non-root _check-nix
    just _nh-darwin "build" "nom"

[doc('Build darwin configuration using nh and save logs to specified file')]
build-nh-to-file LOGFILE: _check-non-root _check-nix
    #!/usr/bin/env bash
    echo "📝 Saving nh build logs to: {{ LOGFILE }}"
    just _nh-darwin "build" "" "{{ LOGFILE }}"
    echo "✅ NH build completed. Logs saved to: {{ LOGFILE }}"

[doc('Build darwin configuration using nh and save logs with timestamp')]
build-nh-log: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="build-nh-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving nh build logs to: $LOGFILE"
    just _nh-darwin "build" "" "$LOGFILE"
    echo "✅ NH build completed. Logs saved to: $LOGFILE"

[doc('Switch system configuration using nh')]
switch-nh: _check-non-root _check-nix
    just _switch-nh-workflow

[doc('Switch system configuration using nh with nom output')]
switch-nh-nom: _check-non-root _check-nix
    just _switch-nh-workflow "nom"

[doc('Switch system configuration using nh and save logs to specified file')]
switch-nh-to-file LOGFILE: _check-non-root _check-nix
    #!/usr/bin/env bash
    echo "📝 Saving nh switch logs to: {{ LOGFILE }}"
    just _switch-nh-workflow "" "{{ LOGFILE }}"
    echo "✅ NH switch completed! Logs saved to: {{ LOGFILE }}"

[doc('Switch system configuration using nh and save logs with timestamp')]
switch-nh-log: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="switch-nh-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving nh switch logs to: $LOGFILE"
    just _switch-nh-workflow "" "$LOGFILE"
    echo "✅ NH switch completed! Logs saved to: $LOGFILE"

[doc('Update flake and switch system configuration using nh')]
update-switch-nh: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "📦 Updating flake..."
    just _nix-flake "update"

    just _switch-nh-workflow

[doc('Update flake and switch system configuration using nh with nom output')]
update-switch-nh-nom: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "📦 Updating flake..."
    just _nix-flake "update" "nom"

    just _switch-nh-workflow "nom"

[doc('Update flake.lock file using nh')]
update-nh:
    #!/usr/bin/env bash
    if command -v nh 1>/dev/null 2>&1; then
      echo "🔨 Using nh for update..."
      nh home switch --update .
    else
      echo "❌ nh is not available, falling back to regular update."
      just update
    fi

[doc('Update flake.lock file using nh with nom output')]
update-nh-nom:
    #!/usr/bin/env bash
    if command -v nh 1>/dev/null 2>&1; then
      echo "🔨 Using nh for update with nom..."
      just _nom "nh home switch --update ."
    else
      echo "❌ nh is not available, falling back to regular update with nom."
      just update-nom
    fi

[doc('Update flake and switch system configuration')]
update-switch: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "📦 Updating flake..."
    just _nix-flake "update"

    just _switch-workflow

[doc('Update flake and switch system configuration with nom output')]
update-switch-nom: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "📦 Updating flake..."
    just _nix-flake "update" "nom"

    just _switch-workflow "nom"

[doc('Update flake and switch system configuration with nom output (alias)')]
switch-update-nom: _check-non-root _check-nix
    just update-switch-nom

[doc('Switch system configuration using morlana')]
switch-morlana: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake..."
    just _nix-flake "check"

    just _separator
    echo "🚀 Switching with morlana..."
    nix run github:ryanccn/morlana -- switch --flake ~/github/sheeeng/nix

[doc('Show darwin-rebuild changelog')]
changelog:
    #!/usr/bin/env bash
    darwin-rebuild changelog --flake ".#{{ HOSTNAME }}"

[doc('Build with logs saved to file')]
build-with-logs: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="build-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving build logs to: $LOGFILE"
    just _darwin-rebuild "build" "nom" "$LOGFILE"
    echo "✅ Build completed. Logs saved to: $LOGFILE"

[doc('Switch with logs saved to file')]
switch-with-logs: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="switch-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving switch logs to: $LOGFILE"
    just _switch-workflow "nom" "$LOGFILE"
    echo "✅ Switch completed. Logs saved to: $LOGFILE"

[doc('Build with verbose debugging and logs')]
build-debug: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="build-debug-$(date +%Y%m%d-%H%M%S).log"
    echo "🐛 Building with debug info. Logs saved to: $LOGFILE"
    CMD="darwin-rebuild build --print-build-logs --show-trace --keep-failed --flake '.#{{ HOSTNAME }}'"
    eval "$CMD" 2>&1 | tee "$LOGFILE"

[doc('Show recent build failures and their logs')]
show-failed-builds:
    #!/usr/bin/env bash
    echo "🔍 Looking for failed builds in /tmp..."
    find /tmp -name "nix-build-*" -type d 2>/dev/null | head -10
    echo ""
    echo "💡 To examine a failed build:"
    echo "   cd /tmp/nix-build-<hash>"
    echo "   ls -la"

[doc('Set experimental features for Nix')]
set-experimental-features: _check-must-be-root
    #!/usr/bin/env bash
    if grep --quiet "experimental-features =" /etc/nix/nix.conf; then
      echo "✅ Experimental features already configured."
    else
      echo "⚙️  Setting experimental features..."
      echo "experimental-features = nix-command flakes" | sudo tee --append /etc/nix/nix.conf >/dev/null
      echo "✅ Experimental features configured."
    fi

[doc('Set GitHub token for higher rate limit')]
set-github-token: _check-must-be-root
    #!/usr/bin/env bash
    if [ -z "${GITHUB_TOKEN_NIX:-}" ]; then
      echo "❌ GITHUB_TOKEN_NIX is not set or empty."
      echo "💡 Please set the GITHUB_TOKEN_NIX environment variable."
      exit 1
    fi

    echo "✅ Token is set and its length is ${#GITHUB_TOKEN_NIX}."

    if grep --quiet "^access-tokens = github.com=" /etc/nix/nix.conf; then
      echo "⚙️  Replacing existing GitHub token configuration..."
      nix-shell --packages gnused --run "sudo sed --in-place 's|^access-tokens = github.com=.*|access-tokens = github.com=${GITHUB_TOKEN_NIX}|' /etc/nix/nix.conf"
      echo "✅ GitHub token configured."
    else
      echo "⚙️  Adding GitHub token configuration..."
      echo "access-tokens = github.com=${GITHUB_TOKEN_NIX}" | sudo tee --append /etc/nix/nix.conf >/dev/null
      echo "✅ GitHub token configured."
    fi
