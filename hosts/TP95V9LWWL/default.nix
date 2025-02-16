{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (config.nixpkgs) system;
    config.allowUnfree = true;
    hostPlatform = pkgs.stdenv.hostPlatform;
  };
in
{
  imports = [
    inputs.agenix.darwinModules.age
    # catppuccin.darwinModules.catppuccin # https://github.com/catppuccin/nix/issues/162
    # inputs.home-manager.darwinModules.defaults
    inputs.home-manager.darwinModules.home-manager
    inputs.nixvim.nixDarwinModules.nixvim
    # ../../modules/yabai
  ];

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    allowUnsupportedSystem = false;

    packageOverrides = pkgs: {
      electron_24 = pkgs.electron_26; # Electron v24 is end-of-life, forcing upgrade
      electron_25 = pkgs.electron_26; # Electron v25 is end-of-life, forcing upgrade
    };
    permittedInsecurePackages = [
      # "python3.12-youtube-dl-2021.12.17"
      # "python3.11-youtube-dl-2021.12.17"
      # "olm-3.2.16"
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # The `home-manager` has issues adding applications to `~/Applications` directory.
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    clang
    coreutils
    findutils
    gcc-unwrapped # ERROR: collision between `/nix/store/5h4hlzrbr28l208jjj505lkvfpxy57qb-binutils-wrapper-2.43.1/bin/strings' and `/nix/store/71l8fmranva05h25868slk2jci5ib3aw-gcc-wrapper-13.3.0/bin/strings'
    git
    gnumake
    kitty
    nix
    nixfmt-rfc-style
    terminal-notifier
    unixtools.watch
    vim
  ];

  # fonts.packages = with pkgs; [
  #   recursive
  #   # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];

  environment.shellAliases = {
    show-system = "nix derivation show /run/current-system";
    switch-system = "darwin-rebuild switch --flake .";
    list-generations = "nix-env --list-generations";
  }; # https://daiderd.com/nix-darwin/manual/index.html#opt-environment.shellAliases

  # Neither nixpkgs.system nor any other option in nixpkgs.* is meant
  # to be read by modules and configurations.
  # Use pkgs.stdenv.hostPlatform instead.
  #
  # The option nixpkgs.system is still fully supported for interoperability, but will be deprecated in the future, so we recommend to set nixpkgs.hostPlatform.
  nixpkgs.system = "aarch64-darwin";

  # error: Determinate detected, aborting activation
  # Determinate uses its own daemon to manage the Nix installation that
  # conflicts with nix-darwin’s native Nix management.
  #
  # To turn off nix-darwin’s management of the Nix installation, set:
  #
  #     nix.enable = false;
  #
  # This will allow you to use nix-darwin with Determinate. Some nix-darwin
  # functionality that relies on managing the Nix installation, like the
  # `nix.*` options to adjust Nix settings or configure a Linux builder,
  # will be unavailable.
  nix.enable = true;

  system.stateVersion = 5;
  nix.package = pkgs-unstable.nix; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.package
  nix.optimise.automatic = true; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.optimise.automatic # https://github.com/NixOS/nix/issues/7273#issuecomment-2295429401
  nix.settings.auto-optimise-store = false; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.settings.auto-optimise-store # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
  nix.settings.sandbox = false; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.settings.sandbox

  # The option definition `services.nix-daemon.enable' no longer has any effect; please remove it.
  # nix-darwin now manages nix-daemon unconditionally when `nix.enable` is on.
  # services.nix-daemon.enable = true;

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.extraOptions =
    ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      trusted-users = root leonardlee
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  nix.settings.trusted-users = [
    "@admin"
  ];

  # The option definition `nix.configureBuildUsers' no longer has any effect; please remove it.
  # nix-darwin now manages build users unconditionally when `nix.enable` is on.
  # nix.configureBuildUsers = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    # dates = "Mon..Fri *-*-* 07:00:00"; # https://nixos.wiki/wiki/storage_optimization#automation
    interval = {
      Hour = 12;
      Minute = 15;
      Day = 1;
    }; # https://nixos.wiki/wiki/storage_optimization#automation
    options = "--delete-older-than 7d";
  };

  security.pam.enableSudoTouchIdAuth = true;

  # networking = {
  #   dns = [ "1.1.1.1" ];
  # }; # TODO:  warning: networking.knownNetworkServices is empty, dns servers will not be configured.

  users.users.leonardlee = {
    name = "leonardlee";
    home = "/Users/leonardlee";
  };

  #  `nixpkgs` options are disabled when `home-manager.useGlobalPkgs` is enabled.
  home-manager.useGlobalPkgs = false; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useGlobalPkgs
  home-manager.useUserPackages = true; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  }; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.extraSpecialArgs
  home-manager.users.leonardlee = {
    home.stateVersion = "25.05";
    imports = [
      ../../home-manager/home.nix
      inputs.agenix.homeManagerModules.age
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.nix-index-database.hmModules.nix-index
      inputs.nixvim.homeManagerModules.nixvim
    ];
  }; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.users
  home-manager.verbose = true; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.verbose

  system.defaults = {
    trackpad = {
      ActuationStrength = 1; # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.trackpad.ActuationStrength
      Clicking = true; # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.trackpad.Clicking
    };
    dock = {
      autohide = true;
      autohide-delay = 0.24;
      autohide-time-modifier = 1.0;
      orientation = "bottom";
      show-process-indicators = true;
      show-recents = true;
      static-only = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    # Tab between form controls and F-row that behaves as F1-F12.
    # https://evantravers.com/articles/2024/02/06/switching-to-nix-darwin-and-flakes/
    # NSGlobalDomain = {
    #   AppleKeyboardUIMode = 3;
    #   "com.apple.keyboard.fnState" = true;
    # };
  };

  # https://chattingdarkly.org/@lhf@fosstodon.org/110661879831891580
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
        /run/current-system "$systemConfig"
    '';
  };

  # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
