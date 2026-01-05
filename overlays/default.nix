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
}
