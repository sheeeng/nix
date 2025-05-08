{ ... }:
{
  programs.nixvim.plugins = {
    telescope = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/telescope/index.html#pluginstelescopeenable
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
    }; # https://nix-community.github.io/nixvim/plugins/telescope/index.html

    toggleterm = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/toggleterm/index.html#pluginstoggletermenable
      settings = {
        hide_numbers = false;
        autochdir = true;
        close_on_exit = true;
        direction = "vertical";
      };
    };

    treesitter.enable = true;
    ts-autotag.enable = true;
  };
}
