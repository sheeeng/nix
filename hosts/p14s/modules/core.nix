{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.firejail.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "26.05";
}
