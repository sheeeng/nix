{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs.mdsh.enable = true;

  programs = {
    # keep-sorted start block=yes newline_separated=no case=no sticky_comments=yes
    deadnix.enable = true;
    just.enable = true;
    keep-sorted.enable = true;
    nixfmt = {
      enable = pkgs.stdenv.hostPlatform.system != "riscv64-linux";
      package = pkgs.nixfmt-rfc-style;
      includes = [ "*.nix" ];
      strict = true;
    };
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
    rustfmt.enable = true;
    shellcheck = {
      enable = pkgs.stdenv.hostPlatform.system != "riscv64-linux";
      includes = [
        "*.bash"
        "*.bats"
        "*.sh"
      ];
    };
    shfmt = {
      enable = true;
      indent_size = 2;
      includes = [
        "*.bash"
        "*.bats"
        "*.sh"
      ];
    };
    statix.enable = true;
    taplo = {
      enable = true;
      settings = {
        include = [ "*.toml" ];
      };
    };
    yamlfmt = {
      enable = true;
      settings = {
        formatter = {
          disallow_anchors = false;
          eof_newline = true;
          include_document_start = false;
          indent = 2;
          line_endings = "lf";
          max_line_length = 0;
          retain_line_breaks = true;
          retain_line_breaks_single = true;
          scan_folded_as_literal = true;
          trim_trailing_whitespace = true;
        };
      };
    };
    # keep-sorted end
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

  settings.formatter = {
    # keep-sorted start block=yes newline_separated=no case=no sticky_comments=yes
    keep-sorted = {
      options = [
        "--mode"
        "fix"
      ];
    };
    shfmt = {
      options = [
        "--indent"
        "2"
        "--space-redirects"
        "--binary-next-line"
        "--diff"
        "--simplify"
        "--list"
        "--write"
      ];
    };
    # Using opentofu as the formatter for Terraform files, as official terraform binaries are not pre-built due to restrictive license.
    # Building terraform from source is not time-efficient for CI runs.
    terraform = {
      command = "${pkgs.opentofu}/bin/tofu"; # https://search.nixos.org/packages?channel=unstable&type=packages&show=opentofu
      options = [ "fmt" ];
      includes = [
        "*.tf"
        "*.tfvars"
        "*.tftest.hcl"
      ];
      excludes = [ ];
    };
    yamllint = {
      command = "${pkgs.yamllint}/bin/yamllint";
      includes = [
        "*.yaml"
        "*.yml"
      ];
    };
    # keep-sorted end
  };
}
