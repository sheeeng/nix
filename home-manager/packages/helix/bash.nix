# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bash-language-server
  ];

  programs.helix.languages = {
    language-server.bash-language-server = {
      args = [ "start" ];
      command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
    };
  };
}
