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

    # opencode's node_modules fixed-output derivation bundles many packages that
    # ship prebuilt Windows binaries, including the 7zip-bin package's
    # win/{x64,ia32,arm64}/7za.exe. On this managed Mac, Microsoft Defender for
    # Endpoint blocks reading those .exe files during the installPhase copy
    # ("cp: ... Operation not permitted"), so the copy omits whichever file
    # Defender happens to hold at that instant. Because Defender's timing is not
    # deterministic, the set of omitted files varies between builds, the output
    # hashes to a different value each time, and the fixed-output hash check
    # fails. Defender's Threat and Vulnerability Management also quarantines the
    # vulnerable 7za.exe (EUS:Win32/TvmWarn) once it lands in the store path,
    # which invalidates the cached output and forces another nondeterministic
    # rebuild.
    #
    # Fix: delete every bundled Windows executable in postInstall so the output
    # no longer depends on Defender. Only 7za.exe has been flagged so far, but
    # every .exe is a Windows portable executable that cannot run on macOS, so
    # removing all of them leaves nothing for Defender to quarantine and makes
    # the result reproducible regardless of which files Defender flags next.
    # find -delete unlinks each entry without reading it, so Defender's read
    # block does not stop it. Darwin-only: Linux keeps the stock hash and its
    # binary-cache hit.
    # NOTE: no cache exists for the custom hash, so node_modules builds from
    # source once (~30 min on this device) per opencode version bump, then
    # stays in the store.
    # @upstream-issue https://github.com/anomalyco/opencode/issues/8029
    opencode =
      if prev.stdenv.hostPlatform.isDarwin then
        prev.opencode.overrideAttrs (old: {
          node_modules = old.node_modules.overrideAttrs (previousAttributes: {
            postInstall = (previousAttributes.postInstall or "") + ''
              find "$out" -type f -name '*.exe' -delete
            '';
            outputHash = "sha256-gb1vgLGiK56A9Xtg71d2J9ct8TJAjDg1A7cOUx0v3cA=";
          });
        })
      else
        prev.opencode;

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };
}
