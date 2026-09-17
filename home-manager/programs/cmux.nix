# cmux embeds Ghostty. When no Ghostty configuration file exists, cmux replaces
# the Ghostty built-in palette with its own managed light and dark palette.
# That managed palette uses a beige foreground on a near-black background.
# Set terminal.adaptiveDefaultTheme to false so cmux uses the Ghostty built-in
# palette, which is #282c34 background with a white foreground.
# https://github.com/manaflow-ai/cmux
{ ... }:
{
  xdg.configFile."cmux/cmux.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json";
    schemaVersion = 1;
    terminal.adaptiveDefaultTheme = false;
  }; # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.configFile
}
