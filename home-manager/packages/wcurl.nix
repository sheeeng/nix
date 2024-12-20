# TODO: https://github.com/NixOS/nixpkgs/pull/325779/files

{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  my-wcurl =
    pkgs.runCommandLocal "wcurl"
      {
        script = "${inputs.wcurl}/wcurl";
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        makeWrapper $script $out/bin/my-wcurl \
          --prefix PATH : ${lib.makeBinPath (with pkgs; [ curl ])}
      '';
in
{
  home.packages = [ my-wcurl ];
}
