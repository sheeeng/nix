# TODO: https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/alacritty.nix

{ pkgs, ... }:
{
  programs = {
    alacritty = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.enable
      package = pkgs.alacritty; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.package
      settings = {
        # colors = {
        #   # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
        #   # https://github.com/MatthiasBenaets/nix-config/blob/d14dd9b68805416c527ae998225ce19489d41097/modules/programs/alacritty.nix
        #   font = {
        #     normal.family = "FiraCode Nerd Font";
        #     bold = {
        #       style = "Bold";
        #     };
        #     size = 11;
        #   };
        #   offset = {
        #     x = -1;
        #     y = 0;
        #   };

        #   primary = {
        #     background = "0x002b36";
        #     foreground = "0xEBEBEB";
        #   };

        #   normal = {
        #     black = "0x0d0d0d";
        #     red = "0xFF301B";
        #     green = "0xA0E521";
        #     yellow = "0xFFC620";
        #     blue = "0x1BA6FA";
        #     magenta = "0x8763B8";
        #     cyan = "0x21DEEF";
        #     white = "0xEBEBEB";
        #   };

        #   bright = {
        #     black = "0x6D7070";
        #     red = "0xFF4352";
        #     green = "0xB8E466";
        #     yellow = "0xFFD750";
        #     blue = "0x1BA6FA";
        #     magenta = "0xA578EA";
        #     cyan = "0x73FBF1";
        #     white = "0xFEFEF8";
        #   };
        # };
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.settings
    };
  };
}
