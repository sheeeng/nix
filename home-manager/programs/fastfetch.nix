{
  lib,
  pkgs,
  ...
}:
let
  escape = builtins.fromJSON ''"\u001b"'';
  systemNameFieldWidth = 10;
  logo = pkgs.fetchurl {
    url = "https://i.imgur.com/6qFClA1.png";
    hash = "sha256-XgWT+5hZiRRLpc44fYLNPucdT/oA9abgyboDWoSuKB8=";
  };
in
{
  programs.fastfetch = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    settings = {
      logo = {
        type = "kitty";
        source = logo;
        width = 30;
        height = 15;
        padding = {
          top = 1;
          left = 2;
        };
      };
      display = {
        color.keys = "blue";
        separator = "";
        constants = [
          "──────────────────────────────────────────────────────────────────────"
          "${escape}[71D"
          "${escape}[71C"
          "${escape}[70C"
        ];
        brightColor = false;
      };
      modules = [
        {
          type = "version";
          key = "┌───────────────┬─{$1}┐${escape}[65D";
          format = "${escape}[1m{#keys} {1} {2}";
        }
        {
          type = "os";
          key = "│  {icon}  ${escape}[s{sysname}${escape}[u${escape}[${toString systemNameFieldWidth}C│{$3}│{$2}";
        }
        {
          type = "datetime";
          key = "│  {icon}  Fetched   │{$3}│{$2}";
          format = "{year}-{month-pretty}-{day-pretty} {hour-pretty}:{minute-pretty}:{second-pretty} {timezone-name}";
        }
        {
          type = "custom";
          key = "│{#cyan}┌──────────────┬{$1}┐{#keys}│${escape}[61D";
          format = "{#bright_cyan} Hardware ";
        }
        {
          type = "host";
          key = "│{#cyan}│ {icon}  Chassis   │{$4}│{#keys}│{$2}";
        }
        {
          type = "physicalmemory";
          key = "│{#cyan}│ {icon}  RAM       │{$4}│{#keys}│{$2}";
          format = "{size}";
        }
        {
          type = "swap";
          key = "│{#cyan}│ {icon}  Swap      │{$4}│{#keys}│{$2}";
        }
        {
          type = "cpu";
          key = "│{#cyan}│ {icon}  CPU       │{$4}│{#keys}│{$2}";
          showPeCoreCount = true;
        }
        {
          type = "gpu";
          key = "│{#cyan}│ {icon}  GPU       │{$4}│{#keys}│{$2}";
        }
        {
          type = "disk";
          key = "│{#cyan}│ {icon}  Disk      │{$4}│{#keys}│{$2}";
          format = "{size-used} / {size-total} ({size-percentage}) {filesystem}";
        }
        {
          type = "battery";
          key = "│{#cyan}│ {icon}  Battery   │{$4}│{#keys}│{$2}";
        }
        {
          type = "custom";
          key = "│{#cyan}└──────────────┴{$1}┘{#keys}│";
          format = "";
        }
        {
          type = "custom";
          key = "│{#green}┌──────────────┬{$1}┐{#keys}│${escape}[61D";
          format = "{#bright_green} Desktop ";
        }
        {
          type = "de";
          key = "│{#green}│ {icon}  Desktop   │{$4}│{#keys}│{$2}";
        }
        {
          type = "wm";
          key = "│{#green}│ {icon}  Session   │{$4}│{#keys}│{$2}";
        }
        {
          type = "display";
          key = "│{#green}│ {icon}  Display   │{$4}│{#keys}│{$2}";
          compactType = "original-with-refresh-rate";
        }
        {
          type = "gpu";
          key = "│{#green}│ {icon}  G Driver  │{$4}│{#keys}│{$2}";
          format = "{driver}";
        }
        {
          type = "custom";
          key = "│{#green}└──────────────┴{$1}┘{#keys}│";
          format = "";
        }
        {
          type = "custom";
          key = "│{#yellow}┌──────────────┬{$1}┐{#keys}│${escape}[61D";
          format = "{#bright_yellow} Terminal ";
        }
        {
          type = "shell";
          key = "│{#yellow}│ {icon}  Shell     │{$4}│{#keys}│{$2}";
        }
        {
          type = "terminal";
          key = "│{#yellow}│ {icon}  Terminal  │{$4}│{#keys}│{$2}";
        }
        {
          type = "terminalfont";
          key = "│{#yellow}│ {icon}  Term Font │{$4}│{#keys}│{$2}";
        }
        {
          type = "terminaltheme";
          key = "│{#yellow}│ {icon}  Colors    │{$4}│{#keys}│{$2}";
        }
        {
          type = "packages";
          key = "│{#yellow}│ {icon}  Packages  │{$4}│{#keys}│{$2}";
        }
        {
          type = "custom";
          key = "│{#yellow}└──────────────┴{$1}┘{#keys}│";
          format = "";
        }
        {
          type = "custom";
          key = "│{#red}┌──────────────┬{$1}┐{#keys}│${escape}[63D";
          format = "{#bright_red} Development ";
        }
        {
          type = "command";
          keyIcon = "";
          key = "│{#red}│ {icon}  Rust      │{$4}│{#keys}│{$2}";
          text = "rustc --version";
          format = "rustc {~6,13}";
          parallel = false;
        }
        {
          type = "command";
          keyIcon = "";
          key = "│{#red}│ {icon}  Clang     │{$4}│{#keys}│{$2}";
          text = "clang --version | head --lines=1 | awk '{print $NF}'";
          format = "clang {}";
          parallel = false;
        }
        {
          type = "command";
          keyIcon = "";
          key = "│{#red}│ {icon}  NodeJS    │{$4}│{#keys}│{$2}";
          text = "node --version";
          format = "node {~1}";
          parallel = false;
        }
        {
          type = "command";
          keyIcon = "";
          key = "│{#red}│ {icon}  Go        │{$4}│{#keys}│{$2}";
          text = "go version | cut --delimiter=' ' --fields=3";
          format = "go {~2}";
          parallel = false;
        }
        {
          type = "command";
          keyIcon = "";
          key = "│{#red}│ {icon}  Zig       │{$4}│{#keys}│{$2}";
          text = "zig version";
          format = "zig {}";
          parallel = false;
        }
        {
          type = "editor";
          key = "│{#red}│ {icon}  Editor    │{$4}│{#keys}│{$2}";
        }
        {
          type = "command";
          keyIcon = "󰊢";
          key = "│{#red}│ {icon}  Git       │{$4}│{#keys}│{$2}";
          text = "git version";
          format = "git {~12}";
          parallel = false;
        }
        {
          type = "custom";
          key = "│{#red}└──────────────┴{$1}┘{#keys}│";
          format = "";
        }
        {
          type = "custom";
          key = "│{#magenta}┌──────────────┬{$1}┐{#keys}│${escape}[60D";
          format = "{#bright_magenta} Uptime ";
        }
        {
          type = "uptime";
          key = "│{#magenta}│ {icon}  Uptime    │{$4}│{#keys}│{$2}";
        }
        {
          type = "users";
          myselfOnly = true;
          keyIcon = "";
          key = "│{#magenta}│ {icon}  Login     │{$4}│{#keys}│{$2}";
        }
        {
          type = "disk";
          keyIcon = "";
          key = "│{#magenta}│ {icon}  OS Age    │{$4}│{#keys}│{$2}";
          folders = "/";
          format = "{create-time:10} [{days} days]";
        }
        {
          type = "custom";
          key = "│{#magenta}└──────────────┴{$1}┘{#keys}│";
          format = "";
        }
        {
          type = "custom";
          key = "└─────────────────{$1}┘";
          format = "";
        }
        "break"
        "colors"
      ];
    };
  };
}
