{
  lib,
  pkgs,
  ...
}:
let
  folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
  # Filter out files that are package derivations, not modules
  packageModuleFiles =
    dir:
    let
      excludedFiles = [ "download-nixos-iso.nix" ];
      allFiles = builtins.attrNames (builtins.readDir dir);
      filteredFiles = builtins.filter (fname: !(builtins.elem fname excludedFiles)) allFiles;
    in
    map (fname: dir + "/${fname}") filteredFiles;
in
{
  imports = [
    ./development.nix
    ./fonts.nix
    ./packages.nix
    ./programs.nix
    ./scripts.nix
    ./sops.nix
    ./theme.nix
  ]
  ++ (packageModuleFiles ./packages)
  ++ (folderFiles ./programs);
  # https://github.com/alexnabokikh/nix-config/blob/bddec40e097d4227cd95badfc02164aa006a8a4c/modules/home-manager/common/default.nix

  fonts.fontconfig = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.enable
    antialiasing = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.antialiasing
    configFile = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.configFile
    defaultFonts = {
      emoji = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.emoji
      monospace = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.monospace
      sansSerif = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.sansSerif
      serif = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.serif
    };
    hinting = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.defaultFonts.hinting
    subpixelRendering = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-fonts.fontconfig.subpixelRendering
  };

  # home.stateVersion = "25.11"; # Please read the comment before changing.

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  nixpkgs.config.allowUnfree = true;

  home = {
    file = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
    shell = {
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableFishIntegration
      enableIonIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableIonIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableNushellIntegration
      enableShellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableShellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableZshIntegration
    };
    shellAliases = {
      ez = "${lib.getExe pkgs.eza}";
      ezl = "${lib.getExe pkgs.eza} --long";
      ezla = "${lib.getExe pkgs.eza} --long --all";
      ezt = "${lib.getExe pkgs.eza} --tree";
      la = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"} --all";
      ll = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"} --long";
      lla = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"} --long --all";
      ls = "${lib.getExe' pkgs.uutils-coreutils-noprefix "ls"}";
      rm = "${lib.getExe' pkgs.uutils-coreutils-noprefix "rm"} --interactive";
      # @note The sudo function lives in programs/zsh/init-content.nix to avoid
      # alias chain-expansion with noglob aliases.
      suspend = if pkgs.stdenv.hostPlatform.isDarwin then "pmset sleepnow" else "systemctl suspend";
      z = "zoxide";

      generate-uuid = "$(${lib.getExe' pkgs.util-linux "uuidgen"} | tr -d \\n)";
      reset-dock = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "defaults delete com.apple.dock; killall Dock";
      terraform = "${lib.getExe' pkgs.opentofu "tofu"}"; # Map terraform to the OpenTofu tofu binary for command compatibility.
      wttr = "${pkgs.curl}/bin/curl 'wttr.in/Oslo?format=3'"; # TODO: https://www.reddit.com/r/macapps/comments/1gg4k6o/comment/lupspio/
      wttr-all = "${pkgs.curl}/bin/curl 'wttr.in/{Helsfyr,Kuching,Kamakura,Lørenskog,Oslo,Tokyo}?format=3'";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shellAliases
    stateVersion = "25.11"; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  };
}
