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
    ./klipper.nix
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

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  nixpkgs.config.allowUnfree = true;

  # Silence the Determinate Nix warning:
  #   Using 'builtins.derivation'/'builtins.toFile' to create ... 'options.json'
  #   that references the store path '<nixpkgs>-source' without a proper context.
  # home-manager's manpages build pulls in the NixOS `meta.maintainers` module,
  # whose "Declared by" declaration hard-codes a context-stripped nixpkgs store
  # path. The warning is benign and only surfaces under Determinate Nix; the
  # accepted workaround is to skip the manpages build (we lose
  # `man home-configuration.nix`).
  # @upstream-issue https://github.com/nix-community/home-manager/issues/7935
  manual.manpages.enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-manual.manpages.enable

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

      # @note generate-uuid is a real command (see scripts.nix), not an alias.
      # A shellAlias whose value is a $(...) command substitution is invalid in
      # nushell, and it is also broken in bash and zsh, because the substitution
      # runs and the shell then tries to execute the resulting UUID as a command.
      reset-dock = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "defaults delete com.apple.dock; killall Dock";
      terraform = "${lib.getExe' pkgs.terraform "terraform"}";
      wttr = "${pkgs.curl}/bin/curl 'wttr.in/Oslo?format=3'"; # TODO: https://www.reddit.com/r/macapps/comments/1gg4k6o/comment/lupspio/
      wttr-all = "${pkgs.curl}/bin/curl 'wttr.in/{Helsfyr,Kuching,Kamakura,Lørenskog,Oslo,Tokyo}?format=3'";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shellAliases
    stateVersion = lib.trivial.release; # Track the nixpkgs release automatically; works on all supported systems. https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  };

  # macOS application installation strategy (Darwin only).
  #
  # For `home.stateVersion >= 25.11` home-manager defaults to
  # `targets.darwin.copyApps`, which rsyncs every `.app` bundle from
  # `home.packages` into `~/Applications/Home Manager Apps` on every
  # activation. Because nix store mtimes are all standardized to the epoch,
  # rsync is forced to run with `--checksum`, re-hashing every byte of every
  # bundle each switch. With several GB of GUI apps this makes the
  # "setting up ~/Applications/Home Manager Apps..." step take many minutes.
  #
  # Instead we use `targets.darwin.linkApps`, which just symlinks the app
  # bundles from the nix store (instant, no copy). A bare symlinked `.app`
  # is not indexed by Spotlight or reliably launchable on modern macOS, so
  # mac-app-util (already enabled via its home-manager module) turns the
  # symlinked directory into Spotlight-friendly trampolines under
  # `~/Applications/Home Manager Trampolines`. mac-app-util's trampoline
  # generator only fires when the source directory is a symlink, so
  # `copyApps` must be disabled for it to run at all.
  # https://github.com/nix-community/home-manager/issues/1341
  targets.darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    copyApps.enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-targets.darwin.copyApps.enable
    linkApps.enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-targets.darwin.linkApps.enable
  };
}
