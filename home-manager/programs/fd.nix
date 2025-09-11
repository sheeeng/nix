{ pkgs, ... }:
{
  programs.fd = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable
    package = pkgs.fd; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.package
    extraOptions = [
      "--no-ignore"
      "--absolute-path"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.extraOptions
    hidden = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.hidden
    ignores = [
      ".git/"
      "*.bak"
      "node_modules"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.ignores
  };
}
