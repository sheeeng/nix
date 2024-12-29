{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    skhd
    yabai
  ];

  services.skhd = {
    enable = true;
    # skhdConfig = builtins.readFile ./skhdrc;
  };

  services.yabai = {
    enable = true;
    # extraConfig = builtins.readFile ./yabairc;
  };

  # "${config.xdg.configHome}/yabai/yabairc".text = builtins.readFile ./yabairc;
}
