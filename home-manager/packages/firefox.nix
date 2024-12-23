{ pkgs, ... }:
{
  config = {
    programs.firefox = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable
      enableGnomeExtensions = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enableGnomeExtensions
      package = pkgs.firefox; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.package
      # # finalPackage = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.finalPackage
      # languagePacks = [
      #   "en-US"
      #   "en-GB"
      # ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.languagePacks
      # nativeMessagingHosts = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.nativeMessagingHosts
      # policies = {
      #   # https://mozilla.github.io/policy-templates/
      #   BlockAboutConfig = true;
      #   DefaultDownloadDirectory = "\${home}/Downloads";
      # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.policies
      # profiles = {
      #   default = {
      #     id = 0;
      #   };
      #   defaultFox = {
      #     # enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles.default.enable
      #     # name = "defaultFox"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles.default.name
      #     bookmarks = [
      #       {
      #         name = "wikipedia";
      #         tags = [ "wiki" ];
      #         keyword = "wiki";
      #         url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
      #       }
      #       {
      #         name = "kernel.org";
      #         url = "https://www.kernel.org";
      #       }
      #       {
      #         name = "Nix";
      #         toolbar = true;
      #         bookmarks = [
      #           {
      #             name = "homepage";
      #             url = "https://nixos.org/";
      #           }
      #           {
      #             name = "wiki";
      #             tags = [
      #               "wiki"
      #               "nix"
      #             ];
      #             url = "https://wiki.nixos.org/";
      #           }
      #         ];
      #       }
      #     ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles.default.bookmarks
      #     containers = {
      #       dangerous = {
      #         color = "red"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.color
      #         icon = "fruit"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.icon
      #         id = 2; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.id
      #         name = "dangerous"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.name
      #       };
      #       shopping = {
      #         color = "blue"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.color
      #         icon = "cart"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.icon
      #         id = 1; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.id
      #         name = "shopping"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.containers._name_.name
      #       };
      #     };
      #     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #       privacy-badger
      #       ublock-origin
      #       violentmonkey
      #     ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions
      #     extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extraConfig
      #     id = 42; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.id
      #     isDefault = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.isDefault
      #     name = "defaultFox"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.name
      #     path = "\${config.home}/.mozilla/firefox/defaultFox"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.path
      #     search = {
      #       engines = [
      #         {
      #           name = "DuckDuckGo";
      #           url = "https://duckduckgo.com/?q=%s";
      #         }
      #         {
      #           name = "Google";
      #           url = "https://www.google.com/search?q=%s";
      #         }
      #       ];
      #       default = "DuckDuckGo"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.search.default
      #     }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.search
      #   };
      # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles
    };
  };
}
