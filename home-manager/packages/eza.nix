{ pkgs, ... }:
{
  programs = {
    eza = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
      package = pkgs.eza; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.package
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableFishIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableNushellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enableZshIntegration
    };
  };
}
