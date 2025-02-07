# https://github.com/mufaroxyz/dotfiles/blob/249b67c429aa4d25016887d6c337ec5b6d355b46/modules/core/nixvim/plugins.nix

{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    alpha = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/alpha/index.html#pluginsalphaenable
      package = pkgs.vimPlugins.alpha-nvim; # https://nix-community.github.io/nixvim/plugins/alpha/index.html#pluginsalphapackage
      opts = null; # https://nix-community.github.io/nixvim/plugins/alpha/index.html#pluginsalphaopts
      theme = "theta"; # https://nix-community.github.io/nixvim/plugins/alpha/index.html#pluginsalphatheme
      # layout = [
      #   # Set `plugins.alpha.theme = null` if you want to configure alpha manually using the `layout` option.
      #   {
      #   }
      # ]; # https://nix-community.github.io/nixvim/plugins/alpha/layout.html#pluginsalphalayout
    }; # https://nix-community.github.io/nixvim/plugins/alpha/index.html
  };
}
