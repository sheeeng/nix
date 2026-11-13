{
  lib,
  pkgs,
  ...
}:
{
  home.activation.herdrIntegrationInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for integration in codex copilot omp opencode pi; do
      run ${lib.getExe pkgs.herdr} integration install "$integration" 2>/dev/null || true
    done
    if command -v hermes-agent >/dev/null 2>&1; then
      run ${lib.getExe pkgs.herdr} integration install hermes 2>/dev/null || true
    fi
  ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
  # claude is excluded: the SessionStart hook is declared in claude-code.nix via programs.claude-code.settings.hooks.

  programs.herdr = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.enable
    mutableSettings = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.mutableSettings
    package = pkgs.herdr; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.package
    settings = {
      onboarding = false;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.herdr.settings
  };
}
