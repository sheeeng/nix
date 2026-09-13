{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ../../modules/home-manager.nix
    inputs.hermes-agent.nixosModules.default
  ];

  # Hermes Agent runs as a hardened NixOS system service. The shared module
  # covers fw13 and p50. https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#nixos-module
  services.hermes-agent = {
    addToSystemPackages = true;
    enable = true;
    environmentFiles = [ config.sops.templates."hermes/env".path ];
    settings.model.default = "deepseek/deepseek-chat";
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

}
