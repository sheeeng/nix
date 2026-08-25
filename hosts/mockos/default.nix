{
  inputs,
  pkgs,
  ...
}:
let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/basecamp/omakub/master/themes/tokyo-night/background.jpg";
    hash = "sha256-wEph35ko8cGweAUAeGSL2dcXMm5cwZ/J3mIomJrwHyQ=";
  };
in
{
  imports = [
    ../../modules/home-manager.nix
    ../../modules/yabai
    inputs.home-manager.darwinModules.home-manager
  ];

  networking.hostName = "mockos";
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };
  programs.zsh.enable = false;

  system = {
    primaryUser = "mockos";
    stateVersion = 5;
  };

  users.users.mockos = {
    home = "/Users/mockos";
    isHidden = false;
    name = "mockos";
    uid = 501;
  };

  home-manager.users.mockos =
    { lib, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        ../../home-manager/fonts.nix
        ../../home-manager/packages.nix
        ../../home-manager/programs/aerospace
        ../../home-manager/programs/neovim/home-manager.nix
        ../../home-manager/programs/starship.nix
        ../../home-manager/programs/tmux.nix
        ../../home-manager/programs/wezterm.nix
        ../../home-manager/programs/zsh
      ];

      home = {
        homeDirectory = "/Users/mockos";
        stateVersion = lib.trivial.release;
        file."Pictures/Wallpapers/tokyo-night.jpg".source = wallpaper;
      };

      nixpkgs.config.allowUnfree = true;

      home.activation.setTokyoNightWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to POSIX file "${wallpaper}"'
      '';

      programs = {
        home-manager.enable = true;

        tmux.extraConfig = lib.mkAfter ''
          set -g status-style "bg=#16161e,fg=#a9b1d6"
          set -g window-status-current-style "bg=#7aa2f7,fg=#16161e"
          set -g pane-active-border-style "fg=#7aa2f7"
          set -g pane-border-style "fg=#3b4261"
        '';
      };

      catppuccin = {
        enable = true;
        autoEnable = false;
        flavor = "mocha";
      };
    };
}
