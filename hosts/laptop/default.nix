# _: { }

{ lib, pkgs, ... }:
{
  imports = [
    # inputs.nixos-hardware.nixosModules.dell-latitude-7490
    ../../modules/nixos
  ];

  # https://wiki.nixos.org/wiki/fonts#installing_all_nerdfonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
