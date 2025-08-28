_:
let
  folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
in
{
  imports = [
    ./development.nix
    ./fonts.nix
    ./packages.nix
    ./programs.nix
    ./scripts.nix
    ./sops.nix
    ./theme.nix
  ]
  ++ (folderFiles ./packages)
  ++ (folderFiles ./programs);
  # https://github.com/alexnabokikh/nix-config/blob/bddec40e097d4227cd95badfc02164aa006a8a4c/modules/home-manager/common/default.nix

  fonts.fontconfig.enable = true;
  # home.stateVersion = "25.11"; # Please read the comment before changing.

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  nixpkgs.config.allowUnfree = true;
}
