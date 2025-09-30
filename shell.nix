# Shell for bootstrapping flake-enabled nix and other tooling
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  pkgs ? import <nixpkgs> { },
  ...
}:

{
  pre-commit = pkgs.mkShell {
    name = "pre-commit-shell";

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

      cabal
      ghc
    ];

    shellHook = ''
      echo ""
      echo "🚀 pre-commit shell loaded!"
      echo ""
      export EDITOR=vim
    '';
  };

  minimal = pkgs.mkShell {
    name = "minimal-shell";

    buildInputs = with pkgs; [
      # keep-sorted start
      (lib.hiPrio uutils-coreutils-noprefix) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
      git # https://search.nixos.org/packages?channel=unstable&type=packages&show=git
      gnupg # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnupg
      nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
      nixfmt-rfc-style # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-rfc-style
      pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
      vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
      # keep-sorted end
    ];

    shellHook = ''
      # Prioritize uutils-coreutils by prepending to $PATH environment variable.
      export PATH="${pkgs.uutils-coreutils-noprefix}/bin:$PATH"

      echo ""
      echo "🚀 minimal shell loaded!"
      echo ""

      # Set up environment variables if we're in GitHub Actions.
      if [ -n "''${GITHUB_ACTIONS}" ]; then
        echo "🔧 GitHub Actions detected. Setting up CI environment."
        export CI=true
      fi
    '';

    EDITOR = "vim";
    PRE_COMMIT_COLOR = "always";
  };
}
