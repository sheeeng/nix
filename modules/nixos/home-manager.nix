{
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
  home.username = "leonard";

  # error: The option `home-manager.users.leonard.home.homeDirectory' has conflicting definition values:
  # - In `/nix/store/fxwb685h2dwl55395vd3yp7a3bl8bgf7-source/modules/nixos/home-manager.nix': "/home/leonard"
  # - In `/nix/store/mdzxa36ixdm9g8yli9h73izv3kpj7xjq-source/nixos/common.nix': "/var/empty"
  # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  # home.homeDirectory = "/home/leonard";
}
