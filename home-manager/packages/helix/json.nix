# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:
{
  programs.helix.languages = {
    languages = [
      {
        name = "json";
        auto-format = true;
        formatter = {
          command = "${pkgs.nodePackages.fixjson}/bin/fixjson";
        };
      }
    ];

    language-server = {

    };
  };
}
