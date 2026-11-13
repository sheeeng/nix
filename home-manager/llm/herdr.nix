{
  lib,
  pkgs,
  ...
}:
{
  home.activation.herdrIntegrationInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v herdr >/dev/null 2>&1; then
      for integration in claude codex copilot hermes omp opencode pi; do
        run herdr integration install "$integration" 2>/dev/null || true
      done
    fi
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
