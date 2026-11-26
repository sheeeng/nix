{
  config,
  lib,
  pkgs,
  ...
}:
# NixOS only. Import this module in a host to add Sway as a session choice in GDM. The module does
# not change the default session. A host sets services.displayManager.defaultSession itself. The
# host must define system.primaryUser, which hosts/linux/sops.nix declares.
let
  # Each lock picks one image at random. Swaylock scales it in proportion until it covers the display
  # and crops the overflow around the center, so it is never squeezed and shows no border. The color is
  # the fallback background, which shows if the image fails to load.
  lockScreens = [
    {
      color = "246f24";
      image = ./sway/lock-screen-green-cht-10.png;
    }
    {
      color = "246f24";
      image = ./sway/lock-screen-green-cht-11.png;
    }
    {
      color = "246f24";
      image = ./sway/lock-screen-green.png;
    }
    {
      color = "1a74a8";
      image = ./sway/lock-screen-stable.jpeg;
    }
  ];
  lockScript = pkgs.writeShellScript "swaylock-random" ''
    screens=(${lib.concatMapStringsSep " " (screen: "${screen.image}:${screen.color}") lockScreens})
    screen="''${screens[RANDOM % ''${#screens[@]}]}"
    exec ${lib.getExe pkgs.swaylock} --color "''${screen##*:}" --daemonize --image "''${screen%:*}" --scaling fill
  '';
  lockCommand = toString lockScript;
in
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    brightnessctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=brightnessctl
    ghostty # The terminal that Sway starts. https://search.nixos.org/packages?channel=unstable&type=packages&show=ghostty
    grim # https://search.nixos.org/packages?channel=unstable&type=packages&show=grim
    slurp # https://search.nixos.org/packages?channel=unstable&type=packages&show=slurp
    swaylock # The locker that Swayidle starts. https://search.nixos.org/packages?channel=unstable&type=packages&show=swaylock
    wl-clipboard # https://search.nixos.org/packages?channel=unstable&type=packages&show=wl-clipboard
    # keep-sorted end
  ];

  home-manager.users."${config.system.primaryUser}" = {
    programs.waybar = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
      settings.mainBar = {
        # keep-sorted start block=yes
        battery.format = "{capacity}% 🔋";
        battery.format-charging = "Charging {capacity}% ⚡️";
        battery.format-critical = "Low {capacity}% 🪫";
        battery.format-plugged = "Full {capacity}% ⚡️";
        battery.format-warning = "Low {capacity}% 🪫";
        battery.states.critical = 15;
        battery.states.warning = 30;
        clock.format = "{:%a %Y-%m-%d %H:%M:%S}";
        clock.interval = 1; # Seconds in the format need a one second refresh.
        clock.locale = "en_US.UTF-8"; # The system time locale is Norwegian, which prints the weekday in Norwegian.
        cpu.format = "{usage}% 🧶";
        height = 30;
        layer = "top";
        memory.format = "{}% 🧠";
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
        network.format-disconnected = "Offline ⚠️";
        network.format-ethernet = "{ipaddr} 🔌";
        network.format-wifi = "{essid} 📶";
        position = "top";
        pulseaudio.format = "{volume}% {icon}";
        pulseaudio.format-icons.default = [
          "🔈"
          "🔉"
          "🔊"
        ];
        pulseaudio.format-muted = "Muted 🔇";
        # keep-sorted end
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.settings
      systemd.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.systemd.enable
      systemd.targets = [ "sway-session.target" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.systemd.targets
    };

    services.mako.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.mako.enable

    services.swayidle = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swayidle.enable
      events = {
        before-sleep = lockCommand; # Lock before suspend. Swayidle waits for the locker.
        lock = lockCommand; # Handle loginctl lock-session.
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swayidle.events
      systemdTargets = [ "sway-session.target" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swayidle.systemdTargets
      timeouts = [
        {
          command = "${lib.getExe pkgs.brightnessctl} --save set 10%"; # Dim the screen after four minutes.
          resumeCommand = "${lib.getExe pkgs.brightnessctl} --restore";
          timeout = 240;
        }
        {
          command = lockCommand;
          timeout = 300;
        }
        {
          command = "${lib.getExe' pkgs.sway "swaymsg"} 'output * power off'"; # Turn the display off after ten minutes.
          resumeCommand = "${lib.getExe' pkgs.sway "swaymsg"} 'output * power on'";
          timeout = 600;
        }
      ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swayidle.timeouts

    systemd.user.services.polkit-gnome-agent = {
      Install.WantedBy = [ "sway-session.target" ];
      Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Unit = {
        After = [ "sway-session.target" ];
        Description = "GNOME PolicyKit agent for Sway. GNOME Shell supplies its own agent in GNOME sessions.";
        PartOf = [ "sway-session.target" ];
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.services

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
        output."*".bg = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath} fill"; # The NixOS GNOME dark wallpaper.
        terminal = lib.getExe pkgs.ghostty;
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.config
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.enable
      extraConfig = "include /etc/sway/config.d/*"; # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.extraConfig
      package = null; # The NixOS module installs the wrapped package. https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.package
    };
  };

  programs.sway = {
    enable = true; # https://search.nixos.org/options?channel=unstable&show=programs.sway.enable
    wrapperFeatures.gtk = true; # https://search.nixos.org/options?channel=unstable&show=programs.sway.wrapperFeatures.gtk
  }; # https://search.nixos.org/options?channel=unstable&show=programs.sway

  xdg.portal.wlr.enable = true; # https://search.nixos.org/options?channel=unstable&show=xdg.portal.wlr.enable
}
