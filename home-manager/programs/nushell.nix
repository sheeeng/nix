{ pkgs, ... }:
{
  programs.nushell = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
    package = pkgs.nushell; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.package
    configFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.configFile
    envFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.envFile
    environmentVariables = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.environmentVariables
    extraConfig = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      # https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
      alias nu-open = open
      alias open = ^open
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraConfig
    extraEnv = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraEnv
    extraLogin = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraLogin
    loginFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.loginFile
    shellAliases.atuin-import = "with-env { HISTFILE: ($env.HISTFILE? | default '') } { atuin import auto }"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.shellAliases
  };
}
