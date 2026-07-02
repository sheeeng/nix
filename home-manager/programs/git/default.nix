{ ... }:
let
  directoryEntries = builtins.readDir ./.;
  nixFiles = builtins.filter (
    fileName:
    fileName != "default.nix"
    && directoryEntries.${fileName} == "regular"
    && builtins.match ".*\\.nix" fileName != null
  ) (builtins.attrNames directoryEntries);
in
{
  imports = builtins.map (fileName: ./. + "/${fileName}") nixFiles;
}
