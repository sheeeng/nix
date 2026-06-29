{ pkgs, ... }:
{
  programs.mise = {
    enable = false; # @upstream-issue https://github.com/jdx/mise/discussions/10617 # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enableFishIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enableNushellIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enableZshIntegration
    package = pkgs.mise; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.package
    globalConfig = {
      # See https://mise.jdx.dev/configuration.html and https://mise.jdx.dev/configuration/settings.html for details on supported values.
      settings = {
        disable_tools = [ ]; # https://mise.jdx.dev/configuration/settings.html#disable_tools
        experimental = true; # https://mise.jdx.dev/configuration/settings.html#experimental
        gpg_verify = true; # https://mise.jdx.dev/configuration/settings.html#gpg_verify
        minimum_release_age = "14d"; # https://mise.jdx.dev/configuration/settings.html#minimum_release_age
        slsa = true; # https://mise.jdx.dev/configuration/settings.html#slsa
        status = {
          show_env = true; # https://mise.jdx.dev/configuration/settings.html#status.show_env
          show_tools = true; # https://mise.jdx.dev/configuration/settings.html#status.show_tools
        }; # https://mise.jdx.dev/configuration/settings.html#status
        verbose = false; # https://mise.jdx.dev/configuration/settings.html#verbose
      };
      tools = {
        node = "lts";
        python = [
          "lts"
          "3.14"
        ];
        trivy = {
          version = "latest";
          minimum_release_age = "7d";
        };
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.globalConfig
  };
}
