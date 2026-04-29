{ inputs, ... }:
{
  additions = final: _prev: {
    # Sandbox Runtime (srt) by Anthropic.
    # https://github.com/anthropic-experimental/sandbox-runtime
    # A lightweight sandboxing tool for enforcing filesystem and network
    # restrictions on arbitrary processes at the OS level.
    sandbox-runtime = final.buildNpmPackage {
      pname = "sandbox-runtime";
      version = "0.0.32";

      # nix-prefetch-github anthropic-experimental sandbox-runtime --rev v0.0.49
      # {
      #     "owner": "anthropic-experimental",
      #     "repo": "sandbox-runtime",
      #     "rev": "7a725a314f8ce0a6404f275292d8eec557ba949a",
      #     "hash": "sha256-1QwUOtgOYcVm61nLCeQL46O/+G/LyXSv+ZnC3la2Ajc="
      # }
      src = final.fetchFromGitHub {
        owner = "anthropic-experimental";
        repo = "sandbox-runtime";
        rev = "7a725a314f8ce0a6404f275292d8eec557ba949a"; # v0.0.49
        hash = "sha256-1QwUOtgOYcVm61nLCeQL46O/+G/LyXSv+ZnC3la2Ajc=";
      };

      # Use `lib.fakeHash` as the npmDepsHash value.
      # specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
      npmDepsHash = "sha256-YAzekNE9lOEMRaaGqLdpXMXgqh4kfGp4CF54ShS3xwA=";

      # The package needs to be built from TypeScript.
      npmBuildScript = "build";

      # Copy vendor directory after build (contains seccomp binaries).
      postBuild = "if [ -d vendor ]; then cp -r vendor dist/; fi";

      meta = {
        description = "Anthropic Sandbox Runtime - A lightweight sandboxing tool for enforcing filesystem and network restrictions";
        homepage = "https://github.com/anthropic-experimental/sandbox-runtime";
        license = final.lib.licenses.asl20;
        maintainers = [ ];
        mainProgram = "srt";
      };
    };
  };

  modifications = final: prev: {
    unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};

    # Workaround for VSCode "Operation not permitted" issue.
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/476838
    # @upstream-issue https://github.com/nix-darwin/nix-darwin/issues/1315#issuecomment-2629517646
    vscode = prev.vscode.overrideAttrs (old: {
      installPhase = "whoami\n" + old.installPhase;
    });

    # nix eval nixpkgs#beads --json 2>&1 | head -20
    # nix eval .#darwinConfigurations.$(hostname).pkgs.beads.version --raw 2>&1
    # nix build .#darwinConfigurations.$(hostname).pkgs.beads --print-build-logs 2>&1
    # nix path-info .#darwinConfigurations.TP95V9LWWL.pkgs.beads
    # To update source hash:
    # nix-prefetch-git \
    #   https://github.com/steveyegge/beads \
    #   0d99d15370030b953a8df0ea67cd3d1b845bb07b \
    #   | jq --raw-output '.hash'
    # To update vendorHash (recommended):
    # 1. Set: vendorHash = final.lib.fakeHash;
    # 2. Run: nix build .#darwinConfigurations.$(hostname).pkgs.beads
    # 3. Copy hash from error message
    # Alternative vendorHash method (may not work):
    # nix --extra-experimental-features 'nix-command flakes' run nixpkgs#nix-prefetch -- \
    #   '{ sha256 }: (builtins.getFlake "git+file://'$(pwd)'").darwinConfigurations.'$(hostname)'.pkgs.beads.goModules.overrideAttrs (_: { outputHash = sha256; })'
    # @upstream-issue https://github.com/NixOS/nixpkgs/pull/483469
    # beads = prev.beads.overrideAttrs (_old: rec {
    #   version = "0d99d15370030b953a8df0ea67cd3d1b845bb07b"; # v0.49.1
    #   src = prev.fetchFromGitHub {
    #     owner = "steveyegge";
    #     repo = "beads";
    #     rev = version;
    #     hash = "sha256-roOyTMy9nKxH2Bk8MnP4h2CDjStwK6z0ThQhFcM64QI=";
    #   };
    #   vendorHash = "sha256-YU+bRLVlWtHzJ1QPzcKJ70f+ynp8lMoIeFlm+29BNPE=";
    # });

    # Pin Microsoft Edge to last working build on Linux.
    # @upstream-issue https://github.com/NixOS/nixpkgs/pull/490349
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/492012
    # Overrides the package to use the previous stable 144.0.3719.115 version.
    microsoft-edge =
      let
        version = "144.0.3719.115";
      in
      prev.microsoft-edge.overrideAttrs (_old: {
        inherit version;
        src = final.fetchurl {
          url = "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_${version}-1_amd64.deb";
          hash = "sha256-HoV2D51zxewFwwu92efEDgohu1yJf1UyjekO3YWZqPc=";
        };
      });

    # Add kubelogin to AKS MCP server PATH for Azure AD authentication.
    # This allows kubectl to authenticate to AKS clusters using Azure AD.
    # @upstream-issue https://github.com/Azure/aks-mcp/issues/TBD
    aks-mcp-server = prev.aks-mcp-server.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ final.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/aks-mcp \
          --prefix PATH : ${final.lib.makeBinPath [ final.kubelogin ]}
      '';
    });

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };
}
