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
      {{ CMD }} |& nom
    else
      {{ CMD }}
    fi

# Print a section separator
_separator:
    @echo "# ======================================================================="

# Execute nix flake commands with optional nom support
_nix-flake SUBCOMMAND USE_NOM="":
    #!/usr/bin/env bash
    CMD="nix {{ NIX_FLAGS }} flake {{ SUBCOMMAND }}"
    if [ "{{ USE_NOM }}" = "nom" ]; then
      just _nom "$CMD"
    else
      eval "$CMD"
    fi

# Execute darwin-rebuild commands
_darwin-rebuild SUBCOMMAND USE_NOM="":
    #!/usr/bin/env bash
    if command -v nh 1>/dev/null 2>&1; then
      echo "🔨 Using nh for darwin {{ SUBCOMMAND }}..."
      CMD="nh darwin {{ SUBCOMMAND }} --hostname '{{ HOSTNAME }}' ."
    else
      echo "🔨 Using darwin-rebuild for {{ SUBCOMMAND }}..."
      if [ "{{ SUBCOMMAND }}" = "switch" ]; then
        CMD="sudo darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}'"
      else
        CMD="darwin-rebuild {{ SUBCOMMAND }} --print-build-logs --flake '.#{{ HOSTNAME }}'"
      fi
    fi

    if [ "{{ USE_NOM }}" = "nom" ]; then
      just _nom "$CMD"
    else
      eval "$CMD"
    fi

# Perform full system switch workflow
_switch-workflow USE_NOM="":
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    just _separator
    echo "🔍 Checking flake..."
    just _nix-flake "check" "{{ USE_NOM }}"

    just _separator
    just _ensure-darwin-rebuild

    just _separator
    echo "✅ Checking darwin configuration..."
    sudo darwin-rebuild check --flake ".#{{ HOSTNAME }}" --show-trace

    just _separator
    echo "🚀 Switching system configuration..."
    just _darwin-rebuild "switch" "{{ USE_NOM }}"

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
    just _nix-flake "update --refresh" "nom"

[doc('Update flake.lock file with nom output')]
update-nom:
    just _nix-flake "update --refresh" "nom"

[doc('Commit updated flake.lock file')]
commit:
    # Equivalent to: nix --experimental-features 'nix-command flakes' flake update --commit-lock-file |& nom
    just _nix-flake "update --commit-lock-file" "nom"

[doc('Check flake for errors')]
check:
    just _nix-flake "check"

[doc('Check flake for errors with nom output')]
check-nom:
    just _nix-flake "check" "nom"

[doc('Build darwin configuration without switching')]
build: _check-non-root _check-nix
    just _darwin-rebuild "build"

[doc('Build darwin configuration with nom output')]
build-nom: _check-non-root _check-nix
    just _darwin-rebuild "build" "nom"

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
