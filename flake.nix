{
  description = "NixOS Configuration";

  inputs = {
    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    # inputs@{
    {
      # determinate,
      self,
      nix-darwin,
      nixpkgs,
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
      # spell-checker: disable
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#TP95V9LWWL
      darwinConfigurations."TP95V9LWWL" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          # determinate.darwinModules.default
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."TP95V9LWWL".pkgs;
      # spell-checker: enable
    };
}
