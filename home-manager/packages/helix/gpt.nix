{ lib, pkgs, ... }:
{
  programs.helix = {
    languages = {
      language-server = {
        gpt = {
          command = lib.getExe pkgs.helix-gpt; # https://search.nixos.org/packages?channel=unstable&type=packages&show=helix-gpt
          args = [
            "--handler"
            "copilot"
          ];
        };
      };
    };
  };
}
