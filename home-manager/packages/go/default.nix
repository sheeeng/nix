# TODO: https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/go/default.nix

{ config, pkgs, ... }:
{
  home.packages = [ pkgs.go ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}";
    GOBIN = "${config.home.homeDirectory}/bin";
  };

  home.sessionPath = [ "${config.home.homeDirectory}/bin" ];
}
