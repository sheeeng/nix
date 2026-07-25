# Host-level SOPS configuration for macOS with nix-darwin.
# For NixOS, see hosts/linux/sops.nix instead.

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
        access-tokens = github.com=${config.sops.placeholder."tokens/github/repo_scope"}
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
        "tokens/github/repo_scope" = {
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

  # Activation scripts to ensure proper directory structure and permissions.
  system.activationScripts = {
    # Create the host-level age key directory at /etc/sops/age/.
    # This stores the age key derived from the host SSH key.
    sopsCreateSystemAgeDirectory = ''
      mkdir --parents /etc/sops/age || true
      chmod 755 /etc/sops
      chmod 700 /etc/sops/age
    '';

    # Create the user-level age key directory at ~/.config/sops/age/.
    # This stores the user age key extracted from host-level secrets.
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

    # NOTE: Kept for reference. This activation script used to add the
    # `!include` directive to /etc/nix/nix.conf and inject the GitHub access
    # token into /etc/nix/nix.custom.conf. Under the Determinate nix-darwin
    # module this file is now MANAGED by Determinate (generated from
    # `determinateNix.customSettings`, and its /etc/nix/nix.conf already does
    # `!include nix.custom.conf`). Rewriting it from here makes nix-darwin
    # abort the next switch with "Unexpected files in /etc". The token is now
    # supplied through `determinateNix.customSettings.access-tokens` below.
    #
    # postActivation.text = lib.mkAfter ''
    #   # Ensure /etc/nix/nix.conf includes /etc/nix/nix.custom.conf.
    #   # Lix and non-Determinate installers do not add this directive,
    #   # so the custom configuration file is never read by the daemon.
    #   if [[ -f /etc/nix/nix.conf ]] && ! grep --quiet --fixed-strings '!include /etc/nix/nix.custom.conf' /etc/nix/nix.conf; then
    #     echo "" >> /etc/nix/nix.conf
    #     echo "!include /etc/nix/nix.custom.conf" >> /etc/nix/nix.conf
    #     echo ":: ✓ Added !include directive for nix.custom.conf to /etc/nix/nix.conf file."
    #   fi
    #
    #   # Configure GitHub access tokens for Nix.
    #   # Since nix.enable is false, nix.extraOptions will not write to /etc/nix/nix.conf.
    #   # Nix reads /etc/nix/nix.custom.conf for user modifications.
    #   echo ":: ♻ Configuring GitHub access tokens for Nix..."
    #
    #   TOKEN_FILE="${config.sops.templates.nix-access-token.path}"
    #
    #   if [[ -r "$TOKEN_FILE" ]]; then
    #     # Remove any existing access-token lines to avoid duplicates.
    #     if [[ -f /etc/nix/nix.custom.conf ]]; then
    #       grep --invert-match --extended-regexp '^(access-tokens|!include.*nix-access-token)' /etc/nix/nix.custom.conf > /tmp/nix.custom.conf.tmp || true
    #     else
    #       echo "# Custom Nix configuration managed by nix-darwin activation." > /tmp/nix.custom.conf.tmp
    #       echo "" >> /tmp/nix.custom.conf.tmp
    #     fi
    #
    #     echo "!include $TOKEN_FILE" >> /tmp/nix.custom.conf.tmp
    #     mv /tmp/nix.custom.conf.tmp /etc/nix/nix.custom.conf
    #     chmod 644 /etc/nix/nix.custom.conf
    #
    #     echo ":: ✓ GitHub access token configured in /etc/nix/nix.custom.conf file."
    #   else
    #     echo ":: ⚠ Warning: Access token file not found at $TOKEN_FILE."
    #     echo "::   This is expected on first activation. The token will be available after sops-nix processes secrets."
    #   fi
    # '';
  };

  # GitHub access token for the Nix daemon (macOS / Determinate only).
  #
  # Determinate's nix-darwin module owns /etc/nix/nix.custom.conf: it is
  # generated from `determinateNix.customSettings`, and Determinate's own
  # /etc/nix/nix.conf already does `!include nix.custom.conf`. We therefore
  # must NOT rewrite that file from an activation script, or nix-darwin
  # aborts the next switch with "Unexpected files in /etc".
  #
  # The token is a secret, so it must stay out of the world-readable Nix
  # store. sops-nix renders it to `config.sops.templates.nix-access-token`
  # at activation time; we pull it in with `!include`. Determinate's
  # settings serializer only emits `key = value` lines, so the bare
  # `!include` rides along as a trailing line on the `access-tokens` value.
  # The empty base value is harmless and is overridden by the included file.
  determinateNix.customSettings.access-tokens = "\n!include ${config.sops.templates.nix-access-token.path}";
}
