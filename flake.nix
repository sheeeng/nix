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

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11"; # Use nixos branches instead of nixpkgs, it runs more tests?
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-helix.url = "github:nixos/nixpkgs/bc947f541ae55e999ffdb4013441347d83b00feb"; # Hack for Helix to be able to build tree-sitter. # https://github.com/llakala/nixos/blob/5dae1c83df4835fd23d433adc76f66bca44962ba/flake.nix#L104

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:lnl7/nix-darwin";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:nix-community/disko";
    };

    firefox-addons = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };

    flake-utils.url = "github:numtide/flake-utils"; # https://github.com/edgelesssys/contrast/blob/7c5206269d2ce0440090f05db601506011e2cd5f/flake.nix#L13-L15

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    }; # https://github.com/llakala/nixos/tree/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/programs/firefox

    helix-unstable = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs-helix"; # So we don't have two instances of `nixpkgs` in flake.lock. We use the same rev from helix's flake.lock so we don't have to recompile
      url = "github:helix-editor/helix"; # Compile Helix from source to support macro keybinds
    }; # https://github.com/llakala/nixos/tree/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/programs/firefox

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:nix-community/home-manager/release-24.11";
    };

    nh-plus = {
      url = "github:toyvo/nh_plus";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvirt = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "https://flakehub.com/f/ashleyyakeley/nixvirt/*.tar.gz";
    };

    microvm = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:astro/microvm.nix";
    };

    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:snowfallorg/lib";
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

    kitty-nightly.flake = false;
    kitty-nightly.url = "github:kovidgoyal/kitty/nightly";

    morlana.url = "github:ryanccn/morlana";
    morlana.inputs.nixpkgs.follows = "nixpkgs-stable";

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
        hostname: system:
        inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/${hostname}
            inputs.home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [
                (final: _prev: {
                  unstable = import inputs.nixpkgs-unstable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })
                inputs.morlana.overlays.default
                inputs.nh-plus.overlays.default
              ];
            }
          ];
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
        TP95V9LWWL = darwinConfiguration "TP95V9LWWL" "aarch64-darwin";
        C02ZV797MD6R = darwinConfiguration "C02ZV797MD6R" "x86_64-darwin";
      };
    };

}
