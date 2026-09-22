{ pkgs, ... }:
{
  programs.mistral-vibe = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mistral-vibe.enable
    package = pkgs.mistral-vibe; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mistral-vibe.package
    settings = {
      active_model = "devstral-latest";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mistral-vibe.settings
  };
}
