{ ... }:
{
  programs.diff-highlight = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-highlight.enable
    pagerOpts = [
      "--color-moved=dimmed_zebra"
      "--tabs=2"
      "--RAW-CONTROL-CHARS" # -R
      "--quit-if-one-screen" # -F
      "--no-init" # -X
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-highlight.pagerOpts
  };
}
