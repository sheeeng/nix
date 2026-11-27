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
  # Catppuccin Macchiato. https://github.com/catppuccin/i3/blob/main/themes/catppuccin-macchiato
  macchiato = {
    base = "#24273a";
    blue = "#8aadf4";
    green = "#a6da95";
    lavender = "#b7bdf8";
    mauve = "#c6a0f6";
    overlay0 = "#6e738d";
    peach = "#f5a97f";
    red = "#ed8796";
    rosewater = "#f4dbd6";
    surface0 = "#363a4f";
    text = "#cad3f5";
    yellow = "#eed49f";
  };
  rofiTheme = pkgs.writeText "macchiato.rasi" ''
    * {
      background: ${macchiato.base};
      background-alt: ${macchiato.surface0};
      foreground: ${macchiato.text};
      selected: ${macchiato.mauve};
    }

    window {
      background-color: @background;
      border: 2px;
      border-color: @selected;
      border-radius: 12px;
      padding: 8px;
    }

    mainbox {
      background-color: transparent;
    }

    inputbar {
      background-color: @background-alt;
      border-radius: 8px;
      padding: 6px 10px;
      spacing: 8px;
      text-color: @foreground;
    }

    prompt, entry {
      background-color: transparent;
      text-color: @foreground;
    }

    listview {
      background-color: transparent;
      lines: 8;
      spacing: 4px;
    }

    element {
      background-color: transparent;
      border-radius: 8px;
      padding: 6px;
      text-color: @foreground;
    }

    element selected.normal {
      background-color: @selected;
      text-color: @background;
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
    }
  '';
  # Each lock picks one entry at random. Swaylock scales an image in proportion until it covers the display
  # and crops the overflow around the center, so it is never squeezed and shows no border. The color is the
  # fallback background, which shows if the image fails to load. The last entry has no image. It shows the
  # plain Catppuccin Macchiato lock screen from the programs.swaylock theme below.
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
    { color = "24273a"; }
  ];
  # Cliphist cannot tell which program owns a copy, so the store script checks which window has the focus.
  # List the app ID or window class in lower case. Find it with:
  # swaymsg --type get_tree | jq '.. | objects | select(.focused? == true) | .app_id // .window_properties.class'
  clipboardExcludedApps = [
    "1password"
    "bitwarden"
    "enpass"
    "org.keepassxc.keepassxc"
  ];
  clipboardPicker = pkgs.writeShellApplication {
    name = "clipboard-picker";
    runtimeInputs = with pkgs; [
      cliphist
      rofi
      wl-clipboard
    ];
    text = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
  };
  cliphistStore = pkgs.writeShellApplication {
    name = "cliphist-store";
    runtimeInputs = with pkgs; [
      cliphist
      coreutils
      gnugrep
      jq
      sway
    ];
    text = ''
      # An unknown focus stores the copy. Cliphist itself skips a copy that its source marks as sensitive.
      focused="$(swaymsg --type get_tree | jq --raw-output '[.. | objects | select(.focused? == true)] | first | (.app_id // .window_properties.class // "") | ascii_downcase')" || focused=""
      if [ -n "$focused" ] && printf '%s\n' ${lib.escapeShellArgs clipboardExcludedApps} | grep --quiet --line-regexp --fixed-strings --regexp "$focused"; then
        cat > /dev/null
        exit 0
      fi
      exec cliphist -max-items 100 store
    '';
  };
  # The assigns below send each demo terminal to its workspace, so the launcher never races the workspace switch.
  demoLauncher = pkgs.writeShellApplication {
    name = "sway-demo";
    runtimeInputs = with pkgs; [
      cava
      cmatrix
      fastfetch
      ghostty
      lavat
      sway
    ];
    text = ''
      ghostty --class=demo.cava -e cava &
      ghostty --class=demo.fastfetch -e sh -c 'fastfetch; exec "''${SHELL:-sh}"' &
      ghostty --class=demo.cmatrix -e cmatrix &
      ghostty --class=demo.lavat -e lavat -c magenta -k blue &
      swaymsg 'workspace number 8'
      # The browser opens on the workspace that has the focus, next to the visualizer.
      exec firefox --new-window
    '';
  };
  lockScript = pkgs.writeShellScript "swaylock-random" ''
    screens=(${
      lib.concatMapStringsSep " " (screen: "${screen.image or "-"}:${screen.color}") lockScreens
    })
    screen="''${screens[RANDOM % ''${#screens[@]}]}"
    image="''${screen%:*}"
    color="''${screen##*:}"
    if [ "$image" = "-" ]; then
      exec ${lib.getExe pkgs.swaylock} --color "$color" --daemonize
    fi
    exec ${lib.getExe pkgs.swaylock} --color "$color" --daemonize --image "$image" --scaling fill
  '';
  lockCommand = toString lockScript;
