# TODO: https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/zellij/default.nix
{ pkgs, ... }:
{
  programs.zellij = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enableFishIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enableZshIntegration
    package = pkgs.zellij; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.package
    attachExistingSession = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.attachExistingSession
    exitShellOnExit = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.exitShellOnExit
    extraConfig = ''
      keybinds {
          // keybinds are divided into modes
          normal {
              unbind "Alt f"
              bind "Alt F" {  ToggleFloatingPanes; }
              // bind instructions can include one or more keys (both keys will be bound separately)
              // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
              bind "Ctrl g" { SwitchToMode "locked"; }
              bind "Ctrl p" { SwitchToMode "pane"; }
              bind "Alt n" { NewPane; }
              bind "Alt h" { MoveFocusOrTab "Left"; }
          }
          pane {
              bind "h" "Left" { MoveFocus "Left"; }
              bind "l" "Right" { MoveFocus "Right"; }
              bind "j" "Down" { MoveFocus "Down"; }
              bind "k" "Up" { MoveFocus "Up"; }
              bind "p" { SwitchFocus; }
          }
          locked {
              bind "Ctrl g" { SwitchToMode "normal"; }
          }
      }
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.extraConfig
    layouts = {
      dev = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:tab-bar";
                      };
                    };
                  }
                  { "children" = { }; }
                  {
                    pane = {
                      size = 2;
                      borderless = true;
                      plugin = {
                        location = "zellij:status-bar";
                      };
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Project";
                  focus = true;
                };
                _children = [
                  {
                    pane = {
                      command = "nvim";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Git";
                };
                _children = [
                  {
                    pane = {
                      command = "lazygit";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Files";
                };
                _children = [
                  {
                    pane = {
                      command = "yazi";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Shell";
                };
                _children = [
                  {
                    pane = {
                      command = "zsh";
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.layouts

    settings = {
      # theme = "custom";
      # themes.custom.fg = "#f8f8f2";
      # themes.custom.bg = "#282a36";
      # keybinds._props.clear-defaults = true;
      # keybinds.pane._children = [
      #   {
      #     bind = {
      #       _args = [ "e" ];
      #       _children = [
      #         { TogglePaneEmbedOrFloating = { }; }
      #         { SwitchToMode._args = [ "locked" ]; }
      #       ];
      #     };
      #   }
      #   {
      #     bind = {
      #       _args = [ "left" ];
      #       MoveFocus = [ "left" ];
      #     };
      #   }
      # ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.settings
    themes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.themes
  };

  # home.file = {
  #   ".config/zellij/config.kdl".text = ''
  #     on_force_close "quit"
  #     default_shell "zsh"
  #     pane_frames false
  #     theme "dracula"
  #     default_layout "simple"
  #     default_mode "normal"
  #     mouse_mode true
  #     scroll_buffer_size 10000
  #     copy_on_select true
  #     copy_command "pbcopy" # https://zellij.dev/documentation/faq.html#copy--paste-isnt-working-how-can-i-fix-this
  #     scrollback_editor "nvim"
  #     mirror_session false
  #     auto_layout false

  #     plugins {
  #         tab-bar { path "tab-bar"; }
  #         status-bar { path "status-bar"; }
  #         strider { path "strider"; }
  #         compact-bar { path "compact-bar"; }
  #     }

  #     themes {
  #        dracula {
  #             fg 248 248 242
  #             bg 40 42 54
  #             black 0 0 0
  #             red 255 85 85
  #             green 80 250 123
  #             yellow 241 250 140
  #             blue 98 114 164
  #             magenta 255 121 198
  #             cyan 139 233 253
  #             white 255 255 255
  #             orange 255 184 108
  #         }
  #     }

  #     ui {
  #         pane_frames {
  #             hide_session_name true
  #         }
  #     }

  #     keybinds clear-defaults=true {
  #         normal {
  #             bind "Ctrl s" { SwitchToMode "tmux"; }

  #             bind "Alt h" { MoveFocusOrTab "Left"; }
  #             bind "Alt l" { MoveFocusOrTab "Right"; }
  #             bind "Alt k" { MoveFocus "Up"; }
  #             bind "Alt j" { MoveFocus "Down"; }
  #         }
  #         "search" {
  #             bind "Ctrl [" "Enter" "Esc" "Ctrl c" "i" { ScrollToBottom; SwitchToMode "normal"; }
  #             bind "Ctrl s" { SwitchToMode "tmux"; }
  #             bind "[" { EditScrollback; ScrollToBottom; SwitchToMode "normal"; }
  #             bind "/" { SwitchToMode "entersearch"; SearchInput 0; }
  #             bind "c" { SearchToggleOption "CaseSensitivity"; }
  #             bind "n" { Search "down"; }
  #             bind "N" { Search "up"; }
  #             bind "j" { ScrollDown; }
  #             bind "k" { ScrollUp; }
  #             bind "d" { HalfPageScrollDown; }
  #             bind "u" { HalfPageScrollUp; }
  #             bind "Ctrl f" { PageScrollDown; }
  #             bind "Ctrl b" { PageScrollUp; }
  #             bind "g" { SwitchToMode "scroll"; }
  #             bind "G" { ScrollToBottom; }
  #         }
  #         "scroll" {
  #             bind "Ctrl [" "Enter" "Esc" "Ctrl c" "i" { ScrollToBottom; SwitchToMode "normal"; }
  #             bind "g" { ScrollToTop; SwitchToMode "search"; }
  #         }
  #         entersearch {
  #             bind "Ctrl [" "Esc" "Ctrl c" { SwitchToMode "normal"; }
  #             bind "Enter" { SwitchToMode "search"; }
  #         }
  #         renametab {
  #             bind "Esc" "Ctrl [" "Ctrl c" { UndoRenameTab; SwitchToMode "normal"; }
  #             bind "Enter" { SwitchToMode "normal"; }
  #         }
  #         renamepane {
  #             bind "Esc" "Ctrl [" "Ctrl c" { UndoRenamePane; SwitchToMode "normal"; }
  #             bind "Enter" { SwitchToMode "normal"; }
  #         }
  #         move {
  #             bind "Enter" "Esc" "Ctrl [" "Space" "i" { SwitchToMode "normal"; }

  #             bind "m" { SwitchToMode "tmux"; }
  #             bind "h" { MovePane "Left"; }
  #             bind "l" { MovePane "Right"; }
  #             bind "k" { MovePane "Up"; }
  #             bind "j" { MovePane "Down"; }
  #             bind "H" { Resize "Left"; }
  #             bind "J" { Resize "Down"; }
  #             bind "K" { Resize "Up"; }
  #             bind "L" { Resize "Right"; }
  #             bind "=" { Resize "Increase"; }
  #             bind "+" { Resize "Increase"; }
  #             bind "-" { Resize "Decrease"; }
  #         }
  #         tmux {
  #             bind "Enter" "Esc" "Ctrl [" "Space" "i" { SwitchToMode "normal"; }

  #             bind "h" { MoveFocusOrTab "Left"; SwitchToMode "normal"; }
  #             bind "l" { MoveFocusOrTab "Right"; SwitchToMode "normal"; }
  #             bind "k" { MoveFocus "Up"; SwitchToMode "normal"; }
  #             bind "j" { MoveFocus "Down"; SwitchToMode "normal"; }

  #             bind "c" { NewTab; SwitchToMode "normal"; }
  #             bind "x" { CloseFocus; SwitchToMode "normal"; }
  #             bind "n" { NewPane; SwitchToMode "normal"; }
  #             bind "\"" { NewPane "Down"; SwitchToMode "normal"; }
  #             bind "%" { NewPane "Right"; SwitchToMode "normal"; }

  #             bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
  #             bind "f" { ToggleFloatingPanes; SwitchToMode "normal"; }
  #             bind "F" { TogglePaneFrames; SwitchToMode "normal"; }

  #             bind "m" { SwitchToMode "move"; }
  #             bind "[" { SwitchToMode "search"; }
  #             bind "/" { SwitchToMode "entersearch"; SearchInput 0; }
  #             bind "z" { ToggleFocusFullscreen; SwitchToMode "normal"; }
  #             bind "C" { Clear; SwitchToMode "normal"; }
  #             bind "," { SwitchToMode "renametab"; TabNameInput 0; }
  #             bind "<" { SwitchToMode "renamepane"; TabNameInput 0; }
  #             bind "d" { Detach; }
  #         }
  #     }
  #   '';

  #   ".config/zellij/layouts/simple.kdl".text = ''
  #     layout {
  #         pane size=1 borderless=true {
  #             plugin location="zellij:compact-bar"
  #         }
  #         pane
  #     }
  #   '';
  # };
}
