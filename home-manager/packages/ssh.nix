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
    enable = true;

    addKeysToAgent = "yes";

    matchBlocks = {
      "SourceHut" = {
        checkHostIP = true;
        compression = true;
        host = "git.sr.ht";
        hostname = "git.sr.ht";
        identitiesOnly = true;
        identityFile = "/home/leonardlee/.ssh/id_ed25519_sheeeng_gmail";
      };
    };
  };
}
