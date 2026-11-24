{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # keep-sorted start block=yes newline_separated=no
    gcc
    git
    gnumake
    # keep-sorted end
  ];
}
