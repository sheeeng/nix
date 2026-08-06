{ pkgs, ... }:
{
  imports = [
    ./sops.nix
    ../../modules/home-manager.nix
  ];

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    dix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dix
    manix # https://search.nixos.org/packages?channel=unstable&type=packages&show=manix
    nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    # nix # Determinate Nix provides Nix on Darwin. Installing this package would shadow it and cause unsupported setting warnings. https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
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
  ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-environment.systemPackages
}
