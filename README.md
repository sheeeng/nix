# nixos

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
[![Github](https://img.shields.io/badge/github-blue.svg?style=for-the-badge&logo=github&logoColor=white&color=2088ff)](https://github.com/sheeeng/nix)

## Getting started

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
