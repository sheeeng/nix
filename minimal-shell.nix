# Minimal shell for quick development
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "nix-dev-minimal";

  buildInputs = with pkgs; [
    # keep-sorted start
    (lib.hiPrio uutils-coreutils-noprefix) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
    git # https://search.nixos.org/packages?channel=unstable&type=packages&show=git
    gnupg # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnupg
    nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
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
}
