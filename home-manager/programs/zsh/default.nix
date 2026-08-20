# https://github.com/NovaViper/NixConfig/blob/beaeaf1e9c482a9dbac47f83d92917d09251d720/features/home/cli/shell/zsh/zsh.nix

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./auto-notify-ignore.nix
    ./init-content.nix
    ./plugins.nix
    ./zsh-abbr.nix
  ];

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
        # "fdellwing/zsh-bat"
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
        "zdharma-continuum/history-search-multi-word"
        "zpm-zsh/clipboard"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-history-substring-search"
        "zsh-users/zsh-syntax-highlighting"
        # "marlonrichert/zsh-autocomplete" # FIXME: https://github.com/zsh-users/zsh-syntax-highlighting/issues/951#issuecomment-2089829937
        # "marlonrichert/zsh-edit" # FIXME: https://github.com/marlonrichert/zsh-edit/issues/24
        # "sindresorhus/pure"
        # "tarrasch/zsh-bd" # FIXME: Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-tarrasch-SLASH-zsh-bd/bd.plugin.zsh:88: command not found: compdef
        # "z-shell/f-sy-h" # FIXME: azhw:zle-line-finish:2: maximum nested function level reached; increase FUNCNEST?
        # "zdharma-continuum/fast-syntax-highlighting" # FIXME: azhw:zle-line-finish:2: maximum nested function level reached; increase FUNCNEST?
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.plugins
      useFriendlyNames = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.useFriendlyNames
    };
    autocd = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autocd
    autosuggestion = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autosuggestion.enable
      highlight = "fg=8,underline"; # "fg=#ff00ff,bg=cyan,bold,underline"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autosuggestion.highlight
      strategy = lib.mkForce [
        "history"
        "completion"
        "match_prev_cmd"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autosuggestion.strategy
    };
    cdpath = [ "~" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.cdpath
    completionInit = "autoload -U compinit && compinit -i"; # https://discourse.nixos.org/t/zsh-compinit-warning-on-every-shell-session/22735/6 # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.completionInit
    # Leave unset: the jeffreytse/zsh-vi-mode plugin owns the vi keymaps. Setting
    # "viins" here only emits a redundant `bindkey -v` that the plugin re-does on
    # load, so keeping it null makes the plugin the single source of truth.
    defaultKeymap = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.defaultKeymap
    dirHashes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.dirHashes
    dotDir = "${config.xdg.configHome}/zsh"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.dotDir
    envExtra = ''
      export LESSHISTFILE="${config.xdg.dataHome}/.lesshst";
      export CARGO_HOME="${config.xdg.cacheHome}/.cargo"
      export PATH="/etc/profiles/per-user/${config.home.username}/bin:$HOME/bin:$PATH"
      export PATH="$PATH:${config.xdg.dataHome}/.local/bin"
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.envExtra
    history = {
      append = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.append
      expireDuplicatesFirst = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.expireDuplicatesFirst
      extended = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.extended
      findNoDups = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.findNoDups
      ignoreAllDups = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignoreAllDups
      ignoreDups = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignoreDups
      ignorePatterns = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignorePatterns
      ignoreSpace = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.ignoreSpace
      path = "${config.home.homeDirectory}/zsh/.zsh_history"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.path
      save = 10000; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.save
      saveNoDups = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.saveNoDups
      share = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.share
      size = 1000000; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history.size
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.history

    historySubstringSearch = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch.enable
      searchDownKey = [ "^[[B" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch.searchDownKey
      searchUpKey = [ "^[[A" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch.searchUpKey
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.historySubstringSearch

    localVariables = {
      ABBR_SET_EXPANSION_CURSOR = 1;
      # Initialize zsh-vi-mode while the plugin is sourced (not lazily on the
      # first prompt) so its keymaps exist before later plugins and our own
      # bindkeys run. Keep custom bindkeys after the plugin list (init-content.nix
      # mkOrder 1000) or zvm_init will wipe them.
      ZVM_INIT_MODE = "sourcing";
      ZVM_CURSOR_STYLE_ENABLED = false;
      # Start every new prompt in INSERT mode instead of inheriting the previous
      # line's mode (the plugin default, $ZVM_MODE_LAST). Inheriting is what left
      # prompts stuck in NORMAL mode showing starship's `❮`. "i" == $ZVM_MODE_INSERT.
      ZVM_LINE_INIT_MODE = "i";
      SPROMPT = "Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [ny] ";
      ZSH_AUTOSUGGEST_STRATEGY = [
        "abbreviations"
        "completion"
        "history"
      ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.localVariables

    loginExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.loginExtra
    logoutExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.logoutExtra

    oh-my-zsh = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.enable
      package = pkgs.oh-my-zsh; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.package
      custom = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.custom
      extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.extraConfig
      plugins = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.plugins
      theme = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.theme
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh

    # plugins = [ ]; # See plugins.nix file. # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.plugins

    prezto = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.enable
      package = pkgs.prezto; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.package
      autosuggestions.color = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.autosuggestions.color
      caseSensitive = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.caseSensitive
      color = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.color
      completions.ignoredHosts = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.completions.ignoredHosts
      editor = {
        dotExpansion = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.editor.dotExpansion
        keymap = "vi"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.editor.keymap
        promptContext = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.editor.promptContext
      };
      extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.extraConfig
      extraFunctions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.extraFunctions
      extraModules = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.extraModules
      git.submoduleIgnore = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.git.submoduleIgnore
      gnuUtility.prefix = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto.gnuUtility.prefix
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.prezto

    profileExtra = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.profileExtra

    sessionVariables = {
      PAGER = "${pkgs.less}/bin/less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.sessionVariables
    setOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.setOptions

    # Noglob aliases prevent Zsh glob expansion from altering flake references
    # in Nix commands. The sudo function in init-content.nix avoids alias
    # chain-expansion that would turn `sudo nix ...` into `sudo noglob nix ...`.
    # @upstream-issue https://github.com/NixOS/nix/issues/4686#issuecomment-3187134220
    shellAliases = {
      atuin-import = "export HISTFILE && atuin import auto && unset HISTFILE";
      nh = "noglob nh";
      nix = "noglob nix";
      nom = "noglob nom";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      nixos-rebuild = "noglob nixos-rebuild";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.shellAliases

    shellGlobalAliases = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.shellGlobalAliases

    siteFunctions = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.siteFunctions

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
        "rm --force --recursive *" = "fg=white,bold,bg=red";
        "rm --recursive --force *" = "fg=white,bold,bg=red";
        "rm -fr *" = "fg=white,bold,bg=red";
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
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zprof.enable
    };

    # zsh-abbr = {
    #   enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.zsh-abbr.enable
    # }; # See zsh-abbr.nix file.
  };
}
