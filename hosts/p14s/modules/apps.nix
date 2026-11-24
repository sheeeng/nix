{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # keep-sorted start block=yes newline_separated=no
    bat
    bottom
    difftastic
    dust
    eza
    fd
    fzf
    git-delta
    helix
    jq
    lazygit
    nushell
    ripgrep
    starship
    tealdeer
    yq
    zoxide
    # keep-sorted end
  ];
}
