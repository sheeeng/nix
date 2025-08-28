{ pkgs, ... }:
{
  programs.broot = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.broot.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.broot.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.broot.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.broot.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.broot.enableZshIntegration
    package = pkgs.broot; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.broot.package
  };
}
