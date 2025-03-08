# _: { }
{ pkgs, ... }:
{
  devenv.debug = false; # https://devenv.sh/reference/options/#devenvdebug
  devenv.flakesIntegration = true; # https://devenv.sh/reference/options/#devenvflakesintegration

  dotenv = {
    enable = true; # https://devenv.sh/reference/options/#dotenvenable
    disableHint = false; # https://devenv.sh/reference/options/#dotenvdisablehint
    filename = [ ".env" ]; # https://devenv.sh/reference/options/#dotenvfilename
  };

  languages.nix = {
    enable = true; # https://devenv.sh/reference/options/#languagesnixenable
    lsp.package = pkgs.nil; # https://devenv.sh/reference/options/#languagesnixlsppackage
  };

  # https://github.com/cachix/devenv/blob/741e23a22f3dc9e53075be3eaa795ea9ed6f5129/examples/go/devenv.nix
  languages.go = {
    enable = true;
  };

  # https://github.com/cachix/devenv/blob/741e23a22f3dc9e53075be3eaa795ea9ed6f5129/examples/javascript/devenv.nix
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs-slim;
    npm = {
      enable = true;
      install.enable = true;
    };
  };

  # https://github.com/cachix/devenv/blob/741e23a22f3dc9e53075be3eaa795ea9ed6f5129/examples/python/devenv.nix
  languages.python = {
    enable = true;
    venv.enable = true;
    venv.requirements = ./requirements-development.txt;
  };

  # https://github.com/cachix/devenv/blob/741e23a22f3dc9e53075be3eaa795ea9ed6f5129/examples/rust/devenv.nix
  languages.rust = {
    enable = true;
    channel = "nightly"; # https://devenv.sh/reference/options/#languagesrustchannel
    components = [
      "rustc"
      "cargo"
      "clippy"
      "rustfmt"
      "rust-analyzer"
    ];
  };

  enterShell = ''
    echo "Activate https://devenv.sh/ developer environment."
    echo "Nix '$(nix --version | awk '{print $3}')' located in '$(which nix)'."
    echo "Atuin '$(atuin --version | awk '{print $2}')' located in '$(which atuin)'."
    echo "Cargo '$(cargo --version | awk '{print $2}')' located in '$(which cargo)'."
    echo "Devenv '$(devenv version | awk '{print $2}')' located in '$(which devenv)'."
    echo "Direnv '$(direnv --version)' located in '$(which direnv)'."
    echo "Go '$(go version | { read _ _ v _; echo ''${v#go}; })' located in '$(which go)'."
    echo "Node '$(node --version)' located in '$(which node)'."
    echo "Npm '$(npm --version)' located in '$(which npm)'."
    echo "Python '$(python --version | awk '{print $2}')' located in '$(which python)'."
    echo ""
  '';

  pre-commit = {
    enabledPackages = [ ]; # https://devenv.sh/reference/options/#pre-commitenabledpackages
    # TODO: Error: The option `git-hooks.package' is defined multiple times while it's expected to be unique.
    # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    # package = pkgs.pre-commit; # https://devenv.sh/reference/options/#pre-commitpackage
    addGcRoot = false; # https://devenv.sh/reference/options/#pre-commitaddgcroot
    configPath = "devenv/.pre-commit-config.yaml"; # https://devenv.sh/reference/options/#pre-commitconfigpath
    default_stages = [ "pre-commit" ]; # https://devenv.sh/reference/options/#pre-commitdefault_stages
    excludes = [ ]; # https://devenv.sh/reference/options/#pre-commitexcludes
    gitPackage = pkgs.gitMinimal; # https://devenv.sh/reference/options/#pre-commitgitpackage
    hooks = {
      # Nix
      alejandra = {
        enable = false;
        fail_fast = true;
        excludes = [ "vendor/" ];
      };
      deadnix.enable = true;
      flake-checker.enable = false; # TODO: Error: Invalid("no nixpkgs dependency found for specified key: nixpkgs")
      my-nixfmt-rfc-style = {
        enable = true; # https://devenv.sh/reference/options/#pre-commithooksnameenable
        package = pkgs.nixfmt-rfc-style; # https://devenv.sh/reference/options/#pre-commithooksnamepackage
        after = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnameafter
        always_run = false; # https://devenv.sh/reference/options/#pre-commithooksnamealways_run
        args = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnameargs
        before = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnamebefore
        description = "nixfmt-rfc-style"; # https://devenv.sh/reference/options/#pre-commithooksnamedescription
        entry = "${pkgs.nixfmt-rfc-style}/bin/nixfmt"; # https://devenv.sh/reference/options/#pre-commithooksnameentry
        exclude_types = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnameexclude_types
        excludes = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnameexcludes
        extraPackages = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnameextrapackages
        fail_fast = false; # https://devenv.sh/reference/options/#pre-commithooksnamefail_fast
        files = "\\.nix$"; # https://devenv.sh/reference/options/#pre-commithooksnamefiles
        language = "system"; # https://devenv.sh/reference/options/#pre-commithooksnamelanguage
        name = "my-nixfmt-rfc-style"; # https://devenv.sh/reference/options/#pre-commithooksnamename
        pass_filenames = true; # https://devenv.sh/reference/options/#pre-commithooksnamepass_filenames
        require_serial = false; # https://devenv.sh/reference/options/#pre-commithooksnamerequire_serial
        stages = [ "pre-commit" ]; # https://devenv.sh/reference/options/#pre-commithooksnamestages
        types = [ "file" ]; # https://devenv.sh/reference/options/#pre-commithooksnametypes
        types_or = [ ]; # https://devenv.sh/reference/options/#pre-commithooksnametypes_or
        verbose = false; # https://devenv.sh/reference/options/#pre-commithooksnameverbose
      };
      nil.enable = true;
      nixfmt-classic.enable = false;
      nixfmt-rfc-style.enable = true;
      nixpkgs-fmt.enable = false;
      statix.enable = false;

      # Haskell
      cabal-fmt.enable = true;
      fourmolu.enable = true;
      hindent.enable = true;
      hlint.enable = true;
      hpack.enable = true;
      ormolu.enable = true;
      stylish-haskell.enable = true;

      # C/C++/C#/ObjC
      clang-format.enable = true;
      clang-tidy.enable = true;

      # Python
      autoflake.enable = true;
      black.enable = true;
      check-builtin-literals.enable = true;
      check-docstring-first.enable = true;
      check-python.enable = true;
      fix-encoding-pragma.enable = true;
      flake8.enable = true;
      isort.enable = true;
      mypy.enable = true;
      name-tests-test.enable = true;
      pylint.enable = true;
      pyright.enable = true;
      python-debug-statements.enable = true;
      poetry-check.enable = true;
      pyupgrade.enable = true;
      ruff.enable = true;
      ruff-format.enable = true;
      sort-requirements-txt.enable = true;

      # Rust
      cargo-check.enable = true;
      clippy.enable = true;
      rustfmt.enable = true;

      # Go
      gofmt.enable = true;
      golangci-lint = {
        enable = true;
        pass_filenames = false;
      };
      gotest.enable = true;
      govet = {
        enable = true;
        pass_filenames = false;
      };
      revive.enable = true;
      staticcheck.enable = true;

      # Shell
      bats.enable = true;
      beautysh.enable = false;
      shellcheck.enable = true;
      shfmt = {
        enable = true;
        entry = "${pkgs.shfmt}/bin/shfmt --indent 2 --space-redirects --diff --simplify --list";
        files = "\\.sh$";
      };

      # Lua
      luacheck.enable = true;
      lua-ls.enable = true;
      stylua.enable = true;

      # Markdown
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

      # Terraform
      terraform-format.enable = true;
      terraform-validate.enable = true;
      tflint.enable = true;

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

      conform.enable = true;

      # Spell
      # cspell.enable = true;
      # hunspell.enable = true;
      # typos.enable = true;

      # https://github.com/tweag/plutus/blob/ae0138a2ff08648db92ee1cdecbd005f5f9f27a8/shell.nix#L47-L52
      # png-optimization = {
      #   enable = true;
      #   name = "png-optimization";
      #   description = "Ensure that PNG files are optimized";
      #   entry = "${pkgs.optipng}/bin/optipng";
      #   files = "\\.png$";
      # };
    }; # https://devenv.sh/reference/options/#pre-commithooks
  }; # https://devenv.sh/reference/options/#pre-commit
}
