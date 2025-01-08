# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    go # https://search.nixos.org/packages?channel=unstable&type=packages&show=go
  ];

  programs.helix.languages = {
    language = [
      {
        name = "go";
        auto-format = true;
        formatter = {
          command = "${pkgs.gotools}/bin/goimports";
          args = [
            "-local"
            "github.com/core"
          ];
        };
        indent = {
          tab-width = 2;
          unit = "\t";
        };
      }
    ];

    language-server = {
      golangci-lint = {
        command = lib.getExe pkgs.golangci-lint;
      };
      gopls = {
        command = lib.getExe pkgs.gopls;
      };
    };
  };
}
