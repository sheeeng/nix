{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    web-devicons = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/web-devicons/index.html#pluginsweb-deviconsenable
    }; # https://nix-community.github.io/nixvim/plugins/web-devicons/index.html

    which-key = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/which-key/index.html#pluginswhich-keyenable
      package = pkgs.vimPlugins.which-key-nvim; # https://nix-community.github.io/nixvim/plugins/which-key/index.html#pluginswhich-keypackage
      settings = {
        "<leader>fg" = "Find Git files with telescope";
        "<leader>fw" = "Find text with telescope";
        "<leader>ff" = "Find files with telescope";
      };
    };
  };
}
