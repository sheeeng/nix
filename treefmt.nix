# https://github.com/rosenpass/rosenpass/blob/cdf6e8369f329b9c535c113d5e146dc3d2b1f320/treefmt.nix

{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs.mdsh.enable = true;

  programs = {
    nixfmt = {
      enable = pkgs.hostPlatform.system != "riscv64-linux";
      package = pkgs.nixfmt-rfc-style;
    };

    shfmt = {
      enable = true;
      indent_size = 2;
    };
    shellcheck = {
      enable = pkgs.hostPlatform.system != "riscv64-linux";
    };

    deadnix.enable = true;
    statix.enable = true;

    prettier = {
      enable = true;
      includes = [
        "*.css"
        "*.html"
        "*.js"
        "*.yaml"
        "*.yml"
      ];
      excludes = [
        "*.json"
        "*.json5"
        "*.lock"
        "*.md"
        "*.mdx"
        "flake.lock"
        ".github/**/*.md"
      ];
      settings = {
        bracketSpacing = true;
        printWidth = 120; # More reasonable print width for general files
        tabWidth = 2;
        trailingComma = "none";
        useTabs = false;
      };
    };

    yamlfmt = {
      enable = true;
      settings = {
        formatter = {
          retain_line_breaks_single = true;
        };
      };
    };

    taplo = {
      enable = true;
      settings = {
        include = [ "*.toml" ];
      };
    };

    just.enable = true;

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
