{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sketchybar
    skhd
    yabai
  ];

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = builtins.readFile ./sketchybarrc;
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = builtins.readFile ./skhdrc;
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    extraConfig = builtins.readFile ./yabairc;
  };
}
