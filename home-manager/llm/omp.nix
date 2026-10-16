{ pkgs, ... }:
{
  home.packages = pkgs.lib.optionals (
    pkgs ? omp && pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.omp
  ) [ pkgs.omp ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.packages
}
