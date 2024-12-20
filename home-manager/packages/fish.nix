{ pkgs, ... }:
let
in
{
  programs = {
    fish = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
      package = pkgs.fish; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.package
      shellAliases = with pkgs; {
        nb = "nix build";
        nd = "nix develop";
        nf = "nix flake";
        nr = "nix run";
        ns = "nix search";
        garbage = "nix-collect-garbage --delete-old";
        installed = "nix-env --query --installed";

        grep = "grep --color=auto";
        cloc = "tokei";
        dk = "docker";
        k = "kubectl";
        dc = "docker-compose";
        find = "fd";
        # du = "ncdu --color dark -rr -x"; # TODO: https://github.com/NixOS/nixpkgs/issues/290512

        v = "lvim";
        vi = "nvim";
        vim = "nvim";

        ".." = "cd ..";
        l = "${pkgs.eza}/bin/eza -lahG";
        ls = "${pkgs.eza}/bin/eza";
        lst = "${pkgs.eza}/bin/eza -T";
        la = "${pkgs.eza}/bin/eza -lah";
        ll = "${pkgs.eza}/bin/eza -l -g --icons";
        md = "mkdir --parents";
        cx = "chmod +x";
        # cat = "${pkgs.bat}/bin/bat"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.

        root = "cd (${pkgs.gitAndTools.git}/bin/git rev-parse --show-cdup)";
        gpom = "${pkgs.gitAndTools.git}/bin/git push origin master";
        gpr = "${pkgs.gitAndTools.git}/bin/git pull --rebase";
        g = "${pkgs.gitAndTools.git}/bin/git";
        r = "${pkgs.ranger}/bin/ranger";

        ci = "code-insiders";

        R = "radian";
        localip = "ipconfig getifaddr en0";
        tb = "toggle-background";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.shellAliases
      shellInit = ''
        # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
        set -U fish_term24bit 1
        fish_vi_key_bindings
      ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.shellInit
      interactiveShellInit = ''
        set -g fish_greeting ""
        ${pkgs.thefuck}/bin/thefuck --alias | source

        # Set Fish colors that aren't dependant the `$term_background`.
        set -g fish_color_quote        cyan      # color of commands
        set -g fish_color_redirection  brmagenta # color of IO redirections
        set -g fish_color_end          blue      # color of process separators like ';' and '&'
        set -g fish_color_error        red       # color of potential errors
        set -g fish_color_match        --reverse # color of highlighted matching parenthesis
        set -g fish_color_search_match --background=yellow
        set -g fish_color_selection    --reverse # color of selected text (vi mode)
        set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
        set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
        set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command
      ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.interactiveShellInit
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
          };
        }

        # oh-my-fish plugins are stored in their own repositories, which
        # makes them simple to import into home-manager.
        {
          name = "fasd";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-fasd";
            rev = "98c4c729780d8bd0a86031db7d51a97d55025cf5";
            sha256 = "sha256-8JASaNylXAGnWd2IV88juk73b8eJJlVrpyiRZUwHGFQ=";
          };
        }
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins
    };
  };

  # https://github.com/yrashk/nix-home/blob/55fc51e1954184e0f5d9a00916963e2ce8b56d21/home.nix#L293-L312
  # home.file = {
  #   ".config/fish/config.fish" = {
  #     text = ''
  #       set -x GPG_TTY (tty)
  #       gpg-connect-agent updatestartuptty /bye > /dev/null
  #       set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
  #       set -x EDITOR vim
  #       set -x TERM xterm-256color
  #       if status --is-interactive
  #         set -g fish_user_abbreviations
  #         abbr h 'home-manager switch'
  #         abbr r 'sudo nixos-rebuild switch'
  #         abbr gvim vim -g
  #         abbr mc 'env TERM=linux mc'
  #         abbr tmux 'tmux -2'
  #       end
  #       function __fish_command_not_found_handler --on-event fish_command_not_found
  #         command-not-found $argv[1]
  #       end
  #     '';
  #   };
  # };
}
