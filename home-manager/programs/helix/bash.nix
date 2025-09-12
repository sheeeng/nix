{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    bash-completion # https://search.nixos.org/packages?channel=unstable&type=packages&show=bash-completion
    bash-language-server # https://search.nixos.org/packages?channel=unstable&type=packages&show=bash-language-server
    nix-bash-completions # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-bash-completions
    shellcheck # https://search.nixos.org/packages?channel=unstable&type=packages&show=shellcheck
    shellharden # https://search.nixos.org/packages?channel=unstable&type=packages&show=shellharden
  ];

  programs.helix = {
    languages = {
      language = [
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.shfmt; # https://search.nixos.org/packages?channel=unstable&type=packages&show=shfmt
            args = [
              "--binary-next-line"
              "--case-indent"
              "--indent 2"
              "--simplify"
              "--space-redirects"
            ];
          };
        }
      ];
      language-server = {
        bash-language-server = {
          args = [ "start" ];
          command = lib.getExe pkgs.bash-language-server; # "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
        };
      };
    };
  };
}
