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
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age = {
      sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
      keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    };
    defaultSopsFile = "${sopsFolder}/common.yaml";
    validateSopsFiles = true;

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
      "keys/ssh/id_ed25519_corporate/public" = {
        path = "${homeDirectory}/.ssh/id_ed25519_corporate.pub";
        mode = "0644";
      };
      "keys/ssh/id_ed25519_corporate/private" = {
        path = "${homeDirectory}/.ssh/id_ed25519_corporate";
        mode = "0600";
      };
      "keys/ssh/id_ed25519_individual/public" = {
        path = "${homeDirectory}/.ssh/id_ed25519_individual.pub";
        mode = "0644";
      };
      "keys/ssh/id_ed25519_individual/private" = {
        path = "${homeDirectory}/.ssh/id_ed25519_individual";
        mode = "0600";
      };
      "keys/ssh/id_ed25519_personal/public" = {
        path = "${homeDirectory}/.ssh/id_ed25519_personal.pub";
        mode = "0644";
      };
      "keys/ssh/id_ed25519_personal/private" = {
        path = "${homeDirectory}/.ssh/id_ed25519_personal";
        mode = "0600";
      };
      "keys/wakatime" = { };

      "tokens/github/gist_scope" = { };
      "tokens/github/public_repo_scope" = { };
      "tokens/github/user_scope" = { };
    };
  };

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
    show-ssh-corporate-public = "cat ${homeDirectory}/.ssh/id_ed25519_corporate.pub 2>/dev/null || echo 'Secret not available.'";
    show-ssh-corporate-private = "cat ${homeDirectory}/.ssh/id_ed25519_corporate 2>/dev/null || echo 'Secret not available.'";
    show-ssh-individual-public = "cat ${homeDirectory}/.ssh/id_ed25519_individual.pub 2>/dev/null || echo 'Secret not available.'";
    show-ssh-individual-private = "cat ${homeDirectory}/.ssh/id_ed25519_individual 2>/dev/null || echo 'Secret not available.'";
    show-ssh-personal-public = "cat ${homeDirectory}/.ssh/id_ed25519_personal.pub 2>/dev/null || echo 'Secret not available.'";
    show-ssh-personal-private = "cat ${homeDirectory}/.ssh/id_ed25519_personal 2>/dev/null || echo 'Secret not available.'";
    show-wakatime-api-key = "cat ${
      config.sops.secrets."keys/wakatime".path
    } 2>/dev/null || echo 'Secret not available.'";

    show-gist-scope-github-token = "cat ${
      config.sops.secrets."tokens/github/gist_scope".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-public-repo-scope-github-token = "cat ${
      config.sops.secrets."tokens/github/public_repo_scope".path
    } 2>/dev/null || echo 'Secret not available.'";
    show-user-scope-github-token = "cat ${
      config.sops.secrets."tokens/github/user_scope".path
    } 2>/dev/null || echo 'Secret not available.'";

    list-home-secrets = "ls --long --all ~/.config/sops-nix/secrets/ 2>/dev/null || echo 'No secrets directory found.'";
  };

  home.file.".local/bin/sops-helper" = {
    text = ''
      #!/usr/bin/env bash

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
          echo "  SSH Corporate Public: ${homeDirectory}/.ssh/id_ed25519_corporate.pub"
          echo "  SSH Corporate Private: ${homeDirectory}/.ssh/id_ed25519_corporate"
          echo "  SSH Individual Public: ${homeDirectory}/.ssh/id_ed25519_individual.pub"
          echo "  SSH Individual Private: ${homeDirectory}/.ssh/id_ed25519_individual"
          echo "  SSH Personal Public: ${homeDirectory}/.ssh/id_ed25519_personal.pub"
          echo "  SSH Personal Private: ${homeDirectory}/.ssh/id_ed25519_personal"
          echo "  Wakatime: ${config.sops.secrets."keys/wakatime".path}"
          ;;
        "show-tokens")
          echo "Available tokens:"
          echo "  GitHub Gist Scope: ${config.sops.secrets."tokens/github/gist_scope".path}"
          echo "  GitHub Public Repo Scope: ${config.sops.secrets."tokens/github/public_repo_scope".path}"
          echo "  GitHub User Scope: ${config.sops.secrets."tokens/github/user_scope".path}"
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
    (pkgs.writeShellScriptBin "get-ssh-corporate-public-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519_corporate.pub 2>/dev/null || echo "SSH corporate public key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-corporate-private-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519_corporate 2>/dev/null || echo "SSH corporate private key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-individual-public-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519_individual.pub 2>/dev/null || echo "SSH individual public key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-individual-private-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519_individual 2>/dev/null || echo "SSH individual private key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-personal-public-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519_personal.pub 2>/dev/null || echo "SSH personal public key not available."
    '')
    (pkgs.writeShellScriptBin "get-ssh-personal-private-key" ''
      cat ${homeDirectory}/.ssh/id_ed25519_personal 2>/dev/null || echo "SSH personal private key not available."
    '')
    (pkgs.writeShellScriptBin "get-wakatime-api-key" ''
      cat ${
        config.sops.secrets."keys/wakatime".path
      } 2>/dev/null || echo "Wakatime API key not available."
    '')

    (pkgs.writeShellScriptBin "get-gist-scope-github-token" ''
      cat ${
        config.sops.secrets."tokens/github/gist_scope".path
      } 2>/dev/null || echo "GitHub gist token not available."
    '')
    (pkgs.writeShellScriptBin "get-public-repo-scope-github-token" ''
      cat ${
        config.sops.secrets."tokens/github/public_repo_scope".path
      } 2>/dev/null || echo "GitHub public repo token not available."
    '')
    (pkgs.writeShellScriptBin "get-user-scope-github-token" ''
      cat ${
        config.sops.secrets."tokens/github/user_scope".path
      } 2>/dev/null || echo "GitHub user token not available."
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
    SSH_CORPORATE_PUBLIC_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519_corporate.pub";
    SSH_CORPORATE_PRIVATE_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519_corporate";
    SSH_INDIVIDUAL_PUBLIC_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519_individual.pub";
    SSH_INDIVIDUAL_PRIVATE_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519_individual";
    SSH_PERSONAL_PUBLIC_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519_personal.pub";
    SSH_PERSONAL_PRIVATE_KEY_FILE = "${homeDirectory}/.ssh/id_ed25519_personal";
    WAKATIME_API_KEY_FILE = config.sops.secrets."keys/wakatime".path;

    GIST_SCOPE_GITHUB_TOKEN_FILE = config.sops.secrets."tokens/github/gist_scope".path;
    PUBLIC_REPO_SCOPE_GITHUB_TOKEN_FILE = config.sops.secrets."tokens/github/public_repo_scope".path;
    USER_SCOPE_GITHUB_TOKEN_FILE = config.sops.secrets."tokens/github/user_scope".path;

    HOST_AGE_KEY_FILE = "/run/secrets/keys/age";
  };
}
