# https://github.com/placek/home.nix/blob/857130de15d1db73da55aa4e36dd0134b3016098/modules/gui/feh.nix

{ pkgs, ... }:
{
  config = {
    programs.feh = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.feh.enable
      package = pkgs.feh; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.feh.package

      buttons = {
        # https://man.finalrewind.org/1/feh/#BUTTONS
        reload = null;
        pan = 1;
        zoom = 2;
        toggle_menu = 3;
        next_img = 4;
        prev_img = 5;
        blur = "C-1";
        rotate = "C-2";
        zoom_in = null;
        zoom_out = null;
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.feh.buttons

      keybindings = {
        # https://man.finalrewind.org/1/feh/#KEYS
        zoom_in = "plus";
        zoom_out = "minus";
        zoom_default = "*";
        zoom_fit = "/";
        zoom_fill = "!";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.feh.keybindings

      # TODO: error: A definition for option `programs.feh.themes' is not of type `attribute set of list of string'.
      # themes = [
      #   # https://man.finalrewind.org/1/feh/#THEMES_CONFIG_SYNTAX
      #   {
      #     booth = [
      #       "--full-screen"
      #       "--hide-pointer"
      #       "--slideshow-delay"
      #       "20"
      #     ];
      #     example = [
      #       "--info"
      #       "foo bar"
      #     ];
      #     feh = [
      #       "--image-bg"
      #       "black"
      #     ];
      #     imagemap = [
      #       "-rVq"
      #       "--thumb-width"
      #       "40"
      #       "--thumb-height"
      #       "30"
      #       "--index-info"
      #       "%n\\n%wx%h"
      #     ];
      #     present = [
      #       "--full-screen"
      #       "--sort"
      #       "name"
      #       "--hide-pointer"
      #     ];
      #     webcam = [
      #       "--multiwindow"
      #       "--reload"
      #       "20"
      #     ];
      #   }
      # ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.feh.themes
    };
  };
}

# next_img l space Right
# prev_img h Left
# quit q
# jump_first 0
# jump_last dollar
# jump_fwd L
# jump_back H
# delete x Delete
# scroll_left C-h C-Left
# scroll_right C-l C-Right
# scroll_up C-k C-Up
# scroll_down C-j C-Down
# zoom_in plus
# zoom_out minus
