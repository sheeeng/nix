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

    # Use `github:NixOS/nixpkgs/nixpkgs-24.11-darwin` to use Nixpkgs 24.11.
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    # Use `github:LnL7/nix-darwin/nix-darwin-24.11` to use Nixpkgs 24.11.
    # nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-stable-darwin";

    # nix-darwin = {
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    #   url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    # };

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
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    snowfall-frost = {
      url = "github:snowfallorg/frost";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    agenix.inputs.nixpkgs.follows = "nixpkgs-stable";
    agenix.url = "github:ryantm/agenix";
    catppuccin.url = "github:catppuccin/nix";
    devenv.url = "github:cachix/devenv";
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

    fenix = {
      inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:nix-community/fenix";
    };

    kitty-nightly.flake = false;
    kitty-nightly.url = "github:kovidgoyal/kitty/nightly";

    morlana.url = "github:ryanccn/morlana";
    morlana.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixvim.inputs.nixpkgs.follows = "nixpkgs-stable";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nur.inputs.nixpkgs.follows = "nixpkgs-stable";
    nur.url = "github:nix-community/nur";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
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
    {
      devenv,
      flake-utils,
      nixpkgs,
      self,
      ...
    }@inputs:
    # flake-utils.lib.eachDefaultSystem (
    #   system:
    let
      # pkgs = import nixpkgs { inherit system; };

      nixosConfiguration =
        hostname: system:
        inputs.nixpkgs-stable.lib.nixosSystem {
          system = system;
          modules = [
            inputs.nix-index-database.nixosModules.nix-index
            { networking.hostName = "${hostname}"; }
            ./hosts/${hostname}
          ];
          specialArgs = { inherit inputs; };
        };

      darwinConfiguration =
        hostname: system:
        inputs.nix-darwin.lib.darwinSystem {
          modules = [
            inputs.nix-index-database.darwinModules.nix-index
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
                # inputs.fenix.overlays.default
              ];
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      # formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
      #   packages = [
      #     pkgs.atuin # https://search.nixos.org/packages?channel=unstable&type=packages&show=atuin
      #     pkgs.bashInteractive # https://search.nixos.org/packages?channel=unstable&type=packages&show=bashInteractive
      #     pkgs.devenv # https://search.nixos.org/packages?channel=unstable&type=packages&show=devenv
      #     pkgs.direnv # https://search.nixos.org/packages?channel=unstable&type=packages&show=direnv
      #     pkgs.gnumake # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnumake
      #     pkgs.pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
      #     (pkgs.bats.withLibraries (p: [
      #       p.bats-support
      #       p.bats-assert
      #       p.bats-file
      #       p.bats-detik
      #     ]))
      #   ];
      #   shellHook = ''
      #     echo "Activate default developer environment."
      #     echo "Nix '$(nix --version | awk '{print $3}')' located in '$(which nix)'."
      #     echo "Atuin '$(atuin --version | awk '{print $2}')' located in '$(which atuin)'."
      #     echo "Cargo '$(cargo --version | awk '{print $2}')' located in '$(which cargo)'."
      #     echo "Devenv '$(devenv version | awk '{print $2}')' located in '$(which devenv)'."
      #     echo "Direnv '$(direnv --version)' located in '$(which direnv)'."
      #     echo "Go '$(go version | { read _ _ v _; echo ''${v#go}; })' located in '$(which go)'."
      #     echo "Node '$(node --version)' located in '$(which node)'."
      #     echo "Npm '$(npm --version)' located in '$(which npm)'."
      #     echo "Python '$(python --version | awk '{print $2}')' located in '$(which python)'."
      #     echo ""
      #   '';
      # };

      # packages.${system} = {
      #   projectTerraform-devenv-up = self.devShells.${system}.projectTerraform.config.procfileScript;
      #   projectTerraform-devenv-test = self.devShells.${system}.projectTerraform.config.test;

      #   projectNix-devenv-up = self.devShells.${system}.projectNix.config.procfileScript;
      #   projectNix-devenv-test = self.devShells.${system}.projectNix.config.test;
      # };

      # devShells.${system} = {
      #   projectTerraform = devenv.lib.mkShell {
      #     inherit inputs pkgs;
      #     modules = [
      #       (
      #         { pkgs, config, ... }:
      #         {
      #           packages = with pkgs; [
      #             terraform # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform
      #             terragrunt # https://search.nixos.org/packages?channel=unstable&type=packages&show=terragrunt
      #           ];
      #           enterShell = ''
      #             echo "Activate Terraform development shell."
      #             echo "Nix '$(nix --version | awk '{print $3}')' located in '$(which nix)'."
      #             echo "Terraform '$(terraform --version | head --lines 1 | grep --only-matching --perl-regexp '\K[0-9]+\.[0-9]+\.[0-9]+')' located in '$(which terraform)'."
      #           '';
      #         }
      #       )
      #     ];
      #   };

      #   projectNix = devenv.lib.mkShell {
      #     inherit inputs pkgs;
      #     modules = [
      #       (
      #         { pkgs, config, ... }:
      #         {
      #           packages = with pkgs; [
      #             nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
      #             nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
      #             nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
      #             nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
      #             nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
      #             nixfmt-rfc-style # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-rfc-style
      #           ];
      #           enterShell = ''
      #             echo "Activate Nix development shell."
      #             echo "Nix '$(nix --version | awk '{print $3}')' located in '$(which nix)'."
      #           '';
      #         }
      #       )
      #     ];
      #   };
      # };

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
  # );
}
