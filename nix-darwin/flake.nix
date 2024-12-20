{
  # https://evantravers.com/articles/2024/02/06/switching-to-nix-darwin-and-flakes/
  # https://github.com/carlthome/dotfiles/blob/714c86da15ef00bbd0882c8ca1afcced2ebf70fa/modules/nix-darwin/configuration.nix
  # https://github.com/dmarcoux/dotfiles/blob/c66ad8c079b0b48227b17d6924212723657486a1/UPDATE.md
  # https://github.com/mhanberg/.dotfiles/blob/ce20d790b8f8b30a43b0bf62b051ffdd06e93169/nix/darwin.nix

  description = "NixOS Configuration";

  inputs = {
    # catppuccin-nix.url = "github:catppuccin/nix";
    lnl7-nix-darwin.inputs.nixpkgs.follows = "nixpkgs-nixpkgs-2411-darwin";
    lnl7-nix-darwin.url = "github:lnl7/nix-darwin";
    nix-community-home-manager-release-2411.inputs.nixpkgs.follows = "nixpkgs-nixpkgs-2411-darwin";
    nix-community-home-manager-release-2411.url = "github:nix-community/home-manager/release-24.11";
    nix-community-nixvim-nixos-2411.inputs.nixpkgs.follows = "nixpkgs-nixpkgs-2411-darwin";
    nix-community-nixvim-nixos-2411.url = "github:nix-community/nixvim/nixos-24.11";
    nixpkgs-nixpkgs-2411-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
  };

  outputs =
    inputs@{
      lnl7-nix-darwin,
      nix-community-home-manager-release-2411,
      nix-community-nixvim-nixos-2411,
      self,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [ pkgs.vim ];

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#TP95V9LWWL
      darwinConfigurations."TP95V9LWWL" = lnl7-nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          # nix-community-nixvim.nixDarwinModules.nixvim
          nix-community-home-manager-release-2411.darwinModules.home-manager
          {
            home-manager = {
              users.leonardlee = {
                imports = [
                  ../home-manager/home.nix
                  nix-community-nixvim-nixos-2411.homeManagerModules.nixvim
                ];
                home.stateVersion = "24.11";
              };
            };
            users.users.leonardlee.home = "/Users/leonardlee";
          }
        ];
        specialArgs = { inherit inputs; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."TP95V9LWWL".pkgs;
    };
}
