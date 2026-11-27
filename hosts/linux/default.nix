{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ../../modules/ca-certificates.nix
    ../../modules/home-manager.nix
    inputs.hermes-agent.nixosModules.default
  ];

  home-manager.sharedModules = [
    inputs.rex.homeManagerModules.default
    {
      programs.rex.enable = true; # https://www.superlogical.com/rex/docs/linux/installation#the-home-manager-module
      services.rex.enable = true; # https://www.superlogical.com/rex/docs/linux/installation#the-home-manager-module
    }
  ];

  # Plymouth shows the disk passphrase dialog on encrypted hosts. Quiet boot
  # keeps boot messages off the dialog.
  boot = {
    consoleLogLevel = 0; # https://search.nixos.org/options?channel=unstable&show=boot.consoleLogLevel
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
    ]; # https://search.nixos.org/options?channel=unstable&show=boot.kernelParams
    plymouth.enable = true; # https://search.nixos.org/options?channel=unstable&show=boot.plymouth.enable
  };

  # Hermes Agent runs as a hardened NixOS system service. The shared module
  # covers fw13 and p50. https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#nixos-module
  services.hermes-agent = {
    addToSystemPackages = true;
    enable = true;
    environmentFiles = [ config.sops.templates."hermes/env".path ];
    # Hermes applies a patch for 0.19.2, which fails on bootstrap patchelf 0.15.2.
    package = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      pmPackages = lib.filterAttrs (_: lib.isDerivation) (
        pkgs.callPackage "${inputs.hermes-agent}/nix/pm-packages.nix" {
          patchelf = pkgs.patchelf.overrideAttrs {
            src = pkgs.fetchurl {
              url = "https://github.com/NixOS/patchelf/releases/download/0.19.2/patchelf-0.19.2.tar.bz2";
              hash = "sha256-1K2aTlxongkRnOLzCpSw6LT5jHhZASPqIWZeNMaSiAE=";
            };
            version = "0.19.2";
          };
        }
      );
    };
    settings.model.default = "deepseek/deepseek-chat";
  };

  services.mullvad-vpn.enable = true;

  # Mullvad drops Tailscale traffic unless it carries the Mullvad exclusion marks.
  # The rules apply on hosts that enable nftables. https://mullvad.net/en/help/split-tunneling-with-linux-advanced
  networking.nftables.tables.mullvad-tailscale = lib.mkIf config.networking.nftables.enable {
    family = "inet"; # https://search.nixos.org/options?channel=unstable&show=networking.nftables.tables
    content = ''
      chain incoming {
        type filter hook input priority -100; policy accept;
        ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
      chain outgoing {
        type route hook output priority -100; policy accept;
        ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    ''; # https://search.nixos.org/options?channel=unstable&show=networking.nftables.tables
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    dix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dix
    firefox-beta # https://search.nixos.org/packages?channel=unstable&type=packages&show=manix
    manix # https://search.nixos.org/packages?channel=unstable&type=packages&show=manix
    nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
    nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
    nix-prefetch-git # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-git
    nix-prefetch-github # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-github
    nix-prefetch-scripts # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-scripts
    nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
    nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
    nvd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nvd
    uutils-coreutils-noprefix # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
    uutils-diffutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-diffutils
    uutils-findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-findutils
    uutils-sed # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-sed
    uutils-tar # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-tar
    # keep-sorted end
  ]; # https://search.nixos.org/options?channel=unstable&query=environment.systemPackages&type=options#show=option%253Aenvironment.systemPackages

  virtualisation.podman.enable = true;
}
