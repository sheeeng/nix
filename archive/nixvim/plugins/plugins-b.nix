{ ... }:
{
  programs.nixvim.plugins = {
    bufferline = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/bufferline/index.html#pluginsbufferlineenable
    }; # https://nix-community.github.io/nixvim/plugins/bufferline/index.html
  };
}
