# TODO: https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/zellij/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile = {
    # https://github.com/cratedev/snowcrate/blob/78fc9f15c9497a4577f4407ba64b5dea550c657b/modules/home/cli/zellij/default.nix#L30
    # https://github.com/not-matthias/dotfiles-nix/blob/b3d3f7166a6d8c97942781fa7ac4804352f72bcc/modules/home/programs/zellij.nix#L64-L77
    "zellij/layouts/default.kdl".text = ''
      layout {
        pane

        pane size=2 borderless=true {
          plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
            format_left  "#[fg=0,bg=10][{session}]  {tabs}"
            format_right "#[fg=0,bg=10]{datetime}"
            format_space "#[bg=10]"

            hide_frame_for_single_pane "true"

            tab_normal   "{index}:{name}  "
            tab_active   "{index}:{name}* "

            datetime          " {format} "
            datetime_format   "%H:%M %d-%b-%y"
            datetime_timezone "Europe/Vienna"
          }
        }
      }
    '';

    "zellij/plugins/zjstatus.wasm".source = pkgs.fetchurl {
      url = "https://github.com/dj95/zjstatus/releases/download/v0.21.1/zjstatus.wasm";
      sha256 = "sha256-3BmCogjCf2aHHmmBFFj7savbFeKGYv3bE2tXXWVkrho=";
    };
    "zellij/plugins/zellij_forgot.wasm".source = pkgs.fetchurl {
      url = "https://github.com/karimould/zellij-forgot/releases/download/0.4.2/zellij_forgot.wasm";
      # sha256 = lib.fakeSha256; # sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
      sha256 = "sha256-MRlBRVGdvcEoaFtFb5cDdDePoZ/J2nQvvkoyG6zkSds=";
    };
    "zellij/plugins/zellij-datetime.wasm".source = pkgs.fetchurl {
      url = "https://github.com/h1romas4/zellij-datetime/releases/download/v0.21.0/zellij-datetime.wasm";
      sha256 = "sha256-oVMh3LlFe4hcY9XmcEHz8pmodyf1aMvgDH31QEusEEE=";
    };
  };

  programs.zellij = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enable
    enableBashIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enableFishIntegration
    enableZshIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enableZshIntegration
    package = pkgs.zellij; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.package
    attachExistingSession = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.attachExistingSession
    exitShellOnExit = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.exitShellOnExit
    extraConfig = ''
      keybinds {
          // keybinds are divided into modes
          normal {
              // keybind = alt+left=unbind // https://github.com/zellij-org/zellij/issues/4151#issuecomment-2976947187
              // keybind = alt+right=unbind // https://github.com/ghostty-org/ghostty/discussions/3207#discussioncomment-11673995
              unbind "Alt f"
              bind "Alt F" {  ToggleFloatingPanes; }
              // bind instructions can include one or more keys (both keys will be bound separately)
              // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
              bind "Ctrl g" { SwitchToMode "locked"; }
              bind "Ctrl p" { SwitchToMode "pane"; }
              bind "Alt n" { NewPane; }
              bind "Alt h" { MoveFocusOrTab "Left"; }
          }
          tmux {
              bind "1" { GoToTab 1; SwitchToMode "Normal"; }
              bind "2" { GoToTab 2; SwitchToMode "Normal"; }
              bind "3" { GoToTab 3; SwitchToMode "Normal"; }
              bind "4" { GoToTab 4; SwitchToMode "Normal"; }
              bind "5" { GoToTab 5; SwitchToMode "Normal"; }
              bind "6" { GoToTab 6; SwitchToMode "Normal"; }
              bind "7" { GoToTab 7; SwitchToMode "Normal"; }
              bind "8" { GoToTab 8; SwitchToMode "Normal"; }
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
          shared_except "locked" {
              bind "Ctrl y" {
                  LaunchOrFocusPlugin "file:${config.xdg.configHome}/zellij/plugins/zellij_forgot.wasm" {
                      "lock"                  "ctrl + g"
                      "unlock"                "ctrl + g"
                      "new pane"              "ctrl + p + n"
                      "change focus of pane"  "ctrl + p + arrow key"
                      "close pane"            "ctrl + p + x"
                      "rename pane"           "ctrl + p + c"
                      "toggle fullscreen"     "ctrl + p + f"
                      "toggle floating pane"  "ctrl + p + w"
                      "toggle embed pane"     "ctrl + p + e"
                      "choose right pane"     "ctrl + p + l"
                      "choose left pane"      "ctrl + p + r"
                      "choose upper pane"     "ctrl + p + k"
                      "choose lower pane"     "ctrl + p + j"
                      "new tab"               "ctrl + t + n"
                      "close tab"             "ctrl + t + x"
                      "change focus of tab"   "ctrl + t + arrow key"
                      "rename tab"            "ctrl + t + r"
                      "sync tab"              "ctrl + t + s"
                      "brake pane to new tab" "ctrl + t + b"
                      "brake pane left"       "ctrl + t + ["
                      "brake pane right"      "ctrl + t + ]"
                      "toggle tab"            "ctrl + t + tab"
                      "increase pane size"    "ctrl + n + +"
                      "decrease pane size"    "ctrl + n + -"
                      "increase pane top"     "ctrl + n + k"
                      "increase pane right"   "ctrl + n + l"
                      "increase pane bottom"  "ctrl + n + j"
                      "increase pane left"    "ctrl + n + h"
                      "decrease pane top"     "ctrl + n + K"
                      "decrease pane right"   "ctrl + n + L"
                      "decrease pane bottom"  "ctrl + n + J"
                      "decrease pane left"    "ctrl + n + H"
                      "move pane to top"      "ctrl + h + k"
                      "move pane to right"    "ctrl + h + l"
                      "move pane to bottom"   "ctrl + h + j"
                      "move pane to left"     "ctrl + h + h"
                      "search"                "ctrl + s + s"
                      "go into edit mode"     "ctrl + s + e"
                      "detach session"        "ctrl + o + w"
                      "open session manager"  "ctrl + o + w"
                      "quit zellij"           "ctrl + q"
                      floating true
                  }
              }
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
      simplified_ui = false; # https://github.com/zellij-org/zellij/issues/3486#issuecomment-2562137415
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
