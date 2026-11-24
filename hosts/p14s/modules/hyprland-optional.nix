{ config, pkgs, lib, ... }:

{
  programs.hyprland = lib.mkIf false {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.hyprlock = lib.mkIf false {
    enable = true;
  };
}
