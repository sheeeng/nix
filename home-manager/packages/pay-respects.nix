{ pkgs, ... }:
let
in
{
  programs = {
    pay-respects = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.enable
      package = pkgs.pay-respects; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.package
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.enableFishIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.enableNushellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.enableZshIntegration
      options = [
        "--alias"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.options
    };
  };
}
