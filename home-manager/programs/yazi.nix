{ pkgs, ... }:
{
  programs.yazi = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enableZshIntegration
    package = pkgs.yazi; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.package
    extraPackages = with pkgs; [
      glow # https://search.nixos.org/packages?channel=unstable&type=packages&show=glow
      ouch # https://search.nixos.org/packages?channel=unstable&type=packages&show=ouch
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.extraPackages
    flavors = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.flavors
    # initLua = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.initLua
    keymap = {
      input.prepend_keymap = [
        {
          run = "close";
          on = [ "<C-q>" ];
        }
        {
          run = "close --submit";
          on = [ "<Enter>" ];
        }
        {
          run = "escape";
          on = [ "<Esc>" ];
        }
        {
          run = "backspace";
          on = [ "<Backspace>" ];
        }
      ];
      mgr.prepend_keymap = [
        {
          run = "escape";
          on = [ "<Esc>" ];
        }
        {
          run = "quit";
          on = [ "q" ];
        }
        {
          run = "close";
          on = [ "<C-q>" ];
        }
      ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.keymap
    plugins = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.plugins
    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = false;
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.settings
    shellWrapperName = "yy"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.shellWrapperName
    theme = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.theme
  };
}
