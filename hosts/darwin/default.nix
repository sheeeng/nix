{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ../../modules/ca-certificates.nix
    ../../modules/home-manager.nix
  ];

  determinateNix.nixosVmBasedLinuxBuilder = {
    config.virtualisation = {
      cores = 8;
      darwin-builder.memorySize = 8192;
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch64 {
      vz.rosetta.enable = false;
    };
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isAarch64 then
        pkgs.darwin.linux-builder-vz
      else
        pkgs.darwin.linux-builder;
    supportedFeatures =
      if pkgs.stdenv.hostPlatform.isAarch64 then
        [
          "benchmark"
          "big-parallel"
        ]
      else
        [
          "benchmark"
          "big-parallel"
          "kvm"
        ];
    systems = [
      (if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64-linux" else "x86_64-linux")
    ];
  };

  environment.systemPackages =
    with pkgs;
    lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") [
      container # https://search.nixos.org/packages?channel=unstable&type=packages&show=container
    ]
    ++ [
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
