# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:
{
  programs.helix.languages = {
    language = [
      {
        name = "bash";
        auto-format = true;
        formatter = {
          command = "${pkgs.shfmt}/bin/shfmt";
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
        command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
      };
    };
  };
}
