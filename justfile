SOPS_FILE := "../nix-secrets/.sops.yaml"

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

[doc('Set experimental features for Nix.')]
set-experimental-features:
    #!/usr/bin/env bash
    # Use a shebang to run all commands in a single shell.

    pushd "${HOME}"
    direnv allow
    eval "$(direnv export bash)"

    # Check if running as root
    if [ ${EUID:-0} -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
      echo "This script requires root access."
      exit 42
    fi

    # Grep if "experimental-features = nix-command flakes" is already in the file.
    if grep --quiet "experimental-features =" /etc/nix/nix.conf; then
      echo "The 'experimental-features =' option already set in the file."
    else
      echo "The 'experimental-features =' option not set in the file."
      echo "experimental-features = nix-command flakes" | sudo tee --append /etc/nix/nix.conf >/dev/null
    fi

    popd

[doc('Set GitHub token to get a higher rate limit.')]
set-github-token:
    #!/usr/bin/env bash
    # Use a shebang to run all commands in a single shell.

    pushd "${HOME}"
    direnv allow
    eval "$(direnv export bash)"

    # Check if running as root
    if [ ${EUID:-0} -ne 0 ] || [ "$(id -u)" -ne 0 ]; then
      echo "This script requires root access."
      exit 42
    fi

    # Check if GitHub access token already exists.
    if grep --quiet "access-tokens = github.com=" /etc/nix/nix.conf; then
      echo "The 'access-tokens = github.com=' option already set in the file."
    else
      echo "The 'access-tokens = github.com=' option not set in the file."
      echo "access-tokens = github.com=${GITHUB_TOKEN_NIX}" | sudo tee --append /etc/nix/nix.conf >/dev/null
    fi

    popd
