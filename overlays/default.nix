inputs: {
  # Skip Node.js tests during nix-darwin switch for improved performance
  # nodejs-skip-tests = import ./nodejs.nix;

  # --------------------------------------------------------------------
  unstable-packages = final: _prev: {
    unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};
  };

  # --------------------------------------------------------------------
  nodejs-skip-tests = _final: prev: {
    nodejs = prev.nodejs.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkPhase = null;
      installCheckPhase = null;
    });
  };

  # --------------------------------------------------------------------
  # Workaround for VSCode "Operation not permitted" issue.
  # https://github.com/NixOS/nixpkgs/issues/476838
  # https://github.com/nix-darwin/nix-darwin/issues/1315#issuecomment-2629517646
  fix-vscode-operation-not-permitted = _final: prev: {
    vscode = prev.vscode.overrideAttrs (old: {
      installPhase = "whoami\n" + old.installPhase;
    });
  };

  # --------------------------------------------------------------------
  # https://github.com/hraban/mac-app-util/issues/42
  # https://github.com/gkze/nixcfg/commit/8d39c5bfd9e3fade36a8383798a5bcc3fcf9e7b3
  # mdformat: Update to 1.0.0 for markdown-it-py 4.x compatibility.
  # nixos-unstable has markdown-it-py 4.0.0 but mdformat 0.7.22 requires <4.0.0 package.
  # https://github.com/NixOS/nixpkgs/issues/483613 merged to master but not yet available in unstable.
  # TODO: Remove the following override once nixos-unstable has mdformat 1.0.0 package.
  mdformat = _final: prev: {
    python3 = prev.python3.override {
      packageOverrides = _: pyPrev: {
        mdformat = pyPrev.mdformat.overridePythonAttrs (_: rec {
          version = "82912cdaea4fb830f751504486a7879c70526547"; # 1.0.0
          src = prev.fetchFromGitHub {
            owner = "hukkin";
            repo = "mdformat";
            tag = version;
            hash = "sha256-fo4xO4Y89qPAggEjwuf6dnTyu1JzhZVdJyUqGNpti7g=";
          };
        });
      };
    };
  };
  # nix-prefetch-git \
  #   https://github.com/hukkin/mdformat \
  #   82912cdaea4fb830f751504486a7879c70526547 \
  #   | jq --raw-output '.hash'

  # --------------------------------------------------------------------
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
  beads = _final: prev: {
    beads = prev.beads.overrideAttrs (_old: rec {
      version = "0d99d15370030b953a8df0ea67cd3d1b845bb07b"; # v0.49.1
      src = prev.fetchFromGitHub {
        owner = "steveyegge";
        repo = "beads";
        rev = version;
        hash = "sha256-roOyTMy9nKxH2Bk8MnP4h2CDjStwK6z0ThQhFcM64QI=";
      };
      vendorHash = "sha256-YU+bRLVlWtHzJ1QPzcKJ70f+ynp8lMoIeFlm+29BNPE=";
    });
  };

  # --------------------------------------------------------------------

}
