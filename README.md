# nix

## Installation

```shell
git submodule init
git submodule update
ln --symbolic $(pwd) ~/.config/nixpkgs
nix-env --set-flag priority 0 nix-2.22.0
nix-env -f '<nixpkgs>' -iA home-manager
```

## Information

```shell
nix-shell --packages nix-info --run "nix-info --markdown --sandbox --host-os"
```

## Garbage Collection

```shell
nix-env --delete-generations old \
&& nix-store --gc --print-dead \
&& nix-collect-garbage --delete-old
```
