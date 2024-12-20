{ pkgs, ... }:
let
in
{
  programs = {
    thefuck = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thefuck.enable
      package = pkgs.thefuck; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thefuck.package
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thefuck.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thefuck.enableFishIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thefuck.enableNushellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thefuck.enableZshIntegration
    };
  };
}
