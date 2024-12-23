{
  config,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (config.nixpkgs) system;
    config.allowUnfree = true;
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

  system.stateVersion = 5;
  nix.package = pkgs-unstable.nix;
  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

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
