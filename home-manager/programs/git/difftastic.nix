{ pkgs, ... }:
{
  programs.difftastic = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.difftastic.enable
    git.mode = "external"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.difftastic.git.mode
    package = [ pkgs.difftastic ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.difftastic.package
    options = {
      background = "light";
      color = "auto";
      display = "side-by-side";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.difftastic.options
  };
}
