# Copilot Commands

## Nix

```shell
# Enter the default minimal shell
nix develop

# Enter the full development shell with all tools
nix develop .#full

# Enter the minimal shell explicitly
nix develop .#minimal

# Check what shells are available
nix flake show

# Fast nix-darwin switch without Node.js tests (recommended)
just switch-fast-nom

# Alternative fast switch command
just switch-fast

# Check for Node.js dependencies in home-manager packages
grep --recursive --include="*.nix" "nodejs" home-manager/packages/

# Verify Node.js overlay is applied
nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs.pname'

nix flake show --json | jq '.devShells."aarch64-darwin" // .devShells."x86_64-linux" // {} | keys[]'

# Verify renovate.json configuration (using renovate-config-validator)
nix shell github:nixos/nixpkgs/nixpkgs-unstable#nodejs-slim --command npx --yes --package renovate -- renovate-config-validator --strict

# Alternative: Verify renovate.json configuration (dry-run validates config)
nix shell github:nixos/nixpkgs/nixpkgs-unstable#nodejs-slim --command npx --yes renovate --dry-run --log-level=debug

# Check Renovate version
nix shell github:nixos/nixpkgs/nixpkgs-unstable#nodejs-slim --command npx --yes renovate --version

nix run '.#formatter' -- .github/copilot-journals.md

nix repl --file '<nixpkgs>'

nix eval '.#darwinConfigurations.<hostname>.config.home-manager.users'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nix.version'

nix eval --json 'nixpkgs#nix.version'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.config.nix.enable'

sudo darwin-rebuild switch --flake .

nix eval --impure --expr '(import ./hosts/core/determinate.nix { }).isDeterminateNix'
```

```shell
nix eval --impure --expr 'let receiptPath = "/nix/receipt.json"; receiptExists = builtins.pathExists receiptPath; receiptContent = if receiptExists then builtins.readFile receiptPath else "{}"; receiptJSON = builtins.fromJSON receiptContent; plannerSettingsDeterminateNixEnabled = receiptExists && receiptJSON ? planner && receiptJSON.planner ? settings && receiptJSON.planner.settings ? determinate_nix && receiptJSON.planner.settings.determinate_nix; in plannerSettingsDeterminateNixEnabled'
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

nix build '.#checks.aarch64-darwin.formatting' --no-link --print-build-logs

nix flake check --no-build 2>&1

nix run '.#formatter' -- --check .
```
