# https://github.com/NovaViper/NixConfig/blob/beaeaf1e9c482a9dbac47f83d92917d09251d720/features/home/cli/shell/zsh/initContent.nix

{
  config,
  lib,
  ...
}:
{
  programs.zsh.initContent = lib.mkMerge [
    # Place before everything (except for zprof)
    (lib.mkOrder 450 ''
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return
    '')

    # 500 (mkBefore): Early initialization (replaces initExtraFirst)
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 500 '''')

    # 550: Before completion initialization (replaces initExtraBeforeCompInit)
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 550 '''')

    # Place where other setopts are declared in home-manager
    (lib.mkOrder 900 (
      ''
        setopt BEEP # Enable terminal bell
        setopt CORRECT # Enable autocorrect
        autoload -U colors && colors # Enable colors

        # Check if sudo-command-line function is available
        if typeset -f sudo-command-line > /dev/null; then
          zle -N sudo-command-line
          bindkey "^B" sudo-command-line
          bindkey -M vicmd '^B' sudo-command-line
        fi
      ''
      + (lib.optionalString config.programs.pyenv.enable ''
        ### Pyenv command
        if command -v pyenv 1>/dev/null 2>&1; then
          eval "$(pyenv init -)"
        fi
      '')
    ))

    # 1000 (default): General configuration (replaces initExtra)
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 1000 ''
      # https://superuser.com/questions/232457/zsh-output-whole-history/1061539#1061539
      histsearch() { fc -lim "*$@*" 1 } # https://superuser.com/a/1061539

      # Switch to new branch from updated default branch.
      git-switch-from-default-branch() {
        default_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
        git fetch origin
        git switch $default_branch
        git pull origin $default_branch
        git switch --create "$1"
      }

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

      # https://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter/1438523#1438523
      # https://stackoverflow.com/a/1438523
      # http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Widgets
      autoload -U select-word-style
      select-word-style bash
    '')

    # 1500 (mkAfter): Last to run configuration
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 1500 '''')

    # Z Style Customizations
    (lib.mkOrder 2000 (
      ''
        # set descriptions format to enable group support
        zstyle ':completion:*:descriptions' format '[%d]'

        # set list-colors to enable filename colorizing
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

        # make directory list first
        zstyle ':completion:*' list-dirs-first true

        # don't complete unavailable commands.
        zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
      ''
      + (lib.optionalString config.programs.fzf.enable ''
        # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
        zstyle ':completion:*' menu no

        # switch group using `<` and `>`
        zstyle ':fzf-tab:*' switch-group '<' '>'

        # trigger continuous trigger with space key
        zstyle ':fzf-tab:*' continuous-trigger 'space'

        # bind tab key to accept event
        zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'

        # accept and run suggestion with enter key
        zstyle ':fzf-tab:*' accept-line enter

        #### FZF-TAB SUGGESTION ADDITIONS ####
        # Command completion preview
        zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
          '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "''${(P)word}"'

        # preview environment vars
        zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview \
        'echo ''${(P)word}'

        # give a preview of commandline arguments when completing `kill`
        zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
        zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
          '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
        zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

        ### Systemctl
        zstyle ':fzf-tab:complete:systemctl-cat:*' fzf-preview 'SYSTEMD_COLORS=false systemctl cat -- $word | bat -lini'
        zstyle ':fzf-tab:complete:systemctl-help:*' fzf-preview 'systemctl help -- $word 2>/dev/null | bat -lhelp'
        zstyle ':fzf-tab:complete:(\\|*/|)systemctl-list-dependencies:*' fzf-preview \
          'case $group in
          unit)
            systemctl list-dependencies -- $word
            ;;
          esac'
        zstyle ':fzf-tab:complete:systemctl-show:*' fzf-preview 'systemctl show $word | bat -lini'
        zstyle ':fzf-tab:complete:systemctl-(status|(re|)start|(dis|en)able):*' fzf-preview 'systemctl status -- $word'


        # Show git
        # it is an example. you can change it
        zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
          'git diff $word | delta'
        zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
          'git log --color=always $word'
        zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
          'git help $word | bat -plman --color=always'
        zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
          'case "$group" in
          "commit tag") git show --color=always $word ;;
          *) git show --color=always $word | delta ;;
          esac'
        zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
          'case "$group" in
          "modified file") git diff $word | delta ;;
          "recent commit object name") git show --color=always $word | delta ;;
          *) git log --color=always $word ;;
          esac'
      '')
      + (lib.optionalString config.programs.eza.enable ''
        # preview directory's content with eza when completing cd or any path
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --group-directories-first --color=always $realpath'
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --group-directories-first --color=always $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'
      '')
      + (lib.optionalString config.programs.tmux.enable ''
        # Enable fzf-tab integration with tmux
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
        zstyle ':fzf-tab:*' popup-min-size 100 20
      '')
    ))
  ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
}
