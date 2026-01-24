{
  config,
  inputs,
  pkgs,
  ...
}:
let
  hostConfiguration = rec {
    # keep-sorted start block=yes newline_separated=no sticky_comments=no
    networking = {
      hostName = "nixos"; # Adjust this to your actual hostname
    };
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      hostPlatform = systemPlatform;
    };
    primaryUser = user.name;
    systemPlatform = "x86_64-linux"; # Change to "aarch64-linux" if ARM
    user = {
      name = "llee";
      description = "Leonard Lee";
      uid = 1000;
      gid = 100;
    };
    # keep-sorted end
  };

  pkgs-unstable = import inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    # Uncomment if you have specific hardware from nixos-hardware
    # inputs.nixos-hardware.nixosModules.dell-latitude-7490
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
    # inputs.nixos-hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix
    ../linux/sops.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.age
    inputs.nixvim.nixosModules.nixvim
  ];

  system.primaryUser = hostConfiguration.primaryUser;

  documentation = {
    enable = true;
    doc.enable = true;
    info.enable = true;
    man.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # keep-sorted start block=yes newline_separated=no
      btop
      coreutils
      enpass
      findutils
      firefox
      git
      gnupg
      helix
      htop
      neovim
      nh
      nil
      nix
      nix-output-monitor
      nix-prefetch-git
      nix-prefetch-github
      nix-prefetch-scripts
      nixd
      nixfmt
      nvd
      openssh
      vim
      wget
      xclip
      zsh
      # keep-sorted end
    ];
    shellAliases = {
      list-generations = "nix-env --list-generations";
      pbcopy = "xclip -selection clipboard -in";
      pbpaste = "xclip -selection clipboard -out";
      show-system = "nix derivation show /run/current-system";
      switch-system = "sudo nixos-rebuild switch --flake .";
    };
    variables = {
      EDITOR = "hx";
      LANG = "en_US.UTF-8";
      SSH_AUTH_SOCK = "$HOME/.gnupg/S.gpg-agent.ssh";
      FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
    };
  };

  # Fonts - reused from darwin config
  fonts.packages =
    with pkgs;
    [
      # keep-sorted start block=no newline_separated=no
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      vt323
      # keep-sorted end
    ]
    ++ (with nerd-fonts; [
      # keep-sorted start block=no newline_separated=no
      dejavu-sans-mono
      droid-sans-mono
      fantasque-sans-mono
      fira-code
      fira-mono
      geist-mono
      go-mono
      gohufont
      hack
      inconsolata
      intone-mono
      iosevka
      iosevka-term
      iosevka-term-slab
      jetbrains-mono
      lekton
      liberation
      lilex
      martian-mono
      meslo-lg
      monaspace
      monofur
      monoid
      mononoki
      noto
      recursive-mono
      roboto-mono
      symbols-only
      ubuntu
      ubuntu-mono
      ubuntu-sans
      victor-mono
      zed-mono
      # keep-sorted end
    ]);

  # Boot loader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # File systems and LUKS configuration are in hardware-configuration.nix

  networking = {
    inherit (hostConfiguration.networking) hostName;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Nix configuration - reused from darwin with adjustments
  nixpkgs.config = {
    enableParallelBuildingByDefault = false;
    showAliases = true;
    allowBroken = false;
    allowUnfree = true;
    allowUnsupportedSystem = false;
    permittedInsecurePackages = [ ];
  };

  system.stateVersion = "25.11";

  nix = {
    optimise.automatic = true;
    package = pkgs-unstable.nix;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
      require-sigs = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "https://ryanccn.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
      ];
      trusted-substituters = [ "https://hydra.nixos.org/" ];
      trusted-users = [
        "root"
        hostConfiguration.primaryUser
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      !include ${config.sops.templates.nix-access-token.path}
      experimental-features = nix-command flakes
      keep-derivations = true
      keep-outputs = true
    '';
  };

  # Locale and timezone
  time.timeZone = "Europe/Oslo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nb_NO.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        uniemoji # https://search.nixos.org/packages?channel=unstable&type=packages&show=ibus-engine-uniemoji
        pinyin # https://search.nixos.org/packages?channel=unstable&type=packages&show=ibus-engine-pinyin
        mozc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ibus-engine-mozc
      ];
    };
  };

  security.polkit.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Disable PulseAudio in favor of PipeWire
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Hardware - Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # User configuration
  users.users."${hostConfiguration.user.name}" = {
    isNormalUser = true;
    inherit (hostConfiguration.user) description;
    inherit (hostConfiguration.user) uid;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ ];
  };

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  # GnuPG agent with SSH support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System auto-upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  home-manager.useGlobalPkgs = false;

  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  };

  home-manager.sharedModules = [ inputs.nix-index-database.homeModules.nix-index ];

  home-manager.users."${hostConfiguration.primaryUser}" = {
    home.stateVersion = "25.11";
    imports = [
      ../../home-manager/home.nix
      inputs.agenix.homeManagerModules.age
      inputs.catppuccin.homeModules.catppuccin
      inputs.nix-index-database.homeModules.nix-index
      inputs.nixvim.homeModules.nixvim
    ];

    # Add any laptop-specific home-manager overrides here
    # For example:
    # programs.kitty.settings.font_size = 11;
  };

  home-manager.verbose = false;

  # Activation scripts - adapted from darwin config
  system.activationScripts = {
    preActivation = {
      supportsDryActivation = true;
      text = ''
        echo ":: Running system.activationScripts.preActivation..."

        if [[ -e /run/current-system ]]; then
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin --color=always diff /run/current-system "$systemConfig"
        else
          echo ":: Initial activation detected. Skipping package version diff tool."
        fi
      '';
    };
    postActivation = {
      text = ''
        echo ":: Running system.activationScripts.postActivation..."
      '';
    };
  };
}
