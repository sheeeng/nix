{ pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;
with import <home-manager/modules/lib/dag.nix> { inherit lib; };

{
  home.packages = [
    mdcat
    pkgs.bc
    pkgs.cowsay
    pkgs.fortune
    pkgs.gnupg
    pkgs.htop
    pkgs.htop
    pkgs.jq
    pkgs.lolcat
    pkgs.ncdu
    pkgs.termite pkgs.tmux
    pkgs.unzip
    pkgs.wget
    pkgs.whois
    xclip
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.atuin.enable = true;

  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };

  programs.fzf.enable = true;

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Leonard Sheng Sheng Lee";
    userEmail = "305414+sheeeng@users.noreply.github.com";
    signing = {
      key = "305414+sheeeng@users.noreply.github.com";
      signByDefault = false;
    };
    extraConfig = {
      pull = {
        rebase = true;
      };
      commit.gpgsign = false;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      rerere.enabled = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
      core.pager = "bat";
      maintenance.auto = true;
      core.untrackedcache = true;
      core.fsmonitor = true;
    };
  };

  programs.gh.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.kitty = {
    enable = true;
    theme = "GitHub Dark Dimmed";
    settings = {
      background_opacity = "0.8";
    };
  };

  programs.ssh = {
    enable = true;
    agent = {
      enable = true;
      enableGpgSupport = true;
    };
    extraConfig = ''
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519

    AllowAgentForwarding yes
    AllowTcpForwarding yes
    X11Forwarding yes
    X11DisplayOffset 10
    X11UseLocalhost no
    '';
  };

  programs.starship = {
    enable = true;
    settings.add_newline = false;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    initExtra = builtins.readFile zsh/initExtra;
    oh-my-zsh = {
      enable = true;
    };
    shellAliases = {
      vim = "nvim";
    };
  };

}
