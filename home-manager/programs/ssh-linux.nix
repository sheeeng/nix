{ lib, pkgs, ... }:
let
  sshPassphraseStore = pkgs.writeShellApplication {
    name = "ssh-passphrase-store";
    runtimeInputs = [
      pkgs.libsecret
      pkgs.systemd
    ];
    text = ''
      if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        echo "SSH key not found: ~/.ssh/id_ed25519" >&2
        exit 1
      fi

      secret-tool store \
        --label="SSH passphrase for ~/.ssh/id_ed25519" \
        ssh id_ed25519
      systemctl --user restart ssh-add-keys.service
    '';
  };
in
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

    home.packages = [
      pkgs.libsecret
      sshPassphraseStore
    ];

    sshAuthSock = {
      enable = true;
      initialization = {
        bash = ''export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"'';
        fish = ''set --export SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gcr/ssh"'';
        nushell = ''$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/gcr/ssh"'';
        zsh = ''export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"'';
      };
      systemd.socketProviderUnit = "gcr-ssh-agent.socket";
    };

    home.sessionVariablesExtra = ''
      export GPG_TTY="$(tty)"
    '';
  };
}
