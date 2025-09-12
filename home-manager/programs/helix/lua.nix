{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    stylua
    lua-language-server
  ];

  programs.helix = {
    languages = {
      language = [
        {
          name = "lua";
          indent = {
            tab-width = 2;
            unit = "\t";
          };
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.stylua; # https://search.nixos.org/packages?channel=unstable&type=packages&show=stylua
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
      language-server = {
        lua-language-server = {
          command = lib.getExe pkgs.lua-language-server; # https://search.nixos.org/packages?channel=unstable&type=packages&show=lua-language-server
        };
      };
    };
  };
}
