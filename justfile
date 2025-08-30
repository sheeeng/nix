SOPS_FILE := "../nix-secrets/.sops.yaml"

# Helper functions
_check-non-root:
    #!/usr/bin/env bash
    # Ensure we're not running as root (but allow sudo usage within commands)
    if [ ${EUID:-0} -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
      echo "This script requires non-root access (but may use sudo internally)."
      exit 42
    fi

_check-must-be-root:
    #!/usr/bin/env bash
    # Ensure we're running as root
    if [ ${EUID:-0} -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
      echo "This script requires root access."
      exit 42
    fi

_check-nix:
    #!/usr/bin/env bash
    if ! command -v nix 1>/dev/null 2>&1; then
      echo "Nix is not installed!"
      exit 42
    fi

_ensure-darwin-rebuild:
    #!/usr/bin/env bash
    if ! command -v darwin-rebuild 1>/dev/null 2>&1; then
      echo "darwin-rebuild is not installed..."
      sudo nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ".#$(hostname)"
    fi

_switch-system:
    #!/usr/bin/env bash
    if command -v nh 1>/dev/null 2>&1; then
      echo "nh darwin switch..."
      nh darwin switch --hostname "$(hostname)" .
    else
      echo "darwin-rebuild switch..."
      sudo darwin-rebuild switch --print-build-logs --flake ".#$(hostname)"
    fi

default:
    @just --list

[doc('Check if sops-nix activated successfully.')]
check-sops:
    scripts/check-sops.sh

[doc('Update nix-secrets.')]
update-nix-secrets:
    @(cd ../nix-secrets && git fetch && git rebase > /dev/null) || true
    nix flake update nix-secrets --timeout 5

[doc('Update all `flake.lock` file.')]
update:
    nix --experimental-features "nix-command flakes" flake update --refresh |& nom

[doc('Commit updated `flake.lock` file.')]
commit:
    nix --experimental-features "nix-command flakes" flake update --commit-lock-file |& nom

[doc('Show current staged and unstaged changes.')]
diff:
    git diff ':!flake.lock'

[doc('Check flake for errors.')]
check:
    nix --experimental-features "nix-command flakes" flake check

[doc('Check darwin-rebuild configuration.')]
check-darwin: _check-non-root
    #!/usr/bin/env bash
    echo "darwin-rebuild check..."
    sudo darwin-rebuild check --flake ".#$(hostname)" --show-trace

[doc('Switch system configuration (default method).')]
switch: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail
    echo "# ----------------------------------------------------------------------"
    echo "nix flake check..."
    nix --experimental-features "nix-command flakes" flake check
    echo "# ----------------------------------------------------------------------"
    just _ensure-darwin-rebuild
    echo "# ----------------------------------------------------------------------"
    echo "darwin-rebuild check..."
    sudo darwin-rebuild check --flake ".#$(hostname)" --show-trace
    echo "# ----------------------------------------------------------------------"
    echo "# ----------------------------------------------------------------------"
    just _switch-system
    echo "# ----------------------------------------------------------------------"

[doc('Switch system configuration after flake update.')]
update-switch: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail
    echo "# ----------------------------------------------------------------------"
    echo "nix flake update..."
    nix --experimental-features "nix-command flakes" flake update
    echo "# ----------------------------------------------------------------------"
    echo "nix flake check..."
    nix --experimental-features "nix-command flakes" flake check
    echo "# ----------------------------------------------------------------------"
    just _ensure-darwin-rebuild
    echo "# ----------------------------------------------------------------------"
    echo "darwin-rebuild check..."
    sudo darwin-rebuild check --flake ".#$(hostname)" --show-trace
    echo "# ----------------------------------------------------------------------"
    echo "# ----------------------------------------------------------------------"
    just _switch-system
    echo "# ----------------------------------------------------------------------"

[doc('Switch system configuration using morlana.')]
switch-morlana: _check-non-root _check-nix
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail
    echo "# ----------------------------------------------------------------------"
    echo "nix flake check..."
    nix --experimental-features "nix-command flakes" flake check
    echo "# ----------------------------------------------------------------------"
    echo "morlana switch..."
    nix run github:ryanccn/morlana -- switch --flake ~/github/sheeeng/nix

[doc('Build darwin configuration without switching.')]
build:
    #!/usr/bin/env bash
    if command -v nh 1>/dev/null 2>&1; then
      echo "nh darwin build..."
      nh darwin build --hostname "$(hostname)" .
    else
      echo "darwin-rebuild build..."
      darwin-rebuild build --print-build-logs --flake ".#$(hostname)"
    fi

[doc('Show darwin-rebuild changelog.')]
changelog:
    #!/usr/bin/env bash
    darwin-rebuild changelog --flake ".#$(hostname)"

[doc('Set experimental features for Nix.')]
set-experimental-features: _check-must-be-root
    #!/usr/bin/env bash
    pushd "${HOME}"
    direnv allow
    eval "$(direnv export bash)"

    # Grep if "experimental-features = nix-command flakes" is already in the file.
    if grep --quiet "experimental-features =" /etc/nix/nix.conf; then
      echo "The 'experimental-features =' option already set in the file."
    else
      echo "The 'experimental-features =' option not set in the file."
      echo "experimental-features = nix-command flakes" | sudo tee --append /etc/nix/nix.conf >/dev/null
    fi

    popd

[doc('Set GitHub token to get a higher rate limit.')]
set-github-token: _check-must-be-root
    #!/usr/bin/env bash
    pushd "${HOME}"
    direnv allow
    eval "$(direnv export bash)"

    # Check if GitHub access token already exists.
    if grep --quiet "access-tokens = github.com=" /etc/nix/nix.conf; then
      echo "The 'access-tokens = github.com=' option already set in the file."
    else
      echo "The 'access-tokens = github.com=' option not set in the file."
      echo "access-tokens = github.com=${GITHUB_TOKEN_NIX}" | sudo tee --append /etc/nix/nix.conf >/dev/null
    fi

    popd
