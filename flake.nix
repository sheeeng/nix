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

  # nixConfig = {
  #   # The extra- prefix appends to any list setting rather than overriding it.
  #   # https://nix.dev/manual/nix/latest/command-ref/conf-file#file-format
  #   extra-substituters = [
  #     "https://cache.nixos.org"
  #     "https://nix-community.cachix.org"
  #   ]; # https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-substituters

  #   # The extra- prefix appends to any list setting rather than overriding it.
  #   extra-trusted-public-keys = [
  #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #   ]; # https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-trusted-public-keys
  # };

  # Nix Channels and Git Branches:
  # https://github.com/nixos/nixpkgs/pull/105986
  # https://github.com/nixos/rfcs/pull/26
  # https://github.com/nixos/rfcs/pull/26#issuecomment-739237393
  # https://wiki.nixos.org/wiki/channel_branches#internal_channel_update_process

  # ruby_{3_3,3_4}: backport patches for GCC 15 and LLVM 21
  # https://github.com/nixos/nixpkgs/pull/451386
  # https://nixpk.gs/pr-tracker.html?pr=451386

  # The staging workflow exists to batch Hydra builds of many packages together.
  # https://github.com/nixos/nixpkgs/blob/master/CONTRIBUTING.md#staging

  # Which channel branch should I use?
  # https://nix.dev/concepts/faq#channel-branches

  # https://nix.dev/manual/nix/development/
  # https://nix.dev/manual/nix/latest/
  # https://nix.dev/manual/nix/rolling/
  # https://nix.dev/manual/nix/stable/
  # https://nix.dev/manual/nix/prev-stable/

  # https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake.html#examples
  # https://nix.dev/manual/nix/2.32/command-ref/new-cli/nix3-flake.html#examples

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?branch=nixos-unstable&rev=dc704e6102e76aad573f63b74c742cd96f8f1e6c"; # https://github.com/nixos/nixpkgs/issues/449970

    # OK
    # nixpkgs.url = "github:nixos/nixpkgs?branch=staging-next&rev=dace194d4791e7dec990c0671795f1e73ff4d196"; # https://github.com/nixos/nixpkgs/issues/449970
    # FAIL
    # nixpkgs.url = "github:nixos/nixpkgs?branch=staging-next&rev=387a92d18b3ff50e3eca63cb5b2bff679a068985"; # https://github.com/nixos/nixpkgs/issues/449970
    # FAIL (libimagequant Cargo.lock git object missing at nixos-unstable rev 9ae611a455b90cf061d8f332b977e387bda8e1ca)
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # OK
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # The next two are for pinning to stable vs unstable regardless of what the above is set to
    # This is particularly useful when an upcoming stable release is in beta because you can effectively
    # keep 'nixpkgs-stable' set to stable for critical packages while setting 'nixpkgs' to the beta branch to
    # get a jump start on deprecation changes.
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix'
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # nixpkgs-helix.url = "github:nixos/nixpkgs/bc947f541ae55e999ffdb4013441347d83b00feb"; # Hack for Helix to be able to build tree-sitter. # https://github.com/llakala/nixos/blob/5dae1c83df4835fd23d433adc76f66bca44962ba/flake.nix#L104

    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";

    # OK
    # nixpkgs-darwin.url = "github:nixos/nixpkgs?branch=nixos-unstable&rev=dc704e6102e76aad573f63b74c742cd96f8f1e6c"; # https://github.com/nixos/nixpkgs/issues/449970
    # FAIL
    # nixpkgs-darwin.url = "github:nixos/nixpkgs?branch=staging-next&rev=dace194d4791e7dec990c0671795f1e73ff4d196"; # https://github.com/nixos/nixpkgs/issues/449970
    # FAIL (libimagequant Cargo.lock git object missing at nixos-unstable rev 9ae611a455b90cf061d8f332b977e387bda8e1ca)
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixos-unstable";
    # OK (starship Darwin linker fix #540463 merged 2026-07-11 into nixpkgs-unstable; opencode 1.18.3 node_modules hash mismatch in 6bfaf02 avoided)
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # FAIL (opencode 1.18.3 node_modules hash mismatch on nixpkgs master 6bfaf02) # @upstream-issue TODO
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/6bfaf02a46540dad5b083e46e80d9ac133260cd3"; # https://github.com/NixOS/nixpkgs/pull/540463
    # FAIL (starship cctools ld64 linker crash on aarch64-darwin) # @upstream-issue https://github.com/NixOS/nixpkgs/issues/540450 # https://github.com/NixOS/nixpkgs/pull/540463
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/dc5eccaaeada7995d3b817e7d7c3bf3ab30b9b20"; # https://github.com/NixOS/nixpkgs/pull/540311
    # FAIL (opencode 1.17.15 node_modules CA hash mismatch) # https://github.com/NixOS/nixpkgs/pull/540311
    # nixpkgs-darwin.url = "github:nixos/nixpkgs?branch=nixpkgs-unstable&rev=96753b919b7befb34f0cb7dd212e6c26a4753e65"; # @upstream-issue https://github.com/anomalyco/opencode/issues/8029
    # FAIL (opencode 1.17.9 node_modules 7zip-bin/win/ia32/7za.exe Operation not permitted on Darwin 25.5.0 / macOS 16) # @upstream-issue https://github.com/anomalyco/opencode/issues/8029
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Nixpkgs 26.11, the nixpkgs-unstable branch above, dropped support for
    # x86_64-darwin. Pin that platform to the 26.05 stable Darwin branch, the
    # last release that still supports it. Only the x86_64-darwin host uses
    # this input; see hosts/C02ZV797MD6R/default.nix. Do not make it follow
    # nixpkgs, because it is an independent pin to a different release.
    # https://github.com/NixOS/nixpkgs/blob/nixpkgs-26.05-darwin
    nixpkgs-darwin-x86_64.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix distribution. Provides the nix-darwin module used to manage
    # the Determinate Nix installation declaratively (see darwinModules.default and
    # `determinateNix.enable`). Upgrade Determinate by bumping this input:
    #   nix flake update determinate && darwin-rebuild switch --flake .#<host>
    # Do NOT make this follow `nixpkgs`; Determinate is a pinned distribution.
    # https://docs.determinate.systems/guides/nix-darwin/
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

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
    # devenv.url = "github:cachix/devenv";
    # flox.url = "github:flox/flox";

    # helix-unstable = {
    #   url = "github:helix-editor/helix"; # Compile Helix from source to support macro keybinds
    #   inputs.nixpkgs.follows = "nixpkgs-helix"; # So we don't have two instances of `nixpkgs` in flake.lock. We use the same rev from helix's flake.lock so we don't have to recompile
    # }; # https://github.com/llakala/nixos/tree/5dae1c83df4835fd23d433adc76f66bca44962ba/apps/programs/firefox

    # nh-plus = {
    #   url = "github:toyvo/nh_plus";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # mac-app-util fails to build with sbcl-2.6.0 package.
    # sbcl-2.6.0 broke fare-quasiquote/cl-interpol readtable handling.
    # @upstream-issue https://github.com/hraban/mac-app-util/issues/42
    # TODO: Enable once upstream issue is fixed. See beads issue nixcfg-gl7.
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      # inputs.nixpkgs.follows = "nixpkgs"; # @upstream-issue https://github.com/hraban/mac-app-util/issues/42
    };

    matt-pocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts/main";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
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

    _1password-shell-plugins.url = "github:1password/shell-plugins";

    nix-systems.url = "github:nix-systems/default"; # https://github.com/nix-systems/nix-systems

    nix-secrets = {
      url = "github:sheeeng/nix-secrets/main";

      # url = "git+ssh://git@github.com/sheeeng/nix-secrets.git?ref=main&shallow=1";
      # url = "git+https://github.com/sheeeng/nix-secrets.git?ref=main&shallow=1";
      # url = "git+file://absolute/path/to/nix-secrets";
    };

    nix-secrets-example = {
      url = "github:sheeeng/nix-secrets-example/main";

      # url = "git+ssh://git@github.com/sheeeng/nix-secrets-example.git?ref=main&shallow=1";
      # url = "git+https://github.com/sheeeng/nix-secrets-example.git?ref=main&shallow=1";
      # url = "git+file://absolute/path/to/nix-secrets-example";
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

      # nixpkgs instance per system with the modifications overlay and allowUnfree
      # applied. Used for treefmt and dev shells, which otherwise receive bare
      # nixpkgs.legacyPackages without overlays or config.
      overlaidPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ (import ./overlays { inherit inputs; }).modifications ];
        };

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = nixpkgs.lib.genAttrs (import nix-systems) (
        system: treefmt-nix.lib.evalModule (overlaidPkgs system) ./treefmt.nix
      );

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454 # https://github.com/EmergentMind/nix-config/blob/f9168993316e8ff99381ff5dd3c7398273439618/flake.nix#L24

      darwinConfiguration =
        hostname: system:
        inputs.nix-darwin.lib.darwinSystem (
          {
            modules = [
              ./hosts/${hostname}
              inputs.determinate.darwinModules.default
              inputs.home-manager.darwinModules.home-manager
              inputs.mac-app-util.darwinModules.default
              inputs.nix-index-database.darwinModules.nix-index
              inputs.agenix.darwinModules.default
              inputs.sops-nix.darwinModules.sops
              {
                # Let Determinate manage the Nix installation declaratively. The
                # module force-sets `nix.enable = false`, so nix-darwin does not
                # also try to manage Nix. Determinate owns /etc/nix/nix.custom.conf
                # (generated from `determinateNix.customSettings`); the GitHub
                # access token is pulled in from that file via an `!include`
                # configured in hosts/darwin/sops.nix (Darwin-only).
                determinateNix.enable = true;
                nixpkgs.overlays = [
                  (import ./overlays { inherit inputs; }).additions
                  (import ./overlays { inherit inputs; }).modifications
                  inputs.morlana.overlays.default
                  # inputs.nh-plus.overlays.default
                  inputs.fenix.overlays.default
                  # TODO: Remove below anonymous/lambda function block after https://github.com/NixOS/nixpkgs/pull/461779 is resolved upstream.
                  # https://github.com/NixOS/nixpkgs/pull/461779#issuecomment-3540524291
                  # $ PAGER=cat nix why-depends --derivation github:NixOS/nixpkgs#direnv github:NixOS/nixpkgs#fish
                  # /nix/store/jw5h4ds90v9kkbazby807qzwvgg0562h-direnv-2.37.1.drv
                  # └───/nix/store/3kinxxz53hwmzw22l4cvpkxidiwh4w80-fish-4.2.1.drv
                  # (_self: super: {
                  #   fish = super.fish.overrideAttrs (oldAttrs: {
                  #     # TODO: Remove after https://github.com/NixOS/nixpkgs/pull/462090 is resolved upstream.
                  #     doCheck = false;
                  #     doInstallCheck = false;
                  #     checkPhase = ":";
                  #     installCheckPhase = ":";
                  #   }); # TODO: Remove anonymous/lambda function after https://github.com/NixOS/nixpkgs/pull/462589 is resolved upstream.
                  # }) # TODO: Remove above anonymous/lambda function after https://github.com/NixOS/nixpkgs/issues/461406 is resolved upstream.
                ];

                nixpkgs.config = {
                  allowUnfree = true;
                };

                environment.variables = { };
              }
            ];
            specialArgs = { inherit inputs; };
          }
          # Nixpkgs 26.11 dropped x86_64-darwin, so that host pins Nixpkgs to the
          # 26.05 stable Darwin branch while nix-darwin itself stays on 26.11.
          # nix-darwin asserts that its own release matches the Nixpkgs release
          # and otherwise throws, so disable that check for this host, where the
          # version mismatch is deliberate. See hosts/C02ZV797MD6R/default.nix.
          // nixpkgs.lib.optionalAttrs (system == "x86_64-darwin") {
            enableNixpkgsReleaseCheck = false;
          }
        );

      nixosConfiguration =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}
            inputs.home-manager.nixosModules.home-manager
            inputs.disko.nixosModules.disko
            inputs.agenix.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            {
              nixpkgs.overlays = [
                (import ./overlays { inherit inputs; }).additions
                (import ./overlays { inherit inputs; }).modifications
                inputs.morlana.overlays.default
                inputs.fenix.overlays.default
              ];

              nixpkgs.config = {
                allowUnfree = true;
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      # for `nix develop` - provides development shell
      devShells = nixpkgs.lib.genAttrs (import nix-systems) (
        system:
        let
          pkgs = overlaidPkgs system;
          shells = import ./shell.nix { inherit pkgs; };
        in
        {
          default = shells.standard-shell;
          inherit (shells) minimal-shell;
          inherit (shells) standard-shell;
        }
      );

      nixosConfigurations = {
        # desktop = nixosConfiguration "desktop" "x86_64-linux";
        # laptop = nixosConfiguration "laptop" "x86_64-linux";
        # rpi = nixosConfiguration "rpi" "aarch64-linux";
        fw13 = nixosConfiguration "fw13" "x86_64-linux";
        p50 = nixosConfiguration "p50" "x86_64-linux";
      };

      darwinConfigurations = {
        mockos = darwinConfiguration "mockos" "aarch64-darwin";
        TP95V9LWWL = darwinConfiguration "TP95V9LWWL" "aarch64-darwin";
        C02ZV797MD6R = darwinConfiguration "C02ZV797MD6R" "x86_64-darwin";
      };
    };
}
