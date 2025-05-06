default:
    @just --list

[doc('Update all `flake.lock` file.')]
update:
    nix --experimental-features "nix-command flakes" flake update --refresh |& nom

[doc('Commit updated `flake.lock` file.')]
commit:
    nix --experimental-features "nix-command flakes" flake update --commit-lock-file |& nom

[doc('Show current staged and unstaged changes.')]
diff:
    git diff ':!flake.lock'

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

    # Check if token already exists
    if grep --quiet "access-tokens = github.com=" /etc/nix/nix.conf; then
      echo "The 'access-tokens = github.com=' option already set in the file."
    else
      echo "The 'access-tokens = github.com=' option not set in the file."
      echo "access-tokens = github.com=${GITHUB_TOKEN_NIX}" | sudo tee -a /etc/nix/nix.conf >/dev/null
    fi

    popd
