# nixos

## Getting started

```shell
mkdir --parents ~/.config/nix && cd $_
nix flake init --template nix-darwin
sed --in-place "s/simple/$(scutil --get LocalHostName)/" flake.nix
```
