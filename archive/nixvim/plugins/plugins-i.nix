{ ... }:
{
  programs.nixvim.plugins = {
    illuminate = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/illuminate/index.html#pluginsilluminateenable
      underCursor = false;
      filetypesDenylist = [
        "Outline"
        "TelescopePrompt"
        "alpha"
        "harpoon"
        "reason"
      ];
    };
  };
}
