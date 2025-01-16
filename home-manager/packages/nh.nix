{ config, pkgs, ... }:
{
  programs.nh = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.enable
    package = pkgs.nh; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.package
    clean = {
      # TODO: programs.nh.clean.enable and nix.gc.automatic (system-wide in configuration.nix) are both enabled. Please use one or the other to avoid conflict.
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.clean.enable
      dates = "Mon..Fri *-*-* 07:00:00"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.clean.dates
      extraArgs = "--keep-since 4d --keep 3"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.clean.extraArgs
    };
    flake = "${config.home.homeDirectory}/github/nix"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.flake
  };
}
