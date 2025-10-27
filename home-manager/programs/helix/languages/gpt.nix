{ lib, pkgs, ... }:
{
  programs.helix = {
    languages = {
      language-server = {
        gpt = {
          # command = lib.getExe pkgs.helix-gpt; # https://search.nixos.org/packages?channel=unstable&type=packages&show=helix-gpt
          command = lib.getExe pkgs.bun; # https://search.nixos.org/packages?channel=unstable&type=packages&show=bun
          args = [
            "run"
            "/usr/local/bin/helix-gpt.js"
            "--handler"
            "copilot"
          ];
        }; # https://github.com/helix-editor/helix/discussions/4037#discussioncomment-13972668
      };
    };
  };
}
