# https://github.com/EmergentMind/nix-config/blob/f9168993316e8ff99381ff5dd3c7398273439618/shell.nix
# https://github.com/NovaViper/NixConfig/blob/2337db1a332b9aeb1e8fb850f77c14ac91367a32/shell.nix
# Shell for bootstrapping flake-enabled nix and other tooling
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  pkgs ?
    # If pkgs is not defined, instantiate nixpkgs from locked commit
    let
      lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
      nixpkgs = fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { },
  checks,
  ...
}:
let
  checks-lib = checks.${pkgs.system};
in
{
  default = pkgs.mkShell {
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
    buildInputs = checks-lib.pre-commit-check.enabledPackages;
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
      sops # This one is from the overlay
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
      ${checks-lib.pre-commit-check.shellHook}
        export EDITOR=vim
    '';
  };
}
