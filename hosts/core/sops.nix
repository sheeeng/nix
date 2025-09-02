# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/secrets";
  # Get primary user from config or fallback to current user
  primaryUser = config.system.primaryUser or (builtins.getEnv "USER");
  homeDirectory = "/Users/${primaryUser}";
in
{
  # Import sops-nix module for system-level
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  # Configure sops at system level
  sops = {
    # Use host name to determine which secrets file to load
    defaultSopsFile = "${sopsFolder}/${lib.strings.toLower config.networking.hostName}.yaml";
    validateSopsFiles = false; # Set to false to avoid validation issues during development

    # Age configuration for system level
    age = {
      # Automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # System-level secrets (these go to /run/secrets/)
    secrets = lib.mkMerge [
      {
        # Extract age key to be available for home-manager
        # This is crucial for home-manager sops to work
        "keys/age" = {
          owner = primaryUser;
          group = if pkgs.stdenv.isLinux then "users" else "staff";
          path = "${homeDirectory}/.config/sops/age/keys.txt";
        };

        # SSH keys from host-specific YAML (tp95v9lwwl.yaml)
        "keys/ssh/keyname1" = {
          owner = primaryUser;
          mode = "0400";
        };

        "keys/ssh/keyname2" = {
          owner = primaryUser;
          mode = "0400";
        };

        "keys/ssh/keyname3" = {
          owner = primaryUser;
          mode = "0400";
        };
      }

      # Common secrets from common.yaml (if needed at system level)
      # Uncomment if you need these secrets available to system services
      # {
      #   # Common shared secrets from common.yaml
      #   "hello" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      #
      #   # System-level password secrets from common.yaml
      #   "passwords/cia_terminal" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      #
      #   "passwords/citypower_grid" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      #
      #   "passwords/door_of_durin" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      #
      #   "passwords/x_files" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      #
      #   # System-level token secrets from common.yaml
      #   "tokens/atuin" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      #
      #   "tokens/github" = {
      #     sopsFile = "${sopsFolder}/common.yaml";
      #     owner = primaryUser;
      #     mode = "0400";
      #   };
      # }
    ];
  };

  # Ensure ownership of age directory for home-manager
  # This is crucial for home-manager sops to work properly
  system.activationScripts.sopsSetAgeKeyOwnership =
    let
      ageFolder = "${homeDirectory}/.config/sops/age";
      user = primaryUser;
      group = if pkgs.stdenv.isLinux then "users" else "staff";
    in
    ''
      mkdir -p ${ageFolder} || true
      chown -R ${user}:${group} ${homeDirectory}/.config || true
    '';
}
