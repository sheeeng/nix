# _: { }

{ config, ... }:

{
  imports = [
    # inputs.nixos-hardware.nixosModules.dell-latitude-7490
    ../../modules/nixos
  ];

  # The option nixpkgs.system is still fully supported for interoperability, but will be deprecated in the future, so we recommend to set nixpkgs.hostPlatform.
  nixpkgs.hostPlatform = config.nixpkgs.system;
}
