{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    package = pkgs.mako;
    settings = {
      anchor = "top-right";
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 10;
      border-size = 2;
      default-timeout = 5000;
      font = "MesloLGS Nerd Font 10";
      group-by = "summary";
      height = 300;
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      icons = true;
      ignore-timeout = true;
      margin = "10,20";
      max-icon-size = 32;
      max-visible = 5;
      padding = "10,15";
      sort = "-time";
      width = 500;
    };

    extraConfig = ''
      [urgency=high]
      border-color=#f38ba8
      text-color=#f38ba8
    '';
  };
}
