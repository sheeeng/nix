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

    # Override nixpkgs terraform with the official HashiCorp binary, pinned via
    # .terraform-version and fetched from the HashiCorp release endpoint.
    terraform = final.callPackage ../pkgs/terraform.nix { };

    # Workaround for VSCode "Operation not permitted" issue.
    # @upstream-issue https://github.com/nix-darwin/nix-darwin/issues/1315#issuecomment-2629517646
    # Workaround for VS Code 1.129.1: @vscode/ripgrep-universal moved back to
    # node_modules.asar.unpacked but nixpkgs assumes node_modules for >= 1.94.0.
    vscode = prev.vscode.overrideAttrs (old: {
      installPhase = "whoami\n" + old.installPhase;
      postPatch =
        builtins.replaceStrings
          [ "node_modules/@vscode/ripgrep" ]
          [ "node_modules.asar.unpacked/@vscode/ripgrep" ]
          (old.postPatch or "");
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

    # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/TBD is resolved upstream.
    # kubernetes-helm-4.2.0 checkPhase calls substitute() on
    # cmd/helm/dependency_build_test.go which no longer exists in the source.
    kubernetes-helm = prev.kubernetes-helm.overrideAttrs (_old: {
      doCheck = false;
    });

    # Disable flaky performance test in jsonpath-python that fails in the Nix sandbox.
    # The test_cache_hit_rate test compares timing which is unreliable in sandboxed builds.
    python313Packages = prev.python313Packages.overrideScope (
      _pyFinal: pyPrev: {
        jsonpath-python = pyPrev.jsonpath-python.overridePythonAttrs (old: {
          disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [
            "tests/test_performance.py"
          ];
        });
      }
    );

    # @upstream-issue https://github.com/NixOS/nixpkgs/pull/555604
    # Backport the Darwin tmux build fix from nixpkgs pull request 555604.
    # Remove this overlay after the change reaches nixos-unstable.
    tmux = prev.tmux.overrideAttrs (old: {
      buildInputs =
        (old.buildInputs or [ ])
        ++ final.lib.optionals final.stdenv.hostPlatform.isDarwin [ final.jemalloc ];
      configureFlags =
        (old.configureFlags or [ ])
        ++ final.lib.optionals final.stdenv.hostPlatform.isDarwin [ "--enable-jemalloc" ];
    });

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };
}
