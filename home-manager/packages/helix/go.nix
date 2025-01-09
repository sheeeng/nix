{ lib, pkgs, ... }:
{
  programs.helix = {
    languages = {
      language = [
        {
          name = "go";
          auto-format = true;
          language-servers = [
            "gopls"
            "golangci-lint-lsp"
            "gpt"
          ];
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
          command = lib.getExe pkgs.golangci-lint; # https://search.nixos.org/packages?channel=unstable&type=packages&show=golangci-lint
        };
        gopls = {
          command = lib.getExe pkgs.gopls; # https://search.nixos.org/packages?channel=unstable&type=packages&show=gopls
        };
      };
    };
  };
}
