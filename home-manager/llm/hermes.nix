# The hermes-agent flake supports x86_64-linux, aarch64-linux, and
# aarch64-darwin. Linux hosts configure hermes-agent via
# inputs.hermes-agent.nixosModules.default in hosts/linux/default.nix.
# This module wires up the Home Manager module for aarch64-darwin only.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  hermesEnabled = pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64;
in
{
  imports = lib.optionals hermesEnabled [
    inputs.hermes-agent.homeManagerModules.default
  ];

  services.hermes-agent = lib.mkIf hermesEnabled {
    enable = true; # https://github.com/NousResearch/hermes-agent
    settings.model.default = "deepseek/deepseek-chat"; # https://github.com/NousResearch/hermes-agent
  };
}
