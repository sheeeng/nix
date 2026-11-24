{ pkgs, ... }:

{
  programs.waybar = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.enable
    package = pkgs.waybar; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.waybar.package
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
          "tray"
        ];

        "sway/workspaces" = {
          "disable-scroll" = false;
          "all-outputs" = true;
          "format" = "{name}";
          "format-icons" = {
            "1" = "󰲨";
            "2" = "󰲪";
            "3" = "󰲬";
            "4" = "󰲮";
            "5" = "󰲰";
            "6" = "󰲲";
            "7" = "󰲴";
            "8" = "󰲶";
            "9" = "󰲸";
            "10" = "󰲺";
          };
        };

        "sway/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
        };

        "sway/window" = {
          "format" = "{}";
          "max-length" = 120;
        };

        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% 󰂰 {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "󰂑";
            "headset" = "󰂑";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
          "min-length" = 13;
        };

        "network" = {
          "format-wifi" = "󰤨 {essid}";
          "format-ethernet" = "󰌘 {ipaddr}/{cidr}";
          "format-linked" = "󰌘 {ifname} (No IP)";
          "format-disconnected" = "⚠ Disconnected";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "on-click-right" = "nmtui";
        };

        "cpu" = {
          "interval" = 10;
          "format" = "󰓅 {usage}%";
          "max-length" = 10;
        };

        "memory" = {
          "interval" = 10;
          "format" = "󰍛 {}%";
          "max-length" = 10;
        };

        "temperature" = {
          "critical-threshold" = 80;
          "format-critical" = "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
            "󰔝"
            "󰔞"
            "󰔟"
          ];
        };

        "battery" = {
          "states" = {
            "good" = 80;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% 󰂄";
          "format-plugged" = "{capacity}% 󰂄";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        "clock" = {
          "interval" = 1;
          "format" = "󰔽 {:%Y-%m-%d 󰅐 %H:%M:%S}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "tray" = {
          "icon-size" = 20;
          "spacing" = 10;
        };
      };
    }; # https://man.archlinux.org/man/waybar-sway.5
  };
}
