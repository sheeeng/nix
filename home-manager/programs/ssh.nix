{
  config,
  ...
}:
{
  imports = [
    ./ssh-darwin.nix
    ./ssh-linux.nix
  ];

  programs.ssh = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
    enableDefaultConfig = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enableDefaultConfig
    package = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.package
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraConfig
    extraOptionOverrides = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraOptionOverrides
    includes = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.includes
    # Home Manager deprecated programs.ssh.matchBlocks in favor of
    # programs.ssh.settings. The attribute name is the Host pattern, and each
    # block uses upstream OpenSSH directive names. checkHostIP is dropped
    # because its previous value of true produced no directive.
    settings = {
      "*" = {
        AddKeysToAgent = "yes"; # https://man.openbsd.org/ssh_config#AddKeysToAgent
        Compression = false; # https://man.openbsd.org/ssh_config#Compression
        ControlMaster = "no"; # https://man.openbsd.org/ssh_config#ControlMaster
        ControlPath = "~/.ssh/master-%r@%n:%p"; # https://man.openbsd.org/ssh_config#ControlPath
        ControlPersist = "no"; # https://man.openbsd.org/ssh_config#ControlPersist
        ForwardAgent = false; # https://man.openbsd.org/ssh_config#ForwardAgent
        HashKnownHosts = false; # https://man.openbsd.org/ssh_config#HashKnownHosts
        ServerAliveCountMax = 3; # https://man.openbsd.org/ssh_config#ServerAliveCountMax
        ServerAliveInterval = 0; # https://man.openbsd.org/ssh_config#ServerAliveInterval
        UserKnownHostsFile = "~/.ssh/known_hosts"; # https://man.openbsd.org/ssh_config#UserKnownHostsFile
      };
      "github.com" = {
        AddKeysToAgent = "yes"; # https://man.openbsd.org/ssh_config#AddKeysToAgent
        Compression = true; # https://man.openbsd.org/ssh_config#Compression
        HostName = "github.com"; # https://man.openbsd.org/ssh_config#HostName
        IdentityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ]; # https://man.openbsd.org/ssh_config#IdentityFile
      };
      "git.sr.ht" = {
        AddKeysToAgent = "yes"; # https://man.openbsd.org/ssh_config#AddKeysToAgent
        Compression = true; # https://man.openbsd.org/ssh_config#Compression
        HostName = "git.sr.ht"; # https://man.openbsd.org/ssh_config#HostName
        IdentitiesOnly = true; # https://man.openbsd.org/ssh_config#IdentitiesOnly
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.settings
  };

}
