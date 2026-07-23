_: { }

# {
#   pkgs,
#   inputs,
#   ...
# }:

# let
#   pkgs-unstable = import inputs.nixpkgs {
#     inherit (pkgs.stdenv.hostPlatform) system;
#     config.allowUnfree = true;
#   };
# in
# {
#   imports = [
#     # (modulesPath + "/installer/scan/not-detected.nix")
#     inputs.home-manager.nixosModules.default
#   ];

#   boot.kernelPackages = pkgs.linuxPackages_latest;

#   boot.initrd.luks.devices = {
#     root = {
#       device = "/dev/nvme0n1p2";
#       preLVM = true;
#       allowDiscards = true;
#     };
#   };

#   fileSystems = {
#     "/boot" = {
#       device = "/dev/nvme0n1p1";
#       fsType = "vfat";
#     };
#     "/" = {
#       device = "/dev/vg/root";
#       fsType = "ext4";
#     };
#     "/home" = {
#       device = "/dev/vg/home";
#       fsType = "ext4";
#     };
#   };

#   swapDevices = [ ];

#   nixpkgs.config.allowUnfree = true;

#   system.stateVersion = config.system.nixos.release;
#   nix = {
#     optimise.automatic = true; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.optimise.automatic # https://github.com/NixOS/nix/issues/7273#issuecomment-2295429401
#     settings = {
#       auto-optimise-store = true; # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
#       experimental-features = [
#         "nix-command"
#         "flakes"
#       ];
#       substituters = [ "https://cache.nixos.org" ];
#       trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
#       extra-substituters = [
#         "https://devenv.cachix.org"
#         "https://ryanccn.cachix.org"
#       ];
#       extra-trusted-public-keys = [
#         "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
#         "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
#         "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
#       ];
#     };
#   };

#   services.lvm.enable = true;

#   networking = {
#     useNetworkd = true;
#     wireless.iwd.enable = true;
#     interfaces.wlan0.useDHCP = true;
#     firewall.enable = true;
#   };

#   time.timeZone = "Europe/Oslo";
#   i18n = {
#     defaultLocale = "en_US.UTF-8";
#     extraLocaleSettings = {
#       LC_TIME = "nb_NO.UTF-8";
#     };
#   };

#   security.polkit.enable = true;

#   # https://nixos.wiki/wiki/Bluetooth
#   hardware.bluetooth.enable = true; # enables support for Bluetooth
#   hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

#   home-manager.useGlobalPkgs = true;
#   home-manager.useUserPackages = true;
#   home-manager.extraSpecialArgs = { inherit pkgs-unstable; };

#   home-manager.users.leonard = ./home-manager.nix;

#   users.users.leonard = {
#     group = "wheel";
#     isSystemUser = true;
#   };
# }
