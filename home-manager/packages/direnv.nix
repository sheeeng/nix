{ pkgs, ... }:
{
  programs.direnv = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
    package = pkgs.direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.package
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableZshIntegration
    nix-direnv = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.enable
      package = pkgs.nix-direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.package
    };
    silent = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.silent
    stdlib = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.stdlib
  };
}
