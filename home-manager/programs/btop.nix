{ pkgs, ... }:
{
  programs.btop = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.btop.enable
    package = pkgs.btop; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.btop.package
  };
}
