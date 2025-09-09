# Copilot Commands

## Node.js Test Skipping Commands

```shell
# Fast nix-darwin switch without Node.js tests (recommended)
just switch-fast-nom

# Alternative fast switch command
just switch-fast

# Check for Node.js dependencies in home-manager packages
grep --recursive --include="*.nix" "nodejs" home-manager/packages/

# Verify Node.js overlay is applied
nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs.pname'
```

## Historical Commands

```shell
nix-shell --packages nix-prefetch-git --run 'nix-prefetch-git --url <https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized> --rev dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.sf-mono-nerd-font-ligatured.pname' 2>&1

nix eval --impure --json --expr 'let inputs = { nixpkgs = import <nixpkgs> {}; }; overlays = import ./overlays inputs; in builtins.hasAttr "sf-mono-nerd-font-ligatured" overlays'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.sf-mono

nix why-depends /run/current-system nodejs 2>/dev/null | head -20

nix eval --json '.#darwinConfigurations.TP95V9LWWL.config.nixpkgs.overlays' | jq length

nix search nixpkgs hadolint --json | jq '.[].pname' 2>/dev/null || echo "Failed to search hadolint"

nix run nixpkgs#prettier -- --write renovate.json --no-config

nix why-depends /run/current-system nodejs 2>/dev/null | head -20

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs.version' 2>/dev/null || echo "nodejs not found in pkgs"

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs_20.version' 2>/dev/null || echo "nodejs_20 not found"
```
