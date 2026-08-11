{ lib, pkgs, ... }:
{
  # catppuccin.enable is the global toggle. catppuccin.autoEnable controls
  # whether ports enroll automatically. Set autoEnable to false to match the
  # previous behavior where nothing was themed, and set enable to true so the
  # global toggle no longer disables everything. This suppresses the migration
  # warning while keeping the current appearance.
  catppuccin.enable = true;
  catppuccin.autoEnable = false;
  catppuccin.flavor = "mocha";
  catppuccin.mako.enable = false; # https://discourse.nixos.org/t/use-services-mako-settings-instead/63902

  gtk.enable = pkgs.stdenv.isLinux;
  home.pointerCursor = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11.enable = true;
  };
}
