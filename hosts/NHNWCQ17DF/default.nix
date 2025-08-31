{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs {
    inherit (config.nixpkgs) system;
    config.allowUnfree = true;
    inherit (pkgs.stdenv) hostPlatform;
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
    clang # https://search.nixos.org/packages?channel=unstable&type=packages&show=clang
    coreutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=coreutils
    findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
    # gcc-unwrapped # ERROR: collision between `/nix/store/5h4hlzrbr28l208jjj505lkvfpxy57qb-binutils-wrapper-2.43.1/bin/strings' and `/nix/store/71l8fmranva05h25868slk2jci5ib3aw-gcc-wrapper-13.3.0/bin/strings'
    # gcc-unwrapped # ERROR: collision between `/nix/store/6rhh54a3df1mzw3pqv6mx9vcvrmwvja7-binutils-wrapper-2.44/bin/strings' and `/nix/store/d49w1nr8r3v0pm07hylwgybwqikiwd2y-gcc-wrapper-14.2.1.20250322/bin/strings'
    git # https://search.nixos.org/packages?channel=unstable&type=packages&show=git
    gnumake # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnumake
    inputs.flox.packages.${pkgs.system}.default
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
    nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
    nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
    nixfmt-rfc-style # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-rfc-style
    shfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=shfmt
    terminal-notifier # https://search.nixos.org/packages?channel=unstable&type=packages&show=terminal-notifier
    unixtools.watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=unixtools.watch
    vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
    # libreoffice-qt # https://search.nixos.org/packages?channel=unstable&type=packages&show=libreoffice-qt
    hunspell # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspell
    hunspellDicts.nb-no # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspellDicts.nb-no
    hunspellDicts.nn-no # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspellDicts.nn-no
    hunspellDicts.en-gb-large # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspellDicts.en-gb-large
    hunspellDicts.en-gb-ize # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspellDicts.en-gb-ize
    hunspellDicts.en-us-large # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspellDicts.en-us-large
    hunspellDicts.en-us # https://search.nixos.org/packages?channel=unstable&type=packages&show=hunspellDicts.en-us
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
  # conflicts with nix-darwin's native Nix management.
  #
  # To turn off nix-darwin's management of the Nix installation, set:
  #
  #     nix.enable = false;
  #
  # This will allow you to use nix-darwin with Determinate. Some nix-darwin
  # functionality that relies on managing the Nix installation, like the
  # `nix.*` options to adjust Nix settings or configure a Linux builder,
  # will be unavailable.

  system.stateVersion = 5;
  system.primaryUser = "llee"; # Added to specify the primary user for system.defaults

  nix = {
    enable = true;
    package = pkgs-unstable.nix; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.package
    optimise.automatic = true; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.optimise.automatic # https://github.com/NixOS/nix/issues/7273#issuecomment-2295429401
    settings = {
      auto-optimise-store = false; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.settings.auto-optimise-store # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      sandbox = false; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.settings.sandbox
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      extra-substituters = [
        "https://devenv.cachix.org"
        "https://ryanccn.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
      ];
      trusted-users = [
        "root"
        "llee"
        "@admin"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-platforms = lib.optionals (pkgs.system == "aarch64-darwin") [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
    gc = {
      automatic = true;
      # dates = "Mon..Fri *-*-* 07:00:00"; # https://nixos.wiki/wiki/storage_optimization#automation
      interval = {
        Day = 1;
        Hour = 12;
        Minute = 15;
      }; # https://nixos.wiki/wiki/storage_optimization#automation
      options = "--delete-older-than 7d";
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # networking = {
  #   dns = [ "1.1.1.1" ];
  # }; # TODO:  warning: networking.knownNetworkServices is empty, dns servers will not be configured.

  users.users.llee = {
    name = "llee";
    home = "/Users/llee";
  }; # https://daiderd.com/nix-darwin/manual/index.html#opt-users.users

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  home-manager.useGlobalPkgs = false;

  home-manager.useUserPackages = true; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  }; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.extraSpecialArgs

  home-manager.sharedModules = [
    inputs.mac-app-util.homeManagerModules.default
  ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.sharedModules

  home-manager.users.llee = {
    home.stateVersion = "25.11";
    imports = [
      ../../home-manager/home.nix
      inputs.agenix.homeManagerModules.age
      inputs.catppuccin.homeModules.catppuccin
      inputs.nix-index-database.homeModules.nix-index
      inputs.nixvim.homeModules.nixvim
    ];
  }; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.users
  home-manager.verbose = false; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.verbose

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
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
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
    text = '''';
    # text = ''
    #   ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
    #     /run/current-system "$systemConfig"
    # '';
  };

  # This script runs after nix-darwin applies system-wide configurations.
  # It ensures that macOS user-specific preferences (like dock, finder settings)
  # are activated for the primary user.
  # Since activation scripts run as root, 'sudo -u llee' is used.
  system.activationScripts.applyUserDefaults = {
    supportsDryActivation = true;
    text = ''
      echo "Applying macOS user defaults for user llee..."
      sudo -u llee /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  # The following block should be removed as system.activationScripts.postUserActivation is obsolete
  # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
  # system.activationScripts.postUserActivation.text = ''
  #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  # '';
}
