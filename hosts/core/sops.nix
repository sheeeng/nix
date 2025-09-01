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
    validateSopsFiles = true;

    # Age configuration for system level
    age = {
      # Automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # System-level secrets (these go to /run/secrets/)
    secrets = {
      # Extract age key to be available for home-manager
      # "keys/age" = {
      #   owner = config.system.primaryUser;
      #   group = if pkgs.stdenv.isLinux then "users" else "staff";
      #   path = "/Users/${config.system.primaryUser}/.config/sops/age/keys.txt";
      # };

      # Host-level secrets based on YAML structure
      # example_number = {
      #   owner = config.system.primaryUser;
      #   mode = "0400";
      # };

      # example_boolean = {
      #   owner = config.system.primaryUser;
      #   mode = "0400";
      # };

      example_key = {
        owner = config.system.primaryUser;
        mode = "0400";
      };

      # TODO: https://github.com/Mic92/sops-nix/issues/604
      # Nested structure secret - use exact path from YAML
      # "example_services.example_subdirectory.example_password" = {
      #   owner = config.system.primaryUser;
      #   mode = "0400";
      # };
    };
  };

  # Ensure ownership of age directory for home-manager
  system.activationScripts.sopsSetAgeKeyOwnership =
    let
      ageFolder = "/Users/${config.system.primaryUser}/.config/sops/age";
      user = config.system.primaryUser;
      group = if pkgs.stdenv.isLinux then "users" else "staff";
    in
    ''
      mkdir -p ${ageFolder} || true
      chown -R ${user}:${group} /Users/${config.system.primaryUser}/.config || true
    '';
}
