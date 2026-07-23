# TODO: https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/shells.nix

# https://github.com/jonringOer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/bash.nix

{
  config,
  lib,
  pkgs,
  ...
}:

let
  bashConfiguration = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enable
    enableCompletion = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enableCompletion
    enableVteIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enableVteIntegration
    package = pkgs.bashInteractive; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.package
    bashrcExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.bashrcExtra
    historyControl = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.historyControl
    historyFile = "${config.xdg.dataHome}/.bash_history"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.historyFile
    historyFileSize = 1000000; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.historyIgnore
    historyIgnore = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.historySize
    initExtra = ''
      set -o vi  # enable vi-like control
      # export EDITOR=nvim # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.

      # Fix color codes in man pages. Why GNU hates sane defaults, we will never know
      export export GROFF_NO_SGR=1

      # not sure why this stopped working, but it's annoying
      git_prompt_path=${pkgs.git}/share/bash-completion/completions/git-prompt.sh
      [ -f "$git_prompt_path" ] && source "$git_prompt_path"
      git_compl_path=${pkgs.git}/share/bash-completion/completions/git
      [ -f "$git_compl_path" ] && source "$git_compl_path"

      RED="\033[0;31m"
      GREEN="\033[0;32m"
      NO_COLOR="\033[m"
      BLUE="\033[0;34m"

      git_prompt_path=${pkgs.git}/share/bash-completion/completions/git-prompt.sh
      if [ -f "$git_prompt_path" ] && ! command -v __git_ps1 > /dev/null; then
        source "$git_prompt_path"
      fi

      prompt_symbol=$(test "$UID" == "0" && echo "$RED#$NO_COLOR" || echo "$")
      export PS1="$RED[\t] $GREEN\u@\h $NO_COLOR\w$BLUE\`__git_ps1\`$NO_COLOR\n$prompt_symbol "

      export PATH=$PATH:~/.cargo/bin:~/.config/nixpkgs/bin

      # bat utilities
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      if [[ "$OSTYPE" == "darwin"* ]]; then
        # on mac, give support to wombat256 colors
        export TERM=xterm-256color
      fi

      if [ -e "$HOME"/.config/git_token ]; then
          export GITHUB_API_TOKEN=$(cat "$HOME"/.config/git_token)
          export GITHUB_TOKEN=$(cat "$HOME"/.config/git_token)
      fi

      if [ -n "$VIRTUAL_ENV" ]; then
        env=$(basename "$VIRTUAL_ENV")
        export PS1="($env) $PS1"
      fi

      if [ -n "$IN_NIX_SHELL" ]; then
        export PS1="(nix-shell) $PS1"
      fi

      if [ ! -z "$WSL_DISTRO_NAME" -a -d ~/.nix-profile/etc/profile.d ]; then
        for f in ~/.nix-profile/etc/profile.d/* ; do
          source $f
        done
      fi

      editline() { nvim ''${1%%:*} +''${1##*:}; }
      cd() { builtin cd "$@" && ls . ; }
      # Change dir with Fuzzy finding
      cf() {
        dir=$(${lib.getExe pkgs.fd} . ''${1:-/home/jon/} --type d 2>/dev/null | fzf)
        cd "$dir"
      }
      # Change dir in Nix store
      cn() {
        dir=$(${lib.getExe pkgs.fd} . '/nix/store/' --maxdepth 1 --type d 2>/dev/null | fzf)
        cd "$dir"
      }
      # search Files and Edit
      fe() {
        rg --files ''${1:-.} | fzf --preview 'bat -f {}' | xargs $EDITOR
      }
      # Search content and Edit
      se() {
        fileline=$(rg -n ''${1:-.} | fzf | awk '{print $1}' | sed 's/.$//')
        $EDITOR ''${fileline%%:*} +''${fileline##*:}
      }

      # Search git log, preview shows subject, body, and diff
      fl() {
        git log --oneline --color=always | fzf --ansi --preview="echo {} | cut -d ' ' -f 1 | xargs -I @ sh -c 'git log --pretty=medium -n 1 @; git diff @^ @' | bat --color=always" | cut -d ' ' -f 1 | xargs git log --pretty=short -n 1
      }

      nix_deps() {
        nix-store -qR "$1" | xargs du -hd0 | sort -rh
      }

      nbfkg() {
        nix build -f . --keep-going $@
      }

      battail() {
        tail -f $@ | bat --paging=never -l log
      }

      h() {
        cd ~
      }

      lo() {
        lorri shell
      }

      ns() {
        nix-shell
      }

      nrp() {
        nix-review pr $@
      }

      if ! command -v vim > /dev/null; then
        vim() {
          nvim $@
        }
      fi

      if ! command -v vi > /dev/null; then
        vim() {
          nvim $@
        }
      fi

      gd() {
        git diff --name-only --diff-filter=d $@ | xargs bat --diff
      }

      push_bot() {
        local branch=$(git rev-parse --abbrev-ref HEAD)
        git push git@github.com:r-ryantm/nixpkgs.git ''${branch}:''${branch} $@
      }

      update_nixpkgs_homepage() {
        if [ "$#" -lt 3 ]; then
          echo "Please provide: [installable] [old-homepage] [new-homepage]"
          return 1
        fi

        local installable=$1
        local old_homepage=$2
        local new_homepage=$3
        local branch_name="update-''${installable}-homepage"

        pushd "''${NIXPKGS_ROOT:-/home/jon/projects/nixpkgs}"

        rg -l "$old_homepage" | xargs sed -i -e "s|$old_homepage|$new_homepage|g"

        if [[ $(git diff --stat) == "" ]]; then
          echo "No changes were made"
          return 1
        fi

        git checkout master
        git checkout -b ''${branch_name}
        git add pkgs/
        git diff HEAD
        git commit -v -m "''${installable}: update homepage"

        git push jonringer ''${branch_name}

        git checkout master
        popd
      }

      by_name_to_core() {
        local from_dir="$(dirname "$(realpath "$1")")"
        local dir="$(basename "$from_dir")"
        local to="$HOME/projects/core-pkgs/pkgs"

        cp -r "$from_dir" "$to"
        mv "$to/$dir/package.nix" "$to/$dir/default.nix"
      }

      unh() {
        update_nixpkgs_homepage $@
      }

      eval "$(starship init bash)"

      export PATH="$PATH:${config.xdg.dataHome}/.local/bin"
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.initExtra
    logoutExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.logoutExtra
    profileExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.profileExtra
    sessionVariables = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.sessionVariables
    shellAliases.atuin-import = "export HISTFILE && atuin import auto && unset HISTFILE"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.shellAliases
    shellOptions = [
      "histappend"
      "extglob"
      "globstar"
      "checkjobs"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.shellOptions
  };
in
{
  programs.bash = bashConfiguration;

  home = {
    packages = with pkgs; [
      # keep-sorted start
      bash # https://search.nixos.org/packages?channel=unstable&type=packages&show=bash
      coreutils-full
      # dateutils # @upstream-issue https://github.com/NixOS/nixpkgs/issues/511329
      diffutils
      gnugrep
      gnumake
      gnupg
      gnused
      gnutar
      shellcheck
      shfmt
      # keep-sorted end
    ];
  };
}
