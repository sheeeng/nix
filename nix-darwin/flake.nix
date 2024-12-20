{
  # https://evantravers.com/articles/2024/02/06/switching-to-nix-darwin-and-flakes/
  # https://github.com/carlthome/dotfiles/blob/714c86da15ef00bbd0882c8ca1afcced2ebf70fa/modules/nix-darwin/configuration.nix
  # https://github.com/dmarcoux/dotfiles/blob/c66ad8c079b0b48227b17d6924212723657486a1/UPDATE.md
  # https://github.com/mhanberg/.dotfiles/blob/ce20d790b8f8b30a43b0bf62b051ffdd06e93169/nix/darwin.nix
  # https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050

  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    catppuccin.url = "github:catppuccin/nix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
  };

  outputs =
    inputs@{
      agenix,
      catppuccin,
      home-manager,
      nix-darwin,
      nixpkgs,
      nixvim,
      self,
    }:
    let
      system = "aarch64-darwin";
      # pkgs = import nixpkgs {
      #   inherit system;
      # };
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

      darwinConfigurations = {
        TP95V9LWWL = nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin.nix
            agenix.darwinModules.age
            # catppuccin.darwinModules.catppuccin # https://github.com/catppuccin/nix/issues/162
            configuration
            home-manager.darwinModules.home-manager
            nixvim.nixDarwinModules.nixvim
            {
              home-manager = {
                users.leonardlee = {
                  imports = [
                    ../home-manager/home.nix
                    agenix.homeManagerModules.age
                    catppuccin.homeManagerModules.catppuccin
                    nixvim.homeManagerModules.nixvim
                  ];
                  home.stateVersion = "24.11";
                };
              };
              users.users.leonardlee.home = "/Users/leonardlee";
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}

# # Build darwin flake using:
# # $ darwin-rebuild build --flake .#TP95V9LWWL
# darwinConfigurations."TP95V9LWWL" = nix-darwin.lib.darwinSystem {
#   modules = [
#     ./darwin.nix
#     agenix.darwinModules.age
#     # catppuccin.darwinModules.catppuccin # https://github.com/catppuccin/nix/issues/162
#     configuration
#     home-manager.darwinModules.home-manager
#     nixvim.nixDarwinModules.nixvim
#     {
#       home-manager = {
#         users.leonardlee = {
#           imports = [
#             ../home-manager/home.nix
#             agenix.homeManagerModules.age
#             catppuccin.homeManagerModules.catppuccin
#             nixvim.homeManagerModules.nixvim
#           ];
#           home.stateVersion = "24.11";
#         };
#       };
#       users.users.leonardlee.home = "/Users/leonardlee";
#     }
#   ];
#   specialArgs = { inherit inputs; };
# };

# # Expose the package set, including overlays, for convenience.
# darwinPackages = self.darwinConfigurations."TP95V9LWWL".pkgs;
