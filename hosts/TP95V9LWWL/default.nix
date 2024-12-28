{
  config,
  inputs,
  pkgs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (config.nixpkgs) system;
    config.allowUnfree = true;
    hostPlatform = pkgs.stdenv.hostPlatform;
  };
in
{
  imports = [
    inputs.agenix.darwinModules.age
    # catppuccin.darwinModules.catppuccin # https://github.com/catppuccin/nix/issues/162
    inputs.home-manager.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    inputs.nixvim.nixDarwinModules.nixvim
    ../../modules/yabai
  ];

  nixpkgs.config = {
    allowUnfree = true;
    hostPlatform = pkgs.stdenv.hostPlatform;
  };

  # Neither nixpkgs.system nor any other option in nixpkgs.* is meant
  # to be read by modules and configurations.
  # Use pkgs.stdenv.hostPlatform instead.
  #
  # The option nixpkgs.system is still fully supported for interoperability, but will be deprecated in the future, so we recommend to set nixpkgs.hostPlatform.
  nixpkgs.system = "aarch64-darwin";

  system.stateVersion = 5;
  nix.package = pkgs-unstable.nix;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  security.pam.enableSudoTouchIdAuth = true;

  networking = {
    dns = [ "1.1.1.1" ];
  };

  programs.zsh.enable = true;

  users.users.leonardlee = {
    name = "leonardlee";
    home = "/Users/leonardlee";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  };
  home-manager.users.leonardlee = {
    home.stateVersion = "24.11";
    imports = [
      ../../home-manager/home.nix
      inputs.agenix.homeManagerModules.age
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.nixvim.homeManagerModules.nixvim
    ];
  };
}
