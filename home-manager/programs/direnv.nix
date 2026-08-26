{ pkgs, ... }:
{
  programs.direnv = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableBashIntegration
    # enableFishIntegration = true; # Read-only. # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableZshIntegration
    package = pkgs.direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.package
    config = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.config
    mise = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.mise.enable
      package = pkgs.mise; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.mise.package
    };
    nix-direnv = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.enable
      package = pkgs.nix-direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.package
    };
    # https://github.com/direnv/direnv/issues/68#issuecomment-162639262
    silent = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.silent
    stdlib = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.stdlib
  };
}
