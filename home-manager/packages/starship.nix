# https://github.com/RMTT/machines/blob/8a1d5a5c62e1e4e6b5e48184bc11960fce56fb24/home/modules/shell.nix
# _: { }

{ lib, pkgs, ... }:
{
  programs.starship = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableFishIntegration
    enableInteractive = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableInteractive
    enableIonIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableIonIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableNushellIntegration
    enableTransience = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableTransience
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableZshIntegration
    package = pkgs.starship; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.package
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$line_break"
        "$package"
        "$line_break"
        "$character"
      ];
      scan_timeout = 10;
      character = {
        # success_symbol = "➜";
        # error_symbol = "➜";
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[<](bold green)";
        vimcmd_replace_one_symbol = "[<](bold purple)";
        vimcmd_replace_symbol = "[<](bold purple)";
        vimcmd_visual_symbol = "[<](bold yellow)";
      };
      package.disabled = false;
      gcloud.disabled = false;
      kubernetes.disabled = false;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.settings
  };
}
