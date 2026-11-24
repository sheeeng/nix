{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../linux
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; }; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.extraSpecialArgs
    sharedModules = [
      {
        nixpkgs.overlays = [
          (import ../../overlays { inherit inputs; }).additions
          (import ../../overlays { inherit inputs; }).modifications
        ];
      }
    ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.sharedModules
    useUserPackages = true; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
    users.llee.imports = [
      ../../home-manager/home.nix
      inputs.agenix.homeManagerModules.age
      inputs.catppuccin.homeModules.catppuccin
      inputs.nix-index-database.homeModules.nix-index
      inputs.nixvim.homeModules.nixvim
    ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.users
  };

  networking = {
    firewall.interfaces.tailscale0.allowedTCPPorts = config.services.openssh.ports;
    hostName = "p14s";
    networkmanager.enable = true;
  };

  nix = {
    extraOptions = ''
      !include ${config.sops.templates.nix-access-token.path}
    '';
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = false;
      settings.PermitRootLogin = "no";
    };
    tailscale.enable = true;
  };

  sops.age.sshKeyPaths = lib.mkForce [ "/etc/ssh/ssh_host_ed25519_key" ];

  system = {
    primaryUser = "llee";
    stateVersion = "26.05";
  };

  users.users.llee = {
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    uid = 1000;
  };
}
