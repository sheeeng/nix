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
      buildPlatform = system; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.buildPlatform
      hostPlatform = system; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.hostPlatform
      inherit system; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.system
    };
    primaryUser = user.name; # https://nix-darwin.github.io/nix-darwin/manual/#opt-system.primaryUser
    system = "aarch64-darwin"; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.system
    user = {
      guid = 20; # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users._name_.gid
      name = "leonardlee"; # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users._name_.name
      uid = 501; # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users._name_.uid
    };
    # keep-sorted end
  };

  inherit ((import ../core/determinate.nix { })) isDeterminateNix;

  pkgs-unstable = import inputs.nixpkgs {
    inherit (hostConfiguration.nixpkgs) system;
    config.allowUnfree = true;
    inherit (pkgs.stdenv) hostPlatform;
  };
in
{
  imports = [
    # ../../modules/yabai
    # catppuccin.darwinModules.catppuccin # TODO: https://github.com/catppuccin/nix/issues/162
    # inputs.home-manager.darwinModules.defaults
    ../core/sops.nix
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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono # https://search.nixos.org/packages?channel=unstable&query=nerd-fonts.jetbrains-mono
  ];

  environment = {
    systemPackages = with pkgs; [
      # List packages installed in system profile.
      # To search by name, run:
      # $ nix-env --query --available --prebuilt-only | grep wget # nix.channel.enable = true; # TODO: Use traditional channels.
      # $ nix search nixpkgs wget
      # TODO: https://github.com/nix-community/home-manager/issues/1341 # The `home-manager` has issues adding applications to `~/Applications` directory.
      # keep-sorted start block=yes newline_separated=no
      clang # https://search.nixos.org/packages?channel=unstable&type=packages&show=clang
      coreutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=coreutils
      dix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dix
      findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
      git # https://search.nixos.org/packages?channel=unstable&type=packages&show=git
      inputs.flox.packages.${pkgs.system}.default
      nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
      nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
      nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
      nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
      nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
      nixfmt-rfc-style # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-rfc-style
      nvd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nvd
      unixtools.watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=unixtools.watch
      vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
      yazi # https://search.nixos.org/packages?channel=unstable&type=packages&show=yazi
      zellij # https://search.nixos.org/packages?channel=unstable&type=packages&show=zellij
      # keep-sorted end
    ]; # https://nix-darwin.github.io/nix-darwin/manual/#opt-environment.systemPackages
    shellAliases = {
      show-system = "nix derivation show /run/current-system";
      switch-system = "darwin-rebuild switch --flake .";
      list-generations = "nix-env --list-generations";
      setup-nix-github-token = "nix config --set access-tokens \"github.com=$(cat /run/secrets/tokens/github/public_repo_scope 2>/dev/null || echo 'GitHub token not available.')\"";
      clear-nix-github-token = "nix config --unset access-tokens";
    }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-environment.shellAliases
    variables = { }; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-environment.variables
  };

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
    enable = !isDeterminateNix; # https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.enable
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
      automatic = !isDeterminateNix; # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-nix.gc.automatic
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

      packageOverrides = pkgs: {
        nodejs = pkgs.nodejs.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          checkPhase = "echo 'Node.js tests disabled.'; true";
          installCheckPhase = "echo 'Node.js install checks disabled.'; true";
        };
        nodejs_22 = pkgs.nodejs_22.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          checkPhase = "echo 'Node.js 22 tests disabled.'; true";
          installCheckPhase = "echo 'Node.js 22 install checks disabled.'; true";
        };
        nodejs_24 = pkgs.nodejs_24.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          checkPhase = "echo 'Node.js 24 tests disabled.'; true";
          installCheckPhase = "echo 'Node.js 24 install checks disabled.'; true";
        };
      }; # https://nixos.org/manual/nixpkgs/unstable/#sec-modify-via-packageOverrides
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

  system.stateVersion = 5;

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
    # inputs.mac-app-util.homeManagerModules.default
  ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.sharedModules

  home-manager.users = {
    "${hostConfiguration.primaryUser}" = {
      home.stateVersion = "25.11";
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

        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin --color=always diff /run/current-system "$systemConfig"
      '';
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux { supportsDryActivation = true; };
    postActivation = {
      text = ''
        echo ":: . "
        echo ":: └── Running system.activationScripts.postActivation..."

      '';
    };
  };

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
  };
}
