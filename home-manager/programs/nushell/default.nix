{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nufmt # https://search.nixos.org/packages?channel=unstable&show=nufmt
  ];

  programs.nushell = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
    package = pkgs.nushell; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.package
    # configDir = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.configDir
    configFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.configFile
    envFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.envFile
    environmentVariables = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.environmentVariables
    extraConfig =
      # Capture nushell's builtin open as nu-open before any platform alias
      # such as the macOS open = ^open below can shadow it. This alias is
      # harmless on Linux.
      ''
        alias nu-open = open

        # `flake` command family. Parent shows the available subcommands.
        def flake [] { help flake }

        # flake list lists inputs with short SHA and lock date read from
        # flake.lock. It uses nu-open so it works whether or not open is
        # aliased per platform.
        def "flake list" [path: string = "flake.lock"] {
          nu-open ''$path | from json | get nodes
          | transpose name node
          | where name != root
          | each {|r|
              let l = ''$r.node.locked?
              {
                name: ''$r.name
                type: (''$l.type? | default "")
                source: $"(''$l.owner? | default "")/(''$l.repo? | default "")"
                rev: (''$l.rev? | default "" | str substring 0..7)
                date: (if (''$l.lastModified? | is-not-empty) {
                  ''$l.lastModified * 1_000_000_000 | into datetime | format date "%Y-%m-%d"
                } else { "" })
              }
            }
          | sort-by name
        }

        # flake update updates flake.lock for all inputs, or only the named ones.
        def "flake update" [...inputs: string] {
          nix flake update ...''$inputs
        }

        # flake check evaluates and builds the flake's checks.
        def "flake check" [...args: string] {
          nix flake check ...''$args
        }

      ''
      + builtins.readFile ./show-github-copilot-usage.nu
      + pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
        # https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
        alias open = ^open
      ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraConfig
    extraEnv = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraEnv
    extraLogin = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.extraLogin
    loginFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.loginFile
    shellAliases.atuin-import = "with-env { HISTFILE: ($env.HISTFILE? | default '') } { atuin import auto }"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.shellAliases
  };
}
