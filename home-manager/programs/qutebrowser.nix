{ pkgs, ... }:
{
  programs.qutebrowser = {
    # Keep the browser disabled until the pinned package has no known vulnerabilities.
    enable =
      pkgs.stdenv.hostPlatform.isLinux && (pkgs.qutebrowser.meta.knownVulnerabilities or [ ]) == [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.enable
    enableDefaultBindings = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.enableDefaultBindings
    package = pkgs.qutebrowser; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.package
    # aliases = {
    #   "q" = "quit";
    #   "w" = "session-save";
    #   "wq" = "quit --save";
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.aliases
    # searchEngines = {
    #   "DEFAULT" = "https://duckduckgo.com/?q={}";
    #   "g" = "https://www.google.com/search?q={}";
    #   "gh" = "https://github.com/search?q={}";
    #   "nix" = "https://search.nixos.org/packages?channel=unstable&query={}";
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.searchEngines
    # settings = {
    #   colors.webpage.darkmode.enabled = true;
    #   content.autoplay = false;
    #   fonts.default_family = "monospace";
    #   fonts.default_size = "12pt";
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.settings
    # keyBindings = {
    #   normal = {
    #     "<Ctrl-v>" = "spawn mpv {url}";
    #     ",p" = "spawn --userscript qute-bitwarden";
    #   };
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.keyBindings
    # quickmarks = {
    #   nixpkgs = "https://github.com/NixOS/nixpkgs";
    #   home-manager = "https://github.com/nix-community/home-manager";
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.qutebrowser.quickmarks
  };
}
