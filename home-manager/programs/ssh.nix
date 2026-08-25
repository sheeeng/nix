{
  config,
  pkgs,
  lib,
  ...
}:
{
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
        IgnoreUnknown = [ "UseKeychain" ]; # https://man.openbsd.org/ssh_config#IgnoreUnknown
        ServerAliveCountMax = 3; # https://man.openbsd.org/ssh_config#ServerAliveCountMax
        ServerAliveInterval = 0; # https://man.openbsd.org/ssh_config#ServerAliveInterval
        UserKnownHostsFile = "~/.ssh/known_hosts"; # https://man.openbsd.org/ssh_config#UserKnownHostsFile
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Store the passphrase in the macOS login keychain after the first prompt.
        UseKeychain = true; # https://man.openbsd.org/ssh_config#UseKeychain
      };
      "github.com" = {
        AddKeysToAgent = "yes"; # https://man.openbsd.org/ssh_config#AddKeysToAgent
        Compression = true; # https://man.openbsd.org/ssh_config#Compression
        HostName = "github.com"; # https://man.openbsd.org/ssh_config#HostName
        IdentityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ]; # https://man.openbsd.org/ssh_config#IdentityFile
        UseKeychain = lib.mkIf pkgs.stdenv.isDarwin true; # https://man.openbsd.org/ssh_config#UseKeychain
      };
      "git.sr.ht" = {
        AddKeysToAgent = "yes"; # https://man.openbsd.org/ssh_config#AddKeysToAgent
        Compression = true; # https://man.openbsd.org/ssh_config#Compression
        HostName = "git.sr.ht"; # https://man.openbsd.org/ssh_config#HostName
        IdentitiesOnly = true; # https://man.openbsd.org/ssh_config#IdentitiesOnly
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.settings
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
