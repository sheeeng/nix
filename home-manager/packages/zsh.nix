# https://github.com/ymatsiuk/nixos-config/blob/d581daf95fcc13f6fc9a3492b409606efa6500eb/zsh.nix

{ config, pkgs, ... }:

# TODO: https://github.com/infinidim-enterprises/hive/blob/e77738405772188b90efb2f28a849078583f581a/cells/home/homeProfiles/shell/zsh.nix#L10C33-L10C65
# TODO: https://github.com/alisonjenkins/nix-config/blob/36c0d523e271faa68cd59ef278ad2f18500b3ae9/home/programs/zsh/default.nix

# TODO: https://github.com/sioodmy/dotfiles/blob/6dcb9d87965873628470f4093849eb628dd888f9/user/zsh/zinit.nix
# TODO: https://github.com/sukhmancs/nixos-configs/blob/6bb668901f9e24987d762365bf1c1211ae89aef2/homes/shared/shell/zsh/plugins.nix#L6
# TODO: https://github.com/njkli/hive/blob/ccebe1f759ee06bd18316119f29d3579e9505928/nix/vod/homeProfiles/shell/zsh.nix#L107
# TODO: https://github.com/ymatsiuk/nixos-config/blob/49898996aa210d2358935c83ea9b19576d1ba158/zsh.nix#L9
# TODO: https://github.com/danielphan2003/flk/blob/main/cells/nixos/nixosProfiles/programs/shells/zsh/shell-init.nix#L26

# FIXME: _zsh_highlight_widget_orig-s000-r552-orig-s000-r456-zle-line-finish:2: maximum nested function level reached; increase FUNCNEST?

