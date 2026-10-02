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

    # Embedded Beads otherwise uses an address that GitHub rejects under email
    # privacy protection when Dolt history is synchronized through Git.
    beads = prev.beads.overrideAttrs (old: {
      # Several upstream tests race during temporary directory cleanup on Darwin.
      doCheck = (old.doCheck or true) && !final.stdenv.hostPlatform.isDarwin;
      postPatch = (old.postPatch or "") + ''
        substituteInPlace internal/storage/embeddeddolt/open.go \
          --replace-fail 'commitEmail = "beads@local"' \
          'commitEmail = "305414+sheeeng@users.noreply.github.com"'
      '';
    });

    # Workaround for a Rust/Zig mixed-toolchain linking conflict. The Rust
    # binary links against the Zig-built libghostty-vt static library, and
    # the default linker, ld.bfd, fails on Linux with ".eh_frame_hdr refers to
    # overlapping FDEs" because of mismatched unwind data between the two
    # toolchains. lld tolerates that mismatch.
    #
    # On macOS, libghostty-vt.a also bundles a compiler_rt.o object that
    # duplicates symbols already in Rust's libcompiler_builtins, which ld64.lld
    # treats as a fatal error. The linker wrapper strips compiler_rt.o from
    # libghostty-vt.a immediately before each link invocation, eliminating
    # that conflict while keeping lld for its mixed unwind-data tolerance.
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/TBD
    herdr =
      let
        linkerWrapper = final.writeShellScript "herdr-linker-wrapper" ''
          for arg in "$@"; do
            if [[ "$arg" == *libghostty-vt.a ]]; then
              ar d "$arg" compiler_rt.o 2>/dev/null || true
              break
            fi
          done
          exec ${final.stdenv.cc}/bin/cc -fuse-ld=lld "$@"
        '';
      in
      prev.herdr.overrideAttrs (
        old:
        {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.lld ];
        }
        // (
          if final.stdenv.hostPlatform.isDarwin then
            {
              env = (old.env or { }) // {
                CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER = "${linkerWrapper}";
              };
            }
          else
            {
              env = (old.env or { }) // {
                RUSTFLAGS = "-C link-arg=-fuse-ld=lld";
              };
            }
        )
      );

    # Override nixpkgs terraform with the official HashiCorp binary, pinned via
    # .terraform-version and fetched from the HashiCorp release endpoint.
    terraform = final.callPackage ../pkgs/terraform.nix { };

    # Workaround for VSCode "Operation not permitted" issue.
    # @upstream-issue https://github.com/nix-darwin/nix-darwin/issues/1315#issuecomment-2629517646
    vscode = prev.vscode.overrideAttrs (old: {
      installPhase = "whoami\n" + old.installPhase;
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

    # Skip the nested-sandbox test that conflicts with the Nix build sandbox.
    nono = prev.nono.overrideAttrs (old: {
      checkFlags = (old.checkFlags or [ ]) ++ [
        "--skip=why_self_reports_active_profile_deny_before_covering_allow"
      ];
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
