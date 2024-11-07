{ pkgs, lib, config, inputs, ... }:

{
  devenv.debug = true; # https://devenv.sh/reference/options/#devenvdebug
  devenv.flakesIntegration = true; # https://devenv.sh/reference/options/#devenvflakesintegration

  languages.nix.enable = true; # https://devenv.sh/reference/options/#languagesnixenable
  languages.nix.lsp.package = pkgs.nil; # https://devenv.sh/reference/options/#languagesnixlsppackage

  pre-commit.hooks = { # https://devenv.sh/reference/options/#pre-commithooks
    my-nixfmt-rfc-style = {
      enable = true;
      name = "my-nixfmt-rfc-style";
      description = "nixfmt-rfc-style";
      files = "\.nix$";
      entry = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
    };

    # Markdown
    markdownlint.enable = true;
    mdl.enable = true;
    mdsh.enable = true;

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
