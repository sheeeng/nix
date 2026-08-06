{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  hostConfiguration = rec {
    # keep-sorted start block=yes newline_separated=no sticky_comments=no
    networking = {
      hostName = "TP95V9LWWL"; # https://nix-darwin.github.io/nix-darwin/manual/#opt-networking.hostName
    };
    nixpkgs = {
      config = {
        allowUnfree = true; # https://nixos.org/manual/nixpkgs/unstable/#sec-allow-unfree
      }; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.config
      buildPlatform = systemPlatform; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.buildPlatform
      hostPlatform = systemPlatform; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.hostPlatform
    };
    primaryUser = user.name; # https://nix-darwin.github.io/nix-darwin/manual/#opt-system.primaryUser
    systemPlatform = "aarch64-darwin"; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.system
    user = {
      guid = 20; # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users._name_.gid
      name = "leonardlee"; # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users._name_.name
      uid = 501; # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users._name_.uid
    };
    # keep-sorted end
  };

  pkgs-unstable = inputs.nixpkgs.legacyPackages.${hostConfiguration.systemPlatform};
in
{
  imports = [
    # ../../modules/yabai
    # catppuccin.darwinModules.catppuccin # TODO: https://github.com/catppuccin/nix/issues/162
    # inputs.home-manager.darwinModules.defaults
    ../darwin
    inputs.agenix.darwinModules.age
    inputs.home-manager.darwinModules.home-manager
    inputs.nixvim.nixDarwinModules.nixvim
  ];

  documentation = {
    enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.enable
    doc.enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.doc.enable
    info.enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.info.enable
    man.enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.man.enable
  };

  environment = {
    systemPackages = with pkgs; [
      # List packages installed in system profile.
      # To search by name, run:
      # $ nix-env --query --available --prebuilt-only | grep wget # nix.channel.enable = true; # TODO: Use traditional channels.
      # $ nix search nixpkgs wget
      # TODO: https://github.com/nix-community/home-manager/issues/1341 # The `home-manager` has issues adding applications to `~/Applications` directory.
      # keep-sorted start block=yes newline_separated=no
      clang # https://search.nixos.org/packages?channel=unstable&type=packages&show=clang
      # dix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dix
      # inputs.flox.packages.${pkgs.system}.default
      tmux # https://search.nixos.org/packages?channel=unstable&type=packages&show=tmux
      unixtools.watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=unixtools.watch
      vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
      # keep-sorted end
    ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-environment.systemPackages
    shellAliases = {
      show-system = "nix derivation show /run/current-system";
      list-generations = "nix-env --list-generations";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      switch-system = "darwin-rebuild switch --flake .";
      setVolume5 = "osascript -e 'set volume output volume 5' -e 'get volume settings'";
      setVolume10 = "osascript -e 'set volume output volume 10' -e 'get volume settings'";
      setVolume25 = "osascript -e 'set volume output volume 25' -e 'get volume settings'";
      setVolume50 = "osascript -e 'set volume output volume 50' -e 'get volume settings'";
      setVolume75 = "osascript -e 'set volume output volume 75' -e 'get volume settings'";
      setVolumeMax = "osascript -e 'set volume output volume 100' -e 'get volume settings'";
      isMuted = "osascript -e 'output muted of (get volume settings)'";
      muted = "osascript -e 'set volume with output muted'";
      unmute = "osascript -e 'set volume without output muted'";
      setVolume035 = "osascript -e 'set volume 0.35' -e 'get volume settings'";
      setVolume070 = "osascript -e 'set volume 0.70' -e 'get volume settings'";
      setVolume175 = "osascript -e 'set volume 1.75' -e 'get volume settings'";
      setVolume350 = "osascript -e 'set volume 3.50' -e 'get volume settings'";
      setVolume525 = "osascript -e 'set volume 5.25' -e 'get volume settings'";
      setVolume700 = "osascript -e 'set volume 7.00' -e 'get volume settings'";
    }; # https://nix-darwin.github.io/nix-darwin/manual/#opt-environment.shellAliases
    variables = {
      EDITOR = "hx";
      LANG = "en_US.UTF-8";
      SSH_AUTH_SOCK = "$HOME/.gnupg/S.gpg-agent.ssh"; # https://github.com/Vinzent03/obsidian-git/issues/959#issuecomment-3458757190
      # https://github.com/NixOS/nixpkgs/issues/176081#issuecomment-1145825623
      FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
    }; # https://nix-darwin.github.io/nix-darwin/manual/#opt-environment.variables
  };

  fonts.packages =
    with pkgs;
    [
      # keep-sorted start block=no newline_separated=no
      noto-fonts # https://search.nixos.org/packages?channel=unstable&query=noto-fonts
      noto-fonts-cjk-sans # https://search.nixos.org/packages?channel=unstable&query=noto-fonts-cjk-sans
      noto-fonts-cjk-serif # https://search.nixos.org/packages?channel=unstable&query=noto-fonts-cjk-serif
      vt323 # https://search.nixos.org/packages?channel=unstable&query=vt323
      # keep-sorted end
    ]
    ++ (with nerd-fonts; [
      # keep-sorted start block=no newline_separated=no
      dejavu-sans-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.dejavu-sans-mono
      droid-sans-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.droid-sans-mono
      fantasque-sans-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.fantasque-sans-mono
      fira-code # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.fira-code
      fira-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.fira-mono
      geist-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.geist-mono
      go-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.go-mono
      gohufont # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.gohufont
      hack # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.hack
      inconsolata # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.inconsolata
      intone-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.intone-mono
      iosevka # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.iosevka
      iosevka-term # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.iosevka-term
      iosevka-term-slab # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.iosevka-term-slab
      jetbrains-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.jetbrains-mono
      lekton # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.lekton
      liberation # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.liberation
      lilex # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.lilex
      martian-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.martian-mono
      meslo-lg # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.meslo-lg
      monaspace # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.monaspace
      monofur # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.monofur
      monoid # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.monoid
      mononoki # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.mononoki
      noto # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.noto
      recursive-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.recursive-mono
      roboto-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.roboto-mono
      symbols-only # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.symbols-only
      ubuntu # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.ubuntu
      ubuntu-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.ubuntu-mono
      ubuntu-sans # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.ubuntu-sans
      victor-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.victor-mono
      zed-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.zed-mono
      # keep-sorted end
    ]); # https://nix-darwin.github.io/nix-darwin/manual/#opt-fonts.packages

  # Neither nixpkgs.system nor any other option in nixpkgs.* is meant
  # to be read by modules and configurations.
  # Use pkgs.stdenv.hostPlatform instead.
  #
  # error: Neither nixpkgs.hostPlatform nor the legacy option nixpkgs.system has been set.
  # The option nixpkgs.system is still fully supported for interoperability,
  # but will be deprecated in the future, so we recommend to set nixpkgs.hostPlatform.
  #
  # The option nixpkgs.system is still fully supported for interoperability, but will be deprecated in the future, so we recommend to set nixpkgs.hostPlatform.
  # nixpkgs.system = system;

  networking = {
    inherit (hostConfiguration.networking) hostName; # https://nix-darwin.github.io/nix-darwin/manual/#opt-networking.hostName
  };

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
  nix = {
    enable = false; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.enable
    package = pkgs-unstable.nix; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.package
    channel.enable = false; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.channel.enable # TODO: https://github.com/NixOS/nix/issues/2982#issuecomment-2477618346
    optimise.automatic = false; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.optimise.automatic # TODO: https://github.com/NixOS/nix/issues/7273#issuecomment-2295429401
    settings = {
      # `nix.settings.auto-optimise-store` is known to corrupt the Nix Store, please use `nix.optimise.automatic` instead.
      auto-optimise-store = false; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.auto-optimise-store # TODO: https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      cores = 0; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.cores
      extra-sandbox-paths = [ ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.extra-sandbox-paths
      max-jobs = "auto"; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.max-jobs
      require-sigs = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.require-sigs
      sandbox = false; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.sandbox
      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "https://ryanccn.cachix.org"
      ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.substituters
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
      ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.trusted-public-keys
      trusted-substituters = [ "https://hydra.nixos.org/" ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.trusted-substituters
      trusted-users = [
        "root"
        hostConfiguration.primaryUser
        "@admin"
      ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.trusted-users
    }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-nix.settings
    gc = {
      # TODO: nix.gc.automatic requires nix.enable
      automatic = false; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-nix.gc.automatic
      interval = {
        Day = 1;
        Hour = 12;
        Minute = 15;
      }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-nix.gc.interval
      options = "--delete-older-than 7d"; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-nix.gc.options
    };
    extraOptions = ''
      !include ${config.sops.templates.nix-access-token.path}
      experimental-features = nix-command flakes
      keep-derivations = true
      keep-outputs = true
    ''; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-nix.extraOptions
  };

  nixpkgs = {
    inherit (hostConfiguration.nixpkgs) buildPlatform; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.buildPlatform
    inherit (hostConfiguration.nixpkgs) hostPlatform; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.hostPlatform
    config = {
      enableParallelBuildingByDefault = false; # https://nixos.org/manual/nixpkgs/unstable/#opt-enableParallelBuildingByDefault
      showAliases = true; # https://nixos.org/manual/nixpkgs/unstable/#opt-allowAliases
      allowBroken = false; # https://nixos.org/manual/nixpkgs/unstable/#opt-allowBroken
      allowUnfree = true; # https://nixos.org/manual/nixpkgs/unstable/#opt-allowUnfree
      allowUnsupportedSystem = false; # https://nixos.org/manual/nixpkgs/unstable/#opt-allowUnsupportedSystem

      # NOTE: nodejs packageOverrides removed - it causes cache misses for large packages
      permittedInsecurePackages = [
        # "python3.12-youtube-dl-2021.12.17"
        # "python3.11-youtube-dl-2021.12.17"
        # "olm-3.2.16"
      ]; # https://nixos.org/manual/nixpkgs/unstable/#sec-allow-insecure
    }; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.config
    flake = {
      setFlakeRegistry = config.nix.enable && config.nixpkgs.flake.source != null; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.flake.setFlakeRegistry
      # setNixPath = config.nix.enable && config.nixpkgs.flake.source != null; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.flake.setNixPath
      # source = null; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.flake.source
    };
  };

  launchd.daemons.limit-maxfiles = {
    serviceConfig = {
      Label = "limit.maxfiles";
      ProgramArguments = [
        "launchctl"
        "limit"
        "maxfiles"
        "1024"
        "1024"
      ];
      RunAtLoad = true;
    };
  };

  system.stateVersion = 5; # nix-darwin uses an integer here; keep it pinned to the initial install. https://nix-darwin.github.io/nix-darwin/manual/#opt-system.stateVersion

  # The option definition `services.nix-daemon.enable' no longer has any effect; please remove it.
  # nix-darwin now manages nix-daemon unconditionally when `nix.enable` is on.
  # services.nix-daemon.enable = true;

  # The option definition `nix.configureBuildUsers' no longer has any effect; please remove it.
  # nix-darwin now manages build users unconditionally when `nix.enable` is on.
  # nix.configureBuildUsers = true;

  security.pam.services.sudo_local.touchIdAuth = true; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-security.pam.services.sudo_local.touchIdAuth

  users.users = {
    "${hostConfiguration.user.name}" = {
      packages = [ ]; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.packages
      createHome = false; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.createHome
      inherit (hostConfiguration.user) gid; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.gid
      home = "/Users/${hostConfiguration.user.name}"; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.home
      ignoreShellProgramCheck = false; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.ignoreShellProgramCheck
      isHidden = false; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.isHidden
      inherit (hostConfiguration.user) name; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.name
      openssh = {
        authorizedKeys = {
          keyFiles = [ ]; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.openssh.authorizedKeys.keyFiles
          keys = [ ]; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.openssh.authorizedKeys.keys
        };
      };
      shell = null; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.shell
      inherit (hostConfiguration.user) uid; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users._name_.uid
    };
  }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-users.users

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
    # Apply overlays to home-manager's pkgs. It is required when useGlobalPkgs = false.
    {
      nixpkgs.overlays = [
        (import ../../overlays { inherit inputs; }).additions
        (import ../../overlays { inherit inputs; }).modifications
      ];
    }
  ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.sharedModules

  home-manager.users = {
    "${hostConfiguration.primaryUser}" = {
      imports = [
        ../../home-manager/home.nix
        inputs.agenix.homeManagerModules.age
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
        inputs.nixvim.homeModules.nixvim
      ];
    };
  }; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.users
  home-manager.verbose = false; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.verbose

  system.primaryUser = hostConfiguration.primaryUser; # https://nix-darwin.github.io/nix-darwin/manual/#opt-system.primaryUser
  # Failed assertions:
  # - The `system.activationScripts.postUserActivation` option has
  # been removed, as all activation now takes place as `root`. Please
  # restructure your custom activation scripts appropriately,
  # potentially using `sudo` if you need to run commands as a user.
  #
  # - Previously, some nix-darwin options applied to the user running
  # `darwin-rebuild`. As part of a long‐term migration to make
  # nix-darwin focus on system‐wide activation and support first‐class
  # multi‐user setups, all system activation now runs as `root`, and
  # these options instead apply to the `system.primaryUser` user.
  #
  # You currently have the following primary‐user‐requiring options set:
  #
  # * `system.defaults.dock.autohide`
  # * `system.defaults.dock.autohide-delay`
  # * `system.defaults.dock.autohide-time-modifier`
  # * `system.defaults.dock.orientation`
  # * `system.defaults.dock.show-process-indicators`
  # * `system.defaults.dock.show-recents`
  # * `system.defaults.dock.static-only`
  # * `system.defaults.finder.AppleShowAllExtensions`
  # * `system.defaults.finder.FXEnableExtensionChangeWarning`
  # * `system.defaults.finder.ShowPathbar`
  # * `system.defaults.trackpad.ActuationStrength`
  # * `system.defaults.trackpad.Clicking`
  #
  # To continue using these options, set `system.primaryUser` to the name
  # of the user you have been using to run `darwin-rebuild`. In the long
  # run, this setting will be deprecated and removed after all the
  # functionality it is relevant for has been adjusted to allow
  # specifying the relevant user separately, moved under the
  # `users.users.*` namespace, or migrated to Home Manager.
  #
  # If you run into any unexpected issues with the migration, please
  # open an issue at <https://github.com/nix-darwin/nix-darwin/issues/new>
  # and include as much information as possible.

  system = {
    defaults = {
      CustomSystemPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default.
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes.
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences
      CustomUserPreferences = {
        # NOTE: Safari preferences are commented out due to sandboxing restrictions.
        # Safari stores its preferences in a sandboxed container at:
        # ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/
        # This prevents nix-darwin from reliably writing these settings.
        # You may need to configure these manually in Safari's preferences.
        #
        # Reference: https://github.com/LnL7/nix-darwin/issues/711
        #
        # "com.apple.Safari" = {
        #   # Privacy: don't send search queries to Apple.
        #   UniversalSearchEnabled = false;
        #   SuppressSearchSuggestions = true;
        #   # Press Tab to highlight each item on a web page.
        #   WebKitTabToLinksPreferenceKey = true;
        #   ShowFullURLInSmartSearchField = true;
        #   # Prevent Safari from opening 'safe' files automatically after downloading.
        #   AutoOpenSafeDownloads = false;
        #   ShowFavoritesBar = false;
        #   IncludeInternalDebugMenu = true;
        #   IncludeDevelopMenu = true;
        #   WebKitDeveloperExtrasEnabledPreferenceKey = true;
        #   WebContinuousSpellCheckingEnabled = true;
        #   WebAutomaticSpellingCorrectionEnabled = false;
        #   AutoFillFromAddressBook = false;
        #   AutoFillCreditCardData = false;
        #   AutoFillMiscellaneousForms = false;
        #   WarnAboutFraudulentWebsites = true;
        #   WebKitJavaEnabled = false;
        #   WebKitJavaScriptCanOpenWindowsAutomatically = false;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
        # };
      }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.CustomUserPreferences # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.CustomUserPreferences
      menuExtraClock = {
        Show24Hour = true; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.menuExtraClock.ShowDate
        ShowDate = 0; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.menuExtraClock.ShowDate
        ShowDayOfMonth = true; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.menuExtraClock.ShowDayOfMonth
        ShowDayOfWeek = true; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.menuExtraClock.ShowDayOfWeek
        ShowSeconds = true; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.menuExtraClock.ShowSeconds
      };
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
  };

  system.activationScripts = {
    extraActivation = {
      text = ''
        echo ":: . "
        echo ":: └── Running system.activationScripts.extraActivation..."

        sudo -u ${hostConfiguration.primaryUser} whoami
        sudo whoami
      '';
    };
    preActivation = {
      text = ''
        echo ":: . "
        echo ":: └── Running system.activationScripts.preActivation..."

        # https://chattingdarkly.org/@lhf@fosstodon.org/110661879831891580
        # https://github.com/luishfonseca/nixos-config/blob/f9369dbe389dafc5537c4b537592b9734fcfec5e/modules/upgrade-diff.nix.
        # https://gist.github.com/luishfonseca/f183952a77e46ccd6ef7c907ca424517?permalink_comment_id=4620275#gistcomment-4620275
        # https://github.com/GoldsteinE/nixos/blob/3d7353065c3f42b6442f7df9ab443fcb5381f2ce/rebuild#L13
        # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236

        if [[ -e /run/current-system ]]; then
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin --color=always diff /run/current-system "$systemConfig"
        else
          echo ":: Initial activation detected. Skipping package version diff tool."
        fi
      '';
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux { supportsDryActivation = true; };
    postActivation = {
      text = ''
        echo ":: . "
        echo ":: └── Running system.activationScripts.postActivation..."
      '';
    };
  }; # https://search.nixos.org/options?channel=unstable&query=system.activationScripts&show=system.activationScripts

  # Failed assertions:
  # - The `system.activationScripts.postUserActivation` option has
  # been removed, as all activation now takes place as `root`. Please
  # restructure your custom activation scripts appropriately,
  # potentially using `sudo` if you need to run commands as a user.
  # system.activationScripts.postUserActivation.text = ''
  #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  # '';
  system.activationScripts.activateUserSettings = {
    supportsDryActivation = true; # Set to false if this command shouldn't run in dry activations
    text = ''
      echo "Activating user settings for ${config.system.primaryUser}..."
      sudo -u ${config.system.primaryUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  }; # https://search.nixos.org/options?channel=unstable&show=system.userActivationScripts&query=system.userActivationScripts
}
