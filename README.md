# nixos

<!-- [![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) -->
[![Built with Nix](https://img.shields.io/badge/Built_with-Nix-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=7EBAE4)](https://nixos.org)
[![Codeberg](https://img.shields.io/badge/codeberg-2185D0.svg?style=for-the-badge&logo=codeberg&logoColor=B5DDFF&color=2185D0&test.svg)](https://codeberg.org/sheeeng/nix)
[![GitHub](https://img.shields.io/badge/github-000000.svg?style=for-the-badge&logo=github&logoColor=FFFFFF&color=000000)](https://github.com/sheeeng/nix)
[![GitLab](https://img.shields.io/badge/gitlab-E24329?style=for-the-badge&logo=gitlab&logoColor=FCA326&test.svg)](https://gitlab.com/sheeeng/nix)

<!-- [![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/sheeeng/nix/badge)](https://scorecard.dev/viewer/?uri=github.com/sheeeng/nix) -->

## Getting started

```shell
nix --extra-experimental-features 'nix-command flakes' flake update; darwin-rebuild build --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'nix-command flakes' run nixpkgs#nix-output-monitor

sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'flakes nix-command' run nixpkgs#nix-output-monitor
```

```shell
nix flake update

darwin-rebuild build --show-trace --print-build-logs --verbose --flake ~/github/sheeeng/nix 2>&1 | nix run nixpkgs#nix-output-monitor

sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'flakes nix-command' run nixpkgs#nix-output-monitor
```

### Install `lix`

```shell
curl --silent --show-error --fail --location https://install.lix.systems/lix | sh -s -- install
```

### Optional: Create `flake.nix`

- Initialize
  [nix-darwin](https://github.com/lnl7/nix-darwin?tab=readme-ov-file#flakes).

```shell
mkdir --parents ~/github/sheeeng/nix/nix-darwin && cd $_
nix flake init --template nix-darwin
sed --in-place "s/simple/$(scutil --get LocalHostName)/" flake.nix
sed --in-place "s/x86_64-darwin/aarch64-darwin/" flake.nix
```

### Install `nix-darwin`

```shell
nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ~/github/sheeeng/nix/nix-darwin
```

### Using `nix-darwin`

- [Setup](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nix-darwin-module)
  flake-based Home Manager nix-darwin in [flake.nix](flake.nix).

```shell
nix run nix-darwin -- switch --flake ~/github/sheeeng/nix/nix-darwin
```

- Rebuild configuration.

```shell
darwin-rebuild switch --flake ~/github/sheeeng/nix/nix-darwin
```

- Update and fetch dependencies.

```shell
fd .nix --exclude flake.nix --exec update-nix-fetchgit

fd .nix --exclude flake.nix --exec sh -c 'echo {}; update-nix-fetchgit {}'
```

- Format files.

```shell
nix fmt

nix-shell --packages nixfmt-tree --run "treefmt ."
```
