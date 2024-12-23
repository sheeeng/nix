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
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:lnl7/nix-darwin";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:nix-community/home-manager/release-24.11";
    };

    nixvirt = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
    };

    microvm = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:astro/microvm.nix";
    };

    agenix.inputs.nixpkgs.follows = "nixpkgs-stable";
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

    kitty-nightly.flake = false;
    kitty-nightly.url = "github:kovidgoyal/kitty/nightly";

    nixvim.inputs.nixpkgs.follows = "nixpkgs-stable";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nur.inputs.nixpkgs.follows = "nixpkgs-stable";
    nur.url = "github:nix-community/nur";
    ragenix.inputs.nixpkgs.follows = "nixpkgs-stable";
    ragenix.url = "github:yaxitech/ragenix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-stable";
    sops-nix.url = "github:mic92/sops-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs-stable"; # https://github.com/edgelesssys/contrast/blob/7c5206269d2ce0440090f05db601506011e2cd5f/flake.nix#L16-L19
    treefmt-nix.url = "github:numtide/treefmt-nix";
    wcurl.flake = false;
    wcurl.url = "github:curl/wcurl/main";
  };

  outputs =
    inputs:
    let
      nixosConfiguration =
        hostname: system:
        inputs.nixpkgs-stable.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = "${hostname}"; }
            ./hosts/${hostname}
          ];
          specialArgs = { inherit inputs; };
        };
      darwinConfiguration =
        hostname:
        inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./hosts/${hostname} ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        desktop = nixosConfiguration "desktop" "x86_64-linux";
        laptop = nixosConfiguration "laptop" "x86_64-linux";
        rpi = nixosConfiguration "rpi" "aarch64-linux";
      };
      darwinConfigurations = {
        TP95V9LWWL = darwinConfiguration "TP95V9LWWL";
      };
    };

}
