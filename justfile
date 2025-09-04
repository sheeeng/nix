# Configuration

SOPS_FILE := "../nix-secrets/.sops.yaml"
NIX_FLAGS := "--experimental-features 'nix-command flakes'"
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

# Execute darwin-rebuild commands with optional logging
_darwin-rebuild SUBCOMMAND USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    if command -v nh 1>/dev/null 2>&1; then
      echo "🔨 Using nh for darwin {{ SUBCOMMAND }}..."
      if [ "{{ USE_NOM }}" = "nom" ]; then
        CMD="nh darwin {{ SUBCOMMAND }} --hostname '{{ HOSTNAME }}' . --log-format internal-json --verbose"
      else
        CMD="nh darwin {{ SUBCOMMAND }} --hostname '{{ HOSTNAME }}' ."
      fi
    else
      echo "🔨 Using darwin-rebuild for {{ SUBCOMMAND }}..."
      if [ "{{ SUBCOMMAND }}" = "switch" ]; then
        if [ "{{ USE_NOM }}" = "nom" ]; then
          CMD="sudo darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}' --log-format internal-json --verbose"
        else
          CMD="sudo darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}'"
        fi
      else
        if [ "{{ USE_NOM }}" = "nom" ]; then
          CMD="darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}' --log-format internal-json --verbose"
        else
          CMD="darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}'"
        fi
      fi
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

# Perform full system switch workflow with optional logging
_switch-workflow USE_NOM="" LOGFILE="":
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake..."
    just _nix-flake "check" "{{ USE_NOM }}" "{{ LOGFILE }}"

    just _separator
    just _ensure-darwin-rebuild

    just _separator
    echo "✅ Checking darwin configuration..."
    if [ -n "{{ LOGFILE }}" ]; then
      sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace 2>&1 | tee -a "{{ LOGFILE }}"
    else
      sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace
    fi

    just _separator
    echo "🚀 Switching system configuration..."
    just _darwin-rebuild "switch" "{{ USE_NOM }}" "{{ LOGFILE }}"

    just _separator
    echo "✅ System switch completed!"

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
        echo "❌ Unknown formatter: {{ FORMATTER }}"
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

[doc('Check darwin-rebuild configuration')]
check-darwin: _check-non-root
    #!/usr/bin/env bash
    echo "✅ Checking darwin configuration..."
    sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace

[doc('Switch system configuration (recommended)')]
switch: _check-non-root _check-nix
    just _switch-workflow

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
    just _darwin-rebuild "build" "nom" 2>&1 | tee "$LOGFILE"
    echo "✅ Build completed. Logs saved to: $LOGFILE"

[doc('Switch with logs saved to file')]
switch-with-logs: _check-non-root _check-nix
    #!/usr/bin/env bash
    LOGFILE="switch-$(date +%Y%m%d-%H%M%S).log"
    echo "📝 Saving switch logs to: $LOGFILE"
    just _switch-workflow "nom" 2>&1 | tee "$LOGFILE"
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
      echo "✅ Experimental features already configured"
    else
      echo "⚙️  Setting experimental features..."
      echo "experimental-features = nix-command flakes" | sudo tee --append /etc/nix/nix.conf >/dev/null
      echo "✅ Experimental features configured"
    fi

[doc('Set GitHub token for higher rate limit')]
set-github-token: _check-must-be-root
    #!/usr/bin/env bash
    if grep --quiet "access-tokens = github.com=" /etc/nix/nix.conf; then
      echo "✅ GitHub token already configured"
    else
      echo "⚙️  Setting GitHub token..."
      echo "access-tokens = github.com=${GITHUB_TOKEN_NIX}" | sudo tee --append /etc/nix/nix.conf >/dev/null
      echo "✅ GitHub token configured"
    fi
