{ pkgs, ... }:
{
  programs.nix-index = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nix-index.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nix-index.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nix-index.enableFishIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nix-index.enableZshIntegration
    package = pkgs.nix-index; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nix-index.package
  };
}
