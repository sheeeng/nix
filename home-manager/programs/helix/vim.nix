{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.packages

  programs.helix = {
    languages = {
      vim = {
        scope = "source.vim";
        language-server = {
          vim-language-server = {
            command = "${pkgs.vim-language-server}/bin/vim-language-server"; # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim-language-server
            args = lib.singleton "--stdio";
          };
        };
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.languages
  };
}
