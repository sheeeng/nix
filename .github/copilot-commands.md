# Copilot Commands

```shell
nix-shell --packages nix-prefetch-git --run 'nix-prefetch-git --url <https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized> --rev dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.sf-mono-nerd-font-ligatured.pname' 2>&1

nix eval --impure --json --expr 'let inputs = { nixpkgs = import <nixpkgs> {}; }; overlays = import ./overlays inputs; in builtins.hasAttr "sf-mono-nerd-font-ligatured" overlays'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.sf-mono-nerd-font-ligatured.pname' 2>&1
```
