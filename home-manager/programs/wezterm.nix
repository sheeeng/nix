{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.enableBashIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.enableZshIntegration
    package = pkgs.wezterm; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.package
    colorSchemes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.colorSchemes
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wezterm.extraConfig
  };
}
