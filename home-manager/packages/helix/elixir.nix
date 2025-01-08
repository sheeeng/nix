# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/elixir.nix

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    beam.packages.erlang.elixir-ls # https://search.nixos.org/packages?channel=unstable&type=packages&show=elixir-ls
  ];

  programs.helix.languages = {
    language = [
      {
        name = "elixir";
        indent = {
          tab-width = 2;
          unit = "\t";
        };
        auto-format = true;
        comment-token = "#";
        file-types = [
          "ex"
          "exs"
        ];
        roots = [ "mix.exs" ];
      }
    ];

    language-server = {
      elixir-ls = {
        command = "${pkgs.elixir-ls}/bin/elixir-ls";
      };
    };
  };
}
