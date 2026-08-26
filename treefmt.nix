{ pkgs, lib, ... }:
{
  projectRootFile = "flake.nix";

  settings = {
    formatter = {
      # keep-sorted start block=yes newline_separated=no case=no sticky_comments=yes
      deadnix = {
        command = "${lib.getExe pkgs.deadnix}";
        includes = [ "*.nix" ];
        excludes = [ ];
        options = [ "--edit" ];
        settings = { };
      };
      keep-sorted = {
        command = "${lib.getExe pkgs.keep-sorted}";
        includes = [ "*" ];
        excludes = [ ];
        options = [
          "--mode"
          "fix"
        ];
        settings = { };
      };
      nixfmt = {
        command = "${lib.getExe pkgs.nixfmt}";
        includes = [ "*.nix" ];
        excludes = [ ];
        options = [
          "--indent"
          "2"
        ];
        settings = { };
      };
      prettier = {
        command = "${lib.getExe pkgs.prettier}";
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
          "*.lock.yaml"
          "*.lock.yml"
          "*.md"
          "*.mdx"
          "flake.lock"
        ];
        options = [
          "--write"
          "--bracket-spacing"
          "--print-width=200"
          "--tab-width=2"
          "--trailing-comma=none"
          "--use-tabs=false"
        ];
        settings = { };
      };
      rustfmt = {
        command = "${lib.getExe pkgs.rustfmt}";
        includes = [ "*.rs" ];
        excludes = [ ];
        options = [ ];
        settings = { };
      };
      shellcheck = {
        command = "${lib.getExe pkgs.shellcheck}";
        includes = [
          "*.bash"
          "*.bats"
          "*.sh"
        ];
        excludes = [ ];
        options = [ ];
        settings = { };
      };
      shfmt = {
        command = "${lib.getExe pkgs.shfmt}";
        includes = [
          "*.bash"
          "*.bats"
          "*.sh"
        ];
        excludes = [ ];
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
        settings = { };
      };
      taplo = {
        command = "${lib.getExe pkgs.taplo}";
        includes = [ "*.toml" ];
        excludes = [ ];
        options = [ "format" ];
        settings = { };
      };
      # Use OpenTofu as the formatter for Terraform files. The official Terraform
      # binary is installed separately from the HashiCorp release endpoint.
      terraform = {
        command = "${lib.getExe pkgs.opentofu}"; # https://search.nixos.org/packages?channel=unstable&type=packages&show=opentofu
        includes = [
          "*.tf"
          "*.tfvars"
          "*.tftest.hcl"
        ];
        excludes = [ ];
        options = [ "fmt" ];
        settings = { };
      };
      # keep-sorted end
    };
    global.excludes = [
      "*.lock"
      "*.patch"
      "LICENSE*"
    ];
  };
}
