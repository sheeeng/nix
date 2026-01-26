inputs: {
  # Skip Node.js tests during nix-darwin switch for improved performance
  # nodejs-skip-tests = import ./nodejs.nix;

  unstable-packages = final: _prev: {
    unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};
  };

  nodejs-skip-tests = _final: prev: {
    nodejs = prev.nodejs.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkPhase = null;
      installCheckPhase = null;
    });
  };

  # Workaround for VSCode "Operation not permitted" issue.
  # https://github.com/NixOS/nixpkgs/issues/476838
  # https://github.com/nix-darwin/nix-darwin/issues/1315#issuecomment-2629517646
  fix-vscode-operation-not-permitted = _final: prev: {
    vscode = prev.vscode.overrideAttrs (old: {
      installPhase = "whoami\n" + old.installPhase;
    });
  };

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
          version = "1.0.0";
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
}
