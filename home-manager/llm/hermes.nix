# The hermes-agent flake supports x86_64-linux, aarch64-linux, and
# aarch64-darwin. Linux hosts configure hermes-agent via
# inputs.hermes-agent.nixosModules.default in hosts/linux/default.nix.
# This module wires up the Home Manager module for aarch64-darwin only.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  hermesEnabled = pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64;
in
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  services.hermes-agent = lib.mkIf hermesEnabled {
    enable = true; # https://github.com/NousResearch/hermes-agent
    environmentFiles = [ config.sops.templates."hermes/env".path ];
    gateway.enable = true;
    package = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      callPackage =
        path: args:
        pkgs.callPackage path (
          args
          // lib.optionalAttrs (baseNameOf path == "lib.nix") {
            # The pinned workspace hash differs on aarch64-darwin.
            fetchPnpmDeps =
              attrs:
              pkgs.fetchPnpmDeps (
                attrs
                // lib.optionalAttrs (attrs.hash or null == "sha256-Y3jmi5nLLgGOGqcm9rgvyGbmcFJQk1Ro3+IsymICoiQ=") {
                  hash = "sha256-W5V/4xsKZKolR2MQL5GN9GBa7844IPNmKVTTcLaZnvI=";
                }
              );
          }
        );
    };
    settings.model.default = "deepseek/deepseek-chat"; # https://github.com/NousResearch/hermes-agent
  };
}
