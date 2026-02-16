{ pkgs, ... }:
{
  programs.element-desktop = {
    enable = pkgs.stdenv.isLinux; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.element-desktop.enable
    package = pkgs.element-desktop; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.element-desktop.package
    profiles = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.element-desktop.profiles
    settings = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.element-des
  };
}
