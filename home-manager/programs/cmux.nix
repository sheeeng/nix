# https://github.com/manaflow-ai/cmux
{ ... }:
{
  xdg.configFile."cmux/cmux.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json";
    schemaVersion = 1;
    terminal.adaptiveDefaultTheme = false;
  }; # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.configFile

  # cmux reads this file for Ghostty-compatible font and color settings.
  xdg.configFile."ghostty/config".text = ''
    background = #282c34
    font-family = JetBrains Mono
    font-size = 13
    foreground = #ffffff
    palette = 0=#1d1f21
    palette = 1=#cc6666
    palette = 2=#b5bd68
    palette = 3=#f0c674
    palette = 4=#81a2be
    palette = 5=#b294bb
    palette = 6=#8abeb7
    palette = 7=#c5c8c6
    palette = 8=#666666
    palette = 9=#d54e53
    palette = 10=#b9ca4a
    palette = 11=#e7c547
    palette = 12=#7aa6da
    palette = 13=#c397d8
    palette = 14=#70c0b1
    palette = 15=#eaeaea
  ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.configFile
}
