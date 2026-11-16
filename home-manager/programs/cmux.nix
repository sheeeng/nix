# https://github.com/manaflow-ai/cmux
{ lib, pkgs, ... }:
{
  # cmux only supports aarch64-darwin; skip this module elsewhere.
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) {
    home.activation.cmuxHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.getExe pkgs.cmux} hooks claude install --yes || true
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation

    xdg.configFile."cmux/cmux.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux-settings.schema.json";
      schemaVersion = 1;
      terminal.adaptiveDefaultTheme = false;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.configFile
  }; # https://nix-community.github.io/home-manager/options.xhtml#opt-config
}
