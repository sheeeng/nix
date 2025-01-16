{ pkgs, ... }:
let
in
{
  programs = {
    direnv = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
      package = pkgs.direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.package
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableBashIntegration
      # TODO: FIXME
      # The option `home-manager.users.leonardlee.programs.direnv.enableFishIntegration' is read-only, but it's set multiple times. Definition values:
      #  - In `/nix/store/cd0q2vk9vqwjg9rcilymm4x8f4n673zi-source/modules/programs/direnv.nix': true
      #  - In `/nix/store/6x578alp8ypwa5yqj8dws38ndpac3k63-source/home-manager/packages/direnv.nix': true
      # enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableFishIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableNushellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enableZshIntegration
      nix-direnv = {
        enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.enable
        package = pkgs.nix-direnv; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.nix-direnv.package
      };
    };
  };
}
