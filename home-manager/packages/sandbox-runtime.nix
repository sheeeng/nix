{ lib, pkgs, ... }:
let
  # Sandbox Runtime (srt) by Anthropic
  # https://github.com/anthropic-experimental/sandbox-runtime
  # A lightweight sandboxing tool for enforcing filesystem and network
  # restrictions on arbitrary processes at the OS level.
  sandbox-runtime = pkgs.buildNpmPackage rec {
    pname = "sandbox-runtime";
    version = "0.0.32";

    src = pkgs.fetchFromGitHub {
      owner = "anthropic-experimental";
      repo = "sandbox-runtime";
      rev = "54ecea4d4717cd8c22bd111bd4461d5ed6cd603e"; # v0.0.32
      hash = "sha256-M1eFZJ3dScI61xaHMRnRr5jnXD4fmSRiSwsUph24OyQ=";
    };

    npmDepsHash = "sha256-7ohrHpsDNHgt/VraqyTLzmz84JLhRcKOZdk2M8Rul5E=";

    # The package needs to be built from TypeScript.
    npmBuildScript = "build";

    # Copy vendor directory after build (contains seccomp binaries).
    postBuild = "if [ -d vendor ]; then cp -r vendor dist/; fi";

    meta = {
      description = "Anthropic Sandbox Runtime - A lightweight sandboxing tool for enforcing filesystem and network restrictions";
      homepage = "https://github.com/anthropic-experimental/sandbox-runtime";
      license = lib.licenses.asl20;
      maintainers = [ ];
      mainProgram = "srt";
    };
  };
in
{
  home.packages =
    with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      # Required on Linux only.
      bubblewrap # https://search.nixos.org/packages?channel=unstable&type=packages&show=bubblewrap
      socat # https://search.nixos.org/packages?channel=unstable&type=packages&show=socat
    ]
    ++ [
      ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
      sandbox-runtime # Provides the `srt` command
    ];

  # Settings file for sandbox-runtime.
  # https://github.com/anthropic-experimental/sandbox-runtime#configuration
  home.file.".srt-settings.json".text = builtins.toJSON {
    network = {
      allowedDomains = [
        # GitHub
        "github.com"
        "*.github.com"
        "lfs.github.com"
        "api.github.com"
        "raw.githubusercontent.com"
        # npm
        "npmjs.org"
        "*.npmjs.org"
        "registry.npmjs.org"
        # PyPI
        "pypi.org"
        "*.pypi.org"
        "files.pythonhosted.org"
        # Nix
        "cache.nixos.org"
        "*.cachix.org"
      ];
      deniedDomains = [ ];
      allowUnixSockets = [ ];
      allowLocalBinding = false;
    };
    filesystem = {
      denyRead = [
        "~/.ssh"
        "~/.gnupg"
        "~/.aws/credentials"
        "~/.config/sops"
      ];
      allowWrite = [
        "."
        "/tmp"
      ];
      denyWrite = [
        ".env"
        ".env.local"
        "secrets/"
      ];
    };
    ignoreViolations = {
      "*" = [
        "/usr/bin"
        "/System"
      ];
    };
    enableWeakerNestedSandbox = false;
  };
}
