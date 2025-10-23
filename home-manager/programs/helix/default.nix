# _: { }

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
    ./all.nix
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
      ".git"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.ignores

    # languages = {
    #   language-server = { };
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.languages

    settings = {
      # theme = "base16"; # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      editor = {
        scrolloff = 5;
        mouse = true;
        middle-click-paste = true;
        scroll-lines = 3;
        shell = [
          "sh"
          "-c"
        ];
        line-number = "absolute"; # Options: "absolute" | "relative"
        cursorline = true;
        cursorcolumn = false;
        auto-completion = true;
        auto-format = true;
        idle-timeout = 250;
        preview-completion-insert = true;
        completion-trigger-len = 2;
        completion-replace = false;
        auto-info = true;
        true-color = false;
        undercurl = false;
        color-modes = true;
        text-width = 80;
        workspace-lsp-roots = [ ];
        default-line-ending = "native"; # Options: "native" | "lf" | "crlf" | "ff" | "cr" | "nel"
        insert-final-newline = true;
        popup-border = "none"; # Options: "none" | "all" | "menu"
        indent-heuristic = "hybrid"; # Options: "simple" | "tree-sitter" | "hybrid"
        jump-label-alphabet = "abcdefghijklmnopqrstuvwxyz";
        bufferline = "always"; # Options: "never" | "always" | "multiple"
        rulers = [
          72
          80
          100
          120
        ];

        clipboard-provider = "system"; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorclipboard-provider-section

        statusline = {
          left = [
            # "mode"
            # "spacer"
            # "spinner"
            # "file-name"
            "mode"
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [ ];
          right = [
            # "diagnostics"
            # "position"
            # "primary-selection-length"
            # "file-encoding"
            # "file-type"
            # "version-control"
            # "spacer"
            # "position-percentage"
            "diagnostics"
            "selections"
            "register"
            "position"
            "file-encoding"
          ];
          separator = "│";
          mode = {
            normal = "NOR";
            insert = "INS";
            select = "SEL";
          };
          diagnostics = [
            "warning"
            "error"
          ];
          workspace-diagnostics = [
            "warning"
            "error"
          ];
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorstatusline-section

        lsp = {
          enable = true;
          display-messages = true;
          display-progress-messages = false;
          auto-signature-help = true;
          display-inlay-hints = false;
          # inlay-hints-length-limit = null;
          display-color-swatches = true;
          display-signature-help-docs = true;
          snippets = true;
          goto-reference-include-declaration = true;
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorlsp-section

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorcursor-shape-section

        file-picker = {
          hidden = true;
          follow-symlinks = true;
          deduplicate-links = true;
          parents = true;
          ignore = true;
          git-ignore = true;
          git-global = true;
          git-exclude = true;
          # max-depth = null;
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorfile-picker-section

        auto-pairs = true; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorauto-pairs-section

        auto-save = {
          focus-lost = true;
          after-delay.enabled = true;
          after-delay.timeout = 3000;
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorauto-save-section

        search = {
          smart-case = true;
          wrap-around = true;
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorsearch-section

        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·"; # Tabs will look like "→···" depending on tab width.
          };
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorwhitespace-section

        indent-guides = {
          render = true;
          character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽".
          skip-levels = 0;
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorindent-guides-section

        gutters = {
          layout = [
            "diagnostics"
            "spacer"
            "line-numbers"
            "spacer"
            "diff"
          ];
          line-numbers = {
            min-width = 3;
          }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorguttersline-numbers-section
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorgutters-section

        soft-wrap = {
          enable = false;
          max-wrap = 20;
          max-indent-retain = 40;
          wrap-indicator = "↪";
          wrap-at-text-width = false;
        }; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorsoft-wrap-section

        smart-tab = {
          enable = true;
          supersede-menu = false;
        }; # https://docs.helix-editor.com/editor.html#editorsmart-tab-section

        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "warning";
          prefix-len = 1;
          max-wrap = 20;
          max-diagnostics = 10;
        }; # https://docs.helix-editor.com/editor.html#editorinline-diagnostics-section
      }; # https://docs.helix-editor.com/editor.html#editor-section

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
