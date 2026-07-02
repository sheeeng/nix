{
  config,
  pkgs,
  ...
}:
{
  # TODO: git config --list --show-origin
  # TODO: git check-ignore --verbose -- .DS_Store
  # TODO: git config --get --global core.excludesFile
  programs.git = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
    package = pkgs.git; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.package
    settings = {
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        adog = "log --all --decorate --oneline --graph";
        last = "log -1 HEAD";
        lgfs = "log --format=fuller --show-signature";
        lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
        log50 = "log --format='%C(auto)%h %C(green)(%<(4)%gd)%Creset %<(50,trunc)%s %C(dim)(%cr)%Creset'";
        log72 = "log --format='%C(auto)%h %C(green)(%<(4)%gd)%Creset %<(72,trunc)%s %C(dim)(%cr)%Creset'";
        lol = "log --oneline --decorate --graph --all";
        root = "rev-parse --show-toplevel";
        unstage = "reset HEAD --";
        # https://github.com/timokau/dotfiles/blob/c2c55834a3b479132ca07794f75a1d887fa29df6/git/.gitconfig
        # https://news.ycombinator.com/item?id=16681141
        # lg is the normal log, glg is with the graph, slg lists my stashes in the same format (i find the date really helpful), and blg does the same for branches.
        # blg can't reuse a pretty definition because it uses a completely different formatting language. The fact that Git contains two different but largely equivalent formatting languages is kind of emblematic of its whole design, really.
        # Like heipei, i put the fixed-width bits on the left so that they line up. I try to use consistent and distinctive colours for everything; mostly that's obvious, but yellow draws an equivalent between branch names for the normal and branch logs, and stash refs for the stashes. Including committer name for stashes is perhaps foolish consistency, although it would be useful if you do pair programming and use something like git-duet.
        lg = "log --pretty=lg";
        glg = "log --graph --pretty=lg";
        slg = "stash list --pretty=reflg";
        blg = "branch --format '%(color:red)%(objectname:short)%(color:reset) %(color:green)%(committerdate:iso)%(color:reset) %(subject) %(color:bold blue)-- %(authorname)%(color:reset) %(color:yellow)(%(refname:short))%(color:reset)'";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        # find the merge commit that included a commit
        # https://stackoverflow.com/questions/8475448/find-merge-commit-which-include-a-specific-commit#8492711
        find-merge = "!sh -c 'commit=$0 && branch=${"1:-HEAD"} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'";
        # push the current branch to timokau (automatically applying the suggested -u parameters)
        track = "!git push --set-upstream timokau \"$(git symbolic-ref --short HEAD)\"";
      };

      apply = {
        whitespace = "fix";
      };
      branch.sort = "-committerdate";
      color = {
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
        ui = "auto";
      };
      column.ui = "auto";
      commit = {
        gpgSign = true;
        verbose = true;
      };
      core = {
        autocrlf = "input"; # https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings#global-settings-for-line-endings
        safecrlf = false; # https://git-scm.com/docs/git-config#Documentation/git-config.txt-coresafecrlf
        # editor = "nvim"; # # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
        excludesfile = "${config.home.homeDirectory}/.config/git/ignore"; # "${pkgs.git}/etc/gitignore"; # git config --get core.excludesfile
        pager = "${pkgs.delta}/bin/delta"; # TODO: consider bat? # https://github.com/lasseheia/nix/blob/2804cb5670f54c91da65067b204a71a5ff5695fc/modules/git/home-manager.nix#L25
        whitespace = "fix,-indent-with-non-tab,trailing-space,space-before-tab";
        untrackedCache = true; # https://groups.google.com/a/chromium.org/g/chromium-dev/c/MbTkba8g_MU/m/NCW0eYknAQAJ
        fsmonitor = false; # TODO: https://discourse.nixos.org/t/builtins-getflake-breaks-if-git-core-fsmonitor-is-enabled/54916
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.extraConfig
      diff = {
        wsErrorHighlight = "all";
        exif = {
          textconv = "exiftool";
        };
        word = {
          textconv = "docx2txt";
        };
      };
      filter = {
        spabs = {
          clean = "expand --initial -t 2"; # https://gist.github.com/eevee/6721177; https://eev.ee/blog/2016/06/04/converting-a-git-repo-from-tabs-to-spaces/
          smudge = "expand --initial -t 2"; # https://gist.github.com/eevee/6721177; https://eev.ee/blog/2016/06/04/converting-a-git-repo-from-tabs-to-spaces/
          required = true;
        };
        spacify = {
          clean = "expand --tabs=2 --initial"; # https://stackoverflow.com/a/40094388; https://stackoverflow.com/questions/40091541/can-git-be-told-to-use-spaces-in-gitconfig/40094388#40094388
          smudge = "expand --tabs=2 --initial"; # https://stackoverflow.com/a/40094388; https://stackoverflow.com/questions/40091541/can-git-be-told-to-use-spaces-in-gitconfig/40094388#40094388
        };
        tabspace = {
          smudge = "unexpand --tabs=2 --first-only"; # https://stackoverflow.com/a/2318063; https://stackoverflow.com/questions/2316677/can-git-automatically-switch-between-spaces-and-tabs/2318063#2318063
          clean = "expand --tabs=2 --initial"; # https://stackoverflow.com/a/2318063; https://stackoverflow.com/questions/2316677/can-git-automatically-switch-between-spaces-and-tabs/2318063#2318063
        };
      };
      fsmonitor = {
        allowRemote = true; # https://git-scm.com/docs/git-fsmonitor--daemon#Documentation/git-fsmonitor--daemon.txt-fsmonitorallowRemote
        socketDir = "${config.home.homeDirectory}/.git/fsmonitor-socket"; # https://git-scm.com/docs/git-config.html#Documentation/git-config.txt-fsmonitorsocketDir
      };
      gpg = {
        program = "${pkgs.gnupg}/bin/gpg2";
      };
      http = {
        cookiefile = "${config.home.homeDirectory}/.gitcookies";
      };
      maintenance = {
        auto = true; # https://git-scm.com/docs/git-config.html#Documentation/git-config.txt-maintenanceauto
      };
      merge = {
        renormalize = true;
      };
      pretty = {
        # https://github.com/timokau/dotfiles/blob/c2c55834a3b479132ca07794f75a1d887fa29df6/git/.gitconfig
        "lg" =
          "%C(red)%h%C(reset) %C(green)%ci%C(reset) %s %C(bold blue)-- %an%C(reset)%C(yellow)%d%C(reset)";
        "lge" =
          "%C(red)%h%C(reset) %C(green)%ci%C(reset) %s %C(bold blue)-- %an <%ae>%C(reset)%C(yellow)%d%C(reset)";
        "reflg" =
          "%C(red)%h%C(reset) %C(green)%ci%C(reset) %s %C(bold blue)-- %an%C(reset) %C(yellow)(%gd)%C(reset)";
      };
      pull = {
        rebase = true;
      };
      push = {
        followTags = true;
      };
      rerere = {
        enabled = true; # https://github.com/lasseheia/nix/blob/2804cb5670f54c91da65067b204a71a5ff5695fc/modules/git/home-manager.nix#L22
      };
      tags = {
        sort = "version:refname";
        gpgSign = true;
      };
      url = {
        "ssh://git@host" = {
          insteadOf = "otherhost";
        };
        "git@github.com:".pushInsteadOf = [
          "https://github.com/"
          "git://github.com/quentinmit/"
        ];
        "git@github.mit.edu:".insteadOf = "https://github.mit.edu/";
        "git@gitlab.com:".pushInsteadOf = "https://gitlab.com/";
      };
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Leonard Sheng Sheng Lee"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.userName
        email = "leonard.sheng.sheng.lee@gmail.com"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.userEmail
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.settings

    # The built-in macro attribute "binary" is equivalent to [attr]binary -diff -merge -text.
    # https://git-scm.com/docs/gitattributes#_defining_macro_attributes
    attributes = [
      "* text=auto"
      "*.bash eol=lf"
      "*.c text"
      "*.csproj text eol=crlf"
      "*.docx diff=word"
      "*.h text"
      "*.jpeg binary diff=exif"
      "*.jpg binary diff=exif"
      "*.pdf diff=pdf"
      "*.png diff=exif"
      "*.ps1 text eol=crlf"
      "*.py filter=tabspace"
      "*.sh eol=lf"
      "*.sln text eol=crlf"
      "*.txt text"
      # ".* filter=spacify"
      # "* filter=spacify"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.attributes

    hooks = {
      # Inject Co-Authored-By trailer on fresh commits from LLM agents.
      # Priority 1: $LLM_COAUTHOR env var (set by opencode shell alias).
      # Priority 2: ~/.cache/claude-code-current-model written by Claude Code statusLine
      #             (tracks live model switches; expires after 5 minutes to avoid
      #             attributing manual commits outside a Claude Code session).
      prepare-commit-msg = pkgs.writeShellScript "prepare-commit-msg" ''
        COMMIT_MSG_FILE="$1"
        COMMIT_SOURCE="$2"
        MODEL_FILE="$HOME/.cache/claude-code-current-model"

        if [ -z "$COMMIT_SOURCE" ]; then
          if [ -n "$LLM_COAUTHOR" ]; then
            printf '\nCo-Authored-By: %s\n' "$LLM_COAUTHOR" >> "$COMMIT_MSG_FILE"
          elif [ -f "$MODEL_FILE" ]; then
            file_mtime=$(stat -f %m "$MODEL_FILE" 2>/dev/null || stat -c %Y "$MODEL_FILE" 2>/dev/null)
            now=$(date +%s)
            if [ -n "$file_mtime" ] && [ $((now - file_mtime)) -lt 300 ]; then
              model=$(cat "$MODEL_FILE")
              printf '\nCo-Authored-By: Claude Code (%s) <noreply@anthropic.com>\n' "$model" >> "$COMMIT_MSG_FILE"
            fi
          fi
        fi
      '';
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.hooks

    ignores = [
      # https://github.com/quentinmit/isz/blob/1e2cc2af0b5b10529768bbd003e6bc07209448c0/nix/home/base.nix#L44
      ''\#*#''
      ".#*"
      ".claude"
      ".direnv"
      ".DS_Store"
      ".env"
      ".envrc"
      ".Spotlight-V100"
      ".Trashes"
      "*.swp"
      "*#"
      "*~"
      "*password*"
      "*secret*"
      "Desktop.ini"
      "Thumbs.db"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.ignores

    includes = [
      {
        path = "~/.gitignore_global"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.includes._.path
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/bitbucket/**/.git"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.includes._.condition
        path = "${config.home.homeDirectory}/bitbucket/.gitconfig"; # # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.includes._.path
      }
      {
        condition = "gitdir:~/bitbucket/sheeeng/**/.git";
        path = "~/bitbucket/sheeeng/.gitconfig";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/codeberg/**/.git";
        path = "${config.home.homeDirectory}/codeberg/.gitconfig";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/dottir/**/.git";
        path = "${config.home.homeDirectory}/dottir/.gitconfig";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/github/**/.git";
        path = "${config.home.homeDirectory}/github/.gitconfig";
      }
      {
        condition = "gitdir:~/github/sheeeng/**/.git";
        path = "~/github/sheeeng/.gitconfig";
      }
      {
        condition = "gitdir:~/github/techcloud0/";
        path = "~/github/techcloud0/.gitconfig";
      }
      {
        condition = "gitdir:~/github/techcloud0-actions/**/.git";
        path = "~/github/techcloud0-actions/.gitconfig";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/gitlab/**/.git";
        path = "${config.home.homeDirectory}/gitlab/.gitconfig";
      }
      {
        condition = "gitdir:${config.xdg.configHome}/srht/**/.git";
        path = "${config.xdg.configHome}/srht/.gitconfig";
      }
      {
        condition = "gitdir:${config.xdg.configHome}/gitea/**/.git";
        path = "${config.xdg.configHome}/gitea/.gitconfig";
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:sheeeng/vscodium-settings.git";
        contents = {
          user = {
            name = "Sheng Sheng";
            email = "305414+sheeeng@users.noreply.github.com";
          };
        };
      }
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.includes

    lfs = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.lfs.enable
      package = pkgs.git-lfs; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.lfs.package
      skipSmudge = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.lfs.skipSmudge
    };

    maintenance = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.maintenance.enable
      repositories = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.maintenance.repositories
      timers = {
        daily = "Tue..Sun *-*-* 0:53:00";
        hourly = "*-*-* 1..23:53:00";
        weekly = "Mon 0:53:00";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.maintenance.timers
    };

    signing = {
      format = "openpgp"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.signing.format
      key = "0xF104C3F659438426!"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.signing.key
      signByDefault = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.signing.signByDefault
      signer = "${pkgs.gnupg}/bin/gpg2"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.signing.signer
    };
  };
}
