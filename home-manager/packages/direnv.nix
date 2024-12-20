{ pkgs, ... }:
let
in
{
  programs = {
    direnv = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
      package = pkgs.direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.package
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableZshIntegration
    };
  };
}
