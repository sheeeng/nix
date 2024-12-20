# TODO: https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/gpg.nix

{
  config,
  lib,
  pkgs,
  ...
}:
let
in
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
        # uid                 [ultimate] Leonard Lee <leonard.lee@bidbax.no>
        source = ./1F2A97D0690D038B.gpg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.source
        trust = "ultimate"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.trust
      }

      {
        # sec   rsa4096/0CDBE52904CA3543 2023-05-05 [SCEAR]
        #       Key fingerprint = 444E 47CF 8B37 E775 83B2  4F15 0CDB E529 04CA 3543
        # uid                 [ultimate] Leonard Sheng Sheng Lee <leonard.sheng.sheng.lee@gmail.com>
        source = ./0CDBE52904CA3543.gpg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.source
        trust = "ultimate"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.trust
      }

      {
        # sec   rsa4096/C6797A2CF7074F4E 2023-05-05 [SCEAR]
        #       Key fingerprint = 0AE9 626A 398D 1D6D B068  D66B C679 7A2C F707 4F4E
        # uid                 [ultimate] Leonard Sheng Sheng Lee <sheeeng@gmail.com>
        source = ./C6797A2CF7074F4E.gpg; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.source
        trust = "ultimate"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys._.trust
      }
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys

    # TODO: https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/gpg.nix#L57-L59
    scdaemonSettings = {
      disable-ccid = true;
    } // lib.optionalAttrs pkgs.stdenv.isDarwin { reader-port = ''"Yubico YubiKey OTP+FIDO+CCID"''; }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.scdaemonSettings

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

  services.gpg-agent.enable = lib.mkDefault true;
  services.gpg-agent.enableSshSupport = lib.mkDefault true;
  services.gpg-agent.enableExtraSocket = lib.mkDefault true;
}
