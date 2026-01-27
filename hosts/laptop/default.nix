_: { }

# {
#   inputs,
#   lib,
#   pkgs,
#   ...
# }:
# {
#   imports = [
#     inputs.nixos-hardware.nixosModules.dell-latitude-7490
#     ../../modules/nixos
#   ];

#   boot.loader = {
#     systemd-boot.enable = true;
#     efi.canTouchEfiVariables = true;
#     systemd-boot.configurationLimit = 10;
#   };

#   # https://wiki.nixos.org/wiki/fonts#installing_all_nerdfonts
#   fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
# }
