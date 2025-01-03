# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/elixir.nix

{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    stylua
    lua-language-server
  ];

  programs.helix.languages = {
    language = [
      {
        name = "lua";
        indent = {
          tab-width = 2;
          unit = "\t";
        };
        auto-format = true;
        formatter = {
          command = "${pkgs.stylua}/bin/stylua";
          args = lib.flatten [
            [ "-" ]

            # Formating Options:
            [
              "--column-width"
              "80"
            ]
            [
              "--indent-type"
              "Tabs"
            ]
            [
              "--indent-width"
              "2"
            ]
            [ "--sort-requires" ]
          ];
        };
      }
    ];

    language-server.lua-language-server = {
      command = "${pkgs.lua-language-server}/bin/lua-language-server";
    };
  };
}
