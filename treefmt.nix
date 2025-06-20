# https://github.com/rosenpass/rosenpass/blob/cdf6e8369f329b9c535c113d5e146dc3d2b1f320/treefmt.nix

{ lib, pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
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
        "*.toml"
        "*.yaml"
        "*.yml"
      ];
      excludes = [
        "*.lock"
      ];
      settings = {
        plugins = [
          "${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules/prettier-plugin-toml/lib/index.js"
        ];
      };
    };

    yamlfmt = {
      command = "${lib.getExe pkgs.yamlfmt}";
      options = [ "-formatter=retain_line_breaks_single=true" ];
      includes = [
        "*.yaml"
        "*.yml"
      ];
    };

    deadnix.enable = true;
    just.enable = true;
    nixfmt.enable = true;
    rustfmt.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    statix.enable = true;
  };
}
