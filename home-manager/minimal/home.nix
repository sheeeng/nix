{ lib, ... }:
{
  imports = [
    ../fonts.nix
    ../packages/minimal-cli.nix
    ../packages/git
    ../programs/atuin.nix
    ../programs/codex.nix
    ../programs/fzf.nix
    ../programs/ssh.nix
    ../programs/starship.nix
    ../programs/zoxide.nix
    ../programs/zsh
    ../programs/opencode
  ];

  fonts.fontconfig = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.enable
    antialiasing = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.antialiasing
    configFile = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.configFile
    defaultFonts = {
      emoji = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.emoji
      monospace = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.monospace
      sansSerif = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.sansSerif
      serif = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.serif
    };
    hinting = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.hinting
    subpixelRendering = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.subpixelRendering
  };

  nixpkgs.config.allowUnfree = true;

  home = {
    file = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
    shell = {
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableBashIntegration
      enableFishIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableFishIntegration
      enableNushellIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableNushellIntegration
      enableShellIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableShellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableZshIntegration
    };
    shellAliases = {
      z = "zoxide";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shellAliases
    stateVersion = lib.trivial.release; # Track the nixpkgs release automatically; works on all supported systems. https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  };

  programs.home-manager.enable = true;
}
