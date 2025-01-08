# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ lib, pkgs, ... }:
{
  programs.helix.languages = {
    language = [ ];

    language-server = {
      marksman = {
        command = lib.getExe pkgs.marksman;
      };
    };
  };
}