in
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    brightnessctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=brightnessctl
    cava # https://search.nixos.org/packages?channel=unstable&type=packages&show=cava
    cmatrix # https://search.nixos.org/packages?channel=unstable&type=packages&show=cmatrix
    fastfetch # https://search.nixos.org/packages?channel=unstable&type=packages&show=fastfetch
    ghostty # The terminal that Sway starts. https://search.nixos.org/packages?channel=unstable&type=packages&show=ghostty
    grim # https://search.nixos.org/packages?channel=unstable&type=packages&show=grim
    lavat # https://search.nixos.org/packages?channel=unstable&type=packages&show=lavat
    slurp # https://search.nixos.org/packages?channel=unstable&type=packages&show=slurp
    swaylock # The locker that Swayidle starts. https://search.nixos.org/packages?channel=unstable&type=packages&show=swaylock
    wl-clipboard # https://search.nixos.org/packages?channel=unstable&type=packages&show=wl-clipboard
    # keep-sorted end
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ]; # https://search.nixos.org/options?channel=unstable&show=fonts.packages

  programs.thunar = {
    enable = true; # https://search.nixos.org/options?channel=unstable&show=programs.thunar.enable
    plugins = [ pkgs.thunar-volman ]; # https://search.nixos.org/options?channel=unstable&show=programs.thunar.plugins
  };

  services.gvfs.enable = true; # Thunar mounts drives and uses the trash through gvfs. https://search.nixos.org/options?channel=unstable&show=services.gvfs.enable
  services.tumbler.enable = true; # Thunar shows thumbnails through tumbler. https://search.nixos.org/options?channel=unstable&show=services.tumbler.enable

  home-manager.users."${config.system.primaryUser}" = {
    programs.waybar = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
      settings.mainBar = {
        # keep-sorted start block=yes
        "sway/window".max-length = 40;
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
        margin-left = 8; # The margins make the bar float.
        margin-right = 8;
        margin-top = 6;
        memory.format = "{}% 🧠";
        modules-center = [ "clock" ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/window"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
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
      # Catppuccin Macchiato palette. Each module is a pill. The bar itself is transparent.
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
          color: ${macchiato.text};
        }

        #battery,
        #clock,
        #cpu,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #tray,
        #window,
        #workspaces {
          background: rgba(36, 39, 58, 0.85);
          border: 1px solid rgba(183, 189, 248, 0.35);
          border-radius: 999px;
          margin: 0 3px;
          padding: 2px 12px;
        }

        #workspaces {
          padding: 2px 4px;
        }

        #workspaces button {
          background: transparent;
          border-radius: 999px;
          color: ${macchiato.text};
          padding: 0 8px;
        }

        #workspaces button.focused {
          background: ${macchiato.mauve};
          color: ${macchiato.base};
          font-weight: bold;
        }

        #workspaces button.urgent {
          background: ${macchiato.red};
          color: ${macchiato.base};
        }

        #battery.critical,
        #network.disconnected {
          color: ${macchiato.red};
        }

        #battery.warning {
          color: ${macchiato.yellow};
        }

        #cpu {
          color: ${macchiato.blue};
        }

        #memory {
          color: ${macchiato.green};
        }

        #mode {
          color: ${macchiato.peach};
        }

        #window {
          color: ${macchiato.lavender};
        }
      ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.style
      systemd.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.systemd.enable
      systemd.targets = [ "sway-session.target" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.systemd.targets
    };

    # Catppuccin Macchiato theme for swaylock, from https://github.com/catppuccin/swaylock (MIT license). The
    # NixOS module installs the swaylock package, which also reads this file. The lock script passes --color per
    # image, which replaces the theme background only when an image fails to load.
    programs.swaylock = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.swaylock.enable
      package = null; # The NixOS module installs the package. https://nix-community.github.io/home-manager/options.xhtml#opt-programs.swaylock.package
      settings = {
        bs-hl-color = "f4dbd6";
        caps-lock-bs-hl-color = "f4dbd6";
        caps-lock-key-hl-color = "a6da95";
        color = "24273a";
        inside-caps-lock-color = "24273a";
        inside-clear-color = "24273a";
        inside-color = "24273a";
        inside-ver-color = "24273a";
        inside-wrong-color = "24273a";
        key-hl-color = "a6da95";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cad3f5";
        line-caps-lock-color = "00000000";
        line-clear-color = "00000000";
        line-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-caps-lock-color = "f5a97f";
        ring-clear-color = "f4dbd6";
        ring-color = "363a4f";
        ring-ver-color = "8aadf4";
        ring-wrong-color = "ee99a0";
        separator-color = "00000000";
        text-caps-lock-color = "f5a97f";
        text-clear-color = "f4dbd6";
        text-color = "cad3f5";
        text-ver-color = "8aadf4";
        text-wrong-color = "ee99a0";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.swaylock.settings
    };

    programs.rofi.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.enable
    programs.rofi.theme = "${rofiTheme}"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.theme

    systemd.user.services.cliphist = {
      Install.WantedBy = [ "sway-session.target" ];
      Service = {
        ExecStart = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe cliphistStore}";
        Restart = "on-failure";
      };
      Unit = {
        After = [ "sway-session.target" ];
        Description = "Store the clipboard history, except for copies from the listed apps.";
        PartOf = [ "sway-session.target" ];
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.services

    services.swaync = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swaync.enable
      style = ./sway/swaync-macchiato.css; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.swaync.style
    };

    # GNOME owns the notification service in a GNOME session, so start SwayNotificationCenter in Sway only.
    systemd.user.services.swaync = {
      Install.WantedBy = lib.mkForce [ "sway-session.target" ];
      Unit = {
        After = lib.mkForce [ "sway-session.target" ];
        PartOf = lib.mkForce [ "sway-session.target" ];
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.services

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
        colors = {
          background = macchiato.base;
          focused = {
            background = macchiato.base;
            border = macchiato.lavender;
            childBorder = macchiato.lavender;
            indicator = macchiato.rosewater;
            text = macchiato.text;
          };
          focusedInactive = {
            background = macchiato.base;
            border = macchiato.overlay0;
            childBorder = macchiato.overlay0;
            indicator = macchiato.rosewater;
            text = macchiato.text;
          };
          placeholder = {
            background = macchiato.base;
            border = macchiato.overlay0;
            childBorder = macchiato.overlay0;
            indicator = macchiato.overlay0;
            text = macchiato.text;
          };
          unfocused = {
            background = macchiato.base;
            border = macchiato.overlay0;
            childBorder = macchiato.overlay0;
            indicator = macchiato.rosewater;
            text = macchiato.text;
          };
          urgent = {
            background = macchiato.base;
            border = macchiato.peach;
            childBorder = macchiato.peach;
            indicator = macchiato.overlay0;
            text = macchiato.peach;
          };
        }; # Catppuccin Macchiato. https://github.com/catppuccin/i3
        assigns = {
          "8" = [ { app_id = "^demo\\.cava$"; } ];
          "9" = [ { app_id = "^demo\\.(cmatrix|fastfetch|lavat)$"; } ];
        };
        bars = [ ]; # Waybar draws the bar.
        input = {
          "type:touchpad" = {
            dwt = "enabled";
            natural_scroll = "enabled";
            tap = "enabled";
          };
        };
        keybindings = lib.mkOptionDefault {
          "Mod4+Shift+n" =
            "exec ${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --toggle-panel --skip-wait"; # Show the notification center.
          "Mod4+Shift+d" = "exec ${lib.getExe demoLauncher}"; # Open the demo apps in workspaces 8 and 9.
          "Mod4+e" = "exec ${lib.getExe pkgs.thunar}";
          "Mod4+v" = "exec ${lib.getExe clipboardPicker}";
          XF86AudioLowerVolume = "exec ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          XF86AudioMute = "exec ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          XF86AudioRaiseVolume = "exec ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          XF86MonBrightnessDown = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
          XF86MonBrightnessUp = "exec ${lib.getExe pkgs.brightnessctl} set 5%+";
        };
        menu = "${lib.getExe pkgs.rofi} -show drun";
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
