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
    ./elixir.nix
    ./lua.nix
    ./nix.nix
    ./prettier.nix
    ./terraform.nix
    ./typescript.nix
  ];

  programs.helix = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.enable
    package = pkgs.helix; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.package
    defaultEditor = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.defaultEditor
    # extraPackages = [ pkgs.marksman ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.extraPackages
    ignores = [
      "!.gitignore"
      ".build/"
      "node_modules"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.ignores
    languages = {
      language-server = {
        # rust-analyzer = {
        #   # https://rust-analyzer.github.io/manual.html
        #   config = {
        #     check.command = "clippy";
        #     cargo = {
        #       features = "all";
        #     };
        #   };
        # }; # https://github.com/Lehmanator/nix-configs/blob/0b9cf9562c765032cca49bc6575f4f8ea42de17b/hm/profiles/languages/rust.nix#L108-L116

        # typescript-language-server.command = lib.getExe pkgs.nodePackages.typescript-language-server; # https://github.com/llakala/nixos/blob/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/core/helix/language-servers.nix#L6

        # taplo.command = lib.getExe pkgs.taplo; # taplo-lsp is just an alias for taplo

        # marksman.command = lib.getExe pkgs.marksman;

        # # TODO: FIXME
        # # mdpls = {
        # #   command = lib.getExe programs.mdpls;
        # #   # lib.getExe self.packages.${pkgs.system}.mdpls; # https://github.com/llakala/nixos/blob/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/core/helix/language-servers.nix#L14
        # #   config.markdown.preview = # https://github.com/euclio/mdpls?tab=readme-ov-file#configuration
        # #     {
        # #       auto = true; # Automatically open preview in browser when opening file
        # #       serveStatic = true; # Show images
        # #     };
        # # };

        # vscode-json-language-server = {
        #   command = lib.getExe pkgs.nodePackages.vscode-json-languageserver;
        #   args = [ "--stdio" ];
        #   config.provideFormatter = false;
        # };

        # vim-language-server = {
        #   command = lib.getExe pkgs.vim-language-server;
        #   args = lib.singleton "--stdio";
        # };

        # bash-language-server = {
        #   command = lib.getExe pkgs.nodePackages.bash-language-server;
        #   environment.SHELLCHECK_ARGUMENTS = "-e SC2164"; # Couldn't get `config` block to work, so this is the best way to disable certain shellchecks in linting
        # };
      };
      language = [
        # {
        #   name = "rust";
        #   auto-format = true;
        #   formatter = {
        #     command = "rustfmt";
        #     # args = ["+nightly"];
        #   };
        # }
      ]; # https://github.com/Lehmanator/nix-configs/blob/0b9cf9562c765032cca49bc6575f4f8ea42de17b/hm/profiles/languages/rust.nix#L117-L124
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.languages

    settings = {
      # theme = "base16"; # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      editor = {
        auto-format = true;
        bufferline = "never";
        color-modes = true;
        cursorline = true;
        line-number = "absolute";
        soft-wrap.enable = true;
        rulers = [
          72
          80
          100
          120
        ];

        indent-guides = {
          render = true;
          character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽"
          skip-levels = 1;
        }; # https://github.com/m0ar/nix/blob/a46f9fba4f8ea3599adf2b7026970f769d0bd721/args/helix/default.nix#L53-L57

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        # file-picker = {
        #   hidden = false;
        #   git-ignore = false;
        # };

        # statusline = {
        #   mode = {
        #     normal = "";
        #     insert = "";
        #     select = "";
        #   };

        #   left = [
        #     "mode"
        #     "spacer"
        #     "spinner"
        #     "file-name"
        #   ];
        #   right = [
        #     "diagnostics"
        #     "position"
        #     "primary-selection-length"
        #     "file-encoding"
        #     "file-type"
        #     "version-control"
        #     "spacer"
        #     "position-percentage"
        #   ];
        # };

        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
      # theme = "catppuccin_macchiato"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      # editor = {
      #   line-number = "relative";
      #   lsp.display-messages = true;
      # };
      # keys.insert = {
      #   j = {
      #     k = "normal_mode";
      #   };
      # };
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
