{ pkgs, ... }:
let
in
{
  programs = {
    zoxide = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enable
      package = pkgs.zoxide; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.package
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enableFishIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enableNushellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enableZshIntegration
    };
  };
}
