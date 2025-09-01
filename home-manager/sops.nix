# home level sops. see hosts/common/core/sops.nix for hosts level

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/secrets";
  # Extract hostname from homeDirectory path for consistency with host config
  hostName = lib.strings.toLower config.home.hostName or "tp95v9lwwl";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # Configure sops at home-manager level
  sops = {
    # Use the same secrets file as the host but different secrets
    defaultSopsFile = "${sopsFolder}/${hostName}.yaml";
    validateSopsFiles = false;

    # Age configuration for home-manager level
    age = {
      # Use the age key file that was created by the system configuration
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    # Home-level secrets (these go to ~/.config/sops-nix/secrets/)
    secrets = {
      # Simple hello secret
      hello = {
        # This will be available at ~/.config/sops-nix/secrets/hello
      };

      # Password secrets (from passwords section in YAML)
      "passwords_cia_terminal" = {
        name = "passwords.cia_terminal";
        # This will be available at ~/.config/sops-nix/secrets/passwords_cia_terminal
      };

      "passwords_citypower_grid" = {
        name = "passwords.citypower_grid";
        # This will be available at ~/.config/sops-nix/secrets/passwords_citypower_grid
      };

      "passwords_door_of_durin" = {
        name = "passwords.door_of_durin";
        # This will be available at ~/.config/sops-nix/secrets/passwords_door_of_durin
      };

      "passwords_x_files" = {
        name = "passwords.x_files";
        # This will be available at ~/.config/sops-nix/secrets/passwords_x_files
      };

      # Token secrets (from tokens section in YAML)
      "tokens_atuin" = {
        name = "tokens.atuin";
        # This will be available at ~/.config/sops-nix/secrets/tokens_atuin
      };

      "tokens_github" = {
        name = "tokens.github";
        # This will be available at ~/.config/sops-nix/secrets/tokens_github
      };
    };
  };

  # Create shell aliases for easy access to secret values
  home.shellAliases = {
    # Basic secret access
    show-hello = "cat ${config.sops.secrets.hello.path} 2>/dev/null || echo 'Secret not available'";

    # Password access aliases
    show-cia-terminal-password = "cat ${config.sops.secrets.passwords_cia_terminal.path} 2>/dev/null || echo 'Secret not available'";
    show-citypower-grid-password = "cat ${config.sops.secrets.passwords_citypower_grid.path} 2>/dev/null || echo 'Secret not available'";
    show-door-of-durin-password = "cat ${config.sops.secrets.passwords_door_of_durin.path} 2>/dev/null || echo 'Secret not available'";
    show-x-files-password = "cat ${config.sops.secrets.passwords_x_files.path} 2>/dev/null || echo 'Secret not available'";

    # Token access aliases
    show-atuin-token = "cat ${config.sops.secrets.tokens_atuin.path} 2>/dev/null || echo 'Secret not available'";
    show-github-token = "cat ${config.sops.secrets.tokens_github.path} 2>/dev/null || echo 'Secret not available'";
  };

  # Helper script for working with secrets
  home.file.".local/bin/sops-helper" = {
    text = ''
      #!/usr/bin/env bash
      # Helper script for working with secrets

      case "$1" in
        "edit")
          sops "${sopsFolder}/${hostName}.yaml"
          ;;
        "show-passwords")
          echo "Available passwords:"
          echo "  CIA Terminal: ${config.sops.secrets.passwords_cia_terminal.path}"
          echo "  Citypower Grid: ${config.sops.secrets.passwords_citypower_grid.path}"
          echo "  Door of Durin: ${config.sops.secrets.passwords_door_of_durin.path}"
          echo "  X-Files: ${config.sops.secrets.passwords_x_files.path}"
          ;;
        "show-tokens")
          echo "Available tokens:"
          echo "  Atuin: ${config.sops.secrets.tokens_atuin.path}"
          echo "  GitHub: ${config.sops.secrets.tokens_github.path}"
          ;;
        "list-home-secrets")
          echo "Home-manager secrets directory:"
          ls -la ~/.config/sops-nix/secrets/ 2>/dev/null || echo "No secrets directory found"
          ;;
        *)
          echo "Usage: $0 {edit|show-passwords|show-tokens|list-home-secrets}"
          echo "  edit: Edit the encrypted secrets file"
          echo "  show-passwords: List available password secrets"
          echo "  show-tokens: List available token secrets"
          echo "  list-home-secrets: List all home-manager secret files"
          ;;
      esac
    '';
    executable = true;
  };

  # Create shell scripts for specific secret access
  home.packages = [
    (pkgs.writeShellScriptBin "get-hello" ''
      cat ${config.sops.secrets.hello.path} 2>/dev/null || echo "Hello secret not available"
    '')
    (pkgs.writeShellScriptBin "get-cia-terminal-password" ''
      cat ${config.sops.secrets.passwords_cia_terminal.path} 2>/dev/null || echo "CIA Terminal password not available"
    '')
    (pkgs.writeShellScriptBin "get-atuin-token" ''
      cat ${config.sops.secrets.tokens_atuin.path} 2>/dev/null || echo "Atuin token not available"
    '')
    (pkgs.writeShellScriptBin "get-github-token" ''
      cat ${config.sops.secrets.tokens_github.path} 2>/dev/null || echo "GitHub token not available"
    '')
  ];

  # Environment variables pointing to secret paths (for applications that need file paths)
  home.sessionVariables = {
    # Basic secret paths
    HELLO_SECRET_FILE = config.sops.secrets.hello.path;

    # Password secret paths
    CIA_TERMINAL_PASSWORD_FILE = config.sops.secrets.passwords_cia_terminal.path;
    CITYPOWER_GRID_PASSWORD_FILE = config.sops.secrets.passwords_citypower_grid.path;
    DOOR_OF_DURIN_PASSWORD_FILE = config.sops.secrets.passwords_door_of_durin.path;
    X_FILES_PASSWORD_FILE = config.sops.secrets.passwords_x_files.path;

    # Token secret paths
    ATUIN_TOKEN_FILE = config.sops.secrets.tokens_atuin.path;
    GITHUB_TOKEN_FILE = config.sops.secrets.tokens_github.path;

    # Host-level secrets (for reference)
    HOST_EXAMPLE_KEY_FILE = "/run/secrets/example_key";
    HOST_EXAMPLE_NUMBER_FILE = "/run/secrets/example_number";
    HOST_EXAMPLE_BOOLEAN_FILE = "/run/secrets/example_boolean";
    HOST_EXAMPLE_SERVICES_PASSWORD_FILE = "/run/secrets/example_services_password";
  };
}
