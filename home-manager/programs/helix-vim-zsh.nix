{
  pkgs,
  lib,
  ...
}:

{
  programs.helix = {
    enable = true;
    settings = {
      core = {
        theme = "catppuccin_mocha";
        line-number = "relative";
        cursorline = true;
        cursorcolumn = false;
        indent-guides.render = true;
        indent-guides.character = "╎";
        indent-guides.skip-levels = 1;
      };
      editor = {
        line-number = "relative";
        rulers = [
          80
          120
        ];
      };
      language-server = {
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
        pylsp = {
          command = "${pkgs.python314Packages.python-lsp-server}/bin/pylsp";
        };
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = [
            "lsp"
            "stdio"
          ];
        };
        vscode-json-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/node";
          args = [
            "${pkgs.vscode-langservers-extracted}/lib/node_modules/vscode-json-languageserver/dist/node/jsonServerMain.js"
            "--stdio"
          ];
        };
        yaml-language-server = {
          command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          args = [
            "--stdio"
          ];
        };
        ltex-ls-plus = {
          command = "${pkgs.ltex-ls-plus}/bin/ltex-ls-plus";
        };
      };
    };
    languages.language = [
      {
        name = "nix";
        scope = "source.nix";
        injection-regex = "nix";
        file-types = [
          "nix"
        ];
        roots = [
          "flake.nix"
        ];
        language-servers = [
          "nixd"
        ];
        indent = {
          tab-width = 2;
          unit = "  ";
        };
      }
      {
        name = "python";
        scope = "source.python";
        injection-regex = "python";
        file-types = [
          "py"
          "pyi"
          "typ"
        ];
        roots = [
          "pyproject.toml"
          "setup.py"
          ".git"
        ];
        language-servers = [
          "pylsp"
        ];
        indent = {
          tab-width = 4;
          unit = "    ";
        };
      }
      {
        name = "rust";
        scope = "source.rust";
        injection-regex = "rust";
        file-types = [
          "rs"
        ];
        roots = [
          "Cargo.toml"
        ];
        language-servers = [
          "rust-analyzer"
        ];
      }
      {
        name = "toml";
        scope = "source.toml";
        file-types = [
          "toml"
        ];
        language-servers = [
          "taplo"
        ];
      }
      {
        name = "json";
        scope = "source.json";
        file-types = [
          "json"
        ];
        language-servers = [
          "vscode-json-language-server"
        ];
      }
      {
        name = "yaml";
        scope = "source.yaml";
        file-types = [
          "yml"
          "yaml"
        ];
        language-servers = [
          "yaml-language-server"
        ];
      }
      {
        name = "markdown";
        scope = "source.markdown";
        file-types = [
          "md"
        ];
        language-servers = [
          "ltex-ls-plus"
        ];
      }
    ];
  };

  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      undofile = true;
      cursorline = true;
      colorcolumn = "80,120";
    };
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-nix
      vim-fugitive
      vim-airline
      catppuccin-vim
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = false;
    defaultEditor = false;
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-nix
      vim-fugitive
      vim-airline
      catppuccin-nvim
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    defaultKeymap = "emacs";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 10000;
      size = 10000;
    };
    initContent = ''
      # Zsh keybindings
      bindkey -e
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^P' history-search-backward
      bindkey '^N' history-search-forward

      # Custom functions
      function mkcd() { mkdir -p "$1" && cd "$1" }
      function fd-search() { find . -type f -name "*$1*" }

      # Nix helpers
      alias nix-search='nix search nixpkgs'
      alias nix-shell='nix-shell --pure'
      alias nix-repl='nix repl'
      alias nix-flake-lock='nix flake update'
      alias nix-revert='sudo nixos-rebuild switch --rollback'
      alias nix-gc='nix-collect-garbage -d && nix-store --gc'

      # System shortcuts
      alias ll='eza --long --all --group-directories-first'
      alias lt='eza --tree --level=2 --group-directories-first'
      alias cat='bat --style=plain'
      alias grep='grep --color=auto'
      alias diff='difft'
      alias du='dust -r'

      # Navigation
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'

      # Lazy shortcuts
      alias lg='lazygit'
      alias vim='hx'

      # Edit config
      alias edit-zsh='hx ~/.config/zsh/.zshrc'
      alias edit-sway='hx ~/.config/sway/config'
      alias edit-nix='hx'
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$fill"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style) ";
        style = "bold cyan";
      };
      git_branch = {
        format = "on [$symbol$branch]($style) ";
        style = "bold purple";
      };
      git_status = {
        format = "([\\\\[$all_status$ahead_behind\\\\]]($style) )";
        style = "bold red";
      };
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
        style = "bold yellow";
      };
      fill = {
        symbol = " ";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--reverse"
      "--preview 'bat --color=always --line-range :20 {}'"
      "--bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)+abort'"
    ];
    fileWidgetCommand = "fd --type f --strip-cwd-prefix";
    fileWidgetOptions = [
      "--preview 'bat --color=always --line-range :20 {}'"
    ];
    changeDirWidgetCommand = "fd --type d --strip-cwd-prefix";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=2 --color=always {}'"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "grid";
      map-syntax = [
        "*.ksql:SQL"
        "*.sql:SQL"
      ];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Leonard Lee";
      user.email = "llee@example.com";
      core.pager = "delta";
      core.editor = "hx";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      rebase.autostash = true;
      log.decorate = "auto";
      status.showUntrackedFiles = "all";
      diff.colorMoved = "default";
      merge.conflictStyle = "diff3";
      pull.rebase = true;
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        average_cpu = true;
        disable_click = false;
        rate = 1000;
      };
    };
  };

  programs.dircolors = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
    FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --follow --exclude .git";
  };
}
