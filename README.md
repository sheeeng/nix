# nixos

## Getting started

- Read [nix-macos-setup](https://davi.sh/til/nix/nix-macos-setup/).

### Create `flake.nix`

- Initialize [nix-darwin](https://github.com/lnl7/nix-darwin?tab=readme-ov-file#flakes).

```shell
mkdir --parents ~/.config/nix && cd $_
nix flake init --template nix-darwin
sed --in-place "s/simple/$(scutil --get LocalHostName)/" flake.nix
sed --in-place "s/x86_64-darwin/aarch64-darwin/" flake.nix
```

### Install `nix-darwin`

```shell
nix run nix-darwin -- switch --flake ~/.config/nix
```

### Using `nix-darwin`

- Extract the inlined configuration from [flake.nix](flake.nix) into a separate file named [darwin.nix](darwin.nix).

- [Setup](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nix-darwin-module) flake-based Home Manager nix-darwin in [flake.nix](flake.nix).

- Create a [home.nix](home.nix) file.

- Install[nix-darwin](https://github.com/lnl7/nix-darwin).

```shell
nix run nix-darwin --experimental-feature "nix-command flakes" -- switch --flake ~/.config/nix

nix run nix-darwin flakes -- switch --flake ~/.config/nix
```

- Rebuild configuration.

```shell
darwin-rebuild switch --flake ~/.config/nix
```
