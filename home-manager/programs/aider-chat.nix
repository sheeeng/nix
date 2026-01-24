{ pkgs, ... }:
{
  programs.aider-chat = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aider-chat.enable
    package = pkgs.aider-chat; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aider-chat.package
    settings = {
      architect = false;
      auto-accept-architect = true;
      cache-prompts = false;
      lint = true;
      show-model-warnings = true;
      verify-ssl = true;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aider-chat.settings
  };
}
