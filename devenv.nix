{ pkgs, ... }:
{
  devenv.debug = false; # https://devenv.sh/reference/options/#devenvdebug
  devenv.flakesIntegration = true; # https://devenv.sh/reference/options/#devenvflakesintegration

  languages.nix.enable = true; # https://devenv.sh/reference/options/#languagesnixenable
  languages.nix.lsp.package = pkgs.nil; # https://devenv.sh/reference/options/#languagesnixlsppackage

  pre-commit.hooks = {
    # https://devenv.sh/reference/options/#pre-commithooks
    # Markdown
    markdownlint = {
      enable = true;
      settings.configuration = {
        MD013.line_length = 512;
      };
    };
    mdl.enable = true;
    mdl.entry = "${pkgs.mdl}/bin/mdl --style .mdlrc.rb";
    mdsh.enable = true;

    # Nix
    alejandra = {
      enable = false;
      fail_fast = true;
      excludes = [ "vendor/" ];
    };
    deadnix.enable = true;
    flake-checker.enable = true;
    nil.enable = true;
    nixfmt-classic.enable = false;
    nixfmt-rfc-style.enable = true;
    nixpkgs-fmt.enable = false;
    statix.enable = true;

    # YAML
    check-yaml.enable = true;
    sort-simple-yaml.enable = true;
    yamlfmt.enable = true;
    yamllint.enable = true;

    # TOML
    check-toml.enable = true;
    taplo.enable = true;

    # JSON
    check-json.enable = true;
    pretty-format-json.enable = true;
  };
}
# {
#   # https://devenv.sh/basics/
#   env.GREET = "devenv";
#   # https://devenv.sh/packages/
#   packages = [ pkgs.git ];
#   # https://devenv.sh/languages/
#   # languages.rust.enable = true;
#   # https://devenv.sh/processes/
#   # processes.cargo-watch.exec = "cargo-watch";
#   # https://devenv.sh/services/
#   # services.postgres.enable = true;
#   # https://devenv.sh/scripts/
#   scripts.hello.exec = ''
#     echo hello from $GREET
#   '';
#   enterShell = ''
#     hello
#     git --version
#   '';
#   # https://devenv.sh/tasks/
#   # tasks = {
#   #   "myproj:setup".exec = "mytool build";
#   #   "devenv:enterShell".after = [ "myproj:setup" ];
#   # };
#   # https://devenv.sh/tests/
#   enterTest = ''
#     echo "Running tests"
#     git --version | grep --color=auto "${pkgs.git.version}"
#   '';
#   # https://devenv.sh/pre-commit-hooks/
#   # pre-commit.hooks.shellcheck.enable = true;
#   # See full reference at https://devenv.sh/reference/options/
# }
