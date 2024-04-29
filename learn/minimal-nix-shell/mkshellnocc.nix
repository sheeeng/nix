# https://fzakaria.com/2021/08/02/a-minimal-nix-shell.html

let
  nixpkgs = import (builtins.fetchTarball {
    # https://nixos.org/manual/nixos/stable/release-notes#sec-release-23.11
    name = "nixos-stable-2023-11-29";
    # https://github.com/NixOS/nixpkgs/releases/tag/23.11
    url = "https://github.com/nixos/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz";
    sha256 = "1ndiv385w1qyb3b18vw13991fzb9wg4cl21wglk89grsfsnra41k";
  }) { };
in nixpkgs.mkShellNoCC {
  name = "mkshellnocc";
  buildInputs = [ ];
  shellHook = ''
  '';
}
