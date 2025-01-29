{ ... }:
{
  programs.nixvim.plugins = {
    undotree = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/undotree.html#pluginsundotreeenable
      settings = {
        autoOpenDiff = true;
        focusOnToggle = true;
      };
    };
  };
}
