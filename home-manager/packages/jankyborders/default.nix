{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      jankyborders # https://search.nixos.org/packages?channel=unstable&type=packages&show=jankyborders
    ];

    home.file.".config/borders".text = ''
      #!/usr/bin/env bash

      options=(
        style=round
        width=5.0
        hidpi=off
        active_color=0xff619ac1
        inactive_color=0xff414550
        blacklist="idea,Arc"
      )

      # The double single quotes before dollar curly brace escapes the dollar sign in Nix.
      borders "''${options[@]}" || exit 1
    '';
  };
}
