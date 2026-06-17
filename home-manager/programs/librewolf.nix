{ pkgs, ... }:
{
  programs.librewolf = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.enable
    enableGnomeExtensions = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.enableGnomeExtensions
    package = pkgs.librewolf; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.package
    # languagePacks = [
    #   "en-US"
    #   "en-GB"
    # ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.languagePacks
    # nativeMessagingHosts = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.nativeMessagingHosts
    # policies = {
    #   # https://mozilla.github.io/policy-templates/
    #   BlockAboutConfig = true;
    #   DefaultDownloadDirectory = "\${home}/Downloads";
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.policies
    # profiles = {
    #   default = {
    #     id = 0;
    #     isDefault = true;
    #     settings = {
    #       "browser.startup.homepage" = "https://nixos.org";
    #     };
    #   };
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.profiles
  };
}
