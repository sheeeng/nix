# https://github.com/japiirainen/darwin/blob/ccda9d41071e28db0c70f3e66ac220892ecd180d/home/helix.nix

{
  # lib,
  pkgs,
  ...
}:
{
  # https://snowfall.org/reference/lib/#libsnowfallfsget-non-default-nix-files
  # imports = lib.snowfall.fs.get-non-default-nix-files ./.; # https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/default.nix#L15
  imports = [
    ./bash.nix
    ./docker.nix
    ./elixir.nix
    ./go.nix
    ./gpt.nix
    ./json.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
    ./nodejs.nix
    ./prettier.nix
    ./python.nix
    ./rust.nix
    ./template.nix
    ./terraform.nix
    ./toml.nix
    ./typescript.nix
    ./vim.nix
    ./yaml.nix
  ];

  programs.helix = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.enable
    package = pkgs.helix; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.package
    defaultEditor = true; # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions. # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.defaultEditor
    extraPackages = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.extraPackages
    ignores = [
      "!.gitignore"
      ".build/"
      "node_modules"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.ignores
    # languages = {
    #   language-server = { };
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.languages

    settings = {
      # theme = "base16"; # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      editor = {
        auto-format = true;
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        line-number = "absolute";
        rulers = [
          72
          80
          100
          120
        ];
        mouse = false;

        indent-guides = {
          render = true;
          character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽"
          skip-levels = 1;
        }; # https://github.com/m0ar/nix/blob/a46f9fba4f8ea3599adf2b7026970f769d0bd721/args/helix/default.nix#L53-L57

        file-picker = {
          hidden = false;
          git-ignore = false;
        };

        statusline = {
          mode = {
            normal = "";
            insert = "";
            select = "";
          };

          left = [
            "mode"
            "spacer"
            "spinner"
            "file-name"
          ];
          right = [
            "diagnostics"
            "position"
            "primary-selection-length"
            "file-encoding"
            "file-type"
            "version-control"
            "spacer"
            "position-percentage"
          ];
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        idle-timeout = 0;
        bufferline = "always";
        soft-wrap = {
          enable = true;
        };
        # inline-diagnostics = {
        #   cursor-line = "hint";
        #   other-lines = "warning";
        # }; # https://github.com/helix-editor/helix/discussions/11230

      };

      keys = {
        normal = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
          "C-h" = "jump_view_left";
          "C-j" = "jump_view_down";
          "C-k" = "jump_view_up";
          "C-l" = "jump_view_right";
          # "ö" = "goto_word";
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
        };
        select = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
          "ö" = "extend_to_word";
        };
        insert = {
          "C-space" = "completion";
        }; # https://github.com/Defelo/nixos/blob/e0f26f24dce1a87bd9f4bfd04f23feb2f9c1ea33/home/helix/default.nix#L69-L71
      };

      # theme = "catppuccin_macchiato"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.settings

    themes = {
      # base16 =
      #   let
      #     transparent = "none";
      #     gray = "#665c54";
      #     dark-gray = "#3c3836";
      #     white = "#fbf1c7";
      #     black = "#282828";
      #     red = "#fb4934";
      #     green = "#b8bb26";
      #     yellow = "#fabd2f";
      #     orange = "#fe8019";
      #     blue = "#83a598";
      #     magenta = "#d3869b";
      #     cyan = "#8ec07c";
      #   in
      #   {
      #     "ui.menu" = transparent;
      #     "ui.menu.selected" = {
      #       modifiers = [ "reversed" ];
      #     };
      #     "ui.linenr" = {
      #       fg = gray;
      #       bg = dark-gray;
      #     };
      #     "ui.popup" = {
      #       modifiers = [ "reversed" ];
      #     };
      #     "ui.linenr.selected" = {
      #       fg = white;
      #       bg = black;
      #       modifiers = [ "bold" ];
      #     };
      #     "ui.selection" = {
      #       fg = black;
      #       bg = blue;
      #     };
      #     "ui.selection.primary" = {
      #       modifiers = [ "reversed" ];
      #     };
      #     "comment" = {
      #       fg = gray;
      #     };
      #     "ui.statusline" = {
      #       fg = white;
      #       bg = dark-gray;
      #     };
      #     "ui.statusline.inactive" = {
      #       fg = dark-gray;
      #       bg = white;
      #     };
      #     "ui.help" = {
      #       fg = dark-gray;
      #       bg = white;
      #     };
      #     "ui.cursor" = {
      #       modifiers = [ "reversed" ];
      #     };
      #     "variable" = red;
      #     "variable.builtin" = orange;
      #     "constant.numeric" = orange;
      #     "constant" = orange;
      #     "attributes" = yellow;
      #     "type" = yellow;
      #     "ui.cursor.match" = {
      #       fg = yellow;
      #       modifiers = [ "underlined" ];
      #     };
      #     "string" = green;
      #     "variable.other.member" = red;
      #     "constant.character.escape" = cyan;
      #     "function" = blue;
      #     "constructor" = blue;
      #     "special" = blue;
      #     "keyword" = magenta;
      #     "label" = magenta;
      #     "namespace" = blue;
      #     "diff.plus" = green;
      #     "diff.delta" = yellow;
      #     "diff.minus" = red;
      #     "diagnostic" = {
      #       modifiers = [ "underlined" ];
      #     };
      #     "ui.gutter" = {
      #       bg = black;
      #     };
      #     "info" = blue;
      #     "hint" = dark-gray;
      #     "debug" = dark-gray;
      #     "warning" = yellow;
      #     "error" = red;
      #   };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.themes
  };
}
