{
  config,
  lib,
  pkgs,
  ...
}:
let
  hermesEnabled = pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64;
in
{
  home.activation.herdrIntegrationInstall =
    lib.hm.dag.entryAfter
      [
        "linkGeneration"
        "writeBoundary"
      ]
      ''
        for integration in codex omp pi; do
          run ${lib.getExe pkgs.herdr} integration install "$integration" 2>/dev/null || true
        done
      ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
  # claude is excluded: the SessionStart hook is declared in claude-code.nix via programs.claude-code.settings.hooks.

  home.activation.herdrHermesIntegrationInstall = lib.mkIf hermesEnabled (
    lib.hm.dag.entryAfter
      [
        "hermesAgentSetup"
        "linkGeneration"
        "writeBoundary"
      ]
      ''
        HERMES_HOME=${lib.escapeShellArg config.services.hermes-agent.hermesHome} \
          run ${lib.getExe pkgs.herdr} integration install hermes 2>/dev/null || true
      ''
  ); # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation

  programs.herdr = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.enable
    mutableSettings = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.mutableSettings
    package = pkgs.herdr; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.package
    settings = {
      onboarding = false;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.settings
  };
}
