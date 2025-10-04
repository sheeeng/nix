# home level sops. see hosts/core/sops.nix for hosts level

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/secrets";
  inherit (config.home) homeDirectory;
  # Get hostname from system or use current hostname
  hostName = lib.strings.toLower (config.networking.hostName or "tp95v9lwwl");
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # Configure sops at home-manager level
  sops = {
    # This is the location of the host specific age-key and will have been
    # extracted to this location via hosts/core/sops.nix on the host
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${sopsFolder}/common.yaml";
    validateSopsFiles = false;

    # Home-level secrets (these go to ~/.config/sops-nix/secrets/)
    secrets = {
      # Simple hello secret from common.yaml
      hello = { };

      # Password secrets (from passwords section in YAML)
      "passwords/cia_terminal" = { };

      "passwords/citypower_grid" = { };

      "passwords/door_of_durin" = { };

      "passwords/x_files" = { };

      # Token secrets (from tokens section in YAML)
      "tokens/atuin" = { };

      "tokens/github" = { };
    };
  };

  # Create shell aliases for easy access to secret values
  home.shellAliases = {
    # Basic secret access
    show-hello = "cat ${config.sops.secrets.hello.path} 2>/dev/null || echo 'Secret not available.'";

    # Password access aliases
    show-cia-terminal-password = "cat ${
      config.sops.secrets."passwords/cia_terminal".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-citypower-grid-password = "cat ${
      config.sops.secrets."passwords/citypower_grid".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-door-of-durin-password = "cat ${
      config.sops.secrets."passwords/door_of_durin".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-x-files-password = "cat ${
      config.sops.secrets."passwords/x_files".path
    } 2>/dev/null || echo 'Secret not available.'";

    # Token access aliases
    show-atuin-token = "cat ${
      config.sops.secrets."tokens/atuin".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-github-token = "cat ${
      config.sops.secrets."tokens/github".path
    } 2>/dev/null || echo 'Secret not available.'";

    # List all home secrets
    list-home-secrets = "ls -la ~/.config/sops-nix/secrets/ 2>/dev/null || echo 'No secrets directory found.'";
  };

  # Helper script for working with secrets
  home.file.".local/bin/sops-helper" = {
    text = ''
      #!/usr/bin/env bash
      # Helper script for working with secrets

      case "$1" in
        "edit-common")
          sops "${sopsFolder}/common.yaml"
          ;;
        "edit-host")
          sops "${sopsFolder}/${hostName}.yaml"
          ;;
        "show-passwords")
          echo "Available passwords:"
          echo "  CIA Terminal: ${config.sops.secrets."passwords/cia_terminal".path}"
          echo "  Citypower Grid: ${config.sops.secrets."passwords/citypower_grid".path}"
          echo "  Door of Durin: ${config.sops.secrets."passwords/door_of_durin".path}"
          echo "  X-Files: ${config.sops.secrets."passwords/x_files".path}"
          ;;
        "show-tokens")
          echo "Available tokens:"
          echo "  Atuin: ${config.sops.secrets."tokens/atuin".path}"
          echo "  GitHub: ${config.sops.secrets."tokens/github".path}"
          ;;
        "list-home-secrets")
          echo "Home-manager secrets directory:"
          ls -la ~/.config/sops-nix/secrets/ 2>/dev/null || echo "No secrets directory found."
          ;;
        "list-host-secrets")
          echo "Host-level secrets directory:"
          sudo ls -la /run/secrets/ 2>/dev/null || echo "No host secrets directory found or no permission."
          ;;
        *)
          echo "Usage: $0 {edit-common|edit-host|show-passwords|show-tokens|list-home-secrets|list-host-secrets}"
          echo "  edit-common: Edit the common encrypted secrets file."
          echo "  edit-host: Edit the host-specific encrypted secrets file."
          echo "  show-passwords: List available password secrets."
          echo "  show-tokens: List available token secrets."
          echo "  list-home-secrets: List all home-manager secret files."
          echo "  list-host-secrets: List all host-level secret files."
          ;;
      esac
    '';
    executable = true;
  };

  # Create shell scripts for specific secret access
  home.packages = [
    (pkgs.writeShellScriptBin "get-hello" ''
      cat ${config.sops.secrets.hello.path} 2>/dev/null || echo "Hello secret not available."
    '')
    (pkgs.writeShellScriptBin "get-cia-terminal-password" ''
      cat ${
        config.sops.secrets."passwords/cia_terminal".path
      } 2>/dev/null || echo "CIA Terminal password not available."
    '')
    (pkgs.writeShellScriptBin "get-atuin-token" ''
      cat ${config.sops.secrets."tokens/atuin".path} 2>/dev/null || echo "Atuin token not available."
    '')
    (pkgs.writeShellScriptBin "get-github-token" ''
      cat ${config.sops.secrets."tokens/github".path} 2>/dev/null || echo "GitHub token not available."
    '')
  ];

  # Environment variables pointing to secret paths (for applications that need file paths)
  home.sessionVariables = {
    # Basic secret paths
    HELLO_SECRET_FILE = config.sops.secrets.hello.path;

    # Password secret paths
    CIA_TERMINAL_PASSWORD_FILE = config.sops.secrets."passwords/cia_terminal".path;
    CITYPOWER_GRID_PASSWORD_FILE = config.sops.secrets."passwords/citypower_grid".path;
    DOOR_OF_DURIN_PASSWORD_FILE = config.sops.secrets."passwords/door_of_durin".path;
    X_FILES_PASSWORD_FILE = config.sops.secrets."passwords/x_files".path;

    # Token secret paths
    ATUIN_TOKEN_FILE = config.sops.secrets."tokens/atuin".path;
    GITHUB_TOKEN_FILE = config.sops.secrets."tokens/github".path;

    # Host-level secrets (only keys are available at host level)
    HOST_AGE_KEY_FILE = "/run/secrets/keys/age";
    HOST_SSH_KEY_KEYNAME1_FILE = "/run/secrets/keys/ssh/keyname1";
    HOST_SSH_KEY_KEYNAME2_FILE = "/run/secrets/keys/ssh/keyname2";
    HOST_SSH_KEY_KEYNAME3_FILE = "/run/secrets/keys/ssh/keyname3";
  };
}
