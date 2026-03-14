{ lib, pkgs, ... }:
{
  programs.nushell = {
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/485915
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
    package = pkgs.nushell; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.package
    configFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.configFile
    envFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.envFile
    environmentVariables = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.environmentVariables
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraConfig
    extraEnv = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraEnv
    extraLogin = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraLogin
    loginFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.loginFile
    shellAliases = {
      la = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"} --all";
      ll = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"} --long";
      lla = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"} --long --all";
      ls = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"}";
      lt = "${lib.getExe pkgs.eza} --tree";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.shellAliases
  };
}
