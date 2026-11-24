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
      hostName = "p14s";
    };
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      hostPlatform = systemPlatform;
    };
    primaryUser = user.name;
    systemPlatform = "x86_64-linux";
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

  # ========== Core System Configuration ==========
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    inherit (hostConfiguration.networking) hostName;
    networkmanager.enable = true;
    wireless.enable = true;
    nftables.enable = true;
    firewall.enable = true;
  };

  programs.firejail.enable = true;
  programs.nix-ld.enable = true;

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  services.openssh.enable = true;

  services.tailscale.enable = true;

  # ========== Locale and Timezone ==========
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
        mozc
        pinyin
        uniemoji
      ];
    };
  };

  # ========== User Configuration ==========
  users.users.llee = {
    isNormalUser = true;
    description = "Leonard Lee";
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # ========== Hardware and Drivers ==========
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # ========== Sway Window Manager Configuration ==========
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1
      export QT_QPA_PLATFORM=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # ========== Application Packages ==========
  environment.systemPackages = with pkgs; [
    # CLI Tools
    # keep-sorted start block=yes newline_separated=no
    atuin
    bat
    bottom
    brightnessctl
    btop
    delta
    difftastic
    dust
    enpass
    enpass-cli
    eza
    fastfetch
    fd
    fish
    fzf
    gcc
    gh
    ghostty
    git
    github-copilot-cli
    gnumake
    gnupg
    grim
    helix
    htop
    jq
    lazygit
    libappindicator-gtk3
    libdbusmenu-gtk3
    libnotify
    libxcb
    mako
    neovim
    nushell
    openssh
    papirus-icon-theme
    pavucontrol
    pulseaudio
    qt5.qtwayland
    qt6.qtwayland
    ripgrep
    slurp
    starship
    swayidle
    swaylock
    swaynotificationcenter
    tailscale
    tailscale-systray
    tealdeer
    unzip
    vim
    waybar
    wireplumber
    wl-clipboard
    wlogout
    xclip
    yq
    zoxide
    # keep-sorted end
  ];

  environment.shellAliases = {
    list-generations = "nix-env --list-generations";
    pbcopy = "xclip -selection clipboard -in";
    pbpaste = "xclip -selection clipboard -out";
    show-system = "nix derivation show /run/current-system";
    switch-system = "sudo nixos-rebuild switch --flake .";
  };

  environment.variables = {
    EDITOR = "hx";
    LANG = "en_US.UTF-8";
    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
    FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
  };

  # ========== Fonts ==========
  fonts.packages =
    with pkgs;
    [
      # keep-sorted start block=no newline_separated=no
      atkinson-hyperlegible-mono
      atkinson-hyperlegible-next
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

  # ========== Nix Configuration ==========
  nixpkgs.config = {
    enableParallelBuildingByDefault = false;
    showAliases = true;
    allowBroken = false;
    allowUnfree = true;
    allowUnsupportedSystem = false;
    permittedInsecurePackages = [ ];
  };

  system.stateVersion = "26.05";

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
        "https://cache.nixos.org?priority=10"
        "https://devenv.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "https://ryanccn.cachix.org"
        "https://nix-community.cachix.org?priority=20"
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://cache.numtide.com"
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
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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

  # ========== Security and SSH ==========
  security.polkit.enable = true;

  security.sudo.extraConfig = ''
    Defaults env_keep += "SSH_AUTH_SOCK"
  '';

  programs.ssh.startAgent = false;
  services.gnome.gcr-ssh-agent.enable = false;
  services.yubikey-agent.enable = false;

  services.pcscd.enable = true;

  # ========== Bluetooth ==========
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ========== Display and Printing ==========
  services.printing.enable = true;

  services.pulseaudio.enable = false;

  # ========== Program Configuration ==========
  programs.firefox.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # ========== System Upgrade ==========
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # ========== Home Manager Configuration ==========
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
    {
      nixpkgs.overlays = [
        (import ../../overlays { inherit inputs; }).additions
        (import ../../overlays { inherit inputs; }).modifications
      ];
    }
  ];

  home-manager.users."${hostConfiguration.primaryUser}" =
    { lib, ... }:
    {
      imports = [
        ../../home-manager/home.nix
        inputs.agenix.homeManagerModules.age
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
        inputs.nixvim.homeModules.nixvim
      ];

      programs.fzf.enable = lib.mkForce false;
    };

  home-manager.verbose = false;

  # ========== System Activation Scripts ==========
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
  };
}
