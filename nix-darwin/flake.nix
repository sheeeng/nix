{
  # https://evantravers.com/articles/2024/02/06/switching-to-nix-darwin-and-flakes/
  # https://github.com/carlthome/dotfiles/blob/714c86da15ef00bbd0882c8ca1afcced2ebf70fa/modules/nix-darwin/configuration.nix
  # https://github.com/dmarcoux/dotfiles/blob/c66ad8c079b0b48227b17d6924212723657486a1/UPDATE.md
  # https://github.com/mhanberg/.dotfiles/blob/ce20d790b8f8b30a43b0bf62b051ffdd06e93169/nix/darwin.nix
  # https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
  # https://librephoenix.com/2024-02-10-using-both-stable-and-unstable-packages-on-nixos-at-the-same-time

  # The `specialArgs` is used when defining NixOS or system-level arguments for modules.
  # The `extraSpecialArgs` is used when invoking Home Manager inside NixOS.
  # The `specialArgs` are used by the nixOS system function, whereas `extraSpecialArgs` are used by the homeManagerConfiguration function from home-manager.
  # +--------------------------------------+
  # |           NixOS system               |
  # |  specialArgs = { inputs = { ... }; } |
  # |                                      |
  # |  +--------------------------------+  |
  # |  |      Home Manager (flake)      |  |
  # |  |  extraSpecialArgs = { ... };   |  |
  # |  +--------------------------------+  |
  # |                                      |
  # +--------------------------------------+

  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    catppuccin.url = "github:catppuccin/nix";
    errata-ai-alex.flake = false;
    errata-ai-alex.url = "github:errata-ai/alex";
    errata-ai-google.flake = false;
    errata-ai-google.url = "github:errata-ai/google";
    errata-ai-joblint.flake = false;
    errata-ai-joblint.url = "github:errata-ai/joblint";
    errata-ai-microsoft.flake = false;
    errata-ai-microsoft.url = "github:errata-ai/microsoft";
    errata-ai-proselint.flake = false;
    errata-ai-proselint.url = "github:errata-ai/proselint";
    errata-ai-readability.flake = false;
    errata-ai-readability.url = "github:errata-ai/readability";
    errata-ai-write-good.flake = false;
    errata-ai-write-good.url = "github:errata-ai/write-good";
    flake-utils.url = "github:numtide/flake-utils"; # https://github.com/edgelesssys/contrast/blob/7c5206269d2ce0440090f05db601506011e2cd5f/flake.nix#L13-L15
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    kitty-nightly.flake = false;
    kitty-nightly.url = "github:kovidgoyal/kitty/nightly";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nixos-hardware-master.url = "github:nixos/nixos-hardware/master";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/nur";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
    ragenix.url = "github:yaxitech/ragenix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs"; # https://github.com/edgelesssys/contrast/blob/7c5206269d2ce0440090f05db601506011e2cd5f/flake.nix#L16-L19
    treefmt-nix.url = "github:numtide/treefmt-nix";
    wcurl.flake = false;
    wcurl.url = "github:curl/wcurl/main";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
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
          environment.systemPackages = [
            pkgs.git
            pkgs.vim
          ];

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
        TP95V9LWWL = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin.nix
            inputs.agenix.darwinModules.age
            # catppuccin.darwinModules.catppuccin # https://github.com/catppuccin/nix/issues/162
            configuration
            inputs.home-manager.darwinModules.home-manager
            inputs.nixvim.nixDarwinModules.nixvim
            {
              home-manager = {
                users.leonardlee = {
                  imports = [
                    ../home-manager/home.nix
                    inputs.agenix.homeManagerModules.age
                    inputs.catppuccin.homeManagerModules.catppuccin
                    inputs.nixvim.homeManagerModules.nixvim
                  ];
                  home.stateVersion = "24.11";
                };
                extraSpecialArgs = { inherit inputs; };
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
