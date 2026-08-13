# https://github.com/NovaViper/NixConfig/blob/beaeaf1e9c482a9dbac47f83d92917d09251d720/features/home/cli/shell/zsh/initContent.nix

{
  config,
  lib,
  pkgs,
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
    (lib.mkOrder 500 "")

    # 550: Before completion initialization (replaces initExtraBeforeCompInit)
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 550 "")

    # Place where other setopts are declared in home-manager
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 900 (
      ''
        setopt BEEP # Enable terminal bell
        setopt CORRECT # Enable autocorrect
        autoload -U colors && colors # Enable colors

        # Wrap sudo as a function instead of a trailing-space alias to prevent
        # alias chain-expansion that turns `sudo nix ...` into `sudo noglob nix ...`.
        # @upstream-issue https://github.com/NixOS/nix/issues/4686#issuecomment-3187134220
        sudo() { command sudo "$@" }
      ''
      + (lib.optionalString config.programs.pyenv.enable ''
        ### Pyenv command
        # if command -v pyenv 1>/dev/null 2>&1; then
        #   eval "$(pyenv init -)"
        # fi
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

      # Update flake inputs and rebuild the nix-darwin system, scaled to this host.
      # - Flake dir is resolved from the current git repo (falls back to the default checkout).
      # - Host config is auto-selected by nix-darwin from the hostname (no #hostname needed).
      # - --max-jobs is sized to half the logical CPUs; --cores 0 lets each job use all cores.
      # - Output is piped through nix-output-monitor (nom).
      # Pass --no-update to skip `nix flake update`.
      darwin-rebuild-update() {
        local flake ncpu jobs do_update=1
        [[ "$1" == "--no-update" ]] && do_update=0
        flake=$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || echo "$HOME/github/sheeeng/nix")
        ncpu=$(sysctl -n hw.ncpu 2>/dev/null || nproc)
        jobs=$(( ncpu / 2 > 0 ? ncpu / 2 : 1 ))

        sudo --validate || return 1
        if (( do_update )); then
          nix flake update --flake "$flake" || return 1
          sudo --validate || return 1
        fi
        sudo nix run github:lnl7/nix-darwin -- switch \
          --flake "$flake" \
          --print-build-logs --show-trace --verbose \
          --max-jobs "$jobs" --cores 0 \
          2>&1 | nix run nixpkgs#nix-output-monitor
      }

      # https://github.com/malev/dotfiles/blob/fbaa079eaaad4b5bf304c133fd05929f90c412d4/config/zsh.nix#L15-L16
      # bindkey '^p' history-search-backward
      # bindkey '^n' history-search-forward

      # https://stackoverflow.com/questions/12382499/looking-for-altleftarrowkey-solution-in-zsh/70596338#70596338
      # https://stackoverflow.com/a/70596338
      # bindkey "^[[5~" beginning-of-buffer-or-history  # ⇞ Key Page Up
      # bindkey "^[[6~" end-of-buffer-or-history # ⇟ Key Page Down

      # NOTE: every key binding below must run *after* the plugin list is sourced.
      # zsh-vi-mode (ZVM_INIT_MODE="sourcing") rebuilds the viins/vicmd keymaps
      # when it loads, wiping any bindkey set earlier in this file. Binding here
      # (mkOrder 1000, after the plugin loop) is what makes them stick.

      # sudo-command-line (from the omz-sudo plugin): press ^B to prepend `sudo`.
      # Lives here rather than earlier because omz-sudo is sourced *after*
      # zsh-vi-mode, so the widget does not exist during the plugin's own init.
      if typeset -f sudo-command-line > /dev/null; then
        zle -N sudo-command-line
        bindkey "^B" sudo-command-line
        bindkey -M vicmd '^B' sudo-command-line
      fi

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

    # Override _auto_notify_format to display elapsed time as Xh:XXm:XXs.
    # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L36-L44
    (lib.mkOrder 1050 ''
      function _auto_notify_format() {
        local message="$1"
        local command="$2"
        local elapsed="$3"
        local exit_code="$4"
        local hours=$(( elapsed / 3600 ))
        local minutes=$(( (elapsed % 3600) / 60 ))
        local seconds=$(( elapsed % 60 ))
        local formatted_elapsed
        printf -v formatted_elapsed '%dh:%02dm:%02ds' "$hours" "$minutes" "$seconds"
        message="''${message//\%command/$command}"
        message="''${message//\%elapsed/$formatted_elapsed}"
        message="''${message//\%exit_code/$exit_code}"
        printf '%s' "$message"
      }
    '')

    # Set iTerm2 tab title to current directory name on each prompt
    (lib.mkOrder 1100 ''
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        autoload -Uz add-zsh-hook
        _set_iterm2_tab_title() { echo -ne "\e]1;''${PWD##*/}\a" }
        add-zsh-hook precmd _set_iterm2_tab_title
      fi
    '')

    # 1500 (mkAfter): Last to run configuration
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 1500 "")

    # Z Style Customizations
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    (lib.mkOrder 2000 (
      ''
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # @note Shoe directories in blue, symlinks in magenta, executables in green, etc.—matching your terminal's ls colors in tab completion.
        zstyle ':completion:*' list-dirs-first true # @note Show directories before files in completion results for easier navigation.
        zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))' # @note Hide internal completion functions (_*) and shell hooks (precmd/preexec) from completion results.
      ''
      + (lib.optionalString config.programs.fzf.enable ''
        zstyle ':completion:*:git-checkout:*' sort false # @note Keep recent branches first instead of alphabetical.
        zstyle ':completion:*:descriptions' format '[%d]' # @note Show group headers like [branch] or [tag].
        zstyle ':completion:*' menu no # @note Disable zsh menu to let fzf-tab handle selection.
        zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept # @note Set colors and Tab to accept.
        zstyle ':fzf-tab:*' switch-group '<' '>' # @note Navigate between completion groups with < and >.
        zstyle ':fzf-tab:*' continuous-trigger 'space' # @note Space triggers continuous completion.
        zstyle ':fzf-tab:*' fzf-bindings 'tab:accept' # @note Tab accepts selection in fzf.
        zstyle ':fzf-tab:*' accept-line enter # @note Enter accepts and runs the command.

        #### FZF-TAB SUGGESTION ADDITIONS ####
        # @note Show tldr, man page, or path when completing commands.
        zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
          '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "''${(P)word}"'

        # @note Show variable values when completing env vars.
        zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview \
        'echo ''${(P)word}'

        # @note Show process command line when completing kill/ps.
        zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
        zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
          '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
        zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

        ### Systemctl previews
        zstyle ':fzf-tab:complete:systemctl-cat:*' fzf-preview 'SYSTEMD_COLORS=false systemctl cat -- $word | ${lib.getExe pkgs.bat} -lini' # @note Show unit file contents.
        zstyle ':fzf-tab:complete:systemctl-help:*' fzf-preview 'systemctl help -- $word 2>/dev/null | ${lib.getExe pkgs.bat} -lhelp' # @note Show unit help.
        zstyle ':fzf-tab:complete:(\\|*/|)systemctl-list-dependencies:*' fzf-preview \
          'case $group in
          unit)
            systemctl list-dependencies -- $word
            ;;
          esac' # @note Show unit dependencies tree.
        zstyle ':fzf-tab:complete:systemctl-show:*' \
          fzf-preview \
          'systemctl show $word | ${lib.getExe pkgs.bat} -lini' # @note Show unit properties.
        zstyle ':fzf-tab:complete:systemctl-(status|(re|)start|(dis|en)able):*' \
          fzf-preview \
          'systemctl status -- $word' # @note Show unit status.

        ### Git previews
        zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
          'git diff $word | delta' # @note Show file diff with delta.
        zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
          'git log --color=always $word' # @note Show commit log.
        zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
          'git help $word | ${lib.getExe pkgs.bat} -plman --color=always' # @note Show git command help.
        zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
          'case "$group" in
          "commit tag") git show --color=always $word ;;
          *) git show --color=always $word | delta ;;
          esac' # @note Show commit or tag details.
        zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
          'case "$group" in
          "modified file") git diff $word | delta ;;
          "recent commit object name") git show --color=always $word | delta ;;
          *) git log --color=always $word ;;
          esac' # @note Show diff, commit, or log based on type.
      '')
      + (lib.optionalString config.programs.eza.enable ''
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${lib.getExe pkgs.eza} -1 --group-directories-first --color=always $realpath' # @note Preview directory contents with eza.
        zstyle ':fzf-tab:complete:z:*' fzf-preview '${lib.getExe pkgs.eza} -1 --group-directories-first --color=always $realpath' # @note Preview zoxide jump targets.
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview '${lib.getExe pkgs.eza} --color=always $realpath' # @note Preview zoxide directory.
      '')
      + (lib.optionalString config.programs.tmux.enable ''
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup # @note Use tmux popup for fzf-tab.
        zstyle ':fzf-tab:*' popup-min-size 100 20 # @note Minimum popup size: 100 cols x 20 rows.
      '')
    ))
  ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
}
