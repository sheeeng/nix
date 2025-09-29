# Shell for bootstrapping flake-enabled nix and other tooling
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  pkgs ? import <nixpkgs> { },
  ...
}:

{
  default = pkgs.mkShell {
    name = "nix-dev-shell";

    FLAKE = ".";
    NH_FLAKE = ".";

    # if you set use-xdg-base-directories = true in your /etc/nix/nix.conf,
    # all the "classic" Nix tools (nix-env, nix-channel, ...)
    # and nix profile will use ~/.local/state/nix instead of dotfiles in your ~.
    # https://github.com/NixOS/nix/issues/1079#issuecomment-1426124503
    # Set use-xdg-base-directories = true in your /etc/nix/nix.conf, and then nix-channel will use ~/.local/state/nix/channels.
    # https://github.com/NixOS/nix/issues/1079#issuecomment-1632043144
    NIX_CONFIG = "use-xdg-base-directories = true\nextra-experimental-features = nix-command flakes";

    PKCS = "${pkgs.opensc}/lib/opensc-pkcs11.so";

    nativeBuildInputs = with pkgs; [
      # Nix toolkit
      nix
      nix-output-monitor
      nix-inspect
      deadnix
      statix
      home-manager

      # Encryption tools/Secrets bootstrapping
      gnupg
      openssh
      vim # Needed for age/sops
      sops
      ssh-to-age
      age-plugin-fido2-hmac
      age-plugin-yubikey
      age-plugin-tpm
      age-plugin-ledger

      # Git setup
      gitFull
      git-extras
      tig
      just
      git-credential-oauth
      git-crypt
      pre-commit
    ];

    shellHook = ''
      echo "Development shell loaded!"
      export EDITOR=vim
    '';
  };
}
