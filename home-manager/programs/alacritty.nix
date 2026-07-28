# TODO: https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/alacritty.nix

{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.enable
    package = pkgs.alacritty; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.package
    settings = {
      # https://alacritty.org/config-alacritty.html
      # https://github.com/alexnabokikh/nix-config/blob/bddec40e097d4227cd95badfc02164aa006a8a4c/modules/home-manager/programs/alacritty/default.nix
      general = {
        live_config_reload = true;
      }; # https://alacritty.org/config-alacritty.html#general

      terminal = {
        # Keep zsh as the login shell so nix-darwin's PATH/env setup runs, then
        # hand off to nushell. `exec` replaces zsh, so exiting nu closes the
        # window and no stray zsh process lingers.
        shell = {
          program = "${pkgs.lib.getExe pkgs.zsh}";
          args = [
            "--login"
            "-c"
            "exec ${pkgs.lib.getExe pkgs.nushell}"
          ];
        };
      };

      env = {
        TERM = "xterm-256color";
      }; # https://alacritty.org/config-alacritty.html#env

      window = {
        decorations = if pkgs.stdenv.isDarwin then "buttonless" else "none";
        dynamic_title = false;
        dynamic_padding = true;
        option_as_alt = "OnlyLeft"; # https://github.com/zellij-org/zellij/issues/2051#issuecomment-1461519892
        dimensions = {
          columns = 160;
          lines = 48;
        };
        padding = {
          x = 5;
          y = 1;
        };
      }; # https://alacritty.org/config-alacritty.html#window

      scrolling = {
        history = 10000;
        multiplier = 3;
      }; # https://alacritty.org/config-alacritty.html#scrolling

      font = {
        size = 10;
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
      }; # https://alacritty.org/config-alacritty.html#font

      colors = { }; # https://alacritty.org/config-alacritty.html#colors

      bell = { }; # https://alacritty.org/config-alacritty.html#bell

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      }; # https://alacritty.org/config-alacritty.html#selection

      cursor = { }; # https://alacritty.org/config-alacritty.html#cursor

      mouse = { }; # https://alacritty.org/config-alacritty.html#mouse

      hints = { }; # https://alacritty.org/config-alacritty.html#hints

      keyboard = {
        bindings = [
          # Word navigation
          {
            key = "Left";
            mods = "Alt";
            chars = "\x1b\x62";
          }
          {
            key = "Right";
            mods = "Alt";
            chars = "\x1b\x66";
          }
          # Line navigation
          {
            key = "Left";
            mods = "Command";
            chars = "\x01";
          }
          {
            key = "Right";
            mods = "Command";
            chars = "\x05";
          }
          # Delete word
          {
            key = "Back";
            mods = "Alt";
            chars = "\x17";
          }
          # Delete line
          {
            key = "Back";
            mods = "Command";
            chars = "\x15";
          }
        ];
      }; # https://alacritty.org/config-alacritty.html#keyboard

      debug = { }; # https://alacritty.org/config-alacritty.html#debug

      # colors = {
      #   # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      #   # https://github.com/MatthiasBenaets/nix-config/blob/d14dd9b68805416c527ae998225ce19489d41097/modules/programs/alacritty.nix
      #   font = {
      #     normal.family = "FiraCode Nerd Font";
      #     bold = {
      #       style = "Bold";
      #     };
      #     size = 11;
      #   };
      #   offset = {
      #     x = -1;
      #     y = 0;
      #   };

      #   primary = {
      #     background = "0x002b36";
      #     foreground = "0xEBEBEB";
      #   };

      #   normal = {
      #     black = "0x0d0d0d";
      #     red = "0xFF301B";
      #     green = "0xA0E521";
      #     yellow = "0xFFC620";
      #     blue = "0x1BA6FA";
      #     magenta = "0x8763B8";
      #     cyan = "0x21DEEF";
      #     white = "0xEBEBEB";
      #   };

      #   bright = {
      #     black = "0x6D7070";
      #     red = "0xFF4352";
      #     green = "0xB8E466";
      #     yellow = "0xFFD750";
      #     blue = "0x1BA6FA";
      #     magenta = "0xA578EA";
      #     cyan = "0x73FBF1";
      #     white = "0xFEFEF8";
      #   };
      # };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.settings
    theme = "catppuccin_mocha"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.theme
    themePackage = pkgs.alacritty-theme; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.themePackage
  };
}
