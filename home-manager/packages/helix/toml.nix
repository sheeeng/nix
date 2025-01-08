# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ ... }:
{
  programs.helix.languages = {
    languages = [
      {
        name = "toml";
        language-servers = [ "taplo" ];
        formatter = {
          command = "taplo";
          args = [
            "fmt"
            "-o"
            "column_width=120"
            "-"
          ];
        };
        auto-format = true;
      }
    ];

    language-server = {

    };
  };
}
