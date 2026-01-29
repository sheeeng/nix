{ lib, pkgs, ... }:
{
  # Sandbox Runtime (srt) by Anthropic
  # https://github.com/anthropic-experimental/sandbox-runtime
  # Install via: npm install -g @anthropic-ai/sandbox-runtime

  home.packages =
    with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      # Required on Linux only.
      bubblewrap # https://search.nixos.org/packages?channel=unstable&type=packages&show=bubblewrap
      socat # https://search.nixos.org/packages?channel=unstable&type=packages&show=socat
    ]
    ++ [
      ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
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
