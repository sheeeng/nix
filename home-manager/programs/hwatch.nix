{ pkgs, ... }:
{
  programs.hwatch = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.hwatch.enable
    package = pkgs.hwatch; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.hwatch.package
    extraArgs = [
      "--exec"
      "--precise"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.hwatch.extraArgs
  };
}
