_: { }

# {
#   inputs,
#   lib,
#   pkgs,
#   ...
# }:
# {
#   imports = [
#     inputs.nixos-hardware.nixosModules.raspberry-pi-4
#     ../../modules/nixos
#   ];

#   boot.loader = {
#     generic-extlinux-compatible.enable = true;
#     efi.canTouchEfiVariables = true;
#     systemd-boot.configurationLimit = 10;
#   };

#   # https://wiki.nixos.org/wiki/fonts#installing_all_nerdfonts
#   fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
# }
