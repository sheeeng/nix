inputs: {
  # Skip Node.js tests during nix-darwin switch for improved performance
  # nodejs-skip-tests = import ./nodejs.nix;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  nodejs-skip-tests = _final: prev: {
    nodejs = prev.nodejs.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkPhase = null;
      installCheckPhase = null;
    });

    nodejs_20 = prev.nodejs_20.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkPhase = null;
      installCheckPhase = null;
    });

    nodejs_22 = prev.nodejs_22.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkPhase = null;
      installCheckPhase = null;
    });
  };
}
