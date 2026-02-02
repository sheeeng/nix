# TODO: https://github.com/kpritam/nixpkgs/blob/dbc2a1538b2c6dfd1d11fb97c08203643c723ff0/home/git.nix

{
  config,
  inputs,
  pkgs,
  ...
}:
let

  # https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/git/default.nix#L6-L12
  git-credential-oauth-wrapper = pkgs.writeShellScriptBin "git-credential-oauth-wrapper" ''
    if [ -n "$REMOTE" ] || [ -n "$SSH_CLIENT" ]; then
      exec ${pkgs.git-credential-oauth}/bin/git-credential-oauth -device "$@"
    else
      exec ${pkgs.git-credential-oauth}/bin/git-credential-oauth "$@"
    fi
  '';

  myselfName = "sheeeng";
  secrets = inputs.nix-secrets.${myselfName};
in
{
  # https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/git/default.nix#L14
  home.packages = with pkgs; [
    # keep-sorted start
    codeberg-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=codeberg-cli
    gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
    gh-f # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-f
    gh-i # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-i
    gh-s # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-s
    ghq # https://search.nixos.org/packages?channel=unstable&type=packages&show=ghq
    git-credential-oauth-wrapper # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-credential-oauth
    git-filter-repo # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-filter-repo
    git-lfs # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-lfs
    gitleaks # https://search.nixos.org/packages?channel=unstable&type=packages&show=gitleaks
    glab # https://search.nixos.org/packages?channel=unstable&type=packages&show=glab
    hut # https://search.nixos.org/packages?channel=unstable&type=packages&show=hut
    # pre-commit # @upstream-issue https://github.com/nixos/nixpkgs/issues/483584
    tea # https://search.nixos.org/packages?channel=unstable&type=packages&show=tea
    # keep-sorted end
  ];

  # https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/git/default.nix#L19
  home.sessionVariables = {
    # GIT_EDITOR = "${pkgs.neovim}/bin/nvim"; # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  };

  # home.file."bitbucket/.gitconfig".source = ./gitconfig-private.ini;
  home.file."bitbucket/.gitconfig" = {
    text = ''
      [user]
        email = ${secrets.email.private or "unknown.user@undefined.domain"}
        gitHub = ${secrets.email.gitHub or "unknown.user@undefined.domain"}
        gitLab = ${secrets.email.gitLab or "unknown.user@undefined.domain"}
        name = ${secrets.userPreferredName or "Unknown User"}
        personal = ${secrets.email.personal or "unknown.user@undefined.domain"}
        private = ${secrets.email.private or "unknown.user@undefined.domain"}
      [credential]
        helper = oauth
      [init]
        defaultBranch = main
    '';
  };
  home.file."bitbucket/sheeeng/.gitconfig".source = ./gitconfig-private.ini;
  home.file."codeberg/.gitconfig".source = ./gitconfig-private.ini;
  home.file."dottir/.gitconfig".source = ./gitconfig-private.ini;
  home.file."github/.gitconfig".source = ./gitconfig-github-noreply.ini;
  home.file."github/sheeeng/.gitconfig".source = ./gitconfig-github-noreply.ini;
  home.file."github/github/.gitconfig" = {
    text = ''
      [user]
        name = ${inputs.nix-secrets-example.octocat.userFullName or "Octocat"}
        email = ${
          inputs.nix-secrets-example.octocat.email.work or "583231+octocat@users.noreply.github.com"
        }
        useConfigOnly = true
      [commit]
        gpgsign = ${inputs.nix-secrets-example.octocat.gpgsign or "false"}
    '';
  };
  home.file."github/techcloud0-actions/.gitconfig".source = ./gitconfig-github-techcloud0.ini;
  home.file."github/techcloud0/.gitconfig".source = ./gitconfig-github-techcloud0.ini;
  home.file."gitlab/.gitconfig".source = ./gitconfig-gitlab.ini;
  home.file."srht/.gitconfig".source = ./gitconfig-private.ini;
  home.file."gitea/.gitconfig".source = ./gitconfig-private.ini;

  # Enable ssh-agent on Linux for file-based SSH keys.
  # gpg-agent handles GPG operations only; ssh-agent handles SSH key caching.
  services.ssh-agent.enable = if pkgs.stdenv.isDarwin then false else true;

  programs = {
    delta = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.enable
      package = pkgs.delta; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.package
      enableGitIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.enableGitIntegration
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        # features = "decorations"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
        whitespace-error-style = "22 reverse";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.options
    };

    diff-highlight = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-highlight.enable
      pagerOpts = [
        "--color-moved=dimmed_zebra"
        "--tabs=2"
        "--RAW-CONTROL-CHARS" # -R
        "--quit-if-one-screen" # -F
        "--no-init" # -X
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-highlight.pagerOpts
    };
    diff-so-fancy = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-so-fancy.enable
      pagerOpts = [
        "--tabs=2"
        "--RAW-CONTROL-CHARS" # -R
        "--quit-if-one-screen" # -F
        "--no-init" # -X
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-so-fancy.pagerOpts
      settings = {
        changeHunkIndicators = true;
        markEmptyLines = true;
        rulerWidth = 80;
        stripLeadingSymbols = true;
        useUnicodeRuler = true;
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.diff-so-fancy.settings
    };
    difftastic = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.difftastic.enable
      git.diffToolMode = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.difftastic.git.diffToolMode
      package = [ pkgs.difftastic ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.difftastic.package
      options = {
        background = "light";
        color = "auto";
        display = "side-by-side";
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.difftastic.options
    };
    # TODO: git config --list --show-origin
    # TODO: git check-ignore --verbose -- .DS_Store
    # TODO: git config --get --global core.excludesFile
    git = {
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
          lfs = {
            process = "git-lfs filter-process";
            clean = "git-lfs clean -- %f";
            smudge = "git-lfs smudge -- %f";
            required = true;
          };
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

      hooks = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.hooks

      ignores = [
        # https://github.com/quentinmit/isz/blob/1e2cc2af0b5b10529768bbd003e6bc07209448c0/nix/home/base.nix#L44
        ''\#*#''
        ".#*"
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

    # curl \
    #   --silent \
    #   --location \
    #   --header "Accept: application/vnd.github+json" \
    #   --header "Authorization: Bearer $GITHUB_TOKEN" \
    #   --header "X-GitHub-Api-Version: 2022-11-28" \
    #   "https://models.github.ai/catalog/models" \
    #   | jq '.[] | {id, name, publisher}'

    # Important note: The GitHub Models API queried (models.github.ai) does not include Anthropic Claude models.
    # Claude Opus 4.5 is only available through GitHub Copilot (api.githubcopilot.com), which is a separate service.
    # That's why opencode was using the github-copilot provider, not github-models.

    gh = {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable
      package = pkgs.gh; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.package
      extensions = with pkgs; [
        # keep-sorted start
        gh-actions-cache # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-actions-cache
        gh-cal # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-cal
        gh-classroom # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-classroom
        gh-contribs # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-contribs
        gh-dash # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-dash
        gh-eco # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-eco
        gh-f # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-f
        gh-gei # @upstream-issue https://github.com/NixOS/nixpkgs/issues/483584 # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-gei
        gh-i # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-i
        gh-markdown-preview # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-markdown-preview
        gh-notify # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-notify
        gh-ost # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-ost
        gh-poi # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-poi
        gh-s # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-s
        gh-screensaver # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-screensaver
        gh-signoff # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-signoff
        gh-skyline # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-skyline
        gh-webhook # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-webhook
        github-copilot-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=github-copilot-cli
        # keep-sorted end
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.extensions
      gitCredentialHelper = {
        enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.gitCredentialHelper.enable
        hosts = [
          "https://github.com"
          "https://gist.github.com"
        ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.gitCredentialHelper.hosts
      };
      hosts = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.hosts
      settings = {
        editor = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings.editor
        git_protocol = "ssh"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings.git_protocol
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings
      # settings = {
      #   # https://cli.github.com/manual/gh_config
      #   # keep-sorted start block=yes newline_separated=no sticky_comments=yes
      #   aliases = {
      #     # https://github.com/kpritam/nixpkgs/blob/dbc2a1538b2c6dfd1d11fb97c08203643c723ff0/home/gh-aliases.nix
      #     icl = "issue close";
      #     icr = "issue create";
      #     il = "issue list";
      #     ire = "issue reopen";
      #     iv = "issue view";
      #     ivw = "issue view --web";
      #     pck = "pr checks";
      #     pcl = "pr close";
      #     pco = "pr checkout";
      #     pcr = "pr create";
      #     pd = "pr diff";
      #     pl = "pr list";
      #     pm = "pr merge";
      #     pre = "pr reopen";
      #     pv = "pr view";
      #     pvw = "pr view --web";
      #     rcl = "repo clone";
      #     rcr = "repo create";
      #     rfk = "repo fork --clone --remote";
      #     rv = "repo view";
      #     rvw = "repo view --web";
      #   }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings.aliases
      #   editor = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings.editor
      #   git_protocol = "ssh"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings.git_protocol
      #   pager = "cat";
      #   prompt = "enabled";
      #   spinner = "enabled";
      #   # keep-sorted end
      # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.settings
    };
  };
}
