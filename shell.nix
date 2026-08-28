# Shell for bootstrapping flake-enabled nix and other tooling
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  pkgs ? import <nixpkgs> { },
  ...
}:

{
  standard-shell = pkgs.mkShell {
    name = "standard-shell";

    # # if you set use-xdg-base-directories = true in your /etc/nix/nix.conf,
    # # all the "classic" Nix tools (nix-env, nix-channel, ...)
    # # and nix profile will use ~/.local/state/nix instead of dotfiles in your ~.
    # # https://github.com/NixOS/nix/issues/1079#issuecomment-1426124503
    # # Set use-xdg-base-directories = true in your /etc/nix/nix.conf, and then nix-channel will use ~/.local/state/nix/channels.
    # # https://github.com/NixOS/nix/issues/1079#issuecomment-1632043144
    # NIX_CONFIG = "use-xdg-base-directories = true\nextra-experimental-features = nix-command flakes";

    nativeBuildInputs =
      (with pkgs; [

        deadnix # https://search.nixos.org/packages?channel=unstable&type=packages&show=deadnix
        nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
        nix-inspect # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-inspect
        nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
        nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
        statix # https://search.nixos.org/packages?channel=unstable&type=packages&show=statix
        terraform # https://releases.hashicorp.com/terraform

        gnupg # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnupg
        openssh # https://search.nixos.org/packages?channel=unstable&type=packages&show=openssh
        vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
        sops # https://search.nixos.org/packages?channel=unstable&type=packages&show=sops
        ssh-to-age # https://search.nixos.org/packages?channel=unstable&type=packages&show=ssh-to-age
        age-plugin-fido2-hmac # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-fido2-hmac
        age-plugin-yubikey # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-yubikey
        age-plugin-tpm # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-tpm
        age-plugin-ledger # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-ledger

        gitFull # https://search.nixos.org/packages?channel=unstable&type=packages&show=gitFull
        git-extras # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-extras
        tig # https://search.nixos.org/packages?channel=unstable&type=packages&show=tig
        just # https://search.nixos.org/packages?channel=unstable&type=packages&show=just
        git-credential-oauth # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-credential-oauth
        git-crypt # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-crypt

        pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
        pre-commit-hook-ensure-sops # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit-hook-ensure-sops

        cabal-install # https://search.nixos.org/packages?channel=unstable&type=packages&show=cabal-install
        ghc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ghc
        gmp # https://search.nixos.org/packages?channel=unstable&type=packages&show=gmp
      ])
      ++ [
        (pkgs.python313.withPackages (
          ps: with ps; [
            ruamel-yaml # https://search.nixos.org/packages?channel=unstable&type=packages&show=python313Packages.ruamel-yaml
          ]
        ))
      ];

    shellHook = "";
  };

  minimal-shell = pkgs.mkShell {
    name = "minimal-shell";

    buildInputs = with pkgs; [
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      (lib.hiPrio uutils-coreutils-noprefix) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
      cabal-install # https://search.nixos.org/packages?channel=unstable&type=packages&show=cabal-install
      ghc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ghc
      git # https://search.nixos.org/packages?channel=unstable&type=packages&show=git
      gmp # https://search.nixos.org/packages?channel=unstable&type=packages&show=gmp
      gnupg # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnupg
      nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
      nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
      pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
      vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
      # keep-sorted end
    ];

    shellHook = ''
      # Prioritize uutils-coreutils by prepending to $PATH environment variable.
      export PATH="${pkgs.uutils-coreutils-noprefix}/bin:$PATH"

      echo ""
      echo "🚀 Shell loaded!"
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
