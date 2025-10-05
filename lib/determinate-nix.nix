# Determinate Nix Detection Utilities
# This module provides utilities for detecting Determinate Nix installations
# and automatically configuring nix-darwin to work with them.

{ lib, ... }:

{
  # Detect if Determinate Nix is installed
  # Returns true if Determinate Nix is detected, false otherwise
  isDeterminateNix =
    # Check for Determinate Nix receipt file
    builtins.pathExists "/nix/receipt.json"
    ||
      # Check for Determinate Nix daemon plist
      builtins.pathExists "/Library/LaunchDaemons/systems.determinate.nix-daemon.plist"
    ||
      # Check for Determinate Nix environment variable
      (builtins.getEnv "NIX_INSTALLER_NO_MODIFY_PROFILE" != "")
    ||
      # Check for Determinate Nix binary signature (if nix command exists)
      (
        let
          nixVersion = builtins.readFile "/proc/version";
        in
        lib.hasInfix "determinate" nixVersion || false
      );

  # Generate nix configuration that's compatible with Determinate Nix
  mkNixConfig =
    {
      pkgs-unstable,
      isDeterminate ? null,
    }:
    let
      actualIsDeterminate =
        if isDeterminate != null then
          isDeterminate
        else
          (import ./determinate-nix.nix { inherit lib; }).isDeterminateNix;
    in
    {
      enable = !actualIsDeterminate;
      package = pkgs-unstable.nix;
      channel.enable = false;
      optimise.automatic = false;

      settings = {
        auto-optimise-store = false;
        cores = 0;
        extra-sandbox-paths = [ ];
        max-jobs = "auto";
        require-sigs = true;
        sandbox = false;
        substituters = [
          "https://cache.nixos.org"
          "https://devenv.cachix.org"
          "https://nixpkgs-python.cachix.org"
          "https://ryanccn.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
          "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
        ];
        trusted-substituters = [
          "https://hydra.nixos.org/"
        ];
      };

      gc = {
        automatic = !actualIsDeterminate;
        interval = {
          Day = 1;
          Hour = 12;
          Minute = 15;
        };
        options = "--delete-older-than 7d";
      };

      extraOptions = ''
        experimental-features = nix-command flakes
        keep-derivations = true
        keep-outputs = true
      '';
    };

  # Generate activation script for Determinate Nix detection info
  mkDeterminateInfoScript =
    {
      isDeterminate ? null,
    }:
    let
      actualIsDeterminate =
        if isDeterminate != null then
          isDeterminate
        else
          (import ./determinate-nix.nix { inherit lib; }).isDeterminateNix;
    in
    {
      supportsDryActivation = true;
      text =
        if actualIsDeterminate then
          ''
            echo "✓ Determinate Nix detected - nix-darwin Nix management disabled"
            echo "  Nix installation managed by Determinate Systems"
            echo "  Some nix-darwin features (like nix.* options) are unavailable"
            echo "  For Nix configuration, use: /etc/nix/nix.conf or ~/.config/nix/nix.conf"
          ''
        else
          ''
            echo "✓ Standard Nix installation detected - nix-darwin managing Nix"
            echo "  Full nix-darwin functionality available"
            echo "  Nix configuration managed through nix-darwin options"
          '';
    };

  # Check methods for debugging
  checkDeterminateNix = {
    receiptExists = builtins.pathExists "/nix/receipt.json";
    daemonPlistExists = builtins.pathExists "/Library/LaunchDaemons/systems.determinate.nix-daemon.plist";
    envVarSet = builtins.getEnv "NIX_INSTALLER_NO_MODIFY_PROFILE" != "";

    # Additional checks
    nixBinaryPath = builtins.getEnv "NIX_PATH";
    nixConfPath = builtins.pathExists "/etc/nix/nix.conf";
  };
}
