{ pkgs, ... }:
{
  imports = [
    ./sops.nix
    ../../modules/home-manager.nix
  ];

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    dix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dix
    manix # https://search.nixos.org/packages?channel=unstable&type=packages&show=manix
    nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
    nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
    nix-prefetch-git # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-git
    nix-prefetch-github # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-github
    nix-prefetch-scripts # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-scripts
    nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
    nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
    nvd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nvd
    uutils-coreutils-noprefix # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
    uutils-diffutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-diffutils
    uutils-findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-findutils
    uutils-sed # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-sed
    uutils-tar # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-tar
    # keep-sorted end
  ]; # https://search.nixos.org/options?channel=unstable&query=environment.systemPackages&type=options#show=option%253Aenvironment.systemPackages

  services.displayManager = {
    defaultSession = "gnome";
    gdm.enable = true;
  };
  services.desktopManager.gnome.enable = true;

  # Use GCR so that the GNOME login keyring can unlock and load SSH keys.
  # Disable the OpenSSH agent because NixOS permits only one SSH agent.
  programs.ssh.startAgent = false;
  services.gnome.gcr-ssh-agent.enable = true;

  home-manager.sharedModules = [
    ({ lib, ... }: {
      dconf.settings = {
        "com/github/libpinyin/ibus-libpinyin/libpinyin" = {
          input-traditional = true;
        };
        "org/gnome/desktop/interface" = {
          cursor-size = 24;
          cursor-theme = "Adwaita";
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
  ];
}
