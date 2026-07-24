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

  # Automatically unlock the SSH key at login. This reproduces the behavior of
  # the old GNOME Keyring option labeled "Automatically unlock this key whenever
  # I am logged in."
  #
  # The gcr-ssh-agent shipped with gcr version 4 holds keys only in memory.
  # Unlike the SSH component that used to live inside GNOME Keyring, it does not
  # store passphrases in the keyring, so keys are forgotten on every reboot. PAM
  # unlocks the login keyring at GDM login, so this service runs at session
  # start, reads the key passphrase from the login keyring with the secret-tool
  # command, and loads the key into gcr-ssh-agent without a prompt.
  #
  # Complete the setup once. This stores the passphrase in the login keyring:
  #
  #   secret-tool store --label='ssh id_ed25519' ssh id_ed25519
  #
  # After that, logging in at GDM loads the key automatically for good, shared
  # by both terminal sessions and graphical applications such as Visual Studio
  # Code and web browsers.
  systemd.user.services.ssh-add-keys = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Load SSH keys into gcr-ssh-agent using the passphrase from the GNOME login keyring.";
      After = [ "gcr-ssh-agent.socket" ];
      Requires = [ "gcr-ssh-agent.socket" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      Environment = [
        "SSH_AUTH_SOCK=%t/gcr/ssh"
        "SSH_ASKPASS=${pkgs.writeShellScript "ssh-askpass-secret" ''
          exec ${pkgs.libsecret}/bin/secret-tool lookup ssh id_ed25519
        ''}"
        "SSH_ASKPASS_REQUIRE=force"
      ];
      ExecStart = "${pkgs.openssh}/bin/ssh-add %h/.ssh/id_ed25519";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # The secret-tool command from libsecret is required to store the passphrase
  # in the login keyring:
  #
  #   secret-tool store --label='ssh id_ed25519' ssh id_ed25519
  home.packages = lib.mkIf pkgs.stdenv.isLinux [ pkgs.libsecret ];

  # Set GPG_TTY for pinentry to work correctly in terminal sessions.
  home.sessionVariablesExtra = lib.mkIf pkgs.stdenv.isLinux ''
    export GPG_TTY="$(tty)"
  '';
}
