{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.enableBashIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.enableZshIntegration
    package = pkgs.wezterm; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.package
    colorSchemes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.colorSchemes
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- Font configuration
      config.font = wezterm.font('MesloLGS Nerd Font', { weight = 'Regular' })
      config.font_size = 15.0

      -- Window appearance
      config.window_decorations = "RESIZE"
      config.window_background_opacity = 0.86
      config.macos_window_background_blur = 24
      config.window_padding = {
        left = 5,
        right = 5,
        top = 1,
        bottom = 1,
      }
      config.initial_cols = 80
      config.initial_rows = 24

      -- Terminal settings
      config.term = "xterm-256color"
      config.scrollback_lines = 10000

      -- Theme
      config.color_scheme = 'Catppuccin Mocha'

      -- Shell integration
      config.default_prog = { 'zsh', '-l', '-c', 'tmux attach || tmux' }

      -- Key bindings (iTerm2 style)
      config.keys = {
        -- Word navigation
        { key = 'LeftArrow', mods = 'OPT', action = wezterm.action.SendString('\x1bb') },
        { key = 'RightArrow', mods = 'OPT', action = wezterm.action.SendString('\x1bf') },

        -- Line navigation
        { key = 'LeftArrow', mods = 'CMD', action = wezterm.action.SendString('\x01') },
        { key = 'RightArrow', mods = 'CMD', action = wezterm.action.SendString('\x05') },

        -- Delete word
        { key = 'Backspace', mods = 'OPT', action = wezterm.action.SendString('\x17') },

        -- Delete line
        { key = 'Backspace', mods = 'CMD', action = wezterm.action.SendString('\x15') },

        -- New tab/window
        { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
        { key = 'n', mods = 'CMD', action = wezterm.action.SpawnWindow },

        -- Tab navigation
        { key = '1', mods = 'CMD', action = wezterm.action.ActivateTab(0) },
        { key = '2', mods = 'CMD', action = wezterm.action.ActivateTab(1) },
        { key = '3', mods = 'CMD', action = wezterm.action.ActivateTab(2) },
        { key = '4', mods = 'CMD', action = wezterm.action.ActivateTab(3) },
        { key = '5', mods = 'CMD', action = wezterm.action.ActivateTab(4) },
        { key = '6', mods = 'CMD', action = wezterm.action.ActivateTab(5) },

        -- Copy/Paste
        { key = 'c', mods = 'CMD', action = wezterm.action.CopyTo 'Clipboard' },
        { key = 'v', mods = 'CMD', action = wezterm.action.PasteFrom 'Clipboard' },

        -- Clear screen
        { key = 'k', mods = 'CMD', action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },
      }

      -- Mouse bindings
      config.mouse_bindings = {
        {
          event = { Up = { streak = 1, button = 'Left' } },
          mods = 'NONE',
          action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        {
          event = { Up = { streak = 1, button = 'Left' } },
          mods = 'CTRL',
          action = wezterm.action.OpenLinkAtMouseCursor,
        },
      }

      return config
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.extraConfig
  };
}
