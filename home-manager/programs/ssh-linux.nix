{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    # Automatically unlock the SSH key at login. This stores the passphrase in
    # the login keyring and loads the key into gcr-ssh-agent.
    systemd.user.services.ssh-add-keys = {
      Unit = {
        Description = "Load SSH keys into gcr-ssh-agent using the passphrase from the login keyring.";
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

    home.packages = [ pkgs.libsecret ];

    home.sessionVariablesExtra = ''
      export GPG_TTY="$(tty)"
    '';
  };
}
