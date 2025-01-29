{ ... }:
{
  programs.nixvim.plugins = {
    gitsigns = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/gitsigns/index.html#pluginsgitsignsenable
    }; # https://nix-community.github.io/nixvim/plugins/gitsigns/index.html
  };
}
