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
  primaryUser = config.system.primaryUser or (builtins.getEnv "USER");
  homeDirectory = "/Users/${primaryUser}";
in
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = "${sopsFolder}/${lib.strings.toLower config.networking.hostName}.yaml";
    validateSopsFiles = true;

    templates = {
      nix-access-token-github.content = ''
        access-tokens = github.com=${config.sops.placeholder."tokens/github/public_repo_scope"}
      '';
    };

    # Age configuration for system level
    age = {
      # Automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # Host-level Secrets
    # stat --format "%A %a %n" /run/secrets/**/*
    secrets = lib.mkMerge [
      {
        # Extract age key to be available for home-manager
        # This is crucial for home-manager sops to work
        "keys/age" = {
          owner = primaryUser;
          group = if pkgs.stdenv.isLinux then "users" else "staff";
          path = "${homeDirectory}/.config/sops/age/keys.txt";
        };

        "tokens/github/public_repo_scope" = {
          owner = primaryUser;
          mode = "0400";
        };
      }
    ];
  };

  system.activationScripts.sopsSetAgeKeyOwnership =
    let
      ageFolder = "${homeDirectory}/.config/sops/age";
      user = primaryUser;
      group = if pkgs.stdenv.isLinux then "users" else "staff";
    in
    ''
      mkdir --parents ${ageFolder} || true
      chown --recursive ${user}:${group} ${homeDirectory}/.config || true
    '';
}
