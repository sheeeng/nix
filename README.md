# nix

## Installation

```shell
git submodule init
git submodule update
ln --symbolic $(pwd) ~/.config/nixpkgs
nix-env -f '<nixpkgs>' -iA home-manager
```
