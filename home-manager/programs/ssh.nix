{
  # programs.ssh.enable = true;
  # programs.ssh.controlMaster = "auto";
  # programs.ssh.controlPath = "/tmp/ssh-%u-%r@%h:%p";
  # programs.ssh.controlPersist = "60";
  # programs.ssh.forwardAgent = true;
  # programs.ssh.serverAliveInterval = 60;
  # programs.ssh.hashKnownHosts = true;
  # programs.ssh.extraConfig = ''
  #   Host remarkable
  #     Hostname 10.11.99.1
  #     User root
  #     ForwardX11 no
  #     ForwardAgent no
  # '';

  programs.ssh = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
    enableDefaultConfig = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enableDefaultConfig
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.addKeysToAgent
        addressFamily = "any"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.addressFamily
        certificateFile = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.certificateFile
        checkHostIP = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.checkHostIP
        compression = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.compression
        controlMaster = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlMaster
        controlPath = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlPath
        controlPersist = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.controlPersist
        dynamicForwards = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.matchBlocks._name_.dynamicForwards
      };
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
