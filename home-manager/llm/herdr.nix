{
  lib,
  pkgs,
  ...
}:
{
  home.activation.herdrIntegrationInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for integration in claude codex copilot hermes omp opencode pi; do
      run ${lib.getExe pkgs.herdr} integration install "$integration" 2>/dev/null || true
    done
  ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation

  programs.herdr = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.enable
    mutableSettings = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.mutableSettings
    package = pkgs.herdr; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.package
    settings = {
      onboarding = false;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.settings
  };
}
