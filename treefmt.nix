# https://github.com/rosenpass/rosenpass/blob/cdf6e8369f329b9c535c113d5e146dc3d2b1f320/treefmt.nix

{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs.mdsh.enable = true;

  programs = {
    # Nix formatting
    nixfmt = {
      enable = pkgs.hostPlatform.system != "riscv64-linux";
      package = pkgs.nixfmt-rfc-style;
    };

    # Shell formatting
    shfmt = {
      enable = true;
      indent_size = 2;
    };
    shellcheck = {
      enable = pkgs.hostPlatform.system != "riscv64-linux";
    };

    # Nix linting
    deadnix.enable = true;
    statix.enable = true;

    # General formatting
    prettier = {
      enable = true;
      includes = [
        "*.css"
        "*.html"
        "*.js"
        "*.json"
        "*.json5"
        "*.md"
        "*.mdx"
        "*.yaml"
        "*.yml"
      ];
      excludes = [
        "*.lock"
        "flake.lock"
      ];
    };

    # YAML formatting
    yamlfmt = {
      enable = true;
      settings = {
        formatter = {
          retain_line_breaks_single = true;
        };
      };
    };

    # TOML formatting (alternative to prettier-plugin-toml)
    taplo = {
      enable = true;
      settings = {
        include = [ "*.toml" ];
      };
    };

    # Justfile formatting
    just.enable = true;

    # Rust formatting (if you have Rust code)
    rustfmt.enable = true;
  };

  settings = {
    global.excludes = [
      "*.lock"
      "*.patch"
      "LICENSE*"
      "archive/**"
      ".github/**/*.md"
    ];
  };
}
