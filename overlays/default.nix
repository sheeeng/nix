{ inputs, ... }:
{
  additions = _final: _prev: { };

  modifications = final: prev: {
    unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};

    # Workaround for VSCode "Operation not permitted" issue.
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/476838
    # @upstream-issue https://github.com/nix-darwin/nix-darwin/issues/1315#issuecomment-2629517646
    vscode = prev.vscode.overrideAttrs (old: {
      installPhase = "whoami\n" + old.installPhase;
    });

    # nix eval nixpkgs#beads --json 2>&1 | head -20
    # nix eval .#darwinConfigurations.$(hostname).pkgs.beads.version --raw 2>&1
    # nix build .#darwinConfigurations.$(hostname).pkgs.beads --print-build-logs 2>&1
    # nix path-info .#darwinConfigurations.TP95V9LWWL.pkgs.beads
    # To update source hash:
    # nix-prefetch-git \
    #   https://github.com/steveyegge/beads \
    #   0d99d15370030b953a8df0ea67cd3d1b845bb07b \
    #   | jq --raw-output '.hash'
    # To update vendorHash (recommended):
    # 1. Set: vendorHash = final.lib.fakeHash;
    # 2. Run: nix build .#darwinConfigurations.$(hostname).pkgs.beads
    # 3. Copy hash from error message
    # Alternative vendorHash method (may not work):
    # nix --extra-experimental-features 'nix-command flakes' run nixpkgs#nix-prefetch -- \
    #   '{ sha256 }: (builtins.getFlake "git+file://'$(pwd)'").darwinConfigurations.'$(hostname)'.pkgs.beads.goModules.overrideAttrs (_: { outputHash = sha256; })'
    # TODO: https://github.com/NixOS/nixpkgs/pull/483469
    # beads = prev.beads.overrideAttrs (_old: rec {
    #   version = "0d99d15370030b953a8df0ea67cd3d1b845bb07b"; # v0.49.1
    #   src = prev.fetchFromGitHub {
    #     owner = "steveyegge";
    #     repo = "beads";
    #     rev = version;
    #     hash = "sha256-roOyTMy9nKxH2Bk8MnP4h2CDjStwK6z0ThQhFcM64QI=";
    #   };
    #   vendorHash = "sha256-YU+bRLVlWtHzJ1QPzcKJ70f+ynp8lMoIeFlm+29BNPE=";
    # });

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.system;
        config.allowUnfree = true;
      };
    };
  };
}
