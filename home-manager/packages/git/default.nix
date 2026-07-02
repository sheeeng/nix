# TODO: https://github.com/kpritam/nixpkgs/blob/dbc2a1538b2c6dfd1d11fb97c08203643c723ff0/home/git.nix

{
  inputs,
  pkgs,
  ...
}:
let

  # https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/git/default.nix#L6-L12
  git-credential-oauth-wrapper = pkgs.writeShellScriptBin "git-credential-oauth-wrapper" ''
    if [ -n "$REMOTE" ] || [ -n "$SSH_CLIENT" ]; then
      exec ${pkgs.git-credential-oauth}/bin/git-credential-oauth -device "$@"
    else
      exec ${pkgs.git-credential-oauth}/bin/git-credential-oauth "$@"
    fi
  '';

  myselfName = "sheeeng";
  secrets = inputs.nix-secrets.${myselfName};
in
{
  # https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/git/default.nix#L14
  home.packages = with pkgs; [
    # keep-sorted start
    codeberg-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=codeberg-cli
    ghq # https://search.nixos.org/packages?channel=unstable&type=packages&show=ghq
    git-credential-oauth-wrapper # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-credential-oauth
    git-filter-repo # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-filter-repo
    git-lfs # https://search.nixos.org/packages?channel=unstable&type=packages&show=git-lfs
    gitleaks # https://search.nixos.org/packages?channel=unstable&type=packages&show=gitleaks
    glab # https://search.nixos.org/packages?channel=unstable&type=packages&show=glab
    hut # https://search.nixos.org/packages?channel=unstable&type=packages&show=hut
    pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
    tea # https://search.nixos.org/packages?channel=unstable&type=packages&show=tea
    # keep-sorted end
  ];

  # https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/git/default.nix#L19
  home.sessionVariables = {
    # GIT_EDITOR = "${pkgs.neovim}/bin/nvim"; # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  };

  # home.file."bitbucket/.gitconfig".source = ./gitconfig-private.ini;
  home.file."bitbucket/.gitconfig" = {
    text = ''
      [user]
        email = ${secrets.email.private or "unknown.user@undefined.domain"}
        gitHub = ${secrets.email.gitHub or "unknown.user@undefined.domain"}
        gitLab = ${secrets.email.gitLab or "unknown.user@undefined.domain"}
        name = ${secrets.userPreferredName or "Unknown User"}
        personal = ${secrets.email.personal or "unknown.user@undefined.domain"}
        private = ${secrets.email.private or "unknown.user@undefined.domain"}
      [credential]
        helper = oauth
      [init]
        defaultBranch = main
    '';
  };
  home.file."bitbucket/sheeeng/.gitconfig".source = ./gitconfig-private.ini;
  home.file."codeberg/.gitconfig".source = ./gitconfig-private.ini;
  home.file."dottir/.gitconfig".source = ./gitconfig-private.ini;
  home.file."github/.gitconfig".source = ./gitconfig-github-noreply.ini;
  home.file."github/sheeeng/.gitconfig".source = ./gitconfig-github-noreply.ini;
  home.file."github/github/.gitconfig" = {
    text = ''
      [user]
        name = ${inputs.nix-secrets-example.octocat.userFullName or "Octocat"}
        email = ${
          inputs.nix-secrets-example.octocat.email.work or "583231+octocat@users.noreply.github.com"
        }
        useConfigOnly = true
      [commit]
        gpgsign = ${inputs.nix-secrets-example.octocat.gpgsign or "false"}
    '';
  };
  home.file."github/techcloud0-actions/.gitconfig".source = ./gitconfig-github-techcloud0.ini;
  home.file."github/techcloud0/.gitconfig".source = ./gitconfig-github-techcloud0.ini;
  home.file."gitlab/.gitconfig".source = ./gitconfig-gitlab.ini;
  home.file."srht/.gitconfig".source = ./gitconfig-private.ini;
  home.file."gitea/.gitconfig".source = ./gitconfig-private.ini;

  # Disable ssh-agent on Linux; GNOME Keyring's gcr-ssh-agent handles SSH keys.
  # gpg-agent handles GPG operations only.
  services.ssh-agent.enable = false;
}
