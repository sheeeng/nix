{ ... }:
{
  programs.diff-so-fancy = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-so-fancy.enable
    pagerOpts = [
      "--tabs=2"
      "--RAW-CONTROL-CHARS" # -R
      "--quit-if-one-screen" # -F
      "--no-init" # -X
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-so-fancy.pagerOpts
    settings = {
      changeHunkIndicators = true;
      markEmptyLines = true;
      rulerWidth = 80;
      stripLeadingSymbols = true;
      useUnicodeRuler = true;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-so-fancy.settings
  };
}
