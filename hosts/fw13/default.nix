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
      hostName = "fw13";
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
    ../linux
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
      enpass
      git
      gnome-tweaks
      gnupg
      helix
      htop
      neovim
      openssh
      tailscale # https://search.nixos.org/packages?channel=unstable&type=packages&show=tailscale
      tailscale-systray # https://search.nixos.org/packages?channel=unstable&type=packages&show=tailscale-systray
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
      FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
    };
  };

  services.tailscale.enable = true;

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

  system.stateVersion = "25.11"; # Keep pinned to the initial install; do not float with the current release. https://search.nixos.org/options?show=system.stateVersion

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
        "https://cache.nixos.org?priority=10" # curl https://cache.nixos.org/nix-cache-info
        "https://devenv.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "https://ryanccn.cachix.org"
        "https://nix-community.cachix.org?priority=20" # curl https://nix-community.cachix.org/nix-cache-info
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"
        "https://cache.nixos-cuda.org" # https://wiki.nixos.org/wiki/CUDA#Setting_up_CUDA_Binary_Cache
        "https://cache.numtide.com" # https://cache.numtide.com/index.html
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" # https://wiki.nixos.org/wiki/CUDA#Setting_up_CUDA_Binary_Cache
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" # https://cache.numtide.com/index.html
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
        mozc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ibus-engine-mozc (Japanese)
        pinyin # https://search.nixos.org/packages?channel=unstable&type=packages&show=ibus-engine-pinyin (Simplified + Traditional Chinese Pinyin)
        uniemoji # https://search.nixos.org/packages?channel=unstable&type=packages&show=ibus-engine-uniemoji
      ];
    };
  };

  security.polkit.enable = true;

  # Preserve SSH_AUTH_SOCK when using sudo.
  # This allows root processes to access the user's SSH agent for authentication,
  # which is required by nixos-rebuild when fetching private flake inputs.
  security.sudo.extraConfig = ''
    Defaults env_keep += "SSH_AUTH_SOCK"
  '';

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager = {
    defaultSession = "gnome";
    gdm.enable = true;
  };
  services.desktopManager.gnome.enable = true;

  # Use GCR so that the GNOME login keyring can unlock and load SSH keys.
  # Disable the OpenSSH agent because NixOS permits only one SSH agent.
  programs.ssh.startAgent = false;
  services.gnome.gcr-ssh-agent.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.sway.enable = true;

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

  # Disable yubikey-agent because gcr-ssh-agent handles SSH keys on this host.
  # The gpg-agent handles GPG operations only on Linux.
  services.yubikey-agent.enable = false; # https://search.nixos.org/options?channel=unstable&show=services.yubikey-agent.enable

  # Enable pcscd for smart card (YubiKey) support with gpg-agent.
  services.pcscd.enable = true; # https://search.nixos.org/options?channel=unstable&show=services.pcscd.enable

  hardware.bluetooth = {
    enable = true; # https://search.nixos.org/options?channel=unstable&show=hardware.bluetooth.enable
    powerOnBoot = true; # https://search.nixos.org/options?channel=unstable&show=hardware.bluetooth.powerOnBoot
  }; # https://search.nixos.org/options?channel=unstable&show=hardware.bluetooth

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
  }; # https://search.nixos.org/options?channel=unstable&show=users.users

  programs.zsh.enable = true; # https://search.nixos.org/options?channel=unstable&show=programs.zsh.enable
  programs.firefox.enable = true; # https://search.nixos.org/options?channel=unstable&show=programs.firefox.enable

  # GPG agent is configured via home-manager (services.gpg-agent).
  # System-level configuration is disabled to avoid conflicts.
  # The home-manager gpg-agent handles SSH support and pinentry.
  programs.gnupg.agent = {
    enable = false; # https://search.nixos.org/options?channel=unstable&show=programs.gnupg.agent.enable
    # SSH support is configured in home-manager's services.gpg-agent.enableSshSupport
  }; # https://search.nixos.org/options?channel=unstable&show=programs.gnupg.agent

  system.autoUpgrade = {
    enable = true; # https://search.nixos.org/options?channel=unstable&show=system.autoUpgrade.enable
    allowReboot = true; # https://search.nixos.org/options?channel=unstable&show=system.autoUpgrade.allowReboot
  }; # https://search.nixos.org/options?channel=unstable&show=system.autoUpgrade

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  home-manager.useGlobalPkgs = false;

  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  };

  home-manager.sharedModules = [
    inputs.nix-index-database.homeModules.nix-index
    ({ lib, ... }: {
      dconf.settings = {
        "com/github/libpinyin/ibus-libpinyin/libpinyin" = {
          input-traditional = true;
        };
        "org/gnome/Console" = {
          custom-font = "";
          use-system-font = true;
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "default";
          cursor-size = 24;
          cursor-theme = "Adwaita";
          document-font-name = "Adwaita Sans 12";
          font-name = "Adwaita Sans 11";
          gtk-theme = "Adwaita";
          icon-theme = "Adwaita";
          monospace-font-name = "Adwaita Mono 11";
        };
        "org/gnome/desktop/input-sources" = {
          sources = [
            (lib.hm.gvariant.mkTuple [
              "xkb"
              "us"
            ])
            (lib.hm.gvariant.mkTuple [
              "ibus"
              "mozc-jp"
            ])
            (lib.hm.gvariant.mkTuple [
              "ibus"
              "pinyin"
            ])
          ];
        };
      };
    })
    # Apply overlays to home-manager's pkgs. It is required when useGlobalPkgs = false.
    {
      nixpkgs.overlays = [
        (import ../../overlays { inherit inputs; }).additions
        (import ../../overlays { inherit inputs; }).modifications
      ];
    }
  ];

  home-manager.users."${hostConfiguration.primaryUser}" =
    { ... }:
    {
      imports = [
        ../../home-manager/home.nix
        inputs.agenix.homeManagerModules.age
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
        inputs.nixvim.homeModules.nixvim
      ];
    };

  home-manager.verbose = false;

  # Activation scripts for system deployment.
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
    # GitHub access tokens are included declaratively via nix.extraOptions
    # using !include with the sops template path. No imperative postActivation
    # script is needed because NixOS generates /etc/nix/nix.conf as a read-only
    # store symlink from nix.settings and nix.extraOptions.
  };
}
