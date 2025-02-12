{ pkgs, ... }:
{
  programs.ripgrep = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable
    package = pkgs.ripgrep; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.package
    arguments = [
      "--max-columns-preview"
      "--colors=line:style:bold"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.arguments
  };
}
