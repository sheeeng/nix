# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level
# This module is for macOS (nix-darwin) only.
# For NixOS, configure sops directly in hosts/nixos/default.nix

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/secrets";
  primaryUser = config.system.primaryUser or (builtins.getEnv "USER");
  homeDirectory = "/Users/${primaryUser}";
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [ inputs.sops-nix.darwinModules.sops ];

  sops = {
    # HOST-LEVEL secrets file (encrypted with host SSH key)
    # Path: secrets/hosts/<hostname>.yaml
    defaultSopsFile = "${sopsFolder}/hosts/${lib.strings.toLower config.networking.hostName}.yaml";
    validateSopsFiles = true;

    templates = {
      nix-access-token.content = ''
        access-tokens = github.com=${config.sops.placeholder."tokens/github/public_repo_scope"}
      '';
    };

    # Age configuration for HOST-LEVEL decryption only
    # Only uses the host SSH key to decrypt host-specific secrets
    age = {
      # Host SSH key path - sops-nix will convert this to age format automatically
      # Explicitly specify only ed25519 to prevent sops-nix from looking for RSA keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # Store the derived host age key at /etc/sops/age/keys.txt
      # This is the HOST's age key, derived from /etc/ssh/ssh_host_ed25519_key
      keyFile = "/etc/sops/age/keys.txt";
    };

    # Host-level Secrets (encrypted with HOST age key ONLY)
    # These secrets are in secrets/hosts/<hostname>.yaml
    # stat --format "%A %a %n" /run/secrets/**/*
    secrets = lib.mkMerge [
      {
        # Host-level GitHub token (encrypted with host key in host-specific secrets file)
        "tokens/github/public_repo_scope" = {
          owner = primaryUser;
          group = if isLinux then "users" else "staff";
        };

        # USER's age key extracted from host-level secrets
        # This allows bootstrapping: the host deploys the user's age key
        # so home-manager can then use it to decrypt user-level secrets
        "keys/age" = {
          owner = primaryUser;
          group = if isLinux then "users" else "staff";
          path = "${homeDirectory}/.config/sops/age/keys.txt";
          mode = "0600";
        };
      }
    ];
  };

  # Activation scripts to ensure proper directory structure and permissions
  system.activationScripts = {
    # 1. Create HOST-LEVEL age key directory at /etc/sops/age/
    # This will store the age key derived from the host's SSH key
    sopsCreateSystemAgeDirectory = ''
      mkdir --parents /etc/sops/age || true
      chmod 755 /etc/sops
      chmod 700 /etc/sops/age
    '';

    # 2. Create USER-LEVEL age key directory at ~/.config/sops/age/
    # This will store the user's age key (extracted from secrets)
    sopsSetAgeKeyOwnership =
      let
        ageFolder = "${homeDirectory}/.config/sops/age";
        user = primaryUser;
        group = if isLinux then "users" else "staff";
      in
      ''
        mkdir --parents ${ageFolder} || true
        chown --recursive ${user}:${group} ${homeDirectory}/.config || true
      '';
  };
}
