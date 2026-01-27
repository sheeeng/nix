# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level
# This module is for NixOS (Linux) only.
# For macOS, see hosts/darwin/sops.nix

{
  inputs,
  config,
  lib,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/secrets";
  inherit (config.system) primaryUser;
  homeDirectory = "/home/${primaryUser}";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options = {
    system.primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "Primary user for the system";
    };
  };

  config = {
    sops = {
      # HOST-LEVEL secrets file (encrypted with host SSH key)
      # Path: secrets/hosts/<hostname>.yaml
      defaultSopsFile = "${sopsFolder}/hosts/${lib.strings.toLower config.networking.hostName}.yaml";
      validateSopsFiles = true;

      templates = {
        nix-access-token = {
          content = ''
            access-tokens = github.com=${config.sops.placeholder."tokens/github/repo_scope"}
          '';
        };
      };

      # Age configuration for HOST-LEVEL decryption only
      # Only uses the host SSH key to decrypt host-specific secrets
      age = {
        # Host SSH key path - sops-nix will convert this to age format automatically
        # Explicitly specify only ed25519 to prevent sops-nix from looking for RSA keys
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519" ];
        # Store the derived host age key at /etc/sops/age/keys.txt
        # This is the HOST's age key, derived from /etc/ssh/ssh_host_ed25519
        keyFile = "/etc/sops/age/keys.txt";
      };

      # Host-level Secrets (encrypted with HOST age key ONLY)
      # These secrets are in secrets/hosts/<hostname>.yaml
      # stat --format "%A %a %n" /run/secrets/**/*
      secrets = {
        # Host-level GitHub token (encrypted with host key in host-specific secrets file)
        "tokens/github/repo_scope" = {
          owner = primaryUser;
          group = "users";
        };

        # USER's age key extracted from host-level secrets
        # This allows bootstrapping: the host deploys the user's age key
        # so home-manager can then use it to decrypt user-level secrets
        "keys/age" = {
          owner = primaryUser;
          group = "users";
          path = "${homeDirectory}/.config/sops/age/keys.txt";
          mode = "0600";
        };
      };
    };

    # Activation scripts to ensure proper directory structure and permissions
    system.activationScripts = {
      # 1. Create HOST-LEVEL age key directory at /etc/sops/age/
      # This will store the age key derived from the host's SSH key
      sopsCreateSystemAgeDirectory = {
        text = ''
          mkdir --parents /etc/sops/age || true
          chmod 755 /etc/sops
          chmod 700 /etc/sops/age
        '';
      };

      # 2. Create USER-LEVEL age key directory at ~/.config/sops/age/
      # This will store the user's age key (extracted from secrets)
      sopsSetAgeKeyOwnership = {
        text =
          let
            ageFolder = "${homeDirectory}/.config/sops/age";
            user = primaryUser;
            group = "users";
          in
          ''
            mkdir --parents ${ageFolder} || true
            chown --recursive ${user}:${group} ${homeDirectory}/.config || true
          '';
      };
    };
  }; # Close config block
}
