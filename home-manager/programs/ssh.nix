_: {
  programs.ssh = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
    enableDefaultConfig = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enableDefaultConfig
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraConfig
    extraOptionOverrides = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraOptionOverrides
    matchBlocks = {
      "*" = {
        forwardAgent = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.forwardAgent
        addKeysToAgent = "no"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.addKeysToAgent
        compression = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.compression;
        serverAliveInterval = 0; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.serverAliveInterval
        serverAliveCountMax = 3; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.serverAliveCountMax
        hashKnownHosts = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.hashKnownHosts
        userKnownHostsFile = "~/.ssh/known_hosts"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.userKnownHostsFile
        controlMaster = "no"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlMaster
        controlPath = "~/.ssh/master-%r@%n:%p"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlPath
        controlPersist = "no"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlPersist
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enableDefaultConfig
      "SourceHut" = {
        checkHostIP = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.checkHostIP
        compression = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.compression
        host = "git.sr.ht"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.host
        hostname = "git.sr.ht"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.hostname
        identitiesOnly = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.identitiesOnly
        identityFile = "/home/leonardlee/.ssh/id_ed25519_sheeeng_gmail"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.identityFile
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks
  };
}
