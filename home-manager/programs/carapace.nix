{ pkgs, ... }:
{
  programs.carapace = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.enableZshIntegration
    package = pkgs.carapace; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.package
    ignoreCase = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.carapace.ignoreCase
  };
}
