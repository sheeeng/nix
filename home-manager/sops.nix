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
  hostName = lib.strings.toLower (config.networking.hostName or "UndefinedHostName");
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # This is the location of the host specific age-key and will have been
    # extracted to this location via hosts/core/sops.nix on the host
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${sopsFolder}/common.yaml";
    validateSopsFiles = false;

    # Home-level Secrets
    # stat --format "%A %a %n" ~/.config/sops-nix/secrets/**/*
    secrets = {
      "passwords/atuin" = { };

      "keys/atuin" = { };
      "keys/ssh/id_ed25519/public" = {
        path = "${homeDirectory}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "keys/ssh/id_ed25519/private" = {
        path = "${homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
      "keys/wakatime" = { };

      "tokens/github/user_scope" = { };
    };
  };

  # Ensure .ssh directory exists with proper permissions
  home.file.".ssh/.keep" = {
    text = "";
  };

  home.activation.setupSshDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG ${homeDirectory}/.ssh
    $DRY_RUN_CMD chmod 700 ${homeDirectory}/.ssh
  '';

  home.shellAliases = {
    show-atuin-password = "cat ${
      config.sops.secrets."passwords/atuin".path
    } 2>/dev/null || echo 'Secret not available.'";

    show-atuin-key = "cat ${
      config.sops.secrets."keys/atuin".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-ed25519-ssh-public-key = "cat ${homeDirectory}/.ssh/id_ed25519.pub 2>/dev/null || echo 'Secret not available.'";
    show-ed25519-ssh-private-key = "cat ${homeDirectory}/.ssh/id_ed25519 2>/dev/null || echo 'Secret not available.'";
    show-wakatime-api-key = "cat ${
      config.sops.secrets."keys/wakatime".path
    } 2>/dev/null || echo 'Secret not available.'";

    show-user-scope-github-token = "cat ${
      config.sops.secrets."tokens/github/user_scope".path
    } 2>/dev/null || echo 'Secret not available.'";

    show-public-repo-scope-github-token = "cat /run/secrets/tokens/github/public_repo_scope 2>/dev/null || echo 'Secret not available.'";

    list-home-secrets = "ls --long --all ~/.config/sops-nix/secrets/ 2>/dev/null || echo 'No secrets directory found.'";
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
          echo "  Atuin: ${config.sops.secrets."passwords/atuin".path}"
          ;;
        "show-keys")
          echo "Available keys:"
          echo "  Atuin: ${config.sops.secrets."keys/atuin".path}"
          echo "  SSH Ed25519 Public: ${homeDirectory}/.ssh/id_ed25519.pub"
          echo "  SSH Ed25519 Private: ${homeDirectory}/.ssh/id_ed25519"
          echo "  Wakatime: ${config.sops.secrets."keys/wakatime".path}"
          ;;
        "show-tokens")
          echo "Available tokens:"
          echo "  GitHub User Scope: ${config.sops.secrets."tokens/github/user_scope".path}"
          echo "  GitHub Public Repo Scope: /run/secrets/tokens/github/public_repo_scope"
          ;;
        "list-home-secrets")
          echo "Home-manager secrets directory:"
          ls --long --all ~/.config/sops-nix/secrets/ 2>/dev/null || echo "No secrets directory found."
          ;;
        "list-host-secrets")
          echo "Host-level secrets directory:"
          sudo ls --long --all /run/secrets/ 2>/dev/null || echo "No host secrets directory found or no permission."
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
    (pkgs.writeShellScriptBin "get-atuin-password" ''
      cat ${
        config.sops.secrets."passwords/atuin".path
      } 2>/dev/null || echo "Atuin password not available."
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
    (pkgs.writeShellScriptBin "get-wakatime-api-key" ''
      cat ${
        config.sops.secrets."keys/wakatime".path
      } 2>/dev/null || echo "Wakatime API key not available."
    '')

    (pkgs.writeShellScriptBin "get-user-scope-github-token" ''
      cat ${
        config.sops.secrets."tokens/github/user_scope".path
      } 2>/dev/null || echo "GitHub token not available."
    '')

    (pkgs.writeShellScriptBin "get-public-repo-scope-github-token" ''
      cat /run/secrets/tokens/github/public_repo_scope 2>/dev/null || echo "GitHub token not available."
    '')

    (pkgs.writeShellScriptBin "test-nix-github-access" ''
      echo "Testing Nix GitHub access configuration..."
      echo "Current Nix access-tokens configuration:"
      nix show-config | grep access-tokens || echo "No access tokens found in Nix config"
      echo ""
      echo "Testing GitHub API access with token:"
      if token=$(cat ${config.sops.secrets."tokens/github/user_scope".path} 2>/dev/null); then
        if [ -n "$token" ]; then
          curl -s -H "Authorization: token $token" https://api.github.com/user | jq '.login // "API call succeeded but no login found"' || echo "GitHub API test failed"
        else
          echo "Token is empty"
        fi
      else
        echo "Could not read GitHub token from SOPS"
      fi
    '')
  ];

  home.sessionVariables = {
    ATUIN_PASSWORD_FILE = config.sops.secrets."passwords/atuin".path;

    ATUIN_KEY_FILE = config.sops.secrets."keys/atuin".path;
    SSH_ED25519_PUBLIC_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519.pub";
    SSH_ED25519_PRIVATE_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519";
    WAKATIME_API_KEY_FILE = config.sops.secrets."keys/wakatime".path;

    USER_SCOPE_GITHUB_TOKEN_FILE = config.sops.secrets."tokens/github/user_scope".path;
    PUBLIC_REPO_SCOPE_GITHUB_TOKEN_FILE = "/run/secrets/tokens/github/public_repo_scope";

    HOST_AGE_KEY_FILE = "/run/secrets/keys/age";
    HOST_PUBLIC_REPO_SCOPE_GITHUB_TOKEN_FILE = "/run/secrets/tokens/github/public_repo_scope";
  };
}
