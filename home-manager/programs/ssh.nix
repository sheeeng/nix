{ pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
    enableDefaultConfig = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enableDefaultConfig
    package = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.package
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraConfig
    extraOptionOverrides = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraOptionOverrides
    includes = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.includes
    matchBlocks = {
      "*" = {
        forwardAgent = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.forwardAgent
        addKeysToAgent = "yes"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.addKeysToAgent
        compression = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.compression;
        serverAliveInterval = 0; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.serverAliveInterval
        serverAliveCountMax = 3; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.serverAliveCountMax
        hashKnownHosts = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.hashKnownHosts
        userKnownHostsFile = "~/.ssh/known_hosts"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.userKnownHostsFile
        controlMaster = "no"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlMaster
        controlPath = "~/.ssh/master-%r@%n:%p"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlPath
        controlPersist = "no"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlPersist
        extraOptions = lib.mkIf pkgs.stdenv.isDarwin { UseKeychain = "yes"; }; # macOS keychain support
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enableDefaultConfig
      "GitHub" = {
        addKeysToAgent = "yes"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.addKeysToAgent
        checkHostIP = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.checkHostIP
        compression = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.compression
        host = "github.com"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.host
        hostname = "github.com"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.hostname
        identityFile = [ "~/.ssh/id_ed25519" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.identityFile
        extraOptions = lib.mkIf pkgs.stdenv.isDarwin { UseKeychain = "yes"; }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.extraOptions
      };
      "SourceHut" = {
        addKeysToAgent = "yes"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.addKeysToAgent
        checkHostIP = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.checkHostIP
        compression = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.compression
        host = "git.sr.ht"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.host
        hostname = "git.sr.ht"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.hostname
        identitiesOnly = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.identitiesOnly
        identityFile = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.identityFile
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks
  };

  # SSH_AUTH_SOCK is set automatically by GNOME Keyring's gcr-ssh-agent on Linux.
  # gcr-ssh-agent only holds keys in memory (session-scoped); keychain below
  # adds id_ed25519 to it at first terminal open after reboot, prompting once.
  programs.keychain = lib.mkIf pkgs.stdenv.isLinux {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.keychain.enable
    keys = [ "id_ed25519" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.keychain.keys
    agents = [ "ssh" ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.keychain.agents
    inheritType = "any"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.keychain.inheritType
    extraFlags = [
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.keychain.extraFlags
      "--quiet"
      "--nocolor"
    ];
  };

  # Set GPG_TTY for pinentry to work correctly in terminal sessions.
  home.sessionVariablesExtra = lib.mkIf pkgs.stdenv.isLinux ''
    export GPG_TTY="$(tty)"
  '';
}
