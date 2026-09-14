{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ../../modules/home-manager.nix
  ];

  # Hermes Agent runs as a Home Manager user service on macOS. The upstream
  # flake declares aarch64-darwin only, so the x86_64-darwin host is excluded.
  # https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#home-manager-module
  home-manager.sharedModules = lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") [
    inputs.hermes-agent.homeManagerModules.default
    (
      { config, lib, ... }:
      {
        programs.hermes-agent.enable = true;
        services.hermes-agent = {
          enable = true;
          environmentFiles = [ config.sops.templates."hermes/env".path ];
          extraPackages = [ pkgs.gh ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.hermes-agent.extraPackages https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#home-manager-module
          gateway.enable = true;
          settings.agent.reasoning_effort = "medium";
          settings.model.default = "copilot/gpt-5.6-luna";
        };

        # Re-write .env after both hermesAgentSetup and setupSecrets complete.
        # hermesAgentSetup runs before sops-nix renders the template, so
        # the environmentFiles merge produces an empty .env. This step runs
        # after both activation entries and overwrites .env with the rendered
        # sops template.
        home.activation.hermesEnvFromSops = lib.hm.dag.entryAfter [ "hermesAgentSetup" "setupSecrets" ] ''
          $DRY_RUN_CMD install -m 0600 \
            ${lib.escapeShellArg config.sops.templates."hermes/env".path} \
            ${lib.escapeShellArg config.services.hermes-agent.hermesHome}/.env
        '';
      }
    )
  ];

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
