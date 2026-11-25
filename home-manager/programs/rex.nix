{
  config,
  lib,
  pkgs,
  ...
}:
let
  ghosttyConfiguration = config.xdg.configFile."ghostty/config".text;
  isPaletteLine = line: builtins.match "(background|foreground|palette) = .*" line != null;
  ghosttyTheme = pkgs.writeText "Ghostty-Dark.ghostty" (
    lib.concatLines (builtins.filter isPaletteLine (lib.splitString "\n" ghosttyConfiguration))
  );
  importGhosttyTheme = pkgs.writeShellApplication {
    name = "rex-import-ghostty-theme";
    text = ''
      rex="/Applications/Rex.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"
      if [[ ! -x "$rex" ]]; then
        printf '%s\n' "Rex was not found in /Applications." >&2
        exit 1
      fi

      exec "$rex" --autostart=false do client.theme.import path=${ghosttyTheme}
    '';
  };
in
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) {
    home.packages = [ importGhosttyTheme ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.packages
  }; # https://nix-community.github.io/home-manager/options.xhtml#opt-config
}
