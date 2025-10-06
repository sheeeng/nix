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
      "passwords/atuin" = { };

      "passwords/cia_terminal" = { };

      "passwords/citypower_grid" = { };

      "passwords/door_of_durin" = { };

      "passwords/x_files" = { };

      # Keys secrets (from keys section in YAML)
      "keys/atuin" = { };
      "keys/ssh/id_ed25519/public" = {
        path = "${homeDirectory}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "keys/ssh/id_ed25519/private" = {
        path = "${homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };

      # Token secrets (from tokens section in YAML)
      "tokens/github" = { };

      # "tokens/github/public_repo_scope" = { };
    };
  };

  # Ensure .ssh directory exists with proper permissions
  home.file.".ssh/.keep" = {
    text = "";
  };

  home.activation.setupSshDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ${homeDirectory}/.ssh
    $DRY_RUN_CMD chmod 700 ${homeDirectory}/.ssh
  '';

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
    show-atuin-key = "cat ${
      config.sops.secrets."keys/atuin".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-ed25519-ssh-public-key = "cat ${homeDirectory}/.ssh/id_ed25519.pub 2>/dev/null || echo 'Secret not available.'";
    show-ed25519-ssh-private-key = "cat ${homeDirectory}/.ssh/id_ed25519 2>/dev/null || echo 'Secret not available.'";

    show-github-token = "cat ${
      config.sops.secrets."tokens/github".path
    } 2>/dev/null || echo 'Secret not available.'";
    # show-github-public-repo-scope-token = "cat ${
    #   config.sops.secrets."tokens/github/public_repo_scope".path
    # } 2>/dev/null || echo 'Secret not available.'";

    # List all home secrets
    list-home-secrets = "ls -la ~/.config/sops-nix/secrets/ 2>/dev/null || echo 'No secrets directory found.'";

    # Nix configuration helpers
    show-nix-access-tokens = "nix show-config | grep access-tokens || echo 'No access tokens configured.'";
    # test-github-api = "curl -H \"Authorization: token $(cat ${
    #   config.sops.secrets."tokens/github/public_repo_scope".path
    # } 2>/dev/null)\" https://api.github.com/user 2>/dev/null | jq '.login // \"Token test failed\"' || echo 'GitHub API test failed.'";
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
        "show-keys")
          echo "Available keys:"
          echo "  Atuin: ${config.sops.secrets."keys/atuin".path}"
          echo "  SSH Ed25519 Public: ${homeDirectory}/.ssh/id_ed25519.pub"
          echo "  SSH Ed25519 Private: ${homeDirectory}/.ssh/id_ed25519"
          ;;
        "show-tokens")
          echo "Available tokens:"
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
          echo "Usage: $0 {edit-common|edit-host|show-passwords|show-tokens|list-home-secrets|list-host-secrets|test-nix-github}"
          echo "  edit-common: Edit the common encrypted secrets file."
          echo "  edit-host: Edit the host-specific encrypted secrets file."
          echo "  show-passwords: List available password secrets."
          echo "  show-keys: List available key secrets."
          echo "  show-tokens: List available token secrets."
          echo "  list-home-secrets: List all home-manager secret files."
          echo "  list-host-secrets: List all host-level secret files."
          echo "  test-nix-github: Test Nix GitHub integration and token access."
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
    (pkgs.writeShellScriptBin "get-atuin-key" ''
      cat ${config.sops.secrets."keys/atuin".path} 2>/dev/null || echo "Atuin key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-ed25519-public-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519.pub 2>/dev/null || echo "SSH Ed25519 public key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-ed25519-private-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519 2>/dev/null || echo "SSH Ed25519 private key not available."
    '')
    (pkgs.writeShellScriptBin "get-github-token" ''
      cat ${config.sops.secrets."tokens/github".path} 2>/dev/null || echo "GitHub token not available."
    '')
    # (pkgs.writeShellScriptBin "get-github-public-repo-token" ''
    #   cat ${
    #     config.sops.secrets."tokens/github/public_repo_scope".path
    #   } 2>/dev/null || echo "GitHub public repo token not available."
    # '')
    (pkgs.writeShellScriptBin "test-nix-github-access" ''
      echo "Testing Nix GitHub access configuration..."
      echo "Current Nix access-tokens configuration:"
      nix show-config | grep access-tokens || echo "No access tokens found in Nix config"
      echo ""
      echo "Testing GitHub API access with token:"
      if token=$(cat ${config.sops.secrets."tokens/github".path} 2>/dev/null); then
        if [ -n "$token" ]; then
          curl -s -H "Authorization: token $token" https://api.github.com/user | jq '.login // "API call succeeded but no login found"' || echo "GitHub API test failed"
        else
          echo "Token is empty"
        fi
      else
        echo "Could not read GitHub token from SOPS"
      fi
    '')
    # (pkgs.writeShellScriptBin "ssh-helper" ''
    #   exec ${builtins.readFile ../scripts/ssh-helper.sh}
    # '')
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

    # Key secret paths
    ATUIN_KEY_FILE = config.sops.secrets."keys/atuin".path;
    SSH_ED25519_PUBLIC_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519.pub";
    SSH_ED25519_PRIVATE_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519";

    # Token secret paths
    GITHUB_TOKEN_FILE = config.sops.secrets."tokens/github".path;

    # Host-level secrets (only keys are available at host level)
    HOST_AGE_KEY_FILE = "/run/secrets/keys/age";
    HOST_GITHUB_PUBLIC_REPO_SCOPE_TOKEN_FILE = "/run/secrets/tokens/github/public_repo_scope";
  };
}
