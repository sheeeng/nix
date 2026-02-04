# NixOS

<!-- [![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) -->

[![Built with Nix](https://img.shields.io/badge/Built_with-Nix-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=7EBAE4)](https://nixos.org)
[![Codeberg](https://img.shields.io/badge/codeberg-2185D0.svg?style=for-the-badge&logo=codeberg&logoColor=B5DDFF&color=2185D0&test.svg)](https://codeberg.org/sheeeng/nix)
[![GitHub](https://img.shields.io/badge/github-000000.svg?style=for-the-badge&logo=github&logoColor=FFFFFF&color=000000)](https://github.com/sheeeng/nix)
[![GitLab](https://img.shields.io/badge/gitlab-E24329?style=for-the-badge&logo=gitlab&logoColor=FCA326&test.svg)](https://gitlab.com/sheeeng/nix)

<!-- [![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/sheeeng/nix/badge)](https://scorecard.dev/viewer/?uri=github.com/sheeeng/nix) -->

## Getting Started

```shell
export NIX_CONFIG="experimental-features = nix-command flakes"; # nix --extra-experimental-features 'nix-command flakes'

nix flake update; \
darwin-rebuild build --flake ~/github/sheeeng/nix 2>&1 \
| nix -run nixpkgs#nix-output-monitor

sudo darwin-rebuild switch --flake ~/github/sheeeng/nix 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo --validate; \
nix flake update; \
sudo --validate; \
sudo nix run github:lnl7/nix-darwin -- switch --flake ~/github/sheeeng/nix  --print-build-logs --show-trace --verbose --cores 2 --max-jobs 2 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo --validate; \
nix flake update; \
sudo --validate; \
sudo nixos-rebuild switch --print-build-logs --show-trace --verbose --cores 2 --max-jobs 2 --flake ~/github/sheeeng/nix 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

## Install `lix`

```shell
curl --silent --show-error --fail --location https://install.lix.systems/lix | sh -s -- install
```

## Miscellaneous

- Restart Nix daemon.

```shell
sudo launchctl kickstart -k -p system/systems.determinate.nix-daemon
```

- Verify access token.

```shell
nix config show | nix run nixpkgs#ripgrep -- '^access-tokens'
```

- Update and fetch dependencies.

```shell
fd .nix --exclude flake.nix --exec update-nix-fetchgit
# fd .nix --exclude flake.nix --exec sh -x 'echo {}; update-nix-fetchgit {}'

fd -e nix --exclude flake.nix \
  -x sh -c 'echo "$1"; update-nix-fetchgit "$1"' _ {}

nix run nixpkgs#fd -- .nix --exclude flake.nix --exec \
    nix run nixpkgs#update-nix-fetchgit --

nix run nixpkgs#fd -- .nix --exclude flake.nix --exec \
    sh -c 'echo {}; nix run nixpkgs#update-nix-fetchgit -- {}'
```

- Format files.

```shell
nix fmt

nix-shell --packages nixfmt-tree --run "treefmt ."
```
