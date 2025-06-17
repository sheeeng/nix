# https://github.com/alexnabokikh/nix-config/blob/bddec40e097d4227cd95badfc02164aa006a8a4c/modules/home-manager/programs/aerospace/default.nix

{
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [
      aerospace
    ];

    home.file.".aerospace.toml".source = ./aerospace.toml;
  };
}
