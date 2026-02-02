{ lib, pkgs, ... }:
{
  # Sandbox Runtime (srt) dependencies and package.
  # Package defined in overlays/default.nix, available as pkgs.sandbox-runtime.
  # https://github.com/anthropic-experimental/sandbox-runtime
  home.packages =
    (
      with pkgs;
      lib.optionals stdenv.isLinux [
        # Required on Linux only.
        bubblewrap # https://search.nixos.org/packages?channel=unstable&type=packages&show=bubblewrap
        socat # https://search.nixos.org/packages?channel=unstable&type=packages&show=socat
      ]
    )
    ++ (with pkgs; [
      ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
      sandbox-runtime # Provides the 'srt' command.
    ]);

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
        # Node
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
        # Go
        "proxy.golang.org"
        "sum.golang.org"
        # Rust
        "crates.io"
        "*.crates.io"
        "static.crates.io"
        # Ruby
        "rubygems.org"
        "*.rubygems.org"
      ];
      deniedDomains = [ ];
      allowUnixSockets = [ ];
      allowLocalBinding = false;
    };
    filesystem = {
      # Read restrictions (deny-only pattern) - all reads allowed by default.
      denyRead = [
        "~/.ssh"
        "~/.gnupg"
        "~/.aws/credentials"
        "~/.config/sops"
        "~/.config/age"
      ];
      # Write restrictions (allow-only pattern) - all writes denied by default.
      allowWrite = [
        "."
        "src/"
        "test/"
        "/tmp"
      ];
      # Deny write within allowed paths (takes precedence over allowWrite).
      denyWrite = [
        ".env"
        ".env.local"
        ".env.production"
        "secrets/"
        "config/production.json"
      ];
    };
    # Ignore violations for specific commands at specific paths.
    ignoreViolations = {
      "*" = [
        "/usr/bin"
        "/System"
      ];
      "git push" = [ "/usr/bin/nc" ];
      "npm" = [ "/private/tmp" ];
    };
    # Default search depth for mandatory deny paths on Linux.
    mandatoryDenySearchDepth = 3;
    # Enable weaker sandbox mode for Docker environments (default: false).
    enableWeakerNestedSandbox = false;
  };
}
