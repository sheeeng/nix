{ pkgs, ... }:
{
  home.packages = with pkgs; [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.packages

  programs.helix = {
    languages = {
      language = [ ];
      language-server = { };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.languages
  };
}
