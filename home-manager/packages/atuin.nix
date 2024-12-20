{ config, pkgs, ... }:

{
  programs.atuin = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enableZshIntegration
    package = pkgs.atuin; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.package
    flags = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.flags
    settings = {
      auto_sync = true; # https://docs.atuin.sh/configuration/config/#auto_sync
      ctrl_n_shortcuts = true; # https://docs.atuin.sh/configuration/config/#macos-ctrl-n-key-shortcuts
      cwd_filter = [ ]; # https://docs.atuin.sh/configuration/config/#cwd_filter
      db_path = "${config.home.homeDirectory}/.local/share/atuin/history.db"; # https://docs.atuin.sh/configuration/config/#db_path
      dialect = "us"; # https://docs.atuin.sh/configuration/config/#dialect
      enter_accept = false; # https://docs.atuin.sh/configuration/config/#enter_accept
      exit_mode = "return-original"; # https://docs.atuin.sh/configuration/config/#exit_mode
      filter_mode = "global"; # https://docs.atuin.sh/configuration/config/#filter_mode
      filter_mode_shell_up_key_binding = "global"; # https://docs.atuin.sh/configuration/config/#filter_mode_shell_up_key_binding
      history_filter = [ ]; # https://docs.atuin.sh/configuration/config/#history_filter
      history_format = "history list"; # https://docs.atuin.sh/configuration/config/#history_format
      inline_height = 0; # https://docs.atuin.sh/configuration/config/#inline_height
      invert = false; # https://docs.atuin.sh/configuration/config/#invert
      key_path = "${config.home.homeDirectory}/.local/share/atuin/key"; # https://docs.atuin.sh/configuration/config/#key_path
      keymap_cursor = { }; # https://docs.atuin.sh/configuration/config/#keymap_cursor
      keymap_mode = "emacs"; # https://docs.atuin.sh/configuration/config/#keymap_mode
      local_timeout = 5; # https://docs.atuin.sh/configuration/config/#local_timeout
      max_preview_height = 4; # https://docs.atuin.sh/configuration/config/#max_preview_height
      network_connect_timeout = 5; # https://docs.atuin.sh/configuration/config/#network_connect_timeout
      network_timeout = 30; # https://docs.atuin.sh/configuration/config/#network_timeout
      prefers_reduced_motion = false; # https://docs.atuin.sh/configuration/config/#prefers_reduced_motion
      search_mode = "fuzzy"; # https://docs.atuin.sh/configuration/config/#search_mode
      search_mode_shell_up_key_binding = "fuzzy"; # https://docs.atuin.sh/configuration/config/#search_mode_shell_up_key_binding
      secrets_filter = true; # https://docs.atuin.sh/configuration/config/#secrets_filter
      session_path = "${config.home.homeDirectory}/.local/share/atuin/session"; # https://docs.atuin.sh/configuration/config/#session_path
      show_help = true; # https://docs.atuin.sh/configuration/config/#show_help
      show_preview = true; # https://docs.atuin.sh/configuration/config/#show_preview
      show_tabs = true; # https://docs.atuin.sh/configuration/config/#show_tabs
      store_failed = true; # https://docs.atuin.sh/configuration/config/#store_failed
      style = "auto"; # https://docs.atuin.sh/configuration/config/#style
      sync_address = "https://api.atuin.sh"; # https://docs.atuin.sh/configuration/config/#sync_address
      sync_frequency = "5m"; # https://docs.atuin.sh/configuration/config/#sync_frequency
      update_check = true; # https://docs.atuin.sh/configuration/config/#update_check
      workspaces = false; # https://docs.atuin.sh/configuration/config/#workspaces
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.settings
  };
}
