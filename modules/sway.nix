{
  config,
  lib,
  pkgs,
  ...
}:
# NixOS only. Import this module in a host to add Sway next to its current session. The host
# must define system.primaryUser, which hosts/linux/sops.nix declares.
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    brightnessctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=brightnessctl
    grim # https://search.nixos.org/packages?channel=unstable&type=packages&show=grim
    slurp # https://search.nixos.org/packages?channel=unstable&type=packages&show=slurp
    wl-clipboard # https://search.nixos.org/packages?channel=unstable&type=packages&show=wl-clipboard
    # keep-sorted end
  ];

  home-manager.users."${config.system.primaryUser}" = {
    programs.waybar = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
      settings.mainBar = {
        # keep-sorted start block=yes
        battery.format = "{capacity}% battery";
        clock.format = "{:%Y-%m-%d %H:%M:%S}";
        clock.interval = 1; # Seconds in the format need a one second refresh.
        height = 30;
        layer = "top";
        modules-center = [ "sway/window" ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
          "tray"
        ];
        position = "top";
        # keep-sorted end
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.settings
      systemd.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.systemd.enable
    };

    services.mako.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.mako.enable

    services.swayidle = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swayidle.enable
      timeouts = [
        {
          timeout = 300;
          command = "${lib.getExe pkgs.swaylock} --daemonize";
        }
      ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swayidle.timeouts

    wayland.systemd.target = "sway-session.target"; # Keeps Waybar and Swayidle out of GNOME sessions. https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.systemd.target

    wayland.windowManager.sway = {
      config = {
        bars = [ ]; # Waybar draws the bar.
        input = {
          "type:touchpad" = {
            dwt = "enabled";
            natural_scroll = "enabled";
            tap = "enabled";
          };
        };
        keybindings = lib.mkOptionDefault {
          XF86AudioLowerVolume = "exec ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          XF86AudioMute = "exec ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          XF86AudioRaiseVolume = "exec ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          XF86MonBrightnessDown = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
          XF86MonBrightnessUp = "exec ${lib.getExe pkgs.brightnessctl} set 5%+";
        };
        modifier = "Mod4";
        terminal = lib.getExe pkgs.ghostty;
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.config
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.enable
      extraConfig = "include /etc/sway/config.d/*"; # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.extraConfig
      package = null; # The NixOS module installs the wrapped package. https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.package
    };
  };

  # GDM lists Sway next to GNOME. This module does not change the default session.
  programs.sway = {
    enable = true; # https://search.nixos.org/options?channel=unstable&show=programs.sway.enable
    wrapperFeatures.gtk = true; # https://search.nixos.org/options?channel=unstable&show=programs.sway.wrapperFeatures.gtk
  }; # https://search.nixos.org/options?channel=unstable&show=programs.sway

  xdg.portal.wlr.enable = true; # https://search.nixos.org/options?channel=unstable&show=xdg.portal.wlr.enable
}
