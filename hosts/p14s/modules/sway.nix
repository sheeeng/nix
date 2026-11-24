{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORM_PLUGIN_PATH=${pkgs.qt5.plugin_base}/lib/qt-${pkgs.qt5.version}/plugins
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start block=yes newline_separated=no
    grim
    libappindicator-gtk3
    libdbusmenu-gtk3
    libnotify
    mako
    papirus-icon-theme
    qt5.qtwayland
    qt6.qtwayland
    slurp
    swayidle
    swaylock
    swaynotificationcenter
    waybar
    wl-clipboard
    wlogout
    # keep-sorted end
  ];
}
