# https://github.com/mufaroxyz/dotfiles/blob/249b67c429aa4d25016887d6c337ec5b6d355b46/modules/core/nixvim/plugins.nix

{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # aerial.enable = false; # https://nix-community.github.io/nixvim/plugins/aerial/index.html#pluginsaerialenable
    airline.enable = false; # https://nix-community.github.io/nixvim/plugins/airline/index.html#pluginsairlineenable
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
    arrow.enable = false; # https://nix-community.github.io/nixvim/plugins/arrow/index.html#pluginsarrowenable
    auto-save.enable = false; # https://nix-community.github.io/nixvim/plugins/auto-save/index.html#pluginsautosaveenable
    auto-session.enable = false; # https://nix-community.github.io/nixvim/plugins/auto-session/index.html#pluginsautosessionenable
    autoclose.enable = false; # https://nix-community.github.io/nixvim/plugins/autoclose/index.html#pluginsautocloseenable
    autosource.enable = false; # https://nix-community.github.io/nixvim/plugins/autosource/index.html#pluginsautosourceenable
    avante.enable = false; # https://nix-community.github.io/nixvim/plugins/avante/index.html#pluginsavanteenable
  };
}
