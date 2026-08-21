# TODO: https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/gpg.nix

{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.gpg = {
    enable = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.enable
    package = pkgs.gnupg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.package
    homedir = "${config.home.homeDirectory}/.gnupg"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.homedir
    mutableKeys = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.mutableKeys
    mutableTrust = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.mutableTrust
    publicKeys = [
      {
        # sec   rsa4096/1F2A97D0690D038B 2024-02-01 [SCEAR]
        #       Key fingerprint = 5556 F727 77F5 2A06 F581  0596 1F2A 97D0 690D 038B
        source = ./1F2A97D0690D038B.gpg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.source
        trust = "ultimate"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.trust
      }

      {
        # sec   rsa4096/0CDBE52904CA3543 2023-05-05 [SCEAR]
        #       Key fingerprint = 444E 47CF 8B37 E775 83B2  4F15 0CDB E529 04CA 3543
        source = ./0CDBE52904CA3543.gpg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.source
        trust = "ultimate"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.trust
      }

      {
        # sec   rsa4096/C6797A2CF7074F4E 2023-05-05 [SCEAR]
        #       Key fingerprint = 0AE9 626A 398D 1D6D B068  D66B C679 7A2C F707 4F4E
        source = ./C6797A2CF7074F4E.gpg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.source
        trust = "ultimate"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.trust
      }
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys

    # TODO: https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/gpg.nix#L57-L59
    scdaemonSettings = {
      disable-ccid = true;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin { reader-port = ''"Yubico YubiKey OTP+FIDO+CCID"''; }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.scdaemonSettings

    # TODO: https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/gpg.nix
    #   programs.gpg.settings = {
    #   } // lib.optionalAttrs (!builtins.isNull user-info.gpg.masterKey) {

    settings = {
      # https://www.gnupg.org/documentation/manuals/gnupg/Compliance-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/Deprecated-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Input-and-Output.html
      # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html

      # ╭───────────────────────────╮
      # │ GPG-Configuration-Options │
      # ╰───────────────────────────╯

      auto-key-locate = "local,wkd,keyserver"; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-auto_002dkey_002dlocate
      display-charset = "utf-8"; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-display_002dcharset
      expert = true; # https://gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-expert
      keyid-format = "0xlong"; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-keyid_002dformat
      require-cross-certification = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-require_002dcross_002dcertification
      require-secmem = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-require_002dsecmem
      no-greeting = true; # https://gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-no_002dgreeting
      no-random-seed-file = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-no_002drandom_002dseed_002dfile
      use-agent = true; # https://gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-use_002dagent
      utf8-strings = true; # https://gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html#index-utf8_002dstrings

      # ╭──────────────────────╮
      # │ GPG-Esoteric-Options │
      # ╰──────────────────────╯

      cert-digest-algo = "SHA512"; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html#index-cert_002ddigest_002dalgo
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 Uncompressed"; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html#index-default_002dpreference_002dlist
      no-comments = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html#index-comment
      no-emit-version = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html#index-emit_002dversion

      # ╭──────────────────────╮
      # │ GPG-Input-and-Output │
      # ╰──────────────────────╯

      with-fingerprint = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Input-and-Output.html#index-with_002dfingerprint
      with-subkey-fingerprints = true; # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Input-and-Output.html#index-with_002dsubkey_002dfingerprint

      # ╭─────────────────╮
      # │ OpenGPG-Options │
      # ╰─────────────────╯

      personal-cipher-preferences = "AES256 AES192 AES CAST5"; # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html#index-personal_002dcipher_002dpreferences
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed"; # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html#index-personal_002dcompress_002dpreferences
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224"; # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html#index-personal_002ddigest_002dpreferences
      s2k-cipher-algo = "AES256"; # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html#index-s2k_002dcipher_002dalgo
      s2k-digest-algo = "SHA512"; # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html#index-s2k_002ddigest_002dalgo
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.settings
  };

  services.gpg-agent = {
    enable = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enable
    enableBashIntegration = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableBashIntegration
    enableExtraSocket = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableExtraSocket
    enableFishIntegration = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableFishIntegration
    enableNushellIntegration = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableNushellIntegration
    enableScDaemon = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableScDaemon
    enableSshSupport = lib.mkDefault (!pkgs.stdenv.isDarwin); # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableSshSupport
    enableZshIntegration = lib.mkDefault true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enableZshIntegration
    defaultCacheTtl = 28800; # 8 hours - https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.defaultCacheTtl
    defaultCacheTtlSsh = 28800; # 8 hours - https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.defaultCacheTtlSsh
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.extraConfig
    grabKeyboardAndMouse = lib.mkDefault false; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.grabKeyboardAndMouse
    maxCacheTtl = 86400; # 24 hours - https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.maxCacheTtl
    maxCacheTtlSsh = 86400; # 24 hours - https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.maxCacheTtlSsh
    noAllowExternalCache = lib.mkDefault false; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.noAllowExternalCache
    pinentry = {
      package = lib.mkIf pkgs.stdenv.isLinux (
        pkgs.writeShellScriptBin "pinentry" ''
          if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
            exec ${pkgs.pinentry-gnome3}/bin/pinentry "$@"
          else
            exec ${pkgs.pinentry-curses}/bin/pinentry "$@"
          fi
        ''
      ); # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.pinentry.package
      # programs = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.pinentry.programs
    };
    sshKeys = [
      "09048FC32D93C2AA3AB8BEB4B22A77DD1889822C" # rsa4096/0x174CED9ACADEACF4 [SEA]
      "FF3B68875CB838FA156153C9C90553D1B79B744F" # rsa4096/0xDBCABCB535F08E4C [SEAR]
      "7502D01ABFAB2F88772FFC454938191A7A1F0C4C" # rsa4096/0xD8900279F772DD27 [SEAR]
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.sshKeys
    verbose = lib.mkDefault false; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.verbose
  };

  # Disable keyboxd on Linux. The keyboxd daemon introduced in GnuPG version 2.4
  # deadlocks on its own database under this configuration, so signing fails
  # intermittently with "keydb_search failed: Connection timed out", even within
  # a single session and after a reboot. An empty common.conf keeps the
  # use-keyboxd option absent, so GnuPG reads the classic pubring.kbx keybox
  # directly and no lock daemon can hang. The existing public keys were migrated
  # from the keyboxd database with "gpg --export" followed by "gpg --import".
  home.file.".gnupg/common.conf" = lib.mkIf pkgs.stdenv.isLinux {
    text = "";
  };

  # The gpg-agent daemon is killed with SIGKILL on shutdown, so it leaves dotlock
  # files behind under the GnuPG home directory, namely the files that match
  # ".#lk*" and "*.lock". Because the home directory is persistent, those files
  # survive the reboot. GnuPG breaks a stale lock only when the process
  # identifier recorded in the lock file is dead. After a reboot, however, that
  # process identifier is usually recycled to a live and unrelated process, so
  # GnuPG assumes the lock is still held and waits on it forever. Remove any
  # leftover lock files at session start, before any GnuPG daemon runs, so that
  # signing works reliably after every reboot.
  systemd.user.services.gpg-clean-stale-locks = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Remove stale GnuPG lock files left by an unclean shutdown.";
      Before = [
        "gpg-agent.service"
        "gpg-agent.socket"
        "keyboxd.socket"
      ];
    };
    Service = {
      Type = "oneshot";
      # Clean only when no GnuPG daemon is running, that is, genuinely at session
      # start, so that an activation restart during a session can never delete a
      # live lock.
      ExecStart = pkgs.writeShellScript "gpg-clean-stale-locks" ''
        if ${pkgs.procps}/bin/pgrep --exact keyboxd >/dev/null \
          || ${pkgs.procps}/bin/pgrep --exact gpg-agent >/dev/null; then
          echo "The GnuPG daemons are already running. Leaving lock files untouched."
          exit 0
        fi
        ${pkgs.findutils}/bin/find "${config.home.homeDirectory}/.gnupg" \
          -type f \( -name '.#lk*' -o -name '*.lock' \) -print -delete 2>/dev/null || true
      '';
    };
    Install.WantedBy = [ "default.target" ];
  };
}
