{ config, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
      dates = "Mon..Fri *-*-* 07:00:00";
    };
    flake = "${config.home.homeDirectory}/github/nix";
  };
}