let
in
# plugins = builtins.concatStringsSep "\n" (source);
# inherit (pkgs) fetchFromGitHub;
# source = map (source: "source ${source}") [
#   "${pkgs.zsh-fzf-tab}/share/fzf-tab"
#   # TODO: This is an inactive placeholder for the future implementation.
#   "${pkgs.fzf}/share/fzf/completion.zsh"
#   "${pkgs.fzf}/share/fzf/key-bindings.zsh"
#   "${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/git.zsh"
#   "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/git/git.plugin.zsh"
#   "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
#   "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions"
#   "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
#   "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"
#   "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
# ];
# TODO: https://stackoverflow.com/a/78468323
# zsh-autosuggestions = pkgs.fetchFromGitHub {
#   owner = "zsh-users";
#   repo = "zsh-autosuggestions";
#   rev = "master";
#   # hash = "sha256-I94/X50EbgL5JwgCl5pjNBKsa2Ilood/d9l9ANgO750=";
# };
# zsh-completions = pkgs.fetchFromGitHub {
#   owner = "zsh-users";
#   repo = "zsh-completions";
#   rev = "master";
#   # hash = "sha256-I94/X50EbgL5JwgCl5pjNBKsa2Ilood/d9l9ANgO750=";
# };
# zsh-syntax-highlighting = pkgs.fetchFromGitHub {
#   owner = "zsh-users";
#   repo = "zsh-syntax-highlighting";
#   rev = "master";
#   # hash = "sha256-I94/X50EbgL5JwgCl5pjNBKsa2Ilood/d9l9ANgO750=";
# };
# zsh-history-substring-search = pkgs.fetchFromGitHub {
#   owner = "zsh-users";
#   repo = "zsh-history-substring-search";
#   rev = "master";
#   # hash = "sha256-I94/X50EbgL5JwgCl5pjNBKsa2Ilood/d9l9ANgO750=";
# };
{
  # TODO: https://github.com/zsh-users/zsh-autosuggestions/issues/187#issuecomment-240310586
  programs.zsh = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
    enableCompletion = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
    enableVteIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableVteIntegration
    package = pkgs.zsh; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.package
    antidote = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.enable
      package = pkgs.antidote; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.package
      # https://github.com/jakedevs/nixos/blob/aee9f3632c57e866e2f165fc7ada8979e8f709b2/modules/home-manager/zsh.nix#L36
      plugins = [
        "agkozak/zsh-z"
        "aloxaf/fzf-tab"
        "fdellwing/zsh-bat"
        "hlissner/zsh-autopair"
        "joshskidmore/zsh-fzf-history-search"
        "mafredri/zsh-async"
        "mfaerevaag/wd"
        "michaelaquilina/zsh-you-should-use"
        "molovo/tipz"
        "nix-community/nix-zsh-completions"
        "olets/zsh-abbr"
        "olivierverdier/zsh-git-prompt"
        "popstas/zsh-command-time"
        "sindresorhus/pure"
        "zdharma-continuum/history-search-multi-word"
        "zpm-zsh/clipboard"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-history-substring-search"
        "zsh-users/zsh-syntax-highlighting"
        # "marlonrichert/zsh-autocomplete" # FIXME: https://github.com/zsh-users/zsh-syntax-highlighting/issues/951#issuecomment-2089829937
        # "tarrasch/zsh-bd" # FIXME: Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-tarrasch-SLASH-zsh-bd/bd.plugin.zsh:88: command not found: compdef
        # "marlonrichert/zsh-edit" # FIXME: https://github.com/marlonrichert/zsh-edit/issues/24
        # "z-shell/f-sy-h" # FIXME: azhw:zle-line-finish:2: maximum nested function level reached; increase FUNCNEST?
        # "zdharma-continuum/fast-syntax-highlighting" # FIXME: azhw:zle-line-finish:2: maximum nested function level reached; increase FUNCNEST?
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.plugins
      useFriendlyNames = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.useFriendlyNames
    };
    autocd = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autocd
    autosuggestion = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autosuggestion.enable
      highlight = null; # "fg=#ff00ff,bg=cyan,bold,underline"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autosuggestion.highlight
      strategy = [
        "history"
        "completion"
        "match_prev_cmd"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autosuggestion.strategy
    };
    cdpath = [ "~" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.cdpath
    completionInit = "autoload -U compinit && compinit"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.completionInit
    defaultKeymap = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.defaultKeymap
    dirHashes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.dirHashes
    dotDir = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.dotDir
    envExtra = ''
      export LESSHISTFILE="${config.xdg.dataHome}/.lesshst";
      export CARGO_HOME="${config.xdg.cacheHome}/.cargo"
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.envExtra
    history = {
      append = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.append
      expireDuplicatesFirst = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.expireDuplicatesFirst
      extended = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.extended
      ignoreAllDups = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignoreAllDups
      ignoreDups = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignoreDups
      ignorePatterns = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignorePatterns
      ignoreSpace = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignoreSpace
      path = "${config.home.homeDirectory}/zsh/.zsh_history"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.path
      save = 10000; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.save
      share = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.share
      size = 1000000; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.size
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history

    historySubstringSearch = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch.enable
      searchDownKey = [ "^[[B" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch.searchDownKey
      searchUpKey = [ "^[[A" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch.searchUpKey
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch

    initExtra = ''
      echo "# ----------------------------------------------------------------------"
      echo "# Init Extra...."

      # https://github.com/malev/dotfiles/blob/fbaa079eaaad4b5bf304c133fd05929f90c412d4/config/zsh.nix#L15-L16
      # bindkey '^p' history-search-backward
      # bindkey '^n' history-search-forward

      # https://stackoverflow.com/questions/12382499/looking-for-altleftarrowkey-solution-in-zsh/70596338#70596338
      # https://stackoverflow.com/a/70596338
      # bindkey "^[[5~" beginning-of-buffer-or-history  # ⇞ Key Page Up
      # bindkey "^[[6~" end-of-buffer-or-history # ⇟ Key Page Down

      # https://github.com/lovesegfault/nix-config/blob/838045d938c6ecfd90df27430337e3870c36727a/users/bemeurer/core/zsh.nix#L36-L39
      bindkey "''${terminfo[kcuu1]}" history-substring-search-up # ↑
      bindkey '^[[A' history-substring-search-up # ↑
      bindkey "''${terminfo[kcud1]}" history-substring-search-down # ↓
      bindkey '^[[B' history-substring-search-down # ↓

      # https://github.com/lovesegfault/nix-config/blob/838045d938c6ecfd90df27430337e3870c36727a/users/bemeurer/core/zsh.nix#L43
      bindkey "''${terminfo[khome]}" beginning-of-line
      bindkey "^A" beginning-of-line # ⌘ + ←

      # https://github.com/lovesegfault/nix-config/blob/838045d938c6ecfd90df27430337e3870c36727a/users/bemeurer/core/zsh.nix#L44
      bindkey "''${terminfo[kend]}" end-of-line
      bindkey "^E" end-of-line # ⌘ + →

      # # https://github.com/lovesegfault/nix-config/blob/838045d938c6ecfd90df27430337e3870c36727a/users/bemeurer/core/zsh.nix#L45
      bindkey "''${terminfo[kdch1]}" delete-char
      bindkey "^[[3~" delete-char # 🌐 + ⌫

      bindkey "^[b" backward-word # ⌥ + ←
      bindkey "^[f" forward-word # ⌥ + →

      bindkey "^[[3;5~" kill-word # ^ + 🌐 + ⌫
      bindkey "^H" backward-kill-word # ⌃ + ⌫

      # https://github.com/NovaViper/NixConfig/blob/ecd84d3d2de589edd6c3ee7f702a806401741611/modules/system/shell/zsh.nix#L63
      AUTO_NOTIFY_IGNORE+=("atuin" "yadm" "emacs" "nix-shell" "nix")

      # https://github.com/NovaViper/NixConfig/blob/ecd84d3d2de589edd6c3ee7f702a806401741611/modules/system/shell/zsh.nix#L65-L66
      setopt beep CORRECT # Enable terminal bell and autocorrect
      autoload -U colors && colors # Enable colors

      # https://github.com/lovesegfault/nix-config/blob/838045d938c6ecfd90df27430337e3870c36727a/users/bemeurer/core/zsh.nix#L41
      # ${pkgs.nix-your-shell}/bin/nix-your-shell --nom zsh | source /dev/stdin

      if command -v git > /dev/null && git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        alias gtl="cd ''$(git rev-parse --show-toplevel)"
      fi

      if command -v kubectl > /dev/null; then
        alias k="kubectl"
        # https://stackoverflow.com/questions/56909180/decoding-kubernetes-secret/58117444#58117444
        # https://stackoverflow.com/a/58117444
        # https://github.com/ymatsiuk/nixos-config/blob/d581daf95fcc13f6fc9a3492b409606efa6500eb/zsh.nix#L59
        alias kds='kubectl get secret --output go-template="{{range \$k,\$v := .data}}{{printf \"%s: \" \$k}}{{if not \$v}}{{\$v}}{{else}}{{\$v | base64decode}}{{end}}{{\"\n\"}}{{end}}"'
        # https://github.com/ymatsiuk/nixos-config/blob/d581daf95fcc13f6fc9a3492b409606efa6500eb/zsh.nix#L61
        alias kgpi="kubectl get pods --all-namespaces --output jsonpath=\"{.items[*].spec.containers[*].image}\" | tr --squeeze-repeats '[[:space:]]' '\n' | sort | uniq --count"
        alias knks="kubectl --namespace kube-system"
      fi

      # if command -v eza > /dev/null; then
      #   alias ls="eza --group-directories-first"
      #   alias tree="eza --tree"
      # fi

      # if command -v ssh > /dev/null; then
      #   alias ssh-data-dome="ssh -X -i ~/.ssh/id_ed25519 ubuntu@129.159.255.15"
      #   alias ssh-tailscale-exit="ssh -X -i ~/Downloads/oracle-cloud-tailscale-exit/ssh-key-2022-03-28.key ubuntu@141.147.50.182"
      #   alias ssh-tor-bridge="ssh -X -i ~/Downloads/oracle-cloud-tor-bridge/ssh-key-2022-03-28.key ubuntu@144.24.178.125"
      # fi

      # command -v terraform > /dev/null && alias tf="terraform"
      # command -v terragrunt > /dev/null && alias tg="terragrunt"
      command -v nvim > /dev/null && alias vim="nvim"

      command -v atuin > /dev/null && eval "''$(atuin init zsh)"
      command -v direnv > /dev/null && eval "''$(direnv hook zsh)"
      command -v thefuck > /dev/null && eval "''$(thefuck --alias)"
      command -v zoxide > /dev/null && eval "''$(zoxide init --cmd cd zsh)"

      # https://github.com/NovaViper/NixConfig/blob/ecd84d3d2de589edd6c3ee7f702a806401741611/modules/system/shell/zsh.nix#L69-L71
      # https://stackoverflow.com/questions/58679742/set-default-python-with-pyenv/69378384#69378384
      if command -v pyenv 1> /dev/null 2>&1; then
        eval "''$(pyenv init -)"

        # https://stackoverflow.com/questions/70116470/how-to-make-pip-command-use-pyenv-pip-rather-than-default-system-pip/71559920#71559920
        export PYENV_BIN="''${HOME}/.pyenv/bin"

        export PATH="''${PYENV_BIN}:''${PATH}" \
          && echo 'Added ''${PYENV_BIN} to ''${PATH}.'
      fi
      if which pyenv-virtualenv-init > /dev/null; then
        eval "''$(pyenv virtualenv-init -)"
      fi

      if command -v cargo 1> /dev/null 2>&1; then
        . "''${HOME}/.cargo/env"
      fi

      # # https://helm.sh/docs/helm/helm_completion_zsh/
      # command -v helm > /dev/null && source <(helm completion zsh)

      # # https://fluxcd.io/flux/cmd/flux_completion_zsh/
      # command -v flux > /dev/null && . <(flux completion zsh)

      GOPATH_BIN="''${HOME}/go/bin"
      [ -d "''${GOPATH_BIN}" ] \
        && export PATH="''${GOPATH_BIN}:''${PATH}" \
        && echo 'Added ''${GOPATH_BIN} to ''${PATH}.'

      LOCAL_BIN="''${HOME}/.local/bin"
      [ -d "''${LOCAL_BIN}" ] \
        && export PATH="''${LOCAL_BIN}:''${PATH}" \
        && echo 'Added ''${LOCAL_BIN} to ''${PATH}.'

      NIXPROFILE_BIN="''${HOME}/.nix-profile/bin"
      [ -d "''${NIXPROFILE_BIN}" ] \
        && export PATH="''${NIXPROFILE_BIN}:''${PATH}" \
        && echo 'Added ''${NIXPROFILE_BIN} to ''${PATH}.'

      # TODO: https://www.dotruby.com/articles/profiling-zsh-setup-with-zprof
      # time ZSH_DEBUGRC=1 zsh -i -c exit
      if [[ -n ''${ZSH_DEBUGRC} ]]; then
        zprof
      fi
      echo "# End of Init Extra...."
      echo "# ----------------------------------------------------------------------"
    '';

    initExtraBeforeCompInit = ''
      echo "# ----------------------------------------------------------------------"
      echo "# Init Extra Before Comp Init...."

      echo "# End of Init Extra Before Comp Init...."
      echo "# ----------------------------------------------------------------------"
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initExtraBeforeCompInit

    initExtraFirst = ''
      echo "# ----------------------------------------------------------------------"
      echo "# Init Extra First...."

      # https://www.dotruby.com/articles/profiling-zsh-setup-with-zprof
      # time ZSH_DEBUGRC=1 zsh -i -c exit
      if [[ -n ''${ZSH_DEBUGRC} ]]; then
        zmodload zsh/zprof
      fi

      # https://github.com/NovaViper/NixConfig/blob/ecd84d3d2de589edd6c3ee7f702a806401741611/modules/system/shell/zsh.nix#L56-L59
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

      echo "# End of Init Extra First...."
      echo "# ----------------------------------------------------------------------"
    '';

    localVariables = {
      EDITOR = [ "${pkgs.neovim}/bin/nvim" ];
      LANG = "en_US.UTF-8";
      MANPATH = "/usr/local/man:$MANPATH";
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat --language man --plain'";
      # https://github.com/njkli/hive/blob/ccebe1f759ee06bd18316119f29d3579e9505928/nix/vod/homeProfiles/shell/zsh.nix#L100
      ZSH_DISABLE_COMPFIX = true; # NOTE: required when plugin dirs are in /nix/store
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#839496,bold,underline"; # https://github.com/njkli/hive/blob/ccebe1f759ee06bd18316119f29d3579e9505928/nix/vod/homeProfiles/shell/zsh.nix#L101
      TIPZ_TEXT = "💡 "; # https://github.com/njkli/hive/blob/ccebe1f759ee06bd18316119f29d3579e9505928/nix/vod/homeProfiles/shell/zsh.nix#L102
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.localVariables

    loginExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.loginExtra
    logoutExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.logoutExtra

    oh-my-zsh = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.enable
      package = pkgs.oh-my-zsh; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.package
      custom = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.custom
      extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.extraConfig
      plugins = [
        # "f-sy-h"
        # "git"
        # "zsh-autosuggestions"
        # "zsh-completions"
        # "zsh-history-substring-search"
        # "zsh-syntax-highlighting"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.plugins
      theme = "agnoster"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.theme
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh

    # TODO: https://github.com/sukhmancs/nixos-configs/blob/6bb668901f9e24987d762365bf1c1211ae89aef2/homes/shared/shell/zsh/plugins.nix#L6
    # TODO: https://github.com/njkli/hive/blob/ccebe1f759ee06bd18316119f29d3579e9505928/nix/vod/homeProfiles/shell/zsh.nix#L107
    # TODO: https://github.com/ymatsiuk/nixos-config/blob/49898996aa210d2358935c83ea9b19576d1ba158/zsh.nix#L9
    # TODO: https://github.com/danielphan2003/flk/blob/main/cells/nixos/nixosProfiles/programs/shells/zsh/shell-init.nix#L26
    # plugins = [
    #   {
    #     # https://github.com/sukhmancs/nixos-configs/blob/6bb668901f9e24987d762365bf1c1211ae89aef2/homes/shared/shell/zsh/plugins.nix#L6
    #     # Must be before plugins that wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting
    #     name = "zsh-fzf-tab";
    #     src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
    #   }

    #   {
    #     name = "zsh-nix-shell";
    #     src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
    #   }

    #   {
    #     name = "zsh-fast-syntax-highlighting";
    #     src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    #   }

    #   {
    #     name = "zsh-fast-syntax-highlighting";
    #     src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
    #   }
    #   {
    #     name = "zsh-nix-shell";
    #     src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
    #   }
    #   # {
    #   #   name = "zsh-vi-mode";
    #   #   src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    #   # }
    #   {
    #     name = "zsh-fzf-tab";
    #     src = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";
    #   }
    #   {
    #     name = "zsh-autosuggestions";
    #     src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    #   }
    #   {
    #     name = "zsh-autopair";
    #     src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh";
    #   }

    #   {
    #     name = "zsh-autosuggestions";
    #     src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    #   }

    #   {
    #     name = "zsh-autopair";
    #     file = "zsh-autopair.plugin.zsh";
    #     src = fetchFromGitHub {
    #       owner = "hlissner";
    #       repo = "zsh-autopair";
    #       rev = "449a7c3d095bc8f3d78cf37b9549f8bb4c383f3d";
    #       hash = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
    #     };
    #   }
    #   {
    #     name = "zsh-you-should-use";
    #     inherit (pkgs.zsh-you-should-use) src;
    #   }
    # ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.plugins
    prezto = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.enable
      autosuggestions.color = "fg=blue"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.autosuggestions.color
      caseSensitive = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.caseSensitive
      color = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.color
      completions.ignoredHosts = [
        "0.0.0.0"
        "127.0.0.1"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.completions.ignoredHosts
      editor = {
        dotExpansion = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.editor.dotExpansion
        keymap = "vi"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.editor.keymap
        promptContext = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.editor.promptContext
      };
      extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.extraConfig
      extraFunctions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.extraFunctions
      extraModules = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.extraModules
      git.submoduleIgnore = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.git.submoduleIgnore
      gnuUtility.prefix = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.gnuUtility.prefix
      historySubstring = {
        foundColor = "fg=blue"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.historySubstring.foundColor
        globbingFlags = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.historySubstring.globbingFlags
        notFoundColor = "fg=red"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.historySubstring.notFoundColor
      };
      macOS.dashKeyword = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.macOS.dashKeyword
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "prompt"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.pmodules
      prompt = {
        pwdLength = "full"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.prompt.pwdLength
        showReturnVal = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.prompt.showReturnVal
        theme = "pure"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.prompt.theme
      };
      python = {
        virtualenvAutoSwitch = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.python.virtualenvAutoSwitch
        virtualenvInitialize = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.python.virtualenvInitialize
      };
      ruby = {
        chrubyAutoSwitch = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.ruby.chrubyAutoSwitch
      };
      screen = {
        autoStartLocal = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.screen.autoStartLocal
        autoStartRemote = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.screen.autoStartRemote
      };
      ssh = {
        identities = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.ssh.identities
      };
      syntaxHighlighting = {
        highlighters = [
          # https://github.com/zsh-users/zsh-syntax-highlighting/blob/5eb677bb0fa9a3e60f0eff031dc13926e093df92/docs/highlighters.md
          "main"
          "brackets"
          "pattern"
          "regexp"
          "cursor"
          "root"
          "line"
        ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.syntaxHighlighting.highlighters
        pattern = {
          "rm*-rf*" = "fg=white,bold,bg=red";
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.syntaxHighlighting.pattern
        styles = {
          # https://github.com/zsh-users/zsh-syntax-highlighting/blob/5eb677bb0fa9a3e60f0eff031dc13926e093df92/docs/highlighters/main.md
          builtin = "bg=blue";
          command = "bg=blue";
          function = "bg=blue";
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.syntaxHighlighting.styles
        # TODO
        # terminal = {
        #   autoTitle = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.terminal.autoTitle
        #   multiplexerTitleFormat = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.terminal.multiplexerTitleFormat
        #   tabTitleFormat = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.terminal.tabTitleFormat
        #   windowTitleFormat = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.terminal.windowTitleFormat
        # };
        # TODO
        # tmux = {
        #   autoStartLocal = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.tmux.autoStartLocal
        #   autoStartRemote = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.tmux.autoStartRemote
        #   defaultSessionName = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.tmux.defaultSessionName
        #   itermIntegration = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.tmux.itermIntegration
        # };
        # TODO
        # utility.safeOps = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.utility.safeOps
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto

    profileExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.profileExtra
    sessionVariables = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.sessionVariables

    shellAliases = {
      gtl = "cd $(${pkgs.kubectl}/bin/git rev-parse --show-toplevel)";
      k = "${pkgs.kubectl}/bin/kubectl";
      kds = ''${pkgs.kubectl}/bin/kubectl get secrets -o go-template='{{range $k,$v := .data}}{{$k}}="{{($v | base64decode)}}"{{"\n"}}{{end}}' ''; # kube decode secrets (mind the space in the end to separate ' from '' :facepalm.nix:)
      kgpi = ''${pkgs.kubectl}/bin/kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c''; # kube get pods' images
      ks = "${pkgs.kubectl}/bin/kubectl -n kube-system";
      l = "${pkgs.eza}/bin/eza --long --all --header --classify=always --group-directories-first --time-style=long-iso --git";
      ls = "${pkgs.eza}/bin/eza --group-directories-first --time-style=long-iso --git";
      lsd = "${pkgs.eza}/bin/eza --long --header --git --only-dirs";
      lse = "${pkgs.eza}/bin/eza --long --header --git --sort ext";
      lsm = "${pkgs.eza}/bin/eza --long --header --git --sort mod";
      lsn = "${pkgs.eza}/bin/eza --long --header --git --sort name";
      lss = "${pkgs.eza}/bin/eza --long --header --git --sort size";
      reset-dock = "defaults delete com.apple.dock; killall Dock";
      tf = "${pkgs.terraform}/bin/terraform";
      # mt = "cd $(mktemp --directory ${"TMPDIR:-/tmp"}/zombie.XXXXXXXXX)";
      tg = "${pkgs.terragrunt}/bin/terragrunt";
      tree = "${pkgs.eza}/bin/eza --tree";
      vi = "${pkgs.helix}/bin/hx";
      wttr = "${pkgs.curl}/bin/curl 'wttr.in/Oslo?format=3'"; # TODO: https://www.reddit.com/r/macapps/comments/1gg4k6o/comment/lupspio/
      wttr-all = "${pkgs.curl}/bin/curl 'wttr.in/{Helsfyr,Kuching,Lørenskog,Oslo}?format=3'";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.shellAliases

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.shellGlobalAliases

    syntaxHighlighting = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting.enable
      package = pkgs.zsh-syntax-highlighting; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting.package
      highlighters = [
        # https://github.com/zsh-users/zsh-syntax-highlighting/blob/5eb677bb0fa9a3e60f0eff031dc13926e093df92/docs/highlighters.md
        "main"
        "brackets"
        "pattern"
        "regexp"
        "cursor"
        "root"
        "line"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting.highlighters
      patterns = {
        "rm -rf *" = "fg=white,bold,bg=red";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting.patterns
      styles = {
        # https://github.com/zsh-users/zsh-syntax-highlighting/blob/5eb677bb0fa9a3e60f0eff031dc13926e093df92/docs/highlighters/main.md
        builtin = "bg=blue";
        command = "bg=blue";
        function = "bg=blue";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting.styles
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting
    zplug = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zplug.enable
      plugins = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zplug.plugins
      zplugHome = "${config.home.homeDirectory}/.zplug"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zplug.zplugHome
    };
    zprof = {
      # TODO: Optional with a flag.
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zprof.enable
    };
    zsh-abbr = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zsh-abbr.enable
      abbreviations = {
        gco = "git checkout";
        l = "less";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zsh-abbr.abbreviations
    };
  };
}
