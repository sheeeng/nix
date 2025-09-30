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
    # nixpkgs.url = "github:nixos/nixpkgs/nixos";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # The next two are for pinning to stable vs unstable regardless of what the above is set to
    # This is particularly useful when an upcoming stable release is in beta because you can effectively
    # keep 'nixpkgs-stable' set to stable for critical packages while setting 'nixpkgs' to the beta branch to
    # get a jump start on deprecation changes.
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix'
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # nixpkgs-helix.url = "github:nixos/nixpkgs/bc947f541ae55e999ffdb4013441347d83b00feb"; # Hack for Helix to be able to build tree-sitter. # https://github.com/llakala/nixos/blob/5dae1c83df4835fd23d433adc76f66bca44962ba/flake.nix#L104

    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/master";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils"; # https://github.com/edgelesssys/contrast/blob/7c5206269d2ce0440090f05db601506011e2cd5f/flake.nix#L13-L15

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    }; # https://github.com/llakala/nixos/tree/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/programs/firefox

    catppuccin.url = "github:catppuccin/nix";
    devenv.url = "github:cachix/devenv";
    flox.url = "github:flox/flox";

    # helix-unstable = {
    #   url = "github:helix-editor/helix"; # Compile Helix from source to support macro keybinds
    #   inputs.nixpkgs.follows = "nixpkgs-helix"; # So we don't have two instances of `nixpkgs` in flake.lock. We use the same rev from helix's flake.lock so we don't have to recompile
    # }; # https://github.com/llakala/nixos/tree/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/programs/firefox

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "github:nix-community/home-manager/release-24.11";
    };

    nh-plus = {
      url = "github:toyvo/nh_plus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # errata-ai-alex.flake = false;
    # errata-ai-alex.url = "github:errata-ai/alex";
    # errata-ai-google.flake = false;
    # errata-ai-google.url = "github:errata-ai/google";
    # errata-ai-joblint.flake = false;
    # errata-ai-joblint.url = "github:errata-ai/joblint";
    # errata-ai-microsoft.flake = false;
    # errata-ai-microsoft.url = "github:errata-ai/microsoft";
    # errata-ai-proselint.flake = false;
    # errata-ai-proselint.url = "github:errata-ai/proselint";
    # errata-ai-readability.flake = false;
    # errata-ai-readability.url = "github:errata-ai/readability";
    # errata-ai-write-good.flake = false;
    # errata-ai-write-good.url = "github:errata-ai/write-good";

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # kitty-nightly.flake = false;
    # kitty-nightly.url = "github:kovidgoyal/kitty/nightly";

    morlana = {
      url = "github:ryanccn/morlana";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wcurl = {
      url = "github:curl/wcurl/main";
      flake = false;
    };

    nix-systems.url = "github:nix-systems/default"; # https://github.com/nix-systems/nix-systems

    nix-secrets = {
      url = "git+ssh://git@github.com/sheeeng/nix-secrets.git?ref=main&shallow=1";
      # url = "git+file:///home/.../nix-secrets?ref=main&shallow=1";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-systems,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Small tool to iterate over each systems
      eachSystem =
        f: nixpkgs.lib.genAttrs (import nix-systems) (system: f nixpkgs.legacyPackages.${system});
      # eachSystem = nixpkgs.lib.genAttrs [
      #   "aarch64-linux"
      #   "i686-linux"
      #   "x86_64-linux"
      #   "aarch64-darwin"
      #   "x86_64-darwin"
      # ];

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (_self: _super: { custom = import ./lib { inherit (nixpkgs) lib; }; }); # https://github.com/EmergentMind/nix-config/blob/f9168993316e8ff99381ff5dd3c7398273439618/flake.nix#L24

      nixosConfiguration =
        hostname: system:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}
            { networking.hostName = "${hostname}"; }
            inputs.nix-index-database.nixosModules.nix-index
          ];
          specialArgs = { inherit inputs outputs lib; };
        };

      darwinConfiguration =
        hostname: _system:
        inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/${hostname}
            inputs.home-manager.darwinModules.home-manager
            inputs.mac-app-util.darwinModules.default
            inputs.nix-index-database.darwinModules.nix-index
            inputs.agenix.darwinModules.default
            inputs.sops-nix.darwinModules.sops
            {
              nixpkgs.overlays = [
                (import ./overlays inputs).nodejs-skip-tests
                (import ./overlays inputs).unstable-packages
                inputs.morlana.overlays.default
                inputs.nh-plus.overlays.default
                inputs.fenix.overlays.default
              ];

              # Global configuration to disable tests for better performance
              nixpkgs.config = {
                allowUnfree = true;
                # Disable checks globally for faster rebuilds
                doCheck = false;
                doInstallCheck = false;
                # Override package defaults to skip tests
                packageOverrides = pkgs: {
                  # Global override for any Node.js related packages
                  nodejs = pkgs.nodejs.overrideAttrs {
                    doCheck = false;
                    doInstallCheck = false;
                  };
                };
              };

              # Set environment variables to disable Node.js tests system-wide
              environment.variables = {
                SKIP_TESTS = "1";
                NODE_SKIP_CRYPTO_TESTS = "1";
                NODE_SKIP_PLATFORM_TESTS = "1";
                NIX_SKIP_NODEJS_TESTS = "1";
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      # for `nix develop` - provides development shell
      devShells = eachSystem (
        pkgs:
        let
          shells = import ./shell.nix { inherit pkgs; };
        in
        {
          default = shells.pre-commit;
          pre-commit = shells.pre-commit;
          minimal = shells.minimal;
        }
      );

      nixosConfigurations = {
        desktop = nixosConfiguration "desktop" "x86_64-linux";
        laptop = nixosConfiguration "laptop" "x86_64-linux";
        rpi = nixosConfiguration "rpi" "aarch64-linux";
      };

      darwinConfigurations = {
        TP95V9LWWL = darwinConfiguration "TP95V9LWWL" "aarch64-darwin";
        NHNWCQ17DF = darwinConfiguration "NHNWCQ17DF" "aarch64-darwin";
        C02ZV797MD6R = darwinConfiguration "C02ZV797MD6R" "x86_64-darwin";
      };
    };
}
