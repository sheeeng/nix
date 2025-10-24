# _: { }

# https://github.com/japiirainen/darwin/blob/ccda9d41071e28db0c70f3e66ac220892ecd180d/home/helix.nix

{ pkgs, ... }:
{
  imports = [
    ./languages/default.nix
    ./themes.nix
  ];

  programs.helix = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.enable
    package = pkgs.helix; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.package
    defaultEditor = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.defaultEditor
    extraConfig = ''''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.extraConfig
    extraPackages = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.extraPackages
    ignores = [
      "!.gitignore"
      ".git"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.ignores

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

        clipboard-provider = if pkgs.stdenv.isDarwin then "pasteboard" else "wayland"; # https://docs.helix-editor.com/editor.html?highlight=git-ignore#editorclipboard-provider-section

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
          after-delay = {
            enable = true;
            timeout = 3000;
          };
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
          "space" = {
            "space" = "file_picker";
            "w" = ":w";
            "q" = ":q";
          };
          "esc" = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
          "C-h" = "jump_view_left";
          "C-j" = "jump_view_down";
          "C-k" = "jump_view_up";
          "C-l" = "jump_view_right";
          # "ö" = "goto_word";
          "C-s" = ":w"; # Maps Ctrl-s to the typable command :w which is an alias for :write (save file)
          "Cmd-s" = ":write"; # Cmd or Win or Meta and 's' to write
          "C-o" = ":open ~/.config/helix/config.toml"; # Maps Ctrl-o to opening of the helix config file
          a = "move_char_left"; # Maps the 'a' key to the move_char_left command
          w = "move_line_up"; # Maps the 'w' key to move_line_up
          "C-S-esc" = "extend_line"; # Maps Ctrl-Shift-Escape to extend_line
          g = {
            a = "code_action";
          }; # Maps `ga` to show possible code actions
          "ret" = [
            "open_below"
            "normal_mode"
          ]; # Maps the enter key to open_below then re-enter normal mode
          "A-x" = "@x<A-d>"; # Maps Alt-x to a macro selecting the whole line and deleting it without yanking it
          "+" = {
            m = ":run-shell-command make";
            c = ":run-shell-command cargo build";
            t = ":run-shell-command cargo test";
          };
        };
        select = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
          "ö" = "extend_to_word";
        };
        insert = {
          "C-space" = "completion";
          "A-x" = "normal_mode"; # Maps Alt-X to enter normal mode
          j = {
            k = "normal_mode";
          }; # Maps `jk` to exit insert mode
        }; # https://github.com/Defelo/nixos/blob/e0f26f24dce1a87bd9f4bfd04f23feb2f9c1ea33/home/helix/default.nix#L69-L71
      }; # https://docs.helix-editor.com/remapping.html
    };
  };
}
