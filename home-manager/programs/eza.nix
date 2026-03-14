{ pkgs, ... }:
{
  programs.eza = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableFishIntegration
    enableIonIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableIonIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableZshIntegration
    package = pkgs.eza; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.package
    colors = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.colors
    extraOptions = [
      "--all"
      "--group-directories-first"
      "--long"
      "--header"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.extraOptions
    git = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.git
    icons = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.icons
    theme = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.theme
  };
}
